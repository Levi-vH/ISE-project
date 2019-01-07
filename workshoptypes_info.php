<?php
include 'functions.php';

function percentageOf($number, $everything, $decimals = 2)
{
    return round($number / $everything * 100, $decimals);
}

$numbers = array();

for ($i = 0; $i < sizeof(getCountOfTypeWorkshops()); $i++) {
    $numbers[$i] = getCountOfTypeWorkshops()[$i]['AANTAL'];
}

$everything = array_sum($numbers);

generate_header('Workshop overzicht voor sector');
?>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 col-sm-4 sidebar1">
            <div class="left-navigation">
                <ul class="list">
                    <h5><strong>Rapportages</strong></h5>
                    <li>
                        <a href="reports.php">Overzicht</a>
                    </li>
                    <li>
                        <a class="active-page">Verhouding workshoptypes</a>
                    </li>
                    <li>
                        <a href="other_reports.php">Overige rapportages</a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="container">
            <div>
                <script>
                    // dataPointss = [];
                    // for (var i = 0; i < 4; i++) {
                    //     dataPointss.y = i;
                    //     dataPointss.label = "";
                    // }
                    // console.log(dataPointss[0].y);
                    // console.log(dataPointss.length);
                    window.onload = function () {
                        var chart = new CanvasJS.Chart("chartContainer", {
                                theme: "light1", // "light1", "light2", "dark1", "dark2"
                                exportEnabled: true,
                                animationEnabled: true,
                                text: "HEEEEEEEEEY",
                                title: {
                                    text: "Verhouding workshoptypes"
                                },
                                data: [{
                                    type: "pie",
                                    startAngle: 25,
                                    toolTipContent: "<b>{label}</b>: {y}%",
                                    showInLegend: "true",
                                    legendText: "{label}",
                                    indexLabelFontSize: 16,
                                    indexLabel: "{label} - {y}%",
                                    dataPoints: [
                                        {
                                            y: <?= percentageOf($numbers[0], $everything) ?>,
                                            label: "<?= getCountOfTypeWorkshops()[0]['TYPE'] ?>"
                                        },
                                        {
                                            y: <?= percentageOf($numbers[1], $everything) ?>,
                                            label: "<?= getCountOfTypeWorkshops()[1]['TYPE'] ?>"
                                        },
                                        {
                                            y: <?= percentageOf($numbers[2], $everything) ?>,
                                            label: "<?= getCountOfTypeWorkshops()[2]['TYPE'] ?>"
                                        },
                                        {
                                            y: <?= percentageOf($numbers[3], $everything) ?>,
                                            label: "<?= getCountOfTypeWorkshops()[3]['TYPE'] ?>"
                                        },
                                    ]
                                }]
                            }
                        );
                        chart.render();
                    }
                </script>
                <div id="chartContainer" style="height: 370px; width: 100%; float: left;"></div>
                <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
                <?php
                for($i = -1; $i < sizeof(getCountOfTypeWorkshops(), $i++);) {
                    echo '<p class="alert-heading"> Aantal '.getCountOfTypeWorkshops()[$i]['TYPE'].' workshops: '.getCountOfTypeWorkshops()[$i]['AANTAL'];
                }
                ?>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.html'; ?>






