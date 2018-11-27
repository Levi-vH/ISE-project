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


function selectBox($naamWaarde, $tabelnaam, $kolomnaam){
    $handler = connectToDB();
    $select = '<select class="form-control" name="'.$naamWaarde.'">';
    $sql ="SELECT $kolomnaam FROM $tabelnaam ORDER BY $kolomnaam";

    $query = $handler->prepare($sql);
    $query->execute();

    while($resultaat = $query->fetch()){
        $select.= '<option value="'. $resultaat[$kolomnaam] . '">'. $resultaat[$kolomnaam] . '</option>';
    }
    $select .= '</select>';

    return $select;
}
