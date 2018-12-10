<?php include 'header.php'; ?>
<!DOCTYPE html>
<html>
<title>Bètadi</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
      integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
        integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"
        integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
        crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css"
      integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">


<head>
    <title>HOMEPAGINA</title>
</head>

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
    $_SESSION['username'] = '';
    header('Location:  ' . $_SERVER['PHP_SELF']);
}

if (isset($_POST['planner'])) {
    $_SESSION['username'] = 'planner';
    header("Refresh:0");
} elseif (isset($_POST['contactpersoon'])) {
    $_SESSION['username'] = 'contactpersoon';
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
</form>
</body>
</html>
<?php include 'footer.html'; ?>
