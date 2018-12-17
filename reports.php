<?php
include 'functions.php';

generate_header('Workshop overzicht voor sector');
?>

    <div class="container">
        <h2 class="text-info text-center">Rapportages</h2>
        <div>
            <form method="POST">
                <label>Type uw sector in</label>
                <input type="text" name="sector"/>
                <button type="submit">Submit</button>
            </form>
            <form method="POST">
                <label>Druk op de knop voor geannuleerde workshops</label>
                <button type="submit" name="cancelled">Submit</button>
            </form>
            <form method="POST">
                <label>Type een workshopleider in</label>
                <input type="text" name="workshopleader"/>
                <button type="submit">Submit</button>
            </form>
            <?php
            if (isset($_POST['sector'])) {
                $sectorname = $_POST["sector"];
                echo '<p>Aantal workshops voor sector ' . strtoupper($sectorname) . ': ' . getCountOfWorkshopsForSector($sectorname) . '</p>';
            } elseif (isset($_POST['cancelled'])) {
                $cancelled = getCountOfCancelledWorkshops();
                echo '<p>Aantal geannuleerde workshops: ' . $cancelled . '</p>';
            } elseif (isset($_POST['workshopleader'])) {
                $workshopleader = $_POST['workshopleader'];
                echo '<p>Aantal workshops van workshopleider ' . $workshopleader . ': ' . getCountOfWorkshopsForWorkshopLeader($workshopleader) . '</p>';

            }

            pre_r(getCountOfTypeWorkshops());


            ?>
        </div>
    </div>
<div>
    <script>
        <?php $dataPoints = array(
                foreach(getCountOfTypeWorkshops() as $row ) {
                    array("label" => "Chrome", "y" => 64.02),
            array("label" => "Firefox", "y" => 12.55),
            array("label" => "IE", "y" => 8.47),
            array("label" => "Safari", "y" => 6.08),
            array("label" => "Edge", "y" => 4.29),
            array("label" => "Others", "y" => 4.59)
                }
        )

        ?>
        window.onload = function () {


            var chart = new CanvasJS.Chart("chartContainer", {
                animationEnabled: true,
                title: {
                    text: "Verhouding type workshops"
                },
                subtitles: [{
                    text: "All time"
                }],
                data: [{
                    type: "pie",
                    yValueFormatString: "#,##0.00\"%\"",
                    indexLabel: "{label} ({y})",
                    dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
                }]
            });
            chart.render();

        }
    </script>
    <div id="chartContainer" style="height: 370px; width: 100%;"></div>
    <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
    </body>
</div>
<?php include 'footer.html'; ?>
</html>






