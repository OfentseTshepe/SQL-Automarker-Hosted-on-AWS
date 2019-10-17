<%-- 
    Document   : Front-Facing UI for the student
    Created on : 08 Aug 2018, 8:08:08 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="java.util.Base64.Decoder"%>
<%@page import="java.util.Base64"%>
<%@page import="java.sql.*"%>
<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html >
    <head>
        <meta charset="UTF-8">
        <title>
            Student Portal
        </title>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css'>
        <link href="./css/studentPortal.css" rel="stylesheet" type="text/css">
    </head>

    <body>
        <div class="container"> 
            <section id="fancyTabWidget" class="tabs t-tabs">
                <div  id="myTabContent" class="tab-content fancyTabContent" aria-live="polite">
                    <h2 id="title01" style="text-align: center;">
                        Student Portal
                    </h2>
                    <br>
                    <%
                        //fetches parameter
                        String u = request.getParameter("u");

                        //decodes the string
                        Decoder decoder = Base64.getDecoder();
                        byte[] us = decoder.decode(u);
                        String user = new String(us);
                    %>
                    <%--displays student numnber--%>
                    <h3 id="username" name="username" style="text-align: center;">
                        <%=user%>
                    </h3>
                    <div class="row">
                        <div class="col-md-12">
                            <br>
                            <br>
                            <%--tabs--%>
                            <div class="tab">
                                <button id="assessments" class="tablinks" onclick="openTab(event, 'Assessments')" id="defaultOpen">
                                    Assessments
                                </button>
                                <button id="grades" class="tablinks" onclick="openTab(event, 'Marks')">
                                    My Grades
                                </button>
                            </div>
                            <%--assessments tab--%>
                            <div id="Assessments" class="tabcontent">
                                <%--creates table to display all assignments--%>
                                <table  id="t01">
                                    <tr>
                                        <td style="width: auto; font-size: small; ">
                                            Assessment
                                        </td>
                                        <td style="width: 120px; font-size: small; ">
                                            Type
                                        </td>
                                        <td style="width: auto; font-size: small; ">
                                            Start Date
                                        </td>
                                        <td style="width: auto; font-size: small; ">
                                            End Date
                                        </td>
                                        <td style="width: 105px; font-size: small; ">
                                            Questions
                                        </td>
                                        <td style="width: 80px; font-size: small; ">
                                            Out Of
                                        </td>
                                        <td style="width: 80px; font-size: small; ">
                                            Retries
                                        </td>
                                        <td style="width: 80px; font-size: small; ">
                                            Result
                                        </td>
                                        <td style="width: 100px; font-size: small; ">
                                        </td>
                                    </tr>
                                    <%
                                        //initiates connection with the MySQL database
                                        Connection connection = new SQL().getConnection();
                                        Statement statement = connection.createStatement();
                                        
                                        statement.addBatch("use `sqlautomarker`;");
                                        statement.executeBatch();

                                        //fetches all assessments
                                        ResultSet rs = statement.executeQuery("SELECT * FROM assessments");
                                        int x = 0;

                                        //traverses result set
                                        while (rs.next())
                                        {
                                            //fetches parameters
                                            String name = rs.getString("assessment_name");
                                            String type = rs.getString("assessment_type");
                                            
                                            String startDate = rs.getString("start_date");
                                            String startTime = rs.getString("start_time");
                                            String start = startDate + " " + startTime;
                                            
                                            String endDate = rs.getString("end_date");
                                            String endTime = rs.getString("end_time");
                                            String end = endDate + " " + endTime;
                                            
                                            String questions = rs.getString("total_questions");
                                            String marks = rs.getString("total_marks");
                                            
                                            int totAttempts = Integer.parseInt(rs.getString("attempts"));
                                            
                                            Statement statement2 = connection.createStatement();
                                            statement2.addBatch("use `marks`;");
                                            statement2.executeBatch();

                                            //fetches information on the assessment and the user from the marks table
                                            String sql = "SELECT attemptsLeft, marks FROM `" + name + "` WHERE studentNumber ='" + user + "'";
                                            ResultSet rn = statement2.executeQuery(sql);
                                            
                                            int attemptsLeft = 0;
                                            int mark = 0;
                                            rn.next();
                                            attemptsLeft = Integer.parseInt(rn.getString("attemptsLeft"));
                                            
                                            String s = rn.getString("marks");
                                            //if the assessment has not been attempted yet
                                            if (s == null)
                                            {
                                                mark = 0;
                                            }
                                            else
                                            {
                                                mark = Integer.parseInt(s);
                                            }
                                            
                                            String endD = endDate + "T" + endTime + "Z";
                                    %>
                                    <%--hidden variables--%>
                                    <p hidden id="<%="totAttempts " + x%>"><%=totAttempts%></p>
                                    <p hidden id="<%="attemptsLeft " + x%>"><%=attemptsLeft%></p>
                                    <p hidden id="<%="endDate " + x%>"><%=endDate + "T" + endTime + "+02:00"%></p>
                                    <p hidden id="<%="startDate " + x%>"><%=startDate + "T" + startTime + "+02:00"%></p>
                                    <tr>
                                        <td style="font-size: small;" name="name" id="name">
                                            <%=name%>
                                        </td>
                                        <td style="font-size: small;">
                                            <%=type%>
                                        </td>
                                        <td style="font-size: smaller;">
                                            <%=start%>
                                        </td>
                                        <td style="font-size: smaller;">
                                            <%=end%>
                                        </td>
                                        <td style="font-size: small;">
                                            <%=questions%>
                                        </td>
                                        <td style="font-size: small;">
                                            <%=marks%>
                                        </td>
                                        <td style="font-size: small;">
                                            <%=attemptsLeft%>
                                        </td>
                                        <td style="font-size: small;">
                                            <%=mark%>
                                        </td>
                                        <td style="font-size: small;">
                                            <a id="ref-<%=x%>"  href="JavaScript:newTab('<%=name%>', '<%=user%>','<%=attemptsLeft%>', '<%=totAttempts%>', '<%="endDate " + x%>');">
                                                Begin
                                            </a>
                                        </td>

                                    </tr>
                                    <%
                                            x++;
                                        }
                                    %>
                                </table>
                            </div>
                            <%--grades tab--%>
                            <div id="Marks" class="tabcontent">
                                <table  id="t01">
                                    <tr>
                                        <td>
                                            Assessment Name
                                        </td>
                                        <td>
                                            Grade
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <%    
                                        statement.addBatch("use `marks`;");
                                        statement.executeBatch();

                                        //fetches all assessments
                                        rs = statement.executeQuery("SHOW TABLES;");
                                        int y = 0;
                                        int mark = 0;

                                        //traverse data set
                                        while (rs.next())
                                        {
                                            String name = rs.getString(1);
                                            //fetches the assessment marks of the user from the database and tables
                                            String sql = "SELECT marks FROM `" + name + "` WHERE studentNumber ='" + user + "'";
                                            Statement s2 = connection.createStatement();
                                            
                                            ResultSet rn = s2.executeQuery(sql);
                                            rn.next();

                                            //fetches the mark
                                            String s = rn.getString("marks");

                                            //if the assessment has not been submitted yet
                                            if (s == null)
                                            {
                                                mark = 0;
                                            }
                                            else
                                            {
                                                mark = Integer.parseInt(s);
                                            }
                                            
                                            Statement s3 = connection.createStatement();
                                            
                                            rn = s3.executeQuery("SELECT question_database, total_marks FROM `sqlautomarker`.`assessments` WHERE assessment_name ='" + name + "';");
                                            rn.next();
                                            String db = rn.getString("question_database");
                                            String tm = rn.getString("total_marks");

                                    %>
                                    <%--populates the table--%>
                                    <tr>
                                        <td>
                                            <%=name%>
                                        </td>
                                        <td>
                                            <%=mark%> out of <%=tm%>
                                        </td>
                                        <td style="text-align: right;">
                                            <a id="mark-<%=y%>"  href="JavaScript:resultsPage('<%=name%>', '<%=user%>','<%=db%>');">
                                                View Results
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            y++;
                                        }
                                    %>
                                </table>
                            </div>
                        </div>
                        <script>
                            /**
                             * when the document loads
                             * @type DOM content loaded
                             */
                            window.addEventListener('DOMContentLoaded', function ()
                            {
                                var x = <%=x%>;
                                var today = new Date();
                                
                                //traverses the assessments
                                for (var i = 0; i < x; i++)
                                {
                                    //fetches start and end date of the assessment 
                                    var v = i;
                                    var y = 'startDate ' + v;
                                    var sDate = document.getElementById(y).innerHTML;
                                    var y1 = 'endDate ' + v;
                                    var eDate = document.getElementById(y1).innerHTML;
                                    var start = new Date(sDate);
                                    var end = new Date(eDate);
                                    
                                    //fetches the number of attempts left
                                    var attempts = document.getElementById("attemptsLeft " + v).innerHTML;
                                    var totAttempts = document.getElementById("totAttempts " + v).innerHTML;
                                    //if there are no more attempts left, disable the link
                                    if (attempts == 0)
                                    {
                                        document.getElementById("ref-" + v).innerHTML = "Closed";
                                        document.getElementById("ref-" + v).removeAttribute('href');
                                    }
                                    
                                    if (totAttempts == attempts)
                                    {
                                        document.getElementById("mark-" + v).innerHTML = "Not Available";
                                        document.getElementById("mark-" + v).removeAttribute('href');
                                    }
                                    //if the current date is greater than the assessment's close date, disable the link
                                    if (end < today)
                                    {
                                        document.getElementById("ref-" + v).innerHTML = "Closed";
                                        document.getElementById("ref-" + v).removeAttribute('href');
                                    }
                                    
                                    //if the start link is greater than today's date, disable the link
                                    if (start > today)
                                    {
                                        document.getElementById("ref-" + v).innerHTML = "Not available";
                                        document.getElementById("ref-" + v).removeAttribute('href');
                                    }
                                }
                                //opens the assessment tab
                                openTab(event, 'Assessments');
                            });
                            
                            
                            /**
                             * redirects to the result's page
                             * 
                             * @param {type} name name of assessment
                             * @param {type} user student number
                             * @param {type} db database name
                             * @returns {undefined} page redirect
                             */
                            function resultsPage(name, user, db)
                            {
                                //encrypts data
                                var db = btoa(db);
                                var a = btoa(name);
                                var u = btoa(user);
                                var url = "resultsPage.jsp?a=" + a + "&u=" + u + "&db=" + db;
                                
                                //redirect
                                window.location = url;
                            }
                            
                            /**
                             * opens the selected tab
                             * 
                             * @param {type} evt event
                             * @param {type} TabName name of the tab
                             * @returns {undefined} new tab opened
                             */
                            function openTab(evt, TabName)
                            {
                                var i, tabcontent, tablinks;
                                
                                //fetches tab content
                                tabcontent = document.getElementsByClassName("tabcontent");
                                
                                //traverses tabs
                                for (i = 0; i < tabcontent.length; i++)
                                {
                                    //hides all tabs
                                    tabcontent[i].style.display = "none";
                                }
                                
                                //fetches tab links
                                tablinks = document.getElementsByClassName("tablinks");
                                
                                //traverse tab links                        
                                for (i = 0; i < tablinks.length; i++)
                                {
                                    //deactivate tab
                                    tablinks[i].className = tablinks[i].className.replace(" active", "");
                                }
                                
                                //display tab
                                document.getElementById(TabName).style.display = "block";
                                
                                //activate tab
                                evt.currentTarget.className += " active";
                            }
                            
                            /**
                             * opens the assessment in a new tab for the student to complete
                             * 
                             * @param {type} name name of assessment
                             * @param {type} user student number
                             * @param {type} left attempts left
                             * @param {type} totAttempt number of attempts allowed
                             * @returns {undefined} assessment page
                             */
                            function newTab(name, user, totAttempt, left, endDate)
                            {
                                
                                var url;
                                var at = totAttempt;
                                var l = left;
                                var endD = document.getElementById(endDate).innerHTML;
                                //if it is the student's first try
                                
                                if (l == at)
                                {
                                    //encrypt data
                                    var attempt = btoa(at);
                                    var a = btoa(name);
                                    var u = btoa(user);
                                    var e = btoa(endD);
                                    
                                    //build url
                                    url = "studentAnswers.jsp?assessment=" + a + "&user=" + u + "&attempt=" + attempt + "&ed=" + e;
                                    
                                    //opens url 
                                    window.location = url;
                                }
                                else
                                {
                                    //prompt the user
                                    var c = confirm('Are you sure you would like to retry the assignment?\nYour current mark will be erased');
                                    
                                    //if the user selects yes 
                                    if (c == true)
                                    {
                                        //encrypt data
                                        var attempt = btoa(at);
                                        var a = btoa(name);
                                        var u = btoa(user);
                                        var e = btoa(endD);
                                        
                                        //build url
                                        url = "studentAnswers.jsp?assessment=" + a + "&user=" + u + "&attempt=" + attempt + "&ed=" + e;
                                        
                                        //opens url 
                                        window.location = url;
                                    }
                                }
                            }
                        </script>
                    </div>
            </section>
        </div>
    </body>
</html>