# Instructie (gebruikershandleiding) bij het script: voorbeelden

Naast de flowchart en de mail moet je de opdrachtgever/gebruiker vaak een **instructie** geven: **hoe gebruik je het script?** Ook dit valt onder het criterium **Communicatie** (begrijpelijk, functioneel). Bij W2 telt het mee voor **Documenteren**.

**Regels voor een goede instructie**
- Schrijf voor iemand **zonder** PowerShell-kennis: **stap voor stap**, genummerd.
- Elke stap = **één handeling** ("Typ…", "Druk op Enter…", "Kies…").
- Zet commando's die de gebruiker moet typen in een **apart blok**, precies zoals ze getypt moeten worden.
- Laat zien **wat de gebruiker op het scherm ziet** (voorbeelden).
- Sluit af met **"Wat als het niet werkt?"** (veelvoorkomende problemen + oplossing).
- Zet de instructie **in de mail** (kort) of als **bijlage** (volledig), en noem dat in de mail.

---

## Voorbeeld 1: volledige instructie Geheugenmonitor (aanbevolen)

### Instructie: Geheugenmonitor (MonitorFreeMemory-Kyan.ps1)
**Versie 1.0 · 2 november 2026 · Kyan Wossink, Solar Plex Network**

**Waar is dit script voor?**
Het script meet een aantal seconden lang hoeveel geheugen er vrij is op de server. De metingen worden bewaard in een bestand, waarmee de tabel *MemoryUsage* in de database gevuld kan worden.

**Wat heb je nodig?**
- Een Windows-server of -pc met PowerShell (standaard aanwezig)
- Het bestand `MonitorFreeMemory-Kyan.ps1`, bijvoorbeeld in de map `C:\Scripts`

**Het script starten**
1. Klik op **Start**, typ `PowerShell`, klik met de rechtermuisknop op **Windows PowerShell** en kies **Als administrator uitvoeren**.
2. Ga naar de map met het script. Typ en druk op **Enter**:
   ```powershell
   cd C:\Scripts
   ```
3. Start het script. Kies **één** van deze manieren en druk op **Enter**:
   ```powershell
   .\MonitorFreeMemory-Kyan.ps1                  # standaard: 5 seconden, bestand Results.txt
   .\MonitorFreeMemory-Kyan.ps1 60 Meting.txt    # zelf kiezen: 60 seconden, bestand Meting.txt
   ```
   Het **eerste getal** is het aantal seconden. Daarna volgt de **naam van het bestand**.

**Bestaat het bestand al?**
4. Dan verschijnt deze vraag:
   ```text
   WARNING: Results.txt already exists. What do you want to do?
   [1] Add the results to this file
   [2] Delete it and start with an empty one
   [9] Quit
   Please make your choice:
   ```
   Typ **1** (nieuwe metingen toevoegen), **2** (oude metingen wissen en opnieuw beginnen) of **9** (stoppen) en druk op **Enter**. Typt u iets anders, dan wordt de vraag opnieuw gesteld.

**Tijdens het meten**
5. U ziet elke 3 seconden een meting en een aftelling. U hoeft niets te doen.
   ```text
   Checking free memory on SRV01 for 60 seconds
   ============================================
   Free memory at 02-11-2026 09:15:03: 4543524
   > Next check in 2
   ```

**Na het meten**
6. Het script laat zien waar het bestand staat en vraagt of u het wilt openen:
   ```text
   Monitoring process is done. Results can be found in C:\Scripts\Meting.txt
   Do you want to open it (y/n)?:
   ```
   Typ **y** om het bestand te openen in Kladblok, of **n** om het niet te openen.
7. Het script meldt dat het klaar is, met de eindtijd. U kunt het venster sluiten.

**Het resultaat in de database zetten**
8. Open MySQL Workbench, open het bestand (*File → Open SQL Script*), zet `USE ritmania;` bovenaan en klik op de bliksem ⚡. Controleer met `SELECT * FROM MemoryUsage;`.

