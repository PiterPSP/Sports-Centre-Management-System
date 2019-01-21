package sportscenter;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private Connection conn;
    private String address;
    private String port;
    private String sid;
    private String username;
    private String password;
    
    public DBConnection(String address, String port, String sid){
        this.address = address;
        this.port = port;
        this.sid = sid;
    }
    
    public void authenticateUser(String username, String password){
       this.username = username;
       this.password = password;
    }
    
    public Connection connect(){
        Properties connectionProps = new Properties();
        connectionProps.put("user", username);
        connectionProps.put("password", password);
        try {
            conn = DriverManager.getConnection(
                    "jdbc:oracle:thin:@"+address+":"+port+":"+sid,
                    connectionProps);
            System.out.println("Połączono z bazą danych");
        } catch (SQLException ex) {
            Logger.getLogger(Connection.class.getName()).log(Level.SEVERE,
                    "nie udało się połączyć z bazą danych", ex);
            System.exit(-1);
        }
        return conn;
    }
    
    public void disconnect() {
        try {
            conn.close();
            System.out.println("Disconnected.");
        } catch (SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConn() {
        return conn;
    }
}           
//        try {
//            stmt = conn.createStatement();
//            rs = stmt.executeQuery("select count(*) FROM pracownicy");
//            while (rs.next()) {
//                System.out.println("Zatrudniono " + rs.getInt(1) + " pracownikow, w tym:\n"); // + " " + rs.getString(2) + " "
//                //+ rs.getFloat(3));
//            }
//        } catch (SQLException ex) {
//            System.out.println("Bład wykonania polecenia" + ex.toString());
//        }
//        stmt.close();
//        try {
//            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
//                    ResultSet.CONCUR_READ_ONLY);
//            rs = stmt.executeQuery("SELECT \n"
//                    + "   ( COUNT(*) || ' w zespole ' ||  z.nazwa ) AS linijka\n"
//                    + "FROM pracownicy p \n"
//                    + "    LEFT JOIN ZESPOLY z \n"
//                    + "    ON p.id_zesp = z.id_zesp\n"
//                    + "GROUP BY z.nazwa");
//
//            rs.afterLast();
//            while (rs.previous()) {
//                System.out.println(rs.getString(1));
//            }
//        } catch (SQLException ex) {
//            System.out.println("Bład wykonania polecenia" + ex.toString());
//        }
//#######################################################
//        try {
//            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
//                    ResultSet.CONCUR_READ_ONLY);
//            rs = stmt.executeQuery("SELECT nazwisko, placa_pod FROM pracownicy WHERE etat='ASYSTENT' ORDER BY placa_pod DESC");
//
//            rs.afterLast();
//            while (rs.previous()) {
//                System.out.println(rs.getString(1) + ' ' + rs.getInt(2));
//            }
//            System.out.println("----------------");
//            rs.first();
//            System.out.println("Najwiecej: " + rs.getString(1));
//            rs.last();
//            System.out.println("Najmniej: " + rs.getString(1));
//            rs.previous();
//            rs.previous();
//            System.out.println("Trzeci od konca: " + rs.getString(1));
//        } catch (SQLException ex) {
//            System.out.println("Bład wykonania polecenia" + ex.toString());
//        }
        //########################################## 
//        Statement stmt;
//        PreparedStatement pstmt;
//        stmt = conn.createStatement();
//        pstmt = conn.prepareStatement("INSERT INTO pracownicy(id_prac, nazwisko) VALUES(sekwencyja.nextval, ?)");
//        
//        int[] zwolnienia = {150, 200, 230};
//        String[] zatrudnienia = {"Kandefer", "Rygiel", "Boczar"};
//        try {
//            for (int elem : zwolnienia) {
//                try {
//                    stmt.executeUpdate("DELETE FROM pracownicy WHERE id_prac=" + Integer.toString(elem));
//                    System.out.println("Usunieto pracownika o id " + Integer.toString(elem));
//                } catch (SQLException ex) {
//                    System.out.println("Bład usuwania pracownika" + ex.toString());
//                }
//
//            }
//            for (String elem : zatrudnienia) {
//                pstmt.setString(1, elem);
//                try {
//                    //stmt.executeUpdate("INSERT INTO pracownicy(id_prac, nazwisko) VALUES(sekwencyja.nextval, "+elem+")");
//                    pstmt.executeUpdate();
//                    System.out.println("Dodano pracownika "+elem);
//                } catch (SQLException ex) {
//                    System.out.println("Bład dodawania pracownika " + ex.toString());
//                }
//            }
//        } catch (SQLException ex) {
//            System.out.println("Bład nawiązania polaczenia" + ex.toString());
//        }
//##################################################################################
//        Statement stmt = conn.createStatement();
//        ResultSet rs = null;
//        conn.setAutoCommit(false);
//        stmt = conn.createStatement();
//        rs = stmt.executeQuery("SELECT nazwa FROM etaty");
//        System.out.println("Przed edycja");
//        while (rs.next()) {
//            System.out.println(rs.getString(1));
//        }
//        stmt.executeUpdate("INSERT INTO etaty(NAZWA)"
//                + "VALUES('sprzatacz')");
//        rs = stmt.executeQuery("SELECT nazwa FROM etaty");
//        System.out.println("Po edycji ");
//        while (rs.next()) {
//            System.out.println(rs.getString(1));
//        }
//        conn.rollback();
//        rs = stmt.executeQuery("SELECT nazwa FROM etaty");
//        System.out.println("Po rollback");
//        while (rs.next()) {
//            System.out.println(rs.getString(1));
//        }
//        stmt.executeUpdate("INSERT INTO etaty(nazwa)"
//                + "VALUES('sprzatacz')");
//        conn.commit();
//        rs = stmt.executeQuery("SELECT nazwa FROM etaty");
//        System.out.println("Po commicie");
//        while (rs.next()) {
//            System.out.println(rs.getString(1));
//        }
//        stmt.close();
////        pstmt.close();
//        rs.close();
//        try {
//            conn.close();
//        } catch (SQLException ex) {
//            Logger.getLogger(Lab_JDBC.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        System.out.println("Rozłączono z bazą danych");
//    }
//}
