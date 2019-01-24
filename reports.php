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
                        <a class="active-page">Overzicht</a>
                    </li>
                    <li>
                        <a href="workshoptypes_info.php">Verhouding workshoptypes</a>
                    </li>
                    <li>
                        <a href="other_reports.php">Overige rapportages</a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="container">
            <h1 class="headcenter">Overzicht rapportages</h1>
            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <h3 class="text-primary">Algemene informatie</h3>
                    <ul class="list-group">
                        <li class="list-group-item-action">Totaal aantal workshops: <?= getCountOfAllWorkshops() ?> </li>
                        <li class="list-group-item-action">Totaal aantal geannuleerde workshops: <?= getCountOfCancelledWorkshops() ?></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.php'; ?>





