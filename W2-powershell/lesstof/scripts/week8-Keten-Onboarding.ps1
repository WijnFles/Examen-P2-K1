<#
  Scriptnaam : Keten-Onboarding.ps1           (week 8 - De keten)
  Functie    : Haalt het personeel op uit de HR-API (GET), maakt per medewerker een
               AD-account + home directory aan, stuurt een rapport terug (POST)
               en toont + logt het bevestigingsnummer.
  Auteur     : Kyan Wossink
  Versie     : 1.0
  Datum      : november 2026

  Gebruik    : .\Keten-Onboarding.ps1
               .\Keten-Onboarding.ps1 -ApiUrl http://localhost:8080 -Suffix 42
  Vereist    : module ActiveDirectory (op de DC), HR-API gestart.

  De vijf schakels:
    1. HR-API: sessiecode + personeel ophalen (GET)
    2. Per medewerker een gebruikersnaam samenstellen
    3. Account + home directory aanmaken in AD (bestaat-al-controle)
    4. Rapport terugsturen met de sessiecode (POST)
    5. Bevestigingsnummer tonen en loggen

  Drie fouttypen:
    API niet bereikbaar  -> stoppen met duidelijke melding (geen data = geen zin)
    API weigert (4xx)    -> statuscode uitlezen, per code eigen melding + log
    AD-fout bij 1 user   -> die ene overslaan met waarschuwing, doorgaan met de rest
#>
param (
    [string]$ApiUrl     = "http://localhost:8080",
    [string]$Domein     = "DC=rkst-kyan42,DC=local",
    [string]$UpnSuffix  = "rkst-kyan42.local",
    [string]$OuPad      = "OU=Medewerkers,OU=Vestiging-Kyan,DC=rkst-kyan42,DC=local",
    [string]$HomeRoot   = "D:\Homedirs",                 # map op de server
    [string]$HomeShare  = "\\DC-KYAN\Homedirs$",         # UNC-pad naar de verborgen share
    [string]$Suffix     = "42",                          # studentnummer-suffix
    [string]$LogPad     = "C:\Scripts\keten-log.txt",
    [securestring]$Wachtwoord                            # leeg = wordt 1x gevraagd
)

# ------------------------------------------------------------------ functies
function Schrijf-Log {
    param ([string]$Tekst, [string]$Niveau = "INFO")
    $stempel = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogPad -Value "$stempel [$Niveau] $Tekst"
}

