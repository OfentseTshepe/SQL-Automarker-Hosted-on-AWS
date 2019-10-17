<%-- 
    Document   : Front-Facing user interface for a staff member or a tutor
    Created on : 08 Aug 2018, 8:08:08 PM
    Author     : MLTZAC001, SBTELV001, TSHRIA002
--%>

<%@page import="java.sql.*"%>
<%@page import="com.csc3003s.sqlautomark.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html >
    <head>
        <meta charset="UTF-8">
        <title>
            Teacher Portal
        </title>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
        <link rel='stylesheet prefetch' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css'>
        <link href="./css/teacherPortal.css" rel="stylesheet" type="text/css">
    </head>

    <body>
        <div class="container"> 
            <section id="fancyTabWidget" class="tabs t-tabs">
                <ul class="nav nav-tabs fancyTabs" role="tablist">
                    <%--overview tab--%>
                    <li class="tab fancyTab active">    
                        <a id="tab0" href="#Overview" role="tab" aria-controls="Overview" aria-selected="true" data-toggle="tab" tabindex="0">
                            <span class="fa fa-desktop"></span>
                            <span class="hidden-xs">Overview</span>
                        </a>
                    </li>
                    <%--create assignment tab--%>
                    <li class="tab fancyTab">
                        <a id="tab1" href="#Create" role="tab" aria-controls="Create" aria-selected="true" data-toggle="tab" tabindex="0" onclick="JavaScript:newTab('');">
                            <span class="fa fa-firefox"></span>
                            <span class="hidden-xs">Create</span>
                        </a>
                    </li>

                    <%--this tab has been disabled but would allow for a data-file upload for the user. 
                        it has not been included due to the ambiguous nature of uploading a csv file without a format--%>

                    <%--<li class="tab fancyTab">
                        <a id="tab2" href="#Data" role="tab" aria-controls="Data" aria-selected="true" data-toggle="tab" tabindex="0">
                            <span class="fa fa-envira"></span>
                            <span class="hidden-xs">Data</span>
                        </a>
                    </li>--%>

                    <%--students tab--%>
                    <li class="tab fancyTab">
                        <a id="tab3" href="#Students" role="tab" aria-controls="Students" aria-selected="true" data-toggle="tab" tabindex="0" onclick="openTab(event, 'Student Overview')">
                            <span class="fa fa-mortar-board"></span>
                            <span class="hidden-xs">Students</span>
                        </a>
                    </li> 
                    <%--marks tab--%>
                    <li class="tab fancyTab">
                        <a id="tab4" href="#Marks" role="tab" aria-controls="Marks" aria-selected="true" data-toggle="tab" tabindex="0">
                            <span class="fa fa-stack-overflow"></span>
                            <span class="hidden-xs">Marks</span>
                        </a>
                    </li>
                </ul>

                <%--overview tab content--%>
                <div id="myTabContent" class="tab-content fancyTabContent" aria-live="polite">
                    <div class="tab-pane  fade active in" id="Overview" role="tabpanel" aria-labelledby="tab0" aria-hidden="true" tabindex="0">
                        <div>
                            <div class="row">
                                <%--shortcut buttons--%>
                                <table class="table" id="table2">
                                    <tr>
                                        <td>
                                    <center>
                                        <Button class="button" id="b1" onclick="move('Add Students')">
                                            Add Students
                                        </Button>
                                    </center>
                                    </td>
                                    <td>
                                    <center>
                                        <Button class="button" id="b1" onclick="move('View Students')">
                                            View Students
                                        </Button>
                                    </center>
                                    </td>
                                    <td>
                                    <center>
                                        <Button class="button" id="b1" onclick="move('Remove Students')">
                                            Remove Students
                                        </Button>
                                    </center>
                                    </td>
                                    </tr>
                                </table>
                                <br>
                                <%--shortcut buttons--%>
                                <table class="table" id="table2">
                                    <tr>
                                        <td>
                                    <center>
                                        <Button class="button" id="b1" onclick="move('Create Assessment')">
                                            Create Assessment
                                        </Button>
                                    </center>
                                    </td>
                                    <td>
                                    <center>
                                        <Button class="button" id="b1" onclick="move('View Results')">
                                            View Results
                                        </Button>
                                    </center>
                                    </td>
                                    </tr>
                                </table>
                            </div>
                            <center>
                                <h4>
                                    Assessments
                                </h4>
                            </center>
                            <%--summary of available assessments--%>
                            <table>
                                <tr>
                                    <td>
                                        ID
                                    </td>
                                    <td>
                                        Name
                                    </td>
                                    <td>
                                        Type
                                    </td>
                                    <td>
                                        Database
                                    </td>
                                    <td>
                                        Questions
                                    </td>
                                    <td>
                                        Cat A
                                    </td>
                                    <td>
                                        Cat B
                                    </td>
                                    <td>
                                        Cat C
                                    </td>
                                    <td>
                                        Cat D
                                    </td>
                                    <td>
                                        Cat E
                                    </td>
                                    <td>
                                        Cat F
                                    </td>
                                    <td>
                                        Cat G
                                    </td>
                                    <td>
                                        Start Date
                                    </td>
                                    <td>
                                        End Date
                                    </td>
                                    <td>
                                        Total Marks
                                    </td>
                                    <td>
                                        Attempts
                                    </td>
                                </tr>

                                <%
                                    //initiates connection with MySQL database server
                                    Connection connection = new SQL().getConnection();
                                    Statement statement = connection.createStatement();

                                    statement.addBatch("use `sqlautomarker`;");
                                    statement.executeBatch();

                                    //fetches all assessments
                                    ResultSet rs = statement.executeQuery("SELECT * FROM assessments");
                                    int x = 0;

                                    while (rs.next())
                                    {
                                        //fetches relevant parameters
                                        String id = rs.getString("assessmentID");
                                        String name = rs.getString("assessment_name");
                                        String type = rs.getString("assessment_type");
                                        String db = rs.getString("question_database");
                                        String totQ = rs.getString("total_questions");

                                        String catA = rs.getString("category_a");
                                        String catB = rs.getString("category_b");
                                        String catC = rs.getString("category_c");
                                        String catD = rs.getString("category_d");
                                        String catE = rs.getString("category_e");
                                        String catF = rs.getString("category_f");
                                        String catG = rs.getString("category_g");

                                        String startDate = rs.getString("start_date");
                                        String startTime = rs.getString("start_time");
                                        String start = startDate + " " + startTime;

                                        String endDate = rs.getString("end_date");
                                        String endTime = rs.getString("end_time");
                                        String end = endDate + " " + endTime;

                                        String marks = rs.getString("total_marks");
                                        String totAttempts = rs.getString("attempts");
                                %>
                                <%--populates table--%>
                                <tr>
                                    <td>
                                        <%=id%>
                                    </td>
                                    <td>
                                        <%=name%>
                                    </td>
                                    <td>
                                        <%=type%>
                                    </td>
                                    <td>
                                        <%=db%>
                                    </td>
                                    <td>
                                        <%=totQ%>
                                    </td>
                                    <td>
                                        <%=catA%>
                                    </td>
                                    <td>
                                        <%=catB%>
                                    </td>
                                    <td>
                                        <%=catC%>
                                    </td>
                                    <td>
                                        <%=catD%>
                                    </td>
                                    <td>
                                        <%=catE%>
                                    </td>
                                    <td>
                                        <%=catF%>
                                    </td>
                                    <td>
                                        <%=catG%>
                                    </td>
                                    <td>
                                        <%=start%>
                                    </td>
                                    <td>
                                        <%=end%>
                                    </td>
                                    <td>
                                        <%=marks%>
                                    </td>
                                    <td>
                                        <%=totAttempts%>
                                    </td>
                                </tr>
                                <%
                                        x++;
                                    }
                                %>
                            </table>
                        </div>
                    </div>

                    <%--this would be where the csv file data upload would occur for adding new databases--%>
                    <%-- <div class="tab-pane  fade" id="Data" role="tabpanel" aria-labelledby="tab2" aria-hidden="true" tabindex="0">
                         <div class="row">
                             <div class="col-md-12">
                                 <h5>Please select a data file to upload</h5>
                                 <br>
                                 <form id = "addStudent" action="DataFileUpload.jsp" method="post" enctype="multipart/form-data"  target="_blank">
                                     <input id = "file" type="file" name="file" size="50" />
                                     <br><br>
                                    <center><button class="button" id="b1" onclick="submit()">Upload File</button></center>
                                    <br>
                                </form>
                            </div>
                        </div>
                    </div>--%>

                    <div class="tab-pane  fade" id="Students" role="tabpanel" aria-labelledby="tab3" aria-hidden="true" tabindex="0">
                        <div class="row">
                            <div class="col-md-12">
                                <br>
                                <center>
                                    <h2>
                                        Students
                                    </h2>
                                </center>
                                <br>
                                <%--student tab contents--%>
                                <div class="tab">
                                    <a id="view_students"  href="JavaScript:newPopup('/javascript/examples/sample_popup.cfm');" target="popup" >
                                    </a>
                                    <button id="assessments" class="tablinks" onclick="openTab(event, 'Student Overview')" id="defaultOpen">
                                        Student Overview
                                    </button>
                                    <button id="add_student" class="tablinks" onclick="openTab(event, 'Add Students')">
                                        Add Students
                                    </button>
                                    <button id="grades" class="tablinks" onclick="openTab(event, 'Remove Students')">
                                        Remove Students
                                    </button>
                                </div>
                                <%--student overview tab--%>
                                <div id="Student Overview" class="tabcontent">
                                    <table class="table" id="table2">
                                        <tr>
                                        <br>
                                        <td>
                                            <button id="b1" class="button" onclick="move('View Students')">
                                                View Students
                                            </button>
                                        </td>
                                        <td>
                                            <button id="b1" class="button" onclick="move('Add Students')">
                                                Add Students
                                            </button>
                                        </td>
                                        <td>
                                            <button id="b1" class="button"onclick="move('Remove Students')">
                                                Remove Students
                                            </button>
                                        </td>
                                        </tr>
                                    </table>
                                </div>
                                <%--add students tab--%>
                                <div id="Add Students" class="tabcontent">
                                    <h5>
                                        Please select a file to upload
                                    </h5>
                                    <br>
                                    <form id = "addStudent" action="fileupload.jsp" method="post" enctype="multipart/form-data" >
                                        <input id = "file" type="file" name="file" size="50" />
                                        <br>
                                        <br>
                                        <center>
                                            <button class="button" id="b1" onclick="submit()">
                                                Upload File
                                            </button>
                                        </center>
                                        <br>
                                    </form>
                                </div>
                                <%--remove students tab--%>
                                <div id="Remove Students" class="tabcontent">
                                    <table class="table" id="table2" >
                                        <tr>
                                        <br>
                                        <td>
                                        <center>
                                            <button id="b1" class="button" onclick="removeIndividual()">
                                                Remove All Students
                                            </button>
                                        </center>
                                        </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%--marks tab--%>
                    <div class="tab-pane  fade" id="Marks" role="tabpanel" aria-labelledby="tab4" aria-hidden="true" tabindex="0">
                        <div class="row">
                            <div class="col-md-12">
                                <%--table to display assessments--%>
                                <table  class="table" id="table2">
                                    <tr>
                                        <td style="font-size: medium;">
                                            Assessment Name
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <%
                                        //creates new connection to MySQL database server
                                        connection = new SQL().getConnection();

                                        statement = connection.createStatement();
                                        statement.addBatch("use `marks`;");
                                        statement.executeBatch();

                                        //fetch all assessments
                                        rs = statement.executeQuery("SHOW TABLES;");
                                        int y = 0;

                                        //traverse result set
                                        while (rs.next())
                                        {
                                            String name = rs.getString(1);
                                    %>
                                    <tr>
                                        <%--populate table cells--%>
                                        <td style="font-size: medium; " name="name" id="name">
                                            <%=name%>
                                        </td>
                                        <td>
                                    <center>
                                        <button onclick="Javascript: marks('<%=name%>')" class="button" id="b1">
                                            View Marks
                                        </button>
                                    </center>
                                    </td>
                                    </tr>
                                    <%
                                            y++;
                                        }
                                    %>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <script>

            /**
             * move from shortcut to a tab
             * @param {type} link tab name 
             * @returns {undefined} tab changed
             */
            function move(link)
            {
                if (link == 'Remove Students')
                {
                    document.getElementById("tab3").click();
                    document.getElementById("remove_student").click();
                }
                if (link == 'View Students')
                {
                    viewStudent();
                }
                if (link == 'Add Students')
                {
                    document.getElementById("tab3").click();
                    document.getElementById("add_student").click();
                }
                if (link == 'Upload New Questions')
                {
                    document.getElementById("tab2").click();
                }
                if (link == 'Create Assessment')
                {
                    document.getElementById("tab1").click();
                }
                if (link == 'View Results')
                {
                    document.getElementById("tab4").click();
                }
            }

            /**
             * opens the "create assessment" page
             * @param {type} name 
             * @returns create assessment page
             */
            function newTab(name)
            {
                var url = "createAssessment.jsp?";
                window.location = url;
            }

            /**
             * view marks 
             * @param {type} name assessment name
             * @returns marks page
             */
            function marks(name)
            {
                var url = btoa(name);
                var s = "ViewMarks.jsp?a=" + url;
                window.location = s;
            }

            //set default tab to the overview tab
            document.getElementById("Overview").click();

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
             * creates pop up to view students
             * @param {type} url
             * @returns {undefined}
             */
            function newPopup(url)
            {
                popupWindow = window.open(
                        "viewStudents.jsp", 'popUpWindow', 'height=700,width=600,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
            }

            /**
             * removes all students from database
             * @returns students removed
             */
            function removeIndividual()
            {
                //prompt user 
                var b = confirm("Are you sure you want to remove all students?");

                //if user selects yes
                if (b == true)
                {
                    popupWindow = window.open("removeStudents.jsp", 'popUpWindow', 'height=500,width=500,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes');
                }
            }

            /**
             * views student
             * @returns view student pop up
             */
            function viewStudent()
            {
                window.location = document.getElementById('view_students').href;
                newPopup('');
            }

            /**
             * checks whether a file has been selected. if no file has been selecten
             * @returns valid file
             */
            function submit()
            {
                if (document.getElementById("file").files.length == 0)
                {
                    alert("no files selected");
                }
            }
        </script>
        <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
        <script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js'></script>
        <script src="../AppData/Local/Temp/Rar$DRa23848.1403/js/index.js"></script>
    </body>
</html>

