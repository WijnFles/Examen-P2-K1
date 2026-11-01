<#
  Scriptnaam : Get-Voertuig en Get-Weer      (week 6 - REST API's: GET)
  Functie    : Twee herbruikbare functies rond een API, met invoer-opschoning
               en foutafhandeling op statuscodes.
  Auteur     : Kyan Wossink
  Gebruik    : . .\week6-Get-Voertuig-en-Get-Weer.ps1        (functies inladen)
               Get-Voertuig -Kenteken "ab-123-c"
               Get-Weer -Plaats "Doetinchem"
  LET OP     : de API-key staat NIET in dit script, maar in C:\Scripts\geheim\owm.key
#>

function Get-Voertuig {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Kenteken
    )
    # invoer opschonen: RDW wil HOOFDLETTERS zonder streepjes/spaties (ab-123-c -> AB123C)
    $schoon = $Kenteken.ToUpper() -replace '[^A-Z0-9]', ''

    try {
        $auto = Invoke-RestMethod -Uri "https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=$schoon" -ErrorAction Stop
    } catch {
        Write-Warning "RDW niet bereikbaar: $($_.Exception.Message)"
        return
    }

    # een onbekend kenteken geeft GEEN fout maar een lege lijst -> zelf controleren
    if ($auto) {
        $auto | Select-Object kenteken, merk, handelsbenaming, eerste_kleur, catalogusprijs, datum_eerste_toelating
    } else {
        Write-Warning "Kenteken $schoon niet gevonden bij de RDW."
    }
}

function Get-Weer {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Plaats,
        [string]$KeyBestand = "C:\Scripts\geheim\owm.key"
    )
    if (-not (Test-Path $KeyBestand)) {
        Write-Warning "Keybestand $KeyBestand niet gevonden."
        return
    }
    $key = (Get-Content $KeyBestand -Raw).Trim()      # key uit een apart bestand, NOOIT hardcoded

    $url = "https://api.openweathermap.org/data/2.5/weather?q=$($Plaats.Trim())&appid=$key&units=metric&lang=nl"
    try {
        $weer = Invoke-RestMethod -Uri $url -ErrorAction Stop
        [PSCustomObject]@{
            Plaats       = $weer.name
            Temperatuur  = "$([math]::Round($weer.main.temp,1)) C"
            Omschrijving = $weer.weather[0].description
            Wind         = "$($weer.wind.speed) m/s"
            Luchtvochtig = "$($weer.main.humidity) %"
        }
    } catch {
        if ($null -eq $_.Exception.Response) { Write-Warning "Geen verbinding met OpenWeatherMap."; return }
        $code = [int]$_.Exception.Response.StatusCode
        switch ($code) {
            401 { Write-Warning "401: API-key ontbreekt of is ongeldig (nieuwe keys werken soms pas na een uur)." }
            404 { Write-Warning "404: plaats '$Plaats' niet gevonden." }
            429 { Write-Warning "429: te veel aanvragen, wacht even." }
            default { Write-Warning "Onverwachte fout ($code)." }
        }
    }
}

# --- voorbeelden ---
# Get-Voertuig -Kenteken "ab-123-c"
# Get-Weer -Plaats "Doetinchem"
# Get-Weer -Plaats "Doetinchem" | Export-Csv C:\Scripts\weer.csv -Append -NoTypeInformation
# Header-variant (zakelijke API's):
# Invoke-RestMethod -Uri "https://api.voorbeeld.nl/data" -Headers @{ "Authorization" = "Bearer $key" }
