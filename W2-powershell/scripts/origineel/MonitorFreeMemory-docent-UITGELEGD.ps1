<#
  =====================================================================
  HET SCRIPT VAN DE DOCENT - MET UITLEG BIJ ELKE REGEL
  =====================================================================
  Dit is precies hetzelfde script als MonitorFreeMemory-docent.ps1,
  maar onder elke regel staat in gewone taal wat die regel doet.

  Alles wat begint met #  is COMMENTAAR. PowerShell slaat dat over.
  Alles tussen <#  en  #> is ook commentaar (meerdere regels).

  Het script kun je gewoon uitvoeren, de uitleg stoort niet.
  =====================================================================

  Scriptnaam:  MonitorFreeMemory.ps1
  Functie   :  Dit script monitort het vrije geheugen van de machine waarop het script uitgevoerd wordt.
               De resultaten worden weggeschreven naar een resultatenfile als uit te voeren SQL query.
  Auteur    :  Olaf Ritman
  Versie    :  1.0
  Datum     :  12 oktober 2022

  Verwachte argumenten: aantal seconden (numeriek) en naam van de output file (tekst)
#>

clear
# "clear" = Clear-Host = maak het scherm leeg.

# ---------------------------------------------------------------------
# STAP 1 (flowchart): Definieer default variabelen
# ---------------------------------------------------------------------
$seconds = 5
# Maak een variabele (een "doosje") met de naam $seconds en stop er het getal 5 in.
# Een variabele begint ALTIJD met een $ teken.

$ResultFile = 'Results.txt'
# Variabele $ResultFile krijgt de TEKST 'Results.txt'. Tekst staat altijd tussen quotes.

$MachineName = hostname
# "hostname" is een programma dat de naam van de computer teruggeeft (bijv. SRV01).
# Die naam gaat in $MachineName. Alternatief: $MachineName = $env:COMPUTERNAME

# ---------------------------------------------------------------------
# STAP 2: Heeft de gebruiker argumenten opgegeven? Zo ja: vervang de default
# ---------------------------------------------------------------------
# Argumenten = wat je achter de scriptnaam typt bij het starten:
#     .\MonitorFreeMemory.ps1 30 Meting.txt
#     $args[0] = 30           (het eerste argument, tellen begint bij 0!)
#     $args[1] = 'Meting.txt' (het tweede argument)

If ($args[0] -Is [int]) {$seconds = $args[0]}
# ALS het eerste argument een geheel getal (int) is, DAN wordt $seconds dat getal.
# Geen argument opgegeven? Dan is $args[0] leeg, dus geen int, en blijft $seconds 5.

If ($args[1] -Is [string]) {$ResultFile = $args[1]}
# ALS het tweede argument tekst (string) is, DAN wordt dat de nieuwe bestandsnaam.

# ---------------------------------------------------------------------
# STAP 3: Bestaat het resultatenbestand al?
# ---------------------------------------------------------------------
If (Test-Path -LiteralPath $ResultFile) {
# Test-Path geeft $true als het bestand bestaat, $false als het niet bestaat.
# Dus: ALS het bestand al bestaat, voer dan alles tussen deze { } uit.

  Write-Host -ForegroundColor Red "WARNING: " -NoNewline
  # Write-Host = toon tekst op het scherm. -ForegroundColor Red = in rode letters.
  # -NoNewline = blijf op dezelfde regel (de volgende tekst komt erachter).

  Write-Host "$ResultFile already exists. What do you want to do?"
  # Tussen DUBBELE quotes wordt $ResultFile vervangen door de inhoud, bijv. "Results.txt already exists..."

  Write-Host "[1] Add the results to this file"
  Write-Host "[2] Delete it and start with an empty one"
  Write-Host "[9] Quit"
  # Het menu tonen: drie opties.

  $answer = Read-Host -Prompt "Please make your choice"
  # Read-Host = VRAAG iets aan de gebruiker. Wat hij typt komt in $answer.

  While (($answer -ne "1") -And ($answer -ne "2") -And ($answer -ne "9")) {
    $answer = Read-Host -Prompt "Please make your choice"
  }
  # INVOERLUS: ZOLANG het antwoord NIET 1 EN NIET 2 EN NIET 9 is: vraag opnieuw.
  # -ne = not equal (is niet gelijk aan).  -And = en.
  # Pas als er 1, 2 of 9 is getypt gaat het script verder.

  If ($answer -Eq '2') {
  # ALS het antwoord 2 is (overschrijven):   -Eq = equal (is gelijk aan)
    Set-Content -path $ResultFile -value "DELETE FROM MemoryUsage WHERE ID > 0;"
    # Set-Content = schrijf naar bestand en GOOI de oude inhoud WEG (overschrijven).
    Add-Content -path $ResultFile -value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"
    # Add-Content = voeg een regel ONDERAAN toe (bestaande inhoud blijft staan).
  }
  If ($answer -Eq '9') {
  # ALS het antwoord 9 is (stoppen):
    Exit
    # Exit = stop het script direct.
  }
  # Antwoord 1 (aanvullen)? Dan gebeurt er hier niets extra's. Het script gaat gewoon
  # verder en de nieuwe metingen worden later onderaan het bestaande bestand toegevoegd.
}
Else {
# ANDERS (het bestand bestaat NIET):
  Set-Content -path $ResultFile -value "DELETE FROM MemoryUsage WHERE ID > 0;"
  Add-Content -path $ResultFile -value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"
  # Maak een nieuw bestand en schrijf de eerste twee regels weg.
}

