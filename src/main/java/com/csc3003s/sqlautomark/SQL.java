package com.csc3003s.sqlautomark;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Facilitates connection with the MySQL database
 *
 * @author MLTZAC001
 * @author SBTELV001
 * @author TSHRIA002
 */
public class SQL
{

    Connection connection = null;

    /**
     * Constructor method that initiates a connection with the database
     */
    public SQL()
    {
        try
        {
            connection = DriverManager.getConnection("jdbc:mysql://sqlautomarker.cdtrwjzldbjr.us-east-1.rds.amazonaws.com:3306/?user=mltzac001", "mltzac001", "SQLauto2018");
        }
        catch (SQLException ex)
        {
            ex.printStackTrace();
        }
    }

    /**
     * fetches connection
     *
     * @return connection to the database
     */
    public Connection getConnection()
    {
        return connection;
    }
}
