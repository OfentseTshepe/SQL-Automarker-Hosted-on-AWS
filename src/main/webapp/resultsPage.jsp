<%-- 
    Document   : createAssessment
    Created on : 12 Aug 2018, 4:08:51 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.Base64.Decoder"%>
<%@page import="java.util.Base64"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>
            Results
        </title>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css'>
        <link href="./css/resultsPage.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <div class="container"> 
            <div id="myTabContent" class="tab-content fancyTabContent" aria-live="polite" >
                <center>
                    <h2>
                        Results
                    </h2>
                </center>
                <br>
                <br>
                <%
                    //fetches parameters
                    String a = request.getParameter("a");
                    String u = request.getParameter("u");
                    String d = request.getParameter("db");

                    //decodes the strings
                    Decoder decoder = Base64.getDecoder();
                    byte[] as = decoder.decode(a);
                    byte[] us = decoder.decode(u);
                    byte[] db = decoder.decode(d);
                    new String(as);
                    String user = new String(us);
                    String assessment = new String(as);
                    String database = new String(db);

                    //initiates connection to the MySQL database
                    Connection connection = new SQL().getConnection();
                    Statement statement = connection.createStatement();

                    String s = "SELECT q.`questionID`, q.`question`, q.`studentAnswer`, ques.`expectedAnswer`, q.`studentMarks`, ques.`marks` "
                            + "FROM `sqlautomarker-individual-records`.`" + user + "-" + assessment + "` q "
                            + "JOIN `" + database + "`.`questions` ques ON q.questionReference = ques.questionNumber";

                    ResultSet rs = statement.executeQuery(s);
                    ResultSetMetaData rsmd = rs.getMetaData();
                    ArrayList<Result> results = new ArrayList<Result>();

                    //traverses through the result set
                    while (rs.next())
                    {
                        //fetches elements
                        String question = rs.getString("question");
                        String studentAnswer = rs.getString("studentAnswer");
                        String expectedAnswer = rs.getString("expectedAnswer");
                        String qID = rs.getString("questionID");
                        String sMarks = rs.getString("studentMarks");

                        int questionID = 0;
                        int studentMarks = 0;

                        if (qID != null)
                        {
                            questionID = Integer.parseInt(qID);
                        }
                        if (sMarks != null)
                        {
                            studentMarks = Integer.parseInt(sMarks);
                        }
                        int outOf = Integer.parseInt(rs.getString("marks"));

                        //creates new Result
                        Result r = new Result(questionID, question, studentAnswer, expectedAnswer, studentMarks, outOf);

                        //adds result to the list
                        results.add(r);
                    }

                    int totMarks = 0;
                    int assignmentTotal = 0;

                    //for each question, create a section to display the answer
                    for (Result result : results)
                    {
                        int num = result.getQuestionID();
                        int marks = result.getStudentMarks();
                        int outOf = result.getOutOf();
                        String question = result.getQuestion();
                        String expected = result.getExpectedAnswer();
                        String given = result.getStudentAnswer();
                        assignmentTotal += outOf;
                        totMarks += marks;

                %>
                <p hidden id="user"><%=user%></p>
                <h4>
                    Question <%=num%>
                </h4>
                <%
                    //if the question is correct
                    if (marks == outOf)
                    {
                %>
                <h5 id="correct">
                    Correct
                </h5>
                <h5>
                    Question:
                </h5>
                <h5>
                    <%=question%>
                </h5>
                <br>
                <h5>
                    Your Answer:
                </h5>
                <h5>
                    <%=given%>
                </h5>
                <br>
                <h5 style="text-align: right;">
                    <%=marks%> out of <%=outOf%>
                </h5>
                <%
                }
                //if the question is incorrect
                else
                {
                %>
                <h5 id="incorrect">
                    Incorrect
                </h5>
                <h5>
                    Question:
                </h5>
                <h5>
                    <%=question%>
                </h5>
                <br>
                <h5>
                    Expected Answer:
                </h5>
                <h5>
                    <%=expected%>
                </h5>
                <br>
                <h5>
                    Your Answer:
                </h5>
                <h5>
                    <%=given%>
                </h5>
                <br>
                <h5 style="text-align: right;">
                    <%=marks%> out of <%=outOf%>
                </h5>
                <%
                        }
                    }
                %>
                <h2 style="text-align: center;">
                    Total Marks: <%=totMarks + " out of " + assignmentTotal%>
                </h2>
                <br>
                <center>
                    <button class="button" id="b1" onClick="Javascript: home();">
                        Home
                    </button>
                </center>
            </div>
        </div>
    </body>
    <script>
 
        /**
         * redirects user back to Student Page
         * @returns redirection to student portal
         */
        function home()
        {
            var user = document.getElementById("user").innerHTML;
            var u = btoa(user);
            var s = 'studentPortal.jsp?u=' + u;
            window.location = s;
        }
    </script>
</html>
