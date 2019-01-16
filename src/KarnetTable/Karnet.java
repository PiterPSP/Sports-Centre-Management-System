package KarnetTable;

import java.sql.ResultSet;
import java.sql.SQLException;
import sportscenter.SQLObject;

public class Karnet extends SQLObject {
    private int IDClient;
    private int IDActivity;
    private float price;
    private String dateStart;
    private String dateEnd;

    public Karnet() {
    }

    public Karnet(ResultSet rs) throws SQLException {
        this.IDClient = rs.getInt(1);
        this.IDActivity = rs.getInt(2);
        this.price = rs.getFloat(3);
        this.dateStart = rs.getString(4);
        this.dateEnd = rs.getString(5);
    }
    
    @Override
    public String getSth() {
        return Integer.toString(IDClient);
    }

    public int getIDClient() {
        return IDClient;
    }

    public void setIDClient(int IDClient) {
        this.IDClient = IDClient;
    }

    public int getIDActivity() {
        return IDActivity;
    }

    public void setIDActivity(int IDActivity) {
        this.IDActivity = IDActivity;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getDateStart() {
        return dateStart;
    }

    public void setDateStart(String dateStart) {
        this.dateStart = dateStart;
    }

    public String getDateEnd() {
        return dateEnd;
    }

    public void setDateEnd(String dateEnd) {
        this.dateEnd = dateEnd;
    }
    
}
