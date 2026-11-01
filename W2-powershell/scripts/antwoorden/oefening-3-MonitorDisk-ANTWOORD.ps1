<#
  Scriptnaam:  MonitorDisk.ps1   (MOEILIJKERE VARIANT)
  Functie   :  Monitort de vrije schijfruimte van een schijf gedurende een aantal seconden.
               Schrijft elke meting als SQL weg, houdt laagste/hoogste/gemiddelde bij
               en sluit de SQL netjes af met een puntkomma.
  Auteur    :  Kyan Wossink
  Versie    :  1.0
  Datum     :  2 november 2026

  Verwachte argumenten: aantal seconden (numeriek), naam van de output file (tekst), schijfletter (tekst)
  Voorbeeld : .\MonitorDisk.ps1 20 Disk.txt D:
#>
Clear-Host

# Functie: schrijf een regel weg naar het resultatenbestand
function Write-Result {
  param([string]$Line)
  Add-Content -Path $ResultFile -Value $Line
}

# Vul vier variabelen met een default waarde: aantal seconden, naam tekstbestand, hostname, schijf
$seconds     = 10
$ResultFile  = 'DiskResults.txt'
$MachineName = $env:COMPUTERNAME
$Drive       = 'C:'

# Controleer de argumenten. Het aantal seconden moet een getal tussen 1 en 3600 zijn.
If (($args[0] -Is [int]) -And ($args[0] -ge 1) -And ($args[0] -le 3600)) {$seconds = $args[0]}
If ($args[1] -Is [string]) {$ResultFile = $args[1]}
If ($args[2] -Is [string]) {$Drive = $args[2]}

# Controleer of het tekstbestand al bestaat
If (Test-Path -LiteralPath $ResultFile) {
  Write-Host "$ResultFile already exists. What do you want to do?" -ForegroundColor Yellow
  Write-Host "[1] Add the results to this file"
  Write-Host "[2] Delete it and start with an empty one"
  Write-Host "[9] Quit"

  # Vraag net zolang tot een correct antwoord is ingevoerd
  do {
    $answer = Read-Host -Prompt "Please make your choice"
  } until ($answer -in '1', '2', '9')

  switch ($answer) {
    '1' {
      # Aanvullen: het vorige blok is afgesloten met ; dus begin een nieuw INSERT-blok
      Write-Result "INSERT INTO DiskUsage (Hostname,Drive,FreeGB,Date) VALUES"
    }
    '2' {
      Set-Content -Path $ResultFile -Value "DELETE FROM DiskUsage WHERE ID > 0;"
      Write-Result "INSERT INTO DiskUsage (Hostname,Drive,FreeGB,Date) VALUES"
    }
    '9' {
      Write-Host "Script stopped by user."
      Exit
    }
  }
}
Else {
  Set-Content -Path $ResultFile -Value "DELETE FROM DiskUsage WHERE ID > 0;"
  Write-Result "INSERT INTO DiskUsage (Hostname,Drive,FreeGB,Date) VALUES"
}

# Bepaal de starttijd en de stoptijd
$startAt = Get-Date
$stopAt  = $startAt.AddSeconds($seconds)

# Variabelen voor de statistiek
$count   = 0
$total   = 0
$lowest  = [double]::MaxValue
$highest = 0

Clear-Host
$LineOut = "Checking free disk space on $Drive ($MachineName) for $seconds seconds"
Write-Host $LineOut -ForegroundColor Cyan
Write-Host ("-" * $LineOut.Length)

# Zolang de stoptijd nog niet bereikt is
while ((Get-Date) -lt $stopAt) {
  # Haal de vrije ruimte op en reken om naar GB (2 decimalen)
  $disk   = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$Drive'"
  $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
  $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

  # Wegschrijven (tekst en datum tussen quotes, getal zonder quotes)
  Write-Result "('$MachineName','$Drive',$freeGB,'$TimeStamp'),"

  # Statistiek bijhouden
  $count++
  $total += $freeGB
  if ($freeGB -lt $lowest)  { $lowest  = $freeGB }
  if ($freeGB -gt $highest) { $highest = $freeGB }

  # Tonen, met waarschuwing onder de 10 GB
  if ($freeGB -lt 10) {
    Write-Host "$TimeStamp  free: $freeGB GB  WARNING: low disk space!" -ForegroundColor Red
  }
  else {
    Write-Host "$TimeStamp  free: $freeGB GB"
  }

  # Iets bewegends: drie puntjes
  for ($i = 1; $i -le 3; $i++) {
    Write-Host -NoNewline "."
    Start-Sleep -Seconds 1
  }
  Write-Host ""
}

# SQL netjes afsluiten: laatste komma wordt een puntkomma
$lines = @(Get-Content -Path $ResultFile)
$lines[-1] = $lines[-1].TrimEnd(',') + ';'
Set-Content -Path $ResultFile -Value $lines

# Gemiddelde berekenen (niet delen door 0!)
if ($count -gt 0) { $average = [math]::Round($total / $count, 2) } else { $average = 0 }

Clear-Host
Write-Host "Done. $count measurements saved in: $((Resolve-Path $ResultFile).Path)" -ForegroundColor Green
Write-Host "Lowest : $lowest GB"
Write-Host "Highest: $highest GB"
Write-Host "Average: $average GB"

# Vraag net zolang tot y of n is ingevoerd
do {
  $answer = Read-Host "`nDo you want to open it (y/n)?"
} until ($answer -in 'y', 'n')

if ($answer -eq 'y') { Invoke-Item $ResultFile }
else { Write-Host "OK, the file will not be opened." }

$duration = [math]::Round(((Get-Date) - $startAt).TotalSeconds)
Write-Host ("=" * 40)
Write-Host "Script finished at $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss') (ran $duration seconds)"
