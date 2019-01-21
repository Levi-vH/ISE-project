<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

if ($_SESSION['username'] == 'beheerder') {
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $sectorname = $_POST['sectorname'];

        createSector($sectorname);

    }



    generate_header('Nieuwe sector toevoegen');
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
                <th>Verwijder sector</th>
                <p class="alert-danger warning deletewarning">Let op! Het verwijderen van sectoren heeft geen gevolgen voor de al geplande/aangevraagde workshops met deze sector.</p>
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
                $html .= '<td>';
                $html .= '<a class="fas fa-times" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze persoon wilt verwijderen? Zijn of haar gegevens worden niet opgeslagen\')" href=""></a>';
                $html .= '</td>';
                $html .= '</tr>';

                echo $html;
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
