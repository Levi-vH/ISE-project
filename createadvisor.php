<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

$errorMessage = null;

if ($_SESSION['username'] == 'beheerder') {


    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $organisation = $_POST['Organisation_Name'];
        $adviser_sector = $_POST['workshopsector'];
        $adviser_name = $_POST['name'];
        $adviser_surname = $_POST['surname'];
        $adviser_phonenumber = $_POST['phonenumber'];
        $adviser_email = $_POST['email'];

        try {
            createAdviser($organisation, $adviser_sector, $adviser_name, $adviser_surname, $adviser_phonenumber, $adviser_email);
        } catch (PDOException $e) {
            echo '<p class="alert-danger warning deletewarning">Kan adviseur niet aanmaken. Message: ' . $e . '</p>';
        }

    }

    generate_header('Nieuwe adviseur toevoegen');
    ?>
    <body>
    <div class="container">
        <h2 class="text-info text-center">Maak een nieuwe adviseur aan</h2>
        <form class="form-horizontal" action="createadvisor.php" method="post">
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="Organisation_Name">Organisatie Naam:</label>
                <div class="col-sm-10">
                    <?php
                    echo selectBox("Organisation_Name", "Organisatie", array("Organisatienaam", "ORGANISATIENUMMER"), "ORGANISATIENUMMER", array("Organisatienaam"), "Organisatienaam");
                    ?>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="sector">Sector:</label>
                <div class="col-sm-10">
                    <?php
                    echo selectBox("workshopsector", "sector", array("sectornaam"), "sectornaam", array("sectornaam"), "sectornaam");
                    ?>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="name">Naam:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="name" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="surname">Achternaam:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="surname" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="phonenumber">Telefoonnummer:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="phonenumber" required>
                </div>
            </div>
            <div>
                <label class="control-label col-sm-2 font-weight-bold" for="email">Email:</label>
                <div class="col-sm-10">
                    <input type="email" class="form-control" name="email" required>
                </div>
            </div>
            <br>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-success btn-lg">Maak aan</button>
                </div>
            </div>
        </form>
    </div>
    </body>
    </html>
<?php } else {
    notLoggedIn();
}
include 'footer.php';
