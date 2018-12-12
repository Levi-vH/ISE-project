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

            <div class="details-container">
                <div class="Aanvraag-details details">
                    <h3> Algemeen</h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Datum Aanvraag:
                        </div>
                        <div class="details-value">
                            <?= $row['AANVRAAG_DATUM'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Aantal Groepen:
                        </div>
                        <div class="details-value">
                            <?= $row['AANTAL_GROEPEN'] ?>
                        </div>

                    </div>
                </div>

                <div class="Coördination-details details">
                    <h3> Coördinatie vanuit SBB</h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Contactpersoon:
                        </div>
                        <div class="details-value">
                            <?= $row['PLANNERNAAM'] ?>
                        </div>

                    </div>
                </div>



                <div class="contactperson-details details">
                    <h3> Contactpersoon gegevens vanuit:      <BR>  <?= $row['ORGANISATIENAAM'] ?>  </h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Naam:
                        </div>
                        <div class="details-value">
                            <?= $row['CONTACTPERSOONVOORNAAM'] .' ' . $row['CONTACTPERSOONACHTERNAAM'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Telefoonnummer:
                        </div>
                        <div class="details-value">
                            <?= $row['CONTACTPERSOONTELEFOONNUMMER'] ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Email:
                        </div>
                        <div class="details-value">
                            <?= $row['CONTACTPERSOONEMAIL'] ?>
                        </div>

                    </div>
                </div>

                <div class="advisor-details details">
                    <h3> Adviseur vanuit SBB</h3>
                    <div class="detail-row">
                        <div class="details-column">
                            Naam:
                        </div>
                        <div class="details-value">
                            <?= $row['ADVISEURVOORNAAM'] .' '. $row['ADVISEURACHTERNAAM']  ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Telefoon:
                        </div>
                        <div class="details-value">
                            <?= $row['ADVISEURTELEFOONNUMMER']  ?>
                        </div>

                    </div>
                    <div class="detail-row">
                        <div class="details-column">
                            Email:
                        </div>
                        <div class="details-value">
                            <?= $row['ADVISEUREMAIL']  ?>
                        </div>

                    </div>
                </div>
            </div>

            <h2 class="text-center">Groepen</h2>
            <div class="accordion" id="accordionGroups">
                <?php
                $aantalModules = 3;
                $group_info = '';
                for($i = 1; $i<=$row['AANTAL_GROEPEN']; $i++){
                    $group_info .= '<div class="card">
                                    <div class="card-header" id="heading' . $i . '">
                                        <h5 class="mb-0">
                                            <button class="btn btn-link collapsed" type="button" data-toggle="collapse" data-target="#collapse' . $i . '" aria-expanded="false" aria-controls="collapse' . $i . '">
                                                Groep ' . $i . ' 
                                            </button>
                                        </h5>
                                    </div>

                                    <div id="collapse' . $i . '" class="collapse" aria-labelledby="heading' . $i . '" data-parent="#accordionGroups">
                                        <div class="card-body">
                                                        <div class="details-container">
                                                            <div class="Groep-details details">
                                                                <h3> Algemeen</h3>
                                                                    <div class="detail-row">
                                                                        <div class="details-column">
                                                                            Adres:
                                                                        </div>
                                                                        <div class="details-value">
                                                                        
                                                                        </div>
                                                                     </div>
                                                            </div>
                                                            <div class="GroepContact-details details">
                                                                <h3> Aanwezig contactpersoon:</h3>
                                                                    <div class="detail-row">
                                                                        <div class="details-column">
                                                                            Naam:
                                                                        </div>
                                                                        <div class="details-value">
                                                                        
                                                                        </div>
                                                                     </div>
                                                                     <div class="detail-row">
                                                                        <div class="details-column">
                                                                            Telefoon:
                                                                        </div>
                                                                        <div class="details-value">
                                                                        
                                                                        </div>
                                                                     </div>
                                                                     <div class="detail-row">
                                                                        <div class="details-column">
                                                                            Email:
                                                                        </div>
                                                                        <div class="details-value">
                                                                        
                                                                        </div>
                                                                     </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="accordion" id="accordionModules">';
                    for($j=1; $j<=$aantalModules; $j++){
                        $group_info .= '<div class="card-header" id="heading_Module' . $j . '">
                                                                                <h5 class="mb-0">
                                                                                    <button class="btn btn-link collapsed" type="button" data-toggle="collapse" data-target="#collapse_Module' . $j . '" aria-expanded="false" aria-controls="collapse_Module' . $j . '">
                                                                                        Module ' . $j . '
                                                                                    </button>
                                                                                </h5>
                                                                            </div>

                                                                            <div id="collapse_Module' . $j . '" class="collapse" aria-labelledby="heading_Module' . $j . '" data-parent="#accordionModules">
                                                                                <div class="card-body">
                                                                                                <form>
                                                                                                    <div class="form-group">
                                                                                                        <label for="preference">Opgegeven Voorkeur:</label>
                                                                                                        <input type="text" class="form-control" id="preference" value="Ochtend" disabled>
                                                                                                    </div>
                                                                                                    <div class="form-group">
                                                                                                        <label for="Date">Opgegeven Voorkeur:</label>
                                                                                                        <input type="text" class="form-control" id="Date" value="01-01-2018" disabled>
                                                                                                    </div>
                                                                                                    <div class="form-group">
                                                                                                        <label for="Starttime">Starttijd:</label>
                                                                                                        <input type="text" class="form-control" id="Starttime" value="12:00" disabled>
                                                                                                    </div>
                                                                                                    <div class="form-group">
                                                                                                        <label for="Endtime">Eindtijd:</label>
                                                                                                        <input type="text" class="form-control" id="Endtime" value="15:00" disabled>
                                                                                                    </div>
                                                                                                </form>
                                                                                </div>
                                                                            </div>';
                    }
                    $group_info .=                      '</div>
                                                </div>
                                    </div>
                          </div>';
                }

                echo $group_info;
                ?>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.html'; ?>




