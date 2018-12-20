<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

generate_header('Inschrijven open workshop');


if ($_SESSION['username'] == 'deelnemer') {

$error_message = NULL;

    $conn = connectToDB();

    $sql = "SELECT MODULENAAM, MODULENUMMER FROM MODULE";
    $stmt= $conn->prepare($sql);
    $stmt->execute();

    $row = $stmt->fetchALL(PDO::FETCH_ASSOC);

    $sqlModulesCount = "SELECT COUNT(*) AS aantal_modules FROM MODULE";
    $stmtModulesCount= $conn->prepare($sqlModulesCount);
    $stmtModulesCount->execute();

    $resultsModulesCount = $stmtModulesCount ->fetchALL(PDO::FETCH_ASSOC);
    $modulesCount = $resultsModulesCount[0]['aantal_modules'];

//    echo $modulesCount;
// define (empty) variables
//$Organisation_Relationnumber = $Contact_ID = $SBB_Planner = $Advisor_practical_learning = $Groups = $Aanvraag_ID = $Group_Module1 = $Group_Module2 = $Group_Module3 = $Group_Module1_voorkeur = $Group_Module2_voorkeur = $Group_Module3_voorkeur = $Adress = $Contact_Person = '';


// The ones that do not get checked are dropdown or select.
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $salutation = check_input($_POST["salutationInput"]);
    $firstname = check_input($_POST["firstnameInput"]);
    $lastname = check_input($_POST["lastnameInput"]);
    $birthDate = check_input($_POST["birthDateInput"]);
    $email = check_input($_POST["emailInput"]);
    $phonenumber = check_input($_POST["phonenumberInput"]);
    $educationalAttainment = check_input($_POST["educationalAttainmentInput"]);
    $educationalAttainmentStudents = check_input($_POST["educationalAttainmentStudentsInput"]);
    $companyName = check_input($_POST["Organisation_Name"]);
    $sector = check_input($_POST["sectorInput"]);
    $companyLocation = check_input($_POST["companyLocationInput"]);
    $Organisation_name = check_input($_POST["Organisation_Name"]);
    $functionInCompany = check_input($_POST["functionInCompanyInput"]);

    pre_r($_POST);

    if(isset($salutation) && isset($firstname) && isset($lastname) && isset($birthDate) && isset($email) && isset($phonenumber) && isset($educationalAttainment)
        && isset($educationalAttainmentStudents) && isset($companyName) && isset($sector) && isset($companyLocation) && isset($Organisation_name) && isset($functionInCompany)) {

        foreach($_POST['post'] as $workshop){
            pre_r($workshop);

        if (isset($workshop['Module'])) {

                $sqlInsertDeelnemer = "SP_insert_participant_in_workshop ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
                $stmtInsertDeelnemer = $conn->prepare($sqlInsertDeelnemer);
                $stmtInsertDeelnemer->bindParam(1, $Organisation_name, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(2, $salutation, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(3, $firstname, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(4, $lastname, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(5, $birthDate, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(6, $email, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(7, $phonenumber, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(8, $educationalAttainment, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(9, $educationalAttainmentStudents, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(10, $sector, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(11, $functionInCompany, PDO::PARAM_INT);
                $stmtInsertDeelnemer->bindParam(12, $workshop['module'], PDO::PARAM_INT);

                $stmtInsertDeelnemer->execute();

            sendMail($email, "Ingeschreven voor workshop", "Beste " . $firstname . " " . $lastname .   ", <br><br> U heeft zich succesvol aangemeld voor de onderstaande workshops: <br> ");
            }
        }
    } else {
        $error_message .= "U heeft een veld niet ingevoerd, ieder veld is verplicht.";
    }
    $error_message .= "Uw staat nu aangemeld voor de workshops bekijk uw mail voor meer informatie";
}

?>

<body>
<div class="container">
    <h2 class="text-info text-center">Inschrijven open workshop</h2>
    <br>
    <?php if ($error_message !== NULL) {
        echo '<div class ="container"> <p>' . $error_message . '</p> </div>';
    } ?>
    <form class="form-horizontal" action="" method="post">
        <h3> Modules</h3>


            <?php

            $checkbox_module = '';
            foreach($row as $module){
                 $checkbox_module .=  '<div class="form-group">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="post['.$module["MODULENUMMER"].'][Module]" value="'.$module["MODULENUMMER"].'" id="Module_' . $module["MODULENUMMER"] . '" onchange="checked_module(' . $module["MODULENUMMER"] . ', this)">
                                                <label class="form-check-label" for="Module_' . $module["MODULENUMMER"] . '">' .
                                                    'Module ' . $module["MODULENUMMER"] . ': ' .  $module["MODULENAAM"]
                                            .'  </label>
                                            </div>
                                       </div>
                                       <div id="hidden_when_and_where' . $module["MODULENUMMER"] .'" class="d-none">
                                        <div class="form-group">
                                            <label class="control-label col-sm-2" for="workshop_' . $module["MODULENUMMER"] .'">Waar en wanneer?:</label>
                                            <div class="col-sm-10">';

                $sql2 = "SP_get_where_and_when " . $module["MODULENUMMER"];
                $stmt2= $conn->prepare($sql2);
                $stmt2->execute();

                $checkbox_module .= '<select name ="post['.$module["MODULENUMMER"].'][Workshop]"" >';
                while($resultaat = $stmt2->fetch(PDO::FETCH_ASSOC)){

                    $checkbox_module.= '<option value="'. $resultaat['WORKSHOP_ID'] . '">' . $resultaat['waar_en_wanneer'] . '</option>';

                }

                $checkbox_module .= '</select>';

                $checkbox_module .=        '</div>
                                            </div>
                                        </div>';
            }

            echo $checkbox_module;

            ?>



        <h3>Persoonlijke gegevens</h3>
        <div class="form-group">
            <label for="salutationInput">Aanhef</label>
            <label class="radio-inline"><input type="radio" name="salutationInput" value="Dhr." checked>Dhr.</label>
            <label class="radio-inline"><input type="radio" name="salutationInput" value="Mvr.">Mvr.</label>
        </div>

        <div class="form-group">
            <label for="firstnameInput">Voornaam</label>
            <input name ="firstnameInput" type="text" class="form-control" id="firstnameInput" placeholder="Voornaam" required>
        </div>
        <div class="form-group">
            <label for="lastnameInput">Achternaam</label>
            <input name ="lastnameInput" type="text" class="form-control" id="lastnameInput" placeholder="Achternaam" required>
        </div>
        <div class="form-group">
            <label for="birthDateInput">Geboortedatum</label>
            <input name ="birthDateInput" type="date" class="form-control" id="birthDateInput" placeholder="Geboortedatum" required>
        </div>
        <div class="form-group">
            <label for="emailInput">Email</label>
            <input name ="emailInput" type="text" class="form-control" id="emailInput" placeholder="Email" required>
        </div>
        <div class="form-group">
            <label for="phonenumberInput">Telefoonnummer</label>
            <input name ="phonenumberInput" type="text" class="form-control" id="phonenumberInputInput" placeholder="Telefoonnummer" required>
        </div>
        <div class="form-group">
            <label for="educationalAttainmentInput">Opleidingsniveau</label>
            <input name ="educationalAttainmentInput" type="text" class="form-control" id="educationalAttainmentInput" placeholder="Opleidingsniveau" required>
        </div>
        <div class="form-group">
            <label for="educationalAttainmentStudentsInput">Niveau begeleide studenten</label>
            <input name ="educationalAttainmentStudentsInput" type="text" class="form-control" id="educationalAttainmentStudentsInput" placeholder="Niveau Begeleide Studenten" required>
        </div>
        <br>


        <h3>Gegevens bedrijf</h3>
        <form class="form-horizontal" action="" method="post">
            <div class="form-group">
                <label for="Organisation_Name">Naam Organisatie:</label>
                    <?php
                    echo selectBox("Organisation_Name", "Organisatie", array("Organisatienaam"), "Organisatienaam", array("Organisatienaam"), "Organisatienaam", "get_organisatie()");
                    ?>
            </div>

        <div class="form-group">
            <label for="sectorInput">Sector</label>
            <?php
            echo selectBox("sectorInput", "Sector", array("Sectornaam"), "Sectornaam", array("Sectornaam"), "Sectornaam");
            ?>
        </div>
        <div class="form-group">
            <label for="companyLocationInput">Vestigingplaats</label>
            <input name ="companyLocationInput" type="text" class="form-control" id="companyLocationInput" placeholder="Vestigingplaats" required>
        </div>
        <div class="form-group">
            <label for="functionInCompanyInput">Functie in bedrijf</label>
            <input name ="functionInCompanyInput" type="text" class="form-control" id="functionInCompanyInput" placeholder="Functie in bedrijf" required>
        </div>


        <div class="form-group">
            <div class="col-sm-offset-5 col-sm-10">
                <button type="submit" class="btn btn-success btn-lg">Opgeven</button>
            </div>
        </div>
    </form>
</div>

</body>
<?php
include 'footer.html';
} else {
    notLoggedIn();
}
?>
</html>

<script>

    function checked_module(i, input) {
        if ($(input).is(":checked")) {
            $("#hidden_when_and_where" + i + "").removeClass("d-none");
        } else {
            $("#hidden_when_and_where" + i + "").addClass("d-none");
        }
    }



</script>