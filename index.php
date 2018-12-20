<?php
require 'functions.php';

if (!isset($_SESSION)) {
    session_start();
}

generate_header('Homepage');

if (isset($_GET['logout'])) {
    unset($_SESSION['username']);
    unset($_SESSION['organisation']);
    header('Location:  ' . $_SERVER['PHP_SELF']);
}

if (isset($_GET['organisation_id'])) {
    $_SESSION['username'] = 'contactpersoon';
    $_SESSION['organisation'] = $_GET['organisation_id'];
    header('Location:  ' . $_SERVER['PHP_SELF']);
}
if (!isset($_SESSION['username'])) {?>
<body>
<h1 class="text-center">Welcome to ISE-PROJECT SBB</h1>
<br>
<h3 class="text-center">Login als Planner / Leerbedrijf / Deelnemer</h3>
<br>
<div class="container">
    <div class="row justify-content-md-center">
        <form class="form-horizontal" name="login" action="" method="post">
            <input align="right" type="submit" name="planner" value="Planner"/>
            <input align="right" type="submit" name="contactpersoon" value="Contactpersoon"/>
            <input class="text-center" type="submit" name="deelnemer" value="Deelnemer"/>
        </form>
    </div>
</div>
<?php }elseif (isset($_SESSION['username'])) { ?>
<div class="container">
    <h3 class="text-center">Je bent ingelogt als <?= $_SESSION['username'] ?></h3>
</div>
<div class="row justify-content-md-center">
    <button class="btn btn-danger btn-lg"><a href="?logout=1">Logout</a></button></div>
<?php
}
if (isset($_POST['planner'])) {
    $_SESSION['username'] = 'planner';
    header("Refresh:0");
} elseif (isset($_POST['contactpersoon'])) {
    ?>
    <div class="container">
        <h3 class="text-center">Kies hieronder uw organisatie</h3>
        <div class="row justify-content-md-center">
            <?php
            echo selectBox("Organisation_Name", "Organisatie", array("Organisatienaam", "ORGANISATIENUMMER"), "ORGANISATIENUMMER", array("Organisatienaam"), "Organisatienaam");
            ?>
        </div>
        <button class="bg-success" onclick="setOrganisation()">Log in</button>
    </div>
    <?php
} elseif (isset($_POST['deelnemer'])) {
    $_SESSION['username'] = 'deelnemer';
    header("Refresh:0");
}

include 'footer.html'; ?>
<script>
    function setOrganisation() {
        var element = document.getElementById('Organisation_Name').value;
        window.location.href = "index.php?organisation_id=" + element;
    }
</script>



