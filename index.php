<?php
require 'functions.php';

generate_header('Homepage');
?>

<body>
<h1 class="text-center">Welcome to ISE-PROJECT SBB</h1>
<br>
<?php
if (!isset($_SESSION)) {
    session_start();
}

$userinfo = array(
    'planner' => 'planner',
    'contactpersoon' => 'contactpersoon'
);

if (isset($_GET['logout'])) {
    unset($_SESSION['username']);
    header('Location:  ' . $_SERVER['PHP_SELF']);
}

if (isset($_POST['planner'])) {
    $_SESSION['username'] = 'planner';
    header("Refresh:0");
} elseif (isset($_POST['contactpersoon'])) {
    $_SESSION['username'] = 'contactpersoon';
    header("Refresh:0");
} elseif (isset($_POST['deelnemer'])) {
    $_SESSION['username'] = 'deelnemer';
    header("Refresh:0");
}
?>

<?php if (isset($_SESSION['username'])){ ?>
    <h3 class="text-center">Je bent ingelogt als <?= $_SESSION['username'] ?></h3>
    <div class="row justify-content-md-center">
        <button class="btn btn-danger btn-lg"><a href="?logout=1">Logout</a></button>
    </div>
<?php } else { ?>
    <h3 class="text-center">Login als Planner / Leerbedrijf / Deelnemer</h3>
    <BR>
    <div class="row justify-content-md-center">
        <form class="form-horizontal" name="login" action="" method="post">
            <input align="right" type="submit" name="planner" value="Planner"/>
            <input class="text-center" type="submit" name="contactpersoon" value="Contactpersoon"/>
            <input class="text-center" type="submit" name="deelnemer" value="Deelnemer"/>
        </form>
    </div>
<?php } ?>
</body>
    </html>
<?php include 'footer.html'; ?>
