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
            <p>
                Lorem Ipsum is slechts een proeftekst uit het drukkerij- en zetterijwezen. Lorem Ipsum is de standaard
                proeftekst in deze bedrijfstak sinds de 16e eeuw, toen een onbekende drukker een zethaak met letters nam
                en
                ze door elkaar husselde om een font-catalogus te maken. Het heeft niet alleen vijf eeuwen overleefd maar
                is
                ook, vrijwel onveranderd, overgenomen in elektronische letterzetting. Het is in de jaren '60 populair
                geworden met de introductie van Letraset vellen met Lorem Ipsum passages en meer recentelijk door
                desktop
                publishing software zoals Aldus PageMaker die versies van Lorem Ipsum bevatten.
            </p>
            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <h3 class="text-center text-primary">Algemene informatie</h3>
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
<?php include 'footer.html'; ?>





