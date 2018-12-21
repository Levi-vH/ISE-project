<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

generate_header('Open aanvragen');

if ($_SESSION['username'] == 'planner') {
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
              integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO"
              crossorigin="anonymous">
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
              integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU"
              crossorigin="anonymous">
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
                            <a href="workshop.php?workshop_id=<?= $workshop_id ?>">Details</a>
                        </li>
                        <li>
                            <a href="open_workshop_participants.php?workshop_id=<?= $workshop_id ?>">Deelnemers</a>
                        </li>
                        <li>
                            <a class="active-page">Openstaande inschrijvingen</a>
                        </li>
                        <li>
                            <a href="reservelist.php?workshop_id=<?= $workshop_id ?>">Reservelijst</a>
                        </li>
                        <li>
                            <a href="editworkshop.php?workshop_id=<?= $workshop_id ?>">Wijzig workshop</a>
                        </li>
                        <li>
                            <a href="addparticipant_workshop.php?workshop_id=<?= $workshop_id ?>">Voeg deelnemers toe</a>
                        </li>
                    </ul>
                    <br>
                </div>
            </div>
            <div class="col-md-10 col-sm-8 main-content">
                <!--Main content code to be written here -->
                <h1>Openstaande inschrijvingen</h1>
                <div>
                    <table class='table table-striped table-hover'>
                        <tr>
                            <th>Nummer</th>
                            <th>Voornaam</th>
                            <th>Achternaam</th>
                            <th>Goedkeuren</th>
                            <th>Afkeuren</th>
                        </tr>
                        <?php
                        //Try to make connection
                        $conn = connectToDB();

                        //Run the stored procedure
                        $sql = "exec SP_get_list_of_to_approve_workshop_participants ?";
                        $stmt = $conn->prepare($sql);
                        $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
                        $stmt->execute();

                        $nummer = 0;

                        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                            $nummer++;
                            $html = '';
                            $html .= '<tr>';
                            $html .= '<td>';
                            $html .= $nummer;
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= $row['VOORNAAM'];
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= $row['ACHTERNAAM'];
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= '<a class="fas fa-check" id="approvebutton" onclick="return confirm(\'Weet je zeker dat je deze persoon wilt toevoegen?\')" href="open_registrations.php?workshop_id=' . $workshop_id . '&participant_id=' . $row['DEELNEMER_ID'] . '&addUser=true"></a>';
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= '<a class="fas fa-times" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze persoon wilt verwijderen? Zijn of haar gegevens worden niet opgeslagen\')" href="open_registrations.php?workshop_id=' . $workshop_id . '&participant_id=' . $row['DEELNEMER_ID'] . '&deleteUser=true"></a>';
                            $html .= '</td>';
                            $html .= '</tr>';
                            echo $html;
                        }

                        if (isset($_GET['deleteUser'])) {
                            deleteUserWorkshop($workshop_id, $_GET['participant_id']);
                            updatePage($_SERVER['PHP_SELF'] . '?workshop_id=' . $workshop_id);
                        }

                        if (isset($_GET['addUser'])) {
                            addUser($workshop_id, $_GET['participant_id']);
                            updatePage($_SERVER['PHP_SELF'] . '?workshop_id=' . $workshop_id);
                        }

                        ?>
                    </table>
                </div>
            </div>
        </div>
    </div>
    </body>
    </html>
<?php } else {
    notLoggedIn();
}
include 'footer.html';


