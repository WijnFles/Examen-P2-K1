# W3 · Beheert databases: SQL (12 punten, 120 min)

| # | Bestand | Wat |
|---|---|---|
| 1 | [01-tabel-vullen.md](01-tabel-vullen.md) | Opdracht 3.1: het scriptbestand in MySQL krijgen, met **"herstel indien nodig"** (de komma!) |
| 2 | [02-queries-spiekbrief.md](02-queries-spiekbrief.md) | ⭐ **Alle queries**: SELECT, WHERE, ORDER BY, COUNT/AVG/SUM/MIN/MAX, GROUP BY, HAVING, subquery, JOIN, datums, INSERT, UPDATE, DELETE + foutmeldingen |
| 3 | [03-autorisatie.md](03-autorisatie.md) | ⚠️ **Gebruikers en rechten** (CREATE USER, GRANT). Staat op het beoordelingsformulier, niet in de oefentoets |
| 4 | [04-oefenvragen.md](04-oefenvragen.md) | 34 oefenvragen met antwoorden: de oefentoets + varianten + moeilijker |
| 5 | [oefen-databases/](oefen-databases/) | `ritmania.sql` en `world-mini.sql` om thuis mee te oefenen |

## Beoordeling (elk 0-3 punten)
| Criterium | Opdracht | Waar |
|---|---|---|
| Autorisatie configureren | gebruiker + rechten | [03](03-autorisatie.md) |
| Eenvoudige selectie-queries | vraag 1, 2, 3 (SELECT, ORDER BY, WHERE) | [02 §1-3](02-queries-spiekbrief.md#1-select-velden-laten-zien) |
| Complexe selectie-queries | vraag 5 + world (subquery, NOT IN, JOIN, GROUP BY) | [02 §4-7](02-queries-spiekbrief.md#4-berekenen-count-sum-avg-min-max) |
| Gegevens aanpassen | 3.1 + vraag 4 (INSERT, DELETE, UPDATE) | [01](01-tabel-vullen.md), [02 §9-11](02-queries-spiekbrief.md#9-insert-record-toevoegen) |

Cijfer: 6 pnt = 5.5 · 7 pnt = 6.3 · **8 pnt = 7.0** · 10 pnt = 8.5 · 12 pnt = 10

## De antwoorden van de oefentoets (docent)
```sql
USE ritmania;
SELECT * FROM MemoryUsage;                                                       -- 1
SELECT Hostname, FreeMemory FROM MemoryUsage ORDER BY FreeMemory;                -- 2
SELECT Date, FreeMemory FROM MemoryUsage WHERE FreeMemory > 5000000;             -- 3
INSERT INTO MemoryUsage (Hostname, FreeMemory, Date) VALUES ('MyNewPC', 4567098, NOW());   -- 4
SELECT Date, FreeMemory FROM MemoryUsage
WHERE FreeMemory < (SELECT AVG(FreeMemory) FROM MemoryUsage);                    -- 5
```
```sql
USE world;
SELECT Code, Name, Region, LocalName FROM country
WHERE Code NOT IN (SELECT CountryCode FROM city);                                -- world
```

## Examendag: stappenplan W3 (120 min)
1. **(15 min) 3.1 Tabel vullen:** script 60 sec → bestand naar de server → in Workbench openen → `USE ritmania;` → **laatste komma → puntkomma** → ⚡ → `SELECT * FROM MemoryUsage;`. Screenshot bij elke stap.
2. **(10 min) Autorisatie** (als het gevraagd wordt): `CREATE USER` → `GRANT` → `SHOW GRANTS` → testen door in te loggen als die gebruiker.
3. **(40 min) Queries:** per vraag een **nieuw query-tabblad** of onder elkaar. Gebruik de tabel *"welke woorden → welk stukje SQL"* uit [02 §0](02-queries-spiekbrief.md#0-welk-stukje-sql-hoort-bij-welke-woorden-in-de-vraag).
4. **(5 min) world:** `world.sql` openen → ⚡ → links op 🔄 klikken (refresh) → `world` staat erbij.
5. **(40 min) Documentatie:** per vraag: **de vraag** · **de query** · **screenshot met resultaat** · **één zin uitleg**. Zie hieronder.
6. **(10 min) Nalopen:** elke vraag beantwoord? Elke screenshot leesbaar?

## Documentatie per vraag (kopieer dit)
```
Vraag 3: Laat date en freememory zien waarvoor freememory hoger is dan 5000000.

Query:
  SELECT Date, FreeMemory FROM MemoryUsage WHERE FreeMemory > 5000000;

[screenshot: query + Result Grid + Output]

Uitleg: Met WHERE filter ik op rijen waarvan FreeMemory groter is dan 5000000.
Resultaat: 0 rijen, omdat de hoogste meting 4.699.836 KB is
(gecontroleerd met SELECT MAX(FreeMemory) FROM MemoryUsage;).
```
