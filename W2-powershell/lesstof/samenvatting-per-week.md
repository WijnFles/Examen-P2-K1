# Samenvatting per week: de stof die je moet kunnen

Per week: **de kern**, **de commando's** en **valkuilen**. De uitgewerkte scripts staan in [scripts/](scripts/).

---

## Week 2 · Van commando naar script
**Kern:** een professioneel script heeft 4 dingen: **parameters**, **functies**, **foutafhandeling** en **logging**. *"Precies deze vier dingen komen terug in élke serveropdracht en op het examen."*

### Script uitvoeren + execution policy
```powershell
.\serverrapport.ps1               # uitvoeren: punt-backslash
Get-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned  # lokale scripts mogen, gedownloade moeten ondertekend zijn
```
Bovenin elk script: **wat doet het, wie schreef het, wanneer** (`<# … #>`).

### Param-blok
```powershell
param (
    [Parameter(Mandatory=$true)]   # verplicht: PowerShell vraagt er zelf om
    [string]$Servernaam,

    [ValidateRange(1,50)]          # alleen 1 t/m 50
    [int]$AantalProcessen = 5      # standaardwaarde
)
# aanroepen: .\rapport.ps1 -Servernaam SRV-KYAN -AantalProcessen 10
```
| Onderdeel | Betekent |
|---|---|
| `[string]` / `[int]` | type afdwingen |
| `Mandatory=$true` | verplicht |
| `= 5` | standaardwaarde |
| `[ValidateRange(1,50)]` | waarde buiten 1-50 → geweigerd **vóór** het script start |
| `[ValidateSet('a','b')]` | alleen deze waarden |
| `[ValidateNotNullOrEmpty()]` | mag niet leeg |
| `[switch]$Force` | aan/uit-schakelaar (`-Force` meegeven = `$true`) |

> **Waarom param en niet Read-Host?** Read-Host laat het script **wachten op een mens**. Scripts draaien vaak 's nachts automatisch, dus geef je waarden mee bij het starten.

### Functie (Verb-Noun, bovenaan het script!)
```powershell
function Schrijf-Log {
    param ([string]$Tekst)
    $stempel = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path C:\Scripts\logboek.txt -Value "$stempel - $Tekst"
}
Schrijf-Log -Tekst "Script gestart"
```
Regel: schrijf je dezelfde 3 regels voor de 2e keer? Dan hoort het in een functie.

### try / catch / finally
```powershell
try {
    $info = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    Write-Output "OS gevonden: $($info.Caption)"
} catch {
    Write-Warning "Kon de systeeminfo niet ophalen: $($_.Exception.Message)"
    Schrijf-Log -Tekst "FOUT: $($_.Exception.Message)"
} finally {
    Schrijf-Log -Tekst "Poging afgerond"     # draait ALTIJD
}
```
| | |
|---|---|
| `-ErrorAction Stop` | **cruciaal**: veel fouten zijn "niet-afbrekend" en schieten anders **langs** de catch |
| `Write-Warning` / `Write-Error` | gele waarschuwing / rode foutmelding. `Write-Output` alleen voor gewone uitvoer |
| `$_.Exception.Message` | de foutomschrijving, voor in je log |
| `finally` | code die altijd draait, ook na een fout |

### Debuggen in VS Code
Klik links van een regelnummer → **rode stip (breakpoint)** → **F5** (start, pauzeert op de stip) → links zie je **alle variabelen** → **F10** = volgende regel · **F11** = de functie in · **Shift+F5** = stoppen.

---

## Week 3 · De server uit het niets
**Kern:** elke wizardstap is één regel PowerShell. **Eerst een snapshot!**

| Wizard | PowerShell |
|---|---|
| Netwerkinstellingen bekijken | `Get-NetIPConfiguration` · `Get-NetAdapter` (onthoud **InterfaceIndex**) |
| Statisch IP + gateway | `New-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.10.10 -PrefixLength 24 -DefaultGateway 192.168.10.1` |
| DNS-server instellen | `Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses 192.168.10.10` (naar **zichzelf**: wordt de DNS-server) |
| Hernoemen | `Rename-Computer -NewName DC-KYAN -Restart` (eerst `-WhatIf`; **vóór** het promoveren) |
| Rollen bekijken | `Get-WindowsFeature *AD*` (Install State: Available / Installed) |
| AD DS installeren | `Install-WindowsFeature AD-Domain-Services -IncludeManagementTools` |
| Promoveren (nieuw forest) | `Install-ADDSForest -DomainName "rkst-kyan.local" -DomainNetbiosName "RKST-KYAN" -InstallDns -SafeModeAdministratorPassword (Read-Host -AsSecureString "DSRM")` |
| Controleren | `Get-ADDomain` · `Get-ADForest` |

