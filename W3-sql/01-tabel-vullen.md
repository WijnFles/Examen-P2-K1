# 01 · Tabel vullen met het resultatenbestand (opdracht 3.1)

## De stappen
### 1. Script minimaal 60 seconden laten draaien
```powershell
.\MonitorFreeMemory-Kyan.ps1 60 Results.txt
```
Elke 3 seconden een meting, dus ongeveer **20 regels**. 📸 Screenshot van de terminal.

### 2. Resultatenbestand naar de MySQL-server kopiëren
Kies wat werkt in jouw omgeving:
- **Via Remote Desktop:** kopieer het bestand op de ene machine (Ctrl+C) en plak het op de server (Ctrl+V). RDP deelt het klembord.
- **Via een netwerkpad:** in Verkenner `\\<servernaam>\c$\Temp` → plakken.
- **Met PowerShell:** `Copy-Item .\Results.txt \\<servernaam>\c$\Temp\`
- Draait MySQL op **dezelfde** machine? Dan hoef je niets te kopiëren.

📸 Screenshot van het bestand op de server (Verkenner).

### 3. Query uitvoeren in MySQL Workbench
1. Open Workbench en maak verbinding met de server.
2. **File → Open SQL Script…** → kies `Results.txt` (zet het bestandstype op *All Files*). Je kunt de inhoud ook in Kladblok kopiëren en in een nieuw query-tabblad plakken.
3. Zet **bovenaan** de database erbij:
   ```sql
   USE ritmania;
   ```
4. **Herstel de laatste regel:** het script van de docent eindigt op een **komma**. Dat moet een **puntkomma** zijn:
   ```text
   ('SRV01',4555548,20261013135115),    ← FOUT, geeft Error 1064
   ('SRV01',4555548,20261013135115);    ← GOED
   ```
5. Klik op ⚡ (alles uitvoeren). In **Output** moet staan: `DELETE … x row(s) affected` en `INSERT … 20 row(s) affected Records: 20`.

📸 Screenshot van de query + Output.

### 4. Controleren
```sql
SELECT * FROM MemoryUsage;
```
Het aantal rijen moet gelijk zijn aan het aantal metingen. 📸 Screenshot van de Result Grid.

### 5. Herstellen indien nodig
Dit is waar de punten zitten: **laat zien dat je fouten herkent en oplost.**

| Wat zie je? | Oorzaak | Herstel |
|---|---|---|
| **Error 1064** … near '' at line … | Laatste regel eindigt op `,` | `,` → `;` |
| **Error 1046** No database selected | Geen database gekozen | `USE ritmania;` bovenaan, of dubbelklik *ritmania* links |
| **Error 1146** Table 'ritmania.memoryusage' doesn't exist | Tabel bestaat nog niet | Tabel aanmaken (zie hieronder) |
| Bij keuze **1 (aanvullen)** staat er een `,` midden in het bestand en daarna nog meer regels | Twee keer gemeten in hetzelfde bestand | Alleen de **allerlaatste** regel krijgt `;`. Tussenliggende regels houden hun `,` (één grote INSERT) |
| Datum is `0000-00-00` of `NULL` | Datumformaat klopt niet | Het script moet `yyyyMMddHHmmss` of `'yyyy-MM-dd HH:mm:ss'` (met quotes) schrijven |
| Er staan **dubbele** rijen in | Query twee keer uitgevoerd zonder DELETE ervoor | `DELETE FROM MemoryUsage WHERE ID > 0;` en opnieuw uitvoeren |
| Tabel leeg na uitvoeren | Alleen de DELETE is uitgevoerd (cursor stond op regel 1, Ctrl+Enter) | Alles selecteren (Ctrl+A) en de **grote** ⚡ gebruiken |

Tabel aanmaken als die ontbreekt:
```sql
CREATE DATABASE IF NOT EXISTS ritmania;
USE ritmania;
CREATE TABLE IF NOT EXISTS MemoryUsage (
  ID         INT AUTO_INCREMENT PRIMARY KEY,
  Hostname   VARCHAR(50),
  FreeMemory INT,
  Date       DATETIME
);
```

> 💡 **In je documentatie:** "Bij het uitvoeren gaf MySQL Error 1064, omdat de laatste regel op een komma eindigde. Dat komt doordat het script na elke meting `),` wegschrijft. Ik heb de laatste komma vervangen door een puntkomma, waarna 20 records zijn toegevoegd." **Dit is precies wat "herstel indien nodig" bedoelt.**
