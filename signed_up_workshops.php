<?php

include 'functions.php';

generate_header('Ingeschreven workshops');

$deelnemer_id = 4;
?>
<html lang="en">
<body>
<div class="container">
    <h2 class="text-info text-center">Overzicht workshops</h2>
    <div>
        <table class='table table-striped table-hover'>
            <tr>
                <th>Workshoptype</th>
                <th>Module</th>
                <th>Datum</th>
                <th>Organisatie</th>
            </tr>
            <?php
            //Try to make connection
            $conn = connectToDB();

            //Run the stored procedure
            // $sql = "SELECT * FROM VW_WORKSHOPS";
            $sql = "EXEC SP_get_participant_workshops ?";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(1, $deelnemer_id, PDO::PARAM_INT);
            $stmt->execute();

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

                $html = '';
                $link = $row['WORKSHOP_ID'];
                $html .= "<tr onclick=\"window.location='workshop_participant.php?workshop_id=$link'\">";
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
</html>
<?php include 'footer.html'; ?>
