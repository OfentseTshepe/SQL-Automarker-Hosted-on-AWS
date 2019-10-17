<%-- 
    Document   : Facilitates the marking of an assessment by moving the data from the UI to the Java class
    Created on : 16 Aug 2018, 10:42:11 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
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
        <link href="./css/markLoading.css" rel="stylesheet" type="text/css">
        <title>
            Results
        </title>
    </head>
    <body onload="Javascript: redir('yes');">

        <div class="loader"></div>
        <h2>
            Marking assessment...
        </h2>
        <h3>
            Please do not exit this page
        </h3>
        <%
            //fetches parameters
            String s = request.getParameter("redir");

            //decodes the strings
            Decoder decoder = Base64.getDecoder();
            byte[] q = decoder.decode(s);
            String st = new String(q);
        %>
        <p hidden id="red" name="red">
            <%=st%>
        </p>
    </body>
</html>
<script>
    /**
     * redirects page to the marking page
     * @param {type} url
     * @returns {undefined} redirect to marking page
     */
    function redir(url)
    {
        var s = '<%=st%>';
        window.location = s;
    }
</script>