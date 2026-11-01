# 02 · Van commentaar naar code (opzoektabel)

**Dit is het belangrijkste bestand voor W2.**

In het examenscript staan commentaarregels zoals `# Vraag de gebruiker net zolang tot er y of n is ingevoerd`. Zoek die zin hieronder op (met **Ctrl+F**, op een kernwoord). Neem de code over en **pas alleen de namen aan** aan de variabelen die al in het script staan.

> ### ⚠️ Gouden regel 1: gebruik de namen die AL in het script staan
> Heet het bestand in het script `$ResultFile`? Typ dan **niet** `$Resultaatbestand`.
> Kijk bovenaan het script welke variabelen er zijn, en gebruik precies die namen.
>
> ### ⚠️ Gouden regel 2: kopieer de stijl van het script
> Gebruikt de docent `While` voor de eerste invoerlus? Doe het bij de tweede ook zo. Je kunt bijna altijd een stuk code **elders in hetzelfde script** vinden dat bijna hetzelfde doet. Kopieer dat en pas het aan.

---

## Stap 1 · Default variabelen

| Commentaar zegt | Code |
|---|---|
| Vul een variabele met het aantal seconden (default) | `$seconds = 5` |
| Vul een variabele met de naam van het tekstbestand | `$ResultFile = 'Results.txt'` |
| Vul een variabele met de hostname / computernaam | `$MachineName = hostname` of `$MachineName = $env:COMPUTERNAME` |
| Vul een variabele met de gebruikersnaam | `$User = $env:USERNAME` |
| Vul een variabele met de map / het pad | `$Map = 'C:\Temp'` of `$Map = $pwd` |
| Vul een variabele met de interval / wachttijd | `$Interval = 3` |
| Zet een teller op 0 | `$teller = 0` |

## Stap 2 · Argumenten

| Commentaar zegt | Code |
|---|---|
| Controleer of er een argument voor het aantal seconden is opgegeven, zo ja vervang de default | `If ($args[0] -Is [int]) {$seconds = $args[0]}` |
| Controleer of er een argument voor de bestandsnaam is opgegeven, zo ja vervang de default | `If ($args[1] -Is [string]) {$ResultFile = $args[1]}` |
| Controleer of er argumenten zijn opgegeven (allebei tegelijk) | `If ($args.Count -ge 2) { $seconds = $args[0]; $ResultFile = $args[1] }` |
| Derde argument (bijv. interval) | `If ($args[2] -Is [int]) {$Interval = $args[2]}` |

## Stap 3 · Bestaat het bestand? Menu + invoerlus

| Commentaar zegt | Code |
|---|---|
| Controleer of het tekstbestand al bestaat | `If (Test-Path -LiteralPath $ResultFile) {` … `}` |
| Zo nee (het bestand bestaat niet) | `Else {` … `}` |
| Toon een waarschuwing dat het bestand al bestaat | `Write-Host -ForegroundColor Red "WARNING: " -NoNewline`<br>`Write-Host "$ResultFile already exists. What do you want to do?"` |
| Toon de opties | `Write-Host "[1] Add the results to this file"`<br>`Write-Host "[2] Delete it and start with an empty one"`<br>`Write-Host "[9] Quit"` |
| Vraag de gebruiker een keuze te maken | `$answer = Read-Host -Prompt "Please make your choice"` |
| **Vraag net zolang tot een correct antwoord (1, 2 of 9) is ingevoerd** | zie blok A hieronder |
| Als de gebruiker kiest om te overschrijven (2): start een nieuw bestand en schrijf de eerste regels weg | zie blok B |
| Als de gebruiker kiest om te stoppen (9): stop het script | `If ($answer -Eq '9') { Exit }` |
| Als de gebruiker kiest om aan te vullen (1) | niets doen, of een melding: `If ($answer -Eq '1') { Write-Host "Results will be added" }` |
| Zo nee: maak een nieuw bestand en schrijf de eerste regels weg | zie blok B (in de `Else`) |

**Blok A · invoerlus 1/2/9** (kies er één):
```powershell
# Docent-stijl (vraag 1x, dan zolang fout opnieuw)
$answer = Read-Host -Prompt "Please make your choice"
While (($answer -ne "1") -And ($answer -ne "2") -And ($answer -ne "9")) {
  $answer = Read-Host -Prompt "Please make your choice"
}

# do-until-stijl (ook goed, korter)
do {
  $answer = Read-Host -Prompt "Please make your choice"
} until ($answer -in "1", "2", "9")
```

