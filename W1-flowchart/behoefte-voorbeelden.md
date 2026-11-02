# Behoefte (beginsituatie, eisen en wensen): voorbeelden

Bij W1 is het eerste criterium **Beginsituatie**: *"De relevante eisen en wensen zijn beschreven."* (0-3 punten). Daarvoor beschrijf je de **behoefte** van de opdrachtgever: **wat is er nu, wat is het probleem, wat wil de klant hebben, en waar moet het aan voldoen?** Zet dit in het Sjabloon ontwerp onder **Doel**, of als apart kopje **Behoefte / Beginsituatie** daarboven.

## Opbouw (kopieer deze kopjes)
1. **Huidige situatie**: hoe gaat het nu?
2. **Probleem / aanleiding**: waarom is er iets nodig?
3. **Behoefte / gewenste situatie**: wat wil de opdrachtgever bereiken?
4. **Eisen**: wat **moet**? Haal ze letterlijk uit de opdrachttekst (stap 1-9). Zonder deze punten is het script niet goed.
5. **Wensen**: wat zou **mooi** zijn, maar is niet verplicht?
6. **Randvoorwaarden**: waarbinnen moet het (Windows, PowerShell, tijd, tabel in MySQL…)?
7. **Doelgroep**: wie gaat het gebruiken?

> 💡 **Eis of wens?** Staat het in de opdracht ("vraag net zolang tot…")? Dan is het een **eis**. Bedenk je het zelf om het beter te maken (gemiddelde, waarschuwing, logbestand)? Dan is het een **wens**.
> Je kunt ook **MoSCoW** gebruiken: **M**ust have = eis · **S**hould have = belangrijke wens · **C**ould have = leuke extra · **W**on't have = nu niet.

---

## Voorbeeld 1: Geheugenmonitor (oefentoets, volledig)

**Huidige situatie**
De beheerders van Solar Plex Network hebben geen overzicht van het geheugengebruik van hun servers. Ze kunnen alleen op een bepaald moment met de hand in Taakbeheer kijken. Er wordt niets vastgelegd.

**Probleem / aanleiding**
Als een server traag wordt, is achteraf niet na te gaan of er een geheugentekort was. Gegevens over een langere periode ontbreken, dus trends zijn niet te zien.

**Behoefte**
De opdrachtgever wil een script dat gedurende een zelf te kiezen tijd het vrije geheugen van een server meet, en de metingen zo opslaat dat ze in de database (tabel *MemoryUsage* in MySQL) kunnen worden ingelezen. Dan kunnen ze later worden geanalyseerd.

**Eisen (must have)**
| # | Eis | Stap in de opdracht |
|---|---|---|
| E1 | Standaardwaarden voor aantal seconden, bestandsnaam en hostname | 1 |
| E2 | Aantal seconden en bestandsnaam kunnen als argument worden meegegeven en vervangen dan de standaard | 2 |
| E3 | Bestaat het bestand al, dan kiest de gebruiker: aanvullen, overschrijven of stoppen. Er wordt net zo lang gevraagd tot een geldig antwoord | 3 |
| E4 | Bestaat het niet (of bij overschrijven), dan wordt een nieuw bestand gemaakt met de eerste regels | 3 |
| E5 | Er wordt gemeten tot een vooraf berekende stoptijd | 4, 6 |
| E6 | Het scherm wordt leeggemaakt en de gebruiker ziet wat er gaat gebeuren | 5 |
| E7 | Elke meting wordt getoond en weggeschreven naar het bestand | 6 |
| E8 | De gebruiker ziet iets bewegends tijdens het meten | 6 |
| E9 | Na afloop: scherm leeg en de locatie van het bestand tonen | 7 |
| E10 | Vragen of het bestand geopend moet worden (net zolang tot y of n); y = openen, n = passende melding | 8 |
| E11 | Melden dat het script klaar is, met de stoptijd | 9 |
| E12 | De uitvoer is geschikt om tabel MemoryUsage (Hostname, FreeMemory, Date) te vullen | opdrachttekst |

**Wensen (should/could have)**
| # | Wens | Waarom |
|---|---|---|
| W1 | De laatste regel van het bestand eindigt op `;`, zodat de query direct uitvoerbaar is | geen handwerk bij het inlezen |
| W2 | Het aantal metingen tonen aan het eind | controle of alles goed ging |
| W3 | Waarschuwing als het vrije geheugen onder 1 GB komt | problemen direct zien |
| W4 | Het geheugen ook in MB op het scherm tonen | beter leesbaar voor mensen |

