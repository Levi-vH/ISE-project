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
                        <a href="workshoptypes_info.php">Verhouding workshoptypes</a>
                    </li>
                    <li>
                        <a class="active-page">Overige rapportages</a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="container">
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
            ?>
        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.html'; ?>






