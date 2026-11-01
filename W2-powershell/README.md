# W2 · Automatiseert processen: script afmaken (15 punten)

> **Je hoeft niets zelf te bedenken.** Het examenscript is al bijna af. Op een paar plekken staat een `#`-commentaar met wat er moet gebeuren. Jij zoekt de bijbehorende code op in [02-commentaar-naar-code.md](02-commentaar-naar-code.md) en typt die eronder.

## Lees in deze volgorde
| # | Bestand | Wat | Tijd |
|---|---|---|---|
| 1 | [scripts/origineel/MonitorFreeMemory-docent-UITGELEGD.ps1](scripts/origineel/MonitorFreeMemory-docent-UITGELEGD.ps1) | Het script van de docent, **elke regel uitgelegd** in gewone taal | 20 min |
| 2 | [01-powershell-vanaf-nul.md](01-powershell-vanaf-nul.md) | Alle bouwstenen: variabelen, if, while, do-until, bestanden, datum… | naslag |
| 3 | [02-commentaar-naar-code.md](02-commentaar-naar-code.md) | ⭐ **Opzoektabel: "commentaar zegt X → typ Y"** | examendag |
| 4 | [scripts/oefeningen/](scripts/oefeningen/) | 3 oefenscripts met gaten. Antwoorden staan in [scripts/antwoorden/](scripts/antwoorden/) | 60 min |
| 5 | [03-testen-en-documenteren.md](03-testen-en-documenteren.md) | Uitvoeren, testplan, documentatie (6 van de 15 punten!) | 15 min |
| 6 | [04-varianten-andere-metingen.md](04-varianten-andere-metingen.md) | Als het examen CPU/schijf/… meet in plaats van geheugen | 10 min |
| 7 | [lesstof/](lesstof/README.md) | **Lessen periode 9** (week 2-9): param/functies/try-catch/logging, AD, DNS/DHCP, bulkgebruikers, REST API's, de keten + verdedigingsvragen. Met geteste scripts | naslag |

## Hoe word je beoordeeld? (elk criterium 0-3 punten)
| Criterium | Wat moet je laten zien | Hoe |
|---|---|---|
| Te automatiseren processen gekozen | Je snapt wat het script automatiseert | Doel van het script in je documentatie |
| Onderdelen en relaties vastgelegd | Welk stuk code hoort bij welke stap | Stap 1-9 van de flowchart koppelen aan de regels in je script |
| Script/code werkend opgeleverd | Het draait zonder fouten | Testen + screenshots |
| Basisconcepten toegepast en begrepen | Variabelen, if, loops, sequentie | Eigen `#`-commentaar in het script + benoemen in de documentatie |
| Documenteren | Technisch, volledig, correct | Sjabloon in [03](03-testen-en-documenteren.md#4-documentatie-opzet-kopieer-in-word) |

Cijfer: 8 pnt = 5.8 · **9 pnt = 6.4** · 10 pnt = 7.0 · 12 pnt = 8.2 · 15 pnt = 10

## Het script in één plaatje
Dit is de opbouw van het examenscript. Elke stap is een blok uit de flowchart (W1).

```
STAP 1  $seconds = 5 ; $ResultFile = 'Results.txt' ; $MachineName = hostname     ← default variabelen
STAP 2  If ($args[0] -Is [int])    {$seconds = $args[0]}                        ← argumenten
        If ($args[1] -Is [string]) {$ResultFile = $args[1]}
STAP 3  If (Test-Path $ResultFile) {                                            ← bestaat het bestand?
            menu 1/2/9 tonen
            $answer = Read-Host ... ; While (fout antwoord) { opnieuw vragen }  ← invoerlus
            If ($answer -Eq '2') { Set-Content ... ; Add-Content ... }          ← overschrijven
            If ($answer -Eq '9') { Exit }                                        ← stoppen
        } Else { Set-Content ... ; Add-Content ... }                             ← nieuw bestand
STAP 4  $stopAt = (Get-Date).AddSeconds($seconds)                               ← stoptijd
STAP 5  clear ; Write-Host "Checking ... for $seconds seconds"                  ← melding
STAP 6  while ((Get-Date) -Lt $stopAt) {                                        ← ZOLANG niet klaar
            meten (Get-CimInstance) → Add-Content (wegschrijven) → Write-Host (tonen)
            aftellen 3-2-1 (iets bewegends)
        }
STAP 7  clear ; Write-Host "Results can be found in $pwd\$ResultFile"           ← waar staat het?
STAP 8  $answer = Read-Host "(y/n)" ; While (niet y/n) { opnieuw }              ← invoerlus
        If ($answer -Eq 'y') {Invoke-Item $ResultFile} Else {Write-Host "..."}   ← openen of melding
STAP 9  Write-Host "Script finished at" (Get-Date)                              ← klaar + tijd
```

## Examendag: stappenplan W2 (90 min)
1. **(5 min)** Script downloaden → logische map (`C:\Scripts`) → hernoemen naar `MonitorFreeMemory-Kyan.ps1` → openen in VS Code → screenshot.
2. **(5 min)** Lees het **hele** script. Zet voor jezelf een nummer (stap 1-9) bij elk deel. Kijk bovenaan **welke variabelenamen** er al zijn.
3. **(30 min)** Vul gat voor gat in met [02-commentaar-naar-code.md](02-commentaar-naar-code.md). **Laat het commentaar staan.** Typ bij elk gat ook een kort eigen `#`-commentaar.
4. **(5 min)** Druk op **F5**. Fout? Lees het regelnummer en los het op. Zie de [veelgemaakte fouten](01-powershell-vanaf-nul.md#21-veelgemaakte-fouten).
5. **(20 min)** Voer het testplan uit en maak screenshots ([03 §3](03-testen-en-documenteren.md#3-testplan-deze-tests-moet-je-doen)).
6. **(20 min)** Schrijf de documentatie ([03 §4](03-testen-en-documenteren.md#4-documentatie-opzet-kopieer-in-word)).
7. **(5 min)** Draai het script **60 seconden** voor W3: `.\MonitorFreeMemory-Kyan.ps1 60 Results.txt`

## Noodkaart: de 10 regels die je het vaakst nodig hebt
```powershell
$variabele = 'waarde'                                         # doosje vullen
If ($args[0] -Is [int]) {$seconds = $args[0]}                 # argument gebruiken
If (Test-Path -LiteralPath $ResultFile) { } Else { }          # bestaat bestand?
$answer = Read-Host -Prompt "Vraag"                            # iets vragen
While (($answer -ne "y") -And ($answer -ne "n")) { $answer = Read-Host -Prompt "Vraag" }   # net zolang vragen
Set-Content -Path $ResultFile -Value "eerste regel"            # nieuw bestand / overschrijven
Add-Content -Path $ResultFile -Value "nog een regel"           # onderaan toevoegen
$stopAt = (Get-Date).AddSeconds($seconds)                      # stoptijd
while ((Get-Date) -Lt $stopAt) { }                             # zolang stoptijd niet bereikt
If ($answer -Eq 'y') {Invoke-Item $ResultFile} Else {Write-Host "Melding"}   # openen of melding
```

## Getest
Alle antwoordscripts zijn getest met PowerShell 7 (met nagebootste Windows-meetwaarden): nieuw bestand, aanvullen (1), overschrijven (2), stoppen (9), ongeldige invoer, y/n. Op het examen gebruik je Windows PowerShell 5.1 of 7 in VS Code. Beide werken.
