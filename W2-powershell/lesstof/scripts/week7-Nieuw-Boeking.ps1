<#
  Scriptnaam : Nieuw-Boeking.ps1          (week 7 - Data terugsturen)
  Functie    : Plaatst een boeking via POST bij de oefen-API en geeft per statuscode
               een zinvolle melding.
  Auteur     : Kyan Wossink
  Gebruik    : . .\Nieuw-Boeking.ps1                       (functie inladen, "dot-sourcen")
               Nieuw-Boeking -Naam "Kyan" -ReisId 3
#>

function Nieuw-Boeking {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Naam,

        [Parameter(Mandatory = $true)]
        [int]$ReisId,

        [string]$ApiUrl = "http://localhost:8080"
    )

    # 1. hashtable -> 2. ConvertTo-Json -> 3. -Body + -ContentType
    $boeking = @{
        naam   = $Naam.Trim()
        reisId = $ReisId
    }

    try {
        $antwoord = Invoke-RestMethod -Uri "$ApiUrl/api/boekingen" `
            -Method Post `
            -Body ($boeking | ConvertTo-Json) `
            -ContentType "application/json" `
            -ErrorAction Stop

        Write-Host "Boeking gelukt: $($antwoord.boekingsnummer) - $($antwoord.naam) naar $($antwoord.bestemming)" -ForegroundColor Green
        return $antwoord
    }
    catch {
        if ($null -eq $_.Exception.Response) {
            Write-Warning "De API is niet bereikbaar op $ApiUrl. Is hij gestart?"
            return
        }
        $code = [int]$_.Exception.Response.StatusCode
        switch ($code) {
            400 { Write-Warning "400 Bad Request: de body is afgekeurd. Controleer naam en reisId." }
            404 { Write-Warning "404 Not Found: reis $ReisId bestaat niet. Bekijk eerst GET /api/reizen." }
            405 { Write-Warning "405 Method Not Allowed: dit endpoint accepteert deze methode niet." }
            500 { Write-Warning "500 Server Error: de API zelf heeft een probleem. Probeer het later opnieuw." }
            default { Write-Warning "Onverwachte fout ($code): $($_.Exception.Message)" }
        }
    }
}

# --- voorbeelden (uitcommentarieren om te testen) ---
# Invoke-RestMethod http://localhost:8080/api/reizen | Format-Table    # welke reizen/id's zijn er?
# Nieuw-Boeking -Naam "Kyan" -ReisId 3                                  # 201 Created
# Nieuw-Boeking -Naam "Kyan" -ReisId 99                                 # 404
# Invoke-RestMethod http://localhost:8080/api/boekingen                 # controle
