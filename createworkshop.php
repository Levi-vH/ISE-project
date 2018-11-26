<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <?php include 'header.html';  ?>
</head>
<body>

<div class="container">
    <h2>Maak een nieuwe workshop</h2>
    <form class="form-horizontal" action="/createworkshop.php">
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshoptype">Type workshop:</label>
            <div class="col-sm-10">
                <select class="form-control" id="sel1">
                    <option>TYPE...</option>
                    <option>INCOMPANY</option>
                    <option>INDIVIDUEEL</option>
                    <option>LARGE ACCOUNTS</option>
                    <option>COM</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopdate">Datum workshop:</label>
            <div class="col-sm-10">
                <input type="date" class="form-control" placeholder="Enter password" name="workshopdate">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="contactinfo">Contactpersoon:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Contactpersoon gegevens" name="workshopdate">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopmodule">Module:</label>
            <div class="col-sm-10">
                <input type="radio" name="moduleoption">Module 1
                <input type="radio" name="moduleoption">Module 2
                <input type="radio" name="moduleoption">Module 3
            </div>
            <div class="col-sm-10">
                <select class="form-control" id="sel1">
                    <option>Selecteer module...</option>
                    <option>Module 1: Matching en Voorbereiding</option>
                    <option>Module 2: Begeleiding tijdens BPV</option>
                    <option>Module 3: Beoordeling</option>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopstarttime">Begintijd workshop:</label>
            <div class="col-sm-10">
                <input type="time" class="form-control" placeholder="Begintijd" name="workshopstarttime">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopendtime">Eindtijd workshop:</label>
            <div class="col-sm-10">
                <input type="time" class="form-control" placeholder="Eindtijd" name="workshopendtime">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopaddress">Adres workshop:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Adres" name="workshopaddress">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshoppostcode">Postcode workshop:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Postcode" name="workshoppostcode">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopcity">Plaats workshop:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Plaats" name="workshopcity">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopleader">Workshopleider workshop:</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" placeholder="Workshopleider" name="workshopleader">
            </div>
        </div>
        <div class="form-group">
            <label class="control-label col-sm-2" for="workshopnotes">Opmerkingen workshop:</label>
            <div class="col-sm-10">
                <input type="txt" class="form-control" placeholder="Opmerkingen" name="workshopnotes">
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <div class="checkbox">
                    <label><input type="checkbox" name="remember"> Remember me</label>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" class="btn btn-default">Submit</button>
            </div>
        </div>
    </form>
</div>

</body>
<?php include 'footer.html'; ?>
</html>
