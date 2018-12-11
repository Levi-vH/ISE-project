<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

if ($_SESSION['username'] == 'planner' or $_SESSION['username'] == 'contactpersoon') {
generate_header('Incompany Aanvragen');
    ?>

<body>
<div class="container">
    <h2 class="text-info text-center" >Openstaande INC aanvragen</h2>
    <div>
        <table class='table table-striped table-hover'>
            <tr>
                <th>Organisatie</th>
                <th>Aantal groepen</th>
                <th>Datum aanvraag</th>
            </tr>
            <?php
            //Try to make connection
            $conn = connectToDB();

            //Run the stored procedure
            // $sql = "SELECT * FROM VW_WORKSHOPS";
            $sql = "exec proc_get_WorkshopRequests";
            $stmt = $conn->prepare($sql);
            $stmt->execute();

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $html = '';
                $link = $row['AANVRAAG_ID'];
                $html .= "<tr onclick=\"window.location='INCaanvraag.php?aanvraag_id=$link'\">";
                $html .= '<td class="align-middle">';
                $html .= $row['ORGANISATIENAAM'];
                $html .= '</td>';
                $html .= '<td class="align-middle">';
                $html .= $row['AANTAL_GROEPEN'];
                $html .= '</td>';
                $html .= '<td class="align-middle">';
                $html .=  date('j F Y', strtotime($row['AANVRAAG_DATUM']));
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
<?php } else {
    echo '<h1> U mag deze pagina niet bezoeken</h1>';
}
include 'footer.html';