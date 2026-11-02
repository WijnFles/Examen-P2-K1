# E-mail bij de flowchart: voorbeelden

Bij W1 wordt het criterium **Communicatie** beoordeeld:
> *"Het ontwerp en de toelichting van de gemaakte keuzes zijn op begrijpelijke (**functionele**) wijze gecommuniceerd met de opdrachtgever."*

**Functioneel** = in gewone taal, voor iemand **zonder** IT-kennis. Je vertelt **wat** het script doet en **waarom** je iets zo hebt ontworpen, **niet** hoe het in PowerShell werkt.

## Checklist voor een goede mail
- [ ] **Onderwerp** dat zegt waar het over gaat ("Ontwerp script geheugenmonitor ter beoordeling")
- [ ] **Aanhef** zakelijk: "Beste [naam]," of "Geachte heer/mevrouw [naam],"
- [ ] **Waarom** je mailt (eerste zin) + **bijlage** genoemd (het ontwerpdocument/de flowchart)
- [ ] **Wat het script doet**, in 3-6 korte punten, in gewone taal
- [ ] **Gemaakte keuzes + waarom** (dat is precies wat het criterium vraagt!)
- [ ] **Aannames / open vragen** (laat zien dat je eisen en wensen afstemt)
- [ ] **Vervolgstap**: wat verwacht je van de ontvanger (akkoord/feedback, vóór wanneer)
- [ ] **Afsluiting** + naam + functie + bedrijf
- [ ] **Geen jargon**: niet `$args[0]`, `while-lus`, `Add-Content`, maar "het script blijft meten tot de ingestelde tijd voorbij is"

| ❌ Technisch (niet doen) | ✅ Functioneel (wel doen) |
|---|---|
| Als `$args[0]` een int is, overschrijft hij `$seconds`. | U kunt bij het starten zelf opgeven hoe lang er gemeten wordt. Doet u dat niet, dan meet het script 5 seconden. |
| Er zit een while-lus op `(Get-Date) -lt $stopAt`. | Het script meet elke 3 seconden, totdat de opgegeven tijd voorbij is. |
| Input-validatie met een while op 1/2/9. | Typt de gebruiker per ongeluk iets anders dan 1, 2 of 9, dan wordt de vraag opnieuw gesteld. Zo kan het script niet vastlopen op een tikfout. |
| `Add-Content` met een SQL INSERT-regel. | Elke meting wordt meteen in een bestand bewaard, in een vorm die direct in de database kan worden ingelezen. |
| `Test-Path` op `$ResultFile`. | Het script controleert eerst of er al een resultatenbestand is, zodat er nooit per ongeluk metingen verloren gaan. |

---

## Voorbeeld 1: ontwerp aanbieden (volledig, aanbevolen)

**Aan:** opdrachtgever@solarplex.nl
**Van:** kyan.wossink@solarplex.nl
**Onderwerp:** Ontwerp script geheugenmonitor ter beoordeling
**Bijlage:** Ontwerp_Geheugenmonitor_Kyan.docx

