<?php
include 'header.html';
include 'functions.php';

// define (empty) variables
$workshoptype = $workshopdate = $contactinfo = $workshopmodule = $workshopcompany = $workshopsector = $starttime = $endtime =
$workshopadress = $workshoppostcode = $workshopcity = $workshopleader = $workshopnotes = '';

// The ones that do not get checked are dropdown or select.
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $workshoptype = $_POST["workshoptype"];
    $workshopdate = $_POST["workshopdate"];
    //$contactinfo = check_input($_POST["contactinfo"]);
    $workshopmodule = $_POST["workshopmodule"];
    $workshopcompany = $_POST["workshopcompany"];
    $workshopsector = $_POST["workshopsector"];
    $starttime = $_POST["workshopstarttime"];
    $endtime = $_POST["workshopendtime"];
    $workshopadress = check_input($_POST["workshopaddress"]);
    $workshoppostcode = check_input($_POST["workshoppostcode"]);
    $workshopcity = check_input($_POST["workshopcity"]);
    $workshopleader = check_input($_POST["workshopleader"]);
    $workshopnotes = check_input(@$_POST['workshopnotes']);

    //Try to make connection
    $conn = connectToDB();

    //Run the stored procedure
    $sql = "exec proc_create_workshop ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $workshoptype, PDO::PARAM_STR);
    $stmt->bindParam(2, $workshopdate, PDO::PARAM_STR);
    //$stmt->bindParam(3, $contactinfo, PDO::PARAM_STR);
    $stmt->bindParam(3, $workshopmodule, PDO::PARAM_INT);
    $stmt->bindParam(4, $workshopcompany, PDO::PARAM_INT);
    $stmt->bindParam(5, $workshopsector, PDO::PARAM_STR);
    $stmt->bindParam(6, $starttime, PDO::PARAM_STR);
    $stmt->bindParam(7, $endtime, PDO::PARAM_STR);
    $stmt->bindParam(8, $workshopadress, PDO::PARAM_STR);
    $stmt->bindParam(9, $workshoppostcode, PDO::PARAM_STR);
    $stmt->bindParam(10, $workshopcity, PDO::PARAM_STR);
    $stmt->bindParam(11, $workshopleader, PDO::PARAM_STR);
    $stmt->bindParam(12, $workshopnotes, PDO::PARAM_STR);
    $stmt->execute();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
</head>
<body>
<div class="container">

    <h2 class="text-info text-center" >Aanvraag INC workshop</h2>
    <br>

    <h3>Organisatie</h3>
    <form class="form-horizontal" action="">
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Name">Naam Organisatie:</label>
            <div class="col-sm-10">
                <?php
                echo selectBox("Organisation_Name", "Organisatie" ,array("Organisatienaam"), "Organisatienaam", array("Organisatienaam"), "Organisatienaam", "get_organisatie()");
                ?>
        </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Relationnumber">Relatie nummer:</label>
            <div class="col-sm-10">
                <input id=Organisation_Relationnumber" type="text" class="form-control" placeholder="Relatie nummer" name="Organisation_Relationnumber">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Address">Adres:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Adres organisatie" name="Organisation_Address">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Postcode">Postcode:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Postcode organisatie" name="Organisation_Postcode">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Town">Plaats:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Plaats organisatie" name="Organisation_Town">
            </div>
        </div>
        <br>

        <h3>Contactpersoon Organisatie</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Contact_Name">Contactpersoon:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Naam contactpersoon" name="Contact_Name">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Contact_Telephonenumber">Telefoonnummer:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Telefoonnummer contactpersoon" name="Contact_Telephonenumber">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Contact_Email">Email:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Email contactpersoon" name="Contact_Email">
            </div>
        </div>
        <br>

        <h3>Coördinatie SBB</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Coordination_Contact">Contactpersoon:</label>
            <div class="col-sm-10">
                <select class="form-control" name="Coordination_Contact">
                    <option>Selecteer Contactpersoon Coördinatie...</option>
                    <option>D. Krom</option>
                    <option>R. Ates</option>
                    <option>G.Gültekin</option>
                    <option>K. deBruijn</option>
                </select>
            </div>
        </div>
        <br>

        <h3>Adviseur SBB</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_practical_learning">Adviseur praktijkleren:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Adviseur praktijkleren" name="Advisor_practical_learning">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_Email">Email:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Email adviseur" name="Advisor_Email">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_Telephonenumber">Telefoonnummer:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Telefoonnummer adviseur" name="Advisor_Telephonenumber">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_Sector">Sector:</label>
            <div class="col-sm-10">
                <?php
                echo selectBox("workshopsector", "sector",array("sectornaam"), "sectornaam", array("sectornaam"), "sectornaam");
                ?>
            </div>
        </div>
        <br>

        <h3>Groepen</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Groups">Aantal groepen:</label>
            <div class="col-sm-10">
                <input type="number" class="form-control" name="Groups">
            </div>
        </div>

        <div class="form-group">
            <div class="col-sm-offset-5 col-sm-10">
                <button type="submit" class="btn btn-success btn-lg">Vraag Incompany Workshop Aan</button>
            </div>
        </div>
    </form>
</div>

</body>
<?php include 'footer.html'; ?>
</html>

<script>

    function get_organisatie() {
        var organisatienaam = document.getElementById("Organisation_Name");
        var organisatieValue = organisatienaam.options[organisatienaam.selectedIndex].value;
        console.log(organisatieValue);



        document.getElementById("Organisation_Relationnumber").value('hoi');

    }


</script>
