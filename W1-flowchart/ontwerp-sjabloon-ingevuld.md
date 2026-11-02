Aanleiding
Bedrijven willen steeds meer hun processen automatiseren om tijd te besparen. Deze besparing van tijd gebeurt vaak door scripting. Het bedrijf PurpleIT wil scripting inzetten om het eigen HR-proces te automatiseren.


Wensen en eisen van het script
De servicedesk krijgt iedere maand een lijst met nieuwe medewerkers van HR. Deze lijst moet automatisch worden ingelezen in de Active Directory. Dit moet op een gestandaardiseerde manier gebeuren. Omdat het om een geautomatiseerd proces gaat, is het belangrijk dat het script goed wordt getest. Fouten moeten worden afgevangen voordat ze worden verwerkt in het systeem. 
Het script kent drie belangrijke fases met daarin elk de wensen en eisen:

Initialisatiefase

De initialisatiefase is een essentieel onderdeel van een script dat voorafgaand aan de uitvoeringfase controleert of alle vereiste versies, modules en bestanden aanwezig zijn. Het dient als een voorbereidende stap om ervoor te zorgen dat het script zonder problemen kan worden uitgevoerd en dat alle benodigde middelen beschikbaar zijn.

Het is noodzakelijk om aan de beheerder te vragen of het script kan worden uitgevoerd met een input van “ja” of “nee”. Indien nee, dan wordt het script direct gestopt.

PurpleIT gebruikt de meest recente versie van PowerShell. Om dit waar te maken, moet het script beginnen met een controle op PowerShell versie 7 of nieuwer voordat het verdergaat met de uitvoering.

Het bronbestand met gebruikers wordt op een vooraf bepaalde locatie in een vaste directory geplaatst en dient te worden gecontroleerd op aanwezigheid door het script. Op deze manier kan het script ervoor zorgen dat het bronbestand beschikbaar is voordat het script verder gaat met de uitvoering. 

Het script is afhankelijk van de Active Directory PowerShell Module en kan niet worden uitgevoerd zonder deze module. Daarom is het belangrijk om te controleren of de module aanwezig is, voordat het script verder kan gaan met de uitvoering. 

Alle foutmeldingen in de initalisatiefase moet het script direct stoppen. De beheerder die het script uitvoert, moet passende meldingen te zien krijgen als er foutmeldingen zijn gevonden.

Uitvoeringsfase

In deze fase worden de acties uitgevoerd en worden gebruikers ingelezen in Active Directory. 

Het script leest gebruikers aan de hand van een .csv-bestand uit waarin de benodigde gegevens worden verzameld, zoals gebruikersnamen, wachtwoorden en e-mailadressen. Gebruikersnaam is altijd firstname+lastname zonder spatie.

Bestaande gebruikers mogen niet in de Active Directory worden ingelezen. Indien een bestaande gebruiker is gevonden, moet er een passende melding naar het logboek worden geschreven en een melding aan de beheerder.

In Active Directory zijn alle department’s in het csv-bestand aanwezig als Organizational Unit (OU). Als een bepaalde afdeling ontbreekt, genereert een script een foutmelding zowel naar de beheerder als in het logboek.

Elke nieuwe aangemaakte gebruiker krijgt in een standaard wachtwoord mee. Deze nieuwe ingelezen gebruikers in Active Directory moeten na de eerste keer inloggen, direct hun wachtwoord wijzigen.

Het moet voor de beheerder eenvoudig zijn om alle foutmeldingen terug te lezen uit het logboek. Alle meldingen zijn duidelijk omschreven voor de beheerder.

Afrondingsfase

Het script geeft een gepaste melding aan de beheerder en registreert deze tevens in het logboek. Op deze manier wordt de beheerder geïnformeerd dat het script is afgerond.

Randvoorwaarden
Het script moet uitgebreid worden getest op mogelijke fouten die door verschillende scenario’s kunnen optreden.
Het script moet in PowerShell 7 of nieuwer worden uitgevoerd.
De interactie met de beheerder gaat via PowerShell.
Visual Studio Code moet aanwezig zijn op de server (VM1).
Voor het testen maak je gebruik van de server (VM1).

Doel
Eisen en wensenvan de opdrachtgever
Plan van aanpak
<Beschrijf het Plan van Aanpak van deze opdracht.
Denk daarbij aan de volgende zaken:
-	Achtergrond
-	Aanleiding
-	Tussenresultaten
-	Eindresultaat
-	Borgen van de kwaliteit
-	etc.> 


Maak een ontwerp

# Sjabloon ontwerp: volledig ingevuld (Geheugenmonitor)

