package sportscenter;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import com.google.common.reflect.TypeToken;

/**
 *
 * @author Piter
 */
public class DBManager {
    private Connection connection;
    private MainWindowController MainWindowController;

    public DBManager(Connection connection) {
        this.connection = connection;
    }
    
    static abstract class ParameterizedClass<T> {
        final TypeToken<T> type = new TypeToken<T>(getClass()) {};
    }
    
    public <T extends SQLLoad> ObservableList<T> selectAll(Class<T> classType) throws InstantiationException, IllegalAccessException {
        ObservableList<T> queryResult = FXCollections.observableArrayList();
        try {
            Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery("select * from pracownik");
            rs.beforeFirst();
            while (rs.next()) {
                System.out.println(rs.getString(1));
                final ParameterizedClass<T> pc = new ParameterizedClass<T>() {};
                final T obj = (T) pc.type.getRawType().newInstance();
                obj.loadFromSql(rs);
                queryResult.add(obj);
            }
            try {
                stmt.close();
                rs.close();
            } catch (SQLException ex) {
                Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException ex) {
            System.out.println("Bład wykonania polecenia" + ex.toString());
        }
        return queryResult;
    }
    
    public ObservableList<Pracownik> selectAllPracownicy() {
        ObservableList<Pracownik> pracownicy = FXCollections.observableArrayList();
        try {
            Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery("select * from pracownik");
            rs.beforeFirst();
            while (rs.next()) {
                System.out.println(rs.getString(1));
                pracownicy.add(new Pracownik(rs));
            }
            try {
                stmt.close();
                rs.close();
            } catch (SQLException ex) {
                Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException ex) {
            System.out.println("Bład wykonania polecenia" + ex.toString());
        }
        return pracownicy;
    }

    public ObservableList<ObiektSportowy> selectAllObiektySportowe() {
        ObservableList<ObiektSportowy> obiekty = FXCollections.observableArrayList();
        try {
            Statement stmt = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery("select * from obiekt_sportowy");
            rs.beforeFirst();
            while (rs.next()) {
                obiekty.add(new ObiektSportowy(rs));
            }
            try {
                stmt.close();
                rs.close();
            } catch (SQLException ex) {
                Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException ex) {
            System.out.println("Bład wykonania polecenia" + ex.toString());
        }
        return obiekty;
    }
    
    public void setMainWindowController(MainWindowController MainWindowController) {
        this.MainWindowController = MainWindowController;
    }
    
}
