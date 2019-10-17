<%-- 
    Document   : Removes all students from the database
    Created on : 01 Sep 2018, 4:21:58 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="./css/removeStudents.css" rel="stylesheet" type="text/css">
        <title>
            Removing students...
        </title>
    </head>
    <body>
        <div class="loader">
        </div>
        <h2>
            Removing students...
        </h2>
        <h3>
            Please do not exit this page
        </h3>
        <%
            //initiates connection to the MySQL database
            Connection connection = new SQL().getConnection();
            Statement statement = connection.createStatement();

            //fetches all information of all students from the database
            String s = "SELECT * FROM `sqlautomarker`.`Users` WHERE Role='Student';";
            ResultSet rs = statement.executeQuery(s);

            //traverses through the data set
            if (rs.next())
            {
                //calls the students class
                new RemoveStudents(connection);
        %>
        <script>
            //alerts the user
            alert('Students removed');
            //closes the window
            window.close();
        </script>
        <%
        }
        else
        {
        %>
        <script>
            //alerts the user        
            alert('No students exist in the database');
            //closes the window        
            window.close();
        </script>
        <%
            }
        %>
    </body>
</html>
