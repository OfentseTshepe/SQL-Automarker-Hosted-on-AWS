<%-- 
    Document   : Views the users existing in the database
    Created on : 08 Aug 2018, 8:08:08 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="java.sql.*"%>
<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>
            View Users
        </title>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css'>
        <link href="./css/viewStudents.css" rel="stylesheet" type="text/css">
    </head>
    <%

        //initiates connection with MySQL database server
        Connection connection = new SQL().getConnection();
        Statement statement = connection.createStatement();
        statement.addBatch("use `preloaded-option-1`;");
        statement.executeBatch();

    %>
    <body>
        <div class="container"> 
            <section id="fancyTabWidget" class="tabs t-tabs">
                <div id="myTabContent" class="tab-content fancyTabContent" aria-live="polite">
                    <div class="tab-pane  fade active in" id="tabBody0" role="tabpanel" aria-labelledby="tab0" aria-hidden="false" tabindex="0">
                        <div class="row">
                            <div class="col-md-12">
                                <center>
                                    <h2>
                                        Users
                                    </h2>
                                </center>
                                <center>
                                    <button id="b2" class="button" onclick="window.location.reload(true);">
                                        Refresh
                                    </button> 
                                </center>
                                <br>
                                <br>
                                <div class="pane pane--table1">
                                    <div class="pane-hScroll">
                                        <table id ="t01">
                                            <thead>
                                            <th>Name</th>
                                            <th>Student Number</th>
                                            <th>Role</th>
                                            </thead>
                                        </table>
                                        <%--populates table cells--%>
                                        <div class="pane-vScroll">
                                            <table id ="t01">
                                                <%                                                        //fetches all users
                                                    ResultSet resultset = statement.executeQuery("SELECT * FROM  `sqlautomarker`.`Users` u ORDER BY Role asc, UserID asc;");

                                                    while (resultset.next())
                                                    {
                                                %>
                                                <tr>
                                                    <td> <%= resultset.getString("Name")%> </td>
                                                    <td> <%= resultset.getString("UserID")%> </td>
                                                    <td> <%= resultset.getString("Role")%> </td>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <script type="text/javascript">
            /**
             * reloads page
             * @type type 
             */
            funcion reload()
            {
                window.location.reload();
            }
        </script>
    </body>
</html>