- `-PrefixLength 24` = 255.255.255.0 (CIDR)
- `` ` `` aan het eind van een regel = het commando loopt door op de volgende regel
- Lees de uitvoer: **Success** ≠ **SuccessRestartRequired**
- DSRM-wachtwoord = herstelmodus, als SecureString, **nooit platte tekst**

---

## Week 4 · Netwerkdiensten (DNS en DHCP)
| Wat | PowerShell |
|---|---|
| Zones bekijken | `Get-DnsServerZone` |
| Records bekijken | `Get-DnsServerResourceRecord -ZoneName "rkst-kyan42.local"` |
| A-record (naam → IP) | `Add-DnsServerResourceRecordA -ZoneName "…" -Name "srv-web" -IPv4Address 192.168.42.20` |
| CNAME (alias) | `Add-DnsServerResourceRecordCName -ZoneName "…" -Name "intranet" -HostNameAlias "srv-web.rkst-kyan42.local"` |
| Reverse zone (IP → naam) | `Add-DnsServerPrimaryZone -NetworkId "192.168.42.0/24" -ReplicationScope "Forest"` |
| PTR-record | `Add-DnsServerResourceRecordPtr -ZoneName "42.168.192.in-addr.arpa" -Name "20" -PtrDomainName "srv-web.…"` |
| **Testen** | `Resolve-DnsName srv-web.rkst-kyan42.local` · `Resolve-DnsName 192.168.42.20` |
| DHCP installeren | `Install-WindowsFeature DHCP -IncludeManagementTools` |
| **DHCP autoriseren** | `Add-DhcpServerInDC -DnsName "dc-kyan.rkst-kyan42.local" -IPAddress 192.168.42.10` · controle `Get-DhcpServerInDC` |
| Scope | `Add-DhcpServerv4Scope -Name "Vestiging" -StartRange 192.168.42.50 -EndRange 192.168.42.150 -SubnetMask 255.255.255.0 -State Active` |
| Opties 3 en 6 | `Set-DhcpServerv4OptionValue -ScopeId 192.168.42.0 -Router 192.168.42.1 -DnsServer 192.168.42.10` |
| Reservering | `Add-DhcpServerv4Reservation -ScopeId 192.168.42.0 -IPAddress 192.168.42.60 -ClientId "00-11-22-33-44-55" -Name "Printer"` |

- **Waarom autoriseren?** Een niet-geautoriseerde DHCP-server in een AD-domein deelt **geen** adressen uit. Dat beschermt tegen een **rogue DHCP-server** (iemand die een eigen DHCP-server in je netwerk hangt).
- `-ScopeId` = het **netwerkadres** (eindigt op .0), niet het serveradres.
- `-ClientId` = MAC-adres. Die client krijgt **altijd** hetzelfde IP.
- DHCP-optie 6 vertelt clients **wie** de DNS-server is. Daarom zijn DNS en DHCP een duo.

---

## Week 5 · De vestiging gaat open
### Disk-pipeline (3 wizards in 1)
```powershell
Get-Disk | Where-Object PartitionStyle -eq 'RAW' |
    Initialize-Disk -PartitionStyle GPT -PassThru |
    New-Partition -DriveLetter D -UseMaximumSize |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel "DATA"
