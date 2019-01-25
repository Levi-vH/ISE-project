<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

$errorMessage = null;

if ($_SESSION['username'] == 'beheerder') {


    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $organisation_name = $_POST['name'];
        $organisation_address = $_POST['address'];
        $organisation_postcode = $_POST['postcode'];
        $organisation_city = $_POST['city'];
        $large_accounts = $_POST['la'];
        try {
            createOrganisation($organisation_name, $organisation_address, $organisation_postcode, $organisation_city, $large_accounts);
        } catch (PDOException $e) {
            echo '<p class="alert-danger warning deletewarning">Kan organisatie niet aanmaken.</p>';
        }
    }
    generate_header('Nieuwe organisatie toevoegen');
    ?>
    <body>
    <div class="container">
        <h2 class="text-info text-center">Maak een nieuwe organisatie aan</h2>
        <form class="form-horizontal" action="createorganisation.php" method="post">
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="name">Organisatie Naam:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="name" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="address">Adres:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="address" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="postcode">Postcode:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="postcode" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="city">Plaatsnaam:</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" name="city" required>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2 font-weight-bold" for="city">Toegestaan voor large accounts:</label>
                <div class="col-sm-10">
                    <input type="radio" name="la" value="1" >Ja<br>
                    <input type="radio" name="la" value="0">Nee<br>
                </div>
            </div>
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