**Randvoorwaarden**
- Het script draait op Windows (Server) met PowerShell
- De uitvoer past bij de bestaande tabel MemoryUsage in MySQL (database ritmania)
- Het ontwerp is gemaakt in Visio en het Sjabloon ontwerp, binnen 90 minuten

**Doelgroep**
Systeembeheerders van Solar Plex Network: ze kunnen een script starten, maar zijn geen programmeurs.

---

## Voorbeeld 2: kort (als je weinig tijd hebt)
> **Beginsituatie:** het geheugengebruik van de servers wordt nu niet vastgelegd, waardoor bij problemen niet te achterhalen is of er een geheugentekort was.
> **Behoefte:** een PowerShell-script dat een instelbaar aantal seconden het vrije geheugen meet en de metingen opslaat als SQL voor de tabel MemoryUsage.
> **Eisen:** instelbaar via argumenten (standaard 5 sec / Results.txt) · keuze aanvullen/overschrijven/stoppen bij een bestaand bestand · invoer controleren tot het antwoord geldig is · meten tot de stoptijd, tonen en wegschrijven · iets bewegends tonen · locatie tonen + vragen of het bestand geopend moet worden · eindmelding met tijd.
> **Wensen:** geldige SQL zonder handwerk (`;` aan het eind) · aantal metingen tonen · waarschuwing bij weinig geheugen.

---

## Voorbeeld 3: CPU-monitor met grenswaarde (de oefen-flowchart)

**Huidige situatie / probleem**
Gebruikers klagen af en toe dat de server traag is. Niemand weet of dat door de processor komt, want de CPU-belasting wordt niet bijgehouden.

**Behoefte**
Een script dat een opgegeven tijd lang de CPU-belasting meet, direct waarschuwt als die te hoog is, en de metingen bewaart voor de tabel CpuUsage.

**Eisen**
- E1 Vier standaardwaarden: aantal seconden, bestandsnaam, hostname, grenswaarde (80%)
- E2 Seconden en bestandsnaam als argument
- E3 Bestaand bestand: aanvullen/overschrijven/stoppen, net zolang vragen tot het antwoord geldig is
- E4 Stoptijd bepalen en een teller voor te hoge metingen op 0 zetten
- E5 Zolang de stoptijd niet bereikt is: meten, tonen, wegschrijven
- E6 Boven de grenswaarde: waarschuwing tonen en de teller +1
- E7 Iets bewegends tonen
- E8 Na afloop: locatie + aantal te hoge metingen tonen
- E9 Vragen of het bestand geopend moet worden (y/n, net zolang tot het antwoord geldig is)
- E10 Eindmelding met tijd

**Wensen**
- Grenswaarde ook als argument kunnen meegeven
- Gemiddelde, hoogste en laagste belasting tonen aan het eind
- Waarschuwingen ook in een apart logbestand

---

## Voorbeeld 4: in de mail naar de opdrachtgever (eisen en wensen afstemmen)
> Beste [naam],
>
> Voordat ik het ontwerp maak, heb ik uw behoefte zo samengevat:
> - **U wilt** inzicht in het vrije geheugen van de servers over een langere periode.
> - **Het script moet** instelbaar zijn (duur en bestandsnaam), mag nooit ongemerkt gegevens overschrijven, en moet de metingen opslaan zodat ze in de database kunnen.
> - **Extra voorstel:** een waarschuwing als het geheugen erg laag wordt, en een geldige SQL-query zonder handwerk.
>
> Klopt deze samenvatting? Dan werk ik het ontwerp op deze basis uit.
>
> Met vriendelijke groet,
> Kyan Wossink

---

## Zinnen die je kunt gebruiken
- *De opdrachtgever heeft behoefte aan …*
- *Op dit moment … Hierdoor …* (huidige situatie + probleem)
- *Het script moet …* (eis) · *Het zou wenselijk zijn dat …* (wens)
- *Deze eis volgt uit stap X van de beschrijving.*
- *Deze wens is toegevoegd omdat …*
- *Buiten scope (won't have): …* (bijv. *automatisch laten draaien via Taakplanner*)
