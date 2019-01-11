package WyposazenieTable;

import SalaTable.*;
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
import sportscenter.DBManager;
import sportscenter.SportsCenter;
import sportscenter.ValidateData;

public class AddWyposazenieController implements Initializable {
    private DBManager dbManager;
    private Map<String, Integer> buildings;
    @FXML
    private TextField name;
    @FXML
    private TextField sport;
    @FXML
    private TextField count;
    @FXML
    private ChoiceBox building;
    @FXML
    private ChoiceBox hall;
    @FXML
    private void handleButtonAction(ActionEvent event) throws IOException, SQLException {
       String[] providedData = {name.getText(), sport.getText(), count.getText()};
        if(ValidateData.isAnyEmpty(providedData)){
            AlertBox.showAlert("None of fields can be empty");
        } else if (!ValidateData.isNumber(providedData[2])){
            AlertBox.showAlert("'Count' value should be an integer");
        } else if (ValidateData.ifValueNotSelected(building)){
            AlertBox.showAlert("None building was chosen");
        }  else {
            int hallId = 0;
            if (ValidateData.ifValueNotSelected(hall)){
                hallId = -1;
            } else {
//                hallString = (String) hall.getSelectionModel().getSelectedItem();
            }
            dbManager.getDbManagerWyposazenie().insertNewWyposazenie(providedData[0], providedData[1], providedData[2], 
                    getBuildingId(), hallId);
            ((Node)(event.getSource())).getScene().getWindow().hide();
        }
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        this.dbManager = SportsCenter.dBManager;
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
    
    private int getBuildingId(){
        return buildings.get((String) building.getSelectionModel().getSelectedItem());
    }
}

