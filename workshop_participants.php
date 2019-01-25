<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';
generate_header('Deelnemers');

if ($_SESSION['username'] == 'planner' or $_SESSION['username'] == 'contactpersoon') {

$workshop_id = $_GET['workshop_id'];
$workshoptype = getWorkshopType($workshop_id);

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
                        <a href="workshop.php?workshop_id=<?php echo $workshop_id ?>">Details</a>
                    </li>
                    <li>
                        <a class="active-page">Deelnemers</a>
                    </li>
                    <?php
                    if ($workshoptype == "IND") {
                        echo '<li>';
                        echo '<a href="open_registrations.php?workshop_id=' . $workshop_id . '">Openstaande inschrijvingen</a>';
                        echo '</li>';
                    }
                    ?>
                    <li>
                        <a href="reservelist.php?workshop_id=<?= $workshop_id ?>">Reservelijst</a>
                    </li>
                    <?php
                    if ($_SESSION['username'] == "planner") {
                        echo '<li>';
                        echo '<a href="editworkshop.php?workshop_id=' . $workshop_id . '">Wijzig workshop</a>';
                        echo '</li>';
                    }
                    ?>
                    <li>
                        <a href="addparticipant_workshop.php?workshop_id=<?= $workshop_id ?>">Voeg deelnemers toe</a>
                    </li>
                </ul>
                <br>
            </div>
        </div>
        <div class="col-md-10 col-sm-8 main-content">

            <h1>Deelnemers</h1>
            <div>
                <table class='table table-striped table-hover'>
                    <tr>
                        <th>Nummer</th>
                        <th>Naam</th>
                        <th>Geboortedatum</th>
                        <th>Opleidingsniveau</th>
                        <th>Email</th>
                        <th>Telefoonnummer</th>
                        <th>Verwijderen</th>
                    </tr>
                    <?php
                    $conn = connectToDB();
                    //Run the stored procedure
                    $sql = "exec SP_get_list_of_approved_workshop_participants ?";
                    $stmt = $conn->prepare($sql);
                    $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
                    try {
                        $stmt->execute();
                    } catch (PDOException $e) {
                        echo '<p class="alert-danger warning deletewarning">Kan lijst met deelnemers niet ophalen.</p>';
                    }

                    $nummer = 0;

                    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                        $nummer++;
                        $html = '';
                        $html .= '<tr>';
                        $html .= '<td>';
                        $html .= $nummer;
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['VOORNAAM'] . ' ' . $row['ACHTERNAAM'];
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['GEBOORTEDATUM'];
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['OPLEIDINGSNIVEAU'];
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['EMAIL'];
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['TELEFOONNUMMER'];
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= '<a class="fas fa-times" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze persoon wilt verwijderen? Zijn of haar gegevens worden niet opgeslagen\')" href="workshop_participants.php?workshop_id=' . $workshop_id . '&participant_id=' . $row['DEELNEMER_ID'] . '&deleteUser=true"></a>';
                        $html .= '</td>';
                        $html .= '</tr>';

                        echo $html;
                    }
                    if (isset($_GET['deleteUser'])) {
                        deleteUserWorkshop($workshop_id, $_GET['participant_id']);
                        updatePage($_SERVER['PHP_SELF'] . '?workshop_id=' . $workshop_id);
                    }
                    }

                    if (isset($_POST['downloadexcel'])) {
                        $newSql = 'exec SP_get_list_of_approved_workshop_participants ' . $workshop_id;
                        createExcelParticipants($newSql, $workshop_id);
                        updatePage('workshop_participants.php?workshop_id=' . $workshop_id);
                    }
                    if (isset($_GET['error'])) {
                        echo '<p class="alert-danger warning">Fout! Sluit eerst het oude bestand <br>Elke download wordt in het zelfde bestand geschreven<br>Verander eerst de bestandsnaam voordat je het opnieuw download</p>';
                    }
                    ?>
                </table>
                <div class="float-right">
                    <form method="post">
                        <button name="downloadexcel" type="submit" class="btn btn-secondary btn-lg">Download Excel
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>