<?php

include 'functions.php';

//Test

//Use 10 minute mail for testing purposes
//https://10minutemail.com/10MinuteMail/index.html
$firstname = "Jesse";
$lastname = "van Dijk";
sendMail("jesse-28@hotmail.com", "Testingss", "Beste " . $firstname . " " . $lastname .   ", <br><br> U heeft zich succesvol aangemeld voor de onderstaande workshops: <br> ");
?>
