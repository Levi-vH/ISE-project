<?php

include 'functions.php';

generate_header('Ingeschreven workshops');

$deelnemer_id = $_SESSION['deelnemer_id'];
?>
<html lang="en">
<body>
<div class="container">
    <h2 class="text-info text-center">Overzicht workshops</h2>
    <?php
        if(isset($_SESSION['message'])) {
            echo '<p>' . $_SESSION['message'] . '</p>';
            unset($_SESSION['message']);
        }
    ?>
    <div>
        <table class='table table-striped table-hover'>
            <tr>
                <th>Workshoptype</th>
                <th>Module</th>
                <th>Datum</th>
                <th>Organisatie</th>
                <th>Status inschrijving</th>
            </tr>
            <?php
            //Try to make connection
            $conn = connectToDB();


            //Run the stored procedure
            $sql = "EXEC SP_get_participant_workshops ?";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(1, $deelnemer_id, PDO::PARAM_INT);
            try {
                $stmt->execute();
            } catch (PDOException $e) {
                echo '<p class="alert-danger warning deletewarning">Kan workshops van deelnemer niet ophalen. Message: ' . $e . '</p>';
            }

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
                $html .= '<td class="align-middle">';
                $html .= $row['STATUS'];
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
<?php include 'footer.php'; ?>
