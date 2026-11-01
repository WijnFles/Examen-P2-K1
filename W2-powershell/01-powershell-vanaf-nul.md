# 01 · PowerShell vanaf nul

Je hoeft geen programmeur te zijn. In het examen krijg je een script dat **al bijna af is**. Op een paar plekken staat een commentaarregel (begint met `#`) die zegt wat er moet gebeuren. Jij typt daaronder de code.

Op deze pagina staan **alle bouwstenen** die je daarvoor nodig hebt. Elke bouwsteen heeft:
- wat het is, in gewone taal
- de code die je kunt kopiëren
- waar je hem in de oefentoets tegenkomt

> **Tip:** zoek op deze pagina met **Ctrl+F**. Zoek bijvoorbeeld op "vraag", "zolang", "bestand" of "datum".

---

## Inhoud
1. [Commentaar](#1-commentaar)
2. [Variabelen (doosjes)](#2-variabelen-doosjes)
3. [Tekst tonen: Write-Host](#3-tekst-tonen-write-host)
4. [Iets vragen: Read-Host](#4-iets-vragen-read-host)
5. [Vergelijken: -eq, -ne, -lt, …](#5-vergelijken)
6. [Keuzes: if / elseif / else](#6-keuzes-if--elseif--else)
7. [Keuzes met veel opties: switch](#7-keuzes-met-veel-opties-switch)
8. [Herhalen: while (eerst controleren)](#8-herhalen-while)
9. [Herhalen: do … until (eerst doen)](#9-herhalen-do--until)
10. [Tellen: for](#10-tellen-for)
11. [Voor elk item: foreach](#11-voor-elk-item-foreach)
12. [Argumenten: $args en param()](#12-argumenten-args-en-param)
13. [Bestanden: Test-Path, Set-Content, Add-Content, Get-Content](#13-bestanden)
14. [Datum en tijd: Get-Date](#14-datum-en-tijd-get-date)
15. [Wachten: Start-Sleep / Wait-Event](#15-wachten)
16. [Systeeminformatie: Get-CimInstance](#16-systeeminformatie-get-ciminstance)
17. [Scherm leeg, bestand openen, stoppen](#17-scherm-leeg-bestand-openen-stoppen)
18. [Rekenen en tekst bewerken](#18-rekenen-en-tekst-bewerken)
19. [Functies](#19-functies)
20. [Speciale tekens: `n `r `t](#20-speciale-tekens)
21. [Veelgemaakte fouten](#21-veelgemaakte-fouten)

---

## 1. Commentaar
```powershell
# Dit is één regel commentaar. PowerShell slaat het over.

<#
   Dit is commentaar over
   meerdere regels.
#>
```
**Op het examen:** de opdracht staat in het commentaar. Laat dat commentaar **staan** en typ je code eronder. Zet bij elke stap ook zelf een korte `#`-uitleg, want dat telt mee voor "basisconcepten begrepen" en "documentatie".

---

## 2. Variabelen (doosjes)
Een variabele is een doosje met een naam waar je iets in stopt. De naam begint **altijd** met `$`.

```powershell
$seconds     = 5                    # een getal (geen quotes)
$ResultFile  = 'Results.txt'        # tekst (altijd tussen quotes)
$MachineName = hostname             # uitkomst van een commando
$MachineName = $env:COMPUTERNAME    # zelfde: computernaam uit Windows
$teller      = 0                    # een teller beginnen bij 0
$isKlaar     = $false               # waar/niet waar: $true of $false
```

| Wat | Voorbeeld | Let op |
|---|---|---|
| Getal | `$x = 10` | geen quotes |
| Tekst | `$naam = 'Kyan'` of `"Kyan"` | altijd quotes |
| Waar/onwaar | `$true` / `$false` | met `$` ervoor |
| Leeg | `$null` | |
| Lijst | `$opties = @('1','2','9')` | `$opties[0]` is de eerste |

**Hoofdletters maken niet uit:** `$Seconds` en `$seconds` zijn hetzelfde doosje.

### Enkele vs dubbele quotes ⚠️
```powershell
$naam = 'Kyan'
Write-Host "Hallo $naam"     # → Hallo Kyan      (dubbele quotes: variabele wordt INGEVULD)
Write-Host 'Hallo $naam'     # → Hallo $naam     (enkele quotes: letterlijk)
```
Gebruik dus **dubbele quotes** als er een variabele in de tekst moet.

Staat er direct een `:` of een letter achter de variabele? Zet er dan accolades omheen: `"Tijd: ${TimeStamp}:"`

Wil je een **eigenschap** van een variabele in tekst? Gebruik dan `$( )`:
```powershell
Write-Host "Lengte is $($tekst.Length)"
Write-Host "Vrij: $($os.FreePhysicalMemory) KB"
```

---

## 3. Tekst tonen: Write-Host
```powershell
Write-Host "Het script start"                         # gewone tekst
Write-Host "Meting op $MachineName"                   # met variabele
Write-Host "LET OP" -ForegroundColor Red              # rode letters
Write-Host "Bezig..." -NoNewline                      # blijf op dezelfde regel
Write-Host "WARNING: " -ForegroundColor Yellow -NoNewline
Write-Host "Bestand bestaat al"                       # komt achter WARNING:
Write-Host ""                                         # lege regel
Write-Host ("=" * 40)                                 # streep van 40 = tekens
```
Kleuren: `Red, Green, Yellow, Cyan, Blue, Magenta, White, Gray, DarkGray`.

**Flowchart-blok:** *Invoer/uitvoer* (parallellogram). Signaalwoorden: **toon, meld, geef een melding**.

---

## 4. Iets vragen: Read-Host
```powershell
$answer = Read-Host -Prompt "Please make your choice"
$answer = Read-Host "Wil je het bestand openen? (y/n)"     # -Prompt mag je weglaten
$naam   = Read-Host "Wat is je naam"
```
Wat de gebruiker typt komt **als tekst** in de variabele. PowerShell zet zelf `: ` achter je vraag.

Wil je een getal? Zet dan `[int]` ervoor:
```powershell
$aantal = [int](Read-Host "Hoeveel seconden")
```

**Flowchart-blok:** *Invoer/uitvoer*. Signaalwoord: **vraag**.

---

## 5. Vergelijken
In PowerShell gebruik je **geen** `=`, `<` of `>` om te vergelijken. Dat gaat met woordjes met een streepje ervoor:

| Code | Betekenis | Engels | Voorbeeld |
|---|---|---|---|
| `-eq` | is gelijk aan | equal | `$answer -eq 'y'` |
| `-ne` | is niet gelijk aan | not equal | `$answer -ne 'n'` |
| `-lt` | kleiner dan | less than | `(Get-Date) -lt $stopAt` |
| `-le` | kleiner of gelijk | less or equal | `$i -le 10` |
| `-gt` | groter dan | greater than | `$vrij -gt 5000000` |
| `-ge` | groter of gelijk | greater or equal | `$args.Count -ge 2` |
| `-in` | zit in de lijst | | `$answer -in '1','2','9'` |
| `-notin` | zit niet in de lijst | | `$answer -notin 'y','n'` |
| `-like` | lijkt op (met *) | | `$naam -like 'SRV*'` |
| `-is` | is van het type | | `$args[0] -is [int]` |

Combineren:

| Code | Betekenis | Voorbeeld |
|---|---|---|
| `-and` | én (beide moeten waar zijn) | `($a -ne 'y') -and ($a -ne 'n')` |
| `-or` | of (één van beide waar is genoeg) | `($a -eq 'y') -or ($a -eq 'Y')` |
| `-not` of `!` | niet | `-not (Test-Path $file)` / `!(Test-Path $file)` |

> ⚠️ `=` betekent in PowerShell **"stop in het doosje"**, niet "vergelijk". Dus `if ($a = 'y')` is FOUT. Goed is `if ($a -eq 'y')`.

> 💡 Hoofdletters maken niet uit: `'Y' -eq 'y'` is `$true`.

---

## 6. Keuzes: if / elseif / else
**Flowchart:** de ruit (Beslissing). Signaalwoorden: **controleer of, als, zo ja / zo nee**.

```powershell
# Alleen iets doen ALS iets waar is (de Ja-tak, er is geen Nee-tak)
if ($args[0] -is [int]) {
    $seconds = $args[0]
}

# Twee wegen: ALS ... ANDERS ...
if (Test-Path $ResultFile) {
    Write-Host "Bestand bestaat al"
}
else {
    Write-Host "Bestand bestaat nog niet"
}

# Meer wegen: ALS ... ANDERS ALS ... ANDERS ...
if ($answer -eq '1') {
    Write-Host "Aanvullen"
}
elseif ($answer -eq '2') {
    Write-Host "Overschrijven"
}
else {
    Write-Host "Stoppen"
    exit
}
```
Opbouw: `if (VOORWAARDE) { WAT ER DAN GEBEURT }`
- de voorwaarde staat tussen **ronde haakjes** `( )`
- wat er gebeurt staat tussen **accolades** `{ }`
- `else` en `elseif` komen **na** de sluitende `}`

Op één regel mag ook: `If ($answer -Eq 'y') {Invoke-Item $ResultFile}`

---

## 7. Keuzes met veel opties: switch
In plaats van veel `if`'s achter elkaar.
```powershell
switch ($answer) {
    '1' { Write-Host "Resultaten worden toegevoegd" }
    '2' {
        Set-Content -Path $ResultFile -Value "DELETE FROM MemoryUsage WHERE ID > 0;"
        Add-Content -Path $ResultFile -Value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"
    }
    '9' { exit }
    default { Write-Host "Ongeldige keuze" }   # alles wat niet 1, 2 of 9 is
}
```

---

## 8. Herhalen: while
**"ZOLANG ... doe ..."**. Eerst controleren, dan doen. Is de voorwaarde meteen onwaar? Dan gebeurt het blok **nooit**.

```powershell
# Zolang de stoptijd niet bereikt is (= zolang NU kleiner is dan de stoptijd)
while ((Get-Date) -lt $stopAt) {
    # meten, tonen, wegschrijven
}

# Invoerlus in de stijl van de docent: eerst één keer vragen, dan zolang het fout is opnieuw vragen
$answer = Read-Host "Please make your choice"
while (($answer -ne "1") -and ($answer -ne "2") -and ($answer -ne "9")) {
    $answer = Read-Host "Please make your choice"
}

# Tellerlus
$teller = 0
while ($teller -lt 5) {
    Write-Host "Ronde $teller"
    $teller++            # +1, ANDERS STOPT DE LUS NOOIT
}
```

---

## 9. Herhalen: do … until
**"Vraag NET ZOLANG TOT ..."**. Eerst doen, dan controleren. Het blok gebeurt **altijd minstens 1 keer**. Perfect om iets te vragen.

```powershell
do {
    $answer = Read-Host "Do you want to open it (y/n)?"
} until ($answer -eq 'y' -or $answer -eq 'n')

# korter met -in:
do {
    $answer = Read-Host "Maak je keuze (1, 2 of 9)"
} until ($answer -in '1', '2', '9')
```

Er bestaat ook `do { } while (...)`. Dat herhaalt **zolang** de voorwaarde waar is:
```powershell
do {
    $answer = Read-Host "(y/n)"
} while ($answer -ne 'y' -and $answer -ne 'n')
```

| Je leest in de opdracht | Gebruik |
|---|---|
| "**Zolang** de stoptijd niet bereikt is" | `while ((Get-Date) -lt $stopAt) { }` |
| "Vraag **net zolang tot** y of n is ingevoerd" | `do { Read-Host } until (...)` **of** de docent-stijl met `while` |
| "Herhaal **x keer**" | `for ($i = 1; $i -le x; $i++) { }` |

> Beide invoerlussen zijn goed. Kijk welke stijl er **al in het script** staat en doe het op dezelfde manier.

---

## 10. Tellen: for
```powershell
for ($i = 1; $i -le 10; $i++) {
    Write-Host "Dit is ronde $i"
}
```
Lees het zo: **begin** bij `$i = 1` ; **ga door zolang** `$i -le 10` ; **na elke ronde** `$i++` (+1).

Aftellen ("iets bewegends"):
```powershell
for ($i = 3; $i -gt 0; $i--) {
    Write-Host -NoNewline "> Next check in $i `r"
    Start-Sleep -Seconds 1
}
```

Een streep zo lang als een tekst (zoals de docent het doet):
```powershell
for ($i = 1; $i -le $LineOut.Length; $i++) { Write-Host -NoNewline "=" }
Write-Host ""
```

---

## 11. Voor elk item: foreach
```powershell
foreach ($entry in $FreeMemory) {
    $MemValue = $entry.FreePhysicalMemory
}

foreach ($disk in Get-CimInstance Win32_LogicalDisk) {
    Write-Host "$($disk.DeviceID) heeft $($disk.FreeSpace) bytes vrij"
}
```
"Voor elk `$entry` in de lijst `$FreeMemory`: doe dit". `$entry` is telkens één item.

---

## 12. Argumenten: $args en param()
Argumenten zijn de waarden die je **achter** de scriptnaam typt bij het starten:
```
.\MonitorFreeMemory-Kyan.ps1 30 Meting.txt
                              ↑      ↑
                          $args[0] $args[1]
```

### Manier 1: $args (zo doet de docent het)
```powershell
$seconds    = 5                  # default
$ResultFile = 'Results.txt'      # default

if ($args[0] -is [int])    { $seconds    = $args[0] }    # getal opgegeven? vervang
if ($args[1] -is [string]) { $ResultFile = $args[1] }    # tekst opgegeven? vervang
```
Andere manieren om "is er iets opgegeven?" te controleren (allemaal goed):
```powershell
if ($args[0])                { $seconds = $args[0] }     # is er iets?
if ($args.Count -ge 1)       { $seconds = $args[0] }     # minstens 1 argument?
if ($args[1] -ne $null)      { $ResultFile = $args[1] }
```

### Manier 2: param() (moet de ALLEREERSTE code in het script zijn)
```powershell
param(
    [int]$Seconden = 15,
    [string]$Resultaatbestand = "Resultaten.sql"
)
# starten:  .\script.ps1 -Seconden 30 -Resultaatbestand test.sql   of   .\script.ps1 30 test.sql
```
> Op het examen: gebruik de manier die **al in het script staat** (waarschijnlijk `$args`).

---

## 13. Bestanden
**Flowchart:** het Document-symbool. Signaalwoorden: **bestand, schrijf weg, maak een bestand, open**.

| Wat wil je? | Code |
|---|---|
| Bestaat het bestand? | `Test-Path -LiteralPath $ResultFile` → `$true`/`$false` |
| **Nieuw** bestand / **overschrijven** + eerste regel | `Set-Content -Path $ResultFile -Value "eerste regel"` |
| Regel **toevoegen** onderaan | `Add-Content -Path $ResultFile -Value "nieuwe regel"` |
| Bestand lezen | `$regels = Get-Content -Path $ResultFile` |
| Leeg bestand maken | `New-Item -Path $ResultFile -ItemType File -Force` |
| Bestand verwijderen | `Remove-Item -Path $ResultFile` |
| Bestand openen (Kladblok) | `Invoke-Item $ResultFile` of `notepad.exe $ResultFile` |
| Volledig pad | `"$pwd\$ResultFile"` of `(Resolve-Path $ResultFile).Path` |

> 🔑 **Set-Content = weggooien en opnieuw beginnen. Add-Content = onderaan erbij.**

```powershell
# Nieuw bestand starten en eerste regels wegschrijven:
Set-Content -Path $ResultFile -Value "DELETE FROM MemoryUsage WHERE ID > 0;"
Add-Content -Path $ResultFile -Value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"

# Eén meting wegschrijven:
Add-Content -Path $ResultFile -Value "('$MachineName',$MemValue,$TimeStamp),"
```

Laatste komma vervangen door `;` (zodat de SQL klopt):
```powershell
$regels = @(Get-Content -Path $ResultFile)
$regels[-1] = $regels[-1].TrimEnd(',') + ';'      # [-1] = de laatste regel
Set-Content -Path $ResultFile -Value $regels
```

---

## 14. Datum en tijd: Get-Date
```powershell
$nu      = Get-Date                                   # nu
$stopAt  = (Get-Date).AddSeconds($seconds)            # nu + x seconden  ← STOPTIJD
$stopAt  = (Get-Date) + (New-TimeSpan -Seconds $seconds)   # zelfde, docent-stijl
$later   = (Get-Date).AddMinutes(5)                   # nu + 5 minuten

Get-Date -Format "yyyyMMddHHmmss"        # 20261102091503     (voor SQL, docent)
Get-Date -Format "yyyy-MM-dd HH:mm:ss"   # 2026-11-02 09:15:03 (voor SQL, met quotes)
Get-Date -Format "dd-MM-yyyy HH:mm:ss"   # 02-11-2026 09:15:03 (mooi voor het scherm)
Get-Date -Format "HH:mm:ss"              # 09:15:03            (alleen de tijd)
```
| Letter | Betekent | Let op |
|---|---|---|
| `yyyy` | jaar | |
| `MM` | maand | **hoofdletter** M |
| `dd` | dag | |
| `HH` | uur (0-23) | |
| `mm` | minuut | **kleine** m |
| `ss` | seconde | |

Vergelijken: `(Get-Date) -lt $stopAt` = "het is nog vóór de stoptijd".

---

## 15. Wachten
```powershell
Start-Sleep -Seconds 1          # wacht 1 seconde
Start-Sleep -Milliseconds 500   # wacht een halve seconde
Wait-Event -TimeOut 1           # wacht 1 seconde (docent-stijl)
```

---

## 16. Systeeminformatie: Get-CimInstance
Hiermee vraag je informatie over de computer op. **Dit is het "meten" in de lus.** Op het examen kan het om iets anders gaan dan geheugen (CPU, schijf, …). Zie [04-varianten-andere-metingen.md](04-varianten-andere-metingen.md).

```powershell
# Vrij geheugen in KB (zoals de docent)
$FreeMemory = Get-CimInstance Win32_OperatingSystem | Select FreePhysicalMemory
$MemValue   = $FreeMemory.FreePhysicalMemory

# Korter (doet hetzelfde):
$MemValue = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory
```
Het `|` teken heet **pipe** en betekent: "geef het resultaat door aan het volgende commando".

---

## 17. Scherm leeg, bestand openen, stoppen
```powershell
Clear-Host                  # scherm leegmaken (cls en clear doen hetzelfde)
Invoke-Item $ResultFile     # bestand openen met het standaardprogramma
notepad.exe $ResultFile     # bestand openen in Kladblok
exit                        # script stoppen
```

---

## 18. Rekenen en tekst bewerken
```powershell
$teller++                         # +1
$teller--                         # -1
$totaal = $totaal + $MemValue     # optellen
$totaal += $MemValue              # zelfde, korter
$gem = $totaal / $aantal          # delen
$mb  = [math]::Round($kb / 1024)  # afronden: KB → MB
$gb  = [math]::Round($bytes / 1GB, 2)   # bytes → GB, 2 decimalen

$tekst.Length                     # aantal tekens
$tekst.ToUpper()                  # HOOFDLETTERS
$tekst.TrimEnd(',')               # komma aan het eind weghalen
$tekst.Replace('a','b')           # vervangen
"=" * 20                          # ==================== (tekst herhalen)
```

---

## 19. Functies
Een functie is een stukje code met een naam, dat je vaker kunt gebruiken. In de flowchart is dat het blok *Voorgedefinieerd proces*.
```powershell
function Write-Log {
    param([string]$Tekst)
    Add-Content -Path $ResultFile -Value $Tekst
}

# gebruiken:
Write-Log "('$MachineName',$MemValue,$TimeStamp),"
```
Een functie moet **boven** de plek staan waar je hem gebruikt.

---

## 20. Speciale tekens
Gebruik het **backtick**-teken `` ` `` (links naast de 1, onder Esc). Het werkt alleen in **dubbele quotes**.

| Code | Betekent |
|---|---|
| `` `n `` | nieuwe regel (enter) |
| `` `r `` | terug naar het begin van de regel (voor aftellen op één regel) |
| `` `t `` | tab |

---

## 21. Veelgemaakte fouten
| Fout | Goed |
|---|---|
| `if ($a = 'y')` | `if ($a -eq 'y')` |
| `if ($a == 'y')` | `if ($a -eq 'y')` |
| `while (Get-Date -lt $stop)` | `while ((Get-Date) -lt $stop)`: Get-Date **tussen haakjes** |
| `$stop = Get-Date.AddSeconds(5)` | `$stop = (Get-Date).AddSeconds(5)` |
| Stoptijd **in** de lus bepalen | Stoptijd **vóór** de lus, anders stopt hij nooit |
| Teller niet verhogen | `$teller++` in de lus |
| `{` of `)` vergeten | VS Code kleurt de bijbehorende haakjes. Klik erop om te zien welke bij elkaar horen. Een rode kronkellijn = fout |
| `'Hallo $naam'` | `"Hallo $naam"` |
| `"Vrij: $os.FreePhysicalMemory"` | `"Vrij: $($os.FreePhysicalMemory)"` |
| Set-Content in de lus | Add-Content in de lus (anders blijft alleen de laatste meting over) |
| `param()` niet bovenaan | `param()` moet de eerste code zijn |
| Script start niet: "running scripts is disabled" | In de terminal: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` |