**Blok B · nieuw bestand + eerste regels**:
```powershell
Set-Content -path $ResultFile -value "DELETE FROM MemoryUsage WHERE ID > 0;"
Add-Content -path $ResultFile -value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"
```
> Heet de tabel op het examen anders, bijvoorbeeld `CpuUsage`? Pas dan de tabelnaam en de kolomnamen aan. Kijk wat de opdracht of de SQL-opdracht (W3) zegt.

## Stap 4 · Stoptijd

| Commentaar zegt | Code |
|---|---|
| Bepaal de stoptijd en zet deze in een variabele | `$stopAt = (Get-Date).AddSeconds($seconds)` |
| (docent-stijl, 3 regels) | `$aantalSeconden = New-TimeSpan -Seconds $seconds`<br>`$startAt = Get-Date`<br>`$stopAt = (Get-Date) + $aantalSeconden` |
| Bewaar de starttijd | `$startAt = Get-Date` |

## Stap 5 · Scherm leeg + melding

| Commentaar zegt | Code |
|---|---|
| Maak het scherm leeg | `clear` of `Clear-Host` |
| Toon de gebruiker wat er gaat gebeuren | `$LineOut = "Checking free memory on $MachineName for $seconds seconds"`<br>`Write-Host $LineOut` |
| Zet een streep onder de melding (even lang als de melding) | `For($i=1;$i -le $LineOut.Length;$i++){ Write-Host -NoNewline "=" }`<br>`Write-Host ""` |
| (korter) | `Write-Host ("=" * $LineOut.Length)` |

## Stap 6 · De lus: meten, tonen, wegschrijven, iets bewegends

| Commentaar zegt | Code |
|---|---|
| **Zolang de stoptijd nog niet bereikt is** | `while ((Get-Date) -Lt $stopAt) {` … `}` |
| Haal het vrije geheugen op | `$MemValue = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory` |
| (docent-stijl) | `$FreeMemory = Get-CIMInstance Win32_OperatingSystem \| Select FreePhysicalMemory`<br>`ForEach ($entry in $FreeMemory){ $MemValue = $entry.FreePhysicalMemory … }` |
| Bepaal de tijd voor in het bestand | `$TimeStamp = Get-Date -Format "yyyyMMddHHmmss"` |
| Stel de regel samen | `$NewLine = "('$MachineName',$MemValue,$TimeStamp),"` |
| Schrijf weg naar het tekstbestand | `Add-Content -Path $ResultFile -Value $NewLine` |
| Toon op het scherm | `Write-Host "Free memory at $(Get-Date):" $MemValue` |
| Toon de gebruiker iets 'bewegends' | zie blok C |
| Wacht x seconden | `Start-Sleep -Seconds 3` of `Wait-Event -TimeOut 3` |
| Tel het aantal metingen | `$teller++` (en vóór de lus `$teller = 0`) |

**Blok C · iets bewegends** (kies er één):
```powershell
# Docent: aftellen 3-2-1 op dezelfde regel
Write-Host -NoNewline "> Next check in 3`r"; Wait-Event -TimeOut 1
Write-Host -NoNewline "> Next check in 2`r"; Wait-Event -TimeOut 1
Write-Host -NoNewline "> Next check in 1`r"; Wait-Event -TimeOut 1

# Met een for-lus (doet hetzelfde)
for ($i = 3; $i -gt 0; $i--) {
  Write-Host -NoNewline "> Next check in $i`r"
  Start-Sleep -Seconds 1
}

# Puntjes die erbij komen
for ($i = 1; $i -le 3; $i++) {
  Write-Host -NoNewline "."
  Start-Sleep -Seconds 1
}
Write-Host ""

