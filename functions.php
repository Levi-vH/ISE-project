<?php

function check_input($data)
{
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);

    return $data;
}

function connectToDB(){
    $hostnaam = '(local)';
    $dbnaam ='SBBWorkshopOmgeving';
    $username = 'iseprojectuser';
    $wachtwoord = 'iseprojectww';

    try {
        $handler = new PDO("sqlsrv:Server=$hostnaam; Database=$dbnaam; ConnectionPooling=0", "$username", "$wachtwoord");

        $handler->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
    }catch (PDOException $e){
        echo "Er ging iets mis met de database.<br>";
        echo "De melding is {$e->getMessage()}<br><br>";
    }
    return $handler;
}



function selectBox($naamWaarde, $tabelnaam, $kolommen, $optionvalue, $displayColumns, $order, $function = null){
    $handler = connectToDB();
    $select = '<select class="form-control" id="'.$naamWaarde.'" name="'.$naamWaarde.'" onchange="'. $function .'">';

    $kolomString = $kolommen[0];

    for($i = 1; $i < sizeof($kolommen); $i++){
        $kolomString .= ',' . $kolommen[$i];
    }

    $sql ="SELECT $kolomString FROM $tabelnaam ORDER BY $order";

    $query = $handler->prepare($sql);
    $query->execute();

    while($resultaat = $query->fetch(PDO::FETCH_ASSOC)){

        $displayString = '';

        if($kolommen == $displayColumns){

            foreach($resultaat as $row){
                    $displayString .= $row . ' ';
                }
        }else{

            foreach (array_keys($resultaat) as $column){
                if(in_array($column, $displayColumns)){
                    $displayString .= $resultaat[$column] .  ' ';
                }
            }
        }

        $select.= '<option value="'. $resultaat[$optionvalue] . '">' . $displayString . '</option>';

        }

    $select .= '</select>';

    return $select;
}


function pre_r($input){
    echo '<pre>';
    print_r($input);
    echo '</pre>';
}

function deleteUserWorkshop($workshop_id, $participant_id) {
    $conn = connectToDB();

    //Run the stored procedure
    $sql = "exec proc_disapprove_workshop_participants ?, ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
    $stmt->bindParam(2, $participant_id, PDO::PARAM_INT);
    $stmt->execute();
}

function deleteUserAanvraag($aanvraag_id, $participant_id) {
    $conn = connectToDB();

    //Run the stored procedure
    $sql = "exec proc_delete_aanvraag_deelnemers ?, ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $aanvraag_id, PDO::PARAM_INT);
    $stmt->bindParam(2, $participant_id, PDO::PARAM_INT);
    $stmt->execute();
}

function addUser($workshop_id, $participant_id) {
    $conn = connectToDB();

    //Run the stored procedure
    $sql = "exec proc_approve_workshop_participants ?, ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
    $stmt->bindParam(2, $participant_id, PDO::PARAM_INT);
    $stmt->execute();
}

function updatePage($pagina) {
    ?>
    <script type="text/javascript">
        window.location.href = '<?php echo $pagina ?>';
    </script>
    <?php
}

function getModuleNummer($id) {
    $conn = connectToDB();

    //Run the stored procedure
    $sql = "exec proc_getWorkshops @where = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $id, PDO::PARAM_INT);
    $stmt->execute();

    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $modulenummer = $row['MODULENUMMER'];

    return $modulenummer;
}

function getWorkshopType($id) {
    $conn = connectToDB();


    $sql = "SELECT TYPE FROM WORKSHOP WHERE WORKSHOP_ID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $id, PDO::PARAM_INT);
    $stmt->execute();

    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $workshoptype = $row['TYPE'];

    return $workshoptype;

}
