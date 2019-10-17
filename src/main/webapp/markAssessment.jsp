<%-- 
    Document   : Marks the assessment
    Created on : 16 Aug 2018, 10:42:11 PM
    Author     : Zach
--%>

<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Base64.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="./css/markAssessment.css" rel="stylesheet" type="text/css">
        <title>
            Marking Assessment...
        </title>
    </head>
    <body>
        <div class="loader">
        </div>
        <%
            //fetches parameters
            ArrayList<Question> qus = new ArrayList<Question>();
            String s = request.getParameter("set");
            String database = request.getParameter("db");
            String qs = request.getParameter("qs");
            String u = request.getParameter("u");
            String a = request.getParameter("a");
            String at = request.getParameter("attempt");

            //decodes the strings
            Decoder decoder = Base64.getDecoder();
            byte[] q = decoder.decode(s);
            byte quest[] = decoder.decode(qs);
            byte db[] = decoder.decode(database);
            byte ass[] = decoder.decode(a);
            byte us[] = decoder.decode(u);
            byte att[] = decoder.decode(at);
            String decodedString = new String(q);
            String questions = new String(quest);
            String dbName = new String(db);
            String user = new String(us);
            String assessment = new String(ass);
            String attempt = new String(att);
        %>
        <%--sets invisible variables--%>
        <p hidden id="assessment"><%=assessment%></p>
        <p hidden id="user"><%=user%></p>
        <p hidden id="dbName"><%=dbName%></p>
        <%
            
            //splits the array of answers on ","
            String ans[] = decodedString.split("\",\"");
            if (ans[0].startsWith("\""))
            {
                ans[0] = ans[0].substring(1);
                
            }
            if (ans[ans.length - 1].contains("\""))
            {
                ans[ans.length - 1] = ans[ans.length - 1].substring(0, ans[ans.length - 1].length() - 1);
            }

            //splits questions on white space
            String z[] = questions.split(" ");

            ArrayList<Integer> x = new ArrayList<Integer>();
            //adds all question numbers from array z
            for (int i = 0; i < z.length; i++)
            {
                x.add(new Integer(z[i]));
            }

            //initiates connection with the MySQL database
            Connection connection = new SQL().getConnection();
            Statement statement = connection.createStatement();

            //use the table of the databse in the assessment
            statement.addBatch("use `" + dbName + "`;");
            statement.executeBatch();

            //fetches all questions
            ResultSet qrs = statement.executeQuery("SELECT * FROM questions;");

            //traverse through the result set
            while (qrs.next())
            {
                // fetches parameters
                int questionNumber = Integer.parseInt(qrs.getString("questionNumber"));
                String question = qrs.getString("question");
                String expectedAnswer = qrs.getString("expectedAnswer");
                String category = qrs.getString("category");
                int marks = Integer.parseInt(qrs.getString("marks"));

                //creates new question and adds it to the list
                Question qu = new Question(questionNumber, question, expectedAnswer, category, marks);
                qus.add(qu);
            }

            ArrayList<String> expected = new ArrayList<String>();
            ArrayList<String> given = new ArrayList<String>();
            ArrayList<Integer> marks = new ArrayList<Integer>();
            ArrayList<String> cat = new ArrayList<String>();

            for (int i = 0; i < ans.length; i++)
            {
                ans[i] = ans[i].replace("&gt", ">");
                ans[i] = ans[i].replace("&lt", "<");
                ans[i] = ans[i].replace("\\(", "(");
                ans[i] = ans[i].replace("\\)", ")");
                ans[i] = ans[i].replace("\\'", "'");
                given.add(ans[i]);
            }
            for (Integer number : x)
            {
                //adds elements to list
                expected.add(qus.get(number - 1).getExpectedAnswer() + "");
                marks.add(qus.get(number - 1).getMarks());
                cat.add(qus.get(number - 1).getCategory());
            }

            //creates array to store student's marks
            ArrayList<Integer> studentMarks = new ArrayList<Integer>();
            for (int i = 0; i < ans.length; i++)
            {
                //marks the question and adds it to the mark's list
                MarkQuestion m = new MarkQuestion(expected.get(i), given.get(i), marks.get(i), dbName, cat.get(i), connection);
                studentMarks.add(m.markQuestion());
            }

            String name = user + "-" + assessment;
            statement.addBatch("use `sqlautomarker-individual-records`;");
            statement.executeBatch();

            int count = 0;

            //creates statement to update user table with the user's answer
            for (Integer elem : x)
            {

                String give = given.get(count);
                give = give.replace("'", "\'");
                give = give.replace("\"", "\\\"");
             
                String n = "UPDATE `" + name + "` SET `studentAnswer` = \"" + give + "\", `studentMarks` = '" + studentMarks.get(count) + "' WHERE (`questionReference` = '" + elem + "');";

                statement.addBatch(n);
                count++;
            }

            //updates user marks
            int totMarks = 0;
            for (Integer elem : studentMarks)
            {
                totMarks += elem.intValue();
            }

            //inserts the mark into the individual user's database
            statement.addBatch("INSERT INTO `" + name + "` (`totalMarks`) VALUES ('" + totMarks + "');");
            statement.executeBatch();

            statement.addBatch("use `marks`;");
            statement.executeBatch();

            String m = "SELECT attemptsLeft, marks FROM `" + assessment + "` WHERE studentNumber = '" + user + "';";
            ResultSet r = statement.executeQuery(m);
            r.next();
            int attemptsLeft = Integer.parseInt(r.getString("attemptsLeft"));
            int prevMarks = Integer.parseInt(r.getString("marks"));

            //decrements marks left
            if (attemptsLeft != 0)
            {
                attemptsLeft--;
            }
            else
            {
                attemptsLeft = 0;
            }

            //updates mark table
            String up = "UPDATE `" + assessment + "` SET `attemptsLeft` = '" + attemptsLeft + "' WHERE (`studentNumber` = '" + user + "');";
            statement.addBatch(up);
            statement.executeBatch();

            if (prevMarks < totMarks)
            {
                up = "UPDATE `" + assessment + "` SET `marks` = '" + totMarks + "' WHERE (`studentNumber` = '" + user + "');";
                statement.addBatch(up);
                statement.executeBatch();
            }
        %>
    </body>
</html>
<script>

    /**
     * when the page is loaded
     */
    window.addEventListener('DOMContentLoaded', function ()
    {
        //fetches information to redirect page
        var user = document.getElementById("user").innerHTML;
        var db = document.getElementById("dbName").innerHTML;
        var name = document.getElementById("assessment").innerHTML;
        newTab(name, user, db);
    });

    /**
     * redirects page
     * @param {type} name name of assessment
     * @param {type} user student number 
     * @param {type} db name of database
     * @returns {undefined}
     */
    function newTab(name, user, db)
    {
        //encrypts data
        var db = btoa(db);
        var a = btoa(name);
        var u = btoa(user);
        var url = "resultsPage.jsp?a=" + a + "&u=" + u + "&db=" + db;

        //redirects page
        window.location = url;
    }
</script>