> Beste [naam opdrachtgever],
>
> Zoals afgesproken stuur ik u in de bijlage het ontwerp van het script dat het vrije geheugen van een server bewaakt. Het ontwerp bestaat uit een stroomdiagram (flowchart) en een toelichting per stap. Met deze mail licht ik kort toe wat het script gaat doen en waarom ik bepaalde keuzes heb gemaakt.
>
> **Wat doet het script?**
> - Het meet een opgegeven aantal seconden lang het vrije geheugen van de server waarop het draait.
> - Elke meting wordt op het scherm getoond en in een bestand bewaard. Met dat bestand kan de database (tabel MemoryUsage) direct gevuld worden.
> - Na afloop ziet de gebruiker waar het bestand staat en kan hij het meteen openen.
>
> **Gemaakte keuzes**
> - **Instelbaar zonder aanpassingen:** u kunt bij het starten zelf opgeven hoe lang er gemeten wordt en hoe het bestand heet. Geeft u niets op, dan gebruikt het script vaste standaardwaarden (5 seconden, Results.txt). Zo is het script direct bruikbaar én flexibel.
> - **Geen gegevens kwijt:** bestaat het bestand al, dan kiest de gebruiker zelf: aanvullen, overschrijven of stoppen. Er wordt nooit zonder toestemming iets overschreven.
> - **Bestendig tegen tikfouten:** bij elke vraag aan de gebruiker wordt net zo lang gevraagd tot er een geldig antwoord is gegeven. Het script kan dus niet vastlopen of iets onverwachts doen door een tikfout.
> - **Zichtbaar bezig:** tijdens het meten ziet de gebruiker een aftelling, zodat duidelijk is dat het script werkt en niet is vastgelopen.
> - **Duidelijke afronding:** aan het eind meldt het script dat het klaar is, met de exacte eindtijd. Die tijd is handig om terug te vinden in de database.
>
> **Aannames**
> - Er wordt elke 3 seconden gemeten. Is een andere frequentie gewenst, dan is dat eenvoudig aan te passen.
> - Het geheugen wordt in kilobytes opgeslagen, zoals de tabel MemoryUsage verwacht.
>
> Wilt u het ontwerp bekijken en mij laten weten of het aan uw wensen voldoet? Na uw akkoord begin ik met het bouwen van het script. Uw reactie zie ik graag uiterlijk [datum] tegemoet.
>
> Met vriendelijke groet,
>
> Kyan Wossink
> IT-medewerker, Solar Plex Network

---

## Voorbeeld 2: kort en zakelijk

**Onderwerp:** Ontwerp geheugenmonitor: graag uw akkoord
**Bijlage:** Ontwerp_Geheugenmonitor_Kyan.docx

> Beste [naam],
>
> In de bijlage vindt u het ontwerp van het script voor de geheugenmonitor.
>
> Het script meet een instelbaar aantal seconden het vrije geheugen van de server en bewaart de metingen in een bestand waarmee de database direct gevuld kan worden. Bestaat dat bestand al, dan kiest de gebruiker of de metingen worden toegevoegd, het bestand wordt overschreven of het script stopt. Zo gaan er nooit ongemerkt gegevens verloren. Bij elke vraag wordt doorgevraagd tot er een geldig antwoord is, zodat een tikfout geen problemen geeft.
>
> In het document staat per stap een toelichting, plus voorbeelden van wat de gebruiker op het scherm te zien krijgt.
>
> Ik hoor graag of het ontwerp akkoord is, of dat u aanpassingen wenst.
>
> Met vriendelijke groet,
> Kyan Wossink
> IT-medewerker, Solar Plex Network

---

## Voorbeeld 3: met vragen om de eisen en wensen af te stemmen
*Gebruik dit als iets in de opdracht niet helemaal duidelijk is. Het laat zien dat je de **beginsituatie (eisen en wensen)** serieus neemt.*

**Onderwerp:** Ontwerp geheugenmonitor: twee vragen ter afstemming

> Beste [naam],
>
> Bijgaand stuur ik het ontwerp van de geheugenmonitor. Voordat ik het script ga bouwen, wil ik twee punten met u afstemmen:
>
> 1. **Hoe vaak moet er gemeten worden?** In het ontwerp ga ik uit van elke 3 seconden. Bij lange metingen (bijvoorbeeld een uur) levert dat veel regels op. Is één meting per minuut voor u voldoende?
> 2. **Wat moet er gebeuren als het geheugen erg laag wordt?** Het ontwerp toont nu alleen de waarden. Ik kan er een waarschuwing aan toevoegen als het vrije geheugen onder een grens komt, bijvoorbeeld 1 GB.
>
> De overige stappen staan in het ontwerp toegelicht. Na uw antwoord pas ik het ontwerp zo nodig aan en begin ik met de bouw.
>
> Met vriendelijke groet,
> Kyan Wossink
> IT-medewerker, Solar Plex Network

---

## Voorbeeld 4: aangepast ontwerp na feedback

**Onderwerp:** Aangepast ontwerp geheugenmonitor (versie 1.1)
**Bijlage:** Ontwerp_Geheugenmonitor_Kyan_v1.1.docx

