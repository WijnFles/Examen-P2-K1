# 04 · Varianten: als het examen iets anders meet

Het examen kan "bijna identiek" zijn, maar met andere namen. Bijvoorbeeld CPU in plaats van geheugen, of schijfruimte. **Het hele script blijft dan hetzelfde.** Alleen deze dingen veranderen:

1. **De meetregel** in de lus (wat haal je op?)
2. **De namen**: variabelen, bestandsnaam, tabelnaam, kolomnamen
3. **De teksten** op het scherm

De structuur (defaults → argumenten → bestand bestaat? → stoptijd → lus → openen? → klaar) blijft **precies** gelijk.

---

## Meetregels: wat haal je op?

| Wat moet je meten? | Code (geeft één getal) | Eenheid |
|---|---|---|
| Vrij geheugen (RAM) | `(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory` | KB |
| Totaal geheugen (RAM) | `(Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize` | KB |
| Gebruikt geheugen | `$os = Get-CimInstance Win32_OperatingSystem`<br>`$used = $os.TotalVisibleMemorySize - $os.FreePhysicalMemory` | KB |
| Geheugen in procenten vrij | `[math]::Round($os.FreePhysicalMemory / $os.TotalVisibleMemorySize * 100, 1)` | % |
| Vrij virtueel geheugen | `(Get-CimInstance Win32_OperatingSystem).FreeVirtualMemory` | KB |
| CPU-belasting | `(Get-CimInstance Win32_Processor \| Measure-Object -Property LoadPercentage -Average).Average` | % |
| Vrije schijfruimte C: | `(Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace` | bytes |
| Vrije schijfruimte C: in GB | `[math]::Round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB, 2)` | GB |
| Totale schijfgrootte C: | `(Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").Size` | bytes |
| Aantal draaiende processen | `(Get-Process).Count` | aantal |
| Geheugen van één proces | `(Get-Process -Name notepad).WorkingSet64` | bytes |
| Aantal draaiende services | `(Get-Service \| Where-Object Status -eq 'Running').Count` | aantal |
| Status van één service | `(Get-Service -Name Spooler).Status` | Running/Stopped |
| Is een server bereikbaar (ping)? | `Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet` | $true/$false |
| Uptime (minuten sinds opstarten) | `[math]::Round(((Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime).TotalMinutes)` | minuten |
| Aantal bestanden in een map | `(Get-ChildItem -Path C:\Temp -File).Count` | aantal |
| Ingelogde gebruiker | `$env:USERNAME` | tekst |
| IP-adres | `(Get-NetIPAddress -AddressFamily IPv4 \| Where-Object IPAddress -ne '127.0.0.1')[0].IPAddress` | tekst |

> 💡 **Tekst** (zoals een status of IP) moet in SQL **tussen quotes**: `"('$MachineName','$Status',$TimeStamp),"`. **Getallen** zonder quotes.

> 💡 Wil je zien wat een `Get-CimInstance` allemaal kan teruggeven? Typ in de terminal:
> `Get-CimInstance Win32_OperatingSystem | Select-Object *`

---

## Voorbeeld: hetzelfde script, maar voor CPU

Alleen de gemarkeerde regels veranderen ten opzichte van het docentscript:

```powershell
$seconds    = 5
$ResultFile = 'CpuResults.txt'                                      # ← andere naam
$MachineName = hostname

...

Set-Content -path $ResultFile -value "DELETE FROM CpuUsage WHERE ID > 0;"                       # ← tabel
Add-Content -path $ResultFile -value "INSERT INTO CpuUsage (Hostname,CpuLoad,Date) VALUES"     # ← kolommen

...

while ((Get-Date) -Lt $stopAt) {
  $CpuValue  = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average   # ← meetregel
  $TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
  Add-Content -Path $ResultFile -Value "('$MachineName',$CpuValue,$TimeStamp),"
  Write-Host "CPU load at $(Get-Date): $CpuValue %"                                             # ← tekst
  ...
}
```

Volledig uitgewerkt en getest: zie [scripts/antwoorden/oefening-2-MonitorCpu-ANTWOORD.ps1](scripts/antwoorden/oefening-2-MonitorCpu-ANTWOORD.ps1).

---

## Checklist: wat pas ik aan bij een variant?

- [ ] Meetregel in de lus
- [ ] Naam van de variabele die de meting bevat (overal hetzelfde!)
- [ ] Default bestandsnaam
- [ ] `DELETE FROM <tabel>` en `INSERT INTO <tabel> (<kolommen>)`
- [ ] Getal of tekst? Tekst tussen `'quotes'` in de SQL-regel
- [ ] Teksten op het scherm (melding, "free memory at …")
- [ ] Header-commentaar bovenaan: naam, functie, jouw naam, datum, versie