function New-Gebruikersnaam {
    # "Roos" + "van der Heijden" -> "rvanderheijden42"
    param ([string]$Voornaam, [string]$Achternaam, [string]$Suffix)
    $ruw = $Voornaam.Substring(0,1) + $Achternaam + $Suffix
    # accenten weg (e -> e, o -> o), dan alles behalve a-z en 0-9 weg (spaties, streepjes, apostrof)
    $zonderAccent = -join ($ruw.Normalize([Text.NormalizationForm]::FormD).ToCharArray() |
        Where-Object { [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark' })
    $sam = ($zonderAccent.ToLower() -replace '[^a-z0-9]', '')
    if ($sam.Length -gt 20) { $sam = $sam.Substring(0,20) }   # sAMAccountName max 20 tekens
    return $sam
}

function Toon-ApiFout {
    # Bepaalt het fouttype en geeft een passende melding
    param ($Fout, [string]$Stap)
    if ($null -eq $Fout.Exception.Response) {
        $melding = "API niet bereikbaar bij '$Stap' ($ApiUrl). Is de HR-API gestart, klopt de poort?"
    } else {
        $code = [int]$Fout.Exception.Response.StatusCode
        $melding = switch ($code) {
            400 { "400 Bad Request bij '$Stap': body klopt niet (JSON/velden/-Depth?)" }
            401 { "401 Unauthorized bij '$Stap': sessiecode onjuist" }
            404 { "404 Not Found bij '$Stap': endpoint bestaat niet" }
            405 { "405 Method Not Allowed bij '$Stap': verkeerd werkwoord (GET/POST)" }
            500 { "500 Server Error bij '$Stap': fout aan de kant van de API" }
            default { "Onverwachte fout ($code) bij '$Stap'" }
        }
    }
    Write-Warning $melding
    Schrijf-Log -Tekst $melding -Niveau "FOUT"
}

# ------------------------------------------------------------------ start
Schrijf-Log -Tekst "===== Keten gestart door $env:USERNAME ====="
if (-not $Wachtwoord) {
    $Wachtwoord = Read-Host -AsSecureString "Startwachtwoord voor de nieuwe accounts"
}

# ---- Schakel 1: sessie + personeel ophalen (GET) ----
try {
    $sessie    = Invoke-RestMethod -Uri "$ApiUrl/api/sessie" -ErrorAction Stop
    $antwoord  = Invoke-RestMethod -Uri "$ApiUrl/api/medewerkers" -ErrorAction Stop
    $personeel = $antwoord.medewerkers
} catch {
    Toon-ApiFout -Fout $_ -Stap "personeel ophalen"
    Schrijf-Log -Tekst "Keten gestopt: geen data van de API" -Niveau "FOUT"
    exit 1
}
Write-Host "Sessiecode: $($sessie.sessiecode) - $($personeel.Count) medewerkers ontvangen" -ForegroundColor Cyan
Schrijf-Log -Tekst "Sessiecode $($sessie.sessiecode), $($personeel.Count) medewerkers ontvangen"

# ---- Schakel 2 + 3: per medewerker account + homedir ----
$verwerkt = @()      # wordt teruggestuurd in het rapport
$nieuw = 0; $bestond = 0; $mislukt = 0

foreach ($m in $personeel) {
    $naam = "$($m.voornaam) $($m.achternaam)"
    $sam  = New-Gebruikersnaam -Voornaam $m.voornaam -Achternaam $m.achternaam -Suffix $Suffix

    try {                                                    # try/catch BINNEN de loop
        if (Get-ADUser -Filter "SamAccountName -eq '$sam'") {
            Write-Warning "$sam ($naam) bestaat al - overgeslagen"
            Schrijf-Log -Tekst "$sam ($naam) bestaat al - overgeslagen" -Niveau "WAARSCHUWING"
            $bestond++
        } else {
            $homedir = Join-Path $HomeRoot $sam
            New-Item -Path $homedir -ItemType Directory -Force -ErrorAction Stop | Out-Null

            New-ADUser -Name $naam -GivenName $m.voornaam -Surname $m.achternaam `
                -SamAccountName $sam -UserPrincipalName "$sam@$UpnSuffix" `
                -Department $m.afdeling -EmployeeID $m.personeelsnummer `
                -Path $OuPad -AccountPassword $Wachtwoord -Enabled $true `
                -ChangePasswordAtLogon $true `
                -HomeDirectory "$HomeShare\$sam" -HomeDrive "H:" -ErrorAction Stop

            Write-Host "Aangemaakt: $sam ($naam, $($m.afdeling))" -ForegroundColor Green
            Schrijf-Log -Tekst "Aangemaakt: $sam ($naam, $($m.afdeling))"
            $nieuw++
        }
        # ook bestaande accounts terugmelden, anders is het rapport bij een 2e run niet compleet
        $verwerkt += [PSCustomObject]@{ naam = $naam; samaccountname = $sam; afdeling = $m.afdeling }
    } catch {
        Write-Warning "Mislukt voor $naam ($sam): $($_.Exception.Message)"
        Schrijf-Log -Tekst "Mislukt voor $naam ($sam): $($_.Exception.Message)" -Niveau "FOUT"
        $mislukt++
    }
}
Schrijf-Log -Tekst "Resultaat: $nieuw nieuw, $bestond bestond al, $mislukt mislukt"

# ---- Schakel 4: rapport terugsturen (POST) ----
$body = @{
    sessiecode = $sessie.sessiecode
    accounts   = $verwerkt
}
try {
    $bevestiging = Invoke-RestMethod -Uri "$ApiUrl/api/rapport" -Method Post `
        -Body ($body | ConvertTo-Json -Depth 4) -ContentType "application/json" -ErrorAction Stop
} catch {
    Toon-ApiFout -Fout $_ -Stap "rapport versturen"
    exit 2
}

# ---- Schakel 5: bevestiging tonen en loggen ----
Write-Host ""
Write-Host "Bevestigingsnummer: $($bevestiging.bevestigingsnummer)" -ForegroundColor Green
Write-Host "Compleet          : $($bevestiging.compleet)"
Write-Host "Nieuw / bestond / mislukt: $nieuw / $bestond / $mislukt"
Schrijf-Log -Tekst "Bevestigingsnummer $($bevestiging.bevestigingsnummer), compleet = $($bevestiging.compleet)"
if (-not $bevestiging.compleet) {
    Write-Warning "Rapport niet compleet. Ontbrekend: $($bevestiging.ontbrekend -join ', ') | Onbekend: $($bevestiging.onbekend -join ', ')"
    Schrijf-Log -Tekst "Niet compleet. Ontbrekend: $($bevestiging.ontbrekend -join ', '). Onbekend: $($bevestiging.onbekend -join ', ')" -Niveau "WAARSCHUWING"
}
Schrijf-Log -Tekst "===== Keten afgerond ====="
