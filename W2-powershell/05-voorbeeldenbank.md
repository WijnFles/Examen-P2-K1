# 05 · Voorbeeldenbank: alle puzzelstukjes

**Doel:** je hoeft **niets** zelf op te zoeken. Voor elke stap van het examenscript staan hier **meerdere kant-en-klare varianten**. Voor stap 6 (het meten) staat er een blok voor **elk onderwerp**: geheugen, CPU, schijf, processen, services, netwerk, ping, uptime en meer.

**Zo puzzel je:**
1. Kijk in het examenscript **welke variabelenamen** er al zijn (`$seconds`? `$ResultFile`? `$MachineName`?).
2. Zoek de **stap** (1-9) waar het gat zit.
3. Pak de variant die het **meest lijkt** op de stijl van het script (Engelse teksten? `While`? `If`?).
4. Wijzig alleen de **namen** waar nodig. **Tip:** de stukken hieronder gebruiken de namen van de docent: `$seconds`, `$ResultFile`, `$MachineName`, `$answer`, `$stopAt`.

> 📦 **Complete scripts per onderwerp** (getest, zelfde opbouw als de docent): [scripts/compleet/](scripts/compleet/)
> `Monitor-FreeMemory` · `Monitor-MemoryPercent` · `Monitor-Cpu` · `Monitor-DiskFree` · `Monitor-DiskPercent` · `Monitor-Processes` · `Monitor-Service` · `Monitor-Ping` · `Monitor-Network` · `Monitor-Uptime`

---

