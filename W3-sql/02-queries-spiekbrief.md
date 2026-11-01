# 02 · SQL-spiekbrief: alle queries

**Zo gebruik je dit:** lees de vraag → zoek in tabel 0 welk onderdeel je nodig hebt → pak het **sjabloon** → vul de tabel- en kolomnamen in.

- Grijze blokken met `<…>` zijn **sjablonen**: vervang alles tussen `< >`.
- Blokken met **SQL-kleuren** zijn **echte voorbeelden**. Ze zijn allemaal getest op de oefendatabases [ritmania](oefen-databases/ritmania.sql) en [world-mini](oefen-databases/world-mini.sql).

> Hoofdletters maken in SQL niet uit: `select` = `SELECT`. Tabelnamen soms wel (op Linux-servers). Neem ze dus over zoals ze in de Navigator links in Workbench staan.

---

## 0. Welk stukje SQL hoort bij welke woorden in de vraag?

| De vraag zegt… | Je gebruikt | Zie |
|---|---|---|
| "Laat **alle velden** zien" | `SELECT *` | [§1](#1-select-velden-laten-zien) |
| "Laat de velden **x en y** zien" | `SELECT x, y` | [§1](#1-select-velden-laten-zien) |
| "**waarvoor geldt dat** …", "**met** …", "**alleen** …" | `WHERE` | [§2](#2-where-filteren) |
| "**hoger/groter dan**", "**lager/kleiner dan**" | `WHERE kolom > getal` / `<` | [§2](#2-where-filteren) |
| "**tussen** x en y" | `BETWEEN x AND y` | [§2](#2-where-filteren) |
| "**begint met**", "**bevat**", "**eindigt op**" | `LIKE 'A%'` / `'%A%'` / `'%A'` | [§2](#2-where-filteren) |
| "**is leeg** / heeft geen waarde" | `IS NULL` | [§2](#2-where-filteren) |
| "**sorteer** van laag naar hoog" | `ORDER BY kolom ASC` | [§3](#3-order-by-en-limit-sorteren-en-beperken) |
| "**sorteer** van hoog naar laag" | `ORDER BY kolom DESC` | [§3](#3-order-by-en-limit-sorteren-en-beperken) |
| "de **5 hoogste**", "de **laatste**", "de **eerste 10**" | `ORDER BY … DESC LIMIT 5` | [§3](#3-order-by-en-limit-sorteren-en-beperken) |
| "**unieke** / **verschillende** waarden" | `SELECT DISTINCT` | [§1](#1-select-velden-laten-zien) |
| "het **aantal**", "**hoeveel**" | `COUNT(*)` | [§4](#4-berekenen-count-sum-avg-min-max) |
| "het **gemiddelde**" | `AVG(kolom)` | [§4](#4-berekenen-count-sum-avg-min-max) |
| "het **totaal**", "**opgeteld**" | `SUM(kolom)` | [§4](#4-berekenen-count-sum-avg-min-max) |
| "de **hoogste** / **laagste** waarde" | `MAX(kolom)` / `MIN(kolom)` | [§4](#4-berekenen-count-sum-avg-min-max) |
| "**per** host", "**per** land", "**per** continent" | `GROUP BY` | [§5](#5-group-by-per-groep-en-having) |
| "per … **met meer dan** x" (filter op een telling/gemiddelde) | `HAVING COUNT(*) > x` | [§5](#5-group-by-per-groep-en-having) |
| "**groter/kleiner dan het gemiddelde**" | subquery `WHERE x < (SELECT AVG(x) FROM …)` | [§6](#6-subqueries-een-query-in-een-query) |
| "**niet** in tabel B **voorkomt**" | `WHERE code NOT IN (SELECT … FROM B)` of `LEFT JOIN … IS NULL` | [§6](#6-subqueries-een-query-in-een-query) / [§7](#7-join-twee-tabellen-combineren) |
| gegevens uit **twee tabellen** | `JOIN … ON` | [§7](#7-join-twee-tabellen-combineren) |
| "**voeg toe**", "nieuw record" | `INSERT INTO` | [§9](#9-insert-record-toevoegen) |
| "**wijzig**", "**pas aan**", "verhoog" | `UPDATE … SET … WHERE` | [§10](#10-update-gegevens-wijzigen) |
| "**verwijder**" | `DELETE FROM … WHERE` | [§11](#11-delete-records-verwijderen) |
| "**datum**", "vandaag", "in oktober", "na 14:00" | datumfuncties | [§8](#8-datum-en-tijd) |
| "**gebruiker** aanmaken", "**rechten**" | `CREATE USER` / `GRANT` | [03-autorisatie.md](03-autorisatie.md) |

### De volgorde ligt VAST
```text
SELECT    <kolommen>          -- 1. wat wil je zien
FROM      <tabel>             -- 2. uit welke tabel
JOIN      <tabel2> ON <…>     -- 3. (optioneel) tweede tabel erbij
WHERE     <voorwaarde>        -- 4. (optioneel) welke RIJEN
GROUP BY  <kolom>             -- 5. (optioneel) per groep
HAVING    <voorwaarde>        -- 6. (optioneel) welke GROEPEN
ORDER BY  <kolom> ASC|DESC    -- 7. (optioneel) sorteren
LIMIT     <aantal>;           -- 8. (optioneel) maximaal x rijen
```
Ezelsbruggetje: **S**ommige **F**ietsers **J**agen **W**eer **G**roepen **H**onden **O**p **L**ater.

---

## 1. SELECT: velden laten zien
```text
SELECT * FROM <tabel>;                                    -- alle velden
SELECT <kolom1>, <kolom2> FROM <tabel>;                   -- alleen deze velden
SELECT <kolom> AS <nieuwe_naam> FROM <tabel>;             -- kolom een andere naam geven
SELECT DISTINCT <kolom> FROM <tabel>;                     -- elke waarde maar 1 keer
```
```sql
SELECT * FROM MemoryUsage;
SELECT Hostname, FreeMemory FROM MemoryUsage;
SELECT Date AS Tijdstip, FreeMemory AS VrijKB FROM MemoryUsage;
SELECT DISTINCT Hostname FROM MemoryUsage;
SELECT Hostname, FreeMemory / 1024 AS VrijMB FROM MemoryUsage;     -- rekenen mag in de SELECT
SELECT Name, Population FROM country;
```

---

## 2. WHERE: filteren
```text
SELECT <kolommen> FROM <tabel> WHERE <kolom> <operator> <waarde>;
```
| Operator | Betekent | Voorbeeld |
|---|---|---|
| `=` | gelijk aan | `WHERE Hostname = 'SRV01'` |
| `<>` of `!=` | niet gelijk aan | `WHERE Hostname <> 'SRV01'` |
| `>` `<` | groter / kleiner dan | `WHERE FreeMemory > 5000000` |
| `>=` `<=` | groter/kleiner **of gelijk** | `WHERE Population >= 1000000` |
| `BETWEEN a AND b` | tussen a en b (**inclusief** a en b) | `WHERE FreeMemory BETWEEN 4500000 AND 5000000` |
| `IN (…)` | één van deze | `WHERE Code IN ('NLD','BEL','DEU')` |
| `NOT IN (…)` | geen van deze | `WHERE Continent NOT IN ('Europe','Asia')` |
| `LIKE 'A%'` | begint met A | `WHERE Name LIKE 'A%'` |
| `LIKE '%a'` | eindigt op a | `WHERE Name LIKE '%land'` |
| `LIKE '%an%'` | bevat "an" | `WHERE Name LIKE '%an%'` |
| `LIKE '_a%'` | 2e letter is a (`_` = precies 1 teken) | `WHERE Name LIKE '_a%'` |
| `IS NULL` | heeft **geen** waarde | `WHERE IndepYear IS NULL` |
| `IS NOT NULL` | heeft **wel** een waarde | `WHERE LifeExpectancy IS NOT NULL` |
| `AND` | beide moeten waar zijn | `WHERE Continent = 'Europe' AND Population > 50000000` |
| `OR` | één van beide is genoeg | `WHERE Code = 'NLD' OR Code = 'BEL'` |
| `NOT` | omdraaien | `WHERE NOT Continent = 'Europe'` |

> ⚠️ **Tekst en datums tussen 'enkele quotes'**, getallen **zonder** quotes: `'SRV01'`, `'2026-10-13'`, `5000000`
> ⚠️ **Nooit `= NULL`**, altijd `IS NULL`.
> ⚠️ AND en OR samen? **Zet haakjes**: `WHERE (Continent='Europe' OR Continent='Asia') AND Population > 100000000`

```sql
SELECT Date, FreeMemory FROM MemoryUsage WHERE FreeMemory > 5000000;
SELECT * FROM MemoryUsage WHERE Hostname = 'SRV01';
SELECT * FROM MemoryUsage WHERE Hostname = 'SRV01' AND FreeMemory < 4600000;
SELECT * FROM MemoryUsage WHERE FreeMemory BETWEEN 4500000 AND 5000000;
SELECT * FROM MemoryUsage WHERE Hostname IN ('SRV01', 'SRV02');
SELECT * FROM MemoryUsage WHERE Hostname LIKE 'SRV%';
SELECT Name, Continent FROM country WHERE (Continent = 'Europe' OR Continent = 'Asia') AND Population > 50000000;
SELECT Name FROM country WHERE IndepYear IS NULL;
```

---

## 3. ORDER BY en LIMIT: sorteren en beperken
```text
... ORDER BY <kolom> ASC;              -- laag → hoog, A → Z, oud → nieuw  (ASC is standaard)
... ORDER BY <kolom> DESC;             -- hoog → laag, Z → A, nieuw → oud
... ORDER BY <kolom1> ASC, <kolom2> DESC;   -- eerst op kolom1, bij gelijke waarde op kolom2
... LIMIT <aantal>;                    -- maximaal zoveel rijen
```
```sql
SELECT Hostname, FreeMemory FROM MemoryUsage ORDER BY FreeMemory ASC;     -- oefentoets vraag 2
SELECT Hostname, FreeMemory FROM MemoryUsage ORDER BY FreeMemory DESC;
SELECT * FROM MemoryUsage ORDER BY Hostname ASC, Date DESC;
SELECT * FROM MemoryUsage ORDER BY FreeMemory DESC LIMIT 5;               -- de 5 hoogste
SELECT * FROM MemoryUsage ORDER BY ID DESC LIMIT 1;                       -- het laatst toegevoegde record
SELECT * FROM MemoryUsage ORDER BY Date ASC LIMIT 1;                      -- de eerste meting
SELECT Name, Population FROM city ORDER BY Population DESC LIMIT 3;       -- 3 grootste steden
```

---

## 4. Berekenen: COUNT, SUM, AVG, MIN, MAX
Dit zijn **aggregatiefuncties**: ze maken van veel rijen één getal.

| Functie | Betekent | Sjabloon |
|---|---|---|
| `COUNT(*)` | aantal rijen | `SELECT COUNT(*) FROM <tabel>` |
| `COUNT(<kolom>)` | aantal rijen waar kolom **niet NULL** is | `SELECT COUNT(IndepYear) FROM country` |
| `COUNT(DISTINCT <kolom>)` | aantal **verschillende** waarden | `SELECT COUNT(DISTINCT Hostname) FROM MemoryUsage` |
| `SUM(<kolom>)` | totaal | `SELECT SUM(<kolom>) FROM <tabel>` |
| `AVG(<kolom>)` | gemiddelde | `SELECT AVG(<kolom>) FROM <tabel>` |
| `MIN(<kolom>)` | laagste | `SELECT MIN(<kolom>) FROM <tabel>` |
| `MAX(<kolom>)` | hoogste | `SELECT MAX(<kolom>) FROM <tabel>` |
| `ROUND(x, 2)` | afronden op 2 decimalen | `SELECT ROUND(AVG(<kolom>), 2) FROM <tabel>` |

```sql
SELECT COUNT(*) AS AantalMetingen FROM MemoryUsage;
SELECT COUNT(*) FROM MemoryUsage WHERE Hostname = 'SRV01';           -- met WHERE: tel alleen SRV01
SELECT COUNT(DISTINCT Hostname) AS AantalHosts FROM MemoryUsage;
SELECT AVG(FreeMemory) AS Gemiddelde FROM MemoryUsage;
SELECT ROUND(AVG(FreeMemory)) AS Gemiddelde FROM MemoryUsage;
SELECT MIN(FreeMemory) AS Laagste, MAX(FreeMemory) AS Hoogste FROM MemoryUsage;
SELECT MIN(Date) AS EersteMeting, MAX(Date) AS LaatsteMeting FROM MemoryUsage;
SELECT SUM(Population) AS InwonersEuropa FROM country WHERE Continent = 'Europe';
```
> ⚠️ Een aggregatiefunctie mag **niet** in de WHERE: `WHERE FreeMemory < AVG(FreeMemory)` werkt **niet**. Gebruik een subquery ([§6](#6-subqueries-een-query-in-een-query)).

---

## 5. GROUP BY (per groep) en HAVING
**"Per …"** in de vraag = `GROUP BY`. Elke kolom in de SELECT die **geen** COUNT/AVG/… is, moet ook in de GROUP BY.

```text
SELECT <groepkolom>, COUNT(*) | AVG(<kolom>) | …
FROM <tabel>
GROUP BY <groepkolom>;
```
```sql
SELECT Hostname, COUNT(*) AS Aantal FROM MemoryUsage GROUP BY Hostname;
SELECT Hostname, ROUND(AVG(FreeMemory)) AS Gemiddeld, MIN(FreeMemory) AS Laagste, MAX(FreeMemory) AS Hoogste
FROM MemoryUsage
GROUP BY Hostname;
SELECT DATE(Date) AS Dag, COUNT(*) AS Metingen FROM MemoryUsage GROUP BY DATE(Date);
SELECT Continent, COUNT(*) AS AantalLanden FROM country GROUP BY Continent ORDER BY AantalLanden DESC;
SELECT CountryCode, COUNT(*) AS AantalSteden, SUM(Population) AS Inwoners FROM city GROUP BY CountryCode;
```

### HAVING = WHERE voor groepen
Wil je filteren op een **uitkomst van COUNT/AVG/SUM**? Dan gebruik je **HAVING** (na GROUP BY).

```text
SELECT <groepkolom>, COUNT(*) FROM <tabel>
GROUP BY <groepkolom>
HAVING COUNT(*) > <getal>;
```
```sql
-- hosts met meer dan 5 metingen
SELECT Hostname, COUNT(*) AS Aantal FROM MemoryUsage GROUP BY Hostname HAVING COUNT(*) > 5;
-- hosts met gemiddeld meer dan 5 miljoen KB vrij
SELECT Hostname, AVG(FreeMemory) AS Gem FROM MemoryUsage GROUP BY Hostname HAVING AVG(FreeMemory) > 5000000;
-- landen met minstens 3 steden
SELECT CountryCode, COUNT(*) AS AantalSteden FROM city GROUP BY CountryCode HAVING COUNT(*) >= 3;
```

| | WHERE | HAVING |
|---|---|---|
| Filtert | losse **rijen** | **groepen** |
| Wanneer | **vóór** het groeperen | **na** het groeperen |
| COUNT/AVG/… erin? | ❌ nee | ✅ ja |
| Voorbeeld | `WHERE Hostname = 'SRV01'` | `HAVING COUNT(*) > 5` |

Allebei in één query:
```sql
SELECT Hostname, COUNT(*) AS Aantal
FROM MemoryUsage
WHERE FreeMemory > 4600000          -- eerst: alleen rijen boven 4,6 miljoen
GROUP BY Hostname                    -- dan: per host
HAVING COUNT(*) >= 5                 -- dan: alleen hosts met 5 of meer van die rijen
ORDER BY Aantal DESC;
```

---

## 6. Subqueries: een query in een query
Een subquery staat **tussen haakjes** en wordt **eerst** uitgevoerd.

### a) Vergelijken met het gemiddelde / maximum (oefentoets vraag 5)
```text
SELECT <kolommen> FROM <tabel>
WHERE <kolom> < (SELECT AVG(<kolom>) FROM <tabel>);      -- kleiner dan gemiddelde
                >                                           -- groter dan gemiddelde
                = (SELECT MAX(<kolom>) FROM <tabel>)        -- de hoogste
```
```sql
SELECT Date, FreeMemory FROM MemoryUsage WHERE FreeMemory < (SELECT AVG(FreeMemory) FROM MemoryUsage);
SELECT Date, FreeMemory FROM MemoryUsage WHERE FreeMemory > (SELECT AVG(FreeMemory) FROM MemoryUsage);
SELECT * FROM MemoryUsage WHERE FreeMemory = (SELECT MAX(FreeMemory) FROM MemoryUsage);
SELECT Name, Population FROM city WHERE Population > (SELECT AVG(Population) FROM city);
```
> 💡 **Tip voor de documentatie:** voer eerst de subquery **los** uit (`SELECT AVG(FreeMemory) FROM MemoryUsage;`) en maak er een screenshot van. Dan laat je zien dat de uitkomst klopt. Kyan deed dit al in de oefentoets 👍

### b) Komt wel / niet voor in een andere tabel (oefentoets vraag world)
```text
SELECT <kolommen> FROM <tabelA>
WHERE <sleutel_A> NOT IN (SELECT <sleutel_B> FROM <tabelB>);     -- NIET in B
WHERE <sleutel_A> IN     (SELECT <sleutel_B> FROM <tabelB>);     -- WEL in B
```
```sql
-- landen die NIET in city voorkomen (country.Code = city.CountryCode)
SELECT Code, Name, Region, LocalName FROM country
WHERE Code NOT IN (SELECT CountryCode FROM city);

-- landen die WEL steden hebben
SELECT Code, Name FROM country WHERE Code IN (SELECT CountryCode FROM city);

-- landen waar Dutch gesproken wordt
SELECT Name FROM country WHERE Code IN (SELECT CountryCode FROM countrylanguage WHERE Language = 'Dutch');
```
Hetzelfde met `NOT EXISTS`:
```sql
SELECT co.Code, co.Name FROM country AS co
WHERE NOT EXISTS (SELECT * FROM city AS ci WHERE ci.CountryCode = co.Code);
```

> ⚠️ **"Je moet eerst bepalen op welk veld je de tabellen kunt vergelijken."** Zoek de kolom die in beide tabellen **hetzelfde betekent**. In world is dat **`country.Code` = `city.CountryCode`** (en `countrylanguage.CountryCode`). Zet dat in je documentatie, met een screenshot van de kolommen (rechtsklik op de tabel → *Table Inspector* of klap *Columns* open in de Navigator).

---

## 7. JOIN: twee tabellen combineren
```text
SELECT a.<kolom>, b.<kolom>
FROM <tabelA> AS a
INNER JOIN <tabelB> AS b ON b.<sleutel> = a.<sleutel>;   -- alleen rijen die in BEIDE voorkomen

SELECT a.<kolom>, b.<kolom>
FROM <tabelA> AS a
LEFT JOIN <tabelB> AS b ON b.<sleutel> = a.<sleutel>;    -- ALLE rijen van A, ook zonder match (dan NULL)
```
`AS a` is een **alias**, een korte bijnaam voor de tabel. Daarna schrijf je `a.Name` in plaats van `country.Name`.

| JOIN | Resultaat |
|---|---|
| `INNER JOIN` (of gewoon `JOIN`) | alleen rijen met een match in **beide** tabellen |
| `LEFT JOIN` | **alle** rijen van de linker tabel (na FROM) + match of NULL |
| `RIGHT JOIN` | **alle** rijen van de rechter tabel + match of NULL |

```sql
-- steden met de naam van hun land
SELECT ci.Name AS Stad, co.Name AS Land
FROM city AS ci
INNER JOIN country AS co ON co.Code = ci.CountryCode;

-- hoofdstad per land (country.Capital = city.ID)
SELECT co.Name AS Land, ci.Name AS Hoofdstad
FROM country AS co
JOIN city AS ci ON ci.ID = co.Capital;

-- landen ZONDER steden (LEFT JOIN + IS NULL)  ← zelfde uitkomst als NOT IN
SELECT co.Code, co.Name, co.Region, co.LocalName
FROM country AS co
LEFT JOIN city AS ci ON ci.CountryCode = co.Code
WHERE ci.ID IS NULL;

-- aantal steden per land, met landnaam (JOIN + GROUP BY)
SELECT co.Name, COUNT(ci.ID) AS AantalSteden
FROM country AS co
LEFT JOIN city AS ci ON ci.CountryCode = co.Code
GROUP BY co.Name
ORDER BY AantalSteden DESC;

-- metingen met de locatie van de host (ritmania)
SELECT m.Hostname, h.Location, m.FreeMemory, m.Date
FROM MemoryUsage AS m
JOIN Hosts AS h ON h.Hostname = m.Hostname;

-- drie tabellen: officiele talen met landnaam
SELECT co.Name, cl.Language
FROM country AS co
JOIN countrylanguage AS cl ON cl.CountryCode = co.Code
WHERE cl.IsOfficial = 'T';
```

---

## 8. Datum en tijd
| Functie | Geeft | Voorbeeld |
|---|---|---|
| `NOW()` | nu (datum + tijd) | `2026-11-02 09:15:03` |
| `CURDATE()` | vandaag (alleen datum) | `2026-11-02` |
| `CURTIME()` | nu (alleen tijd) | `09:15:03` |
| `DATE(kolom)` | alleen de datum | `DATE(Date) = '2026-10-13'` |
| `TIME(kolom)` | alleen de tijd | `TIME(Date) > '14:00:00'` |
| `YEAR() MONTH() DAY()` | jaar / maand / dag | `MONTH(Date) = 10` |
| `HOUR() MINUTE()` | uur / minuut | `HOUR(Date) = 14` |
| `DATE_FORMAT(kolom, '%d-%m-%Y %H:%i')` | mooi formaat | `13-10-2026 14:19` |
| `DATE_SUB(NOW(), INTERVAL 7 DAY)` | 7 dagen geleden | |
| `DATEDIFF(a, b)` | aantal dagen tussen a en b | |

Een datum **schrijven** (in WHERE of INSERT). Alle drie goed:
```text
'2026-10-13 14:19:00'      ← met quotes, met streepjes (meest duidelijk)
20261013141900             ← zonder quotes, zo maakt het script van de docent het
NOW()                      ← nu
```
```sql
SELECT * FROM MemoryUsage WHERE DATE(Date) = '2026-10-13';
SELECT * FROM MemoryUsage WHERE Date BETWEEN '2026-10-13 14:00:00' AND '2026-10-13 15:00:00';
SELECT * FROM MemoryUsage WHERE HOUR(Date) = 14;
SELECT * FROM MemoryUsage WHERE MONTH(Date) = 10 AND YEAR(Date) = 2026;
SELECT * FROM MemoryUsage WHERE Date >= DATE_SUB(NOW(), INTERVAL 30 DAY);
SELECT Hostname, DATE_FORMAT(Date, '%d-%m-%Y %H:%i:%s') AS Tijdstip FROM MemoryUsage;
```

---

## 9. INSERT: record toevoegen
```text
INSERT INTO <tabel> (<kolom1>, <kolom2>, <kolom3>)
VALUES (<waarde1>, <waarde2>, <waarde3>);
```
- **ID** met `AUTO_INCREMENT` laat je **weg**, die vult MySQL zelf.
- Tekst en datum tussen `'quotes'`, getallen zonder.
- Zelfde aantal kolommen als waarden, in dezelfde volgorde.

```sql
-- oefentoets vraag 4: ID automatisch, Date met NOW()
INSERT INTO MemoryUsage (Hostname, FreeMemory, Date) VALUES ('KYAN-LAPTOP', 6250000, NOW());

-- zelfde, met een vaste datum (2 manieren)
INSERT INTO MemoryUsage (Hostname, FreeMemory, Date) VALUES ('MyNewPC', 4567098, '2026-11-02 09:00:00');
INSERT INTO MemoryUsage (Hostname, FreeMemory, Date) VALUES ('MyNewPC', 4567098, 20261102090000);

-- meerdere records in één keer (zoals het script doet)
INSERT INTO MemoryUsage (Hostname, FreeMemory, Date) VALUES
('TEST01', 4000000, NOW()),
('TEST02', 4100000, NOW());

-- controleren of hij erin staat
SELECT * FROM MemoryUsage ORDER BY ID DESC LIMIT 1;
```
> ⚠️ **Maar één keer uitvoeren!** Elke klik op ⚡ voegt een record toe. Te vaak geklikt? Zie [§11](#11-delete-records-verwijderen) om de dubbele te verwijderen.

---

## 10. UPDATE: gegevens wijzigen
```text
UPDATE <tabel>
SET <kolom> = <nieuwe waarde>, <kolom2> = <waarde2>
WHERE <welke rijen>;              ← VERGEET DE WHERE NIET, anders verandert ALLES
```
```sql
UPDATE MemoryUsage SET FreeMemory = 5000000 WHERE ID = 1;
UPDATE MemoryUsage SET Hostname = 'SERVER01' WHERE Hostname = 'SRV01';
UPDATE MemoryUsage SET FreeMemory = FreeMemory + 1000 WHERE Hostname = 'SRV02';
UPDATE city SET Population = 800000 WHERE Name = 'Amsterdam';
```
> ⚠️ **Error 1175: "You are using safe update mode"** → Workbench wil een WHERE op de **primary key** (ID). Oplossingen:
> 1. Gebruik `WHERE ID = …` / `WHERE ID > 0`, **of**
> 2. Zet het even uit: `SET SQL_SAFE_UPDATES = 0;` → je query → `SET SQL_SAFE_UPDATES = 1;`

---

## 11. DELETE: records verwijderen
```text
DELETE FROM <tabel> WHERE <welke rijen>;     ← VERGEET DE WHERE NIET, anders is alles weg
```
```sql
DELETE FROM MemoryUsage WHERE ID = 22;
DELETE FROM MemoryUsage WHERE Hostname = 'MyNewPC';
DELETE FROM MemoryUsage WHERE FreeMemory < 1000;
DELETE FROM MemoryUsage WHERE ID > 0;      -- alles weg (zo begint het bestand van het script)
```
> 💡 **Eerst kijken, dan verwijderen:** voer eerst `SELECT * FROM … WHERE <zelfde voorwaarde>` uit. Klopt het? Vervang dan `SELECT *` door `DELETE`.

`TRUNCATE TABLE MemoryUsage;` leegt de hele tabel én zet de ID-teller terug op 1.

---

## 12. Tabel en database maken (als de tabel nog niet bestaat)
```sql
CREATE DATABASE IF NOT EXISTS ritmania;
USE ritmania;
CREATE TABLE IF NOT EXISTS MemoryUsage (
  ID         INT AUTO_INCREMENT PRIMARY KEY,
  Hostname   VARCHAR(50),
  FreeMemory INT,
  Date       DATETIME
);
DESCRIBE MemoryUsage;                  -- laat de kolommen zien
SHOW TABLES;                           -- welke tabellen zijn er
SHOW DATABASES;                        -- welke databases zijn er
```
Andere handige commando's:
```text
ALTER TABLE <tabel> ADD <kolom> VARCHAR(50);       -- kolom toevoegen
ALTER TABLE <tabel> DROP COLUMN <kolom>;           -- kolom verwijderen
DROP TABLE <tabel>;                                -- tabel weg (pas op!)
```

| Datatype | Voor |
|---|---|
| `INT` | geheel getal |
| `DECIMAL(10,2)` | getal met 2 decimalen |
| `VARCHAR(50)` | tekst, max 50 tekens |
| `DATETIME` | datum + tijd |
| `DATE` | alleen datum |

---

## 13. Tekstfuncties (extra)
```sql
SELECT CONCAT(Name, ' (', Code, ')') AS Land FROM country;    -- Netherlands (NLD)
SELECT UPPER(Name), LOWER(Name), LENGTH(Name) FROM country;
SELECT LEFT(Name, 3) FROM country;                            -- eerste 3 letters
```

---

## 14. Foutmeldingen in Workbench en de oplossing
| Fout | Betekent | Oplossing |
|---|---|---|
| **1046** No database selected | Workbench weet niet welke database | `USE ritmania;` bovenaan, of dubbelklik de database links (wordt **vet**) |
| **1064** You have an error in your SQL syntax … near '' | Typfout. Bij het scriptbestand: **komma aan het eind** | Laatste `,` → `;` · kijk naar quotes, komma's en haakjes vlak vóór "near" |
| **1146** Table '…' doesn't exist | Tabelnaam fout of tabel bestaat niet | Spelling checken, `SHOW TABLES;`, of tabel aanmaken (§12) |
| **1054** Unknown column '…' | Kolomnaam fout | `DESCRIBE <tabel>;` en kijk hoe de kolom echt heet |
| **1175** safe update mode | UPDATE/DELETE zonder WHERE op primary key | §10 |
| **1136** Column count doesn't match | Aantal kolommen ≠ aantal waarden bij INSERT | Tellen! |
| **1111** Invalid use of group function | AVG/COUNT in WHERE | Subquery (§6) of HAVING (§5) |
| **1142** command denied to user | Gebruiker mist rechten | `GRANT` (zie [03-autorisatie.md](03-autorisatie.md)) |
| **1062** Duplicate entry | Waarde voor de primary key bestaat al | ID weglaten (auto increment) |
| 0 row(s) returned | Geen fout! Er voldoet gewoon niets | Controleer met een andere query en **leg het uit** in je documentatie |

---

## 15. Uitvoeren in Workbench
- ⚡ **Bliksem** (Ctrl+Shift+Enter): voert **alles** uit (of alleen wat je geselecteerd hebt).
- ⚡ **Bliksem met cursor** (Ctrl+Enter): voert **alleen de query waar je cursor staat** uit.
- Resultaat staat in de **Result Grid**. Log en fouten staan onderin bij **Output** (groen vinkje = gelukt).
- Screenshot voor je documentatie: zorg dat de **query + Result Grid + Output** in beeld zijn.
