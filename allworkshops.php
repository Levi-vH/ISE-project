<?php
include 'functions.php';

generate_header('Workshop overzicht');

$search_string = null;
?>

<div class="container">
    <h2 class="text-info text-center">Overzicht workshops</h2>
    <form class="form-horizontal" action="" method="post">
        <h4>Filteren workshop:</h4>
        <div class="form-row">
            <div class="form-group col-md-3">
                <label for="inputCity">Workshoptype</label>
                <?php
                echo selectBox("Workshop_type", "WORKSHOPTYPE", array("TypeName", "TYPE"), "TYPE", array("TypeName"), "TypeName");
                ?>
            </div>
            <div class="form-group col-md-3">
                <label for="inputState">Module</label>
                <?php
                echo selectBox("Module_type", "MODULE", array("MODULENAAM"), "MODULENAAM", array("MODULENAAM"), "MODULENAAM");
                ?>
            </div>
            <div class="form-group col-md-3">
                <label for="inputZip">Workshopleider</label>
                <?php
                echo selectBox("WORKSHOPLEIDER_ID", "WORKSHOPLEIDER", array("WORKSHOPLEIDER_ID", "VOORNAAM", "ACHTERNAAM", "TOEVOEGING"), "WORKSHOPLEIDER_ID", array("VOORNAAM", "ACHTERNAAM", "TOEVOEGING"), "VOORNAAM");
                ?>
            </div>
            <div class="form-group col-md-3">
                <label for="inputZip">Organisatie</label>
                <?php
                echo selectBox("Organisation_Name", "Organisatie", array("Organisatienaam"), "Organisatienaam", array("Organisatienaam"), "Organisatienaam");
                ?>
            </div>
            <div class="form-group col-md-3">
                <label for="inputZip">Workshop Status</label>
                <?php
                echo selectBox("Workshop_status", "WORKSHOP", array("DISTINCT STATUS"), "STATUS", array("STATUS"), "STATUS");
                ?>
            </div>
        </div>
        <h4>Zoeken op deelnemer:</h4>
        <div class="form-row">
            <div class="form-group col-md-3">
                <label for="inputParticipantFirstName">Deelnemer voornaam</label>
                <input type="text" name="inputParticipantFirstName" class="form-control" id="inputParticipantFirstName">
            </div>
            <div class="form-group col-md-3">
                <label for="inputParticipantLastName">Deelnemer achternaam</label>
                <input type="text" name="inputParticipantLastName" class="form-control" id="inputParticipantLastName">
            </div>

        </div>

        <div class="form-group">
            <div class="col-sm-offset-5 col-sm-10">
                <button type="submit" class="btn btn-success btn-lg">Zoeken</button>
                <button name="download" type="submit" class="btn btn-secondary btn-lg">Download Excel</button>
                <button class="btn btn-danger btn-lg" onclick="resetSearch()">Reset</button>

            </div>
        </div>
    </form>

    <div>
        <table class='table table-striped table-hover'>
            <tr>
                <th>Workshoptype</th>
                <th>Module</th>
                <th>Datum</th>
                <th>Workshopleider</th>
                <th>Organisatie</th>

            </tr>
            <?php
            //Try to make connection
            $conn = connectToDB();
            $user_searched = false;
            //Run the stored procedure
            // $sql = "SELECT * FROM VW_WORKSHOPS";

            if ($_SERVER["REQUEST_METHOD"] == "POST") {
                $search_string = null;
                $search_workshop = "'%%'";
                $search_module = "'%%'";
                $search_leader = "'%%'";
                $search_company_name = "'%%'";
                $search_status = "'%%'";
                $firstname = "'%%'";
                $lastname = "'%%'";

                if (isset($_POST["Workshop_type"])) {
                    //   $search_string.= 'workshoptype komt binnen';
                    $search_workshop = "'%" . check_input($_POST["Workshop_type"]) . "%'";
                }
                if (isset($_POST["Module_type"])) {
                    //    $search_string.= 'moduletype komt binnen';
                    $search_module = "'%" . check_input($_POST["Module_type"]) . "%'";
                }
                if (isset($_POST["WORKSHOPLEIDER_ID"])) {
                    //   $search_string.= 'workshopleider komt binnen';
                    $search_leader = check_input($_POST["WORKSHOPLEIDER_ID"]);
                }
                if (isset($_POST["Organisation_Name"])) {
                    //   $search_string.= 'organisatie naam komt binnen';
                    $search_company_name = "'%" . check_input($_POST["Organisation_Name"]) . "%'";
                }
                if (isset($_POST["inputParticipantFirstName"])) {
                    //   $search_string.= 'voornaam komt binnen';
                    $firstname = "'%" . check_input($_POST["inputParticipantFirstName"]) . "%'";
                }
                if (isset($_POST["inputParticipantLastName"])) {
                    //   $search_string.= 'achternaam komt binnen';
                    $lastname = "'%" . check_input($_POST["inputParticipantLastName"]) . "%'";
                }
                if (isset($_POST["Workshop_status"])) {
                    $workshopStatus = "'%" . check_input($_POST["Workshop_status"]) . "%'";
                }

                // setting the search string to match the values that were selected.

            if ($search_workshop != "'%%'") { ?>
                <script type="text/javascript">
                    var element = document.getElementById("Workshop_type");
                    var value = "<?= $_POST['Workshop_type']?>";
                    element.value = value;
                </script>
            <?php
            }
            if ($search_module != "'%%'") { ?>
                <script type="text/javascript">
                    var element = document.getElementById("Module_type");
                    var value = "<?= $_POST['Module_type']?>";
                    element.value = value;
                </script>
            <?php
            }

            if ($search_company_name != "'%%'") { ?>
                <script type="text/javascript">
                    var element = document.getElementById("Organisation_Name");
                    var value = "<?= $_POST['Organisation_Name']?>";
                    element.value = value;
                </script>
            <?php
            }
            if ($firstname != "'%%'") { ?>
                <script type="text/javascript">
                    var element = document.getElementById("inputParticipantFirstName");
                    var value = "<?= $_POST['inputParticipantFirstName']?>";
                    element.value = value;
                </script>
            <?php
            }

            if ($lastname != "'%%'") { ?>
                <script type="text/javascript">
                    var element = document.getElementById("inputParticipantLastName");
                    var value = "<?= $_POST['inputParticipantLastName']?>";
                    element.value = value;
                </script>
                <?php
            }

                if ($search_leader != "'%%'") {
                    $workshopleader_id = check_input($_POST["WORKSHOPLEIDER_ID"]);
                    if($search_leader == "") {
                        $search_leader = "'%%'";
                        $workshopleader_id = "'%%'";
                    }
                    $get_advisorname = "EXEC SP_get_workshopleader_first_and_lastname @workshopleader_id = $workshopleader_id";
                    $stmt2 = $conn->prepare($get_advisorname);
                    $stmt2->execute();
                    $advisor_results = $stmt2->fetch(PDO::FETCH_ASSOC);
                    if($search_leader !== "") {
                        $search_string .= 'workshopleider = ' . $advisor_results ["VOORNAAM"] . ' ' . $advisor_results["ACHTERNAAM"];
                    }
                }

                $sql = "EXEC SP_get_workshops_filtered @workshop_type = $search_workshop, @modulenaam = $search_module, @workshopleider_ID = $search_leader,
                @company_name = $search_company_name, @firstname = $firstname, @lastname = $lastname, @status = $workshopStatus";

                $user_searched = true;
            }

            if ($user_searched == false) {
                $sql = "EXEC SP_get_workshops";
            }

            $stmt = $conn->prepare($sql);
            $stmt->execute();
            if ($search_string !== NULL) {
                echo '<div class ="container"> <p>' . $search_string . '</p> </div>';
            }

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

                $html = '';
                $link = $row['WORKSHOP_ID'];
                $html .= "<tr onclick=\"window.location='workshop.php?workshop_id=$link'\">";
                $html .= '<td class="align-middle">';
                $html .= $row['TYPE'];
                $html .= '</td>';
                $html .= '<td class="align-middle">';
                $html .= $row['MODULENAAM'];
                $html .= '</td>';
                $html .= '<td class="align-middle">';
                $html .= date('j F Y', strtotime($row['DATUM']));
                $html .= '</td>';
                $html .= '<td class="align-middle">';
                $html .= $row['WORKSHOPLEIDER_VOORNAAM'] . ' ' . $row['WORKSHOPLEIDER_ACHTERNAAM'];
                $html .= '</td>';
                $html .= '<td class="align-middle">';
                $html .= $row['ORGANISATIENAAM'];
                $html .= '</td>';

                $html .= '</tr>';

                echo $html;
            }

            if (isset($_POST['download'])) {
                createExcelWorkshop($sql);
                updatePage('allworkshops.php');
            }

            if (isset($_GET['error'])) {
                echo '<p class="alert-danger warning">Fout! Sluit eerst het oude bestand <br>Elke download wordt in het zelfde bestand geschreven<br>Verander eerst de bestandsnaam voordat je het opnieuw download</p>';
//                $time = time();
//                if($time + 10000 > time()) {
//                    updatePage('allworkshops.php');
//                }
               // updatePage('allworkshops.php');
            }
            ?>
        </table>
    </div>
    <script type="text/javascript">
        function resetSearch() {
            var element1 = document.getElementById("Workshop_type");
            var element2 = document.getElementById("Module_type");
            var element3 = document.getElementById("Organisation_Name");
            var element4 = document.getElementById("inputParticipantFirstName");
            var element5 = document.getElementById("inputParticipantLastName");
            element1.selectedIndex = element2.selectedIndex = element3.selectedIndex = 0;
            element4.value = element5.value = '';
        }

    </script>
</div>
</body>
<?php include 'footer.html'; ?>
</html>

