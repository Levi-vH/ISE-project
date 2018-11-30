<?php
include 'header.html';
include 'functions.php';

$id = $_GET['id'];

// define (empty) variables
$workshoptype = $workshopdate = $contactinfo = $workshopmodule = $workshopcompany = $workshopsector = $starttime = $endtime =
$workshopadress = $workshoppostcode = $workshopcity = $workshopleader = $workshopnotes = '';

//Try to make connection
$conn = connectToDB();

//Run the stored procedure
// $sql = "SELECT * FROM VW_WORKSHOPS";
$sql = "exec proc_getWorkshops @where = ?";
$stmt = $conn->prepare($sql);
$stmt->bindParam(1, $id, PDO::PARAM_INT);
$stmt->execute();

$row = $stmt->fetch(PDO::FETCH_ASSOC);
$workshoptype = $row['TYPE'];
$workshopdate = $row['DATUM'];
$contactinfo = $row['CONTACTPERSOON_VOORNAAM'].' '.$row['CONTACTPERSOON_ACHTERNAAM'];
//$workshopmodule = $row['MODULENAAM'];
//$workshopcompany = $row['ORGANISATIENAAM'];
//$workshopsector = $row['WORKSHOP_SECTOR'];
$starttime = substr($row['STARTTIJD'], 0, 5);
$endtime = substr($row['EINDTIJD'], 0, 5);
$workshopaddress = $row['ADRES'];
$workshoppostcode = $row['POSTCODE'];
$workshopcity = $row['PLAATSNAAM'];
//$workshopleader = $row['WORKSHOPLEIDER_VOORNAAM'];
$workshopnotes = $row['OPMERKING'];


//Try to make connection
//$conn = connectToDB();

//Run the stored procedure
//$sql = "exec proc_create_workshop ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
//$stmt = $conn->prepare($sql);
//$stmt->bindParam(1, $workshoptype, PDO::PARAM_STR);
//$stmt->bindParam(2, $workshopdate, PDO::PARAM_STR);
////$stmt->bindParam(3, $contactinfo, PDO::PARAM_STR);
//$stmt->bindParam(3, $workshopmodule, PDO::PARAM_INT);
//$stmt->bindParam(4, $workshopcompany, PDO::PARAM_INT);
//$stmt->bindParam(5, $workshopsector, PDO::PARAM_STR);
//$stmt->bindParam(6, $starttime, PDO::PARAM_STR);
//$stmt->bindParam(7, $endtime, PDO::PARAM_STR);
//$stmt->bindParam(8, $workshopadress, PDO::PARAM_STR);
//$stmt->bindParam(9, $workshoppostcode, PDO::PARAM_STR);
//$stmt->bindParam(10, $workshopcity, PDO::PARAM_STR);
//$stmt->bindParam(11, $workshopleader, PDO::PARAM_STR);
//$stmt->bindParam(12, $workshopnotes, PDO::PARAM_STR);
//$stmt->execute();

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>maak workshop</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
          integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
            integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
            integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css"
          integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
    <link rel="stylesheet" href="css/custom.css">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-sm-4 sidebar1">
            <div class="left-navigation">
                <ul class="list">
                    <h5><strong>Workshop Opties</strong></h5>
                    <li>
                        <a href="participants.php?id=<?php echo $id ?>">Inzien deelnemers</a>
                    </li>
                    <li>
                        <a class="active-page">Wijzig workshop</a>
                    </li>
                    <li>
                        <a href="INCworkshop.php">K</a>
                    </li>
                    <li>
                        <a href="allworkshops.php">P</a>
                    </li>
                    <li>
                        <a href="allworkshops.php">H</a>
                    </li>
                </ul>

                <br>
            </div>
        </div>

        <div class="container">
            <h2 class="text-info text-center">Wijzig workshop <?php echo $id ?></h2>
            <form class="form-horizontal" action="createworkshop.php" method="post">
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshoptype">Type workshop:</label>
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
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopdate">Datum workshop:</label>
                    <div class="col-sm-10">
                        <input type="date" class="form-control" placeholder="Enter password" name="workshopdate"
                               value="<?php echo $workshopdate ?>">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="contactinfo">Contactpersoon:</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" placeholder="Contactpersoon gegevens" name="contactinfo"
                               value="<?php echo $contactinfo ?>">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopmodule">Module:</label>
                    <div class="col-sm-10">
                        <?php
                        echo selectBox("workshopmodule", "module", array("modulenummer", "modulenaam"), "modulenummer", array("modulenummer", "modulenaam"), "modulenummer");
                        ?>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopcompany">Organisatie:</label>
                    <div class="col-sm-10">
                        <?php
                        echo selectBox("workshopcompany", "organisatie", array("organisatienaam", "organisatienummer"), "organisatienummer", array("organisatienaam"), "organisatienaam");
                        ?>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopsector">Sector:</label>
                    <div class="col-sm-10">
                        <?php
                        echo selectBox("workshopsector", "sector", array("sectornaam"), "sectornaam", array("sectornaam"), "sectornaam");
                        ?>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopstarttime">Begintijd
                        workshop:</label>
                    <div class="col-sm-10">
                        <input type="time" class="form-control" placeholder="Begintijd" name="workshopstarttime"
                               value="<?php echo $starttime ?>">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopendtime">Eindtijd
                        workshop:</label>
                    <div class="col-sm-10">
                        <input type="time" class="form-control" placeholder="Eindtijd" name="workshopendtime"
                               value="<?php echo $endtime ?>">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopaddress">Adres workshop:</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" placeholder="Adres" name="workshopaddress"
                               value="<?php echo $workshopaddress ?>">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshoppostcode">Postcode
                        workshop:</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" placeholder="Postcode" name="workshoppostcode"
                               value="<?php echo $workshoppostcode ?>">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopcity">Plaats workshop:</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" placeholder="Plaats" name="workshopcity"
                               value="<?php echo $workshopcity ?>">
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopleader">Workshopleider:</label>
                    <div class="col-sm-10">
                        <?php
                        echo selectBox("workshopleader", "workshopleider", array("achternaam", "voornaam", "workshopleider_id"), "workshopleider_id", array("achternaam", "voornaam"), "achternaam, voornaam");
                        ?>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-sm-2 font-weight-bold" for="workshopnotes">Opmerkingen:</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" placeholder="Opmerkingen" name="workshopnotes"
                               value="<?php echo $workshopnotes ?>">
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <button type="submit" class="btn btn-default">Submit</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
<?php include 'footer.html'; ?>
</html>
