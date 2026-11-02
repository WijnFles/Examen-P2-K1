<#
  Scriptnaam:  Monitor-Uptime.ps1
  Functie   :  Dit script monitort hoe lang de machine al aan staat (minuten sinds opstarten) van de machine waarop het script
               uitgevoerd wordt. De resultaten worden weggeschreven naar een resultatenfile
               als uit te voeren SQL query (tabel Uptime).
  Auteur    :  Kyan Wossink   (opbouw gelijk aan MonitorFreeMemory van de docent)
  Versie    :  1.0
  Datum     :  2 november 2026

  Verwachte argumenten: aantal seconden (numeriek) en naam van de output file (tekst)
  Voorbeeld : .\Monitor-Uptime.ps1 20 UptimeResults.txt
#>
clear

# STAP 1: Definieer default variabelen
$seconds = 10
$ResultFile = 'UptimeResults.txt'
$MachineName = hostname

# STAP 2: Argumenten opgegeven? Dan de default vervangen
If ($args[0] -Is [int]) {$seconds = $args[0]}
If ($args[1] -Is [string]) {$ResultFile = $args[1]}

# STAP 3: Bestaat het tekstbestand al?
If (Test-Path -LiteralPath $ResultFile) {
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
  If ($answer -Eq '1') {
    # Aanvullen: nieuw INSERT-blok, want het vorige blok is afgesloten met ;
    Add-Content -path $ResultFile -value "INSERT INTO Uptime (Hostname,UptimeMinutes,Date) VALUES"
  }
  If ($answer -Eq '2') {
    Set-Content -path $ResultFile -value "DELETE FROM Uptime WHERE ID > 0;"
    Add-Content -path $ResultFile -value "INSERT INTO Uptime (Hostname,UptimeMinutes,Date) VALUES"
  }
  If ($answer -Eq '9') {
    Exit
  }
}
Else {
  Set-Content -path $ResultFile -value "DELETE FROM Uptime WHERE ID > 0;"
  Add-Content -path $ResultFile -value "INSERT INTO Uptime (Hostname,UptimeMinutes,Date) VALUES"
}

# STAP 4: Bepaal de stoptijd
$stopAt = (Get-Date).AddSeconds($seconds)

# STAP 5: Scherm leeg + melding wat er gaat gebeuren
clear
$LineOut = "Checking hoe lang de machine al aan staat (minuten sinds opstarten) on $MachineName for $seconds seconds"
Write-Host $LineOut
Write-Host ("=" * $LineOut.Length)

# STAP 6: Zolang de stoptijd niet bereikt is: meten, wegschrijven, tonen, iets bewegends
while ((Get-Date) -Lt $stopAt) {
  $boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
  $Value = [math]::Round(((Get-Date) - $boot).TotalMinutes)                # minuten
  $TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
  $NewLine = "('$MachineName',$Value,$TimeStamp),"
  Add-Content -Path $ResultFile -Value $NewLine
  Write-Host "Uptime at $(Get-Date): $Value minutes"

  Write-Host -NoNewline "> Next check in 3`r"; Wait-Event -TimeOut 1
  Write-Host -NoNewline "> Next check in 2`r"; Wait-Event -TimeOut 1
  Write-Host -NoNewline "> Next check in 1`r"; Wait-Event -TimeOut 1
}

# (extra) Laatste komma vervangen door ; zodat de SQL direct uitvoerbaar is
$lines = @(Get-Content -Path $ResultFile)
$lines[-1] = $lines[-1].TrimEnd(',') + ';'
Set-Content -Path $ResultFile -Value $lines

# STAP 7: Scherm leeg + waar staat het bestand
clear
Write-Host -NoNewline "Monitoring process is done. Results can be found in "
Write-Host -ForegroundColor Green "$pwd\$ResultFile"

# STAP 8: Bestand openen? Net zolang vragen tot y of n
$answer = Read-Host -Prompt "`nDo you want to open it (y/n)?"
While (($answer -ne "y") -And ($answer -ne "n")) {
  $answer = Read-Host -Prompt "Please make your choice (y/n)"
}
If ($answer -Eq 'y') {Invoke-Item $ResultFile}
Else {Write-Host "OK, the file will not be opened."}

# STAP 9: Klaar + tijd
Write-Host "================================"
Write-Host "Script finished at $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')"