## Inhoud
- [Stap 1 · Default variabelen](#stap-1--default-variabelen)
- [Stap 2 · Argumenten](#stap-2--argumenten)
- [Stap 3 · Bestaat het bestand? Menu, invoerlus, keuze](#stap-3--bestaat-het-bestand-menu-invoerlus-keuze)
- [Stap 4 · Stoptijd](#stap-4--stoptijd)
- [Stap 5 · Scherm leeg + melding](#stap-5--scherm-leeg--melding)
- [Stap 6 · De lus](#stap-6--de-lus)
  - [6a · Soorten lussen](#6a--soorten-lussen)
  - [6b · ⭐ MEETBLOKKEN: geheugen, CPU, schijf, processen, …](#6b--meetblokken-wat-meet-je)
  - [6c · Iets bewegends](#6c--iets-bewegends)
  - [6d · Extra's: teller, gemiddelde, min/max, waarschuwing](#6d--extras-in-de-lus)
- [Na de lus · SQL afsluiten, statistiek](#na-de-lus)
- [Stap 7 · Waar staat het bestand?](#stap-7--waar-staat-het-bestand)
- [Stap 8 · Bestand openen (y/n)](#stap-8--bestand-openen-yn)
- [Stap 9 · Klaar + tijd](#stap-9--klaar--tijd)
- [Datum/tijd-formaten](#datumtijd-formaten)
- [W3-koppeling: CREATE TABLE per onderwerp](#w3-koppeling-create-table-per-onderwerp)
- [Alles uit de oefentoets op een rij](#alles-uit-de-oefentoets-op-een-rij)

---

## Stap 1 · Default variabelen
**A. Docent (oefentoets)**
```powershell
$seconds = 5
$ResultFile = 'Results.txt'
$MachineName = hostname
```
**B. Hostname via omgevingsvariabele (doet hetzelfde)**
```powershell
$MachineName = $env:COMPUTERNAME
```
**C. Kyan / param-stijl (moet de EERSTE code van het script zijn)**
```powershell
param(
    [ValidateRange(1, 3600)]
    [int]$Seconden = 15,
    [string]$Resultaatbestand = "Resultaten.sql"
)
```
**D. Extra variabelen die gevraagd kunnen worden**
```powershell
$Interval    = 3                      # seconden tussen twee metingen
$Threshold   = 80                     # grenswaarde (bijv. CPU 80%)
$Drive       = 'C:'                   # welke schijf
$ServiceName = 'Spooler'              # welke service
$Target      = '8.8.8.8'              # welk adres pingen
$ProcessName = 'notepad'              # welk proces
$Folder      = 'C:\Scripts'           # map voor het bestand
$UserName    = $env:USERNAME          # wie draait het script
$Count       = 0                      # teller
$StartAt     = Get-Date               # starttijd
```

## Stap 2 · Argumenten
**A. Docent: twee losse controles**
```powershell
If ($args[0] -Is [int]) {$seconds = $args[0]}
If ($args[1] -Is [string]) {$ResultFile = $args[1]}
```
**B. Zijn er twee argumenten?**
```powershell
If ($args.Count -ge 2) {
  $seconds = $args[0]
  $ResultFile = $args[1]
}
```
**C. "Is er iets opgegeven?"**
```powershell
If ($args[0]) {$seconds = $args[0]}
If ($args[1]) {$ResultFile = $args[1]}
```
**D. Met controle op een geldig getal**
```powershell
If (($args[0] -Is [int]) -And ($args[0] -ge 1) -And ($args[0] -le 3600)) {$seconds = $args[0]}
```
**E. Derde argument (grenswaarde / schijf / service / host)**
```powershell
If ($args[2] -Is [int])    {$Threshold = $args[2]}
If ($args[2] -Is [string]) {$Drive = $args[2]}
```
**F. Met melding welke waarde gebruikt wordt**
```powershell
If ($args[0] -Is [int]) {$seconds = $args[0]; Write-Host "Using $seconds seconds (argument)"}
Else {Write-Host "Using default: $seconds seconds"}
```
Starten: `.\script.ps1 30 Meting.txt` → `$args[0] = 30`, `$args[1] = 'Meting.txt'`

---

## Stap 3 · Bestaat het bestand? Menu, invoerlus, keuze
### 3a · De controle
```powershell
If (Test-Path -LiteralPath $ResultFile) {
  # bestaat al: menu + keuze
}
Else {
  # bestaat niet: nieuw bestand + eerste regels
}
```
```powershell
If (-not (Test-Path $ResultFile)) { … }     # omgekeerd: "als het NIET bestaat"
```

### 3b · Het menu tonen
**Docent (Engels)**
```powershell
Write-Host -ForegroundColor Red "WARNING: " -NoNewline
Write-Host "$ResultFile already exists. What do you want to do?"
Write-Host "[1] Add the results to this file"
Write-Host "[2] Delete it and start with an empty one"
Write-Host "[9] Quit"
```
**Nederlands**
```powershell
Write-Host "LET OP: " -ForegroundColor Yellow -NoNewline
Write-Host "$ResultFile bestaat al. Wat wil je doen?"
Write-Host "  [1] Nieuwe metingen toevoegen"
Write-Host "  [2] Bestand leegmaken en opnieuw beginnen"
Write-Host "  [9] Stoppen"
```
**Met letters (a/o/s)**
```powershell
Write-Host "$ResultFile bestaat al: (a)anvullen, (o)verschrijven of (s)toppen?"
```

### 3c · Invoerlus: net zolang vragen tot het antwoord goed is
**A. Docent: `While`**
```powershell
$answer = Read-Host -Prompt "Please make your choice"
While (($answer -ne "1") -And ($answer -ne "2") -And ($answer -ne "9")) {
  $answer = Read-Host -Prompt "Please make your choice"
}
```
**B. `do … until` (Kyan)**
```powershell
do {
  $answer = Read-Host -Prompt "Please make your choice"
} until ($answer -in "1", "2", "9")
```
**C. `do … while`**
```powershell
do {
  $answer = Read-Host -Prompt "Please make your choice"
} while ($answer -notin "1", "2", "9")
```
**D. Met foutmelding bij een verkeerd antwoord**
```powershell
$answer = Read-Host -Prompt "Please make your choice"
While ($answer -notin "1", "2", "9") {
  Write-Host "Invalid choice, please enter 1, 2 or 9." -ForegroundColor Red
  $answer = Read-Host -Prompt "Please make your choice"
}
```
**E. Letters a/o/s**
```powershell
do { $answer = Read-Host "a, o of s" } until ($answer -in 'a','o','s')
```

### 3d · Keuze afhandelen
**A. Docent: losse `If`'s (optie 1 doet niets extra)**
```powershell
If ($answer -Eq '2') {
  Set-Content -path $ResultFile -value "DELETE FROM MemoryUsage WHERE ID > 0;"
  Add-Content -path $ResultFile -value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"
}
If ($answer -Eq '9') {
  Exit
}
```
**B. `If / ElseIf / Else`**
```powershell
If ($answer -Eq '1') {
  Write-Host "Results will be added to $ResultFile"
}
ElseIf ($answer -Eq '2') {
  Set-Content -path $ResultFile -value "DELETE FROM MemoryUsage WHERE ID > 0;"
  Add-Content -path $ResultFile -value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"
}
Else {
  Write-Host "Script stopped by user."
  Exit
}
```
**C. `switch` (Kyan)**
```powershell
switch ($answer) {
  "1" { Add-Content -Path $ResultFile -Value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES" }
  "2" {
        Set-Content -Path $ResultFile -Value "DELETE FROM MemoryUsage WHERE ID > 0;"
        Add-Content -Path $ResultFile -Value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"
      }
  "9" { Write-Host "Script gestopt, er is niets gemeten."; Exit }
}
```
> 💡 Bij **aanvullen (1)**: maakt het script de laatste regel netjes `;` (zoals Kyan), voeg dan bij 1 een nieuwe `INSERT INTO …`-regel toe. Doet het script dat niet (zoals de docent), laat 1 dan leeg.

### 3e · Nieuw bestand + eerste regels (Else-tak én optie 2)
**Geheugen (oefentoets)**
```powershell
Set-Content -path $ResultFile -value "DELETE FROM MemoryUsage WHERE ID > 0;"
Add-Content -path $ResultFile -value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"
```
**Andere onderwerpen**: pas alleen **tabel** en **kolommen** aan (zie [6b](#6b--meetblokken-wat-meet-je)), bijv.:
```powershell
Set-Content -path $ResultFile -value "DELETE FROM CpuUsage WHERE ID > 0;"
Add-Content -path $ResultFile -value "INSERT INTO CpuUsage (Hostname,CpuLoad,Date) VALUES"
```
**Gewoon tekst/CSV in plaats van SQL**
```powershell
Set-Content -Path $ResultFile -Value "Hostname;FreeMemory;Date"          # kopregel CSV
Set-Content -Path $ResultFile -Value "Meting gestart op $(Get-Date) op $MachineName"   # tekstbestand
```
**Leeg bestand**
```powershell
New-Item -Path $ResultFile -ItemType File -Force | Out-Null
```

---

## Stap 4 · Stoptijd
```powershell
$stopAt = (Get-Date).AddSeconds($seconds)                         # kortst
```
```powershell
$aantalSeconden = New-TimeSpan -Seconds $seconds                  # docent
$startAt = Get-Date
$stopAt = (Get-Date) + $aantalSeconden
```
```powershell
$stopAt = (Get-Date).AddMinutes($minutes)                         # in minuten
$startAt = Get-Date; $stopAt = $startAt.AddSeconds($seconds)      # start + stop bewaren
```

## Stap 5 · Scherm leeg + melding
**A. Docent (streep met een for-lus)**
```powershell
clear
$LineOut = "Checking free virtual memory on $MachineName for $seconds seconds"
Write-Host $LineOut
$LengthLineOut = $LineOut.Length
For($i=1;$i -le $LengthLineOut;$i++){
  Write-Host -NoNewline "="
}
Write-Host "`r"
```
**B. Korter**
```powershell
Clear-Host
$LineOut = "Checking free memory on $MachineName for $seconds seconds"
Write-Host $LineOut -ForegroundColor Cyan
Write-Host ("=" * $LineOut.Length)
```
**C. Nederlands (Kyan)**
```powershell
Clear-Host
$titel = "Vrij fysiek geheugen meten op $MachineName gedurende $seconds seconden"
Write-Host $titel -ForegroundColor Cyan
Write-Host ("-" * $titel.Length)
```
**D. Met start- en eindtijd**
```powershell
Clear-Host
Write-Host "Monitoring $MachineName from $(Get-Date -Format 'HH:mm:ss') until $($stopAt.ToString('HH:mm:ss'))"
```

---

## Stap 6 · De lus
### 6a · Soorten lussen
**Zolang de stoptijd niet bereikt is (docent)**
```powershell
while ((Get-Date) -Lt $stopAt) {
  # meten, wegschrijven, tonen, bewegend
}
```
**do … until (eerst meten, dan controleren)**
```powershell
do {
  # meten, wegschrijven, tonen, bewegend
} until ((Get-Date) -ge $stopAt)
```
**Een vast aantal keer meten**
```powershell
for ($i = 1; $i -le $Count; $i++) {
  # meten …
}
```
**Met teller (aantal metingen)**
```powershell
$Count = 0
while ((Get-Date) -Lt $stopAt) {
  # meten …
  $Count++
}
```

### 6b · Meetblokken: wat meet je?
Elk blok = **meten** → **tijdstempel** → **SQL-regel wegschrijven** → **op het scherm tonen**. Zet het blok **binnen** de lus. De bijbehorende kopregels (DELETE/INSERT) staan erbij.

#### 🧠 Vrij geheugen in KB (oefentoets, docent)
```powershell
$FreeMemory = Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory
ForEach ($entry in $FreeMemory){
  $TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
  $MemValue = $entry.FreePhysicalMemory
  $NewLine = "('$MachineName',$MemValue,$TimeStamp),"
  Add-Content -Path $ResultFile -Value $NewLine
  $TimeStamp = Get-Date
  Write-Host "Free memory at ${TimeStamp}:" $entry.FreePhysicalMemory
}
```
Kop: `DELETE FROM MemoryUsage WHERE ID > 0;` + `INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES`

#### 🧠 Vrij geheugen: korte versie, ook in MB (Kyan)
```powershell
$os       = Get-CimInstance -ClassName Win32_OperatingSystem
$vrijKB   = $os.FreePhysicalMemory
$vrijMB   = [math]::Round($vrijKB / 1024)
$sqlDatum = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $ResultFile -Value "('$MachineName',$vrijKB,'$sqlDatum'),"
Write-Host "$sqlDatum   vrij geheugen: $vrijMB MB ($vrijKB KB)"
```

#### 🧠 Gebruikt geheugen in %
```powershell
$os = Get-CimInstance Win32_OperatingSystem
$UsedPct = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize * 100, 1)
$TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
Add-Content -Path $ResultFile -Value "('$MachineName',$UsedPct,$TimeStamp),"
Write-Host "Memory in use at $(Get-Date): $UsedPct %"
```
Kop: `INSERT INTO MemoryPercent (Hostname,UsedPercent,Date) VALUES`

#### 🧠 Totaal / gebruikt / vrij geheugen in GB
```powershell
$os = Get-CimInstance Win32_OperatingSystem
$TotalGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)        # KB -> GB
$FreeGB  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$UsedGB  = [math]::Round($TotalGB - $FreeGB, 2)
Add-Content -Path $ResultFile -Value "('$MachineName',$TotalGB,$UsedGB,$FreeGB,$TimeStamp),"
Write-Host "Memory: $UsedGB GB used of $TotalGB GB ($FreeGB GB free)"
```

#### 🧠 Vrij virtueel geheugen (KB)
```powershell
$Value = (Get-CimInstance Win32_OperatingSystem).FreeVirtualMemory
```

#### 🧠 Beschikbaar geheugen in MB (performance counter)
```powershell
$Value = (Get-CimInstance Win32_PerfFormattedData_PerfOS_Memory).AvailableMBytes
```

#### ⚙️ CPU-belasting in %
```powershell
$CpuValue = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
$TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
Add-Content -Path $ResultFile -Value "('$MachineName',$CpuValue,$TimeStamp),"
Write-Host "CPU load at $(Get-Date): $CpuValue %"
```
Kop: `DELETE FROM CpuUsage WHERE ID > 0;` + `INSERT INTO CpuUsage (Hostname,CpuLoad,Date) VALUES`

#### ⚙️ CPU-belasting (alternatief: performance counter, totaal)
```powershell
$CpuValue = (Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -Filter "Name='_Total'").PercentProcessorTime
```

#### ⚙️ CPU-informatie (naam, cores) — eenmalig, vóór de lus
```powershell
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
Write-Host "CPU: $($cpu.Name) - $($cpu.NumberOfCores) cores, $($cpu.NumberOfLogicalProcessors) threads"
```

#### 💾 Vrije schijfruimte C: in GB
```powershell
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$FreeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
$TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
Add-Content -Path $ResultFile -Value "('$MachineName','C:',$FreeGB,$TimeStamp),"
Write-Host "Free space on C: at $(Get-Date): $FreeGB GB"
```
Kop: `INSERT INTO DiskUsage (Hostname,Drive,FreeGB,Date) VALUES`

#### 💾 Vrije schijfruimte in %
```powershell
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$FreePct = [math]::Round($disk.FreeSpace / $disk.Size * 100, 1)
```

#### 💾 Alle schijven tegelijk (één regel per schijf)
```powershell
$TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
ForEach ($disk in Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3") {     # 3 = lokale harde schijf
  $FreeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
  Add-Content -Path $ResultFile -Value "('$MachineName','$($disk.DeviceID)',$FreeGB,$TimeStamp),"
  Write-Host "$($disk.DeviceID) $FreeGB GB free"
}
```

#### 💾 Schijf met de `Get-PSDrive` (korter)
```powershell
$FreeGB = [math]::Round((Get-PSDrive C).Free / 1GB, 2)
```

#### 📋 Aantal draaiende processen
```powershell
$ProcCount = (Get-Process).Count
Add-Content -Path $ResultFile -Value "('$MachineName',$ProcCount,$TimeStamp),"
Write-Host "Processes at $(Get-Date): $ProcCount"
```

#### 📋 Proces met het meeste geheugen
```powershell
$top = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 1
$TopMB = [math]::Round($top.WorkingSet64 / 1MB)
Add-Content -Path $ResultFile -Value "('$MachineName','$($top.ProcessName)',$TopMB,$TimeStamp),"
Write-Host "Top process: $($top.ProcessName) ($TopMB MB)"
```

#### 📋 Top 5 processen (geheugen of CPU)
```powershell
Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 Name, Id, @{n='MB';e={[math]::Round($_.WorkingSet64/1MB)}}
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, Id, CPU
```

#### 📋 Draait een bepaald proces? (bijv. notepad)
```powershell
$p = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
If ($p) { $Running = 1; $MB = [math]::Round(($p | Measure-Object WorkingSet64 -Sum).Sum / 1MB) }
Else    { $Running = 0; $MB = 0 }
Add-Content -Path $ResultFile -Value "('$MachineName','$ProcessName',$Running,$MB,$TimeStamp),"
```

#### 🛎️ Status van een service (tekst → tussen quotes!)
```powershell
$Status = (Get-Service -Name $ServiceName).Status          # Running / Stopped
Add-Content -Path $ResultFile -Value "('$MachineName','$ServiceName','$Status',$TimeStamp),"
Write-Host "Service $ServiceName at $(Get-Date): $Status"
```

#### 🛎️ Aantal draaiende services
```powershell
$Running = (Get-Service | Where-Object Status -eq 'Running').Count
```

#### 🌐 Ping: bereikbaar + reactietijd (werkt in PS 5.1 én 7)
```powershell
try { $ping = (New-Object System.Net.NetworkInformation.Ping).Send($Target, 1000) } catch { $ping = $null }
If ($ping -and $ping.Status -eq 'Success') { $Reachable = 1; $Ms = $ping.RoundtripTime }
Else { $Reachable = 0; $Ms = 'NULL' }
Add-Content -Path $ResultFile -Value "('$MachineName','$Target',$Reachable,$Ms,$TimeStamp),"
Write-Host "Ping $Target : reachable=$Reachable $Ms ms"
```
Kort (alleen ja/nee): `$ok = Test-Connection -ComputerName $Target -Count 1 -Quiet`

#### 🌐 Netwerkverkeer in KB/s
```powershell
$KBps = [math]::Round((Get-CimInstance Win32_PerfFormattedData_Tcpip_NetworkInterface | Measure-Object -Property BytesTotalPersec -Sum).Sum / 1KB, 1)
```

#### 🌐 IP-adres van de machine
```powershell
$IP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object IPAddress -ne '127.0.0.1' | Select-Object -First 1).IPAddress
```

#### ⏱️ Uptime (minuten sinds opstarten)
```powershell
$boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$UptimeMin = [math]::Round(((Get-Date) - $boot).TotalMinutes)
```

#### 📁 Aantal bestanden / grootte van een map
```powershell
$Files = (Get-ChildItem -Path $Folder -File -Recurse).Count
$SizeMB = [math]::Round((Get-ChildItem -Path $Folder -File -Recurse | Measure-Object Length -Sum).Sum / 1MB, 2)
```

#### 👤 Ingelogde gebruiker / OS-info
```powershell
$User = $env:USERNAME
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "OS: $($os.Caption) $($os.Version)"
```

> **Getal of tekst in de SQL-regel?**
> getal → zonder quotes: `$Value` · tekst → met quotes: `'$Status'` · datum `yyyyMMddHHmmss` → zonder quotes · datum `yyyy-MM-dd HH:mm:ss` → **met** quotes: `'$sqlDatum'`

### 6c · Iets bewegends
**A. Docent: aftellen 3-2-1 op één regel**
```powershell
Write-Host -NoNewline "> Next check in 3`r"; Wait-Event -TimeOut 1
Write-Host -NoNewline "> Next check in 2`r"; Wait-Event -TimeOut 1
Write-Host -NoNewline "> Next check in 1`r"; Wait-Event -TimeOut 1
```
**B. Aftellen met een for-lus (Kyan)**
```powershell
for ($i = 3; $i -gt 0; $i--) {
  Write-Host -NoNewline "   volgende meting over $i sec...`r"
  Start-Sleep -Seconds 1
}
```
**C. Puntjes**
```powershell
for ($i = 1; $i -le 3; $i++) { Write-Host -NoNewline "."; Start-Sleep -Seconds 1 }
Write-Host ""
```
**D. Draaiend streepje**
```powershell
foreach ($c in '|','/','-','\','|','/','-','\') { Write-Host -NoNewline "`r$c measuring..."; Start-Sleep -Milliseconds 375 }
```
**E. Voortgangsbalk (Write-Progress)**
```powershell
$pct = [math]::Min(100, [math]::Round((((Get-Date) - $startAt).TotalSeconds / $seconds) * 100))
Write-Progress -Activity "Monitoring $MachineName" -Status "$pct %" -PercentComplete $pct
Start-Sleep -Seconds 3
```
**F. Resterende tijd tonen**
```powershell
$rest = [math]::Round(($stopAt - (Get-Date)).TotalSeconds)
Write-Host -NoNewline "`r$rest seconds remaining...   "
Start-Sleep -Seconds 1
```

### 6d · Extra's in de lus
**Teller, totaal, laagste, hoogste.** Zet de eerste regel vóór de lus en de rest erin:
```powershell
# vóór de lus
$Count = 0; $Total = 0; $Lowest = [double]::MaxValue; $Highest = 0
# in de lus (na het meten van $Value)
$Count++
$Total += $Value
If ($Value -lt $Lowest)  {$Lowest = $Value}
If ($Value -gt $Highest) {$Highest = $Value}
```
**Waarschuwing boven/onder een grens**
```powershell
If ($CpuValue -gt $Threshold) {
  Write-Host "WARNING: CPU load $CpuValue % is above $Threshold %!" -ForegroundColor Red
  $AlertCount++
}
If ($FreeGB -lt 10)        { Write-Host "WARNING: less than 10 GB free on C:" -ForegroundColor Red }
If ($MemValue -lt 1000000) { Write-Host "WARNING: less than 1 GB memory free" -ForegroundColor Red }
If ($Status -ne 'Running') { Write-Host "WARNING: $ServiceName is $Status" -ForegroundColor Red }
If ($Reachable -eq 0)      { Write-Host "WARNING: $Target is not reachable" -ForegroundColor Red }
```
**Ook naar een logbestand**
```powershell
Add-Content -Path "monitor.log" -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') CPU=$CpuValue"
```

---

## Na de lus
**Laatste komma → puntkomma (geldige SQL)**
```powershell
$lines = @(Get-Content -Path $ResultFile)
$lines[-1] = $lines[-1].TrimEnd(',') + ';'
Set-Content -Path $ResultFile -Value $lines
```
**Gemiddelde, laagste en hoogste tonen**
```powershell
If ($Count -gt 0) {$Average = [math]::Round($Total / $Count, 2)} Else {$Average = 0}
Write-Host "Measurements: $Count  Average: $Average  Lowest: $Lowest  Highest: $Highest"
```
**Hoe vaak boven de grens**
```powershell
Write-Host "$AlertCount of $Count measurements were above $Threshold %"
```

## Stap 7 · Waar staat het bestand?
```powershell
clear
Write-Host -NoNewline "Monitoring process is done. Results can be found in "
Write-Host -ForegroundColor Red $pwd\$ResultFile                     # docent
```
```powershell
$fullPath = (Resolve-Path -LiteralPath $ResultFile).Path             # Kyan
Clear-Host
Write-Host "Klaar! $Count metingen opgeslagen in: " -NoNewline
Write-Host $fullPath -ForegroundColor Green
```
```powershell
Write-Host "Results: $((Get-Item $ResultFile).FullName)"             # alternatief
Write-Host "Results: $(Join-Path $pwd $ResultFile)"                  # alternatief
```

## Stap 8 · Bestand openen (y/n)
**A. Docent**
```powershell
$answer = Read-Host -Prompt "`nDo you want to open it (y/n)?"
While (($answer -ne "y") -And ($answer -ne "n")) {
  $answer = Read-Host -Prompt "Please make your choice (y/n)"
}
If ($answer -Eq 'y') {Invoke-Item $ResultFile}
Else {Write-Host "Dan niet joh..."}
```
**B. do-until + Kladblok (Kyan)**
```powershell
do {
  $openen = Read-Host "`nWil je het bestand openen? (j/n)"
} until ($openen -in "j", "n")
If ($openen -eq "j") { notepad.exe $fullPath }
Else { Write-Host "Prima, het bestand wordt niet geopend." }
```
**Andere manieren om te openen**
```powershell
Invoke-Item $ResultFile                    # standaardprogramma
notepad.exe $ResultFile                    # Kladblok
Start-Process notepad.exe $ResultFile      # Kladblok, script wacht niet
Get-Content $ResultFile                    # inhoud in de console tonen
```

## Stap 9 · Klaar + tijd
```powershell
Write-Host "================================`nScript finished at", (Get-Date), "`n"     # docent
```
```powershell
Write-Host ("=" * 45)
Write-Host "Script afgerond op $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')"                 # Kyan
```
```powershell
$duration = [math]::Round(((Get-Date) - $startAt).TotalSeconds)
Write-Host "Script finished at $(Get-Date -Format 'HH:mm:ss') after $duration seconds"
```

---

## Datum/tijd-formaten
| Code | Resultaat | Gebruik |
|---|---|---|
| `Get-Date -Format "yyyyMMddHHmmss"` | `20261102091503` | SQL zonder quotes (docent) |
| `Get-Date -Format "yyyy-MM-dd HH:mm:ss"` | `2026-11-02 09:15:03` | SQL **met** quotes (Kyan) |
| `Get-Date -Format "dd-MM-yyyy HH:mm:ss"` | `02-11-2026 09:15:03` | scherm (NL) |
| `Get-Date -Format "HH:mm:ss"` | `09:15:03` | alleen tijd |
| `Get-Date -Format "yyyyMMdd-HHmm"` | `20261102-0915` | in een bestandsnaam |
| `(Get-Date).AddSeconds(30)` | +30 seconden | stoptijd |
| `((Get-Date) - $startAt).TotalSeconds` | verstreken seconden | duur |

## W3-koppeling: CREATE TABLE per onderwerp
Getest in MariaDB met de uitvoer van de complete scripts:
```sql
CREATE TABLE MemoryUsage   (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), FreeMemory INT, Date DATETIME);
CREATE TABLE MemoryPercent (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), UsedPercent DECIMAL(5,1), Date DATETIME);
CREATE TABLE CpuUsage      (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), CpuLoad DECIMAL(5,1), Date DATETIME);
CREATE TABLE DiskUsage     (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), Drive VARCHAR(5), FreeGB DECIMAL(10,2), Date DATETIME);
CREATE TABLE DiskPercent   (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), Drive VARCHAR(5), FreePercent DECIMAL(5,1), Date DATETIME);
CREATE TABLE ProcessUsage  (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), ProcessCount INT, TopProcess VARCHAR(100), TopProcessMB INT, Date DATETIME);
CREATE TABLE ServiceStatus (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), ServiceName VARCHAR(100), Status VARCHAR(20), Date DATETIME);
CREATE TABLE PingResults   (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), Target VARCHAR(100), Reachable TINYINT, ResponseMs INT NULL, Date DATETIME);
CREATE TABLE NetworkUsage  (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), KBPerSec DECIMAL(10,1), Date DATETIME);
CREATE TABLE Uptime        (ID INT AUTO_INCREMENT PRIMARY KEY, Hostname VARCHAR(50), UptimeMinutes INT, Date DATETIME);
```

---

## Alles uit de oefentoets op een rij
Elke regel uit het **docentscript** en het **script van Kyan**, en waar je hem hierboven vindt:

| In de oefentoets | Wat | Hier |
|---|---|---|
| `clear` | scherm leeg | stap 5 |
| `$seconds = 5` · `$ResultFile = 'Results.txt'` · `$MachineName = hostname` | defaults | stap 1A |
| `param( [ValidateRange(1,3600)] [int]$Seconden = 15, … )` | param-blok | stap 1C |
| `$Interval = 3` · `$Computer = $env:COMPUTERNAME` · `$Kopregel = "INSERT INTO …"` | extra variabelen | stap 1B/1D |
| `If ($args[0] -Is [int]) {$seconds = $args[0]}` | argument | stap 2A |
| `If (Test-Path -LiteralPath $ResultFile) {` | bestaat? | stap 3a |
| `Write-Host -ForegroundColor Red "WARNING: " -NoNewline` … `[9] Quit` | menu | stap 3b |
| `While (($answer -ne "1") -And …)` | invoerlus | stap 3c-A |
| `do { $keuze = Read-Host … } until ($keuze -in "1","2","9")` | invoerlus | stap 3c-B |
| `If ($answer -Eq '2') { Set-Content … ; Add-Content … }` / `If ($answer -Eq '9') { Exit }` | keuze | stap 3d-A |
| `switch ($keuze) { "1" {…} "2" {…} "9" {…} }` | keuze | stap 3d-C |
| `Set-Content … "DELETE FROM MemoryUsage WHERE ID > 0;"` | nieuw bestand | stap 3e |
| `New-timespan -seconds $seconds` · `$stopAt = (Get-Date) + …` | stoptijd | stap 4 |
| `$stopTijd = (Get-Date).AddSeconds($Seconden)` | stoptijd | stap 4 |
| `$LineOut = "Checking …"` + `For($i=1;…){Write-Host -NoNewline "="}` | melding + streep | stap 5A |
| `Write-Host ("-" * $titel.Length)` | streep | stap 5C |
| `while ((Get-Date) -Lt $stopAt) {` | lus | stap 6a |
| `Get-CIMInstance Win32_OperatingSystem \| Select FreePhysicalMemory` | meten | stap 6b 🧠 |
| `[math]::Round($vrijKB / 1024)` | KB → MB | stap 6b 🧠 Kyan |
| `Get-Date -Format "yyyyMMddHHmmss"` | tijdstempel | datum-formaten |
| `$NewLine = "('$MachineName',$MemValue,$TimeStamp),"` | SQL-regel | stap 6b |
| `Add-Content -Path $ResultFile -Value $NewLine` | wegschrijven | stap 6b |
| `Write-Host "Free memory at ${TimeStamp}:" …` | tonen | stap 6b |
| `` Write-Host -NoNewline "> Next check in 3`r"; Wait-Event -TimeOut 1 `` | bewegend | stap 6c-A |
| `for ($i = $Interval; $i -gt 0; $i--) { … Start-Sleep 1 }` | bewegend | stap 6c-B |
| `$aantalMetingen++` | teller | stap 6d |
| `$regels[-1] = $regels[-1].TrimEnd(",") + ";"` | SQL afsluiten | na de lus |
| `Write-Host -ForegroundColor Red $pwd\$ResultFile` | locatie | stap 7 |
| `(Resolve-Path -LiteralPath $Resultaatbestand).Path` | locatie | stap 7 |
| `` Read-Host -Prompt "`nDo you want to open it (y/n)?" `` + While | openen? | stap 8A |
| `If ($answer -Eq 'y') {Invoke-Item $ResultFile} Else {…}` | openen | stap 8A |
| `notepad.exe $volledigPad` | openen | stap 8B |
| `Write-Host "…Script finished at", (Get-Date)` | klaar | stap 9 |
