<?php
/**
 * Created by PhpStorm.
 * User: jesse
 * Date: 28-11-2018
 * Time: 15:29
 */
include 'functions.php';
$handler = connectToDB();
$organisation_number = check_input($_POST['organisation_number']);
$sql = "SELECT * FROM contactperson WHERE ORGANISATIENUMBER = ?";
$stmt = $handler->prepare($sql);
$stmt->bindParam( 1, $organisation_number, PDO::PARAM_STR);
$stmt->execute();

while($resultaat = $stmt->fetch(PDO::FETCH_ASSOC)) {
    echo json_encode($resultaat);
}


