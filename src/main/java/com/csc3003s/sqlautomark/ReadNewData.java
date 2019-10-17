package com.csc3003s.sqlautomark;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

/**
 * would be used to read data from database file -- INCOMPLETE. THIS WOULD BE
 * USED FOR ANOTHER STAGE OF THE DEVELOPMENT AND EXPANSION OF THE PROJECT
 *
 * @author MLTZAC001
 */
public class ReadNewData
{

    /**
     * Constructor
     *
     * @param file file to be read
     */
    public ReadNewData(File file)
    {

        try
        {
            BufferedReader f = new BufferedReader(new FileReader(file));
            String name = f.readLine();
            int numTables = Integer.parseInt(f.readLine());
            int numQuestions = Integer.parseInt(f.readLine());
            String s = f.readLine();
            int count = 0;
            while (s != null)
            {

                while (count < numTables - 1)
                {
                    String table = "";
                    int numColumns = 0;

                    if ((!s.startsWith("(")) && (!s.equals("")))
                    {
                        String d = s.replaceAll(" ", "");
                        d = d.replaceAll("[()]", " ");
                        String z[] = d.split(" ");

                        table = z[0];

                        String col[] = z[1].split(",");
                        numColumns = col.length;
                        //String str = z[1].substring(0,x-1);
                        //System.out.println(str);
                    }
                    if (s.startsWith("("))
                    {
                        String str = s.replaceAll("[()]", "");

                        System.out.println(str);
                    }
                    if (s.equals(""))
                    {
                        count++;
                    }
                    s = f.readLine();
                }
                s = f.readLine();
            }

        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }
}
