# 04 · Oefenvragen met antwoorden

**Zo oefen je:** laad eerst de oefendatabases in Workbench. Open [oefen-databases/ritmania.sql](oefen-databases/ritmania.sql) en [oefen-databases/world-mini.sql](oefen-databases/world-mini.sql) en voer ze uit met ⚡. Probeer elke vraag zelf, en klik daarna pas op **Antwoord**.

> Op het examen gebruik je `USE world;`. Thuis met de oefendatabase is dat `USE world_mini;`.

---

## A. De oefentoets (bijna zeker vergelijkbaar met het examen)
`USE ritmania;`

**A1.** Laat alle velden van de tabel MemoryUsage zien.
<details><summary>Antwoord</summary>

```sql
SELECT * FROM MemoryUsage;
```
</details>

**A2.** Laat hostname en freememory zien, gesorteerd op freememory van laag naar hoog.
<details><summary>Antwoord</summary>

```sql
SELECT Hostname, FreeMemory FROM MemoryUsage ORDER BY FreeMemory ASC;
```
</details>

**A3.** Laat date en freememory zien waarvoor freememory hoger is dan 5000000.
<details><summary>Antwoord</summary>

```sql
SELECT Date, FreeMemory FROM MemoryUsage WHERE FreeMemory > 5000000;
```
Geeft het 0 rijen? Dan is dat **geen fout**: alle metingen liggen onder de 5 miljoen. Schrijf dat erbij en laat het zien met `SELECT MAX(FreeMemory) FROM MemoryUsage;`.
</details>

**A4.** Voeg een nieuw record toe (ID wordt automatisch gevuld, zoek uit hoe je date vult).
<details><summary>Antwoord</summary>

```sql
INSERT INTO MemoryUsage (Hostname, FreeMemory, Date) VALUES ('MyNewPC', 4567098, NOW());
SELECT * FROM MemoryUsage ORDER BY ID DESC LIMIT 1;
```
Date kan op drie manieren: `NOW()`, `'2026-11-02 09:00:00'` of `20261102090000`. ID laat je weg, want AUTO_INCREMENT vult die zelf.
</details>

**A5.** Laat date en freememory zien waarvoor freememory kleiner is dan het gemiddelde van alle records.
<details><summary>Antwoord</summary>

```sql
SELECT AVG(FreeMemory) FROM MemoryUsage;    -- eerst los: wat is het gemiddelde?
SELECT Date, FreeMemory FROM MemoryUsage
WHERE FreeMemory < (SELECT AVG(FreeMemory) FROM MemoryUsage);
```
</details>

**A6.** (world) Laat code, name, region en localname uit Country zien van landen die niet in City voorkomen.
<details><summary>Antwoord</summary>

Vergelijkveld: **country.Code = city.CountryCode**
```sql
SELECT Code, Name, Region, LocalName FROM country
WHERE Code NOT IN (SELECT CountryCode FROM city);
```
of
```sql
SELECT co.Code, co.Name, co.Region, co.LocalName
FROM country AS co
LEFT JOIN city AS ci ON ci.CountryCode = co.Code
WHERE ci.ID IS NULL;
```
In de echte world-database geeft dit **7 landen**: ATA, ATF, BVT, HMD, IOT, SGS, UMI.
</details>

---

## B. Zelfde soort vragen, andere woorden (ritmania)

**B1.** Laat de velden ID, hostname en date zien van alle metingen van SRV02.
<details><summary>Antwoord</summary>

```sql
SELECT ID, Hostname, Date FROM MemoryUsage WHERE Hostname = 'SRV02';
```
</details>

**B2.** Laat hostname en freememory zien, gesorteerd op freememory van **hoog naar laag**.
<details><summary>Antwoord</summary>

```sql
SELECT Hostname, FreeMemory FROM MemoryUsage ORDER BY FreeMemory DESC;
```
</details>

**B3.** Laat date en freememory zien waarvoor freememory **lager** is dan 4600000.
<details><summary>Antwoord</summary>

