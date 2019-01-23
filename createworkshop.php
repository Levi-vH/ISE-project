<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

$errorMessage = null;

if ($_SESSION['username'] == 'planner') {
// define (empty) variables
    $workshopdate = $contactsbb = $workshopmodule = $workshopsector = $starttime = $endtime =
    $workshopadress = $workshopcity = $workshoppostcode = $workshopleader = $workshopnotes =
    $contactcompanyname = $contactcompanyemail = $contactcompanyphone = '';

// The ones that do not get checked are dropdown or select.
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $workshopdate = $_POST["workshopdate"];
        $contactsbb = $_POST["Coordination_Contact"];
        $workshopmodule = $_POST["workshopmodule"];
        $workshopsector = $_POST["workshopsector"];
        $starttime = $_POST["workshopstarttime"];
        $endtime = $_POST["workshopendtime"];
        $workshopadress = check_input($_POST["workshopaddress"]);
        $workshopcity = check_input($_POST["workshopcity"]);
        $workshoppostcode = check_input($_POST["workshoppostalcode"]);
        $workshopleader = check_input($_POST["workshopleader"]);
        $workshopnotes = check_input($_POST["workshopnotes"]);
        $contactcompanyname = check_input($_POST['contactcompanyname']);
        $contactcompanyemail = check_input($_POST['contactcompanyemail']);
        $contactcompanyphone = check_input($_POST["contactcompanyphone"]);

        //Try to make connection
        $conn = connectToDB();

        //Run the stored procedure
        $sql = "exec SP_insert_workshop ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(1, $workshopdate, PDO::PARAM_STR);
        $stmt->bindParam(2, $contactsbb, PDO::PARAM_INT);
        $stmt->bindParam(3, $workshopmodule, PDO::PARAM_INT);
        $stmt->bindParam(4, $workshopsector, PDO::PARAM_STR);
        $stmt->bindParam(5, $starttime, PDO::PARAM_STR);
        $stmt->bindParam(6, $endtime, PDO::PARAM_STR);
        $stmt->bindParam(7, $workshopadress, PDO::PARAM_STR);
        $stmt->bindParam(8, $workshopcity, PDO::PARAM_STR);
        $stmt->bindParam(9, $workshoppostcode, PDO::PARAM_STR);
        $stmt->bindParam(10, $workshopleader, PDO::PARAM_INT);
        $stmt->bindParam(11, $workshopnotes, PDO::PARAM_STR);
        $stmt->bindParam(12, $contactcompanyname, PDO::PARAM_STR);
        $stmt->bindParam(13, $contactcompanyemail, PDO::PARAM_STR);
        $stmt->bindParam(14, $contactcompanyphone, PDO::PARAM_STR);
        $stmt->execute();

//        try {
//        } catch (PDOException $e) {
//            echo '<p class="alert-danger warning deletewarning">Email moet een @ en punt bevatten en de workshop mag niet in het verleden liggen(of er is iets misgegaan in de database)</p>';
//        }


        $sql2 = "SELECT TOP 1 WORKSHOP_ID FROM WORKSHOP ORDER BY WORKSHOP_ID DESC";
        $stmt2 = $conn->prepare($sql2);
        $stmt2->execute();

        $row = $stmt2->fetch(PDO::FETCH_ASSOC);

        header('Location: workshop.php?workshop_id=' . $row['WORKSHOP_ID']);
    }

    generate_header('Workshop aanmaken');
    ?>

    <body>
    <div class="container">
        <h2 class="text-info text-center">Maak een nieuwe workshop</h2>
        <form class="form-horizontal" action="createworkshop.php" method="post">
            <?= $errorMessage ?>
            <h2 class="text-info">Algemeen</h2>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="workshopdate">Datum workshop:</label>
                <div class="col-sm-10">
                    <input type="date" class="form-control" name="workshopdate" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-6 font-weight-bold" for="Coordination_Contact">Contactpersoon
                    SBB:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="Coordination_Contact"
                           value="<?= $_SESSION['planner'] ?>" readonly>
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
                    <input type="time" class="form-control" placeholder="Begintijd" name="workshopstarttime" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="workshopendtime">Eindtijd workshop:</label>
                <div class="col-sm-10">
                    <input type="time" class="form-control" placeholder="Eindtijd" name="workshopendtime" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="workshopaddress">Adres workshop:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" placeholder="Adres" name="workshopaddress" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="workshopcity">Plaats workshop:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" placeholder="Plaats" name="workshopcity" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="workshoppostalcode">Postcode
                    workshop:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" placeholder="Postcode" name="workshoppostalcode" required>
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
                    <input type="text" class="form-control" placeholder="Opmerkingen" name="workshopnotes">
                </div>
            </div>
            <h2 class="text-info">Contactpersoon Bedrijf</h2>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="contactcompanyname">Naam:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" placeholder="Naam" name="contactcompanyname" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="contactcompanyemail">Email:</label>
                <div class="col-sm-10">
                    <input type="email" class="form-control" placeholder="Email" name="contactcompanyemail" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="contactcompanyphone">Telefoonnummer:</label>
                <div class="col-sm-10">
                    <input type="number" class="form-control" placeholder="Telefoonnummer" name="contactcompanyphone">
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-success btn-lg">Maak aan</button>
                </div>
            </div>
        </form>
    </div>
    </body>
    </html>
    <?php
} else {
    notLoggedIn();
}
include 'footer.php';
