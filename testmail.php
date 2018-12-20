<?php

include 'functions.php';

//Test

//Use 10 minute mail for testing purposes
//https://10minutemail.com/10MinuteMail/index.html
$firstname = "Jesse";
$lastname = "van Dijk";
sendMail("o4796106@nwytg.net", "Testingss", "Beste " . $firstname . " " . $lastname .   ", <br><br> U heeft zich succesvol aangemeld voor de onderstaande workshops: <br> ");
?>
