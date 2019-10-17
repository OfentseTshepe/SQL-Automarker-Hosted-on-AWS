<%-- 
    Document   : Interface for a Lecturer or a Tutor to create an assessment for the students
    Created on : 12 Aug 2018, 4:08:51 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Assessment</title>
        <link href="./css/createAssessment.css" rel="stylesheet" type="text/css">
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css'>
    </head>
    <body onload="begin()">
        <div class="container"> 
            <section id="fancyTabWidget" class="tabs t-tabs">
                <div id="myTabContent" class="tab-content fancyTabContent" aria-live="polite">
                    <body>
                    <center>
                        <h2>
                            Create Assessment
                        </h2>
                    </center>
                    <br>
                    <br>
                    <%--Creates table to handle UI layout--%>
                    <table id="t01">
                        <tr>
                            <td>
                                Assessment Name:
                            </td>
                            <td>
                                <input id="assessmentName" name="assessmentName" type="text" >
                            </td> 
                        </tr>
                        <tr>
                            <td>Select Database:</td>
                            <td>
                                <select id="selectDatabase" name="selectDatabase">
                                    <%
                                        //Initiates connection to the MySQL database
                                        Connection connection = new SQL().getConnection();
                                        Statement statement = connection.createStatement();

                                        //fetches all databases in the system
                                        ResultSet rs = statement.executeQuery("SHOW SCHEMAS");

                                        //traverses through the result set
                                        while (rs.next())
                                        {
                                            //fetches database name
                                            String s = rs.getString("Database");

                                            //selects valid databases
                                            if (s.contains("option") || s.contains("questionset"))
                                            {
                                    %>
                                    <%--Populates the dropdown box with all relevant databases--%>
                                    <option class="database">
                                        <%= rs.getString("Database")%>
                                    </option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </td> 
                        </tr>
                        <tr>
                            <td>Assessment Type:</td>
                            <td>
                                <select id="assessmentType" name="assessmentType">
                                    <option id="assignment">
                                        Assignment
                                    </option>
                                    <option id="closedPrac">
                                        Closed Practical
                                    </option>
                                </select>
                            </td> 
                        </tr>
                        <tr>
                            <td>
                                Attempts
                            </td>
                            <td>
                                <input class="cat" id="attempts" name="attempts" TYPE="NUMBER" MIN="1" MAX="10" STEP="1" VALUE="1" SIZE="6" onchange="update()">
                            </td> 
                        </tr>
                    </table>
                    <br>
                    <br>     
                    <table id="t01">
                        <tr>
                            <td>
                                Total Number of Questions:
                            </td>
                            <td>
                                <input type="text" id="numQuestions" name="numQuestions" readonly>
                            </td> 
                        </tr>
                        <tr>
                            <td>
                                Category A: SIMPLE QUERIES      (2 Marks)
                            </td>
                            <td>
                                <input class="cat" id="catA" name="catA" TYPE="NUMBER" MIN="0" MAX="10" STEP="1" VALUE="1" SIZE="6" onchange="update()">
                            </td> 
                        </tr>
                        <tr>
                            <td>
                                Category B: WHERE CONDITIONS      (2 Marks)
                            </td>
                            <td>
                                <input class="cat" id="catB" name="catB" TYPE="NUMBER" MIN="0" MAX="10" STEP="1" VALUE="1" SIZE="6" onchange="update()">
                            </td> 
                        </tr>
                        <tr>
                            <td>
                                Category C: ORDER BY      (3 Marks)
                            </td>
                            <td>
                                <input class="cat" id="catC" name="catC" TYPE="NUMBER" MIN="0" MAX="10" STEP="1" VALUE="1" SIZE="6" onchange="update()">
                            </td> 
                        </tr>
                        <tr>
                            <td>
                                Category D: GROUP BY & HAVING      (3 Marks)
                            </td>
                            <td>
                                <input class="cat" id="catD" name="catD" TYPE="NUMBER" MIN="0" MAX="10" STEP="1" VALUE="1" SIZE="6" onchange="update()">
                            </td> 
                        </tr>
                        <tr>
                            <td>
                                Category E: SUB-QUERIES      (4 Marks)
                            </td>
                            <td>
                                <input class="cat" id="catE" name="catE" TYPE="NUMBER" MIN="0" MAX="10" STEP="1" VALUE="1" SIZE="6" onchange="update()">
                            </td> 
                        </tr>
                        <tr>
                            <td>
                                Category F: SUB-QUERY OPERATORS (ALL, ANY, SOME, EXISTS)       (4 Marks)
                            </td>
                            <td>
                                <input class="cat" id="catF" name="catF" TYPE="NUMBER" MIN="0" MAX="10" STEP="1" VALUE="1" SIZE="6" onchange="update()">
                            </td> 
                        </tr>
                        <tr>
                            <td>
                                Category G: JOINS      (5 Marks)
                            </td>
                            <td>
                                <input class="cat" id="catG" name="catG" TYPE="NUMBER" MIN="0" MAX="10" STEP="1" VALUE="1" SIZE="6" onchange="update()">
                            </td> 
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td> 
                                <table>
                                    <tr>
                                        <td>
                                            Total Marks:
                                        </td>
                                        <td> 
                                            <input type="text" id="totMarks" name="totMarks" readonly>
                                        </td> 
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <br>
                    <table id="t01">
                        <tr>                          
                            <td>
                                Start date (YYYY/MM/DD):
                            </td>
                            <td>
                                <input type="date" id="startDate" name="startDate" >
                            </td> 
                        </tr>
                        <tr>                          
                            <td>
                                Start time:
                            </td>
                            <td>
                                <input type="time" id="startTime" name="startTime">
                            </td> 
                        </tr>
                        <tr>                          
                            <td>
                                End date (YYYY/MM/DD):
                            </td>
                            <td>
                                <input type="date" id="endDate" name="endDate">
                            </td> 
                        </tr>
                        <tr>                          
                            <td>
                                End time:
                            </td>
                            <td>
                                <input type="time" id="endTime" name="endTime">
                            </td> 
                        </tr>
                    </table>
                    <br>
                    <br>
                    <center>
                        <input type="submit" class="button" id="b1" onclick="Javascript: validate();" >
                    </center>
                    <br>
                    <center>
                        <button class="button" id="b1" onclick="Javascript: home();" >
                            Home
                        </button>
                    </center>
                    </body>
                </div>
            </section>
        </div>
    </body>
    <script>

        /**
         * redirects the user back to the Teacher Portal home page 
         * @returns redirection to the teacher portal
         */
        function home()
        {
            var url = "teacherPortal.jsp?";
            window.history.back();
        }

        /**
         * sets the date and time values to the current date and time
         * @returns updated page
         */
        function begin()
        {
            //fetches date
            var now = new Date();

            var day = ("0" + now.getDate()).slice(-2);
            var month = ("0" + (now.getMonth() + 1)).slice(-2);

            var today = now.getFullYear() + "-" + (month) + "-" + (day);

            //sets values
            document.getElementById("startDate").value = today;
            document.getElementById("startTime").value = '00:00';
            document.getElementById("endDate").value = today;
            document.getElementById("endTime").value = '00:00';

            //updates the UI
            update();
        }

        /**
         * updates UI
         * @returns updated UI
         */
        function update()
        {
            var tot, cats, catA, catB, catC, catD, catE, catF, catG, label, totMarks, marksA, marksB, marksC, marksD, marksE, marksF, marksG, attempts, labelMarks;

            //fetches the data
            label = document.getElementById("numQuestions");
            cats = document.getElementsByClassName("cat");
            labelMarks = document.getElementById("totMarks");
            catA = document.getElementById("catA").valueOf();
            catB = document.getElementById("catB").valueOf();
            catC = document.getElementById("catC").valueOf();
            catD = document.getElementById("catD").valueOf();
            catE = document.getElementById("catE").valueOf();
            catF = document.getElementById("catF").valueOf();
            catG = document.getElementById("catG").valueOf();
            attempts = document.getElementById("attempts").valueOf();

            //sets the information
            tot = Number(catA.value) + Number(catB.value) + Number(catC.value) + Number(catD.value) + Number(catE.value) + Number(catF.value) + Number(catG.value);
            label.value = tot.valueOf();
            totMarks = Number(2 * catA.value) + Number(2 * catB.value) + Number(3 * catC.value) + Number(3 * catD.value) + Number(4 * catE.value) + Number(4 * catF.value) + Number(5 * catG.value);
            labelMarks.value = totMarks.valueOf();
        }

        /**
         * enures that the information provided is correct
         * @returns {undefined}
         */
        function validate()
        {
            //fetches information
            var name = document.getElementById("assessmentName").value;
            var startDate = document.getElementById("startDate").value;
            var endDate = document.getElementById("endDate").value;
            var proceed = true;

            //if the assignment name is empty
            if (name == "")
            {
                //alert the user
                alert('Please provide a name for the assessment');
                //sets proceed to false
                proceed = false;
            }

            //if the starting date of the assignment is after the end date of the assignment
            if (startDate > endDate)
            {
                //alert the user
                alert('Start date cannot be greater than the end date');
                //sets proceed to false
                proceed = false;
            }

            //if proceed is true, create the assessment
            if (proceed == true)
            {
                createAssessment();
            }
        }

        /**
         * creates the assessment
         * @returns redirection to created assessment
         */
        function createAssessment()
        {
            var assessmentName, assessmentType, selectDatabase, tot, cats, catA, catB, catC, catD, catE, catF, catG, numQuestions, totMarks, attempts, startDate, startTime, endDate, endTime;

            //fetches values
            assessmentName = document.getElementById("assessmentName").value;
            assessmentType = document.getElementById("assessmentType").value;
            numQuestions = document.getElementById("numQuestions").value;
            selectDatabase = document.getElementById("selectDatabase").value;
            totMarks = document.getElementById("totMarks").value;
            catA = document.getElementById("catA").value;
            catB = document.getElementById("catB").value;
            catC = document.getElementById("catC").value;
            catD = document.getElementById("catD").value;
            catE = document.getElementById("catE").value;
            catF = document.getElementById("catF").value;
            catG = document.getElementById("catG").value;
            attempts = document.getElementById("attempts").value;
            startDate = document.getElementById("startDate").value;
            startTime = document.getElementById("startTime").value;
            endDate = document.getElementById("endDate").value;
            endTime = document.getElementById("endTime").value;

            if (totMarks == 0)
            {
                alert('Assessment has to have at least one question');
            }
            else
            {
                //creates redirect link
                var s = "createAssessmentLoading.jsp?n=" + btoa(assessmentName) + "&t=" + btoa(assessmentType) + "&db=" + btoa(selectDatabase) + "&nQ=" + btoa(numQuestions) + "&tM=" + btoa(totMarks) + "&cA=" + btoa(catA) + "&cB=" + btoa(catB) + "&cC=" + btoa(catC) + "&cD=" + btoa(catD) + "&cE=" + btoa(catE) + "&cF=" + btoa(catF) + "&cG=" + btoa(catG) + "&at=" + btoa(attempts) + "&sD=" + btoa(startDate) + "&sT=" + btoa(startTime) + "&eD=" + btoa(endDate) + "&eT=" + btoa(endTime);
                //redirects to the assessment handling page
                window.location = s;
            }


        }
    </script>
</html>
