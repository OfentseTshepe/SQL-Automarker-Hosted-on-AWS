package com.csc3003s.sqlautomark;

import java.sql.*;

/**
 * Marks individual questions against the expected answer from the database.
 *
 * @author MLTZAC001
 * @author SBTELV001
 * @author TSHRIA002
 */
public class MarkQuestion
{

    //connection to the database
    private Connection connection;

    //name of the database being accessed
    private String database;

    //marks available for the question
    private int mark;

    //expected answer
    private String expected;

    //answer provided by student
    private String actual;

    //category of question
    private String category;

    /**
     * Constructor method
     *
     * @param expected expected answer
     * @param actual answer provided by student
     * @param marks marks available
     * @param database name of database
     * @param category category of question
     * @param connection connection to MySQL server database
     */
    public MarkQuestion(String expected, String actual, int marks, String database, String category, Connection connection)
    {
        this.connection = connection;
        this.database = database;
        this.expected = expected;
        this.actual = actual;
        this.mark = marks;
        this.category = category;
    }

    /**
     * assigns the student's mark for question
     *
     * @param x case for which the mark is assigned. 0 = full marks, 1 = partial
     * marks, 2 = no marks
     */
    public void assignMark(int x)
    {
        switch (x)
        {
            //full marks
            case 0:
                mark = mark;
                break;
            //partial marks
            case 1:
                mark = (int) mark / 2;
                break;
            //no marks
            case 2:
                mark = 0;
                break;
        }
    }

    /**
     * marks the question
     *
     * @return mark for the question
     */
    public int markQuestion()
    {

        if (actual.isEmpty() || expected.isEmpty())
        {
            assignMark(2);
        }
        else
        {
            try
            {
                Statement statement = connection.createStatement();

                statement.addBatch("use `" + database + "`");

                statement.executeBatch();

                //execute correct statement
                String s = expected;
                ResultSet rs = statement.executeQuery(s);

                Statement statement1 = connection.createStatement();

                //execute given query
                String s1 = actual;
                ResultSet rs1 = statement1.executeQuery(s1);
                ResultSetMetaData rsm1 = rs1.getMetaData();

                //compare results
                int x = compareResultSets(rs, rs1);

                //assign marks for question
                assignMark(x);
            }
            catch (SQLException e)
            {
                assignMark(checkHalfMarks());
            }
        }
        return mark;
    }

    /**
     * checks if the question answer deserves partial marks
     *
     * @return partial marks or no marks
     */
    public int checkHalfMarks()
    {
        String a = actual;
        a = a.toUpperCase();
        int res = 2;

        switch (category)
        {
            case "A":
                if (a.contains("SELECT") && a.contains("FROM"))
                {
                    res = 1;
                }
                break;
            case "B":
                if (a.contains("SELECT") && a.contains("FROM") && a.contains("WHERE"))
                {
                    res = 1;
                }
                break;
            case "C":
                if (a.contains("SELECT") && a.contains("FROM") && a.contains("ORDER BY"))
                {
                    res = 1;
                }
                break;
            case "D":
                if (a.contains("SELECT") && a.contains("FROM") && (a.contains("GROUP BY") || a.contains("HAVING")))
                {
                    res = 1;
                }
                break;
            case "E":
                if (a.contains("SELECT") && a.contains("FROM") && a.contains("\\(") && a.contains("\\)"))
                {
                    res = 1;
                }
                break;
            case "F":
                if (a.contains("SELECT") && a.contains("FROM") && (a.contains("ALL") || a.contains("ANY") || a.contains("SOME") || a.contains("EXISTS")))
                {
                    res = 1;
                }
                break;
            case "G":
                if (a.contains("SELECT") && a.contains("FROM") && (a.contains("WHERE") || a.contains("JOIN")))
                {
                    res = 1;
                }
                break;
        }
        return res;
    }

    /**
     * Compares the expected result with the actual result. If they match, the user receives full marks, if not, the system checks for partial marks. 
     *
     * @param resultSet1 result set of expected answer
     * @param resultSet2 result set of student answer
     * @return mark achieved
     * @throws SQLException error in executing sql statement - checks for half marks
     */
    public int compareResultSets(ResultSet resultSet1, ResultSet resultSet2) throws SQLException
    {
        int x = 0;
        ResultSetMetaData rsm = resultSet1.getMetaData();
        int columnsNumber = rsm.getColumnCount();
        ResultSetMetaData rsm2 = resultSet2.getMetaData();
        int columnsNumber2 = rsm2.getColumnCount();
        int row1 = 0;
        int row2 = 0;

        //fetches number of rows in each result set
        while (resultSet1.next())
        {
            row1++;
        }
        while (resultSet2.next())
        {
            row2++;
        }

        //reset cursors
        resultSet1.beforeFirst();
        resultSet2.beforeFirst();

        //if the number of rows in the database do not match
        if (row1 != row2)
        {
            x = checkHalfMarks();

        }
        //if the number of columns do not match
        else if (columnsNumber != columnsNumber2)
        {
            x = checkHalfMarks();
        }
        else
        {
            while (resultSet1.next())
            {
                resultSet2.next();

                //for each column
                for (int i = 1; i <= columnsNumber; i++)
                {
                    //check if equal
                    if (resultSet1.getString(i) == null || resultSet2.getString(i) == null)
                    {
                        if (!(resultSet1.getString(i) == null && resultSet2.getString(i) == null))
                        {
                            x = 2;
                        }
                    }
                    else if (!resultSet1.getString(i).equals(resultSet2.getString(i)))
                    {
                        x = 2;
                    }
                }
            }
        }
        return x;
    }
}
