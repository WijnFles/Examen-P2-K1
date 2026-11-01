# Week 9 · Verdediging en eindtoets

**Cijfer module:** eindopdracht + verdediging **70%**, eindtoets **30%**. Allebei minimaal **5,5** (niet compenseren). Plus 8 weekopdrachten "voldaan".

## Deel A (tabblad 2 van de werkmap): klaarzetten
Sessiecode · bevestigingsnummer · aantallen uit je run · **wegwijzer met regelnummers** naar de belangrijkste stukken · zelfinschatting op 4 criteria. Inleveren **1 werkdag vóór** je tijdslot, met je script, logboek en 3 screenshots.

Wegwijzer voor [week8-Keten-Onboarding.ps1](scripts/week8-Keten-Onboarding.ps1) (pas de regelnummers aan je eigen script aan):
| Onderdeel | Waar |
|---|---|
| Param-blok | bovenaan (`param (`) |
| Logfunctie | `function Schrijf-Log` |
| Gebruikersnaam samenstellen | `function New-Gebruikersnaam` |
| Foutsoort bepalen (API) | `function Toon-ApiFout` |
| Schakel 1: GET | `# ---- Schakel 1` |
| Bestaat-al-controle | `if (Get-ADUser -Filter …` |
| try/catch binnen de loop | `foreach ($m in $personeel) {` → `try {` |
| Schakel 4: POST met -Depth 4 | `# ---- Schakel 4` |
| Bevestiging + compleet | `# ---- Schakel 5` |

## Deel B: het gesprek (±5 min)
1. **Live demo**: HR-API opnieuw starten (nieuw personeelsbestand, nieuwe sessiecode) → keten van begin tot eind.
2. **Uitleg code**: de docent wijst een stuk aan: *wat doet het, waarom zo?*
3. **"Wat als"-vraag**

**Klaarzetten:** server aan · script open in VS Code · logboek bij de hand.

## De voorbereidingsvragen met antwoord
**1. Waar wordt de gebruikersnaam samengesteld? Loop het door voor "Roos van der Heijden".**
> In de functie `New-Gebruikersnaam`. De eerste letter van de voornaam (`R`) + de achternaam (`van der Heijden`) + het suffix (`42`) geeft `Rvan der Heijden42`. Daarna worden accenten verwijderd, wordt alles kleine letters en haalt `-replace '[^a-z0-9]',''` de spaties weg. Resultaat: **`rvanderheijden42`**. Is de naam langer dan 20 tekens, dan wordt hij ingekort, omdat een sAMAccountName maximaal 20 tekens mag zijn.

**2. Waarom staat er `-ErrorAction Stop` bij je API-call, en wat gebeurt er als je die weghaalt?**
> Met `-ErrorAction Stop` wordt elke fout een **afbrekende** fout, zodat mijn `catch` hem opvangt. Zonder die parameter kan een fout "niet-afbrekend" zijn: dan schiet hij **langs** de catch, krijg ik rode tekst, en gaat het script door met een **lege** `$personeel`. Dan wordt er niets aangemaakt en lijkt het alsof alles goed ging.

**3. Wat gebeurt er als je script twee keer achter elkaar draait? Waarom crasht het niet?**
> Door de **bestaat-al-controle** (`Get-ADUser -Filter "SamAccountName -eq '$sam'"`). Bestaat het account al, dan geef ik een waarschuwing, log ik dat en sla ik `New-ADUser` over. Ik meld die accounts **wel** terug in het rapport, zodat het rapport bij de 2e run ook `compleet = True` is. Getest: run 2 gaf 0 nieuw, 15 bestond al, compleet True. (Het script is *idempotent*: vaker draaien geeft hetzelfde eindresultaat.)

