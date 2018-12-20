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
                    <th>Aantal groepen</th>
                    <th>Adviseur naam</th>
                    <th>Datum aanvraag</th>
                </tr>
                <?php
                //Try to make connection
                $conn = connectToDB();

                //Run the stored procedure
                $sql = "exec SP_get_workshops @where = ?, @where_column = ?";
                $where = 'Educational Services';
                $where_column = 'O.ORGANISATIENAAM';
                $stmt = $conn->prepare($sql);
                $stmt->bindParam(1, $where, PDO::PARAM_STR);
                $stmt->bindParam(2, $where_column, PDO::PARAM_STR);
                $stmt->execute();


                while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                    $html = '';
                    $link = $row['DATUM'];
                    $html .= "<tr onclick=\"window.location='INCaanvraag.php?aanvraag_id=$link'\">";
                    $html .= '<td class="align-middle">';
                    $html .= $row['DATUM'];
                    $html .= '</td>';
                    $html .= '<td class="align-middle">';
                    $html .= $row['DATUM'];
                    $html .= '</td>';
                    $html .= '<td class="align-middle">';
                    $html .= $row['ADVISEURVOORNAAM'] . ' ' . $row['ADVISEURACHTERNAAM'];
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
    notLoggedIn();
}
include 'footer.html';