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
// define (empty) variables
$workshoptype = $workshopdate = $contactinfo = $workshopmodule = $workshopcompany = $workshopsector = $starttime = $endtime =
$workshopadress = $workshoppostcode = $workshopcity = $workshopleader = $workshopnotes = '';

// The ones that do not get checked are dropdown or select.
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $workshoptype = $_POST["workshoptype"];
    $workshopdate = $_POST["workshopdate"];
    $contactinfo = check_input($_POST["contactinfo"]);
    $workshopmodule = $_POST["workshopmodule"];
    $workshopcompany = $_POST["workshopcompany"];
    $workshopsector = $_POST["workshopsector"];
    $starttime = $_POST["starttime"];
    $endtime = $_POST["endtime"];
    $workshopadress = check_input($_POST["workshopaddress"]);
    $workshoppostcode = check_input($_POST["workshoppostcode"]);
    $workshopcity = check_input($_POST["workshopcity"]);
    $workshopleader = check_input($_POST["workshopleader"]);
    $workshopnotes = check_input(@$_POST['workshopnotes']);

    //Try to make connection
    //connectToDB();

    //Run the stored procedure
    $sql = "exec proc_create_workshop(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $params = array($workshoptype, $workshopdate, $contactinfo, $workshopmodule, $workshopcompany, $workshopsector, $starttime,
        $endtime, $workshopadress, $workshoppostcode, $workshopcity, $workshopleader, $workshopnotes);
    $stmt = sqlsrv_query( $conn, $sql, $params);
    if( $stmt === false ) {
        die( print_r( sqlsrv_errors(), true));
    }
}

//mssql_free_statement($sql);
function selectBox($naamWaarde, $tabelnaam, $kolomnaam){

$sql = "exec proc_create_workshop(?, ?, ?, ? , ?, ?,?,?,?,?,?,?)";
$params = array(1, $workshoptype, 2, "");

    $handler = connectToDB();
    $select = '<select name="'.$naamWaarde.'">';
    $sql ="SELECT $kolomnaam FROM $tabelnaam ORDER BY $kolomnaam";

    $query = $handler->prepare($sql);
    $query->execute();

    while($resultaat = $query->fetch()){
        $select.= '<option value="'. $resultaat[$kolomnaam] . '">'. $resultaat[$kolomnaam] . '</option>';
    }
    $select .= '</select><br>';

    return $select;
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
