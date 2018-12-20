<?php
include 'functions.php';

generate_header('Workshop overzicht');
?>

<div class="container">
    <h2 class="text-info text-center" >Overzicht workshops</h2>
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
        </div>
        <h4>Zoeken op deelnemer:</h4>
        <div class="form-row">
            <div class="form-group col-md-3">
                <label for="inputParticipantFirstName">Deelnemer voornaam</label>
                <input type="text" name ="inputParticipantFirstName" class="form-control" id="inputParticipantFirstName">
            </div>
            <div class="form-group col-md-3">
                <label for="inputParticipantLastName">Deelnemer achternaam</label>
                <input type="text" name ="inputParticipantLastName" class="form-control" id="inputParticipantLastName">
            </div>

        </div>

        <div class="form-group">
            <div class="col-sm-offset-5 col-sm-10">
                <button type="submit" class="btn btn-success btn-lg">Zoeken</button>
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
                $search_workshop = "'%%'";
                $search_module = "'%%'";
                $search_leader = "'%%'";
                $search_company_name = "'%%'";
                $firstname = "'%%'";
                $lastname = "'%%'";

                if (isset($_POST["Workshop_type"])) {
                    $search_workshop ="'%". check_input($_POST["Workshop_type"]) . "%'";
                }
                if (isset($_POST["Module_type"])) {
                    $search_module ="'%". check_input($_POST["Module_type"]) . "%'";
                }
                if (isset($_POST["WORKSHOPLEIDER_ID"])) {
                    $search_leader ="'%". check_input($_POST["WORKSHOPLEIDER_ID"]) . "%'";
                }
                if (isset($_POST["Organisation_Name"])) {
                    $search_company_name ="'%". check_input($_POST["Organisation_Name"]) . "%'";
                }
                if (isset($_POST["inputParticipantFirstName"])) {
                    $firstname ="'%". check_input($_POST["inputParticipantFirstName"]) . "%'";
                }
                if (isset($_POST["inputParticipantLastName"])) {
                    $lastname ="'%". check_input($_POST["inputParticipantLastName"]) . "%'";
                }

                $sql = "EXEC SP_get_workshops_filtered @workshop_type = $search_workshop, @modulenaam = $search_module, @workshopleider_ID = $search_leader,
                @company_name = $search_company_name, @firstname = $firstname, @lastname = $lastname";

                $user_searched = true;
            }

            if ($user_searched == false) {
                $sql = "EXEC SP_get_workshops";
            }

            $stmt = $conn->prepare($sql);
            $stmt->execute();

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
            ?>
        </table>
    </div>
</div>
</body>
<?php include 'footer.html'; ?>
</html>
