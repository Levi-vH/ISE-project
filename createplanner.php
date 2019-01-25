<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

$errorMessage = null;

if ($_SESSION['username'] == 'beheerder') {

    generate_header('Nieuwe planner toevoegen');

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $planner_name = $_POST['plannername'];

        try {
            createPlanner($planner_name);
        } catch (PDOException $e) {
            echo '<p class="alert-danger warning deletewarning">Planner bestaat al! (of er is iets anders misgegaan)</p>';
        }
    }

    ?>
    <body>
    <div class="container">
        <h2 class="text-info text-center">Maak een nieuwe planner aan</h2>
        <form class="form-horizontal" action="createplanner.php" method="post">
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="plannername">Planner Naam:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="plannername" required>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-success btn-lg">Maak aan</button>
                </div>
            </div>
        </form>
        <table class='table table-striped table-hover'>
            <tr>
                <th>Alle planners</th>
                <th>Zet planner actief/inactief</th>
                <th>Verwijder planner</th>
                <th>Status</th>
                <p class="alert-danger warning deletewarning">Let op! Het verwijderen van planners heeft geen gevolgen
                    voor de al geplande/aangevraagde workshops met deze planner.</p>
            </tr>
            <?php
            $conn = connectToDB();
            $sql = "SELECT * FROM PLANNER";
            $stmt = $conn->prepare($sql);
            $stmt->execute();

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

                $html = '';
                $html .= "<tr>";
                $html .= '<td>';
                $html .= $row['PLANNERNAAM'];
                $html .= '</td>';
                if ($row['IS_ACTIEF'] == 1) {
                    $html .= '<td>';
                    $html .= '<a class="fas fa-ban" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze planner op inactief wilt zetten? \')" href="createplanner.php?planner=' . $row['PLANNERNAAM'] . '&inactivePlanner=true"></a>';
                    $html .= '</td>';
                } elseif ($row['IS_ACTIEF'] == 0) {
                    $html .= '<td>';
                    $html .= '<a class="fas fa-check" id="approvebutton" onclick="return confirm(\'Weet je zeker dat je deze planner op actief wilt zetten? \')" href="createplanner.php?planner=' . $row['PLANNERNAAM'] . '&activePlanner=true"></a>';
                    $html .= '</td>';
                }
                $html .= '<td>';
                $html .= '<a class="fas fa-times" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze planner wilt verwijderen? Zijn of haar gegevens worden niet opgeslagen\')" href="createplanner.php?planner='.$row['PLANNERNAAM'].'&deletePlanner=true"></a>';
                $html .= '</td>';
                if ($row['IS_ACTIEF'] == 1) {
                    $html .= '<td>';
                    $html .= '<p>ACTIEF</p>';
                    $html .= '</td>';
                } elseif ($row['IS_ACTIEF'] == 0) {
                    $html .= '<td>';
                    $html .= '<p>INACTIEF</p>';
                    $html .= '</td>';
                }
                $html .= '</tr>';
                $html .= '</tr>';

                echo $html;
            }

            if (isset($_GET['deletePlanner'])) {
                deletePlanner($_GET['planner']);
                updatePage('createplanner.php?deleteSuccess');
            }elseif (isset($_GET['inactivePlanner'])) {
                setInactive('PLANNER', 'PLANNERNAAM', $_GET['planner']);
                updatePage('createplanner.php?inactiveSuccess');
            }  if (isset($_GET['activePlanner'])) {
                setActive('PLANNER','PLANNERNAAM', $_GET['planner']);
                updatePage('createplanner.php?inactiveSuccess');
            }

            if (isset($_GET['deleteSuccess'])) {
                echo '<p class="alert-success warning deletewarning">Verwijderen gelukt!</p>';
            } elseif (isset($_GET['inactiveSuccess'])) {
                echo '<p class="alert-success warning deletewarning">Op inactief/actief gezet!</p>';
            }

            ?>
        </table>
    </div>
    </body>
    </html>
<?php } else {
    notLoggedIn();
}
include 'footer.php';
