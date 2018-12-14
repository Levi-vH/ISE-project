<?php

include 'functions.php';

generate_header('Incompany aanvraag');

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    pre_r($_POST);
    //Try to make connection
    $conn = connectToDB();
    if(isset($_POST["Organisation_Name"])) {
        $Organisation_grant = check_input($_POST["Organisation_Name"]);

        $sql = "exec SP_grant_large_account ?";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(1, $Organisation_grant, PDO::PARAM_INT);
        $stmt->execute();
    }
    if(isset($_POST["Organisation_Name2"])){
        $Organisation_ungrant = check_input($_POST["Organisation_Name2"]);

        $sql2 = "exec SP_ungrant_large_account ?";
        $stmt2 = $conn->prepare($sql2);
        $stmt2->bindParam(1, $Organisation_ungrant, PDO::PARAM_INT);
        $stmt2->execute();
    }
}

?>

<body>


<div class="container">
    <h1 class="text-info text-center">Large accounts</h1>
        <form class="form-horizontal" action="" method="post">
            <div class="form-group">
                <label class="control-label col-sm-2" for="Organisation_Name">Ongemachtigd:</label>
                <div class="col-sm-10">
                    <?php
                    echo selectBox("Organisation_Name", "Organisatie", array("Organisatienaam"), "Organisatienaam", array("Organisatienaam"), "Organisatienaam", "","LARGE_ACCOUNTS = 0");
                    ?>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-5 col-sm-10">
                    <button type="submit" class="btn btn-success btn-lg">Machtig</button>
                </div>
            </div>
        </form>

    <form class="form-horizontal" action="" method="post">
        <div class="form-group">
            <label class="control-label col-sm-2" for="Organisation_Name">Gemachtigd:</label>
            <div class="col-sm-10">
                <?php
                echo selectBox("Organisation_Name2", "Organisatie", array("Organisatienaam"), "Organisatienaam", array("Organisatienaam"), "Organisatienaam", "","LARGE_ACCOUNTS = 1");
                ?>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-5 col-sm-10">
                <button type="submit" class="btn btn-danger btn-lg">Onmachtig</button>
            </div>
        </div>
    </form>
</div>
</body>