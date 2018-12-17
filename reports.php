<?php
include 'functions.php';

generate_header('Workshop overzicht voor sector');
?>

<div class="container">
    <h2 class="text-info text-center">Overzicht workshops</h2>
    <div>
        <form method="POST">
            <label>Type uw sector in</label>
            <input type="text" name="sector"/>
            <button type="submit">Submit</button>
        </form>
        <?php
        ?>
        <?php

        if (isset($_POST['sector'])) {
            $sectorname = $_POST["sector"];

            //Try to make connection
            $conn = connectToDB();

            //Run the stored procedure
            // $sql = "SELECT * FROM VW_WORKSHOPS";
            $sql = "EXEC SP_get_workshops_for_sector ?";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(1, $sectorname, PDO::PARAM_STR);
            $stmt->execute();

            $nummer = 0;

            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $nummer++;
            }

            echo '<p>Aantal workshops voor sector ' . $nummer . '</p>';

        }
        ?>
    </div>
</div>
</body>
<?php include 'footer.html'; ?>
</html>