<?php

function check_input($data)
{
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

function connectToDB() {
    $host = '(local)';
    $user = "iseprojectuser";
    $pass = "iseprojectww";
    $db = "SBBWorkshopOmgeving";

    $connectionInfo = array("Database" => $db, "UID" => $user, "PWD" => $pass);
    $conn = sqlsrv_connect($host, $connectionInfo);
    if ($conn === false) {
        die(print_r(sqlsrv_errors(), true));
    }
    return $conn;
}