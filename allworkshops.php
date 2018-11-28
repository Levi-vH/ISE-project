<?php
include 'header.html';
include 'functions.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
    <h2 class="text-info text-center" >Overzicht workshops</h2>
    <div>
        <table class='table table-striped table-dark'>";
            <tr>
                <th>Workshoptype</th>
                <th>Datum</th>
                <th>Starttijd</th>
                <th>Eindtijd</th>
                <th>Organisatie</th>
                <th>Aantal deelnemers</th>
            </tr>
            <?php
            //Try to make connection
            $conn = connectToDB();

            //Run the stored procedure
           // $sql = "SELECT * FROM VW_WORKSHOPS";
            $sql = "SELECT * FROM WORKSHOP";
            $stmt = $conn->prepare($sql);
            $stmt->execute();

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $html = '';
                $html .= '<tr>';
                $html .= '<td>';
                $html .= $row['TYPE'];
                $html .= '</td>';
                $html .= '<td>';
                $html .= $row['DATUM'];
                $html .= '</td>';
                $html .= '<td>';
                $html .= $row['ORGANISATIENUMMER'];
                $html .= '</td>';
                $html .= '<td>';
                $html .= $row['ORGANISATIENUMMER'];
                $html .= '</td>';
                $html .= '<td>';
                $html .= $row['ORGANISATIENUMMER'];
                $html .= '</td>';
                $html .= '<td>';
                $html .= $row['ORGANISATIENUMMER'];
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
