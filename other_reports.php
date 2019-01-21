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
            <h2>Kies hieronder een optie om het aantal workshops te zien</h2>
            <form method="POST">
                <label>Selecteer een sector</label>
                <?php
                echo selectBox("workshopsector", "sector", array("sectornaam"), "sectornaam", array("sectornaam"), "sectornaam");
                ?>
                <button type="submit">Submit</button>
            </form>
            <form method="POST">
                <label>Selecteer een workshopleider</label>
                <?php
                echo selectBox("workshopleader", "workshopleider", array("achternaam", "voornaam", "workshopleider_id"), "workshopleider_id", array("achternaam", "voornaam"), "achternaam, voornaam");
                ?>
                <button type="submit">Submit</button>
            </form>
            <form method="POST">
                <label>Selecteer een Organisatie</label>
                <?php
                echo selectBox("Organisation_Name", "Organisatie", array("Organisatienaam", "ORGANISATIENUMMER"), "ORGANISATIENUMMER", array("Organisatienaam"), "Organisatienaam");
                ?>
                <button type="submit">Submit</button>
            </form>
            <?php
            if (isset($_POST['workshopsector'])) {
                $sectorname = $_POST["workshopsector"];
                echo '<p>Aantal workshops voor sector <b>' . strtoupper($sectorname) . '</b>: <i>' . getCountOfWorkshopsForSector($sectorname) . '</i> van de '.getCountOfAllWorkshops().'</p>';
            } elseif (isset($_POST['workshopleader'])) {
                $workshopleader = $_POST['workshopleader'];
                echo '<p>Aantal workshops van workshopleider <b>' . getWorkshopleaderName($workshopleader)['voornaam'] . " " . getWorkshopleaderName($workshopleader)['achternaam'].'</b>: ' . getCountOfWorkshopsForWorkshopLeader($workshopleader) . '</p>';
            } elseif (isset($_POST['Organisation_Name'])) {
                $organisation = $_POST['Organisation_Name'];
                echo '<p>Aantal workshops van Organisatie <b>'. getOrganisationName($organisation) .'</b>: ' . getCountOfWorkshopsFromOrganisation($organisation) . '</p>';
            }
            ?>
        </div>
    </div>
</div>
</body>
</html>
<?php include 'footer.php'; ?>






