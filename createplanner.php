<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

$errorMessage = null;

if ($_SESSION['username'] == 'beheerder') {


    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $planner_name = $_POST['plannername'];

        //pre_r($_POST);

        createPlanner($planner_name);


    }

    generate_header('Nieuwe planner toevoegen');
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
                <th>Verwijder planner</th>
                <p class="alert-danger warning deletewarning">Let op! Het verwijderen van planners heeft geen gevolgen voor de al geplande/aangevraagde workshops met deze planner.</p>
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
                $html .= '<td>';
                $html .= '<a class="fas fa-times" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze planner wilt verwijderen? Zijn of haar gegevens worden niet opgeslagen\')" href=""></a>';
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
include 'footer.html';
