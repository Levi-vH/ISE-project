<?php

include 'functions.php';

$aanvraag_id = $_GET['aanvraag_id'];

generate_header('Incompnay Aanvraag');
?>

<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-sm-4 sidebar1">
            <div class="left-navigation">
                <ul class="list">
                    <h5><strong>Aanvraag Opties</strong></h5>
                    <li>
                        <a class="active-page">Details</a>
                    </li>
                    <li>
                        <a href="participants.php?aanvraag_id=<?php echo $aanvraag_id?>">Deelnemers en Groepen</a>
                    </li>
                    <li>
                        <a href="addparticipant.php?aanvraag_id=<?php echo $aanvraag_id?>">Deelnemers toevoegen</a>
                    </li>
                </ul>
                <br>
            </div>
        </div>
        <div class="col-md-10 col-sm-8 main-content">
            <!--Main content code to be written here -->
            <h1 class="text-center">Aanvraag Details</h1>
            <h3>workshopnummer<?php echo $aanvraag_id ?></h3>
        </div>
    </div>
</body>
</html>
<?php include 'footer.html'; ?>


