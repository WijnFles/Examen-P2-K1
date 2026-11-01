# 03 · Script uitvoeren, testen en documenteren

Van de 15 punten voor W2 gaan er **6** over het opleveren en uitleggen, niet over het typen:
- *Script werkend opgeleverd* (3)
- *Documentatie technisch op niveau, volledig en correct* (3)

Er moet een document komen **met screenshots van je testen en wat je zag (bevindingen)**.

---

## 1. Het script klaarzetten (zoals de opdracht vraagt)
1. Download `MonitorFreeMemory - opdracht.ps1`.
2. Zet het in een **logische map**, bijvoorbeeld `C:\Scripts\` of `C:\Users\Administrator\Documents\Examen\`. Maak een screenshot van de map.
3. Hernoem het naar **`MonitorFreeMemory-Kyan.ps1`**.
4. Open het in **Visual Studio Code**: rechtsklik → *Open with Code*, of in VS Code *File → Open File*.
5. Pas de header aan: zet bij **Auteur**/**Aangepast** je naam, de datum en een hogere versie (1.1).

## 2. Het script uitvoeren
**Manier A: F5 in VS Code.** Dit draait het script **zonder argumenten**, dus met de defaults.

**Manier B: in de terminal van VS Code, met argumenten.** Ga eerst naar de map en start het script:
```powershell
cd C:\Scripts
.\MonitorFreeMemory-Kyan.ps1                    # zonder argumenten (defaults)
.\MonitorFreeMemory-Kyan.ps1 10 test.txt        # 10 seconden, bestand test.txt
.\MonitorFreeMemory-Kyan.ps1 60 Results.txt     # voor W3: minimaal 60 seconden!
```
> ⚠️ Een fout als *"running scripts is disabled on this system"*? Typ dan eerst:
> ```powershell
> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
> ```
> Dit geldt alleen voor dit terminalvenster en is veilig.

> ⚠️ Rode tekst bij het starten? Lees de **regelnummer** in de foutmelding (`At line:42 char:5`) en kijk daar. Meestal mist er een `}` of `)`, of is een variabelenaam fout gespeld.

## 3. Testplan: deze tests moet je doen
Doe elke test, maak een **screenshot** en vul de tabel in je documentatie in.

| # | Test | Hoe | Verwacht resultaat |
|---|---|---|---|
| 1 | Zonder argumenten, bestand bestaat niet | `.\MonitorFreeMemory-Kyan.ps1` | Defaults worden gebruikt (5 sec, Results.txt), nieuw bestand met DELETE + INSERT + metingen |
| 2 | Met argumenten | `.\MonitorFreeMemory-Kyan.ps1 10 Test.txt` | Meting duurt 10 sec, bestand Test.txt wordt gemaakt |
| 3 | Bestand bestaat, ongeldige keuze | start opnieuw, typ `5`, dan `x` | De vraag wordt herhaald |
| 4 | Keuze 1 (aanvullen) | typ `1` | Nieuwe metingen komen **onder** de oude |
| 5 | Keuze 2 (overschrijven) | typ `2` | Oude metingen weg, bestand begint opnieuw met DELETE + INSERT |
| 6 | Keuze 9 (stoppen) | typ `9` | Script stopt, er wordt niets gemeten |
| 7 | Openen: ongeldig antwoord | typ `a` | De vraag wordt herhaald |
| 8 | Openen: y | typ `y` | Bestand opent in Kladblok |
| 9 | Openen: n | typ `n` | Passende melding |
| 10 | Eindmelding | | "Script finished at" + datum/tijd |
| 11 | Inhoud bestand | open het bestand | Juiste SQL: `('HOST',getal,datum),` per regel |
| 12 | (voor W3) 60 seconden | `.\MonitorFreeMemory-Kyan.ps1 60 Results.txt` | ±20 metingen (1 per 3 sec) |

### Bevindingen opschrijven
Schrijf bij elke test op **wat je zag** en of het **klopt**. Voorbeeld:

| Test | Resultaat | Bevinding |
|---|---|---|
| 3 | Na "5" en "x" werd opnieuw gevraagd, "1" werd geaccepteerd | ✅ Invoerlus werkt |
| 11 | Laatste regel eindigt op `,` | ⚠️ Moet `;` zijn voor MySQL. Bij W3 met de hand aangepast (of opgelost met code, zie 02) |
| 1 | Melding zegt "free **virtual** memory", maar er wordt **physical** gemeten | ⚠️ Tekst klopt niet helemaal, aangepast naar "free memory" |

> 💡 Bevindingen = ook dingen die **niet goed** gingen en hoe je ze hebt opgelost. Dat laat zien dat je echt getest hebt. Een fout die je zelf vond en oploste is een **plus**, geen min.

## 4. Documentatie: opzet (kopieer in Word)

```
Documentatie MonitorFreeMemory-Kyan.ps1
Naam: Kyan Wossink        Datum: 2-11-2026        Versie: 1.1