```
- `-PassThru` = geef het object door aan de volgende cmdlet (anders geeft Initialize-Disk niets door)
- filter op `RAW` = nooit per ongeluk de systeemschijf. Eerst `Get-Disk` los draaien en **kijken**

### Verborgen share
```powershell
New-SmbShare -Name "Homedirs$" -Path "D:\Homedirs" -FullAccess "RKST-KYAN\Domain Admins" -ChangeAccess "RKST-KYAN\Domain Users"
Get-SmbShare
```
- `$` achter de naam = **verborgen** (niet zichtbaar bij bladeren)
- **Share-rechten + NTFS-rechten: de strengste wint**

### OU's
```powershell
New-ADOrganizationalUnit -Name "Vestiging-Kyan" -Path "DC=rkst-kyan42,DC=local"
New-ADOrganizationalUnit -Name "Medewerkers" -Path "OU=Vestiging-Kyan,DC=rkst-kyan42,DC=local"
```
- Distinguished name lees je van **klein naar groot**: `OU=Medewerkers,OU=Vestiging-Kyan,DC=rkst-kyan42,DC=local`
- `ProtectedFromAccidentalDeletion` staat automatisch aan. Verwijderen kan pas na `Set-ADOrganizationalUnit … -ProtectedFromAccidentalDeletion $false`

### Bulk: Import-Csv + New-ADUser (het skelet)
```powershell
$wachtwoord = Read-Host -AsSecureString "Startwachtwoord"
$personeel  = Import-Csv C:\Scripts\personeel.csv
foreach ($p in $personeel) {
    $sam = ($p.Voornaam.Substring(0,1) + $p.Achternaam + "42").ToLower()
    if (Get-ADUser -Filter "SamAccountName -eq '$sam'") {
        Write-Warning "$sam bestaat al - overgeslagen"
    } else {
        New-ADUser -Name "$($p.Voornaam) $($p.Achternaam)" -GivenName $p.Voornaam -Surname $p.Achternaam `
            -SamAccountName $sam -UserPrincipalName "$sam@rkst-kyan42.local" `
            -Path "OU=Medewerkers,OU=Vestiging-Kyan,DC=rkst-kyan42,DC=local" `
            -AccountPassword $wachtwoord -Enabled $true -ChangePasswordAtLogon $true `
            -HomeDirectory "\\DC-KYAN\Homedirs$\$sam" -HomeDrive "H:"
    }
}
```
**De 3 professionele details:**
1. **Bestaat-al-controle**: zonder die check crasht je script bij de 2e run.
2. **Wachtwoord**: nooit platte tekst, maar `Read-Host -AsSecureString` + `-ChangePasswordAtLogon $true`.
3. **Home directory**: map per gebruiker + `-HomeDirectory` (**UNC-pad naar de share!**) + `-HomeDrive`.

> Valkuil: `"van der Heijden"` geeft een spatie in de gebruikersnaam. Haal spaties en tekens weg: `-replace '[^a-zA-Z]', ''`.

---

## Week 6 · REST API's (GET)
| Begrip | Betekent |
|---|---|
| **Endpoint** | URL van het "loket", bijv. `https://opendata.rdw.nl/resource/m9d7-ebf2.json` |
| **HTTP-werkwoord** | GET = ophalen · POST = aanmaken · PUT = wijzigen · DELETE = verwijderen (≈ Get-/New-/Set-/Remove-) |
| **Querystring** | filter achter het `?`: `?kenteken=AB123C&units=metric` |
| **Statuscode** | 200 OK · 401 niet geautoriseerd · 404 bestaat niet · 500 serverfout |
| **JSON** | `{ }` = object, `[ ]` = lijst. `Invoke-RestMethod` maakt er **automatisch objecten** van |

```powershell
$auto = Invoke-RestMethod -Uri "https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=AB123C"
$auto | Get-Member                                    # ALTIJD eerst kijken welke velden er zijn
$auto | Select-Object kenteken, merk, eerste_kleur, catalogusprijs
if ($auto) { "gevonden" } else { "niet gevonden" }    # onbekend kenteken = LEGE lijst, geen fout
```
- RDW: kenteken in **hoofdletters zonder streepjes**: `$k.ToUpper() -replace '-',''`
- **API-key nooit in je script** (ook niet in een screenshot):
```powershell
$key = Get-Content "C:\Scripts\geheim\owm.key"
Invoke-RestMethod "https://api.openweathermap.org/data/2.5/weather?q=Doetinchem&appid=$key&units=metric&lang=nl"   # key in querystring
Invoke-RestMethod "https://api.voorbeeld.nl/data" -Headers @{ "Authorization" = "Bearer $key" }                     # key in header
```

---

## Week 7 · Data terugsturen (POST)
```powershell
$boeking = @{ naam = "Kyan"; reisId = 3 }                   # 1. hashtable
$antwoord = Invoke-RestMethod -Uri "http://localhost:8080/api/boekingen" `
    -Method Post `                                          # 2. anders doet hij een GET
    -Body ($boeking | ConvertTo-Json) `                     # 3. JSON, niet de hashtable zelf
    -ContentType "application/json"                         # 4. zo leest de server de body
