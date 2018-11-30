<?php
/**
 * Created by PhpStorm.
 * User: jesse
 * Date: 28-11-2018
 * Time: 15:29
 */
include 'functions.php';
$handler = connectToDB();
$advisor_id = check_input($_POST['advisor_id']);
$sql = "SELECT * FROM adviseur WHERE adviseur_ID = ?";
$stmt = $handler->prepare($sql);
$stmt->bindParam( 1, $advisor_id, PDO::PARAM_STR);
$stmt->execute();
$rows = array();
while($resultaat = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $rows[] = $resultaat;
}

echo json_encode($rows, JSON_FORCE_OBJECT);