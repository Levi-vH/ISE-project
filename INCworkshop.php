<?php
include 'header.html';
include 'functions.php';

// define (empty) variables
$Organisation_Relationnumber = $Contact_ID = $SBB_Planner = $Advisor_practical_learning = $Groups = '';

// The ones that do not get checked are dropdown or select.
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $Organisation_Relationnumber = check_input($_POST["Organisation_Relationnumber"]);
    $Contact_ID = check_input($_POST["Contact_Name"]);
    $SBB_Planner = check_input($_POST["Coordination_Contact"]);
    $Advisor_practical_learning = check_input($_POST["Advisor_practical_learning"]);
    $Groups = check_input($_POST["Groups"]);

    //Try to make connection
    $conn = connectToDB();

    //Run the stored procedure
    $sql = "exec proc_insert_aanvraag ?, ?, ?, ?, ?";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1, $Organisation_Relationnumber, PDO::PARAM_INT);
    $stmt->bindParam(2, $Contact_ID, PDO::PARAM_INT);
    $stmt->bindParam(3, $Advisor_practical_learning, PDO::PARAM_INT);
    $stmt->bindParam(4, $SBB_Planner, PDO::PARAM_STR);
    $stmt->bindParam(5, $Groups, PDO::PARAM_INT);
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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
</head>
<body>
<div class="container">

    <h2 class="text-info text-center" >Aanvraag INC workshop</h2>
    <br>

    <h3>Organisatie</h3>
    <form class="form-horizontal" action="" method="post">
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
                <input id="Organisation_Relationnumber" type="text" class="form-control" placeholder="Relatie nummer" name="Organisation_Relationnumber" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Address">Adres:</label>
            <div class="col-sm-10">
                <input id="Organisation_Address" type="text" class="form-control" placeholder="Adres organisatie" name="Organisation_Address" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Postcode">Postcode:</label>
            <div class="col-sm-10">
                <input id="Organisation_Postcode" type="text" class="form-control" placeholder="Postcode organisatie" name="Organisation_Postcode" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Town">Plaats:</label>
            <div class="col-sm-10">
                <input id="Organisation_Town" type="text" class="form-control" placeholder="Plaats organisatie" name="Organisation_Town" readonly>
            </div>
        </div>
        <br>

        <h3>Contactpersoon Organisatie</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Contact_Name">Contactpersoon:</label>
            <div class="col-sm-10">
                <select id= "Contact_Name" class="form-control" name="Contact_Name" onchange="get_contact_details()">
                    <option value="">Selecteer Contactpersoon Coördinatie...</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Contact_Telephonenumber">Telefoonnummer:</label>
            <div class="col-sm-10">
                <input id="Contact_Telephonenumber" type="text" class="form-control" placeholder="Telefoonnummer contactpersoon" name="Contact_Telephonenumber" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Contact_Email">Email:</label>
            <div class="col-sm-10">
                <input id="Contact_Email" type="text" class="form-control" placeholder="Email contactpersoon" name="Contact_Email" readonly>
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
                    <option>G. Gültekin</option>
                    <option>K. deBruijn</option>
                </select>
            </div>
        </div>
        <br>

        <h3>Adviseur SBB</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_practical_learning">Adviseur praktijkleren:</label>
            <div class="col-sm-10">
                <select id= "Advisor_practical_learning" class="form-control" name="Advisor_practical_learning" onchange="get_advisor_details()">
                    <option value="">Selecteer Adviseur praktijkleren...</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_Email">Email:</label>
            <div class="col-sm-10">
                <input id="Advisor_Email" type="text" class="form-control" placeholder="Email adviseur" name="Advisor_Email" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_Telephonenumber">Telefoonnummer:</label>
            <div class="col-sm-10">
                <input id="Advisor_Telephonenumber" type="text" class="form-control" placeholder="Telefoonnummer adviseur" name="Advisor_Telephonenumber" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_Sector">Sector:</label>
            <div class="col-sm-10">
                <input id="Advisor_Sector" type="text" class="form-control" placeholder="Telefoonnummer adviseur" name="Advisor_Sector" readonly>
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
        $.ajax({
            url: "autofill_organisation.php",
            method: "POST",
            data: { organisation : organisatieValue },
            dataType: "json"
        }).done(function( organisation ) {
            removeOptions(document.getElementById('Contact_Name'));
            removeOptions(document.getElementById('Advisor_practical_learning'));
            $("#Organisation_Relationnumber").val(organisation['ORGANISATIENUMMER']);
            $("#Organisation_Address").val(organisation['ADRES']);
            $("#Organisation_Postcode").val(organisation['POSTCODE']);
            $("#Organisation_Town").val(organisation['PLAATSNAAM']);

            get_contactpersons(organisation['ORGANISATIENUMMER']);
            $("#Contact_Telephonenumber").val('');
            $("#Contact_Email").val('');
            $("#Advisor_Telephonenumber").val('');
            $("#Advisor_Email").val('');
            $("#Advisor_Sector").val('');
            get_advisor(organisation['ORGANISATIENUMMER']);
        });
    }

    function get_contactpersons(relationnumber) {
        $.ajax({
            url: "autofill_contact.php",
            method: "POST",
            data: { organisation_number : relationnumber },
            dateType : "json"
        }).done(function ( html ) {
            contactpersons = (JSON.parse(html));
            var sel = document.getElementById('Contact_Name');
            $.each(contactpersons, function (index, value) {
                var opt = document.createElement('option');
                var full_name = value['VOORNAAM'] + ' ' + value['ACHTERNAAM'];
                opt.innerHTML = full_name;
                opt.value = value['CONTACTPERSOON_ID'];
                sel.appendChild(opt);
            });
        });
    }

    function get_contact_details(){
        var contactname = document.getElementById("Contact_Name");
        var contactValue = contactname.options[contactname.selectedIndex].value;

        if (contactValue == ''){
            $("#Contact_Telephonenumber").val('');
            $("#Contact_Email").val('');
            return;
        }

        $.ajax({
            url: "autofill_contact_details.php",
            method: "POST",
            data: { contact_id : contactValue },
            dateType : "json"
        }).done(function ( html ) {
            contact_details = (JSON.parse(html));
            $("#Contact_Telephonenumber").val(contact_details[0]['TELEFOONNUMMER']);
            $("#Contact_Email").val(contact_details[0]['EMAIL']);
        });
    }


    function get_advisor(relationnumber) {
        $.ajax({
            url: "autofill_advisor.php",
            method: "POST",
            data: { organisation_number : relationnumber },
            dateType : "json"
        }).done(function ( html ) {
            contactpersons = (JSON.parse(html));
            var sel = document.getElementById('Advisor_practical_learning');
            $.each(contactpersons, function (index, value) {
                var opt = document.createElement('option');
                var full_name = value['VOORNAAM'] + ' ' + value['ACHTERNAAM'];
                opt.innerHTML = full_name;
                opt.value = value['ADVISEUR_ID'];
                sel.appendChild(opt);
            });
        });
    }

    function get_advisor_details(){
        var advisorname = document.getElementById("Advisor_practical_learning");
        var advisorValue = advisorname.options[advisorname.selectedIndex].value;

        if (advisorValue == ''){
            $("#Advisor_Telephonenumber").val('');
            $("#Advisor_Email").val('');
            $("#Advisor_Sector").val('');
            return;
        }

        $.ajax({
            url: "autofill_advisor_details.php",
            method: "POST",
            data: { advisor_id : advisorValue },
            dateType : "json"
        }).done(function ( html ) {
            advisor_details = (JSON.parse(html));
            $("#Advisor_Telephonenumber").val(advisor_details[0]['TELEFOONNUMMER']);
            $("#Advisor_Email").val(advisor_details[0]['EMAIL']);
            $("#Advisor_Sector").val(advisor_details[0]['SECTORNAAM']);
        });
    }


    function removeOptions(selectbox){
        var i;
        for(i=selectbox.options.length - 1; i>=1; i--){
            selectbox.remove(i);
        }
    }

</script>
