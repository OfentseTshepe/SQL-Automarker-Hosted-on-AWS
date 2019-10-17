package com.csc3003s.sqlautomark;

import java.sql.*;

/**
 * Class to handle user creation 
 *
 * @author MLTZAC001
 * @author SBTELV001
 * @author TSHRIA002
 */
public class User
{

    
    //name of user
    private String name;
    
    //student or staff number
    private String userID;
    
    //role of user: lecturer, tutor, or student
    private String role;

    /**
     * fetches user's name
     *
     * @return name of user
     */
    public String getName()
    {
        return name;
    }

    /**
     * gets user user ID
     *
     * @return user ID
     */
    public String getUserID()
    {
        return userID;
    }

    /**
     * fetches role of user
     *
     * @return role of the user
     */
    public String getRole()
    {
        return role;
    }

    /**
     * Constructor method
     *
     * @param name name of the user
     * @param userID user ID 
     * @param role role of the user
     */
    public User(String name, String userID, String role)
    {
        this.name = name;
        this.userID = userID;
        this.role = role;

    }

    /**
     * fetches string representation of object
     *
     * @return string representation of object
     */
    @Override
    public String toString()
    {
        return userID + ", " + name + ", " + role;
    }

}
