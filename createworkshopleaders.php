<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';

if ($_SESSION['username'] == 'beheerder') {


    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $workshopleider_name = $_POST['name'];
        $workshopleider_surname = $_POST['surname'];

        pre_r($_POST);

        createWorkshopleader($workshopleider_name, $workshopleider_surname);


    }

    generate_header('Nieuwe workshopleider toevoegen');
    ?>
    <body>
    <div class="container">
        <h2 class="text-info text-center">Maak een nieuwe workshopleider aan</h2>
        <form class="form-horizontal" action="createworkshopleaders.php" method="post">
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
include 'footer.html';