1. Doel van het script
   Het script meet gedurende een op te geven aantal seconden het vrije fysieke geheugen
   van de machine en schrijft de metingen weg als SQL-query (DELETE + INSERT) in een
   tekstbestand. Met dat bestand wordt de tabel MemoryUsage in MySQL gevuld.

2. Gebruik
   .\MonitorFreeMemory-Kyan.ps1 [aantal seconden] [naam resultaatbestand]
   Voorbeeld: .\MonitorFreeMemory-Kyan.ps1 60 Results.txt
   Zonder argumenten: 5 seconden en Results.txt.

3. Werking per stap (koppeling met de flowchart)
   Stap 1  Default variabelen: $seconds, $ResultFile, $MachineName
   Stap 2  Argumenten controleren met $args[0] -is [int] / $args[1] -is [string]
   Stap 3  Test-Path: bestaat het bestand? Menu 1/2/9 met invoerlus (while)
   Stap 4  Stoptijd = nu + aantal seconden
   Stap 5  Scherm leeg (clear) en melding
   Stap 6  While-lus tot de stoptijd: Get-CimInstance Win32_OperatingSystem,
           Add-Content naar het bestand, Write-Host op het scherm, aftellen 3-2-1
   Stap 7  Scherm leeg, pad tonen ($pwd\$ResultFile)
   Stap 8  Invoerlus y/n, Invoke-Item opent het bestand
   Stap 9  Eindmelding met Get-Date

4. Wat heb ik aangevuld (per gat)
   Regel 18-20: default variabelen ...
   Regel 23-24: argumenten ...
   (enz.: kort, per gat: wat en waarom)

5. Gebruikte basisconcepten
   - Variabelen: $seconds, $ResultFile, ...
   - Sequentie: stappen 1 t/m 9 worden na elkaar uitgevoerd
   - Selectie (conditionals): if/else bij Test-Path, keuze 2/9, y/n
   - Iteratie (loops): while-lus voor de meting, while-invoerlussen, for-lus voor de streep
   - Algoritme: stoptijd berekenen en vergelijken met de huidige tijd

6. Testen
   (tabel uit §3 met screenshots en bevindingen)

7. Resultaat
   Screenshot van het resultatenbestand in Kladblok.
```

> **Waarom punt 5?** Het criterium zegt letterlijk: *"Basisconcepten (sequenties, loops, variabelen, algoritmes, conditionals) zijn toegepast en er is duidelijk te zien dat deze begrepen worden."* Als je ze **bij naam noemt** met een voorbeeld uit je script, ziet de beoordelaar dat je ze begrijpt.

## 5. Screenshots: checklist
- [ ] Map met het hernoemde script
- [ ] Script in VS Code (het aangevulde deel)
- [ ] Elke test uit het testplan (terminal)
- [ ] Inhoud van het resultatenbestand
- [ ] Eventuele foutmelding + de oplossing

Snelle screenshot: **Win + Shift + S**, dan plakken in Word met **Ctrl + V**.
