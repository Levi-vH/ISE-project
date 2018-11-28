<?php
include 'header.html';
include 'functions.php';

// define (empty) variables
$workshoptype = $workshopdate = $contactinfo = $workshopmodule = $workshopcompany = $workshopsector = $starttime = $endtime =
$workshopadress = $workshoppostcode = $workshopcity = $workshopleader = $workshopnotes = '';

// The ones that do not get checked are dropdown or select.
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $workshoptype = $_POST["workshoptype"];
    $workshopdate = $_POST["workshopdate"];
    //$contactinfo = check_input($_POST["contactinfo"]);
    $workshopmodule = $_POST["workshopmodule"];
    $workshopcompany = $_POST["workshopcompany"];
    $workshopsector = $_POST["workshopsector"];
    $starttime = $_POST["workshopstarttime"];
    $endtime = $_POST["workshopendtime"];
    $workshopadress = check_input($_POST["workshopaddress"]);
    $workshoppostcode = check_input($_POST["workshoppostcode"]);
    $workshopcity = check_input($_POST["workshopcity"]);
    $workshopleader = check_input($_POST["workshopleader"]);
    $workshopnotes = check_input(@$_POST['workshopnotes']);

    //Try to make connection
    $conn = connectToDB();

    //Run the stored procedure
    $sql = "exec proc_create_workshop ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $workshoptype, PDO::PARAM_STR);
    $stmt->bindParam(2, $workshopdate, PDO::PARAM_STR);
    //$stmt->bindParam(3, $contactinfo, PDO::PARAM_STR);
    $stmt->bindParam(3, $workshopmodule, PDO::PARAM_INT);
    $stmt->bindParam(4, $workshopcompany, PDO::PARAM_INT);
    $stmt->bindParam(5, $workshopsector, PDO::PARAM_STR);
    $stmt->bindParam(6, $starttime, PDO::PARAM_STR);
    $stmt->bindParam(7, $endtime, PDO::PARAM_STR);
    $stmt->bindParam(8, $workshopadress, PDO::PARAM_STR);
    $stmt->bindParam(9, $workshoppostcode, PDO::PARAM_STR);
    $stmt->bindParam(10, $workshopcity, PDO::PARAM_STR);
    $stmt->bindParam(11, $workshopleader, PDO::PARAM_STR);
    $stmt->bindParam(12, $workshopnotes, PDO::PARAM_STR);
    $stmt->execute();
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
    <h2 class="text-info text-center">Maak een nieuwe workshop</h2>
    <form class="form-horizontal" action="createworkshop.php" method="post">
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
                <?php
             echo selectBox("workshopmodule", "module",array("modulenummer", "modulenaam"), "modulenummer", array("modulenummer", "modulenaam"), "modulenummer");
                ?>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopcompany">Organisatie:</label>
            <div class="col-sm-10">
                <?php
                echo selectBox("workshopcompany", "organisatie",array("organisatienaam", "organisatienummer"), "organisatienummer", array("organisatienaam"), "organisatienaam");
                ?>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopsector">Sector:</label>
            <div class="col-sm-10">
                <?php
               echo selectBox("workshopsector", "sector",array("sectornaam"), "sectornaam", array("sectornaam"), "sectornaam");
                ?>
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
                <?php
                echo selectBox("workshopleader", "workshopleider",array("achternaam", "voornaam", "workshopleider_id"), "workshopleider_id", array("achternaam", "voornaam"), "achternaam, voornaam");
                ?>
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
