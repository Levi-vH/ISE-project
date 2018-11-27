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
// define empty variables
$contactinfo = $workshopadress = $workshoppostcode = $workshopcity = $workshopleader = $workshopnotes = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $contactinfo = check_input($_POST["contactinfo"]);
    $workshopadress = check_input($_POST["workshopaddress"]);
    $workshoppostcode = check_input($_POST["workshoppostcode"]);
    $workshopcity = check_input($_POST["workshopcity"]);
    $workshopleader = check_input($_POST["workshopleader"]);
    $workshopnotes = check_input(@$_POST['workshopnotes']);
}
$host = 'localhost';
$user = 'iseprojectuser';
$pass = 'iseprojectww';

/*$conn = mssql_connect($host, $user, $pass);
mssql_select_db('SBBWorkshopOmgeving', $conn);

// Call a simple query
$result = mssql_query('SELECT * FROM sometable', $conn);

// Release the result resource
mssql_free_result($result);

// Then execute the procedure
$proc = mssql_init('proccreateworkshop', $conn);
$proc_result = mssql_execute($proc);

mssql_free_statement($proc);
?>
*/

function check_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}

?>
<div class="container">
    <h2>Maak een nieuwe workshop</h2>
    <form class="form-horizontal" action="/createworkshop.php">
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshoptype">Type workshop:</label>
            <div class="col-sm-10">
                <select class="form-control" name="workshoptype">
                    <option>TYPE...</option>
                    <option>INCOMPANY</option>
                    <option>INDIVIDUEEL</option>
                    <option>LARGE ACCOUNTS</option>
                    <option>COM</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopdate">Datum workshop:</label>
            <div class="col-sm-10">
                <input type="date" class="form-control" placeholder="Enter password" name="workshopdate">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="contactinfo">Contactpersoon:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Contactpersoon gegevens" name="contactinfo">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopmodule">Module:</label>
            <div class="col-sm-10">
                <select class="form-control" id="sel1">
                    <option>Selecteer module...</option>
                    <option>Module 1: Matching en Voorbereiding</option>
                    <option>Module 2: Begeleiding tijdens BPV</option>
                    <option>Module 3: Beoordeling</option>
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
            <label class="control-label col-sm-2" for="workshopaddress">Adres workshop:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Adres" name="workshopaddress">
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
