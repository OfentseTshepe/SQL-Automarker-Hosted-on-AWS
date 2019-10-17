package com.csc3003s.sqlautomark;

import java.sql.Connection;
import java.sql.*;

/**
 * Log in class that accesses the MySQL database to validate a user when logging
 * into the portal
 *
 * @author MLTZAC001
 * @author SBTELV001
 * @author TSHRIA002
 */
public class LogIn
{

    private final String username;
    private final String password;

    //role of user 
    private int role;

    /**
     * Constructor method
     *
     * @param username Username of Student, Lecturer, or Tutor
     * @param password Password of user
     */
    public LogIn(String username, String password)
    {
        this.username = username;
        this.password = password;

        //sets the initial log in status to "error"
        this.role = 2;
    }

    /**
     * Calls the database to try log into server
     *
     * @return int value of the status of the user. 0: Staff, 1: Student, 2-3:
     * Error
     */
    public int LogInUser()
    {
        try
        {
            //initiate connection to the database
            Connection connection = new SQL().getConnection();
            Statement stmt = connection.createStatement();
            Statement stmt2 = connection.createStatement();

            //fetches the user record from the 'Users' database
            String sql = "SELECT * FROM sqlautomarker.Users WHERE UserID='" + username.toUpperCase() + "';";
            ResultSet rs = stmt.executeQuery(sql);

            //fetches the user record from the 'Password' database
            String sql2 = "SELECT Password FROM sqlautomarker.Password where UserID='" + username.toUpperCase() + "';";
            ResultSet rs2 = stmt2.executeQuery(sql2);

            //traverse through the result set
            while (rs.next())
            {
                rs2.next();

                //fetches password and role of user
                String p = rs2.getString("Password");
                String role = rs.getString("Role");

                //if the password entered matches the password on record
                if (p.equals(password))
                {
                    //is the user is a Lecturer or Tutor
                    if (role.equals("Lecturer") || role.equals("Tutor"))
                    {
                        this.role = 0;
                    }
                    //if the user is a Student
                    if (role.equals("Student"))
                    {
                        this.role = 1;
                    }
                }
                //if the passwords do not match
                else
                {
                    this.role = 2;
                }
            }
        }
        //if an error occurs while loggin in
        catch (Exception e)
        {
            this.role = 3;
        }

        return this.role;
    }

    /**
     * Fetches role of the user logging in
     *
     * @return int Role. 0: Lecturer or Tutor, 1: Student, 2-3: error
     */
    public int getRole()
    {
        int r = role;
        return r;
    }
}
