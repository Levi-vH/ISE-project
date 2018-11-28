<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <?php include 'header.html';  ?>
</head>
<body>
<?php
//// define empty variables
//$contactinfo = $workshopadress = $workshoppostcode = $workshopcity = $workshopleader = $workshopnotes = "";
//
//if ($_SERVER["REQUEST_METHOD"] == "POST") {
//    $contactinfo = check_input($_POST["contactinfo"]);
//    $workshopadress = check_input($_POST["workshopaddress"]);
//    $workshoppostcode = check_input($_POST["workshoppostcode"]);
//    $workshopcity = check_input($_POST["workshopcity"]);
//    $workshopleader = check_input($_POST["workshopleader"]);
//    $workshopnotes = check_input(@$_POST['workshopnotes']);
//}
//$host = 'localhost';
//$user = 'iseprojectuser';
//$pass = 'iseprojectww';
//
//$connectionInfo = array( "Database"=>"SQL", "UID"=>"iseprojectuser", "PWD"=>"iseprojectww" );
//$conn = sqlsrv_connect( $host, $connectionInfo);
//if( $conn === false ) {
//     die( print_r( sqlsrv_errors(), true));
//}
//
//$sql = "exec proc_create_workshop(?, ?, ?, ? , ?, ?,?,?,?,?,?)";
//$params = array(1, $workshoptype, 2, "");
//
//$stmt = sqlsrv_query( $conn, $sql, $params);
//if( $stmt === false ) {
//     die( print_r( sqlsrv_errors(), true));
//}
//
//mssql_free_statement($proc);
//
//function check_input($data) {
//  $data = trim($data);
//  $data = stripslashes($data);
//  $data = htmlspecialchars($data);
//  return $data;
//}
//
//?>
<div class="container">
    <h2>Aanvraag INC workshop</h2>
    <h3>Organisatie</h3>
    <form class="form-horizontal" action="">
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisationname">Naam Organisatie:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Naam organisatie" name="Organisationname">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Relationnumber">Relatie nummer:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Relatie nummer" name="Relationnumber">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="address">Adres:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Adres" name="address">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Postcode">Postcode:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Postcode" name="Postcode">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Town">Plaats:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Plaats" name="Town">
            </div>
        </div>
        <h3>Contactpersoon</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="contact_name">Contactpersoon:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="naam" name="contact_name">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="contact_telephonenumber">Telefoonnummer:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Telefoonnummer" name="contact_telephonenumber">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="contact_Email">Email:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Email" name="contact_Email">
            </div>
        </div>
        <h3>Coördinatie SBB</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopmodule">Module:</label>
            <div class="col-sm-10">
                <select class="form-control" name="workshopmodule">
                    <option>Selecteer module...</option>
                    <option>Module 1: Matching en Voorbereiding</option>
                    <option>Module 2: Begeleiding tijdens BPV</option>
                    <option>Module 3: Beoordeling</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopcompany">Organisatie:</label>
            <div class="col-sm-10">
                <select class="form-control" name="workshopcompany">
                    <option>Selecteer organisatie...</option>
                    <option>SBB</option>
                    <option>NSB</option>
                    <option>Lageschool van Arnhem en Duisburg</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopsector">Sector:</label>
            <div class="col-sm-10">
                <select class="form-control" name="workshopsector">
                    <option>Selecteer sector...</option>
                    <option>ZWS</option>
                    <option>NSB</option>
                    <option>BSN</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopstarttime">Begintijd workshop:</label>
            <div class="col-sm-10">
                <input type="time" class="form-control" placeholder="Begintijd" name="workshopstarttime">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopendtime">Eindtijd workshop:</label>
            <div class="col-sm-10">
                <input type="time" class="form-control" placeholder="Eindtijd" name="workshopendtime">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="workshoppostcode">Postcode workshop:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Postcode" name="workshoppostcode">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopcity">Plaats workshop:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Plaats" name="workshopcity">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopleader">Workshopleider workshop:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Workshopleider" name="workshopleader">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopnotes">Opmerkingen workshop:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Opmerkingen" name="workshopnotes">
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" class="btn btn-default">Submit</button>
            </div>
        </div>
    </form>
</div>

</body>
<?php include 'footer.html'; ?>
</html>
