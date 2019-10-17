package com.csc3003s.sqlautomark;

/**
 * Result class
 *
 * @author MLTZAC001
 * @author SBTELV001
 * @author TSHRIA002
 */
public class Result
{

    //the question number
    private int questionID;
    
    //the actual question
    private String question;
    
    //the student's answer
    private String studentAnswer;
    
    //the expected answer
    private String expectedAnswer;
    
    //the marks achieved by the student for the question
    private int studentMarks;
    
    //the marks that the question is worth
    private int outOf;

    /**
     * Constructor method
     *
     * @param questionID question ID
     * @param question question
     * @param studentAnswer given answer
     * @param expectedAnswer expected answer
     * @param studentMarks marks received
     * @param outOf marks available
     */
    public Result(int questionID, String question, String studentAnswer, String expectedAnswer, int studentMarks, int outOf)
    {
        this.questionID = questionID;
        this.question = question;
        this.studentAnswer = studentAnswer;
        this.expectedAnswer = expectedAnswer;
        this.studentMarks = studentMarks;
        this.outOf = outOf;
    }

    /**
     * fetches question ID
     *
     * @return question ID
     */
    public int getQuestionID()
    {
        return questionID;
    }

    /**
     * sets question ID
     *
     * @param questionID question ID
     */
    public void setQuestionID(int questionID)
    {
        this.questionID = questionID;
    }

    /**
     * fetches question
     *
     * @return question
     */
    public String getQuestion()
    {
        return question;
    }

    /**
     * sets question
     *
     * @param question question
     */
    public void setQuestion(String question)
    {
        this.question = question;
    }

    /**
     * fetches answer given by student
     *
     * @return student's answer
     */
    public String getStudentAnswer()
    {
        return studentAnswer;
    }

    /**
     * set student's answer
     *
     * @param studentAnswer student's answer
     */
    public void setStudentAnswer(String studentAnswer)
    {
        this.studentAnswer = studentAnswer;
    }

    /**
     * fetches expected result
     *
     * @return expected result
     */
    public String getExpectedAnswer()
    {
        return expectedAnswer;
    }

    /**
     * set expected answer
     *
     * @param expectedAnswer expected answer
     */
    public void setExpectedAnswer(String expectedAnswer)
    {
        this.expectedAnswer = expectedAnswer;
    }

    /**
     * fetches student marks
     *
     * @return student marks
     */
    public int getStudentMarks()
    {
        return studentMarks;
    }

    /**
     * sets student marks
     *
     * @param studentMarks student marks
     */
    public void setStudentMarks(int studentMarks)
    {
        this.studentMarks = studentMarks;
    }

    /**
     * get marks available
     *
     * @return marks available
     */
    public int getOutOf()
    {
        return outOf;
    }

    /**
     * set marks available
     *
     * @param outOf marks available
     */
    public void setOutOf(int outOf)
    {
        this.outOf = outOf;
    }
}
