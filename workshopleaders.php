<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';
generate_header('Workshopleiders');

if ($_SESSION['username'] == 'planner') {
    if (isset($_GET['add']) && !isset($_POST['delete'])) {
        if ($_GET['add'] == true) {
            $id = $_POST['workshopleader'];
            $year = $_POST['year'];
            $quarter = $_POST['quarter'];
            $hours = $_POST['hours'];

            insertWorkshopleaderHours($id, $quarter, $year, $hours);
        }
    }

    if(isset($_POST['delete'])){
        $id = $_POST['workshopleader'];
        $year = $_POST['year'];
        $quarter = $_POST['quarter'];
        $hours = $_POST['hours'];

        deleteWorkshopleaderHours($id, $quarter, $year, $hours);
    }


    ?>

    <body>
    <div class="container">
        <h2 class="text-info text-center">Workshopleiders</h2>
        <form class="form-horizontal" action="workshopleaders.php" method="post">
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="workshopmodule">Workshopleider:</label>
                <div class="col-sm-10">
                    <?php
                    echo selectBox("workshopleader", "workshopleider", array("achternaam", "voornaam", "workshopleider_id"), "workshopleider_id", array("achternaam", "voornaam"), "achternaam, voornaam");
                    ?>
                </div>
                <br>
                <button type="submit" class="btn btn-success">Kies workshopleider</button>
            </div>
        </form>
        <?php
        if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $workshopleader_id = $_POST['workshopleader'];
        ?>
        <script type="text/javascript">
            var element = document.getElementById("workshopleader");
            var value = "<?= $workshopleader_id ?>";
            element.value = value;
        </script>
        <h2>Plan nieuwe uren in</h2>
        <form class="form-horizontal" action="workshopleaders.php?add=true" method="post">
            <input type="hidden" value="<?= $workshopleader_id ?>" name="workshopleader">
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="year">Jaar</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" placeholder="Jaar" name="year" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="quarter">Kwartaal:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" placeholder="Kwartaal" name="quarter" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="hours">Aantal uur:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" placeholder="Aantal uur" name="hours" required>
                </div>
            </div>
            <button type="submit" class="btn btn-success">Voeg toe</button>
        </form>
        <h2>Overzicht</h2>
        <div>
            <table class='table table-striped table-hover'>
                <tr>
                    <th>Jaar</th>
                    <th>Kwartaal</th>
                    <th>Aantal uur</th>
                    <th>Verwijder uren</th>
                </tr>
                <?php

                $conn = connectToDB();

                $sql = "SELECT * FROM BESCHIKBAARHEID WHERE WORKSHOPLEIDER_ID = ?";
                $stmt = $conn->prepare($sql);
                $stmt->bindParam(1, $workshopleader_id, PDO::PARAM_INT);
                try {
                    $stmt->execute();
                } catch (PDOException $e) {
                    echo '<p class="alert-danger warning deletewarning">Kan beschikbaarheid van workshopleider(s) niet ophalen.</p>';
                }

                while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                    $html = '<form method="post"  class="form-horizontal" onsubmit="return confirm(\'Weet je zeker dat je deze persoon wilt verwijderen? Zijn of haar gegevens worden niet opgeslagen\')">';
                    $html .= '<input type="hidden" name="year" value="'.$row['JAAR'].'">';
                    $html .= '<input type="hidden" name="quarter" value="'.$row['KWARTAAL'].'">';
                    $html .= '<input type="hidden" name="hours" value="'.$row['AANTAL_UUR'].'">';
                    $html .= '<input type="hidden" name="workshopleader" value="'.$workshopleader_id.'">';

                    $html .= '<tr>';
                    $html .= '<td>';
                    $html .= $row['JAAR'];
                    $html .= '</td>';
                    $html .= '<td>';
                    $html .= $row['KWARTAAL'];
                    $html .= '</td>';
                    $html .= '<td>';
                    $html .= $row['AANTAL_UUR'];
                    $html .= '</td>';
                    $html .= '<td>';
                    $html .= '<button type="submit" name="delete" class="deletebutton"><i class="fas fa-times" id="denybutton"></i></button>';
                    $html .= '</td>';
                    $html .= '</tr>';
                    $html .= '</form>';

                    echo $html;
                }
                }
                ?>
            </table>
    </body>
    </html>

    <?php
} else {
    notLoggedIn();
}
include 'footer.php';
