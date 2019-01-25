<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

if ($_SESSION['username'] == 'contactpersoon') {
    generate_header('Workshops organisatie');
?>

    <body>
    <div class="container">
        <h2 class="text-info text-center">Workshops</h2>
        <div>
            <table class='table table-striped table-hover'>
                <tr>
                    <th>Datum</th>
                    <th>Starttijd</th>
                    <th>Eindtijd</th>
                    <th>Locatie</th>
                    <th>Module</th>
                </tr>
                <?php
                //Try to make connection
                $conn = connectToDB();


                //Run the stored procedure
                $sql = "exec SP_get_workshops @where = ?, @where_column = ?";
                $where = getOrganisationName($_SESSION['organisation']);
                $where_column = 'O.ORGANISATIENAAM';
                $stmt = $conn->prepare($sql);
                $stmt->bindParam(1, $where, PDO::PARAM_STR);
                $stmt->bindParam(2, $where_column, PDO::PARAM_STR);
                try {
                    $stmt->execute();
                } catch (PDOException $e) {
                    echo '<p class="alert-danger warning deletewarning">Kan workshops niet ophalen.</p>';
                }


                while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                    $html = '';
                    $link = $row['WORKSHOP_ID'];
                    $html .= "<tr onclick=\"window.location='Organisatie_workshop_details.php?workshop_id=$link'\">";
                    $html .= '<td class="align-middle">';
                    $html .= date('j F Y', strtotime($row['DATUM']));
                    $html .= '</td>';
                    $html .= '<td class="align-middle">';
                    $html .= date('H:i',strtotime($row['STARTTIJD']));
                    $html .= '</td>';
                    $html .= '<td class="align-middle">';
                    $html .= date('H:i',strtotime($row['EINDTIJD']));
                    $html .= '</td>';
                    $html .= '<td class="align-middle">';
                    $html .= $row['ADRES'] . ' <BR>' . $row['POSTCODE'] . ', ' .$row['PLAATSNAAM'];
                    $html .= '</td>';
                    $html .= '<td class="align-middle">';
                    $html .=  $row['MODULENUMMER'] . ': ' .$row['MODULENAAM'];
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
    notLoggedIn();
}
include 'footer.php';