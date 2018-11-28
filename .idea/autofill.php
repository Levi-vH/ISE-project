<?php
/**
 * Created by PhpStorm.
 * User: jesse
 * Date: 28-11-2018
 * Time: 15:19
 */

$organisation = $_POST['organisation'];

    $handler = connectToDB();
    $sql = "SELECT organisatienummer FROM organisatie WHERE Organisatienaam = $organisation";
    $query = $handler->prepare($sql);
    $query->execute();

    while($resultaat = $query->fetch(PDO::FETCH_ASSOC)) {
          echo $resultaat['organisatienummer'];
    }
