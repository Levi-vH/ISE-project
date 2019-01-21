<?php
if (!isset($_SESSION)) {
    session_start();
}
include 'functions.php';
generate_header('Nieuwe sector toevoegen');


if ($_SESSION['username'] == 'beheerder') {
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $sectorname = $_POST['sectorname'];

        if (checkIfSectorExists($sectorname) == "") {
            createSector($sectorname);
        } else {
            echo '<p class="alert-danger warning deletewarning">Sector bestaat al!</p>';
        }

    }
    ?>
    <body>
    <div class="container">
        <h2 class="text-info text-center">Maak een nieuwe sector aan</h2>
        <form class="form-horizontal" action="createsector.php" method="post">
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="sectorname">Sector Naam:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="sectorname" required>
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
                <th>Alle sectoren</th>
                <th>Zet op actief/inactief</th>
                <th>Verwijder sector</th>
                <th>Status</th>
                <p class="alert-warning deletewarning">Let op! Het verwijderen van sectoren kan alleen als er geen
                    personen of workshops aan gekoppeld zijn. Zet deze sectoren op inactief</p>
            </tr>
            <?php
            $conn = connectToDB();
            $sql = "SELECT * FROM SECTOR";
            $stmt = $conn->prepare($sql);
            $stmt->execute();

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

                $html = '';
                $html .= "<tr>";
                $html .= '<td>';
                $html .= $row['SECTORNAAM'];
                $html .= '</td>';
                if ($row['IS_ACTIEF'] == 1) {
                    $html .= '<td>';
                    $html .= '<a class="fas fa-ban" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze sector op inactief wilt zetten? \')" href="createsector.php?sector=' . $row['SECTORNAAM'] . '&inactiveSector=true"></a>';
                    $html .= '</td>';
                } elseif ($row['IS_ACTIEF'] == 0) {
                    $html .= '<td>';
                    $html .= '<a class="fas fa-check" id="approvebutton" onclick="return confirm(\'Weet je zeker dat je deze sector op actief wilt zetten? \')" href="createsector.php?sector=' . $row['SECTORNAAM'] . '&activeSector=true"></a>';
                    $html .= '</td>';
                }
                $html .= '<td>';
                $html .= '<a class="fas fa-times" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze sector wilt verwijderen?\')" href="createsector.php?sector=' . $row['SECTORNAAM'] . '&deleteSector=true"></a>';
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

                echo $html;
            }

            if (isset($_GET['deleteSector'])) {
                if (!checkIfSectorExistsAnywhere($_GET['sector'])) {
                    deleteSector($_GET['sector']);
                    updatePage('createsector.php?deleteSuccess');
                } else {
                    updatePage('createsector.php?deleteFailed');
                }
            } elseif (isset($_GET['inactiveSector'])) {
                setInactive('SECTOR', 'SECTORNAAM', $_GET['sector']);
                updatePage('createsector.php?inactiveSuccess');
            } elseif (isset($_GET['activeSector'])) {
                setActive('SECTOR', 'SECTORNAAM', $_GET['sector']);
                updatePage('createsector.php?inactiveSuccess');
            }

            if (isset($_GET['deleteFailed'])) {
                echo '<p class="alert-danger warning deletewarning">Verwijderen mislukt! Sector wordt nog gebruikt in een workshop of ergens anders</p>';
            } elseif (isset($_GET['deleteSuccess'])) {
                echo '<p class="alert-success warning deletewarning">Verwijderen gelukt!</p>';
            } elseif (isset($_GET['inactiveSuccess'])) {
                echo '<p class="alert-success warning deletewarning">Op inactief/actief gezet!</p>';
            }

            ?>
        </table>
    </div>
    </body>
    </html>
    <?php
} else {
    notLoggedIn();
}
include 'footer.html';
