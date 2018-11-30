<?php
/**
 * Created by PhpStorm.
 * User: jesse
 * Date: 28-11-2018
 * Time: 15:29
 */
include 'functions.php';
$handler = connectToDB();
$organisation = check_input($_POST['organisation']);
$sql = "SELECT * FROM organisatie WHERE ORGANISATIENAAM = ?";
$stmt = $handler->prepare($sql);
$stmt->bindParam( 1, $organisation, PDO::PARAM_STR);
$stmt->execute();

while($resultaat = $stmt->fetch(PDO::FETCH_ASSOC)) {
    echo json_encode($resultaat);
}


