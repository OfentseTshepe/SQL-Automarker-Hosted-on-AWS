package com.csc3003s.sqlautomark;

import java.sql.*;
import java.time.*;
import java.util.*;

/**
 * Assessment class that assigns assessments to users based on the database set
 * of questions
 *
 * @author MLTZAC001
 * @author SBTELV001
 * @author TSHRIA002
 */
public class Assessment
{

    private int ID;
    private String name;
    private String type;
    private String database;
    private int questions;
    private int totalMarks;
    private int catA;
    private int catB;
    private int catC;
    private int catD;
    private int catE;
    private int catF;
    private int catG;
    private LocalDate startDate;
    private LocalTime startTime;
    private LocalDate endDate;
    private LocalTime endTime;
    private int attempts;
    private ArrayList<Question> question;
    private ArrayList<String> students;

    private Connection connection;

    /**
     * Constructor method
     *
     * @param name assessment name
     * @param type assessment type
     * @param database database name
     * @param questions number of questions
     * @param marks total marks
     * @param catA number of questions from category A
     * @param catB number of questions from category B
     * @param catC number of questions from category C
     * @param catD number of questions from category D
     * @param catE number of questions from category E
     * @param catF number of questions from category F
     * @param catG number of questions from category G
     * @param attempts number of attempts allowed
     * @param startDate start date
     * @param startTime start time
     * @param endDate end date
     * @param endTime end time
     */
    public Assessment(String name, String type, String database, int questions, int marks, int catA, int catB, int catC, int catD, int catE, int catF, int catG, int attempts, LocalDate startDate, LocalTime startTime, LocalDate endDate, LocalTime endTime)
    {
        //initiates connection with MySQL database
        this.connection = new SQL().getConnection();

        this.name = name;
        this.type = type;
        this.database = database;
        this.questions = questions;
        this.totalMarks = marks;
        this.catA = catA;
        this.catB = catB;
        this.catC = catC;
        this.catD = catD;
        this.catE = catE;
        this.catF = catF;
        this.catG = catG;
        this.attempts = attempts;
        this.startDate = startDate;
        this.startTime = startTime;
        this.endDate = endDate;
        this.endTime = endTime;

        this.question = new ArrayList<Question>();
        this.students = new ArrayList<String>();

        fetchStudents();
        createAssessment();
        createSummary();
    }

    /**
     * Empty constructor method
     */
    public Assessment()
    {

    }

