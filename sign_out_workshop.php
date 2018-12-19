<?php
include 'functions.php';
generate_header('Afmelden');

$workshop_id = $_GET['workshop_id'];


?>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-sm-4 sidebar1">
            <div class="left-navigation">
                <ul class="list">
                    <h5><strong>Workshop Opties</strong></h5>
                    <li>
                        <a href="workshop_participant.php?workshop_id=<?= $workshop_id ?>">Overzicht</a>
                    </li>
                    <li>
                        <a class="active-page">Afmelden voor workshop</a>
                    </li>
                </ul>
            </div>
        </div>
        <div>
            <h1 class="text-center">Afmelden</h1>
            <form method="POST">
                <label>Type uw afmeldcode in</label>
                <input type="text" name="sign_out_code" required/>
                <button type="submit" onclick="alert('Weet u zeker dat u zich wilt afmelden voor deze workshop?')">Meld af</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.html'; ?>


