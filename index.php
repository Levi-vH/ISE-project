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
<h1 class="text-center">Login als planner of contactpersoon</h1>
<?php if (isset($_SESSION['username'])){ ?>
    <p class="text-center">Je bent ingelogt als <?= $_SESSION['username'] ?></p>
    <p class="text-center"><a href="?logout=1">Logout</a></p>
<?php } ?>
<form class="form-horizontal" name="login" action="" method="post">
    <input align="right" type="submit" name="planner" value="Planner"/>
    <input class="text-center" type="submit" name="contactpersoon" value="Contactpersoon"/>
    <input class="text-center" type="submit" name="deelnemer" value="Deelnemer"/>
</form>
</body>
</html>
<?php include 'footer.html'; ?>