    /**
     * Assigns questions to students
     */
    public void assign()
    {
        try
        {
            Statement statement = connection.createStatement();
            statement.addBatch("use `" + database + "`;");
            statement.executeBatch();

            //fetches all questions
            ResultSet resultset = statement.executeQuery("SELECT * FROM questions;");

            while (resultset.next())
            {
                int questionNumber = Integer.parseInt(resultset.getString("questionNumber"));
                String question = resultset.getString("question");
                String expectedAnswer = resultset.getString("expectedAnswer");
                String category = resultset.getString("category");
                int marks = Integer.parseInt(resultset.getString("marks"));

                //creates new question element
                Question q = new Question(questionNumber, question, expectedAnswer, category, marks);

                //adds question to list
                this.question.add(q);
            }

            statement.addBatch("use `sqlautomarker-individual-records`;");
            statement.executeBatch();

            Statement statement2 = connection.createStatement();

            statement.addBatch("use `" + database + "`;");
            statement.executeBatch();

            //traverse through students
            for (String student : students)
            {
                ArrayList<Integer> A = new ArrayList<Integer>();
                ArrayList<Integer> B = new ArrayList<Integer>();
                ArrayList<Integer> C = new ArrayList<Integer>();
                ArrayList<Integer> D = new ArrayList<Integer>();
                ArrayList<Integer> E = new ArrayList<Integer>();
                ArrayList<Integer> F = new ArrayList<Integer>();
                ArrayList<Integer> G = new ArrayList<Integer>();

                //if there are questions from category A
                if (catA != 0)
                {
                    //fetches random questions from the category
                    String catA = "SELECT questionNumber FROM questions WHERE category='A'"
                            + "ORDER BY RAND()"
                            + "LIMIT " + this.catA + ";";

                    ResultSet rs = statement.executeQuery(catA);

                    //traverses result set
                    while (rs.next())
                    {
                        A.add(Integer.parseInt(rs.getString("questionNumber")));
                    }
                }

                //if there are questions from category B
                if (catB != 0)
                {
                    //fetches random questions from the category
                    String catB = "SELECT questionNumber FROM questions WHERE category='B'"
                            + "ORDER BY RAND()"
                            + "LIMIT " + this.catB + ";";

                    ResultSet rs = statement.executeQuery(catB);

                    //traverses result set
                    while (rs.next())
                    {
                        B.add(Integer.parseInt(rs.getString("questionNumber")));
                    }
                }

                //if there are questions from category C
                if (catC != 0)
                {
                    //fetches random questions from the category
                    String catC = "SELECT questionNumber FROM questions WHERE category='C'"
                            + "ORDER BY RAND()"
                            + "LIMIT " + this.catC + ";";

                    ResultSet rs = statement.executeQuery(catC);

                    //traverses result set
                    while (rs.next())
                    {
                        C.add(Integer.parseInt(rs.getString("questionNumber")));
                    }
                }

                //if there are questions from category D
                if (catD != 0)
                {
                    //fetches random questions from the category
                    String catD = "SELECT questionNumber FROM questions WHERE category='D'"
                            + "ORDER BY RAND()"
                            + "LIMIT " + this.catD + ";";

                    ResultSet rs = statement.executeQuery(catD);

                    //traverses result set
                    while (rs.next())
                    {
                        D.add(Integer.parseInt(rs.getString("questionNumber")));
                    }
                }

                //if there are questions from category E
                if (catE != 0)
                {
                    //fetches random questions from the category
                    String catE = "SELECT questionNumber FROM questions WHERE category='E'"
                            + "ORDER BY RAND()"
                            + "LIMIT " + this.catE + ";";

                    ResultSet rs = statement.executeQuery(catE);

                    //traverses result set
                    while (rs.next())
                    {
                        E.add(Integer.parseInt(rs.getString("questionNumber")));
                    }
                }

                //if there are questions from category F
                if (catF != 0)
                {
                    //fetches random questions from the category
                    String catF = "SELECT questionNumber FROM questions WHERE category='F'"
                            + "ORDER BY RAND()"
                            + "LIMIT " + this.catF + ";";

                    ResultSet rs = statement.executeQuery(catF);

                    //traverses result set
                    while (rs.next())
                    {
                        F.add(Integer.parseInt(rs.getString("questionNumber")));
                    }
                }

                //if there are questions from category A
                if (catG != 0)
                {
                    //fetches random questions from the category
                    String catG = "SELECT questionNumber FROM questions WHERE category='G'"
                            + "ORDER BY RAND()"
                            + "LIMIT " + this.catG + ";";

                    ResultSet rs = statement.executeQuery(catG);

                    //traverses result set
                    while (rs.next())
                    {
                        G.add(Integer.parseInt(rs.getString("questionNumber")));
                    }
                }

                //creates and assigns individual student record
                String create = "CREATE TABLE `sqlautomarker-individual-records`.`" + student + "-" + name + "` ("
                        + "`questionID` INT NOT NULL AUTO_INCREMENT,"
                        + "`database` VARCHAR(45) NULL,"
                        + "`questionReference` INT NULL,"
                        + "`question` VARCHAR(1000) NULL,"
                        + "`studentAnswer` VARCHAR(500) NULL,"
                        + "`studentMarks` INT NULL,"
                        + "`category` VARCHAR(1) NULL,"
                        + "`totalMarks` INT NULL,"
                        + "PRIMARY KEY (`questionID`));";

                statement2.addBatch(create);

                for (int i = 0; i < this.catA; i++)
                {
                    int x = A.get(i);

                    //insert question record into database
                    String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + student + "-" + name + "` "
                            + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                            + "VALUES ('" + database + "', '" + x + "', '" + question.get(x - 1).getQuestion() + "', null, null, 'A');";

                    statement2.addBatch(sql);
                }

                for (int i = 0; i < catB; i++)
                {
                    int x = B.get(i);

                    //insert question record into database
                    String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + student + "-" + name + "` "
                            + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                            + "VALUES ('" + database + "', '" + x + "', '" + question.get(x - 1).getQuestion() + "', null, null, 'B');";

                    statement2.addBatch(sql);
                }

                for (int i = 0; i < catC; i++)
                {
                    int x = C.get(i);

                    //insert question record into database
                    String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + student + "-" + name + "` "
                            + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                            + "VALUES ('" + database + "', '" + x + "', '" + question.get(x - 1).getQuestion() + "', null, null, 'C');";

                    statement2.addBatch(sql);
                }

                for (int i = 0; i < catD; i++)
                {
                    int x = D.get(i);

                    //insert question record into database
                    String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + student + "-" + name + "` "
                            + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                            + "VALUES ('" + database + "', '" + x + "', '" + question.get(x - 1).getQuestion() + "', null, null, 'D');";

                    statement2.addBatch(sql);
                }

                for (int i = 0; i < catE; i++)
                {
                    int x = E.get(i);

                    //insert question record into database
                    String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + student + "-" + name + "` "
                            + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                            + "VALUES ('" + database + "', '" + x + "', '" + question.get(x - 1).getQuestion() + "', null, null, 'E');";

                    statement2.addBatch(sql);
                }

                for (int i = 0; i < catF; i++)
                {
                    int x = F.get(i);

                    //insert question record into database
                    String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + student + "-" + name + "` "
                            + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                            + "VALUES ('" + database + "', '" + x + "', '" + question.get(x - 1).getQuestion() + "', null, null, 'F');";

                    statement2.addBatch(sql);
                }

                for (int i = 0; i < catG; i++)
                {
                    int x = G.get(i);

                    //insert question record into database
                    String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + student + "-" + name + "` "
                            + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                            + "VALUES ('" + database + "', '" + x + "', '" + question.get(x - 1).getQuestion() + "', null, null, 'G');";

                    statement2.addBatch(sql);
                }
                statement2.executeBatch();
            }
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }

    /**
     * creates a summary of the assignment in the marks database
     */
    public void createSummary()
    {
        try
        {
            Statement statement = connection.createStatement();

            statement.addBatch("use `marks`;");
            statement.executeBatch();

            //creates summary table
            String create = "CREATE TABLE `marks`.`" + this.name + "` ("
                    + "  `studentNumber` VARCHAR(9) NOT NULL,"
                    + "  `attemptsLeft` INT NOT NULL,"
                    + "  `marks` double DEFAULT 0,"
                    + "  PRIMARY KEY (`studentNumber`));";

            statement.addBatch(create);
            statement.executeBatch();

            //traverse through students
            for (String student : students)
            {
                //insert each student into the table
                String sql = "INSERT INTO `marks`.`" + name + "` "
                        + "(`studentNumber`, `attemptsLeft`) "
                        + "VALUES ('" + student + "', '" + attempts + "');";
                statement.addBatch(sql);
            }

            statement.executeBatch();
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }

    /**
     * fetch all students from database
     */
    public void fetchStudents()
    {
        try
        {
            Statement statement = connection.createStatement();

            statement.addBatch("use `sqlautomarker`;");
            statement.executeBatch();
            ResultSet resultset = statement.executeQuery("SELECT * FROM Users WHERE Role='Student';");

            while (resultset.next())
            {
                String name = resultset.getString("UserID");
                students.add(name);
            }
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }

    /**
     * reassigns assessment to user if s/he wants to try again
     *
     * @param user student number
     * @param Assessment assessment name
     * @param database database name
     */
    public void updateAssessment(String user, String Assessment, String database)
    {
        ArrayList<Question> quest = new ArrayList<Question>();

        try
        {
            //initiates connection with MySQL database
            Connection connection = new SQL().getConnection();
            Statement statement = connection.createStatement();

            statement.addBatch("use `sqlautomarker`;");
            statement.executeBatch();

            //fetch information from assessment record in the assessment database
            String as = "SELECT * FROM assessments WHERE assessment_name = '" + Assessment + "';";

            ResultSet r = statement.executeQuery(as);
            r.next();

            int a = Integer.parseInt(r.getString("category_a"));
            int b = Integer.parseInt(r.getString("category_b"));
            int c = Integer.parseInt(r.getString("category_c"));
            int d = Integer.parseInt(r.getString("category_d"));
            int e = Integer.parseInt(r.getString("category_e"));
            int f = Integer.parseInt(r.getString("category_f"));
            int g = Integer.parseInt(r.getString("category_g"));

            statement.addBatch("use `sqlautomarker-individual-records`;");
            statement.executeBatch();

            //removes table from the database
            String drop = "DROP TABLE `sqlautomarker-individual-records`.`" + user + "-" + Assessment + "`;";
            statement.addBatch(drop);
            statement.executeBatch();

            statement.addBatch("use `" + database + "`;");
            statement.executeBatch();
            ResultSet resultset = statement.executeQuery("SELECT * FROM questions;");

            //traverse through result set
            while (resultset.next())
            {
                int questionNumber = Integer.parseInt(resultset.getString("questionNumber"));
                String question = resultset.getString("question");
                String expectedAnswer = resultset.getString("expectedAnswer");
                String category = resultset.getString("category");
                int marks = Integer.parseInt(resultset.getString("marks"));

                //creates new question element
                Question q = new Question(questionNumber, question, expectedAnswer, category, marks);

                //adds question to list
                quest.add(q);
            }

            //`sqlautomarker-individual-records`
            statement.addBatch("use `sqlautomarker-individual-records`;");
            statement.executeBatch();

            Statement statement2 = connection.createStatement();

            //creates table for user
            String create = "CREATE TABLE `sqlautomarker-individual-records`.`" + user + "-" + Assessment + "` ("
                    + "`questionID` INT NOT NULL AUTO_INCREMENT,"
                    + "`database` VARCHAR(45) NULL,"
                    + "`questionReference` INT NULL,"
                    + "`question` VARCHAR(1000) NULL,"
                    + "`studentAnswer` VARCHAR(500) NULL,"
                    + "`studentMarks` INT NULL,"
                    + "`category` VARCHAR(1) NULL,"
                    + "`totalMarks` INT NULL,"
                    + "PRIMARY KEY (`questionID`));";
            statement2.addBatch(create);
            statement2.executeBatch();

            ArrayList<Question> q = new ArrayList<Question>();

            statement.addBatch("use `" + database + "`;");
            statement.executeBatch();

            ArrayList<Integer> A = new ArrayList<Integer>();
            ArrayList<Integer> B = new ArrayList<Integer>();
            ArrayList<Integer> C = new ArrayList<Integer>();
            ArrayList<Integer> D = new ArrayList<Integer>();
            ArrayList<Integer> E = new ArrayList<Integer>();
            ArrayList<Integer> F = new ArrayList<Integer>();
            ArrayList<Integer> G = new ArrayList<Integer>();

            //if there are questions from category A
            if (a != 0)
            {
                //fetches random questions from the category
                String catA = "SELECT questionNumber FROM questions WHERE category='A'"
                        + "ORDER BY RAND()"
                        + "LIMIT " + a + ";";

                ResultSet rs = statement.executeQuery(catA);

                //traverses result set
                while (rs.next())
                {
                    A.add(Integer.parseInt(rs.getString("questionNumber")));
                }
            }

            //if there are questions from category B
            if (b != 0)
            {
                //fetches random questions from the category
                String catB = "SELECT questionNumber FROM questions WHERE category='B'"
                        + "ORDER BY RAND()"
                        + "LIMIT " + b + ";";

                ResultSet rs = statement.executeQuery(catB);

                //traverses result set
                while (rs.next())
                {
                    B.add(Integer.parseInt(rs.getString("questionNumber")));
                }
            }

            //if there are questions from category C
            if (c != 0)
            {
                //fetches random questions from the category
                String catC = "SELECT questionNumber FROM questions WHERE category='C'"
                        + "ORDER BY RAND()"
                        + "LIMIT " + c + ";";

                ResultSet rs = statement.executeQuery(catC);

                //traverses result set
                while (rs.next())
                {
                    C.add(Integer.parseInt(rs.getString("questionNumber")));
                }
            }

            //if there are questions from category D
            if (d != 0)
            {
                //fetches random questions from the category
                String catD = "SELECT questionNumber FROM questions WHERE category='D'"
                        + "ORDER BY RAND()"
                        + "LIMIT " + d + ";";

                ResultSet rs = statement.executeQuery(catD);

                //traverses result set
                while (rs.next())
                {
                    D.add(Integer.parseInt(rs.getString("questionNumber")));
                }
            }

            //if there are questions from category E
            if (e != 0)
            {
                //fetches random questions from the category
                String catE = "SELECT questionNumber FROM questions WHERE category='E'"
                        + "ORDER BY RAND()"
                        + "LIMIT " + e + ";";

                ResultSet rs = statement.executeQuery(catE);

                //traverses result set
                while (rs.next())
                {
                    E.add(Integer.parseInt(rs.getString("questionNumber")));
                }
            }

            //if there are questions from category F
            if (f != 0)
            {
                //fetches random questions from the category
                String catF = "SELECT questionNumber FROM questions WHERE category='F'"
                        + "ORDER BY RAND()"
                        + "LIMIT " + f + ";";

                ResultSet rs = statement.executeQuery(catF);

                //traverses result set
                while (rs.next())
                {
                    F.add(Integer.parseInt(rs.getString("questionNumber")));
                }
            }

            //if there are questions from category G
            if (g != 0)
            {
                //fetches random questions from the category
                String catG = "SELECT questionNumber FROM questions WHERE category='G'"
                        + "ORDER BY RAND()"
                        + "LIMIT " + g + ";";

                ResultSet rs = statement.executeQuery(catG);

                //traverses result set
                while (rs.next())
                {
                    G.add(Integer.parseInt(rs.getString("questionNumber")));
                }
            }

            for (int i = 0; i < a; i++)
            {
                int x = A.get(i);

                //insert question record into database
                String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + user + "-" + Assessment + "` "
                        + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                        + "VALUES ('" + database + "', '" + x + "', '" + quest.get(x - 1).getQuestion() + "', null, null, 'A');";
                statement2.addBatch(sql);
            }
            for (int i = 0; i < b; i++)
            {
                int x = B.get(i);

                //insert question record into database
                String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + user + "-" + Assessment + "` "
                        + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                        + "VALUES ('" + database + "', '" + x + "', '" + quest.get(x - 1).getQuestion() + "', null, null, 'B');";
                statement2.addBatch(sql);
            }
            for (int i = 0; i < c; i++)
            {
                int x = C.get(i);

                //insert question record into database
                String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + user + "-" + Assessment + "` "
                        + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                        + "VALUES ('" + database + "', '" + x + "', '" + quest.get(x - 1).getQuestion() + "', null, null, 'C');";
                statement2.addBatch(sql);
            }
            for (int i = 0; i < d; i++)
            {
                int x = D.get(i);

                //insert question record into database
                String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + user + "-" + Assessment + "` "
                        + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                        + "VALUES ('" + database + "', '" + x + "', '" + quest.get(x - 1).getQuestion() + "', null, null, 'D');";
                statement2.addBatch(sql);
            }
            for (int i = 0; i < e; i++)
            {
                int x = E.get(i);

                //insert question record into database
                String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + user + "-" + Assessment + "` "
                        + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                        + "VALUES ('" + database + "', '" + x + "', '" + quest.get(x - 1).getQuestion() + "', null, null, 'E');";
                statement2.addBatch(sql);
            }
            for (int i = 0; i < f; i++)
            {
                int x = F.get(i);

                //insert question record into database
                String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + user + "-" + Assessment + "` "
                        + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                        + "VALUES ('" + database + "', '" + x + "', '" + quest.get(x - 1).getQuestion() + "', null, null, 'F');";
                statement2.addBatch(sql);
            }
            for (int i = 0; i < g; i++)
            {
                int x = G.get(i);

                //insert question record into database
                String sql = "INSERT INTO `sqlautomarker-individual-records`.`" + user + "-" + Assessment + "` "
                        + "(`database`, `questionReference`,`question` , `studentAnswer` ,`studentMarks`, `category`) "
                        + "VALUES ('" + database + "', '" + x + "', '" + quest.get(x - 1).getQuestion() + "', null, null, 'G');";
                statement2.addBatch(sql);
            }

            statement2.executeBatch();
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }

    /**
     * Creates an assessment record in the assessments table
     */
    public void createAssessment()
    {
        try
        {
            Connection connection = new SQL().getConnection();
            Statement statement = connection.createStatement();
            String create = "INSERT INTO `sqlautomarker`.`assessments` (`assessment_name`, `assessment_type`, `question_database`, `total_questions`, `category_a`, `category_b`, `category_c`, `category_d`, `category_e`, `category_f`, `category_g`, `start_date`, `start_time`, `end_date`, `end_time`, `total_marks`, `attempts`) VALUES ('" + name + "', '" + type + "', '" + database + "', '" + questions + "', '" + catA + "', '" + catB + "', '" + catC + "', '" + catD + "', '" + catE + "', '" + catF + "', '" + catG + "', '" + startDate.toString() + "', '" + startTime.toString() + "', '" + endDate.toString() + "', '" + endTime.toString() + "', '" + totalMarks + "', '" + attempts + "');";
            statement.executeUpdate(create);
            assign();
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }
}
