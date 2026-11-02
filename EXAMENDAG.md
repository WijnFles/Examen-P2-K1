# 📋 Examendag P2-K1: stappenplan

## Vooraf (thuis of 's ochtends)
- [ ] [W2/02-commentaar-naar-code.md](W2-powershell/02-commentaar-naar-code.md) en [W3/02-queries-spiekbrief.md](W3-sql/02-queries-spiekbrief.md) open in een tabblad (als hulpmiddelen mogen)
- [ ] Het docentscript met uitleg 1× rustig gelezen: [UITGELEGD.ps1](W2-powershell/scripts/origineel/MonitorFreeMemory-docent-UITGELEGD.ps1)
- [ ] [Oefening 1](W2-powershell/scripts/oefeningen/oefening-1-MonitorFreeMemory-GATEN.ps1) 1× zelf ingevuld
- [ ] Weet de 3 dingen die op het formulier staan en **niet** in de oefentoets: **autorisatie** (W3), **eisen en wensen** (W1), **testbevindingen** (W2)

---

## W1 · Flowchart (90 min)
1. **Lees** de hele beschrijving. **Nummer** elke stap (1, 2, 3…).
2. **Markeer de signaalwoorden:** *controleer of* → ruit · *zolang / net zolang tot* → ruit + terugpijl · *vraag / toon* → parallellogram · *bestand* → document · *vul / bepaal* → rechthoek.
3. **Bouw** in Visio, van boven naar beneden.
4. **Ruiten = vragen met ?**, elke uitgang **Ja/Nee**.
5. **Keuze met 3 opties?** Eerst `geldig?` (lus), dan `Optie 2?` → `Optie 9?`.
6. **Checklist** onderaan [W1/README](W1-flowchart/README.md#checklist-voor-je-inlevert). Vooral: **geen doodlopende paden**.
7. **Sjabloon invullen** (kopieer de opbouw van [het ingevulde sjabloon](W1-flowchart/ontwerp-sjabloon-ingevuld.md)): Doel + **eisen en wensen** · Aanpak · Stroomdiagram · Toelichting per stap · Input · Output · Resultaat uitvoer.
8. **E-mail aan de opdrachtgever** met het ontwerp als bijlage: wat doet het script + **welke keuzes en waarom**, in gewone taal ([voorbeelden](W1-flowchart/email-voorbeelden.md))

## W2 · Script (90 min)
1. Download → map `C:\Scripts` → hernoem naar `MonitorFreeMemory-Kyan.ps1` → open in VS Code. 📸
2. Lees het script. **Kijk welke variabelenamen er al zijn** (`$seconds`, `$ResultFile`, …).
3. Per gat: zoek het commentaar op in [02-commentaar-naar-code.md](W2-powershell/02-commentaar-naar-code.md) of pak het puzzelstuk uit de [voorbeeldenbank](W2-powershell/05-voorbeeldenbank.md) (meet het script iets anders, zoals CPU of schijf? → [6b meetblokken](W2-powershell/05-voorbeeldenbank.md#6b--meetblokken-wat-meet-je)) → typ de code → **gebruik de namen uit het script**.
4. **Kopieer de stijl:** staat er al een `While`-invoerlus? Doe de tweede net zo.
5. **F5.** Rode tekst? Kijk naar het regelnummer. Meestal is het `}` `)` `"` of `-eq`.
6. Lukt starten niet? → `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
7. **Testen** (📸 elke test): zonder argumenten · `.\script.ps1 10 test.txt` · keuze 1 / 2 / 9 / ongeldig · y / n / ongeldig.
8. **Documentatie** met het [sjabloon](W2-powershell/03-testen-en-documenteren.md#4-documentatie-opzet-kopieer-in-word): doel, gebruik, werking per stap, **basisconcepten bij naam** (variabelen, sequentie, selectie, iteratie), testtabel met **bevindingen**.
9. **Voor W3:** `.\MonitorFreeMemory-Kyan.ps1 60 Results.txt`

## W3 · SQL (120 min)
1. **3.1:** bestand naar de server → Workbench → `USE ritmania;` → **laatste `,` wordt `;`** → ⚡ → `SELECT * FROM MemoryUsage;` 📸 bij elke stap. Leg de komma-fout uit = **"herstel"**.
2. **Autorisatie** (indien gevraagd): `CREATE USER` → `GRANT` → `SHOW GRANTS` → testen als die gebruiker. 📸
3. **Queries:** woorden in de vraag → [tabel §0](W3-sql/02-queries-spiekbrief.md#0-welk-stukje-sql-hoort-bij-welke-woorden-in-de-vraag) → sjabloon → invullen.
   - "laat zien" = `SELECT` · "waarvoor geldt" = `WHERE` · "sorteer" = `ORDER BY` · "per" = `GROUP BY` · "aantal" = `COUNT(*)` · "gemiddelde" = `AVG()` · "groter dan het gemiddelde" = subquery · "niet in tabel" = `NOT IN (SELECT …)` · "voeg toe" = `INSERT` (ID weglaten, datum `NOW()`)
4. **INSERT maar 1× uitvoeren!**
5. **world:** vergelijkveld = `country.Code = city.CountryCode`. Schrijf dat op.
6. **Documentatie per vraag:** vraag · query · 📸 resultaat · 1 zin uitleg. **0 rijen? Leg uit waarom.**

---

## Als je vastloopt
| Probleem | Doe dit |
|---|---|
| Ik snap een gat in het script niet | Zoek een stukje code **elders in hetzelfde script** dat bijna hetzelfde doet en kopieer het |
| Script start niet | `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` |
| Lus stopt nooit | Stoptijd **vóór** de lus? `(Get-Date)` **tussen haakjes**? |
| SQL Error 1064 | Komma/puntkomma/quote vlak vóór "near …" |
| SQL Error 1046 | `USE ritmania;` |
| SQL Error 1175 | `SET SQL_SAFE_UPDATES = 0;` |
| Tijd dringt | Liever **alles half met screenshots** dan één ding perfect: documentatie = punten |

Succes Kyan! 💪
