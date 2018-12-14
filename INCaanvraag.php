<?php

include 'functions.php';

$aanvraag_id = $_GET['aanvraag_id'];

generate_header('Incompany aanvraag');

$conn = connectToDB();

//Run the stored procedure
$sql = "exec SP_get_workshoprequests ?";
$stmt = $conn->prepare($sql);
$stmt->bindParam(1, $aanvraag_id, PDO::PARAM_INT);
$stmt->execute();

$row = $stmt->fetch(PDO::FETCH_ASSOC);

foreach ($row as $key => $value){
    if($value == ''){
        $row[$key] = 'Nog niet bekend';
    }
}

if($_SERVER["REQUEST_METHOD"] == "POST"){
    $GroupIDs[] = '';
    //Run the stored procedure
//    $sql2 = "exec SP_get_group_ids ?";
//    $stmt2 = $conn->prepare($sql2);
//    $stmt2->bindParam(1, $aanvraag_id, PDO::PARAM_INT);
//    $stmt2->execute();
//
//    $groups = $stmt2->fetchall(PDO::FETCH_ASSOC);
//    $i = 1;
//    foreach ($groups as $group => $value){
//        $GroupIDs[$i] = $groups[$group];
//        $i++;
//    }
//    for($Groupsnumber=1; $Groupsnumber<=$row['AANTAL_GROEPEN']; $Groupsnumber++) {
//
//            $sql3 = "exec SP_get_information_of_group ?";
//            $stmt3 = $conn->prepare($sql3);
//            $stmt3->bindParam(1, $GroupIDs[$Groupsnumber]['GROEP_ID'], PDO::PARAM_INT);
//            $stmt3->execute();
//
//            $groupinfo = $stmt3->fetch(PDO::FETCH_ASSOC);
//
//            foreach ($groupinfo as $key => $value){
//                if($value == ''){
//                    $groupinfo[$key] = 'Nog niet bekend';
//                }
//            }
//
//
//
//            for($Modulenumber=1; $Modulenumber<=$groupinfo['AANTAL_MODULES']; $Modulenumber++) {
//                $Groep_Module_Date          = $_POST['group_' . $Groupsnumber . '_module_' . $Modulenumber . '_Date'];
//                $Groep_Module_Starttime     = $_POST['group_' . $Groupsnumber . '_module_' . $Modulenumber . '_Starttime'];
//                $Groep_Module_Endtime       = $_POST['group_' . $Groupsnumber . '_module_' . $Modulenumber . '_Endtime'];
//
//                $sql6 = "exec SP_add_date_and_time_to_request_from_group ?, ?, ?, ?, ?";
//                $stmt6 = $conn->prepare($sql6);
//                $stmt6->bindParam(1, $Groupsnumber, PDO::PARAM_INT);
//                $stmt6->bindParam(2, $Modulenumber, PDO::PARAM_INT);
//                $stmt6->bindParam(3, $Groep_Module_Date, PDO::PARAM_INT);
//                $stmt6->bindParam(4, $Groep_Module_Starttime, PDO::PARAM_STR);
//                $stmt6->bindParam(5, $Groep_Module_Endtime, PDO::PARAM_STR);
//                $stmt6->execute();
//
//            }
//    }

    $groepNumber = 0;

    pre_r($_POST);

    foreach ($_POST['edit'] as $groep){
        $groepNumber++;
        $moduleNumber = 0;
        foreach($groep as $module){
            $moduleNumber++;

            $sql6 = "exec SP_add_date_and_time_to_request_from_group ?, ?, ?, ?, ?";
            $stmt6 = $conn->prepare($sql6);
            $stmt6->bindParam(1, $groepNumber, PDO::PARAM_INT);
            $stmt6->bindParam(2, $moduleNumber, PDO::PARAM_INT);
            $stmt6->bindParam(3, $module['Date'], PDO::PARAM_STR);
            $stmt6->bindParam(4, $module['starttime'], PDO::PARAM_STR);
            $stmt6->bindParam(5, $module['endtime'], PDO::PARAM_STR);
            $stmt6->execute();

        }
    }


}

