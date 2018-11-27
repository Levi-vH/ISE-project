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



function selectBox($naamWaarde, $tabelnaam, $kolommen, $optionvalue, $displayColumns){
    $handler = connectToDB();
    $select = '<select class="form-control" name="'.$naamWaarde.'">';

    $kolomString = $kolommen[0];

    for($i = 1; $i < sizeof($kolommen); $i++){
        $kolomString .= ',' . $kolommen[$i];
    }

    $sql ="SELECT $kolomString FROM $tabelnaam";

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