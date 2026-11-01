# Examen P2-K1 · Ontwikkelt digitale informatievoorzieningen

Alles wat je nodig hebt voor het examen **P2-K1** (Expert IT systems and devices).
Gebaseerd op de **oefentoets "Geheugenmonitor"**. Volgens de docent is die vergelijkbaar met het examen, soms zelfs moeilijker. Het examen kan bijna hetzelfde zijn, met **andere namen en vragen**.

| Werkproces | Opdracht | Tijd | Punten | Start hier |
|---|---|---|---|---|
| **W1** Ontwerpt een informatievoorziening | Flowchart in Visio + Sjabloon ontwerp | 90 min | 9 | [W1-flowchart/](W1-flowchart/) |
| **W2** Automatiseert processen | PowerShell-script afmaken + testen + documenteren | 90 min | 15 | [W2-powershell/](W2-powershell/) ⭐ |
| **W3** Beheert databases | Tabel vullen + SQL-queries + autorisatie | 120 min | 12 | [W3-sql/](W3-sql/) |

📋 **[EXAMENDAG.md](EXAMENDAG.md)**: het stappenplan voor morgen op één pagina.

---

## Hoe de drie opdrachten samenhangen
```
 W1 FLOWCHART                W2 SCRIPT                         W3 DATABASE
 ┌──────────────┐  bouwplan  ┌──────────────────────┐  maakt   ┌───────────────────────┐
 │ ontwerp van  │ ─────────▶ │ MonitorFreeMemory.ps1│ ───────▶ │ Results.txt (SQL)      │
 │ het script   │            │ meet vrij geheugen   │          │ → tabel MemoryUsage    │
 └──────────────┘            └──────────────────────┘          │ → queries in Workbench │
                                                               └───────────────────────┘
```
Elke **stap** in de flowchart (W1) is een **stukje code** in het script (W2). Het **resultatenbestand** van het script vult de **tabel** in W3.

## Snel naar…
**W1**
- [Elk Visio-blok uitgelegd + hoe je de tekst schrijft](W1-flowchart/README.md#de-blokken-in-visio-sjabloon-basisstroomdiagram--basic-flowchart)
- [Van zin naar blok](W1-flowchart/README.md#van-zin-naar-blok-zo-vertaal-je-de-beschrijving)
- [Sjabloon ontwerp volledig ingevuld](W1-flowchart/ontwerp-sjabloon-ingevuld.md)

**W2**
- [Het script van de docent, elke regel uitgelegd](W2-powershell/scripts/origineel/MonitorFreeMemory-docent-UITGELEGD.ps1)
- [⭐ Opzoektabel: commentaar → code](W2-powershell/02-commentaar-naar-code.md)
- [PowerShell vanaf nul](W2-powershell/01-powershell-vanaf-nul.md)
- [Oefenscripts met gaten](W2-powershell/scripts/oefeningen/) en [antwoorden](W2-powershell/scripts/antwoorden/)
- [Testen en documenteren](W2-powershell/03-testen-en-documenteren.md)
- [Lessen periode 9: param, try/catch, AD, DNS/DHCP, bulkgebruikers, REST API, de keten + verdediging](W2-powershell/lesstof/README.md)

**W3**
- [⭐ SQL-spiekbrief: alle queries](W3-sql/02-queries-spiekbrief.md)
- [Tabel vullen + de komma-fout](W3-sql/01-tabel-vullen.md)
- [Autorisatie (CREATE USER / GRANT)](W3-sql/03-autorisatie.md)
- [34 oefenvragen met antwoorden](W3-sql/04-oefenvragen.md)

## Mapstructuur
```
├── EXAMENDAG.md                          stappenplan voor het examen
├── W1-flowchart/
│   ├── README.md                         Visio-blokken, schrijfregels, uitwerking, checklist
│   ├── ontwerp-sjabloon-ingevuld.md      Sjabloon ontwerp volledig ingevuld
│   ├── Sjabloon_ontwerp.docx             leeg sjabloon
│   ├── flowchart-kyan-oefentoets.vsdx    jouw oefenversie
│   └── afbeeldingen/flowchart-docent.png uitwerking docent
├── W2-powershell/
│   ├── README.md                         start hier + stappenplan
│   ├── 01-powershell-vanaf-nul.md        alle bouwstenen
│   ├── 02-commentaar-naar-code.md        ⭐ opzoektabel
│   ├── 03-testen-en-documenteren.md      testplan + documentatie
│   ├── 04-varianten-andere-metingen.md   CPU, schijf, processen, ping…
│   ├── lesstof/                          lessen periode 9: samenvatting, scripts, oefen-API's, verdediging
│   └── scripts/
│       ├── origineel/                    script docent (+ uitgelegd) en jouw versie
│       ├── oefeningen/                   3 scripts met gaten
│       └── antwoorden/                   uitwerkingen (getest)
└── W3-sql/
    ├── README.md                         start hier + antwoorden oefentoets
    ├── 01-tabel-vullen.md                opdracht 3.1
    ├── 02-queries-spiekbrief.md          ⭐ alle queries
    ├── 03-autorisatie.md                 gebruikers en rechten
    ├── 04-oefenvragen.md                 oefenvragen + antwoorden
    └── oefen-databases/                  ritmania.sql, world-mini.sql
```