**4. Wat als de API halverwege uitvalt? Wat is dan de toestand van je AD, en zie je dat in je log?**
> - Valt de API uit **vóór of tijdens het ophalen**, dan vangt de catch dat op. `Toon-ApiFout` ziet dat `$_.Exception.Response` leeg is, dus "niet bereikbaar": melding, log en `exit 1`. Er is **niets** aangemaakt.
> - Valt hij uit **na het ophalen, tijdens het aanmaken**, dan merkt AD daar niets van: de data zit al in `$personeel`. Alle accounts worden aangemaakt.
> - Valt hij uit **bij het rapport (POST)**, dan **staan de accounts al in AD**, maar is er geen bevestigingsnummer. In het log staat per account "Aangemaakt: …" en daarna de FOUT-regel bij "rapport versturen". **Oplossing:** API opnieuw starten en het script opnieuw draaien. Dankzij de bestaat-al-controle worden er geen dubbele accounts gemaakt, en het rapport wordt alsnog compleet verstuurd.

**5. Wat zou je anders doen bij 500 medewerkers in plaats van 15?**
> - Niet `$verwerkt += …` gebruiken (dat kopieert de hele array bij elke toevoeging, dus traag), maar een `[System.Collections.Generic.List[object]]` met `.Add()`.
> - **Dubbele namen** opvangen: twee keer "Jan Jansen" geeft dezelfde sAMAccountName. Voeg dan een volgnummer toe, of gebruik het personeelsnummer.
> - Voortgang tonen met `Write-Progress`.
> - Eerst een **testrun** met `-WhatIf`.
> - **Paginering**: grote API's sturen data in pagina's; dan meerdere GETs doen.
> - Het rapport eventueel in delen versturen. En het log per run een eigen bestandsnaam geven.

### Meer "wat als"-vragen die kunnen komen
| Vraag | Antwoord |
|---|---|
| Wat als een medewerker een naam met een accent heeft (José Müller)? | Accenten worden weggehaald met `Normalize(FormD)`: `jmuller42` |
| Wat als twee medewerkers dezelfde naam hebben? | Nu krijgt de tweede "bestaat al". Beter: volgnummer of personeelsnummer toevoegen |
| Waarom staat het wachtwoord niet in je script? | Knock-out: wachtwoorden horen niet in code (iedereen met toegang tot het script ziet het). Daarom `Read-Host -AsSecureString` + `ChangePasswordAtLogon` |
| Waarom `-Depth 4`? | ConvertTo-Json gaat standaard maar 2 niveaus diep. Wat dieper zit, wordt platte tekst (`"@{naam=…}"`). Mijn accounts zijn objecten in een lijst in een object; met -Depth 4 weet ik zeker dat alles als echte JSON aankomt |
| Waarom `compleet = False`? | Kijk naar `ontbrekend` (niet teruggemeld, bijv. een AD-fout) en `onbekend` (naam anders gespeld dan de API) |
| Wat als het OU-pad niet bestaat? | Dan faalt `New-ADUser` voor **iedereen**; elke medewerker komt in de catch. Beter: vooraf controleren met `Get-ADOrganizationalUnit` en dan stoppen |
| Waarom try/catch **in** de loop? | Eén fout mag de rest niet tegenhouden ("één rotte appel") |
| Waarom een functie voor het log? | Herbruikbaar, overal dezelfde tijdstempel en hetzelfde formaat |
| Hoe debug je dit? | Breakpoint in VS Code (F9 of klik voor het regelnummer), F5, variabelen bekijken, F10 stap voor stap |
| "Dat zou beter kunnen…" | Eerlijk benoemen **telt mee** als begrip. Bijv. "ik log het wachtwoordbeleid niet" of "dubbele namen vang ik nog niet af" |

---

## Eindtoets: oefenvragen (meerkeuze, 5 thema's)
<details><summary><b>1.</b> Waarom zet je <code>-ErrorAction Stop</code> achter een cmdlet in een try-blok?</summary>

Zodat niet-afbrekende fouten **toch** naar de catch gaan.
</details>
<details><summary><b>2.</b> Wat doet <code>[ValidateRange(1,50)]</code> boven <code>[int]$Aantal</code>?</summary>

Waarden buiten 1-50 worden geweigerd **voordat** het script start.
</details>
<details><summary><b>3.</b> Waar in je script moet een functie staan?</summary>

**Boven** de plek waar je hem aanroept (direct onder het param-blok).
</details>
<details><summary><b>4.</b> Welke execution policy staat lokale scripts toe en eist een handtekening bij gedownloade?</summary>