# Draaiend streepje  | / - \
foreach ($teken in '|','/','-','\') {
  Write-Host -NoNewline "`r$teken "
  Start-Sleep -Milliseconds 250
}
```

**De complete lus, docent-stijl:**
```powershell
while ((Get-Date) -Lt $stopAt) {
  $FreeMemory = Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory
  ForEach ($entry in $FreeMemory){
    $TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
    $MemValue = $entry.FreePhysicalMemory
    $NewLine = "('$MachineName',$MemValue,$TimeStamp),"
    Add-Content -Path $ResultFile -Value $NewLine
    $TimeStamp = Get-Date
    Write-Host "Free memory at ${TimeStamp}:" $entry.FreePhysicalMemory
  }
  Write-Host -NoNewline "> Next check in 3`r"; Wait-Event -TimeOut 1
  Write-Host -NoNewline "> Next check in 2`r"; Wait-Event -TimeOut 1
  Write-Host -NoNewline "> Next check in 1`r"; Wait-Event -TimeOut 1
}
```

## (Extra) SQL netjes afsluiten

| Commentaar zegt | Code |
|---|---|
| Vervang de laatste komma door een puntkomma | `$regels = @(Get-Content -Path $ResultFile)`<br>`$regels[-1] = $regels[-1].TrimEnd(',') + ';'`<br>`Set-Content -Path $ResultFile -Value $regels` |

> Het script van de docent doet dit **niet**. Daardoor eindigt het bestand op een `,` en geeft MySQL een fout. Bij W3 3.1 ("herstel indien nodig") vervang je die komma met de hand. Zie [W3-sql/01-tabel-vullen.md](../W3-sql/01-tabel-vullen.md).

## Stap 7 · Scherm leeg + locatie tonen

| Commentaar zegt | Code |
|---|---|
| Maak het scherm leeg | `clear` |
| Toon waar het bestand gevonden kan worden | `Write-Host -NoNewline "Monitoring process is done. Results can be found in "`<br>`Write-Host -ForegroundColor Red $pwd\$ResultFile` |
| (alternatief, volledig pad) | `$pad = (Resolve-Path $ResultFile).Path`<br>`Write-Host "Results can be found in $pad"` |

## Stap 8 · Bestand openen? (y/n)

| Commentaar zegt | Code |
|---|---|
| Vraag of de gebruiker het bestand wil openen | `` $answer = Read-Host -Prompt "`nDo you want to open it (y/n)?" `` |
| **Herhaal dit net zolang tot er y of n wordt ingevoerd** | `While (($answer -ne "y") -And ($answer -ne "n")) {`<br>`  $answer = Read-Host -Prompt "Please make your choice (y/n)"`<br>`}` |
| Als het antwoord y is: open het bestand | `If ($answer -Eq 'y') {Invoke-Item $ResultFile}` |
| Als het antwoord n is: geef een passende melding | `Else {Write-Host "The file will not be opened."}` |

Compleet:
```powershell
$answer = Read-Host -Prompt "`nDo you want to open it (y/n)?"
While (($answer -ne "y") -And ($answer -ne "n")) {
  $answer = Read-Host -Prompt "Please make your choice (y/n)"
}
If ($answer -Eq 'y') {Invoke-Item $ResultFile}
Else {Write-Host "OK, the file will not be opened."}
```

## Stap 9 · Klaar + tijd

| Commentaar zegt | Code |
|---|---|
| Meld dat het script klaar is, inclusief de tijd dat het gestopt is | `Write-Host "Script finished at" (Get-Date)` |
| (docent-stijl) | `` Write-Host "================================`nScript finished at", (Get-Date), "`n" `` |
| (mooie tijd) | `Write-Host "Script finished at $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')"` |
| Toon hoe lang het script heeft gedraaid | `$duur = (Get-Date) - $startAt`<br>`Write-Host "Duur: $([math]::Round($duur.TotalSeconds)) seconden"` |
| Toon het aantal metingen | `Write-Host "Aantal metingen: $teller"` |

---

## "Moeilijker dan de oefentoets": extra's die gevraagd kunnen worden

| Commentaar zegt | Code |
|---|---|
| Bereken het gemiddelde | vóór de lus: `$totaal = 0; $teller = 0`<br>in de lus: `$totaal += $MemValue; $teller++`<br>na de lus: `$gemiddelde = [math]::Round($totaal / $teller)` |
| Bewaar de laagste waarde | vóór: `$laagste = [long]::MaxValue`<br>in de lus: `if ($MemValue -lt $laagste) { $laagste = $MemValue }` |
| Bewaar de hoogste waarde | vóór: `$hoogste = 0`<br>in de lus: `if ($MemValue -gt $hoogste) { $hoogste = $MemValue }` |
| Geef een waarschuwing als het geheugen onder een grens komt | `if ($MemValue -lt 1000000) { Write-Host "WARNING: low memory!" -ForegroundColor Red }` |
| Reken om naar MB | `$MB = [math]::Round($MemValue / 1024)` |
| Reken om naar GB | `$GB = [math]::Round($MemValue / 1MB, 2)` (KB → GB) |
| Controleer of het argument een geldig getal tussen 1 en 3600 is | `if ($args[0] -is [int] -and $args[0] -ge 1 -and $args[0] -le 3600) { $seconds = $args[0] }` |
| Maak de map aan als die niet bestaat | `if (-not (Test-Path $Map)) { New-Item -Path $Map -ItemType Directory }` |
| Schrijf ook naar een logbestand via een functie | zie [01 § 19 Functies](01-powershell-vanaf-nul.md#19-functies) |
| Vraag de gebruiker hoeveel seconden (in plaats van argument) | `$seconds = [int](Read-Host "How many seconds?")` |
| Laat de gebruiker de hostname bevestigen | `$ok = Read-Host "Use $MachineName? (y/n)"` |