Dit is het **Sjabloon ontwerp** (Solar Plex Network) ingevuld voor de oefentoets. Op het examen neem je dezelfde opbouw over en pas je de namen en stappen aan.

> **Tip:** de kopjes zijn precies die van het sjabloon. Vervang alleen de tekst tussen `< >`.

---

## Doel
Het programma `MonitorFreeMemory.ps1` is een PowerShell-script dat gedurende een op te geven aantal seconden het **vrije fysieke geheugen** meet van de machine waarop het draait. Elke meting wordt weggeschreven in een tekstbestand, in de vorm van een SQL-query. Met dat bestand kan de tabel **MemoryUsage** in de MySQL-database gevuld worden. Zo kan het geheugengebruik van een server over een periode geanalyseerd worden.

**Eisen en wensen van de opdrachtgever** *(= criterium "Beginsituatie")*
1. Het script gebruikt default waarden voor het aantal seconden, de naam van het tekstbestand en de hostname.
2. De gebruiker kan het aantal seconden en de bestandsnaam als argument meegeven. Die vervangen dan de defaults.
3. Bestaat het tekstbestand al? Dan kiest de gebruiker: **aanvullen**, **overschrijven** of **stoppen**. Er wordt net zo lang gevraagd tot het antwoord geldig is.
4. Bestaat het bestand niet, of kiest de gebruiker overschrijven? Dan wordt een nieuw bestand gemaakt met de eerste regels van de SQL-query.
5. Het script meet tot een berekende stoptijd. Elke meting wordt op het scherm getoond en in het bestand geschreven.
6. Tijdens het meten ziet de gebruiker iets bewegends, zodat duidelijk is dat het script bezig is.
7. Na afloop ziet de gebruiker waar het bestand staat en kan hij kiezen of het geopend wordt (y/n, net zo lang vragen tot het antwoord geldig is).
8. Het script meldt dat het klaar is, met de tijd waarop het gestopt is.
9. De uitvoer moet een geldige SQL-query zijn voor de tabel MemoryUsage (Hostname, FreeMemory, Date).

## Aanpak
1. De beschrijving van het script helemaal gelezen en de signaalwoorden gemarkeerd: *controleer of* (keuze), *zolang / net zolang tot* (herhaling), *vraag / toon* (invoer/uitvoer), *bestand* (document).
2. Elke stap uit de beschrijving genummerd (1 t/m 9) en per stap bepaald of het een **sequentie**, **selectie** (keuze) of **iteratie** (herhaling) is.
3. Eerst een ruwe schets op papier gemaakt, daarna de flowchart gebouwd in **Visio online** met het sjabloon *Basisstroomdiagram*, van boven naar beneden.
4. Gekozen symbolen: ovaal = start/einde, rechthoek = proces, ruit = beslissing, parallellogram = invoer/uitvoer naar de gebruiker, document = bestand.
5. De flowchart **droog gedraaid** met drie scenario's (zie onder) om te controleren dat elk pad bij een Einde uitkomt en elke lus kan stoppen.

## Stroomdiagram
*(Plak hier je flowchart uit Visio: Ctrl+A → Ctrl+C in Visio → Ctrl+V in Word, of een screenshot met Win+Shift+S.)*