**RemoteSigned**
</details>
<details><summary><b>5.</b> Wat doet <code>-PrefixLength 24</code>?</summary>

Subnetmasker **255.255.255.0**
</details>
<details><summary><b>6.</b> Waarom moet je een DHCP-server autoriseren in AD?</summary>

Een niet-geautoriseerde DHCP-server deelt **geen** adressen uit. Zo voorkom je **rogue DHCP-servers**.
</details>
<details><summary><b>7.</b> Wat is de ScopeId van een scope 192.168.42.50-150 /24?</summary>

**192.168.42.0**
</details>
<details><summary><b>8.</b> Welk record vertaalt een IP-adres naar een naam?</summary>

**PTR** (in een reverse lookup zone)
</details>
<details><summary><b>9.</b> Wat betekent <code>$</code> achter een sharenaam (<code>Homedirs$</code>)?</summary>

**Verborgen** share
</details>
<details><summary><b>10.</b> Share-rechten: Full Control, NTFS: Read. Wat mag de gebruiker via de share?</summary>

Alleen **lezen**: de strengste wint.
</details>
<details><summary><b>11.</b> Waarom heeft <code>Initialize-Disk</code> in de pipeline <code>-PassThru</code> nodig?</summary>

Anders geeft hij **geen object door** aan New-Partition.
</details>
<details><summary><b>12.</b> Wat voorkomt dat je bulkscript bij de 2e run crasht?</summary>

De **bestaat-al-controle** met `Get-ADUser -Filter`.
</details>
<details><summary><b>13.</b> Welk HTTP-werkwoord gebruik je om iets nieuws aan te maken? En welke statuscode hoort bij succes?</summary>

**POST** → **201 Created**
</details>
<details><summary><b>14.</b> Je krijgt een 405. Wat is er mis?</summary>

Goed endpoint, **verkeerd werkwoord** (bijv. POST waar alleen GET mag).
</details>
<details><summary><b>15.</b> Je krijgt een 401 bij een weer-API. Oorzaak?</summary>

**API-key** ontbreekt of is fout.
</details>
<details><summary><b>16.</b> Waar bewaar je een API-key?</summary>

In een **apart bestand** buiten het script (`Get-Content C:\Scripts\geheim\owm.key`), nooit hardcoded en nooit op een screenshot.
</details>
<details><summary><b>17.</b> Wat geeft de RDW bij een kenteken dat niet bestaat?</summary>

**Geen fout**, maar een **leeg** antwoord. Controleer zelf met `if ($auto)`.
</details>
<details><summary><b>18.</b> Wat zijn de 3 verplichte onderdelen van een POST met Invoke-RestMethod?</summary>

`-Method Post` · `-Body ($x | ConvertTo-Json)` · `-ContentType "application/json"`
</details>
<details><summary><b>19.</b> Waarom <code>-Depth 4</code> bij ConvertTo-Json?</summary>

Standaard gaat hij maar 2 niveaus diep; wat dieper genest is, komt als tekst (`@{naam=…}`) aan in plaats van als JSON.
</details>
<details><summary><b>20.</b> Hoe lees je de statuscode uit in een catch?</summary>

`[int]$_.Exception.Response.StatusCode`
</details>
<details><summary><b>21.</b> Wat betekent JSON <code>[ { … } ]</code>?</summary>

Een **lijst** (blokhaken) met **objecten** (accolades).
</details>
<details><summary><b>22.</b> Welk cmdlet promoveert een server tot eerste DC van een nieuw forest?</summary>

**Install-ADDSForest**
</details>
<details><summary><b>23.</b> Hoe lees je de DN <code>OU=Medewerkers,OU=Vestiging,DC=school,DC=local</code>?</summary>

Van **klein naar groot**: OU Medewerkers zit in OU Vestiging, in het domein school.local.
</details>
<details><summary><b>24.</b> Waarom krijgen nieuwe OU's ProtectedFromAccidentalDeletion?</summary>

Zodat je een OU (met misschien 400 gebruikers) niet per ongeluk verwijdert. Eerst uitzetten, dan pas verwijderen.
</details>
