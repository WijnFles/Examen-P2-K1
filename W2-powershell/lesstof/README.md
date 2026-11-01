# Lesstof Scripting deel 2 (periode 9): samenvatting, scripts en examenrelevantie

Alle lesbrieven van **Scripting deel 2** (week 2 t/m 9, P2-K1-W2 *Automatiseert processen*), samengevat, met **uitgewerkte en geteste scripts**.

> **Hoe verhoudt dit zich tot het examen?** Het examen W2 is waarschijnlijk zoals de oefentoets: een **script afmaken** (zie [../02-commentaar-naar-code.md](../02-commentaar-naar-code.md)). Maar de gaten kunnen ook gaan over wat je in deze lessen leerde: een **param-blok**, een **logfunctie**, **try/catch met -ErrorAction Stop**, een **bestaat-al-controle**. Of het script is "moeilijker" en werkt met **gebruikers, shares of een API**. Daarom staat alles hier met code die je direct kunt overnemen.

| Week | Onderwerp | Samenvatting | Uitgewerkt script | Kans op examen |
|---|---|---|---|---|
| 2 | Param-blok, functies, try/catch, logging, debuggen | [§ week 2](samenvatting-per-week.md#week-2--van-commando-naar-script) | [week2-Serverrapport.ps1](scripts/week2-Serverrapport.ps1) | ⭐⭐⭐ **zeer groot** (zit in elk script) |
| 3 | IP, servernaam, AD DS, Install-ADDSForest | [§ week 3](samenvatting-per-week.md#week-3--de-server-uit-het-niets) | [week3-Bouw-Domein.ps1](scripts/week3-Bouw-Domein.ps1) | ⭐ |
| 4 | DNS-zones/records, DHCP autoriseren, scopes | [§ week 4](samenvatting-per-week.md#week-4--netwerkdiensten-dns-en-dhcp) | [week4-Netwerkdiensten.ps1](scripts/week4-Netwerkdiensten.ps1) | ⭐ |
| 5 | Disk-pipeline, SMB-share, OU's, **bulk New-ADUser uit CSV** | [§ week 5](samenvatting-per-week.md#week-5--de-vestiging-gaat-open) | [week5-Vestiging-Bulk.ps1](scripts/week5-Vestiging-Bulk.ps1) + [personeel.csv](scripts/personeel.csv) | ⭐⭐ ("dé klassieke automatiseringsklus") |
| 6 | REST API: GET, JSON, API-keys | [§ week 6](samenvatting-per-week.md#week-6--rest-apis-get) | [week6-Get-Voertuig-en-Get-Weer.ps1](scripts/week6-Get-Voertuig-en-Get-Weer.ps1) | ⭐⭐ |
| 7 | POST, statuscodes, eigen API | [§ week 7](samenvatting-per-week.md#week-7--data-terugsturen-post) | [week7-Nieuw-Boeking.ps1](scripts/week7-Nieuw-Boeking.ps1) | ⭐⭐ |
| 8 | **De keten**: API → AD → rapport | [§ week 8](samenvatting-per-week.md#week-8--de-keten) | [week8-Keten-Onboarding.ps1](scripts/week8-Keten-Onboarding.ps1) | ⭐⭐ |
| 9 | Eindtoets + verdediging | [verdediging-en-eindtoets.md](verdediging-en-eindtoets.md) | – | voor de module |

## Oefenen zonder schoolserver
In [oefen-apis/](oefen-apis/) staan twee **nagebootste API's** die werken zoals in de lesbrieven. Start er één in een tweede PowerShell-venster en draai je script ertegen:
```powershell
.\oefen-apis\boekingen-api-nagebootst.ps1          # week 7: /api/reizen, /api/boekingen
.\oefen-apis\hr-api-nagebootst.ps1 -Aantal 15       # week 8: /api/sessie, /api/medewerkers, /api/rapport
```
(Dit zijn **niet** de API's van school. Ze volgen de beschrijving in de lesbrieven; kijk bij de echte API altijd eerst met `Get-Member` welke velden je krijgt.)

## Getest
- **week 2:** rapport gemaakt, fout netjes afgevangen (try/catch/finally + log), `ValidateRange` weigert 99.
- **week 5:** 10 gebruikers aangemaakt; bij de 2e run 10 overgeslagen (bestaat-al-controle); `Roos van der Heijden` → `rvanderheijden42`.
- **week 7:** 201 bij een geldige boeking, 404 bij een onbekende reis, melding als de API uit staat. De drie klassieke fouten (geen ContentType, geen ConvertTo-Json) geven 400.
- **week 8:** run 1: 15 nieuw, compleet = True. Run 2: 15 "bestaat al", compleet = True (crasht niet). API uit: duidelijke melding + exit. AD-fout bij 1 medewerker: die overgeslagen, de rest gaat door, en het rapport meldt hem als `ontbrekend`. 401/400/405 worden herkend.
- Week 2, 5 en 8 zijn getest met nagebootste AD-cmdlets (op Linux is geen Active Directory). Week 3, 4 en 6 zijn op syntax gecontroleerd. Alle scripts zijn ASCII, dus ook veilig in Windows PowerShell 5.1.
