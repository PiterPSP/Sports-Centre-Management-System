package ObiektSportowyTable;

import sportscenter.*;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DBManagerObiektSportowy {
    
    private DBManager dBManager;

    public DBManagerObiektSportowy(DBManager dBManager) {
        this.dBManager = dBManager;
    }

    public void insertNewObiektSportowy(String name, String location, String type) throws SQLException {
        try {
            PreparedStatement pstmt = SportsCenter.dBManager.getConnection().prepareStatement("INSERT INTO obiekt_sportowy VALUES(seq_id_obiektu.nextval, ?, ?, ?)");
            pstmt.setString(1, location);
            pstmt.setString(2, name);
            pstmt.setString(3, type);
            pstmt.executeUpdate();
            SportsCenter.dBManager.getConnection().commit();
            System.out.println("Sports facility added!");
        } catch (SQLException e) {
            ValidateData.printSQLException(e, "Nazwa");
            System.out.println("Sports facility inserting error");
        }
    }
    
    public void editObiektSportowy(String buildingId, String location, String name, String type) throws SQLException {
        try {
            PreparedStatement pstmt = SportsCenter.dBManager.getConnection().prepareStatement("UPDATE obiekt_sportowy SET nazwa = ?, lokalizacja = ? , typ_obiektu = ? WHERE id_obiektu = ?");
            pstmt.setString(1, name);
            pstmt.setString(2, location);
            pstmt.setString(3, type);
            pstmt.setString(4, buildingId);

            pstmt.executeUpdate();
            SportsCenter.dBManager.getConnection().commit();
            System.out.println("Sports facility added!");
        } catch (SQLException e) {
            ValidateData.printSQLException(e, "Nazwa");
            System.out.println("Sports facility inserting error");
        }
    }
    public DBManager getdBManager() {
        return dBManager;
    }
    
}