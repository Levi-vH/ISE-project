<?php
include 'functions.php';
generate_header('Afmelden');

$workshop_id = $_GET['workshop_id'];
if(isset($_POST['resign'])){
    $conn = connectToDB();

    $sqlGetCode = "EXEC SP_get_participant_code ?";
    $stmtGetCode = $conn->prepare($sqlGetCode);
    $stmtGetCode->bindParam(1,$_SESSION['deelnemer_id'], PDO::PARAM_INT);
    $stmtGetCode->execute();

    $sql = "EXEC SP_disapprove_participant_of_workshop ?, ?";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(1,$workshop_id, PDO::PARAM_INT);
    $stmt->bindParam(2,$_SESSION['deelnemer_id'], PDO::PARAM_INT);
    $stmt->execute();
    $_SESSION['message'] = 'U bent succesvol uitgeschreven voor deze workshop';
    header("refresh:0;url=signed_up_workshops.php");
}


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
                <input type="submit" name="resign" value="Meld af">
            </form>
        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.php'; ?>