```
**Klassieke beginnersfout:** één van `-Method Post`, `ConvertTo-Json` of `-ContentType` vergeten (getest: geeft een **400**).

| Code | Betekenis | Wiens schuld |
|---|---|---|
| **200** OK | gelukt (GET) | – |
| **201** Created | gelukt **en** iets aangemaakt: hét succes bij POST | – |
| **400** Bad Request | body klopt niet (geen JSON, velden missen) | jij |
| **401** Unauthorized | key/inlog ontbreekt of is fout | jij |
| **404** Not Found | endpoint of id bestaat niet | jij |
| **405** Method Not Allowed | goed endpoint, verkeerd werkwoord | jij |
| **500** Server Error | de server ging stuk | zij |

```powershell
try {
    $antwoord = Invoke-RestMethod -Uri $url -Method Post -Body $json -ContentType "application/json" -ErrorAction Stop
} catch {
    $code = [int]$_.Exception.Response.StatusCode
    switch ($code) {
        400 { Write-Warning "Body afgekeurd: controleer je velden." }
        404 { Write-Warning "Niet gevonden: bestaat het id wel?" }
        default { Write-Warning "Onverwachte fout ($code)." }
    }
}
```
> Is `$_.Exception.Response` **leeg** (`$null`)? Dan kwam er **geen** antwoord: de API is **niet bereikbaar** (niet gestart / verkeerde poort).

---

## Week 8 · De keten
**HR-API → gebruikersnaam → AD-account + homedir → rapport (POST) → bevestigingsnummer.** Geen nieuwe stof, wel alles samen. Uitgewerkt en getest: [week8-Keten-Onboarding.ps1](scripts/week8-Keten-Onboarding.ps1).

```powershell
$antwoord  = Invoke-RestMethod "$ApiUrl/api/medewerkers"    # i.p.v. Import-Csv
$personeel = $antwoord.medewerkers                           # velden: voornaam, achternaam, afdeling, personeelsnummer
foreach ($m in $personeel) { ... }                           # dezelfde loop als week 5
```

**Drie fouttypen, drie reacties:**
| Fout | Reactie |
|---|---|
| API **niet bereikbaar** (niet gestart, verkeerde poort) | **stoppen** met een duidelijke melding: geen data = geen zin |
| API **weigert** (4xx: sessiecode fout, veld mist) | statuscode uitlezen, per code een eigen melding **én** log |
| **AD-fout bij één gebruiker** (bestaat al, ongeldige naam) | **die ene overslaan** met een waarschuwing, **doorgaan** met de rest |

> 🔑 **De try/catch hoort BINNEN je foreach**, niet eromheen. Anders stopt de hele onboarding bij medewerker 3, en staan er 7 mensen maandag zonder account.

**Rapport terugsturen:**
```powershell
$aangemaakt += [PSCustomObject]@{ naam = $naam; samaccountname = $sam }   # tijdens de loop verzamelen
$body = @{ sessiecode = $sessie.sessiecode; accounts = $aangemaakt }
$bevestiging = Invoke-RestMethod "$ApiUrl/api/rapport" -Method Post `
    -Body ($body | ConvertTo-Json -Depth 4) -ContentType "application/json"
```
- **`-Depth 4`**: standaard gaat ConvertTo-Json maar **2 niveaus** diep. Alles wat dieper zit, wordt platte tekst zoals `"@{naam=Roos; sam=r}"` (getest) en is voor de API onleesbaar. Je stuurt een lijst objecten **binnen** een object, dus neem de veilige marge: `-Depth 4`.
- Antwoord: **bevestigingsnummer** + **compleet**. Is compleet `false`? Kijk dan naar **ontbrekend** (niet teruggemeld) en **onbekend** (namen die de API niet kent).
- Geef per account minimaal **naam** + **samaccountname** mee.
- Meld bij een 2e run ook de **al bestaande** accounts terug, anders is het rapport niet compleet.

**Rubric:** werkende keten 40% · robuustheid 20% · codekwaliteit 20% · verdediging 20%.
**Knock-out:** geen wachtwoorden of keys in je code · sessiecode en bevestigingsnummer moeten kloppen met je screenshots en logboek.
