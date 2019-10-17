<%-- 
    Document   : Displays the mark breakdown of an assessment. It displays the student numbers and their marks for the assignment. 
    Created on : 08 Aug 2018, 8:08:08 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="java.util.Base64.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html >
    <head>
        <meta charset="UTF-8">
        <title>Marks</title>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css'>
        <link href="./css/viewMarks.css" rel="stylesheet" type="text/css">
    </head>

    <body>
        <div class="container"> 
            <section id="fancyTabWidget" class="tabs t-tabs">
                <div  id="myTabContent" class="tab-content fancyTabContent" aria-live="polite">
                    <%
                        //fetches parameters
                        String u = request.getParameter("a");

                        //decodes the string
                        Decoder decoder = Base64.getDecoder();
                        byte[] us = decoder.decode(u);
                        String name = new String(us);
                    %>
                    <h2>View Marks</h2>
                    <h3 id="username" name="username"><%=name%></h3>
                    <br>
                    <br>

                    <%--Creates a table to store the data in--%>
                    <table id="t01">
                        <tr>
                            <td>Student Number</td>
                            <td>Mark</td>
                        </tr>

                        <%
                            //Establishes connection to the MySQL database
                            Connection connection = new SQL().getConnection();
                            Statement statement = connection.createStatement();

                            //use the 'marks' database
                            statement.addBatch("use `marks`;");
                            statement.executeBatch();

                            //SQL statement to fetch records from the assignment table
                            String s = "SELECT * FROM `" + name + "`";
                            ResultSet rs = statement.executeQuery(s);

                            //traverse through the result set
                            while (rs.next())
                            {
                                //fetches student number and the marks the student achieved for the assignment
                                String user = rs.getString("studentNumber");
                                String marks = rs.getString("marks");

                                int m = 0;
                                if (marks != null)
                                {
                                    m = Integer.parseInt(marks);
                                }
                        %>
                        <tr>
                            <td><a href="Javascript: newTab('<%=user%>', '<%=name%>');"><%=user%></a></td>
                            <td><%=m%></td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                    <br>
                    <br>     
                    <center>
                        <%--Home button--%>
                        <button onclick="Javascript: home()" class="button" id="b1" >Home</button>
                    </center>
                    <br>
                    <center>
                        <a href=" Javascript: exportTableToCSV('<%=name%>_mark_summary.csv');" >Export CSV</a>
                    </center>

                    <script>
                        /**
                         * redirects the page to view an Individual User's assessment breakdown
                         * @param {type} name assessment name
                         * @param {type} user student number
                         * @returns redirect to view marks
                         */
                        function newTab(name, user)
                        {
                            var url;

                            //encrypts data and redirects the page
                            var a = btoa(name);
                            var u = btoa(user);
                            url = "viewIndividualMarks.jsp?assessment=" + a + "&u=" + u;
                            window.location = url;
                        }

                        /**
                         * redirects the page the Teacher Portal
                         * @returns redirects to teacher portal
                         */
                        function home()
                        {
                            window.history.back();
                        }
                        /**
                         * Downloads the csv file
                         * @param {type} csv document type
                         * @param {type} filename name of file
                         * @returns {undefined} downloaded document
                         */
                        function downloadCSV(csv, filename)
                        {
                            var csvFile;
                            var downloadLink;

                            // CSV file
                            csvFile = new Blob([csv], {type: "text/csv"});

                            // Download link
                            downloadLink = document.createElement("a");

                            // File name
                            downloadLink.download = filename;

                            // Create a link to the file
                            downloadLink.href = window.URL.createObjectURL(csvFile);

                            // Hide download link
                            downloadLink.style.display = "none";

                            // Add the link to DOM
                            document.body.appendChild(downloadLink);

                            // Click download link
                            downloadLink.click();
                        }

                        /**
                         * exports the table to a CSV file
                         * @param {type} filename filename
                         * @returns {undefined} 
                         */
                        function exportTableToCSV(filename)
                        {
                            var csv = [];
                            var rows = document.querySelectorAll("table tr");

                            for (var i = 0; i < rows.length; i++)
                            {
                                var row = [], cols = rows[i].querySelectorAll("td, th");

                                for (var j = 0; j < cols.length; j++)
                                    row.push(cols[j].innerText);

                                csv.push(row.join(","));
                            }

                            // Download CSV file
                            downloadCSV(csv.join("\n"), filename);
                        }
                    </script>
                </div>
            </section>
        </div>
    </body>
</html>

