<?php
include 'header.html';
include 'functions.php';

$id = $_GET['id'];

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>deelnemers</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
          integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
            integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
            integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css"
          integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
    <link rel="stylesheet" href="css/custom.css">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-sm-4 sidebar1">
            <div class="left-navigation">
                <ul class="list">
                    <h5><strong>Workshop Opties</strong></h5>
                    <li>
                        <a class="active-page">Inzien deelnemers</a>
                    </li>
                    <li>
                        <a href="editworkshop.php?id=<?php echo $id ?>">Wijzig workshop</a>
                    </li>
                    <li>
                        <a href="INCworkshop.php">K</a>
                    </li>
                    <li>
                        <a href="allworkshops.php">P</a>
                    </li>
                    <li>
                        <a href="allworkshops.php">H</a>
                    </li>
                </ul>

                <br>
            </div>
        </div>
        <div class="col-md-10 col-sm-8 main-content">
            <!--Main content code to be written here -->
            <h1>Deelnemers</h1>
            <h3>workshopnummer<?php echo $id ?></h3>
            <div>
                <table class='table table-striped table-hover'>
                    <tr>
                        <th>Voornaam</th>
                        <th>Achternaam</th>
                        <th>Volgnummer</th>
                    </tr>
                    <?php
                    //Try to make connection
                    $conn = connectToDB();

                    //Run the stored procedure
                    $sql = "exec proc_request_workshop_participants ?";
                    $stmt = $conn->prepare($sql);
                    $stmt->bindParam(1, $id, PDO::PARAM_INT);
                    $stmt->execute();

                    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                        $html = '';
                        $html .= '<tr>';
                        $html .= '<td>';
                        $html .= $row['VOORNAAM'];
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['ACHTERNAAM'];
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['VOLGNUMMER'];
                        $html .= '</td>';
                        $html .= '</tr>';

                        echo $html;

                    }

                    ?>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.html'; ?>

