package ObiektSportowyTable;

import java.io.IOException;
import java.net.URL;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import GUI.AlertBox;
import sportscenter.DBManager;
import sportscenter.SportsCenter;
import sportscenter.ValidateData;

public class AddObiektSportowyController implements Initializable {
    
    private DBManager dBManager;
    
    @FXML
    private TextField name;
    @FXML
    private TextField location;
    @FXML
    private TextField type;
    @FXML
    private Button button;
    @FXML
    private void handleButtonAction(ActionEvent event) throws IOException, SQLException {
        String[] providedData = { name.getText(), location.getText(), type.getText() };
        if(ValidateData.isAnyEmpty(providedData)){
            AlertBox.showAlert("None of fields can be empty");
        } else {
            dBManager.getDbManagerObiektSportowy().insertNewObiektSportowy(providedData[0],providedData[1],providedData[2]);
            ((Node)(event.getSource())).getScene().getWindow().hide();
        }
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        dBManager = SportsCenter.dBManager;
    }    
    
    private boolean ifSomeEmpty(){
        return (name.getText().equals("") || location.getText().equals("") || 
                type.getText().equals(""));
    }
    
}

