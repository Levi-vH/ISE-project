<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

if ($_SESSION['username'] == 'beheerder') {


    generate_header('Nieuwe planner toevoegen');
    ?>
    <body>
    <div class="container">
        <h2 class="text-info text-center">Maak een nieuwe contactpersoon aan</h2>
        <form class="form-horizontal" action="createcontactpersons.php" method="post">
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="Organisation_Name">Organisatie:</label>
                <div class="col-sm-10">
                    <?php
                    echo selectBox("Organisation_Name", "Organisatie", array("Organisatienaam", "ORGANISATIENUMMER"), "ORGANISATIENUMMER", array("Organisatienaam"), "Organisatienaam");
                    ?>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-success btn-lg">Kies organisatie</button>
                </div>
            </div>
        </form>
        <table class='table table-striped table-hover'>
            <tr>
                <th>Naam</th>
                <th>Telefoonnummer</th>
                <th>Email</th>
                <th>Verwijder contactpersoon</th>
                <p class="alert-danger warning deletewarning">Let op! Het verwijderen van contactpersonen heeft geen
                    gevolgen voor de al geplande/aangevraagde workshops met deze contactpersoon.</p>
            </tr>
            <?php
            if ($_SERVER["REQUEST_METHOD"] == "POST" && !isset($_POST['name'])) {
                $organisation_name = $_POST['Organisation_Name'];

                $conn = connectToDB();
                $sql = "SELECT * FROM CONTACTPERSOON WHERE ORGANISATIENUMMER = ?";
                $stmt = $conn->prepare($sql);
                $stmt->bindParam(1, $organisation_name, PDO::PARAM_STR);
                $stmt->execute();

                while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

                    $html = '';
                    $html .= '<tr>';
                    $html .= '<td>';
                    $html .= $row['VOORNAAM'] . ' ' . $row['ACHTERNAAM'];
                    $html .= '</td>';
                    $html .= '<td>';
                    $html .= $row['TELEFOONNUMMER'];
                    $html .= '</td>';
                    $html .= '<td>';
                    $html .= $row['EMAIL'];
                    $html .= '</td>';
                    $html .= '<td>';
                    $html .= '<a class="fas fa-times" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze persoon wilt verwijderen? Zijn of haar gegevens worden niet opgeslagen\')" href=""></a>';
                    $html .= '</td>';
                    $html .= '</tr>';

                    echo $html;
                }
            }
            if (isset($organisation_name)) { ?>
                <form class="form-horizontal" action="createcontactpersons.php?organisation=<?=$organisation_name?>" method="post">
                    <h2>Maak nieuwe contactpersoon aan</h2>
                    <div class="form-group">
                        <label class="control-label col-sm-2 font-weight-bold" for="name">Voornaam:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="name" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-6 font-weight-bold" for="surname">Achternaam:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="surname">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2 font-weight-bold"
                               for="phonenumber">Telefoonnummer:</label>
                        <div class="col-sm-10">
                            <input type="number" class="form-control" name="phonenumber">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2 font-weight-bold" for="email">Email:</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" name="email">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-10">
                            <button type="submit" class="btn btn-success btn-lg">Maak aan</button>
                        </div>
                    </div>
                </form>
                <?php
            }
            if (isset($_POST['name'])) {
                $contactperson_name = $_POST['name'];
                $contactperson_surname = $_POST['surname'];
                $contactperson_phonenumber = $_POST['phonenumber'];
                $contactperson_email = $_POST['email'];

                pre_r($_POST);

                createContactpersoon($_GET['organisation'], $contactperson_name, $contactperson_surname,
                    $contactperson_phonenumber, $contactperson_email );
                updatePage('createcontactpersons.php?createSuccess');
            }

            if(isset($_GET['createSuccess'])) {
                echo '<p class="alert-success warning deletewarning">Contactpersoon toegevoegd!</p>';
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
