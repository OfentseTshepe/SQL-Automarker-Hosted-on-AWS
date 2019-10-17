<%-- 
    Document   : This provides the UI from which the user will view and take his/her assessment
    Created on : 12 Aug 2018, 4:08:51 PM
    Author     : MLTZAC001
--%>

<%@page import="java.util.Base64.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>
            Assessment
        </title>
        <link href="./css/studentAnswers.css" rel="stylesheet" type="text/css">
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css'>
    </head>
    <body>
        <div class="container"> 
            <section id="fancyTabWidget" class="tabs t-tabs">
                <div id="myTabContent" class="tab-content fancyTabContent" aria-live="polite">
                    <%
                        //fetches parameters
                        String a = request.getParameter("assessment");
                        String u = request.getParameter("user");
                        String at = request.getParameter("attempt");
                        String e = request.getParameter("ed");

                        //decodes the strings
                        Decoder decoder = Base64.getDecoder();
                        byte[] as = decoder.decode(a);
                        byte[] us = decoder.decode(u);
                        byte[] att = decoder.decode(at);
                        byte[] ed = decoder.decode(e);
                        String assessment = new String(as);
                        String user = new String(us);
                        String attempt = new String(att);
                        String endDate = new String(ed);

                        ArrayList<Question> questions = new ArrayList<Question>();

                        //initiates connection with the MySQL database
                        Connection connection = new SQL().getConnection();
                        Statement statement = connection.createStatement();
                        statement.addBatch("use `sqlautomarker`;");
                        statement.executeBatch();

                        //fetches assessment information
                        ResultSet rs1 = statement.executeQuery("Select * FROM assessments WHERE assessment_name='" + assessment + "';");

                        String database = "";
                        String attempts = "";

                        //traverses through result set
                        while (rs1.next())
                        {
                            //fetches relevant information
                            database = rs1.getString("question_database");
                            attempts = rs1.getString("attempts");
                        }

                        int intAttempt = Integer.parseInt(attempt);
                        int intAttempts = Integer.parseInt(attempts);
                        
                        //if the current attempt is less than the number of attempts allowed
                        if (intAttempt < intAttempts)
                        {
                            //assigns a new set of questions to the user based on the assessment
                            new Assessment().updateAssessment(user, assessment, database);
                        }

                        ArrayList<String> schemas = new ArrayList<String>();

                        statement.addBatch("use `" + database + "`;");
                        statement.executeBatch();

                        //fetches all relevant tables from the question's database
                        ResultSet rs2 = statement.executeQuery("SHOW TABLES;");

                        //traverses through result set
                        while (rs2.next())
                        {
                            String st = rs2.getString(1);

                            //for every table in the database that does not have the name "question", add it to the list of schema
                            if (!st.equals("questions"))
                            {
                                schemas.add(st);
                            }
                        }
                    %>
                    <%--creates hidden variables--%>
                    <p hidden id="user"><%=user%></p>
                    <p hidden id="assessmet"><%=assessment%></p>
                    <p hidden id="eD"><%=endDate%></p>
                    <%
                        //fetches all questions from the database
                        ResultSet qrs = statement.executeQuery("SELECT * FROM questions;");

                        //traverses through result set
                        while (qrs.next())
                        {
                            //fetches information
                            int questionNumber = Integer.parseInt(qrs.getString("questionNumber"));
                            String question = qrs.getString("question");
                            String expectedAnswer = qrs.getString("expectedAnswer");
                            String category = qrs.getString("category");
                            int marks = Integer.parseInt(qrs.getString("marks"));

                            //create new question record
                            Question quest = new Question(questionNumber, question, expectedAnswer, category, marks);

                            //add question to the list
                            questions.add(quest);
                        }
                    %>
                    <center>
                        <h2 id="title01">
                            Assessment
                        </h2>
                    </center>
                    <%--this section displays all tables necessary for the assessment--%>
                    <div id="myTabContent" class="container" aria-live="polite" style="overflow:scroll; height:300px; width: 100%">
                        <br>

                        <%
                            //traverses through the schemas that are not named "questions"
                            for (String string : schemas)
                            {
                        %>
                        <h4>
                            <%--displays the name of the relevant schema--%>
                            <%=string%>
                        </h4>
                        <%
                            //fetches all entries from the schema
                            ResultSet rs = statement.executeQuery("SELECT * FROM " + string + ";");
                            ResultSetMetaData rsmd = rs.getMetaData();

                            //fetches number of columns
                            int columnsNumber = rsmd.getColumnCount();

                            ArrayList<String> col = new ArrayList<String>();
                        %>
                        <%--creates table to display the schema--%>
                        <table style="table-layout: auto; width: 100%;">
                            <%
                                //traverses through the columns
                                for (int i = 1; i < columnsNumber + 1; i++)
                                {
                                    //fetches column name
                                    String st = rsmd.getColumnName(i);
                                    //adds column to list
                                    col.add(st);
                            %>
                            <%--creates a table header for each entry--%>
                            <th style="font-size: 10px">
                                <%=st%>
                            </th>
                            <%
                                }

                                //traverses through the schemas that are not named "questions"
                                while (rs.next())
                                {
                            %>
                            <tr>
                                <%
                                    //traverses through the columns
                                    for (int i = 0; i < columnsNumber; i++)
                                    {
                                        //fetches value from column
                                        String ent = rs.getString(col.get(i));
                                %>
                                <%--populates the table cell--%>
                                <td style="font-size: 10px;">
                                    <%=ent%>
                                </td>
                                <%
                                    }
                                %>
                            </tr>
                            <%
                                }
                            %>
                        </table>
                        <%
                            }
                        %> 
                        <br>
                    </div>
                    <%--this section displays all questions and answer boxes--%>
                    <div class="slideshow-container">
                        <%
                            statement.addBatch("use `sqlautomarker-individual-records`;");
                            statement.executeBatch();
                            String dbName = user.toUpperCase() + "-" + assessment;
                        %>
                        <p hidden id="dbName"><%=database%></p>
                        <p hidden id="attempt"><%=attempt%></p>
                        <%
                            String qs = "";

                            //fetches all questions and information for the user
                            ResultSet q = statement.executeQuery("SELECT * FROM `" + dbName + "`;");
                            ArrayList<Question> indivQuestions = new ArrayList<Question>();

                            //traverses through the schemas that are not named "questions"
                            while (q.next())
                            {
                                //fetches relevant informention
                                int qNum = Integer.parseInt(q.getString("questionReference"));
                                qs += q.getString("questionReference") + " ";
                                indivQuestions.add(questions.get(qNum - 1));
                            }
                        %>
                        <%--hidden variable--%>
                        <p hidden id="qs"><%=qs%></p>
                        <%
                            int count = 1;

                            //creates a new 'section' for each question assigned to the student
                            for (Question quest : indivQuestions)
                            {
                        %>
                        <div class="mySlides" style="word-wrap: break-word;">
                            <table style="border: none;">
                                <tr>
                                    <%--displays question--%>
                                    <td style="border: none; font-size:20px;  word-wrap: break-word;">
                                        <p><%=count + ". " + quest.getQuestion()%></p>
                                    </td> 
                                    <%--displays how many marks the question is worth--%>
                                    <td style="border: none; width: 20px;  text-align: right; vertical-align: top; font-size: 20px">
                                        <p><%="Marks: (" + quest.getMarks() + ")"%></p>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <table style="border: none;">
                                <tr>
                                    <td style="border: none;">
                                        Type your answer here:
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <table style="border: none;">
                                <%--creates a text area for the user's answer--%>
                                <tr>
                                    <td style=" border: none; height: 200px;"><textarea id="text <%=count%>" style="width: 100%; height: 100%;"></textarea></td>
                                </tr>
                            </table>
                            <br>
                            <table>
                                <%--button for the user to run the query--%>
                                <tr>
                                    <td style="text-align: center; border: none;">
                                        <button id ="runQuery<%=count%>"  onclick="JavaScript:newTab('text <%=count%>', '<%=database%>');" >
                                            Run Query
                                        </button>
                                    </td>
                                </tr>
                            </table>
                            <br>
                        </div>
                        <%
                                count++;
                            }
                        %>
                        <%--creates submit button--%>
                        <div class="mySlides" style="word-wrap: break-word;">
                            <br><br> <br><br>
                            <table>
                                <tr>
                                    <td style="border:none; text-align: center;">
                                        <button id="b1" class="button" onclick="JavaScript:submit('yes');">Submit</button>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <br>

                        <%--creates forward and backward button--%>
                        <a class="prev" onclick="plusSlides(-1)">❮</a>
                        <a class="next" onclick="plusSlides(1)">❯</a>
                    </div>
                    <%--creates the dots that display the question numbers and submit button at the bottom of the page--%>
                    <div class="dot-container">
                        <%
                            int x = 1;
                            for (Question qu : indivQuestions)
                            {
                        %>
                        <span class="dot" onclick="currentSlide(<%=x%>)">
                            <%=x%>
                        </span>
                        <%
                                x++;
                            }
                        %>
                        <span class="dot" onclick="currentSlide(<%=x%>)">
                            S
                        </span>
                    </div>
                    <br>
                    </body>
                </div>
            </section>
        </div>
    </body>
    <script>

        //sets the initial slide that displays the question
        var slideIndex = 1;
        showSlides(slideIndex);

        /**
         * increases the slide to the next one
         * @param {type} n slide number 
         * @returns {undefined} new slide
         */
        function plusSlides(n)
        {
            showSlides(slideIndex += n);
        }

        /**
         * goes back to the previous slide
         * @param {type} n slide number
         * @returns {undefined} new slide
         */
        function currentSlide(n)
        {
            showSlides(slideIndex = n);
        }

        /**
         * displays a question slide
         * @param {type} n slide number
         * @returns {undefined} new slide
         */
        function showSlides(n)
        {
            var i;
            //fetches elements
            var slides = document.getElementsByClassName("mySlides");
            var dots = document.getElementsByClassName("dot");

            //if the slide goes past the total number of slides, set the slide to the first one
            if (n > slides.length)
            {
                slideIndex = 1
            }
            //if the slide goes behind the first slide, set the slide to the last slide 
            if (n < 1)
            {
                slideIndex = slides.length
            }

            //hide all slides
            for (i = 0; i < slides.length; i++)
            {
                slides[i].style.display = "none";
            }
            //deactivate all slides
            for (i = 0; i < dots.length; i++)
            {
                dots[i].className = dots[i].className.replace(" active", "");
            }
            //display selected slide
            slides[slideIndex - 1].style.display = "block";
            //activate slide
            dots[slideIndex - 1].className += " active";
        }

        /**
         * runs a query
         * @param {type} id sql statement
         * @param {type} database name of database
         * @returns {undefined} new query window
         */
        function newTab(id, database)
        {
            //fetches information
            var s = document.getElementById(id).value;

            //encrypts information
            var data = btoa(database);
            var ur = btoa(s);

            var url = "runQuery.jsp?database=" + data + "&string=" + ur;
            runQuery(url);
        }

        /**
         * creates a popup to run the query 
         * @param {type} text url of the query
         * @returns {undefined} pop up window
         */
        function runQuery(text)
        {
            popupWindow = window.open(
                    text, 'popUpWindow', 'height=600,width=700,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes')
        }

        /**
         * submits the assignment
         * @param {type} url
         * @returns {undefined}
         */
        function submit(url)
        {

            var arr = new Array();
            var x = <%=x - 1%>;

            //fetches all answers from the textareas
            for (var i = 1; i <= x; i++)
            {
                var s = document.getElementById("text " + i).value;
                var res = s.replace(/\(/g, "\\(");
                var res2 = res.replace(/\)/g, "\\)");
                var res3 = res2.replace(/'/g, "\\'");
                var res4 = res3.replace(/</g,"&lt");
                var res5 = res4.replace(/>/g,"&gt");
                arr[i - 1] = "\"" + res5 + "\"";
            }

            //fetches relevant elements
            var questions = document.getElementById("qs").innerHTML;
            var dbName = document.getElementById("dbName").innerHTML;
            var ass = document.getElementById("assessmet").innerHTML;
            var us = document.getElementById("user").innerHTML;
            var attempt = document.getElementById("attempt").innerHTML;

            //encrypts elements
            var database = btoa(dbName);
            var q = btoa(questions);
            var data = btoa(arr);
            var assessment = btoa(ass);
            var user = btoa(us);
            var a = btoa(attempt);

            //creates redirect url
            var url = "markAssessment.jsp?set=" + data + "&db=" + database + "&qs=" + q + "&a=" + assessment + "&u=" + user + "&attempt=" + a;
            var nURL = btoa(url)


            var eDate = document.getElementById("eD").innerHTML;

            //fetches date
            var now = new Date();
            var end = new Date(eDate);

            if (end < now)
            {
                alert('Assessment has closed');
            }
            else
            {
                //  sends url to mark handler
                mark("markLoading.jsp?redir=" + nURL);
            }
        }

        /**
         * forwards the assessment to mark it
         * @param {type} arr array of user inputs
         * @returns {undefined} redirection to mark assessment
         */
        function mark(arr)
        {
            //prompt the user 
            var x = confirm('Are you sure you would like to submit the assessment?');

            //if user selects yes, mark assignment
            if (x == true)
            {
                window.location = arr;
            }
        }
    </script>
</html>
