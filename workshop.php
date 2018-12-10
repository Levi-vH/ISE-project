<?php
include 'header.php';
include 'functions.php';

$id = $_GET['id'];
$workshoptype = getWorkshopType($id);


$conn = connectToDB();

//Run the stored procedure
// $sql = "SELECT * FROM VW_WORKSHOPS";
$sql = "exec proc_getWorkshops @where = ?";
$stmt = $conn->prepare($sql);
$stmt->bindParam(1, $id, PDO::PARAM_INT);
$stmt->execute();

$row = $stmt->fetch(PDO::FETCH_ASSOC);

foreach ($row as $key => $value){
    if($value == ''){
        $row[$key] = 'Nog niet bekend';
    }
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>workshop</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
    <link rel="stylesheet" href="css/custom.css">
    <link rel="stylesheet" href="css/details.css">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-sm-4 sidebar1">
            <div class="left-navigation">
                <ul class="list">
                    <h5><strong>Workshop Opties</strong></h5>
                    <li>
                        <a href="participants.php?id=<?php echo $id?>">Inzien deelnemers</a>
                    </li>
                    <?php
                        if($workshoptype != 'INC') {
                            echo '<li>';
                            echo  '<a href="open_registrations.php?id='.$id.'">Openstaande inschrijvingen</a>';
                            echo '</li>';
                            echo '<li>';
                            echo  '<a href="reservelist.php?id='.$id.'">Reservelijst</a>';
                            echo '</li>';
                        }
                        ?>
                    <li>
                        <a href="editworkshop.php?id=<?php echo $id?>">Wijzig workshop</a>
                    </li>
                    <?php
                    if($workshoptype == 'INC') {
                        echo '<li>';
                        echo  '<a href="addparticipant.php?id='.$id.'">Voeg deelnemers toe</a>';
                        echo '</li>';
                    }
                    ?>
                </ul>
                <br>
            </div>
        </div>
        <div class="col-md-10 col-sm-8 main-content">
            <!--Main content code to be written here -->
            <h1>WORKSHOP DETAILS</h1>
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
                                <?= substr($row['STARTTIJD'],0,5) ?>
                            </div>

                        </div>
                        <div class="detail-row">
                            <div class="details-column">
                                Eindtijd:
                            </div>
                            <div class="details-value">
                                <?= substr($row['EINDTIJD'],0,5) ?>
                            </div>

                        </div>
                        <div class="detail-row">
                            <div class="details-column">
                                Adres:
                            </div>
                            <div class="details-value">
                                <?= $row['ADRES'] . ' ' . $row['PLAATSNAAM']  ?>
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
                        <div class="detail-row">
                            <div class="details-column">
                                Deelnemer gegevens ontvangen:
                            </div>
                            <div class="details-value">
                                <?= $row['DEELNEMER_GEGEVENS_ONTVANGEN'] ?>
                            </div>

                        </div>
                        <div class="detail-row">
                            <div class="details-column">
                                OVK_Bevestiging:
                            </div>
                            <div class="details-value">
                                <?= $row['OVK_BEVESTIGING'] ?>
                            </div>

                        </div>
                        <div class="detail-row">
                            <div class="details-column">
                                Presentielijst verstuurd:
                            </div>
                            <div class="details-value">
                                <?= $row['PRESENTIELIJST_VERSTUURD'] ?>
                            </div>

                        </div>
                        <div class="detail-row">
                            <div class="details-column">
                                Presentielijst ontvangen:
                            </div>
                            <div class="details-value">
                                <?= $row['PRESENTIELIJST_ONTVANGEN'] ?>
                            </div>

                        </div>
                    </div>

                    <div class="adviseur-details details">
                        <h3> Adviseur vanuit SBB</h3>
                        <div class="detail-row">
                            <div class="details-column">
                                Naam:
                            </div>
                            <div class="details-value">
                                <?= $row['ADVISEUR_VOORNAAM'] .' '. $row['ADVISEUR_ACHTERNAAM']  ?>
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

                    <div class="contactperson-details details">
                        <h3> Contactpersoon gegevens vanuit <?= $row['ORGANISATIENAAM'] ?> </h3>
                        <div class="detail-row">
                            <div class="details-column">
                                Naam:
                            </div>
                            <div class="details-value">
                                <?= $row['CONTACTPERSOON_VOORNAAM'] .' ' . $row['CONTACTPERSOON_ACHTERNAAM'] ?>
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

                </div>



        </div>
    </div>
</body>
</html>
<?php include 'footer.html'; ?>


