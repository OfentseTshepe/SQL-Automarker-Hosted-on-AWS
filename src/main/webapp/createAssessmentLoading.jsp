<%-- 
    Document   : Creates an assessment using the information from the UI
    Created on : 16 Aug 2018, 10:42:11 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page import="java.time.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Base64.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="./css/createAssessmentLoading.css" rel="stylesheet" type="text/css">
        <title>Results</title>
    </head>
    <body>
        <div class="loader">
        </div>
    <center>
        <h2 id="head" style="color: white;">
            Creating assessment...
        </h2>
    </center>
    <h3 style="color: white;">
        Please do not exit this page
    </h3>
    <%
        //fetches parameters
        String n = request.getParameter("n");
        String t = request.getParameter("t");
        String db = request.getParameter("db");
        String nQ = request.getParameter("nQ");
        String tM = request.getParameter("tM");
        String cA = request.getParameter("cA");
        String cB = request.getParameter("cB");
        String cC = request.getParameter("cC");
        String cD = request.getParameter("cD");
        String cE = request.getParameter("cE");
        String cF = request.getParameter("cF");
        String cG = request.getParameter("cG");
        String at = request.getParameter("at");
        String sD = request.getParameter("sD");
        String sT = request.getParameter("sT");
        String eD = request.getParameter("eD");
        String eT = request.getParameter("eT");

        //decodes the strings
        Decoder decoder = Base64.getDecoder();
        byte[] name = decoder.decode(n);
        byte[] type = decoder.decode(t);
        byte[] data = decoder.decode(db);
        byte[] numQ = decoder.decode(nQ);
        byte[] totM = decoder.decode(tM);
        byte[] catA = decoder.decode(cA);
        byte[] catB = decoder.decode(cB);
        byte[] catC = decoder.decode(cC);
        byte[] catD = decoder.decode(cF);
        byte[] catE = decoder.decode(cE);
        byte[] catF = decoder.decode(cF);
        byte[] catG = decoder.decode(cG);
        byte[] numAt = decoder.decode(at);
        byte[] startD = decoder.decode(sD);
        byte[] startT = decoder.decode(sT);
        byte[] endD = decoder.decode(eD);
        byte[] endT = decoder.decode(eT);

        String assessmentName = new String(name);
        String assessmentType = new String(type);
        String database = new String(data);
        int questions = Integer.parseInt(new String(numQ));
        int totalMarks = Integer.parseInt(new String(totM));
        int A = Integer.parseInt(new String(catA));
        int B = Integer.parseInt(new String(catB));
        int C = Integer.parseInt(new String(catC));
        int D = Integer.parseInt(new String(catD));
        int E = Integer.parseInt(new String(catE));
        int F = Integer.parseInt(new String(catF));
        int G = Integer.parseInt(new String(catG));
        int numAttempts = Integer.parseInt(new String(numAt));
        LocalDate startDate = LocalDate.parse(new String(startD));
        LocalTime startTime = LocalTime.parse(new String(startT));
        LocalDate endDate = LocalDate.parse(new String(endD));
        LocalTime endTime = LocalTime.parse(new String(endT));

        ArrayList<String> arr = new ArrayList<String>();

        //fetches list of all assessments in the database
        String sql = "SELECT assessment_name FROM `sqlautomarker`.`assessments`;";

        //initiates a connection with the MySQL database
        Connection connection = new SQL().getConnection();
        Statement statement = connection.createStatement();
        ResultSet rs = statement.executeQuery(sql);

        //traverses through the result set
        while (rs.next())
        {
            arr.add(rs.getString("assessment_name"));
        }

        boolean exists = false;
        boolean over = false;

        String count = "select count(*) from `" + database + "`.`questions` where category ='A' UNION ALL select count(*) from `" + database + "`.`questions` where category ='B' UNION ALL "
                + "select count(*) from `" + database + "`.`questions` where category ='C' UNION ALL select count(*) from `" + database + "`.`questions` where category ='D' UNION ALL "
                + "select count(*) from `" + database + "`.`questions` where category ='E' UNION ALL select count(*) from `" + database + "`.`questions` where category ='F' UNION ALL "
                + "select count(*) from `" + database + "`.`questions` where category ='G';";

        rs = statement.executeQuery(count);
        ArrayList<Integer> counting = new ArrayList<Integer>();

        while (rs.next())
        {
            counting.add(Integer.parseInt(rs.getString(1)));
        }

        ArrayList<String> counter = new ArrayList<String>();
        if (counting.get(0) < A)
        {
            counter.add("A");
            over = true;
        }
        if (counting.get(1) < B)
        {
            counter.add("B");
            over = true;
        }
        if (counting.get(2) < C)
        {
            counter.add("C");
            over = true;
        }
        if (counting.get(3) < D)
        {
            counter.add("D");
            over = true;
        }
        if (counting.get(4) < E)
        {
            counter.add("E");
            over = true;
        }
        if (counting.get(5) < F)
        {
            counter.add("F");
            over = true;
        }
        if (counting.get(6) < G)
        {
            counter.add("G");
            over = true;
        }
        //traverses all assessment names looking for one with the same name
        for (String elem : arr)
        {
            //if the name exists
            if (assessmentName.equals(elem))
            {
                exists = true;
            }
        }

        //if the number of questions in a category exceeds the number available
        if (over == true)
        {
    %>
    <script>
        //alerts the user of an error
        alert('The following categories exceed the available questions <%=counter.toString()%>');
        document.getElementById("head").innerHTML = "Redirecting to Create Assessment page...";

        //redirects to the Create Assessment page
        window.history.back();
    </script>
    <%
        }

        //if the assessment already exists
        if (exists == true)
        {
    %>
    <script>
        //alerts the user of a duplicate
        alert('An assessment already exists with the name <%=assessmentName%>');
        document.getElementById("head").innerHTML = "Redirecting to Create Assessment page...";

        //redirects to the Create Assessment page
        window.history.back();
    </script>
    <%
        }
        //if there is no matching assessment name
        if (exists == false && over == false)
        {
           Assessment ass = new Assessment(assessmentName, assessmentType, database, questions, totalMarks, A, B, C, D, E, F, G, numAttempts, startDate, startTime, endDate, endTime);
    %>
    <script>
        //alerts the user that the assignment has been created
        alert('Assessment created successfully');
        document.getElementById("head").innerHTML = "Redirecting to Teacher Portal...";
        //redirects to the Teacher Portal page            
        window.location = 'teacherPortal.jsp?';
    </script>
    <%
        }
    %>
</body>
</html>
