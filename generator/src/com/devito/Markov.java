package com.devito;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Created by octopuscabbage on 4/21/16.
 */
public class Markov {
    private final static String connString = "";
    private final static String user = "";
    private final static String password = "";
    private Connection conn;
    private Statement stmt;

    public static void main(String args[]) {
        try {
            System.out.println(new Markov().generate());
        } catch (SQLException e){
            throw new RuntimeException(e);
        }
    }

    public String generate() throws SQLException{
        String curr = "";
        String word1 = null;
        String word2 = findStartPair();
        String tail = "";
        curr += word2;
        while(tail != null) {
            tail = findTail(word1,word2);
            curr += tail;
            word1 = word2;
            word2 = tail;
        }
        return curr;
    }

    public String findStartPair() throws SQLException{
        String findNullString = "SELECT WORD2 FROM WORDHEAD WHERE WORD1 = NULL";
        ResultSet rs = runQuery(findNullString);
        List<String> words = new ArrayList<>();
        while(rs.next()){
            words.add(rs.getString("WORD2"));
        }
        return words.get(new Random().nextInt(words.size()));
    }

    private ResultSet runQuery(String query) throws SQLException{
        try {
            Class.forName("com.mysql.jdbc.Drver");
        } catch (Exception e) {
            e.printStackTrace();
        }
        conn = DriverManager.getConnection(connString);
        stmt = conn.createStatement();
        return stmt.executeQuery(query);
    }

    private static String findWordsString = "SELECT * FROM WORDHEAD NATURAL JOIN OCCURANCES NATURAL JOIN WORDTAIL WHERE WORD1 = ";
    private String makeQuery(String word1, String word2) {
        return findWordsString + word1 + " AND WORD2 = " + word2;
    }
    private String findTail(String word1, String word2) throws SQLException{
        ResultSet rs = runQuery(makeQuery(word1,word2))
        List<Edge> edgeList = new ArrayList<>();
        while(rs.next()){
            Edge edge = new Edge();
            edge.word1 = rs.getString("WORD1");
            edge.word2 = rs.getString("WORD2");
            edge.frequency = rs.getInt("OCCURENCES");
            edge.tail = rs.getString("WORD");
            edgeList.add(edge);
        }
        return selectEdge(edgeList).tail;
    }

    public class Edge{
        public String word1;
        public String word2;
        public int frequency;
        public String tail;
    }

    public Edge selectEdge(List<Edge> edgeList) {
        // Compute the total weight of all items together
        double totalWeight = 0.0d;
        for (Edge e : edgeList) {
            totalWeight += e.frequency;
        }
        // Now choose a random item
        int randomIndex = -1;
        double random = Math.random() * totalWeight;
        for (int i = 0; i < edgeList.size(); ++i) {
            random -= edgeList.get(i).frequency;
            if (random <= 0.0d) {
                return edgeList.get(i);
            }
        }
        return null;
    }
}
