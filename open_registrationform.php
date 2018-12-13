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


}
?>

<body>
<div class="container">
    <h2 class="text-info text-center">Inschrijven open workshop</h2>
    <br>
    <?php if ($error_message !== NULL) {
        echo '<div class ="container"> <p>' . $error_message . '</p> </div>';
    } ?>
    <h3>Organisatie</h3>
    <form class="form-horizontal" action="" method="post">
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Name">Modules</label>
            <div class="col-sm-10">
                <?php
                //echo selectBox("Module_Name", "Module", array("modulenaam"), "modulenaam", array("modulenaam"), "modulenaam", "get_organisatie()");
                ?>
            </div>
        </div>
        <h3>Persoonlijke gegevens</h3>
        <div class="form-group">
            <label for="Organisation_Relationnumber">Aanhef</label>
            <label class="radio-inline"><input type="radio" name="Aanhefradio" checked>Dhr.</label>
            <label class="radio-inline"><input type="radio" name="Aanhefradio">Mvr.</label>
        </div>

        <div class="form-group">
            <label for="voornaamInput">Voornaam</label>
            <input type="text" class="form-control" id="voornaamInput" placeholder="Voornaam">
        </div>
        <div class="form-group">
            <label for="achternaamInput">Achternaam</label>
            <input type="text" class="form-control" id="voornaamInput" placeholder="Achternaam">
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Postcode">Postcode:</label>
            <div class="col-sm-10">
                <input id="Organisation_Postcode" type="text" class="form-control" placeholder="Postcode organisatie"
                       name="Organisation_Postcode" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Town">Plaats:</label>
            <div class="col-sm-10">
                <input id="Organisation_Town" type="text" class="form-control" placeholder="Plaats organisatie"
                       name="Organisation_Town" readonly>
            </div>
        </div>
        <br>

        <h3>Contactpersoon Organisatie</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Contact_Name">Contactpersoon:</label>
            <div class="col-sm-10">
                <select id="Contact_Name" class="form-control" name="Contact_Name" onchange="get_contact_details()">
                    <option value="">Selecteer Contactpersoon Coördinatie...</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Contact_Telephonenumber">Telefoonnummer:</label>
            <div class="col-sm-10">
                <input id="Contact_Telephonenumber" type="text" class="form-control"
                       placeholder="Telefoonnummer contactpersoon" name="Contact_Telephonenumber" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Contact_Email">Email:</label>
            <div class="col-sm-10">
                <input id="Contact_Email" type="text" class="form-control" placeholder="Email contactpersoon"
                       name="Contact_Email" readonly>
            </div>
        </div>
        <br>

        <h3>Coördinatie SBB</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Coordination_Contact">Contactpersoon:</label>
            <div class="col-sm-10">
                <?php echo selectBox("Coordination_Contact", "planner", array("plannernaam"), "plannernaam", array("plannernaam"), "plannernaam"); ?>
            </div>
        </div>
        <br>

        <h3>Adviseur SBB</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_practical_learning">Adviseur praktijkleren:</label>
            <div class="col-sm-10">
                <select id="Advisor_practical_learning" class="form-control" name="Advisor_practical_learning"
                        onchange="get_advisor_details()">
                    <option value="">Selecteer Adviseur praktijkleren...</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_Email">Email:</label>
            <div class="col-sm-10">
                <input id="Advisor_Email" type="text" class="form-control" placeholder="Email adviseur"
                       name="Advisor_Email" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_Telephonenumber">Telefoonnummer:</label>
            <div class="col-sm-10">
                <input id="Advisor_Telephonenumber" type="text" class="form-control"
                       placeholder="Telefoonnummer adviseur" name="Advisor_Telephonenumber" readonly>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Advisor_Sector">Sector:</label>
            <div class="col-sm-10">
                <input id="Advisor_Sector" type="text" class="form-control" placeholder="Sector"
                       name="Advisor_Sector" readonly>
            </div>
        </div>
        <br>

        <h3>Workshop informatie</h3>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Groups">Aantal groepen:</label>
            <div class="col-sm-10">
                <input id="Groups" type="number" class="form-control" name="Groups" onchange="accordion(value)" min="0"
                       max="15">
            </div>
        </div>

        <div id="hidden_accordion">

        </div>


        <div class="form-group">
            <div class="col-sm-offset-5 col-sm-10">
                <button type="submit" class="btn btn-success btn-lg">Vraag Incompany Workshop Aan</button>
            </div>
        </div>
    </form>
