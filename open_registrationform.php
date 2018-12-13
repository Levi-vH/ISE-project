<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

generate_header('Inschrijven open workshop');


if ($_SESSION['username'] == 'deelnemer') {

$error_message = NULL;


// define (empty) variables
//$Organisation_Relationnumber = $Contact_ID = $SBB_Planner = $Advisor_practical_learning = $Groups = $Aanvraag_ID = $Group_Module1 = $Group_Module2 = $Group_Module3 = $Group_Module1_voorkeur = $Group_Module2_voorkeur = $Group_Module3_voorkeur = $Adress = $Contact_Person = '';


// The ones that do not get checked are dropdown or select.
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $module = check_input($_POST["moduleInput"]);
    $salutation = check_input($_POST["salutationInput"]);
    $voornaam = check_input($_POST["firstnameInput"]);
    $achternaam = check_input($_POST["lastnameInput"]);
    $birthDate = check_input($_POST["birthDateInput"]);
    $email = check_input($_POST["emailInput"]);
    $phonenumber = check_input($_POST["phonenumberInput"]);
    $educationalAttainment = check_input($_POST["educationalAttainmentInput"]);
    $educationalAttainmentStudents = check_input($_POST["educationalAttainmentStudentsInput"]);
    $companyName = check_input($_POST["companyNameInput"]);
    $sector = check_input($_POST["sectorInput"]);
    $companyLocation = check_input($_POST["companyLocationInput"]);
    $Organisation_Relationnumber = check_input($_POST["Organisation_Relationnumber"]);
    $functionInCompany = check_input($_POST["functionInCompanyInput"]);

}
?>

<body>
<div class="container">
    <h2 class="text-info text-center">Inschrijven open workshop</h2>
    <br>
    <?php if ($error_message !== NULL) {
        echo '<div class ="container"> <p>' . $error_message . '</p> </div>';
    } ?>
    <h3>Modules</h3>
    <form class="form-horizontal" action="" method="post">
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Name">Modules</label>
            <div class="col-sm-10">
                <?php
                echo selectBox("ModuleInput", "MODULE", array("MODULENAAM", "MODULENUMMER"), "MODULENUMMER", array("MODULENAAM"), "MODULENUMMER");
                ?>
            </div>
        </div>
        <h3>Persoonlijke gegevens</h3>
        <div class="form-group">
            <label for="$salutationInput">Aanhef</label>
            <label class="radio-inline"><input type="radio" name="$salutationInput" checked>Dhr.</label>
            <label class="radio-inline"><input type="radio" name="$salutationInput">Mvr.</label>
        </div>

        <div class="form-group">
            <label for="firstnameInput">Voornaam</label>
            <input type="text" class="form-control" id="firstnameInput" placeholder="Voornaam">
        </div>
        <div class="form-group">
            <label for="lastnameInput">Achternaam</label>
            <input type="text" class="form-control" id="lastnameInput" placeholder="Achternaam">
        </div>
        <div class="form-group">
            <label for="birthDateInput">Geboortedatum</label>
            <input type="date" class="form-control" id="birthDateInput" placeholder="Geboortedatum">
        </div>
        <div class="form-group">
            <label for="EmailInput">Email</label>
            <input type="text" class="form-control" id="EmailInput" placeholder="Email">
        </div>
        <div class="form-group">
            <label for="phonenumberInput">Telefoonnummer</label>
            <input type="text" class="form-control" id="phonenumberInputInput" placeholder="telefoonnummer">
        </div>
        <div class="form-group">
            <label for="educationalAttainmentInput">Opleidingsniveau</label>
            <input type="text" class="form-control" id="educationalAttainmentInput" placeholder="opleidingsniveau">
        </div>
        <div class="form-group">
            <label for="educationalAttainmentStudentsInput">Niveau begeleide studenten</label>
            <input type="text" class="form-control" id="educationalAttainmentStudentsInput" placeholder="Niveau Begeleide Studenten">
        </div>
        <br>


        <h3>Gegevens bedrijf</h3>
        <form class="form-horizontal" action="" method="post">
            <div class="form-group">
                <label class="control-label col-sm-2" for="Organisation_Name">Naam Organisatie:</label>
                <div class="col-sm-10">
                    <?php
                    echo selectBox("Organisation_Name", "Organisatie", array("Organisatienaam"), "Organisatienaam", array("Organisatienaam"), "Organisatienaam", "get_organisatie()");
                    ?>
                </div>
            </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Relationnumber">Relatie nummer:</label>
            <div class="col-sm-10">
                <input id="Organisation_Relationnumber" type="text" class="form-control" placeholder="Relatie nummer"
                       name="Organisation_Relationnumber" readonly>
            </div>
        </div>
        <div class="form-group">
            <label for="sectorInput">Sector</label>
            <input type="text" class="form-control" id="sectorInput" placeholder="sector">
        </div>
        <div class="form-group">
            <label for="companyLocationInput">Vestigingplaats</label>
            <input type="text" class="form-control" id="companyLocationInput" placeholder="vestigingplaats">
        </div>
        <div class="form-group">
            <label for="functionInCompanyInput">Functieinbedrijf</label>
            <input type="text" class="form-control" id="functionInCompanyInput" placeholder="functieinbedrijf">
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
    echo '<h1> Alleen deelnemers kunnen deze pagina bezoeken</h1>';
}
?>
</html>

<script>

    function removeOptions(selectbox) {
        var i;
        for (i = selectbox.options.length - 1; i >= 1; i--) {
            selectbox.remove(i);
        }
    }
</script>