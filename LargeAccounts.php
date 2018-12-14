<?php

include 'functions.php';

generate_header('Incompany aanvraag');

?>

<body>


<div class="container">
    <h1 class="text-info text-center">Large accounts</h1>
        <form class="form-horizontal" action="" method="post">
            <div class="form-group">
                <label class="control-label col-sm-2" for="Organisation_Name">Naam Organisatie:</label>
                <div class="col-sm-10">
                    <?php
                    echo selectBox("Organisation_Name", "Organisatie", array("Organisatienaam"), "Organisatienaam", array("Organisatienaam"), "Organisatienaam");
                    ?>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-5 col-sm-10">
                    <button type="submit" class="btn btn-success btn-lg">Machtig</button>
                </div>
            </div>
        </form>
</div>

</body>