## Toelichting bij stappen stroomdiagram
1. **Start van het programma.**
2. **Definieer default variabelen.** Het aantal seconden (5), de naam van het resultatenbestand (Results.txt) en de hostname van de machine worden in variabelen gezet.
3. **Aantal seconden als argument opgegeven?** Er wordt gecontroleerd of de gebruiker bij het starten als eerste argument een aantal seconden heeft meegegeven (in het script: `$args[0]`). Zo ja, dan wordt de default waarde voor seconden vervangen.
4. **Naam van het bestand als argument opgegeven?** Er wordt gecontroleerd of de gebruiker als tweede argument een bestandsnaam heeft meegegeven (in het script: `$args[1]`). Zo ja, dan wordt de default bestandsnaam vervangen.
5. **Bestaat de results file al?** Zo nee: er wordt een nieuw bestand gemaakt en de eerste regels (`DELETE FROM MemoryUsage WHERE ID > 0;` en `INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES`) worden weggeschreven. Daarna gaat het script naar stap 9.
6. **Vraag gebruiker een optie te selecteren.** Het bestand bestaat al. De gebruiker kiest 1 (aanvullen), 2 (overschrijven) of 9 (stoppen).
7. **1 van de opties ingevoerd?** Is het antwoord geen 1, 2 of 9? Dan wordt de vraag opnieuw gesteld (invoerlus).
8. **Optie 2? / Optie 9?** Bij optie 2 wordt een nieuw bestand gemaakt met de eerste regels (overschrijven). Bij optie 9 stopt het script. Bij optie 1 gaat het script verder, en worden de nieuwe metingen onderaan het bestaande bestand toegevoegd.
9. **Bepaal de stoptijd.** De stoptijd = huidige tijd + het aantal seconden.
10. **Maak scherm leeg en toon wat er gaat gebeuren.** Bijvoorbeeld: *Checking free memory on SRV01 for 60 seconds*.
11. **Haal vrije geheugen op, toon op scherm en schrijf weg.** Het vrije fysieke geheugen (in KB) wordt opgehaald, op het scherm getoond en als SQL-regel `('SRV01',4543524,20261102091503),` aan het bestand toegevoegd.
12. **Toon iets 'bewegends'.** Een aftelling (3, 2, 1) laat zien dat het script bezig is. Dit duurt 3 seconden, dus er wordt elke 3 seconden gemeten.
13. **Stoptijd bereikt?** Nee: terug naar stap 11 (herhaling). Ja: door naar stap 14.
14. **Maak scherm schoon en toon waar de results file staat.** Het volledige pad wordt getoond.
15. **Vraag of de results file geopend moet worden.**
16. **Is het antwoord 'y' of 'n'?** Zo nee, wordt de vraag herhaald (invoerlus).
17. **Is het antwoord 'y'?** Ja: het bestand wordt geopend. Nee: er verschijnt een passende melding.
18. **Meld dat het script klaar is, inclusief de tijd.**
19. **Einde.**

## Input data
- Aantal seconden dat gemeten moet worden: default of als argument (stap 2, 3)
- Naam van het resultatenbestand: default of als argument (stap 2, 4)
- Hostname van de machine (stap 2)
- Keuze van de gebruiker: 1, 2 of 9 als het bestand al bestaat (stap 6, 7)
- Vrij fysiek geheugen van de machine, opgehaald uit Windows (stap 11)
- Huidige datum en tijd (stap 9, 11, 18)
- Antwoord van de gebruiker: y of n, bestand openen (stap 15, 16)

## Output data
- Waarschuwing dat het bestand al bestaat + de opties 1, 2 en 9 (stap 6)
- Tekstbestand met de eerste regels van de SQL-query (stap 5, 8)
- Melding wat er gaat gebeuren (stap 10)
- Per meting: vrij geheugen op het scherm + een SQL-regel in het bestand (stap 11)
- Iets bewegends (aftellen) op het scherm (stap 12)
- Locatie van het resultatenbestand (stap 14)
- Het geopende bestand, of een passende melding (stap 17)
- Melding dat het script klaar is + de tijd (stap 18)

## Resultaat uitvoer
*Schermvoorbeelden van wat het script gaat tonen:*

- Bestand bestaat al (stap 6)
  ```
  WARNING: Results.txt already exists. What do you want to do?
  [1] Add the results to this file
  [2] Delete it and start with an empty one
  [9] Quit
  Please make your choice: 5
  Please make your choice: 2
  ```
- Start van het meten (stap 10)
  ```
  Checking free memory on SRV01 for 60 seconds
  ============================================
  ```
- Tijdens het meten (stap 11, 12)
  ```
  Free memory at 02-11-2026 09:15:03: 4543524
  Free memory at 02-11-2026 09:15:06: 4535680
  > Next check in 2
  ```
- Na het meten (stap 14, 15, 18)
  ```
  Monitoring process is done. Results can be found in C:\Scripts\Results.txt
  Do you want to open it (y/n)?: n
  OK, the file will not be opened.
  ================================
  Script finished at 02-11-2026 09:16:03
  ```
- Inhoud van het resultatenbestand
  ```sql
  DELETE FROM MemoryUsage WHERE ID > 0;
  INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES
  ('SRV01',4543524,20261102091503),
  ('SRV01',4535680,20261102091506),
  ```

## Droog gedraaid (controle van het ontwerp)
| Scenario | Pad door de flowchart | Klopt? |
|---|---|---|
| A: geen argumenten, bestand bestaat niet | Start → defaults → 2× Nee → Bestaat? Nee → nieuw bestand → stoptijd → lus tot stoptijd → pad tonen → "y" → openen → klaar → Einde | ✅ |
| B: bestand bestaat, gebruiker typt "x" en daarna "2" | … → Bestaat? Ja → vraag → ongeldig → **terug naar de vraag** → "2" → Optie 2? Ja → nieuw bestand → stoptijd → … | ✅ |
| C: bestand bestaat, gebruiker typt "9" | … → vraag → "9" → Optie 2? Nee → Optie 9? Ja → **Stop script** | ✅ |