$groupnumber = getFirstGroup($aanvraag_id);

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
                        <a href="participants.php?aanvraag_id=<?php echo $aanvraag_id?>&groeps_id=<?= $groupnumber ?>">Deelnemers en Groepen</a>
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
            <form method="post">
            <div class="accordion" id="accordionGroups">

                <?php
                $GroupIDs[] = '';
                //Run the stored procedure
                $sql2 = "exec SP_get_group_ids ?";
                $stmt2 = $conn->prepare($sql2);
                $stmt2->bindParam(1, $aanvraag_id, PDO::PARAM_INT);
                $stmt2->execute();

                $groups = $stmt2->fetchall(PDO::FETCH_ASSOC);
                $i = 1;
                foreach ($groups as $group => $value){
                    $GroupIDs[$i] = $groups[$group];
                    $i++;
                }




                $group_info = '';
                for($i = 1; $i<=$row['AANTAL_GROEPEN']; $i++){
                    $sql3 = "exec SP_get_information_of_group ?";
                    $stmt3 = $conn->prepare($sql3);
                    $stmt3->bindParam(1, $GroupIDs[$i]['GROEP_ID'], PDO::PARAM_INT);
                    $stmt3->execute();

                    $groupinfo = $stmt3->fetch(PDO::FETCH_ASSOC);

                    foreach ($groupinfo as $key => $value){
                        if($value == ''){
                            $groupinfo[$key] = 'Nog niet bekend';
                        }
                    }

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
                                                          ' . $groupinfo['ADRES'] . '
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
                                                                 ' . $groupinfo['VOORNAAM'] . ' ' . $groupinfo['ACHTERNAAM'] . '
                                                            </div>
                                                         </div>
                                                         <div class="detail-row">
                                                            <div class="details-column">
                                                                Telefoon:
                                                            </div>
                                                            <div class="details-value">
                                                             ' . $groupinfo['TELEFOONNUMMER'] . '
                                                            </div>
                                                         </div>
                                                         <div class="detail-row">
                                                            <div class="details-column">
                                                                Email: 
                                                            </div>
                                                            <div class="details-value">
                                                              ' . $groupinfo['EMAIL'] . '
                                                            </div>
                                                         </div>
                                                </div>
                                            </div>
                                                        
                                                        <div class="accordion" id="accordionModules">';

                    $ModuleIDs[] = '';
                    $sql4 = "exec SP_get_modulenumbers ?";
                    $stmt4 = $conn->prepare($sql4);
                    $stmt4->bindParam(1, $GroupIDs[$i]['GROEP_ID'], PDO::PARAM_INT);
                    $stmt4->execute();

                    $Modules = $stmt4->fetchall(PDO::FETCH_ASSOC);
                    $k = 1;
                    foreach ($Modules as $module => $value){
                        $ModuleIDs[$k] = $Modules[$module];
                        $k++;
                    }

                    for($j=1; $j<=$groupinfo['AANTAL_MODULES']; $j++){

                        $sql5 = "exec SP_get_module_information_of_group ?, ?";
                        $stmt5 = $conn->prepare($sql5);
                        $stmt5->bindParam(1, $GroupIDs[$i]['GROEP_ID'], PDO::PARAM_INT);
                        $stmt5->bindParam(2, $ModuleIDs[$j]['MODULENUMMER'], PDO::PARAM_INT);
                        $stmt5->execute();

                        $moduleinfo = $stmt5->fetch(PDO::FETCH_ASSOC);

                        foreach ($moduleinfo as $key => $value){
                            if($value == ''){
                                $moduleinfo[$key] = 'Nog niet bekend';
                            }
                        }

                        $group_info .= '<div class="card-header" id="heading_Module' . $j . '">
                                            <h5 class="mb-0">
                                                <button class="btn btn-link collapsed" type="button" data-toggle="collapse" data-target="#collapse_Module' . $j . '" aria-expanded="false" aria-controls="collapse_Module' . $j . '">
                                                    Module ' . $ModuleIDs[$j]['MODULENUMMER'] . ': '  .  $ModuleIDs[$j]['MODULENAAM'] . '
                                                </button>
                                            </h5>
                                        </div>

                                        <div id="collapse_Module' . $j . '" class="collapse" aria-labelledby="heading_Module' . $j . '" data-parent="#accordionModules">
                                            <div class="card-body">
                                                
                                                    <div class="form-group">
                                                        <label for="group_'. $i .'_module_'. $j .'_preference">Opgegeven Voorkeur:</label>
                                                        <input type="text" class="form-control" id="group_'. $i .'_module_'. $j .'_preference" name="edit[group'. $i .'][module'. $j .'][preference]" placeholder="' . $moduleinfo['VOORKEUR'] . '" disabled>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="group_'. $i .'_module_'. $j .'_Date">Datum:</label>
                                                        <input type="date" class="form-control" id="group_'. $i .'_module_'. $j .'_Date" name="edit[groep'. $i .'][module'. $j .'][Date]" placeholder="' . $moduleinfo['DATUM'] . '"';
                                                     if($_SESSION['username'] == 'contactpersoon'){ $group_info .= 'disabled';}
                                    $group_info .=  '></div>
                                                         <div class="form-group">
                                                             <label for="group_'. $i .'_module_'. $j .'_Starttime">Starttijd:</label>
                                                             <input type="time" class="form-control" id="group_'. $i .'_module_'. $j .'_Starttime" name="edit[groep'. $i .'][module'. $j .'][Starttime]" placeholder="' . $moduleinfo['STARTTIJD'] . '"';
                                                     if($_SESSION['username'] == 'contactpersoon'){ $group_info .= 'disabled';}
                                    $group_info .=       '></div>
                                                          <div class="form-group">
                                                             <label for="group_'. $i .'_module_'. $j .'_Endtime">Eindtijd:</label>
                                                             <input type="time" class="form-control" id="group_'. $i .'_module_'. $j .'_Endtime" name="edit[groep'. $i .'][module'. $j .'][Endtime]" placeholder="' . $moduleinfo['EINDTIJD'] . '"';
                                                      if($_SESSION['username'] == 'contactpersoon'){ $group_info .= 'disabled';}
                                    $group_info .=       '></div>';
                                                    if($_SESSION['username'] == 'planner'){ $group_info .= '<button type="submit" class="btn btn-primary">Submit</button>';}
                                 $group_info .='
                                            </div>
                                        </div>';
                    }
                    $group_info .=                      '</div>
                                                </div>
                                    </div>
                          </div>';
                }
                $group_info .= '</form>';

                echo $group_info;
                ?>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.html'; ?>




