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
// $sql = "SELECT * FROM VW_WORKSHOPS";
    $sql = "exec SP_get_workshops @where = ?";
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
    $workshopleader = $row['WORKSHOPLEIDER_ID'];
    $workshopnotes = $row['OPMERKING'];

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        
        $workshoptype = $_POST["workshoptype"];
        $workshopdate = $_POST["workshopdate"];
        $contactinfo = check_input($_POST["workshopContact"]);
        $workshopmodule = $_POST["workshopmodule"];
        $workshopcompany = $_POST["workshopcompany"];
        $workshopsector = $_POST["workshopsector"];
        $starttime = $_POST["workshopstarttime"];
        $endtime = $_POST["workshopendtime"];
        $workshopadress = check_input($_POST["workshopaddress"]);
        $workshoppostcode = check_input($_POST["workshoppostcode"]);
        $workshopcity = check_input($_POST["workshopcity"]);
        $workshopleader = check_input($_POST["workshopleader"]);
        $workshopnotes = check_input($_POST['workshopnotes']);

        if(strtotime($workshopdate) < time()){
            $errorMessage = 'De workshop mag niet in het verleden liggen';
            $workshopdate = $row['DATUM'];
        }else {

            //Run the stored procedure
            $sql = "exec SP_alter_workshop ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
            $stmt->bindParam(2, $workshoptype, PDO::PARAM_STR);
            $stmt->bindParam(3, $workshopdate, PDO::PARAM_STR);
            $stmt->bindParam(4, $contactinfo, PDO::PARAM_INT);
            $stmt->bindParam(5, $workshopmodule, PDO::PARAM_INT);
            $stmt->bindParam(6, $workshopcompany, PDO::PARAM_STR);
            $stmt->bindParam(7, $workshopsector, PDO::PARAM_STR);
            $stmt->bindParam(8, $starttime, PDO::PARAM_STR);
            $stmt->bindParam(9, $endtime, PDO::PARAM_STR);
            $stmt->bindParam(10, $workshopadress, PDO::PARAM_STR);
            $stmt->bindParam(11, $workshoppostcode, PDO::PARAM_STR);
            $stmt->bindParam(12, $workshopcity, PDO::PARAM_STR);
            $stmt->bindParam(13, $workshopleader, PDO::PARAM_INT);
            $stmt->bindParam(14, $workshopnotes, PDO::PARAM_STR);
            $stmt->execute();

        }
    }

    generate_header('Workshop aanpassen');

    $getTypes = "SELECT * FROM WORKSHOPTYPE";
    $statement = $conn->prepare($getTypes);
    $statement->execute();

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
    $statement->execute();


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
                        <label class="control-label col-sm-2 font-weight-bold" for="workshoptype">Type workshop:</label>
                        <div class="col-sm-10">
                            <select class="form-control" name="workshoptype">
                               <?= $dropdownTypes ?>
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
                            <select class="form-control" name="workshopContact">
                            <?= $dropdownContact ?>
                            </select>
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
                                modulenummer = <?php echo getModuleNummer($workshop_id)?>;
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
                            <script href="text/javascript">
                                var val = '<?php echo $row['ORGANISATIENAAM']; ?> ';
                                $('#workshopcompany option').each(function (){
                                    if($(this).text() === val){
                                        $(this).attr('selected', 'selected');
                                        return false;
                                    }
                                    return true;
                                });
                            </script>
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
                            echo selectBox("workshopleader", "workshopleider", array("achternaam", "voornaam", "workshopleider_id"), "workshopleider_id", array("achternaam", "voornaam"), "achternaam, voornaam");
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
include 'footer.html';
