<%-- 
    Document   : LogIn Class - Displays the log in screen to the user
    Created on : 02 Aug 2018, 4:21:43 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Log In</title>
        <link rel="stylesheet" type="text/css" href="./css/login.css">   
    </head>
    <body>
        <%
            //fetches parameter from header
            String s = request.getParameter("e");

            //if there is an error
            if (s != null)
            {
        %>
        <script>
            //alert the user that an error occurred
            alert('Unable to log in');
            window.location = "LogIn.jsp";
        </script>
        <%
            }
        %>

        <%--Log in box for the user to input credentials--%>
        <div class="login-box">
            <img src="avatar.png" class="avatar">
            <h1>Login</h1>
            <form>
                <p style="font-size: medium">Username</p>
                <input type="text" name="username" id="username" placeholder="Enter Username">
                <p style="font-size: medium">Password</p>
                <input type="password" name="password" id="password" placeholder="Enter Password">
                <input type="button" name="submit" value="Login" onclick="Javascript: newTab();"> 
            </form>
        </div>
    </body>
</html>

<script>
    /**
     * captures input details
     * @returns {undefined}
     */
    function newTab()
    {
        var user = document.getElementById("username").value;
        var password = document.getElementById("password").value;

        //if either of the inputs are empty
        if (user == '' || password == '')
        {
            alert('Please fill out all fields');
        }
        else
        {
            //encrypts the username and passeword and attaches it to the Log In Handler url
            var u = btoa(user);
            var p = btoa(password);
            var url = "LogInHandler.jsp?u=" + u + "&p=" + p;

            //sends to redirect
            redir(url);
        }
    }

    /**
     * sends redirect
     * @param {type} url url to redirect to
     * @returns redirection to log in handler
     */
    function redir(url)
    {
        var x = url;
        window.location = x;
    }
</script>