</div>

</body>
<?php
include 'footer.html';
?>
</html>

<script>

    function get_organisatie() {
        var organisatienaam = document.getElementById("Organisation_Name");
        var organisatieValue = organisatienaam.options[organisatienaam.selectedIndex].value;
        $.ajax({
            url: "ajax/autofill_organisation.php",
            method: "POST",
            data: {organisation: organisatieValue},
            dataType: "json"
        }).done(function (organisation) {
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
            $("#Groups").val('');
            accordion(0);
            get_advisor(organisation['ORGANISATIENUMMER']);
        });
    }

    var contactpersons = null;

    function get_contactpersons(relationnumber) {
        $.ajax({
            url: "ajax/autofill_contact.php",
            method: "POST",
            data: {organisation_number: relationnumber},
            dateType: "json"
        }).done(function (html) {
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

    function get_contact_details() {
        var contactname = document.getElementById("Contact_Name");
        var contactValue = contactname.options[contactname.selectedIndex].value;

        if (contactValue == '') {
            $("#Contact_Telephonenumber").val('');
            $("#Contact_Email").val('');
            return;
        }

        $.ajax({
            url: "ajax/autofill_contact_details.php",
            method: "POST",
            data: {contact_id: contactValue},
            dateType: "json"
        }).done(function (html) {
            contact_details = (JSON.parse(html));
            $("#Contact_Telephonenumber").val(contact_details[0]['TELEFOONNUMMER']);
            $("#Contact_Email").val(contact_details[0]['EMAIL']);
        });
    }


    function get_advisor(relationnumber) {
        $.ajax({
            url: "ajax/autofill_advisor.php",
            method: "POST",
            data: {organisation_number: relationnumber},
            dateType: "json"
        }).done(function (html) {
            advisor = (JSON.parse(html));
            var sel = document.getElementById('Advisor_practical_learning');
            $.each(advisor, function (index, value) {
                var opt = document.createElement('option');
                var full_name = value['VOORNAAM'] + ' ' + value['ACHTERNAAM'];
                opt.innerHTML = full_name;
                opt.value = value['ADVISEUR_ID'];
                sel.appendChild(opt);
            });
        });
    }

    function get_advisor_details() {
        var advisorname = document.getElementById("Advisor_practical_learning");
        var advisorValue = advisorname.options[advisorname.selectedIndex].value;

        if (advisorValue == '') {
            $("#Advisor_Telephonenumber").val('');
            $("#Advisor_Email").val('');
            $("#Advisor_Sector").val('');
            return;
        }

        $.ajax({
            url: "ajax/autofill_advisor_details.php",
            method: "POST",
            data: {advisor_id: advisorValue},
            dateType: "json"
        }).done(function (html) {
            advisor_details = (JSON.parse(html));
            $("#Advisor_Telephonenumber").val(advisor_details[0]['TELEFOONNUMMER']);
            $("#Advisor_Email").val(advisor_details[0]['EMAIL']);
            $("#Advisor_Sector").val(advisor_details[0]['SECTORNAAM']);
        });
    }


    function removeOptions(selectbox) {
        var i;
        for (i = selectbox.options.length - 1; i >= 1; i--) {
            selectbox.remove(i);
        }
    }


    function accordion(amount_of_groups) {
        $html = '<div class="accordion" id="accordionGroups">';

        for (var i = 1; i <= amount_of_groups; i++) {
            $html += ' <div class="card">\n' +
                '        <div class="card-header" id="heading' + i + '">\n' +
                '           <h5 class="mb-0">\n' +
                '               <button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapse' + i + '" aria-expanded="false" aria-controls="collapse' + i + '">\n' +
                '                   Groep ' + i + ' \n' +
                '               </button>\n' +
                '           </h5>\n' +
                '        </div>\n' +
                '\n' +
                '        <div id="collapse' + i + '" class="panel-collapse collapse in" aria-labelledby="heading' + i + '" data-parent="#accordionGroups">\n' +
                '           <div class="card-body">\n' +
                '               <div class="form-group">\n' +
                //MODULES
                '                   <label class="control-label col-sm-2" for="group_' + i + '_module">Modules:</label>\n' +
                '                       <div class="col-sm-10">\n' +
                //MODULE 1
                '<input type="checkbox" name="group_' + i + '_module1" value="1" onchange="checked_module1(' + i + ', this)"> Module 1: Matching en voorbereiding <br>\n' +
                //VOORKEUR MODULE 1
                '                       <div id="hidden_voorkeur_module1_group_' + i + '" class="d-none">\n' +
                '                           <div class="form-group">\n' +
                '                                  <label class="control-label" for="group_' + i + '_module1_Voorkeur">Voorkeur module 1:</label>\n' +
                '                                       <div class="form-check form-check-inline">\n' +
                '                                           <input class="form-check-input" type="radio" name="group_' + i + '_module1_Voorkeur" id="group_' + i + '_module1_ochtend" value="ochtend">\n' +
                '                                           <label class="form-check-label" for="group_' + i + '_module1_ochtend">ochtend</label>\n' +
                '                                       </div>\n' +
                '                                       <div class="form-check form-check-inline">\n' +
                '                                           <input class="form-check-input" type="radio" name="group_' + i + '_module1_Voorkeur" id="group_' + i + '_module1_middag" value="middag">\n' +
                '                                           <label class="form-check-label" for="group_' + i + '_module1_middag">middag</label>\n' +
                '                                       </div>\n' +
                '                           </div>\n' +
                '                       </div>\n' +
                //MODULE 2
                '<input type="checkbox" name="group_' + i + '_module2" value="2" onchange="checked_module2(' + i + ', this)"> Module 2: Begeleiden <br>\n' +
                //VOORKEUR MODULE 2
                '                       <div id="hidden_voorkeur_module2_group_' + i + '" class="d-none">\n' +
                '                           <div class="form-group">\n' +
                '                               <label class="control-label" for="group_' + i + '_module2_Voorkeur">Voorkeur module 2:</label>\n' +
                '                                   <div class="form-check form-check-inline">\n' +
                '                                       <input class="form-check-input" type="radio" name="group_' + i + '_module2_Voorkeur" id="group_' + i + '_module2_ochtend" value="ochtend">\n' +
                '                                       <label class="form-check-label" for="group_' + i + '_module2_ochtend">ochtend</label>\n' +
                '                                   </div>\n' +
                '                                   <div class="form-check form-check-inline">\n' +
                '                                       <input class="form-check-input" type="radio" name="group_' + i + '_module2_Voorkeur" id="group_' + i + '_module2middag" value="middag">\n' +
                '                                       <label class="form-check-label" for="group_' + i + '_module2_middag">middag</label>\n' +
                '                                   </div>\n' +
                '                          </div>\n' +
                '                       </div>\n' +
                //MODULE 3
                '<input type="checkbox" name="group_' + i + '_module3" value="3" onchange="checked_module3(' + i + ', this)"> Module 3: Beoordelen <br>\n' +
                //VOORKEUR MODULE 3
                '                       <div id="hidden_voorkeur_module3_group_' + i + '" class="d-none">\n' +
                '                           <div class="form-group">\n' +
                '                               <label class="control-label" for="group_' + i + '_module3_Voorkeur">Voorkeur module 3:</label>\n' +
                '                                   <div class="form-check form-check-inline">\n' +
                '                                       <input class="form-check-input" type="radio" name="group_' + i + '_module3_Voorkeur" id="group_' + i + '_module3_ochtend" value="ochtend">\n' +
                '                                       <label class="form-check-label" for="group_' + i + '_module3_ochtend">ochtend</label>\n' +
                '                                   </div>\n' +
                '                                   <div class="form-check form-check-inline">\n' +
                '                                       <input class="form-check-input" type="radio" name="group_' + i + '_module3_Voorkeur" id="group_' + i + '_module3_middag" value="middag">\n' +
                '                                       <label class="form-check-label" for="group_' + i + '_module3_middag">middag</label>\n' +
                '                                   </div>\n' +
                '                           </div>\n' +
                '                       </div>\n' +
                '           </div>\n' +
                '        </div>\n' +
                //ADRES
                '           <div class="form-group">\n' +
                '               <label class="control-label" for="group_' + i + 'Workshop_Address">Adres:</label>\n' +
                '                   <div class="col-sm-10">\n' +
                '                       <input id="group_' + i + 'Workshop_Address" type="text" class="form-control" placeholder="Adres Workshop" name="group_' + i + 'Workshop_Address">\n' +
                '                   </div>\n' +
                '           </div>\n' +
                //CONTACTPERSOON
                '   <div class="form-group">\n' +
                '            <label class="control-label col-sm-2" for=group_' + i + 'Aanwezig_Contactpersoon"> Aanwezig Contactpersoon:</label>\n' +
                '            <div class="col-sm-10">\n' +
                '                <select id= "group_' + i + 'Aanwezig_Contactpersoon" class="form-control" name="group_' + i + 'Aanwezig_Contactpersoon">\n' +
                '                    <option value="">Selecteer Contactpersoon Coördinatie...</option>\n' +
                '                </select>\n' +
                '            </div>\n' +
                '        </div>        ' +


                //            //TELEFOONNUMMER
                //            '           <div class="form-group">\n' +
                //            '               <label class="control-label" for="group_' + i + 'Aanwezig_Telephone">Telefoonnummer:</label>\n' +
                //            '                   <div class="col-sm-10">\n' +
                //            '                       <input id="group_' + i + 'Aanwezig_Telephone" type="text" class="form-control" placeholder="Telefoonnummer" name="group_' + i + 'Aanwezig_Telephone">\n'+
                //            '                   </div>\n' +
                //            '           </div>\n' +
                //            //EMAIL
                //            '           <div class="form-group">\n' +
                //            '               <label class="control-label" for="group_' + i + 'Aanwezig_Email">Email:</label>\n' +
                //            '                   <div class="col-sm-10">\n' +
                //            '                       <input id="group_' + i + 'Aanwezig_Email" type="text" class="form-control" placeholder="Email" name="group_' + i + 'Aanwezig_Email">\n' +
                //            '                   </div>\n' +
                //            '           </div>\n' +
                '       </div>\n' +
                '     </div>\n' +
                '</div>';
        }

        $html += '</div><br>';

        $("#hidden_accordion").html($html);

        group_Contactpersons(amount_of_groups);
    }


    function group_Contactpersons(amount_of_groups) {
        for (var i = 1; i <= amount_of_groups; i++) {
            var sel = document.getElementById('group_' + i + 'Aanwezig_Contactpersoon');

            $.each(contactpersons, function (index, value) {
                var opt = document.createElement('option');
                var full_name = value['VOORNAAM'] + ' ' + value['ACHTERNAAM'];
                opt.innerHTML = full_name;
                opt.value = value['CONTACTPERSOON_ID'];
                sel.appendChild(opt);
                console.log(sel);
            });
        }
    }


    function checked_module1(i, input) {
        if ($(input).is(":checked")) {
            $("#hidden_voorkeur_module1_group_" + i + "").removeClass("d-none");
        } else {
            $("#hidden_voorkeur_module1_group_" + i + "").addClass("d-none");
        }
    }


    function checked_module2(i, input) {
        if ($(input).is(":checked")) {
            $("#hidden_voorkeur_module2_group_" + i + "").removeClass("d-none");
        } else {
            $("#hidden_voorkeur_module2_group_" + i + "").addClass("d-none");
        }
    }

    function checked_module3(i, input) {
        if ($(input).is(":checked")) {
            $("#hidden_voorkeur_module3_group_" + i + "").removeClass("d-none");
        } else {
            $("#hidden_voorkeur_module3_group_" + i + "").addClass("d-none");
        }
    }
    <?php } else {
        echo '<h1> Alleen deelnemers kunnen deze pagina bezoeken</h1>';
    } ?>

</script>