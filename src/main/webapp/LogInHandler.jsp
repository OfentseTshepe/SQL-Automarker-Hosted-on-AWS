<%-- 
    Document   : LogInHandler - Handles the validation and redirection of the user log in
    Created on : 01 Sep 2018, 11:05:01 AM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page import="java.util.Base64.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Logging In...</title>
    </head>
    <body>
        <%
            //fetches parameters
            String u = request.getParameter("u");
            String p = request.getParameter("p");

            //decodes the strings
            Decoder decoder = Base64.getDecoder();
            byte[] pass = decoder.decode(p);
            byte[] us = decoder.decode(u);
            String password = new String(pass);
            String user = new String(us);

            //attempts to log the user in
            LogIn login = new LogIn(user, password);

            //fetches role of the user
            int role = login.LogInUser();

            //if user is a staff member
            if (role == 0)
            {
                response.sendRedirect("./teacherPortal.jsp?u=" + u);
            }
            //if user is a student
            else if (role == 1)
            {
                response.sendRedirect("./studentPortal.jsp?u=" + u);
            }
            //if an error occurs
            else
            {
                response.sendRedirect("./LogIn.jsp?e=error");
            }
        %>
    </body>
</html>