```sql
SELECT Date, FreeMemory FROM MemoryUsage WHERE FreeMemory < 4600000;
```
</details>

**B4.** Laat alle metingen zien met freememory **tussen** 4,5 en 5 miljoen.
<details><summary>Antwoord</summary>

```sql
SELECT * FROM MemoryUsage WHERE FreeMemory BETWEEN 4500000 AND 5000000;
```
</details>

**B5.** Hoeveel metingen staan er in de tabel?
<details><summary>Antwoord</summary>

```sql
SELECT COUNT(*) AS AantalMetingen FROM MemoryUsage;
```
</details>

**B6.** Wat is de laagste, de hoogste en de gemiddelde freememory?
<details><summary>Antwoord</summary>

```sql
SELECT MIN(FreeMemory) AS Laagste, MAX(FreeMemory) AS Hoogste, ROUND(AVG(FreeMemory)) AS Gemiddeld
FROM MemoryUsage;
```
</details>

**B7.** Laat **per hostname** het aantal metingen en het gemiddelde vrije geheugen zien.
<details><summary>Antwoord</summary>

```sql
SELECT Hostname, COUNT(*) AS Aantal, ROUND(AVG(FreeMemory)) AS Gemiddeld
FROM MemoryUsage
GROUP BY Hostname;
```
</details>

**B8.** Laat alleen de hostnames zien met **meer dan 5** metingen.
<details><summary>Antwoord</summary>

```sql
SELECT Hostname, COUNT(*) AS Aantal FROM MemoryUsage
GROUP BY Hostname
HAVING COUNT(*) > 5;
```
</details>

**B9.** Laat de meting met het **hoogste** vrije geheugen zien (alle velden).
<details><summary>Antwoord</summary>

```sql
SELECT * FROM MemoryUsage WHERE FreeMemory = (SELECT MAX(FreeMemory) FROM MemoryUsage);
```
of
```sql
SELECT * FROM MemoryUsage ORDER BY FreeMemory DESC LIMIT 1;
```
</details>

**B10.** Laat date en freememory zien waarvoor freememory **groter** is dan het gemiddelde.
<details><summary>Antwoord</summary>

```sql
SELECT Date, FreeMemory FROM MemoryUsage WHERE FreeMemory > (SELECT AVG(FreeMemory) FROM MemoryUsage);
```
</details>

**B11.** Laat alle metingen van **13 oktober 2026** zien.
<details><summary>Antwoord</summary>

```sql
SELECT * FROM MemoryUsage WHERE DATE(Date) = '2026-10-13';
```
</details>

**B12.** Laat alle metingen zien die **na 14:00** zijn gedaan.
<details><summary>Antwoord</summary>

```sql
SELECT * FROM MemoryUsage WHERE TIME(Date) > '14:00:00';
```
</details>

**B13.** Verander de hostname `WS-KYAN` in `LAPTOP-KYAN`.
<details><summary>Antwoord</summary>

```sql
SET SQL_SAFE_UPDATES = 0;
UPDATE MemoryUsage SET Hostname = 'LAPTOP-KYAN' WHERE Hostname = 'WS-KYAN';
SET SQL_SAFE_UPDATES = 1;
```
</details>

**B14.** Verwijder het record dat je bij A4 hebt toegevoegd.
<details><summary>Antwoord</summary>

```sql
SELECT * FROM MemoryUsage WHERE Hostname = 'MyNewPC';   -- eerst kijken
SET SQL_SAFE_UPDATES = 0;
DELETE FROM MemoryUsage WHERE Hostname = 'MyNewPC';
SET SQL_SAFE_UPDATES = 1;
```
</details>

**B15.** (JOIN) Laat per meting de hostname, de locatie van de host (tabel Hosts) en het vrije geheugen zien.
<details><summary>Antwoord</summary>

```sql
SELECT m.Hostname, h.Location, m.FreeMemory
FROM MemoryUsage AS m
JOIN Hosts AS h ON h.Hostname = m.Hostname;
```
</details>

