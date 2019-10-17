package com.csc3003s.sqlautomark;

import java.sql.*;

/**
 * Removes all students from database
 *
 * @author MLTZAC001
 */
public class RemoveStudents
{

    /**
     * Constructor Method
     *
     * @param connection connection to MySQL server database
     */
    public RemoveStudents(Connection connection)
    {
        try
        {
            //initiates connection with the MySQL database
            Statement statement = connection.createStatement();

            statement.addBatch("use `sqlautomarker`;");
            statement.executeBatch();

            //deletes all user entries from password and user tables
            String s = "DELETE u.*, p.* FROM Users u INNER JOIN Password p ON u.UserID = p.UserID WHERE (u.Role = 'Student');";

            statement.executeUpdate(s);
        }
        catch (Exception e)
        {
            System.out.println("");
        }
    }
}
