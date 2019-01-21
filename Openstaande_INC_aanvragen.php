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
                <?php
                if(isset($_SESSION['username']) && $_SESSION['username'] == 'contactpersoon'){
                    echo '<th>Aanvraag nummer</th>';
                }elseif(isset($_SESSION['username']) && $_SESSION['username'] == 'planner'){
                    echo '<th>Organisatie</th>';
                }
                ?>
                <th>Aantal groepen</th>
                <th>Adviseur naam</th>
                <th>Datum aanvraag</th>
            </tr>
            <?php
            //Try to make connection
            $conn = connectToDB();

            //Run the stored procedure
    if(isset($_SESSION['username']) && $_SESSION['username'] == 'contactpersoon') {
        $where = $_SESSION['organisation'];
        $where_column = 'O.ORGANISATIENUMMER';

        $sql = "exec SP_get_workshoprequests ?, ?";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(1, $where, PDO::PARAM_STR);
        $stmt->bindParam(2, $where_column, PDO::PARAM_STR);
    }else{
        $sql = "exec SP_get_workshoprequests";
        $stmt = $conn->prepare($sql);
    }
            $stmt->execute();
            $nummer = 0;

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

                $nummer++;
                $html = '';
                $link = $row['AANVRAAG_ID'];
                $html .= "<tr onclick=\"window.location='INCaanvraag.php?aanvraag_id=$link'\">";
                $html .= '<td class="align-middle">';
                if(isset($_SESSION['username']) && $_SESSION['username'] == 'contactpersoon'){
                    $html .= $nummer;
                }elseif(isset($_SESSION['username']) && $_SESSION['username'] == 'planner'){
                    $html .= $row['ORGANISATIENAAM'];
                }

                $html .= '</td>';
                $html .= '<td class="align-middle">';
                $html .= $row['AANTAL_GROEPEN'];
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
include 'footer.php';