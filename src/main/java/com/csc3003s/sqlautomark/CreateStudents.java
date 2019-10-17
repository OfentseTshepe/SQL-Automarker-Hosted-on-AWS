package com.csc3003s.sqlautomark;

import java.io.*;
import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * Adds students from a file to the MySQL database
 *
 * @author MLTZAC001
 * @author SBTELV001
 * @author TSHRIA002
 */
public class CreateStudents
{
    //file of students
    private File students;
    
    //connection to the MySQL database
    private Connection connection;
    
    //list of users
    private ArrayList<User> users;
    
    //boolean to determine if the file is valid or not.
    private boolean isValid;

    /**
     * Constructor method
     *
     * @param students file of students
     */
    public CreateStudents(File students)
    {
        this.students = students;

        //initiates connection with MySQL database
        this.connection = new SQL().getConnection();
        this.users = new ArrayList<User>();
        this.isValid = true;
        readFile();
    }

    /**
     * adds students to database
     */
    private void addToDatabase()
    {
        try
        {
            Statement stmt = connection.createStatement();
            Statement statement = connection.createStatement();
            String sql = "";
            String p = "";

            //traverse students
            for (User user : users)
            {
                //insert record into user database
                sql = "INSERT INTO `sqlautomarker`.`Users` (`UserID`, `Name`, `Role`) VALUES ('" + user.getUserID().toUpperCase() + "', '" + user.getName() + "', '" + user.getRole() + "');";

                //generates a secure password
                String pass = new GeneratePassword().getPassword();

                //insert record into password table
                p = "INSERT INTO `sqlautomarker`.`Password` (`UserID`, `Password`) VALUES ('" + user.getUserID().toUpperCase() + "', '" + pass + "');";

                statement.addBatch(p);
                stmt.addBatch(sql);
            }
            stmt.executeBatch();
            statement.executeBatch();
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }

    /**
     * Checks if the file format is valid
     *
     * @return (in)valid file
     */
    public boolean isValid()
    {
        return isValid;
    }

    /**
     * reads file
     */
    public void readFile()
    {
        try
        {
            BufferedReader f = new BufferedReader(new FileReader(students));

            String s = f.readLine();
            while (s != null)
            {
                String z[] = s.split(";");
                String name = z[0];
                String y[] = name.split(", ");
                String fname = y[1];
                String sname = y[0];
                name = fname + " " + sname;
                String userID = z[1];
                String role = z[2];
                User u = new User(name, userID, role);
                users.add(u);

                s = f.readLine();
            }
            addToDatabase();
        }
        catch (Exception e)
        {
            isValid = false;
        }
    }
}
