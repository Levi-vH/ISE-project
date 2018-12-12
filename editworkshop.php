<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

if ($_SESSION['username'] == 'planner') {

    $workshop_id = $_GET['workshop_id'];
    $workshoptypeget = getWorkshopType($workshop_id);

// define (empty) variables
    $workshoptype = $workshopdate = $contactinfo = $workshopmodule = $workshopcompany = $workshopsector = $starttime = $endtime =
    $workshopadress = $workshoppostcode = $workshopcity = $workshopleader = $workshopnotes = '';

//Try to make connection
    $conn = connectToDB();

//Run the stored procedure
// $sql = "SELECT * FROM VW_WORKSHOPS";
    $sql = "exec proc_get_workshops @where = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
    $stmt->execute();

    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $workshoptype = $row['TYPE'];
    $workshopdate = $row['DATUM'];
    $contactinfo = $row['CONTACTPERSOON_VOORNAAM'] . ' ' . $row['CONTACTPERSOON_ACHTERNAAM'];
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

        //Run the stored procedure
        $sql = "exec proc_update_workshop ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(1, $workshop_id, PDO::PARAM_STR);
        $stmt->bindParam(2, $workshoptype, PDO::PARAM_STR);
        $stmt->bindParam(3, $workshopdate, PDO::PARAM_STR);
        //$stmt->bindParam(3, $contactinfo, PDO::PARAM_STR);
        $stmt->bindParam(4, $workshopmodule, PDO::PARAM_INT);
        $stmt->bindParam(5, $workshopcompany, PDO::PARAM_INT);
        $stmt->bindParam(6, $workshopsector, PDO::PARAM_STR);
        $stmt->bindParam(7, $starttime, PDO::PARAM_STR);
        $stmt->bindParam(8, $endtime, PDO::PARAM_STR);
        $stmt->bindParam(9, $workshopadress, PDO::PARAM_STR);
        $stmt->bindParam(10, $workshoppostcode, PDO::PARAM_STR);
        $stmt->bindParam(11, $workshopcity, PDO::PARAM_STR);
        $stmt->bindParam(12, $workshopleader, PDO::PARAM_STR);
        $stmt->bindParam(13, $workshopnotes, PDO::PARAM_STR);
        $stmt->execute();
    }

    generate_header('Workshop aanpassen');
    ?>

    <body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2 col-sm-4 sidebar1">
                <div class="left-navigation">
                    <ul class="list">
                        <h5><strong>Workshop Opties</strong></h5>
                        <li>
                            <a href="workshop.php?workshop_id=<?php echo $workshop_id ?>">Details</a>
                        </li>
                        <li>
                            <a href="open_workshop_participants.php?workshop_id=<?php echo $workshop_id ?>">Inzien deelnemers</a>
                        </li>
                        <?php
                        if ($workshoptypeget != 'INC') {
                            echo '<li>';
                            echo '<a href="open_registrations.php?workshop_id=' . $workshop_id . '">Openstaande inschrijvingen</a>';
                            echo '</li>';
                            echo '<li>';
                            echo '<a href="reservelist.php?workshop_id=' . $workshop_id . '">Reservelijst</a>';
                            echo '</li>';
                        }
                        ?>
                        <li>
                            <a class="active-page">Wijzig workshop</a>
                        </li>
                        <?php
                        if ($workshoptypeget == 'INC') {
                            echo '<li>';
                            echo '<a href="addparticipant.php?workshop_id=' . $workshop_id . '">Voeg deelnemers toe</a>';
                            echo '</li>';
                        }
                        ?>
                    </ul>
                    <br>
                </div>
            </div>

            <div class="container">
                <h2 class="text-info text-center">Wijzig workshop <?php echo $workshop_id ?></h2>
                <form class="form-horizontal" action="editworkshop.php?id=<?php echo $workshop_id ?>" method="post">
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
                        <label class="control-label col-sm-2 font-weight-bold" for="workshopdate">Datum
                            workshop:</label>
                        <div class="col-sm-10">
                            <input type="date" class="form-control" placeholder="Enter password" name="workshopdate"
                                   value="<?php echo $workshopdate ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2 font-weight-bold" for="contactinfo">Contactpersoon:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" placeholder="Contactpersoon gegevens"
                                   name="contactinfo"
                                   value="<?php echo $contactinfo ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2 font-weight-bold" for="workshopmodule">Module:</label>
                        <div class="col-sm-10">
                            <?php
                            echo selectBox("workshopmodule", "module", array("modulenummer", "modulenaam"), "modulenummer", array("modulenummer", "modulenaam"), "modulenummer");
                            ?>
                            <script href="text/javascript">
                                var sel = document.getElementById("workshopmodule");
                                var modulenummer;
                                modulenummer = <?php echo getModuleNummer($workshop_id)?> -1;
                                sel.selectedIndex = modulenummer;
                            </script>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2 font-weight-bold"
                               for="workshopcompany">Organisatie:</label>
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
                        <label class="control-label col-sm-2 font-weight-bold" for="workshopaddress">Adres
                            workshop:</label>
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
                        <label class="control-label col-sm-2 font-weight-bold" for="workshopcity">Plaats
                            workshop:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" placeholder="Plaats" name="workshopcity"
                                   value="<?php echo $workshopcity ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2 font-weight-bold"
                               for="workshopleader">Workshopleider:</label>
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
                            <button type="submit" class="btn btn-default">Update workshop</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </body>
    </html>
<?php } else {
    echo '<h1> U mag deze pagina niet bezoeken</h1>';
}
include 'footer.html';
