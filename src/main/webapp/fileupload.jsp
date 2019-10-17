<%-- 
    Document   : Facilitiates the uploading of a file 
    Created on : 10 Aug 2018, 7:31:05 AM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page import="java.nio.file.*"%>
<%@page import="javax.script.*"%>
<%@page import="java.nio.charset.*"%>
<%@page import="javax.script.*"%>
<%@page import="javax.script.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<html>
    <body >
        <%
            File file = null;
            int maximumFileSize = 5000 * 1024;
            int maximumMemorySize = 5000 * 1024;

            //sets file path
            String filePath = "C:\\" + "\\Users\\Zach\\Desktop\\SQLautomark\\src\\main\\resources\\";
            String contentType = request.getContentType();

            if ((contentType.indexOf("multipart/form-data") >= 0))
            {
                DiskFileItemFactory factory = new DiskFileItemFactory();
                factory.setSizeThreshold(maximumMemorySize);
                factory.setRepository(new File("c:\\temp"));
                ServletFileUpload upload = new ServletFileUpload(factory);
                upload.setSizeMax(maximumFileSize);
                try
                {
                    List fileItems = upload.parseRequest(request);
                    Iterator i = fileItems.iterator();
                    while (i.hasNext())
                    {
                        FileItem fi = (FileItem) i.next();
                        String name = fi.getName();
                        if (!fi.isFormField())
                        {
                            String fieldName = fi.getFieldName();
                            String fileName = fi.getName();
                            boolean isInMemory = fi.isInMemory();
                            long sizeInBytes = fi.getSize();
                            file = new File(filePath + name);
                            fi.write(file);
                        }
                    }
                    CreateStudents c = new CreateStudents(file);
                    boolean isValid = c.isValid();

                    if (isValid == true)
                    {
        %>
        <script>
            alert('File Upload Successful');
            window.history.back();
        </script>
        <%
            }
            if (isValid == false)
            {
        %>
        <script>
            alert('File format error, please read documentation on how file must be formatted.');
            window.history.back();
        </script>
        <%
            }

        }
        catch (Exception ex)
        {
        %>
        <script>
            alert('File Upload Error\n'<%=ex%>);
            window.history.back();
        </script>
        <%
            }
        }
        else
        {
        %>
        <script>
            alert('Error in file upload');
            window.history.back();
        </script>
        <%
            }
        %>
    </body>
    <script>
        /**
         * close window
         * @returns {undefined} closed window
         */
        function Close()
        {
            alert("Students successfully added");
            window.history.back();
        }
    </script>
</html>