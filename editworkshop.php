<?php
if (!isset($_SESSION)) {
    session_start();
}

$errorMessage = null;

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

    $sql = "exec SP_get_workshops @where = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
    try {
        $stmt->execute();
    } catch (PDOException $e) {
        echo '<p class="alert-danger warning deletewarning">Kan workshops niet ophalen.</p>';
    }

    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    $workshoptype = $row['TYPE'];
    $workshopdate = $row['DATUM'];
    $contactinfo = $row['CONTACTPERSOON_VOORNAAM'] . ' ' . $row['CONTACTPERSOON_ACHTERNAAM'];

    $workshopsector = $row['SECTORNAAM'];
    $starttime = substr($row['STARTTIJD'], 0, 5);
    $endtime = substr($row['EINDTIJD'], 0, 5);
    $workshopaddress = $row['ADRES'];
    $workshoppostcode = $row['POSTCODE'];
    $workshopcity = $row['PLAATSNAAM'];
    $workshopleader = $row['WORKSHOPLEIDER_ID'];
    $workshopnotes = $row['OPMERKING'];
    $BREIN_date = $row['VERWERKT_BREIN'];
    $received_participantsinfo = $row['DEELNEMER_GEGEVENS_ONTVANGEN'];
    $OVK_received = $row['OVK_BEVESTIGING'];
    $attendance_list_send = $row['PRESENTIELIJST_VERSTUURD'];
    $attendance_list_received = $row['PRESENTIELIJST_ONTVANGEN'];
    $evidence_participation_mail = $row['BEWIJS_DEELNAME_MAIL_SBB_WSL'];
    $contactperson_name = $row['CONTACTPERSOON_NAAM'];
    $contactperson_email = $row['CONTACTPERSOON_EMAIL'];
    $contactperson_phonenumber = $row['CONTACTPERSOON_TELEFOONNUMMER'];

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $workshop_id = $_GET['workshop_id'];
        $workshopdate = $_POST["workshopdate"];
        $contactinfo = check_input($_POST["workshopContact"]);
        $workshopsector = $_POST["workshopsector"];
        $starttime = $_POST["workshopstarttime"];
        $endtime = $_POST["workshopendtime"];
        $workshopadress = check_input($_POST["workshopaddress"]);
        $workshoppostcode = check_input($_POST["workshoppostcode"]);
        $workshopcity = check_input($_POST["workshopcity"]);
        $workshopleader = check_input($_POST["workshopleader"]);
        $workshopnotes = check_input($_POST['workshopnotes']);
        $BREIN_date = check_input($_POST['Brein_date']);
        $received_participantsinfo = check_input($_POST['received_participantsinfo']);
        $OVK_received = check_input($_POST['OVK_received']);
        $attendance_list_send = check_input($_POST['attendance_list_send']);
        $attendance_list_received = check_input($_POST['attendance_list_received']);
        $evidence_participation_mail = check_input($_POST['evidence_participation_mail']);
        if ($row['TYPE'] == 'IND') {
            $contactperson_name = check_input($_POST['contactperson_name']);
            $contactperson_email = check_input($_POST['contactperson_email']);
            $contactperson_phonenumber = check_input($_POST['contactperson_phonenumber']);
        }

        if(strtotime($workshopdate) < time()){
            $errorMessage = 'De workshop mag niet in het verleden liggen';
            $workshopdate = $row['DATUM'];
        }else {
            if($OVK_received == "") {
                $OVK_received = null;
            }
            if($BREIN_date == "") {
                $BREIN_date = null;
            }
            if($received_participantsinfo == "") {
                $received_participantsinfo = null;
            }
            if($attendance_list_send == "") {
                $attendance_list_send = null;
            }
            if($attendance_list_received == "") {
                $attendance_list_received = null;
            }
            if($evidence_participation_mail == "") {
                $evidence_participation_mail = null;
            }

            // if the workshop is and IND workshop the last 3 parameters have to be not null
            if ($row['TYPE'] == 'IND') {
                //Run the stored procedure
                $sql = "exec SP_alter_workshop ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
                $stmt = $conn->prepare($sql);
                $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
                $stmt->bindParam(2, $workshopdate, PDO::PARAM_STR);
                $stmt->bindParam(3, $contactinfo, PDO::PARAM_INT);
                $stmt->bindParam(4, $workshopsector, PDO::PARAM_STR);
                $stmt->bindParam(5, $starttime, PDO::PARAM_STR);
                $stmt->bindParam(6, $endtime, PDO::PARAM_STR);
                $stmt->bindParam(7, $workshopadress, PDO::PARAM_STR);
                $stmt->bindParam(8, $workshoppostcode, PDO::PARAM_STR);
                $stmt->bindParam(9, $workshopcity, PDO::PARAM_STR);
                $stmt->bindParam(10, $workshopleader, PDO::PARAM_INT);
                $stmt->bindParam(11, $workshopnotes, PDO::PARAM_STR);
                $stmt->bindParam(12, $BREIN_date, PDO::PARAM_INT);
                $stmt->bindParam(13, $received_participantsinfo, PDO::PARAM_STR);
                $stmt->bindParam(14, $OVK_received, PDO::PARAM_STR);
                $stmt->bindParam(15, $attendance_list_send, PDO::PARAM_INT);
                $stmt->bindParam(16, $attendance_list_received, PDO::PARAM_INT);
                $stmt->bindParam(17, $evidence_participation_mail, PDO::PARAM_STR);
                $stmt->bindParam(18, $contactperson_name, PDO::PARAM_STR);
                $stmt->bindParam(19, $contactperson_email, PDO::PARAM_STR);
                $stmt->bindParam(20, $contactperson_phonenumber, PDO::PARAM_STR);
                try {
                    $stmt->execute();
                } catch (PDOException $e) {
                    echo '<p class="alert-danger warning deletewarning">Kan workshops niet wijzigen.</p>';
                }
            } else {
                // if the workshop type is not IND the last 3 parameters have to be null
                $sql = "exec SP_alter_workshop ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
                $stmt = $conn->prepare($sql);
                $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
                $stmt->bindParam(2, $workshopdate, PDO::PARAM_STR);
                $stmt->bindParam(3, $contactinfo, PDO::PARAM_INT);
                $stmt->bindParam(4, $workshopsector, PDO::PARAM_STR);
                $stmt->bindParam(5, $starttime, PDO::PARAM_STR);
                $stmt->bindParam(6, $endtime, PDO::PARAM_STR);
                $stmt->bindParam(7, $workshopadress, PDO::PARAM_STR);
                $stmt->bindParam(8, $workshoppostcode, PDO::PARAM_STR);
                $stmt->bindParam(9, $workshopcity, PDO::PARAM_STR);
                $stmt->bindParam(10, $workshopleader, PDO::PARAM_INT);
                $stmt->bindParam(11, $workshopnotes, PDO::PARAM_STR);
                $stmt->bindParam(12, $BREIN_date, PDO::PARAM_INT);
                $stmt->bindParam(13, $received_participantsinfo, PDO::PARAM_STR);
                $stmt->bindParam(14, $OVK_received, PDO::PARAM_STR);
                $stmt->bindParam(15, $attendance_list_send, PDO::PARAM_INT);
                $stmt->bindParam(16, $attendance_list_received, PDO::PARAM_INT);
                $stmt->bindParam(17, $evidence_participation_mail, PDO::PARAM_STR);
                try {
                    $stmt->execute();
                } catch (PDOException $e) {
                    echo '<p class="alert-danger warning deletewarning">Kan workshops niet wijzigen.</p>';
                }
            }
        }
    }

    generate_header('Workshop aanpassen');

    $getTypes = "SELECT * FROM WORKSHOPTYPE";
    $statement = $conn->prepare($getTypes);
    try {
        $statement->execute();
    } catch (PDOException $e) {
        echo '<p class="alert-danger warning deletewarning">Kan workshoptypes niet ophalen.</p>';
    }

    $types = $statement->fetchAll(PDO::FETCH_ASSOC);
    $dropdownTypes = '<option disabled> Kies een Type... </option>';

    foreach ($types as $type){
        if($type['TYPE'] == $workshoptype){
            $dropdownTypes .= '<option value="'.$type['TYPE'].'" selected> '.$type['TypeName'].'</option>';
        }else{
            $dropdownTypes .= '<option value="'.$type['TYPE'].'"> '.$type['TypeName'].'</option>';
        }
    }

    $getContact = "SELECT * FROM CONTACTPERSOON
                    WHERE ORGANISATIENUMMER = ?";

    $statement = $conn->prepare($getContact);
    $statement->bindParam(1, $workshop_id,PDO::PARAM_INT);
    try {
        $statement->execute();
    } catch (PDOException $e) {
        echo '<p class="alert-danger warning deletewarning">Kan workshoptypes niet ophalen.</p>';
    }
    $contacts = $statement->fetchAll(PDO::FETCH_ASSOC);
    $dropdownContact = '<option disabled> Kies een Contactpersoon...</option>';

    foreach($contacts as $contact){
        if($contact['CONTACTPERSOON_ID'] == $contactinfo){
            $dropdownContact .= '<option value="'. $contact['CONTACTPERSOON_ID'] .'" selected>' .$contact['VOORNAAM']. ' ' .$contact['ACHTERNAAM']. '</option>';
        }else{
            $dropdownContact .= '<option value="'. $contact['CONTACTPERSOON_ID'] .'">' .$contact['VOORNAAM']. ' ' .$contact['ACHTERNAAM']. '</option>';
        }
    }

    ?>

    <body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2 col-sm-4 sidebar1">
                <div class="left-navigation">
                    <ul class="list">
                        <h5><strong>Workshop Opties</strong></h5>
                        <?php

                        if ($_SESSION['username'] == "planner") {
                            echo '<li>';
                            echo '<a href="workshop.php?workshop_id='.$workshop_id.'">Details</a>';
                            echo '</li>';
                        } elseif($_SESSION['username'] == "contactpersoon") {
                            echo '<li>';
                            echo '<a href="Organisatie_workshop_details.php?workshop_id='.$workshop_id.'">Details</a>';
                            echo '</li>';
                        }
                        ?>
                        <li>
                            <a href="workshop_participants.php?workshop_id=<?= $workshop_id ?>">Deelnemers</a>
                        </li>
                        <?php
                        if ($workshoptype == "IND") {
                            echo '<li>';
                            echo '<a href="open_registrations.php?workshop_id=' . $workshop_id . '">Openstaande inschrijvingen</a>';
                            echo '</li>';
                        }
                        ?>
                        <li>
                            <a href="reservelist.php?workshop_id=<?= $workshop_id ?>">Reservelijst</a>
                        </li>
                        <li>
                            <a class="active-page" >Wijzig workshop</a>
                        </li>
                        <li>
                            <a href="addparticipant_workshop.php?workshop_id=<?= $workshop_id ?>">Voeg deelnemers toe</a>
                        </li>
                    </ul>
                    <br>
                </div>
            </div>
            <div class="container">
                <h2 class="text-info text-center">Wijzig workshop <?php echo $workshop_id ?></h2>
                <?= $errorMessage ?>
                <form class="form-horizontal" action="editworkshop.php?workshop_id=<?php echo $workshop_id ?>" method="post">
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
                            <select class="form-control" name="workshopContact">
                            <?= $dropdownContact ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2 font-weight-bold" for="workshopsector">Sector:</label>
                        <div class="col-sm-10">
                            <?php
                            echo selectBox("workshopsector", "sector", array("sectornaam"), "sectornaam", array("sectornaam"), "sectornaam");
                            ?>
                            <script href="text/javascript">
                                var val = '<?php echo $row['SECTORNAAM']; ?>';
                                $('#workshopsector').find('option[value='+val+']').attr('selected','selected');
                            </script>
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
                            echo selectBox(
                                "workshopleader",
                                "workshopleider w INNER JOIN beschikbaarheid b ON w.workshopleider_id = b.workshopleider_id",
                                array("achternaam", "voornaam", "W.workshopleider_id"), "workshopleider_id",
                                array("achternaam", "voornaam"), "achternaam, voornaam", NULL,
                                "AANTAL_UUR - (CAST(DATEDIFF(minute, '$starttime', '$endtime') AS NUMERIC(5,2)) / 60.00) >= 0
                                 AND    JAAR = YEAR('$workshopdate')
                                 AND    KWARTAAL = DATEPART(QUARTER, '$workshopdate')");
                            ?>
                            <script>
                               var dropdown = $("#workshopleader");

                                var val = '<?php echo $workshopleader; ?>';
                                if(val === ''){
                                    dropdown.find('option[value=""]').attr('selected','selected');
                                }else{
                                    dropdown.find('option[value='+val+']').attr('selected','selected');
                                }

                            </script>
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
                        <label class="control-label col-sm-3 font-weight-bold" for="Brein_date">Verwerkt in BREIN op:</label>
                        <div class="col-sm-10">
                            <input type="date" class="form-control" placeholder="Onbekend" name="Brein_date"
                                   value="<?php echo $BREIN_date ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-4 font-weight-bold" for="received_participantsinfo">Deelnemer gegevens ontvangen op:</label>
                        <div class="col-sm-10">
                            <input type="date" class="form-control" placeholder="Onbekend" name="received_participantsinfo"
                                   value="<?php echo $received_participantsinfo ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-3 font-weight-bold" for="OVK_received">OVK bevestiging op:</label>
                        <div class="col-sm-10">
                            <input type="date" class="form-control" placeholder="Onbekend" name="OVK_received"
                                   value="<?php echo $OVK_received ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-3 font-weight-bold" for="attendance_list_send">Presentielijst verstuurd op:</label>
                        <div class="col-sm-10">
                            <input type="date" class="form-control" placeholder="Onbekend" name="attendance_list_send"
                                   value="<?php echo $attendance_list_send ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-3 font-weight-bold" for="attendance_list_received">Presentielijst ontvangen op:</label>
                        <div class="col-sm-10">
                            <input type="date" class="form-control" placeholder="Onbekend" name="attendance_list_received"
                                   value="<?php echo $attendance_list_received ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-4 font-weight-bold" for="evidence_participation_mail">Bewijs deelname mail SBB WSL op:</label>
                        <div class="col-sm-10">
                            <input type="date" class="form-control" placeholder="Onbekend" name="evidence_participation_mail"
                                   value="<?php echo $evidence_participation_mail ?>">
                        </div>
                    </div>

                    <?php if($workshoptype == 'IND') {?>

                    <div class="form-group">
                        <label class="control-label col-sm-3 font-weight-bold" for="contactperson_name">Contactpersoon naam (voor IND workshops):</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" placeholder="Onbekend" name="contactperson_name"
                                   value="<?php echo $contactperson_name ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-3 font-weight-bold" for="contactperson_email">Contactpersoon email (voor IND workshops):</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" placeholder="Onbekend" name="contactperson_email"
                                   value="<?php echo $contactperson_email ?>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-3 font-weight-bold" for="contactperson_phonenumber">Contactpersoon telefoonnummer (voor IND workshops):</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" placeholder="Onbekend" name="contactperson_phonenumber"
                                   value="<?php echo $contactperson_phonenumber ?>">
                        </div>
                    </div>
                    <?php } ?>

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
    notLoggedIn();
}

include 'footer.php';
