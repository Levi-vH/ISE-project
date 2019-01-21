<?php
include 'functions.php';
generate_header('Workshop Details');

if (!isset($_SESSION)) {
    session_start();
}

$workshop_id = $_GET['workshop_id'];
$workshoptype = getWorkshopType($workshop_id);


$conn = connectToDB();

//Run the stored procedure
$sql = "exec SP_get_workshops @where = ?";
$stmt = $conn->prepare($sql);
$stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
$stmt->execute();

$row = $stmt->fetch(PDO::FETCH_ASSOC);

foreach ($row as $key => $value) {
    if ($value == '') {
        $row[$key] = 'Nog niet bekend';
    }
}

$workshopleader = $row['WORKSHOPLEIDER_VOORNAAM'] . ' ' . $row['WORKSHOPLEIDER_ACHTERNAAM'];

if ($row['WORKSHOPLEIDER_VOORNAAM'] == 'Nog niet bekend' OR $row['WORKSHOPLEIDER_ACHTERNAAM'] == 'Nog niet bekend') {
    $workshopleader = 'Nog niet bekend';
}


?>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-sm-4 sidebar1">
            <div class="left-navigation">
                <ul class="list">
                    <h5><strong>Workshop Opties</strong></h5>
                    <li>
                        <a class="active-page">Details</a>
                    </li>
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
                    <?php
                    if ($_SESSION['username'] == "planner") {
                        echo '<li>';
                        echo '<a href="editworkshop.php?workshop_id=' . $workshop_id . '">Wijzig workshop</a>';
                        echo '</li>';
                    }
                    ?>
                    <li>
                        <a href="addparticipant_workshop.php?workshop_id=<?= $workshop_id ?>">Voeg deelnemers toe</a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="col-md-10 col-sm-8 main-content">
            <!--Main content code to be written here -->
            <div class="details-container">
                <div class="workshop-details details">
                    <h3> Workshop Details</h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Organisatie:
                        </div>
                        <div class="details-value">
                            <?= $row['ORGANISATIENAAM'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Module:
                        </div>
                        <div class="details-value">
                            <?= $row['MODULENUMMER'] . ': ' . $row['MODULENAAM'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Type:
                        </div>
                        <div class="details-value">
                            <?= $row['TYPE'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Datum:
                        </div>
                        <div class="details-value">
                            <?= date('j F Y', strtotime($row['DATUM'])) ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Starttijd:
                        </div>
                        <div class="details-value">
                            <?= substr($row['STARTTIJD'], 0, 5) ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Eindtijd:
                        </div>
                        <div class="details-value">
                            <?= substr($row['EINDTIJD'], 0, 5) ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Adres:
                        </div>
                        <div class="details-value">
                            <?= $row['ADRES'] . ' ' . $row['PLAATSNAAM'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Postcode:
                        </div>
                        <div class="details-value">
                            <?= $row['POSTCODE'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Status:
                        </div>
                        <div class="details-value">
                            <?= $row['STATUS'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Workshopleider:
                        </div>
                        <div class="details-value">
                            <?= $workshopleader ?>
                        </div>

                    </div>
                </div>

                <div class="recieved-details details">
                    <h3> Ontvangen gegevens</h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Verwerkt in BREIN:
                        </div>
                        <div class="details-value">
                            <?= $row['VERWERKT_BREIN'] ?>
                        </div>

                    </div>
                    <!--<div class="detail-row">
                        <div class="details-column">
                            Deelnemer gegevens ontvangen:
                        </div>
                        <div class="details-value">
                            < ?= $row['DEELNEMER_GEGEVENS_ONTVANGEN'] ?>
                        </div>

                    </div>-->
                    <?php
                    if ($row['TYPE'] !== 'IND') {
                        ?>

                        <div class="detail-row">
                            <div class="details-column">
                                OVK_Bevestiging:
                            </div>
                            <div class="details-value">
                                <?= $row['OVK_BEVESTIGING'] ?>
                            </div>

                        </div>
                    <?php } ?>
                    <div class="detail-row">
                        <div class="details-column">
                            Presentielijst verstuurd:
                        </div>
                        <div class="details-value">
                            <?= $row['PRESENTIELIJST_VERSTUURD'] ?>
                        </div>

                    </div>
                </div>

                <?php
                if ($row['TYPE'] !== 'IND') {
                ?>
                <div class="adviseur-details details">
                    <h3> Adviseur vanuit SBB</h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Naam:
                        </div>
                        <div class="details-value">
                            <?= $row['ADVISEUR_VOORNAAM'] . ' ' . $row['ADVISEUR_ACHTERNAAM'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Telefoon:
                        </div>
                        <div class="details-value">
                            <?= $row['ADVISEUR_TELEFOON_NUMMER'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Email:
                        </div>
                        <div class="details-value">
                            <?= $row['ADVISEUR_EMAIL'] ?>
                        </div>

                    </div>
                </div>
                <?php } ?>

                <?php
                if ($row['TYPE'] !== 'IND') {
                ?>
                <div class="contactperson-details details">
                    <h3> Contactpersoon gegevens vanuit <?= $row['ORGANISATIENAAM'] ?> </h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Naam:
                        </div>
                        <div class="details-value">
                            <?= $row['CONTACTPERSOON_VOORNAAM'] . ' ' . $row['CONTACTPERSOON_ACHTERNAAM'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Telefoonnummer:
                        </div>
                        <div class="details-value">
                            <?= $row['CONTACTPERSON_TELEFOONNUMMER'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Email:
                        </div>
                        <div class="details-value">
                            <?= $row['CONTACTPERSOON_EMAIL'] ?>
                        </div>

                    </div>
                </div>
                <?php } ?>

            </div>


        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.php'; ?>


