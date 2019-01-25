<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';
generate_header('Reservelijst');

if ($_SESSION['username'] == 'planner' or $_SESSION['username'] == 'contactpersoon') {

$workshop_id = $_GET['workshop_id'];
$workshoptype = getWorkshopType($workshop_id);

?>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-sm-4 sidebar1">
            <div class="left-navigation">
                <ul class="list">
                    <h5><strong>Workshop Opties</strong></h5>
                    <?php
                    if ($_SESSION['username'] == "planner") {
                        echo '<li>';
                        echo '<a href="workshop.php?workshop_id='.$workshop_id.'">Details</a>';
                        echo '</li>';
                    } elseif($_SESSION['username'] == "contactpersoon") {
                        echo '<li>';
                        echo '<a href="Organisatie_workshop_details.php?workshop_id='.$workshop_id.'">Details</a>';
                        echo '</li>';
                    }
                    ?>
                    <li>
                        <a href="workshop_participants.php?workshop_id=<?= $workshop_id ?>">Deelnemers</a>
                    </li>
                    <?php
                    if ($workshoptype == "IND") {
                        echo '<li>';
                        echo '<a href="open_registrations.php?workshop_id=' . $workshop_id . '">Openstaande inschrijvingen</a>';
                        echo '</li>';
                    }
                    ?>
                    <li>
                        <a class="active-page">Reservelijst</a>
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
            <h1>Reservelijst</h1>
            <div>
                <table class='table table-striped table-hover'>
                    <tr>
                        <th>Nummer</th>
                        <th>Voornaam</th>
                        <th>Achternaam</th>
                        <th>Afmelden</th>
                    </tr>
                    <?php
                    //Try to make connection
                    $conn = connectToDB();


                    //Run the stored procedure
                    $sql = "exec SP_get_reservelist_of_approved_workshop_participants ?";
                    $stmt = $conn->prepare($sql);
                    $stmt->bindParam(1, $workshop_id, PDO::PARAM_INT);
                    try {
                        $stmt->execute();
                    } catch (PDOException $e) {
                        echo '<p class="alert-danger warning deletewarning">Kan reservelijst niet ophalen.</p>';
                    }$stmt->execute();

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
                        $html .= '<a class="fas fa-times" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze persoon wilt verwijderen? Zijn of haar gegevens worden niet opgeslagen\')" href="reservelist.php?workshop_id='.$workshop_id.'&participant_id='.$row['DEELNEMER_ID'].'&deleteUser=true"></a>';
                        $html .= '</td>';
                        $html .= '</tr>';
                        echo $html;
                    }

                    if(isset($_GET['deleteUser'])) {

                    deleteUserWorkshop($workshop_id, $_GET['participant_id']);
                    updatePage($_SERVER['PHP_SELF'].'?workshop_id='.$workshop_id);
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
include 'footer.php';


