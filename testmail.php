<?php

require 'vendor/phpmailer/phpmailer/src/PHPMailer.php';

require 'vendor/autoload.php';

$mail = new PHPMailer\PHPMailer\PHPMailer();
$mail->IsSMTP(); // enable SMTP
$mail->SMTPDebug = 1; // debugging: 1 = errors and messages, 2 = messages only
$mail->SMTPAuth = true; // authentication enabled
$mail->SMTPSecure = 'ssl'; // secure transfer enabled REQUIRED for Gmail
$mail->Host = "smtp.gmail.com";
$mail->Port = 465; // or 587
$mail->IsHTML(true);
$mail->Username = "testISEB2@gmail.com";
$mail->Password = "ise!b2MAILTEST";
$mail->SetFrom("testISEB2@gmail.com");
$mail->Subject = "Test";
$mail->Body = "hello";
$mail->AddAddress("levicheater@hotmail.com");
if(!$mail->Send()) {
    echo 'Message was not sent!.';
    echo 'Mailer error: ' . $mail->ErrorInfo;
} else {
    echo  //Fill in the document.location thing
    '<script type="text/javascript">
                        if(confirm("Your mail has been sent"))
                        document.location = "/";
        </script>';
}
?>
