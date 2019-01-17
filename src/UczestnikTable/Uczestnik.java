package UczestnikTable;

import java.sql.ResultSet;
import java.sql.SQLException;
import sportscenter.SQLObject;

public class Uczestnik extends SQLObject {
    private String PESEL;
    private String surname;
    private String name;
    private char status;

    public Uczestnik(String PESEL, String nazwisko, String imie, char oplacony) {
        this.PESEL = PESEL;
        this.surname = nazwisko;
        this.name = imie;
        this.status = oplacony;
    }

    public Uczestnik(){}
    
    
    public Uczestnik(ResultSet rs) throws SQLException {
        this.PESEL = rs.getString(1);
        this.surname = rs.getString(2);
        this.name = rs.getString(3);
        this.status = rs.getString(4).charAt(0);
    }

    public String getPESEL() {
        return PESEL;
    }

    public String getSurname() {
        return surname;
    }

    public String getName() {
        return name;
    }

    public char getStatus() {
        return status;
    }




 


    
    
}
