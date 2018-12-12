<?php
if (!isset($_SESSION)) {
    session_start();
}

include 'functions.php';
generate_header('Deelnemers en Groepen');

if ($_SESSION['username'] == 'planner' or $_SESSION['username'] == 'contactpersoon') {

    $aanvraag_id = $_GET['aanvraag_id'];


    ?>
    <script type="text/javascript">
        function colorSelectedRow(row, pagina) {

            window.location.href = pagina;

            // var els = document.getElementsByClassName("groupsrow"); // Creates an HTMLObjectList not an array.
            // Array.prototype.forEach.call(els, function(el) {
            //     el.removeAttribute("style");
            // });

            // row.style.backgroundColor = "";

        }
    </script>
    <body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2 col-sm-10 sidebar1">
                <div class="left-navigation">
                    <ul class="list">
                        <h5><strong>Aanvraag Opties</strong></h5>
                        <li>
                            <a href="INCaanvraag.php?aanvraag_id=<?php echo $aanvraag_id ?>">Details</a>
                        </li>
                        <li>
                            <a class="active-page">Deelnemers en Groepen</a>
                        </li>
                        <li>
                            <a href="addparticipant.php?aanvraag_id=<?php echo $aanvraag_id ?>">Deelnemers beheren</a>
                        </li>
                    </ul>
                    <br>
                </div>
            </div>
            <div class="col-md-10 col-sm-8 main-content">
                <!--Main content code to be written here -->
                <h1>Groepen</h1>
                <table class='table table-striped table-hover'>
                    <tr>
                        <th>Nummer</th>
                        <th>Contactpersoon</th>
                        <th>Adres</th>
                        <th>Aantal deelnemers</th>
                    </tr>
                    <?php
                    //Try to make connection
                    $conn = connectToDB();

                    //Run the stored procedure
                    $sql = "exec proc_request_groups ?";
                    $stmt = $conn->prepare($sql);
                    $stmt->bindParam(1, $aanvraag_id, PDO::PARAM_INT);
                    $stmt->execute();

                    $nummer = 0;

                    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                        $nummer++;
                        $html = '';
                        $groeps_id = $row['GROEP_ID'];
                        $pagina = $_SERVER['PHP_SELF'].'?aanvraag_id='.$aanvraag_id.'&groeps_id='.$groeps_id;
                        if ($groeps_id == $_GET['groeps_id']) {
                            $html .= "<tr class='colorrow' onclick='colorSelectedRow(this, \"$pagina\")'>";
                        }else {
                            $html .= "<tr onclick='colorSelectedRow(this, \"$pagina\")'>";
                        }
                        $html .= '<td>';
                        $html .= $nummer;
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['VOORNAAM'] . ' ' . $row['ACHTERNAAM'];
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['ADRES'];
                        $html .= '</td>';
                        $html .= '<td>';
                        $html .= $row['AANTAL_DEELNEMERS'] . '/16';
                        $html .= '</td>';
                        $html .= '</tr>';

                        echo $html;

                    }
                    if (isset($_GET['deleteUser'])) {
                        deleteUserAanvraag($aanvraag_id, $_GET['participant_id']);
                        updatePage($_SERVER['PHP_SELF'] . '?aanvraag_id='.$aanvraag_id.'&groeps_id=' . $_GET['groeps_id']);
                    }

                    ?>
                </table>
                <h1 class="participantsheader">Deelnemers zonder groep</h1>
                <h1 class="participantsheader">Deelnemers in groep</h1>
                <p class="alert-danger warning">Let op! elke deelnemer moet aan een groep zijn toegevoegd</p>
                <div>
                    <table class='table table-striped table-hover participantstable'>
                        <tr class="small">
                            <th>Naam</th>
                            <th>Geboortedatum</th>
                            <th>Opleidingsniveau</th>
                            <th>Toevoegen</th>
                        </tr>
                        <?php
                        //Try to make connection
                        $conn = connectToDB();

                        //Run the stored procedure
                        $sql = "exec proc_request_deelnemers_in_aanvraag_not_in_groep ?";
                        $stmt = $conn->prepare($sql);
                        $stmt->bindParam(1, $aanvraag_id, PDO::PARAM_INT);
                        $stmt->execute();

                        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                            $html = '';
                            $html .= "<tr class='small'>";
                            $html .= '<td>';
                            $html .= $row['VOORNAAM'] . ' ' . $row['ACHTERNAAM'];
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= $row['GEBOORTEDATUM'];
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= $row['OPLEIDINGSNIVEAU'];
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= '<a class="fas fa-check" id="approvebutton" onclick="return confirm(\'Weet je zeker dat je deze persoon wilt toevoegen?\')" href="participants.php?aanvraag_id='.$aanvraag_id.'&groeps_id='.$_GET['groeps_id'].'&participant_id='.$row['DEELNEMER_ID'].'&addUserToGroup=true"></a>';
                            $html .= '</td>';
                            $html .= '</tr>';

                            echo $html;

                        }
                        if (isset($_GET['addUserToGroup'])) {
                            addUserToGroup($aanvraag_id, $_GET['groeps_id'], $_GET['participant_id']);
                            updatePage($_SERVER['PHP_SELF'] . '?aanvraag_id='.$aanvraag_id.'&groeps_id='.$_GET['groeps_id']);
                        }

                        ?>
                    </table>
                    <table class='table table-striped table-hover participantstable'>
                        <tr class="small">
                            <th>Naam</th>
                            <th>Geboortedatum</th>
                            <th>Opleidingsniveau</th>
                            <th>Verwijderen</th>
                        </tr>
                        <?php
                        //Try to make connection
                        $conn = connectToDB();

                        //Run the stored procedure
                        $sql = "exec proc_request_deelnemers_van_groep ?, ?";
                        $stmt = $conn->prepare($sql);
                        $stmt->bindParam(1, $aanvraag_id, PDO::PARAM_INT);
                        $stmt->bindParam(2, $_GET['groeps_id'], PDO::PARAM_INT);

                        $stmt->execute();

                        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                            $html = '';
                            $html .= "<tr class='small col-sm-6'>";
                            $html .= '<td>';
                            $html .= $row['VOORNAAM'] . ' ' . $row['ACHTERNAAM'];
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= $row['GEBOORTEDATUM'];
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= $row['OPLEIDINGSNIVEAU'];
                            $html .= '</td>';
                            $html .= '<td>';
                            $html .= '<a class="fas fa-times" id="denybutton" onclick="return confirm(\'Weet je zeker dat je deze persoon uit de groep wilt verwijderen? Zijn of haar gegevens worden niet opgeslagen\')" href="participants.php?aanvraag_id='.$aanvraag_id.'&groeps_id='.$_GET['groeps_id'].'&participant_id='.$row['DEELNEMER_ID'].'&deleteUserFromGroup=true"></a>';
                            $html .= '</td>';
                            $html .= '</tr>';

                            echo $html;

                        }
                        if (isset($_GET['deleteUserFromGroup'])) {
                            deleteUserFromGroup($aanvraag_id, $_GET['groeps_id'], $_GET['participant_id']);
                            updatePage($_SERVER['PHP_SELF'] . '?aanvraag_id='.$aanvraag_id.'&groeps_id='.$_GET['groeps_id']);
                        }

                        ?>
                    </table>
                </div>
            </div>
        </div>
    </div>
    </body>
    </html>
<?php } else {
    echo '<h1> U mag deze pagina niet bezoeken</h1>';
}


