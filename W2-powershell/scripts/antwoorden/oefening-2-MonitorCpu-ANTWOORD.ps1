<#
  Scriptnaam:  MonitorCpu.ps1
  Functie   :  Dit script monitort de CPU-belasting van de machine waarop het script uitgevoerd wordt.
               De resultaten worden weggeschreven naar een resultatenfile als uit te voeren SQL query.
  Auteur    :  Kyan Wossink
  Versie    :  1.0
  Datum     :  2 november 2026

  Verwachte argumenten: aantal seconden (numeriek) en naam van de output file (tekst)
  Voorbeeld : .\MonitorCpu.ps1 20 Cpu.txt
#>
clear

# Vul drie variabelen met een default waarde: aantal seconden, naam van het tekstbestand, hostname
$seconds = 10
$ResultFile = 'CpuResults.txt'
$MachineName = hostname

# Controleer of de gebruiker een argument heeft opgegeven voor het aantal seconden. Zo ja, vervang de default.
If ($args[0] -Is [int]) {$seconds = $args[0]}

# Controleer of de gebruiker een argument heeft opgegeven voor de naam van het tekstbestand. Zo ja, vervang de default.
If ($args[1] -Is [string]) {$ResultFile = $args[1]}

# Controleer of het tekstbestand al bestaat
If (Test-Path -LiteralPath $ResultFile) {
  # Geef de gebruiker de keuze: aanvullen, overschrijven of stoppen
  Write-Host -ForegroundColor Red "WARNING: " -NoNewline
  Write-Host "$ResultFile already exists. What do you want to do?"
  Write-Host "[1] Add the results to this file"
  Write-Host "[2] Delete it and start with an empty one"
  Write-Host "[9] Quit"

  # Vraag net zolang tot een correct antwoord is ingevoerd
  $answer = Read-Host -Prompt "Please make your choice"
  While (($answer -ne "1") -And ($answer -ne "2") -And ($answer -ne "9")) {
    $answer = Read-Host -Prompt "Please make your choice"
  }

  # Overschrijven: start een nieuw tekstbestand en schrijf de eerste regels weg
  If ($answer -Eq '2') {
    Set-Content -path $ResultFile -value "DELETE FROM CpuUsage WHERE ID > 0;"
    Add-Content -path $ResultFile -value "INSERT INTO CpuUsage (Hostname,CpuLoad,Date) VALUES"
  }
  # Stoppen: stop het script
  If ($answer -Eq '9') {
    Exit
  }
}
Else {
  # Het bestand bestaat niet: start een nieuw tekstbestand en schrijf de eerste regels weg
  Set-Content -path $ResultFile -value "DELETE FROM CpuUsage WHERE ID > 0;"
  Add-Content -path $ResultFile -value "INSERT INTO CpuUsage (Hostname,CpuLoad,Date) VALUES"
}

# Bepaal de stoptijd en zet deze in een variabele
$stopAt = (Get-Date).AddSeconds($seconds)

# Maak het scherm leeg en toon de gebruiker wat er gaat gebeuren
clear
$LineOut = "Checking CPU load on $MachineName for $seconds seconds"
Write-Host $LineOut
Write-Host ("=" * $LineOut.Length)

# Zolang de stoptijd nog niet bereikt is
while ((Get-Date) -Lt $stopAt) {
  # Check de CPU-belasting, toon op het scherm en schrijf weg naar het tekstbestand
  $CpuValue = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
  $TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
  Add-Content -Path $ResultFile -Value "('$MachineName',$CpuValue,$TimeStamp),"
  Write-Host "CPU load at $(Get-Date -Format 'HH:mm:ss'): $CpuValue %"

  # Toon de gebruiker iets 'bewegends' op het scherm
  for ($i = 3; $i -gt 0; $i--) {
    Write-Host -NoNewline "> Next check in $i`r"
    Start-Sleep -Seconds 1
  }
}

# Maak het scherm leeg en toon de gebruiker waar het tekstbestand gevonden kan worden
clear
Write-Host -NoNewline "Monitoring is done. Results can be found in "
Write-Host -ForegroundColor Green "$pwd\$ResultFile"

# Vraag of de gebruiker het bestand wil openen. Herhaal dit net zolang tot er y of n wordt ingevoerd.
do {
  $answer = Read-Host -Prompt "`nDo you want to open it (y/n)?"
} until (($answer -eq 'y') -or ($answer -eq 'n'))

# y: open het bestand / n: geef een passende melding
If ($answer -Eq 'y') {Invoke-Item $ResultFile}
Else {Write-Host "OK, the file will not be opened."}

# Meld de gebruiker dat het script klaar is, inclusief de tijd dat het script gestopt is
Write-Host "================================"
Write-Host "Script finished at $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')"
