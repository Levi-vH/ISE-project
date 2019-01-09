<?php

use PhpOffice\PhpSpreadsheet\Spreadsheet;

require_once('PhpSpreadsheet/samples/Header.php');

$spreadsheet = new Spreadsheet();
$helper->log('Create new Spreadsheet object');

// Set document properties
$helper->log('Set document properties');
$spreadsheet->getProperties()
    ->setCreator('ISE projectgroep B2')
    ->setLastModifiedBy('ISE Projectgroep B2')
    ->setTitle('PhpSpreadsheet Test Document')
    ->setSubject('PhpSpreadsheet Test Document')
    ->setDescription('Test document for PhpSpreadsheet, generated using PHP classes.')
    ->setKeywords('office PhpSpreadsheet php')
    ->setCategory('Test result file');

function connectToDB()
{
    $hostnaam = '(local)';
    $dbnaam = 'SBBWorkshopOmgeving';
    $username = 'iseprojectuser';
    $wachtwoord = 'iseprojectww';

    try {
        $handler = new PDO("sqlsrv:Server=$hostnaam; Database=$dbnaam; ConnectionPooling=0", "$username", "$wachtwoord");

        $handler->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    } catch (PDOException $e) {
        echo "Er ging iets mis met de database.<br>";
        echo "De melding is {$e->getMessage()}<br><br>";
    }
    return $handler;
}


//Try to make connection
$conn = connectToDB();

//Run the stored procedure
$sql = "EXEC SP_get_workshops";
$stmt = $conn->prepare($sql);
$stmt->execute();


$nummer = 1;
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $nummer++;
    $spreadsheet->setActiveSheetIndex(0)
        ->setCellValue('A1', 'Workshop_ID')
        ->setCellValue('B1', 'Workshop_TYPE')
        ->setCellValue('C1', 'Module')
        ->setCellValue('D1', 'Datum')
        ->setCellValue('E1', 'Adviseurnaam')
        ->setCellValue('F1', 'Organisatie')
        ->setCellValue('A' . $nummer, $row['WORKSHOP_ID'])
        ->setCellValue('B' . $nummer, $row['TYPE'])
        ->setCellValue('C' . $nummer, $row['MODULENAAM'])
        ->setCellValue('D' . $nummer, date('j F Y', strtotime($row['DATUM'])))
        ->setCellValue('E' . $nummer, $row['ADVISEUR_VOORNAAM'] . ' ' . $row['ADVISEUR_ACHTERNAAM'])
        ->setCellValue('F' . $nummer, $row['ORGANISATIENAAM']);

}

//$spreadsheet->getActiveSheet()
//    ->setCellValue('A8', "Hello\nWorld");
//$spreadsheet->getActiveSheet()
//    ->getRowDimension(8)
//    ->setRowHeight(-1);
//$spreadsheet->getActiveSheet()
//    ->getStyle('A8')
//    ->getAlignment()
//    ->setWrapText(true);
//
//$value = "-ValueA\n-Value B\n-Value C";
//$spreadsheet->getActiveSheet()
//    ->setCellValue('A10', $value);
//$spreadsheet->getActiveSheet()
//    ->getRowDimension(10)
//    ->setRowHeight(-1);
//$spreadsheet->getActiveSheet()
//    ->getStyle('A10')
//    ->getAlignment()
//    ->setWrapText(true);
//$spreadsheet->getActiveSheet()
//    ->getStyle('A10')
//    ->setQuotePrefix(true);

// Rename worksheet
$helper->log('Rename worksheet');
$spreadsheet->getActiveSheet()
    ->setTitle('Workshop');

// Save
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $helper->write($spreadsheet, 'Workshops.xlsx');
    //$helper->writeFile($spreadsheet, 'Workshops.xlsx');

}


?>

<form action="allworkshopsexcel.php" method="post">
    <button type="submit">Download</button>
</form>





