<?php
include 'header.html';
include 'functions.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Aanvragen INC</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
    <link rel="stylesheet" href="css/custom.css"
</head>
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
            $sql = "exec proc_getWorkshopRequest";
            $stmt = $conn->prepare($sql);
            $stmt->execute();

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $html = '';
                //$link = $row['WORKSHOP_ID'];
                $html .= '<tr>';
                $html .= "<tr>";
                $html .= '<td class="align-middle">';
                $html .= $row['ORGANISATIENAAM'];
                $html .= '</td>';
                $html .= '<td class="align-middle">';
                $html .= $row['AANTAL_GROEPEN'];
                $html .= '</td>';
                $html .= '<td class="align-middle">';
                $html .=  date('j F Y', strtotime($row['AANVRAAG_DATUM']));
                $html .= '</td>';
                echo $html;
            }
            ?>
        </table>
    </div>
</div>
</body>
<?php include 'footer.html'; ?>
</html>