**B16.** Welke hosts uit de tabel Hosts hebben **geen** metingen?
<details><summary>Antwoord</summary>

```sql
SELECT Hostname FROM Hosts WHERE Hostname NOT IN (SELECT Hostname FROM MemoryUsage);
```
→ SRV03
</details>

---

## C. world (moeilijker: zo kan de laatste vraag ook gesteld worden)
`USE world;` (thuis: `USE world_mini;`)

**C1.** Laat naam en inwonertal zien van alle landen in Europa, van groot naar klein.
<details><summary>Antwoord</summary>

```sql
SELECT Name, Population FROM country WHERE Continent = 'Europe' ORDER BY Population DESC;
```
</details>

**C2.** Laat per continent het aantal landen zien.
<details><summary>Antwoord</summary>

```sql
SELECT Continent, COUNT(*) AS AantalLanden FROM country GROUP BY Continent;
```
</details>

**C3.** Laat de landcodes zien met **minstens 3** steden in de tabel city.
<details><summary>Antwoord</summary>

```sql
SELECT CountryCode, COUNT(*) AS AantalSteden FROM city GROUP BY CountryCode HAVING COUNT(*) >= 3;
```
</details>

**C4.** Laat de naam van elke stad zien met de **naam** van het land waarin hij ligt.
<details><summary>Antwoord</summary>

```sql
SELECT ci.Name AS Stad, co.Name AS Land
FROM city AS ci
JOIN country AS co ON co.Code = ci.CountryCode;
```
</details>

**C5.** Laat elk land zien met de naam van de **hoofdstad**.
<details><summary>Antwoord</summary>

Vergelijkveld: **country.Capital = city.ID**
```sql
SELECT co.Name AS Land, ci.Name AS Hoofdstad
FROM country AS co
JOIN city AS ci ON ci.ID = co.Capital;
```
</details>

**C6.** Laat de steden zien met meer inwoners dan het gemiddelde van alle steden.
<details><summary>Antwoord</summary>

```sql
SELECT Name, Population FROM city WHERE Population > (SELECT AVG(Population) FROM city);
```
</details>

**C7.** Laat de landen zien waar **Dutch** gesproken wordt.
<details><summary>Antwoord</summary>

```sql
SELECT Name FROM country
WHERE Code IN (SELECT CountryCode FROM countrylanguage WHERE Language = 'Dutch');
```
</details>

**C8.** Laat de landen zien die **geen** onafhankelijkheidsjaar hebben.
<details><summary>Antwoord</summary>

```sql
SELECT Code, Name FROM country WHERE IndepYear IS NULL;
```
</details>

**C9.** Laat code en naam zien van landen die **niet** in de tabel countrylanguage voorkomen.
<details><summary>Antwoord</summary>

Vergelijkveld: **country.Code = countrylanguage.CountryCode**
```sql
SELECT Code, Name FROM country WHERE Code NOT IN (SELECT CountryCode FROM countrylanguage);
```
</details>

**C10.** Laat per land de naam en het aantal steden zien, ook landen met 0 steden. Sorteer van veel naar weinig.
<details><summary>Antwoord</summary>

```sql
SELECT co.Name, COUNT(ci.ID) AS AantalSteden
FROM country AS co
LEFT JOIN city AS ci ON ci.CountryCode = co.Code
GROUP BY co.Name
ORDER BY AantalSteden DESC;
```
`COUNT(ci.ID)` en niet `COUNT(*)`: dan telt een land zonder steden als **0** in plaats van 1.
</details>

**C11.** Laat de landen in Europa zien waarvan de naam met een **B** begint.
<details><summary>Antwoord</summary>

```sql
SELECT Name FROM country WHERE Continent = 'Europe' AND Name LIKE 'B%';
```
</details>

**C12.** Laat het totale inwonertal per continent zien, alleen continenten met meer dan 100 miljoen inwoners.
<details><summary>Antwoord</summary>

```sql
SELECT Continent, SUM(Population) AS Inwoners FROM country
GROUP BY Continent
HAVING SUM(Population) > 100000000;
```
</details>
