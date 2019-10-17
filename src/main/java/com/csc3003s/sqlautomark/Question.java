package com.csc3003s.sqlautomark;

/**
 * Question class. Handles questions that have been fetched from the database.
 *
 * @author MLTZAC001
 * @author SBTELV001
 * @author TSHRIA002
 */
public class Question
{

    private int questionNumber;
    private String question;
    private String expectedAnswer;
    private String category;
    private int marks;

    /**
     * fetches question number
     *
     * @return question number
     */
    public int getQuestionNumber()
    {
        return questionNumber;
    }

    /**
     * sets question number
     *
     * @param questionNumber question number
     */
    public void setQuestionNumber(int questionNumber)
    {
        this.questionNumber = questionNumber;
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
     * set question
     *
     * @param question question
     */
    public void setQuestion(String question)
    {
        this.question = question;
    }

    /**
     * fetches expected answer
     *
     * @return expected answer
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
     * fetches category
     *
     * @return category
     */
    public String getCategory()
    {
        return category;
    }

    /**
     * set category
     *
     * @param category category
     */
    public void setCategory(String category)
    {
        this.category = category;
    }

    /**
     * fetches marks
     *
     * @return marks
     */
    public int getMarks()
    {
        return marks;
    }

    /**
     * set marks
     *
     * @param marks marks
     */
    public void setMarks(int marks)
    {
        this.marks = marks;
    }

    /**
     * Constructor method
     *
     * @param questionNumber question number
     * @param question question
     * @param expectedAnswer expected answer
     * @param category category
     * @param marks marks
     */
    public Question(int questionNumber, String question, String expectedAnswer, String category, int marks)
    {
        this.questionNumber = questionNumber;
        this.question = question;
        this.expectedAnswer = expectedAnswer;
        this.category = category;
        this.marks = marks;
    }

    /**
     * fetches string representation of object
     *
     * @return string representation of object
     */
    @Override
    public String toString()
    {
        return questionNumber + "\t" + question + "\t" + expectedAnswer + "\t" + category + "\t" + marks;
    }

}