> Beste [naam],
>
> Bedankt voor uw feedback op het ontwerp. Ik heb de volgende aanpassingen gedaan:
>
> - Bij een bestaand bestand kan de gebruiker nu ook kiezen voor **aanvullen**, naast overschrijven en stoppen.
> - Na het openen van het resultatenbestand meldt het script nu ook dat het klaar is, inclusief de eindtijd.
>
> De aangepaste stappen zijn in het stroomdiagram en in de toelichting gemarkeerd. Als u akkoord bent, begin ik met het bouwen van het script.
>
> Met vriendelijke groet,
> Kyan Wossink
> IT-medewerker, Solar Plex Network

---

## Voorbeeld 5: andere opdracht (CPU-monitor met grenswaarde)
*Zo pas je de mail aan als het examen iets anders meet.*

**Onderwerp:** Ontwerp script CPU-monitor ter beoordeling
**Bijlage:** Ontwerp_CPU-monitor_Kyan.docx

> Beste [naam],
>
> In de bijlage vindt u het ontwerp van het script dat de belasting van de processor (CPU) van een server bewaakt.
>
> **Wat doet het script?**
> - Het meet een opgegeven aantal seconden lang hoe zwaar de processor belast wordt (in procenten).
> - Elke meting wordt getoond en in een bestand bewaard, waarmee de tabel CpuUsage in de database gevuld kan worden.
> - Komt de belasting boven de **grenswaarde van 80%**, dan krijgt de gebruiker direct een waarschuwing op het scherm. Aan het eind ziet hij hoe vaak dat is gebeurd.
>
> **Gemaakte keuzes**
> - **Grenswaarde als instelling:** de grens van 80% staat bovenaan het script als instelbare waarde. Zo kunt u die later eenvoudig aanpassen, zonder het script verder te wijzigen.
> - **Waarschuwing direct zichtbaar:** de waarschuwing verschijnt op het moment van de meting, zodat de beheerder meteen kan ingrijpen.
> - **Samenvatting achteraf:** het aantal te hoge metingen geeft in één oogopslag aan of er een structureel probleem is.
> - Net als bij de geheugenmonitor gaan er geen gegevens verloren (keuze bij een bestaand bestand), en geven tikfouten geen problemen.
>
> Ik hoor graag of het ontwerp aan uw wensen voldoet.
>
> Met vriendelijke groet,
> Kyan Wossink
> IT-medewerker, Solar Plex Network

---

## Bouwstenen om zelf een mail te maken
**Openingszinnen**
- *Zoals afgesproken stuur ik u in de bijlage het ontwerp van …*
- *In de bijlage vindt u het ontwerp (stroomdiagram en toelichting) van het script dat …*
- *Graag leg ik u het ontwerp voor van …*

**Keuzes uitleggen (keuze → voordeel voor de klant)**
| Keuze in het ontwerp | Zo zeg je het |
|---|---|
| Standaardwaarden + argumenten | *Het script werkt direct met vaste instellingen, maar u kunt bij het starten zelf de duur en de bestandsnaam opgeven.* |
| Bestand bestaat → aanvullen/overschrijven/stoppen | *Er gaan nooit ongemerkt eerdere metingen verloren; de gebruiker beslist zelf.* |
| Invoerlus (net zolang vragen) | *Een tikfout van de gebruiker kan het script niet laten vastlopen.* |
| Stoptijd vooraf berekenen | *Het script stopt precies na de opgegeven tijd.* |
| Iets bewegends | *De gebruiker ziet dat het script bezig is en niet is vastgelopen.* |
| Scherm leegmaken | *Het scherm blijft overzichtelijk; de gebruiker ziet alleen wat op dat moment belangrijk is.* |
| Resultaat als SQL | *De metingen kunnen zonder extra werk in de database worden ingelezen.* |
| Locatie tonen + openen | *De gebruiker hoeft het bestand niet te zoeken.* |
| Eindtijd melden | *Zo is duidelijk wanneer de meting klaar was; handig om terug te vinden in de database.* |
| Grenswaarde/waarschuwing | *Problemen vallen direct op, zodat er op tijd ingegrepen kan worden.* |

**Afsluiters**
- *Wilt u het ontwerp bekijken en mij laten weten of het aan uw wensen voldoet?*
- *Na uw akkoord begin ik met het bouwen van het script.*
- *Heeft u vragen of wensen, dan hoor ik dat graag.*
