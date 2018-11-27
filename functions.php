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