# ---------------------------------------------------------------------
# STAP 4: Bepaal de stoptijd en zet die in een variabele
# ---------------------------------------------------------------------
$aantalSeconden = New-timespan -seconds $seconds
# New-TimeSpan maakt een "tijdsduur" van $seconds seconden.

$startAt = Get-Date
# Get-Date = de huidige datum + tijd. Die bewaren we als starttijd.

$stopAt = (Get-Date) + $aantalSeconden
# Stoptijd = nu + de tijdsduur.
# Korter alternatief (doet hetzelfde):  $stopAt = (Get-Date).AddSeconds($seconds)

# ---------------------------------------------------------------------
# STAP 5: Maak het scherm leeg en toon wat er gaat gebeuren
# ---------------------------------------------------------------------
clear
$LineOut = "Checking free virtual memory on $MachineName for $seconds seconds"
# Zet de meldingstekst in een variabele (de $-variabelen worden ingevuld).
Write-Host $LineOut
# Toon de melding.

$LengthLineOut = $LineOut.Length
# .Length = het aantal tekens van de tekst.
For($i=1;$i -le $LengthLineOut;$i++){
  Write-Host -NoNewline "="
}
# FOR-lus: tel $i van 1 tot en met de lengte van de tekst, en print elke keer een "=".
# Resultaat: een streep ====== precies zo lang als de melding.
#   $i=1          = begin bij 1
#   $i -le ...    = ga door zolang $i kleiner of gelijk (-le) is aan de lengte
#   $i++          = tel er na elke ronde 1 bij op
# Korter alternatief:  Write-Host ("=" * $LineOut.Length)

Write-Host "`r"
# `r = terug naar het begin van de regel (hier: gewoon een nieuwe regel beginnen).

# ---------------------------------------------------------------------
# STAP 6: ZOLANG de stoptijd niet bereikt is: meten, tonen, wegschrijven, iets bewegends tonen
# ---------------------------------------------------------------------
while ((Get-Date) -Lt $stopAt) {
# ZOLANG de huidige tijd KLEINER IS DAN (-Lt = less than) de stoptijd: herhaal alles tussen { }.

  $FreeMemory = Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory
  # Vraag aan Windows informatie over het besturingssysteem op (Win32_OperatingSystem)
  # en pak daaruit alleen (Select) het vrije fysieke geheugen. Dat is in KB.
  # Het | teken (pipe) = "geef het resultaat door aan het volgende commando".

  ForEach ($entry in $FreeMemory){
  # Voor elk resultaat (hier is er maar 1) doe het volgende:

    $TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
    # Huidige tijd als tekst in de vorm 20221013141903 (jaar maand dag uur minuut seconde).
    # MySQL snapt dit als datum+tijd.

    $MemValue = $entry.FreePhysicalMemory
    # Het getal (vrij geheugen in KB) uit het resultaat halen.

    $NewLine = "('$MachineName',$MemValue,$TimeStamp),"
    # De SQL-regel samenstellen, bijv:  ('SRV01',4543524,20221013141903),

    Add-Content -Path $ResultFile -Value $NewLine
    # De regel ONDERAAN het bestand toevoegen = wegschrijven naar het tekstbestand.

    $TimeStamp = Get-Date
    Write-Host "Free memory at ${TimeStamp}:" $entry.FreePhysicalMemory
    # Op het scherm tonen.  ${TimeStamp} met accolades omdat er direct een : achter staat.
  }

  # "Iets bewegends" op het scherm: aftellen 3, 2, 1 op dezelfde regel.
  Write-Host -NoNewline "> Next check in 3`r";
  Wait-Event -TimeOut 1
  # Wait-Event -TimeOut 1 = wacht 1 seconde. (Hetzelfde als Start-Sleep -Seconds 1)
  Write-Host -NoNewline "> Next check in 2`r";
  Wait-Event -TimeOut 1
  Write-Host -NoNewline "> Next check in 1`r";
  Wait-Event -TimeOut 1
  # `r zet de cursor terug naar het begin van de regel, dus de volgende tekst
  # overschrijft de vorige. Zo lijkt het alsof het getal aftelt = "bewegend".
}
# Einde van de lus. Terug naar de while-regel om opnieuw de tijd te controleren.

# ---------------------------------------------------------------------
# STAP 7: Scherm leeg en tonen waar het bestand staat
# ---------------------------------------------------------------------
clear
Write-Host -NoNewline "Monitoring process is done. Results can be found in "
Write-Host -ForegroundColor Red $pwd\$ResultFile
# $pwd = de map waar je nu in staat (print working directory).
# $pwd\$ResultFile = volledig pad, bijv. C:\Users\Administrator\Results.txt

# ---------------------------------------------------------------------
# STAP 8: Vraag of het bestand geopend moet worden, net zolang tot y of n
# ---------------------------------------------------------------------
$answer = Read-Host -Prompt "`nDo you want to open it (y/n)?";
# `n = nieuwe regel (enter).

While (($answer -ne "y") -And ($answer -ne "n")) {
  $answer = Read-Host -Prompt "Please make your choice (y/n)";
}
# INVOERLUS: zolang het antwoord niet y en niet n is: opnieuw vragen.

If ($answer -Eq 'y') {Invoke-Item $ResultFile}
# ALS het antwoord y is: open het bestand (Invoke-Item = openen met het standaardprogramma, bijv. Kladblok).
Else {Write-Host "Dan niet joh..."}
# ANDERS (dus n): een passende melding.

# ---------------------------------------------------------------------
# STAP 9: Meld dat het script klaar is, inclusief de tijd
# ---------------------------------------------------------------------
Write-Host "================================`nScript finished at", (Get-Date), "`n" ;
# Toon een streep, een nieuwe regel, en "Script finished at" + de huidige datum/tijd.
