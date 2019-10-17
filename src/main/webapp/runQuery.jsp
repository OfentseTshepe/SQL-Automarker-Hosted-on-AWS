<%-- 
    Document   : Runs a query for the student to check his/her statement
    Created on : 16 Aug 2018, 12:08:31 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="java.util.*"%>
<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Base64.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="./css/runQuery.css" rel="stylesheet" type="text/css">
        <title>
            Query
        </title>
    </head>
    <body>
        <div class="container"> 
            <section id="fancyTabWidget" class="tabs t-tabs">
                <div id="myTabContent" class="tab-content fancyTabContent" aria-live="polite">
                    <%
                        //fetches parameters
                        String s = request.getParameter("string");
                        String d = request.getParameter("database");

                        //decodes the strings
                        Decoder decoder = Base64.getDecoder();
                        byte[] q = decoder.decode(s);
                        byte[] data = decoder.decode(d);
                        String database = new String(data);
                        String decodedString = new String(q);

                        //initiates connection with the MySQL database
                        Connection connection = new SQL().getConnection();
                        Statement statement = connection.createStatement();

                        //use the database of the assessment
                        statement.addBatch("use `" + database + "`;");
                        statement.executeBatch();

                        try
                        {

                            ResultSet rs = statement.executeQuery(decodedString);
                            ResultSetMetaData rsm = rs.getMetaData();

                            //fetches the number of columns
                            int columnsNumber = rsm.getColumnCount();
                            ArrayList<String> col = new ArrayList<String>();

                    %>
                    <%--creates table to display query output--%>
                    <table>
                        <%                            //loop for the number of columns
                            for (int i = 1; i < columnsNumber + 1; i++)
                            {
                                //fetches the label of the column and adds it to the list
                                String st = rsm.getColumnLabel(i);
                                col.add(st);
                        %>
                        <%--adds column to table header--%>
                        <th>
                            <%=st%>
                        </th>
                        <%
                            }

                            //traverses through result set
                            while (rs.next())
                            {
                        %>
                        <tr>
                            <%
                                for (int i = 0; i < columnsNumber; i++)
                                {
                                    String ent = rs.getString(col.get(i));
                            %>
                            <td>
                                <%=ent%>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                    <%
                    }
                    catch (SQLException e)
                    {
                    %>
                    <%--if an error occurs in the statement, the user will be notified that an error has occurred--%>
                    <h1 style="text-align: center">
                        SQL Error
                    </h1>
                    <%
                        }
                    %>
                    <br>
                    <br>
                    <div>
                        <table style="border: 0px none;"> 
                            <td style="text-align: center; border: 0px none;">
                                <button id="b2" class="button" onclick="closeWindow()">
                                    Close
                                </button>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </body>
    <script>
        /**
         * closes window
         * @returns {undefined} closed window
         */
        function closeWindow()
        {
            close();
        }
    </script>
</html>
