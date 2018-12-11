<?php

include 'functions.php';

$aanvraag_id = $_GET['aanvraag_id'];

generate_header('Incompany aanvraag');

$conn = connectToDB();

//Run the stored procedure
// $sql = "SELECT * FROM VW_WORKSHOPS";
$sql = "exec proc_get_workshoprequests @aanvraag_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bindParam(1, $aanvraag_id, PDO::PARAM_INT);
$stmt->execute();

$row = $stmt->fetch(PDO::FETCH_ASSOC);

foreach ($row as $key => $value){
    if($value == ''){
        $row[$key] = 'Nog niet bekend';
    }
}
?>

<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-sm-4 sidebar1">
            <div class="left-navigation">
                <ul class="list">
                    <h5><strong>Aanvraag Opties</strong></h5>
                    <li>
                        <a class="active-page">Details</a>
                    </li>
                    <li>
                        <a href="participants.php?aanvraag_id=<?php echo $aanvraag_id?>">Deelnemers en Groepen</a>
                    </li>
                    <li>
                        <a href="addparticipant.php?aanvraag_id=<?php echo $aanvraag_id?>">Deelnemers toevoegen</a>
                    </li>
                </ul>
                <br>
            </div>
        </div>
        <div class="col-md-10 col-sm-8 main-content">
            <!--Main content code to be written here -->
            <h1 class="text-center">Aanvraag Details</h1>
            <h3>Aanvraag<?php echo $aanvraag_id ?></h3>

            <div class="details-container">
                <div class="workshop-details details">
                    <h3> Algemeen</h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Datum Aanvraag:
                        </div>
                        <div class="details-value">
<!--                            --><?//=  ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Aantal Groepen:
                        </div>
                        <div class="details-value">
<!--                            --><?//=  ?>
                        </div>

                    </div>
                </div>

                <div class="recieved-details details">
                    <h3> Coördinatie vanuit SBB</h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Contactpersoon:
                        </div>
                        <div class="details-value">
<!--                            --><?//= $row['VERWERKT_BREIN'] ?>
                        </div>

                    </div>
                </div>



                <div class="contactperson-details details">
                    <h3> Contactpersoon gegevens vanuit  </h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Naam:
                        </div>
                        <div class="details-value">
<!--                            --><?//= $row['CONTACTPERSOON_VOORNAAM'] .' ' . $row['CONTACTPERSOON_ACHTERNAAM'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Telefoonnummer:
                        </div>
                        <div class="details-value">
<!--                            --><?//= $row['CONTACTPERSON_TELEFOONNUMMER'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Email:
                        </div>
                        <div class="details-value">
<!--                            --><?//= $row['CONTACTPERSOON_EMAIL'] ?>
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
<!--                            --><?//= $row['ADVISEUR_VOORNAAM'] .' '. $row['ADVISEUR_ACHTERNAAM']  ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Telefoon:
                        </div>
                        <div class="details-value">
<!--                            --><?//= $row['ADVISEUR_TELEFOON_NUMMER'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Email:
                        </div>
                        <div class="details-value">
<!--                            --><?//= $row['ADVISEUR_EMAIL'] ?>
                        </div>

                    </div>
                </div>
            </div>




        </div>
    </div>
</body>
</html>
<?php include 'footer.html'; ?>