**Wat als het niet werkt?**
| Probleem | Oplossing |
|---|---|
| Rode melding *"running scripts is disabled on this system"* | Typ eerst `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` en druk op Enter. Start daarna het script opnieuw |
| *"The term … is not recognized"* | U staat niet in de juiste map. Typ `cd C:\Scripts` en probeer opnieuw. Vergeet `.\` vóór de naam niet |
| Het script stopt meteen | U heeft bij de vraag **9** gekozen. Start opnieuw en kies 1 of 2 |
| Het bestand opent niet | Typ **y** (kleine letter). Het bestand staat ook op de getoonde locatie; open het met Kladblok |
| MySQL geeft een fout bij de laatste regel | Vervang de **komma** aan het eind van de laatste regel door een **puntkomma** `;` |

---

## Voorbeeld 2: korte instructie (in de mail zelf)

> **Zo gebruikt u het script**
> 1. Open PowerShell als administrator en ga naar de map met het script: `cd C:\Scripts`
> 2. Start het script: `.\MonitorFreeMemory-Kyan.ps1 60 Meting.txt` (60 = aantal seconden, Meting.txt = naam van het bestand). Zonder getallen meet het 5 seconden in Results.txt.
> 3. Bestaat het bestand al? Kies **1** (toevoegen), **2** (opnieuw beginnen) of **9** (stoppen).
> 4. Wacht tot het meten klaar is. Kies daarna **y** om het bestand te openen of **n** om het niet te openen.
>
> Krijgt u een melding dat scripts zijn uitgeschakeld? Typ dan eerst `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`.

---

## Voorbeeld 3: instructie als "snelstartkaart"

| Ik wil… | Typ dit |
|---|---|
| standaard meten (5 sec, Results.txt) | `.\MonitorFreeMemory-Kyan.ps1` |
| 1 minuut meten | `.\MonitorFreeMemory-Kyan.ps1 60 Results.txt` |
| meten in een nieuw bestand | `.\MonitorFreeMemory-Kyan.ps1 30 Meting-maandag.txt` |
| metingen toevoegen aan een bestaand bestand | start het script met die bestandsnaam → kies **1** |
| een bestaand bestand overschrijven | start het script met die bestandsnaam → kies **2** |
| stoppen zonder te meten | kies **9** bij de vraag |
| het resultaat openen | kies **y** aan het eind |

---

## Voorbeeld 4: instructie voor een ander script (CPU-monitor met grenswaarde)

### Instructie: CPU-monitor (Monitor-Cpu.ps1)
1. Open **PowerShell als administrator** en ga naar de map: `cd C:\Scripts`
2. Start het script met het aantal seconden en een bestandsnaam:
   ```powershell
   .\Monitor-Cpu.ps1 120 CpuResults.txt
   ```
3. Bestaat het bestand al? Kies **1** (toevoegen), **2** (overschrijven) of **9** (stoppen).
4. Tijdens het meten ziet u elke 3 seconden de processorbelasting in procenten. Komt die **boven 80%**, dan verschijnt er een **rode waarschuwing**. U hoeft niets te doen.
5. Na afloop ziet u waar het bestand staat en hoe vaak de grens werd overschreden. Kies **y** om het bestand te openen.

> **Grenswaarde aanpassen?** Open het script in Kladblok of VS Code, zoek bovenaan de regel `$Threshold = 80` en verander het getal. Sla op en start opnieuw.

---

## Voorbeeld 5: instructie voor de beheerder (installatie + technisch)
*Voor een collega-beheerder mag het iets technischer.*

**Installatie**
1. Kopieer `MonitorFreeMemory-Kyan.ps1` naar `C:\Scripts` op de server.
2. Controleer de execution policy: `Get-ExecutionPolicy`. Advies: `Set-ExecutionPolicy RemoteSigned` (lokale scripts mogen draaien).
3. Test: `.\MonitorFreeMemory-Kyan.ps1 5 test.txt` en kies **n** aan het eind.

**Automatisch laten draaien** (optioneel, via Taakplanner)
- Programma: `powershell.exe`
- Argumenten: `-ExecutionPolicy Bypass -File C:\Scripts\MonitorFreeMemory-Kyan.ps1 300 Results.txt`
- Let op: het script stelt vragen (1/2/9 en y/n). Voor automatisch draaien moeten die vragen eerst uit het script worden gehaald.

**Uitvoer**
- Tekstbestand met `DELETE FROM MemoryUsage WHERE ID > 0;`, `INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES` en per meting `('HOST',KB,yyyyMMddHHmmss),`
- Vrij geheugen in **KB**, datum als `yyyyMMddHHmmss`

---

## Sjabloon: zelf invullen
```text
Instructie: <naam script>
Versie <x> · <datum> · <jouw naam>, <bedrijf>

Waar is dit script voor?
<1-2 zinnen in gewone taal>

Wat heb je nodig?
- <Windows/PowerShell, map, rechten>

Het script starten
1. <PowerShell openen als administrator>
2. <cd naar de map>
3. <startcommando + uitleg van de argumenten>

Vragen tijdens het script
4. <vraag 1: wat kun je kiezen en wat gebeurt er>
5. <…>

Resultaat
6. <waar staat het bestand, wat zie je>

Wat als het niet werkt?
<probleem> → <oplossing>
```
