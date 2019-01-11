package SalaTable;

import java.io.IOException;
import java.net.URL;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextField;
import GUI.AlertBox;
import sportscenter.SportsCenter;
import sportscenter.ValidateData;

public class AddSalaController implements Initializable {
    private Map<String, Integer> buildings;
    @FXML
    private TextField name;
    @FXML
    private ChoiceBox building;
    @FXML
    private Button button;
    @FXML
    private void handleButtonAction(ActionEvent event) throws IOException, SQLException {
       String[] providedData = {name.getText(), (String) building.getSelectionModel().getSelectedItem()};
        if(ValidateData.isAnyEmpty(providedData)){
            AlertBox.showAlert("None of fields can be empty");
        } else if (ifBuildingNotSelected()){
            AlertBox.showAlert("None building was chosen");
        } else{
            insertIntoDB(providedData[0], providedData[1]);
            ((Node)(event.getSource())).getScene().getWindow().hide();
        }
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        try {
            Statement stmt = SportsCenter.connection.getConn().createStatement();
            ResultSet rs = stmt.executeQuery("SELECT nazwa, id_obiektu FROM obiekt_sportowy");
            buildings = new HashMap<String, Integer>();
            ArrayList<String> choices = new ArrayList<String>();
            while (rs.next()) {
                String buildingName = rs.getString(1);
                 choices.add(buildingName);
                 buildings.put(buildingName, rs.getInt(2));
            }
            building.setItems(FXCollections.observableArrayList(choices));
        } catch (SQLException ex) {
            System.out.println("Bład wykonania polecenia" + ex.toString());
        }    
    }    
    
    private boolean ifSomeEmpty(){
        return (name.getText().equals(""));
    }
    
    private boolean ifBuildingNotSelected(){
        return building.getSelectionModel().isEmpty();
    }
    
    private void insertIntoDB(String name, String buildingName) throws SQLException{
        try{
            PreparedStatement pstmt = SportsCenter.dBManager.getConnection().prepareStatement("INSERT INTO sala VALUES(?, ?)");
            pstmt.setString(1, name);
            pstmt.setInt(2, buildings.get(buildingName));
            pstmt.executeUpdate();
            System.out.println("Sports room added!");
        }catch(SQLException e ){
            System.out.println("Sports room inserting error");
        }
    }
    
}

