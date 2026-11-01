<#
  NAGEBOOTSTE HR-API (week 8 "De keten") om thuis mee te oefenen.
  Dit is NIET de API van school, maar doet hetzelfde volgens de lesbrief:
    GET  /api/sessie       -> { sessiecode }
    GET  /api/medewerkers  -> { medewerkers: [ {personeelsnummer, voornaam, achternaam, afdeling}, ... ] }
    POST /api/rapport      -> body { sessiecode, accounts: [ {naam, samaccountname}, ... ] }
                              antwoord 201 { bevestigingsnummer, compleet, ontbrekend, onbekend }
                              400 bij ontbrekende velden/geen JSON, 401 bij foute sessiecode
  Starten (PowerShell als administrator op Windows):   .\hr-api-nagebootst.ps1
  Stoppen: Ctrl+C (soms pas na het volgende request)
#>
param([int]$Poort = 8080, [int]$Aantal = 15)

$voornamen   = 'Anna','Bram','Chris','Daan','Eva','Fleur','Gijs','Hanna','Ivo','Jesse','Kim','Lars','Mila','Noah','Roos','Sem','Tess','Yara'
$achternamen = 'Jansen','de Vries','Bakker','van Dijk','Visser','Smit','Meijer','de Boer','Mulder','van der Heijden','Bos','Vos','Peters','Hendriks'
$afdelingen  = 'Administratie','Magazijn','Sales','ICT'
$sessiecode  = 'RKST-' + (Get-Random -Minimum 1000 -Maximum 9999)
$personeel   = for ($i = 1; $i -le $Aantal; $i++) {
    [pscustomobject]@{
        personeelsnummer = 1000 + $i
        voornaam  = $voornamen | Get-Random
        achternaam = if ($i -eq 1) { 'van der Heijden' } else { $achternamen | Get-Random }
        afdeling  = $afdelingen | Get-Random
    }
}
$personeel[0].voornaam = 'Roos'

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$Poort/")
$listener.Start()
Write-Host "HR-API draait op http://localhost:$Poort  (sessiecode: $sessiecode, $Aantal medewerkers)" -ForegroundColor Green

function Stuur($ctx, [int]$code, $obj) {
    $json  = $obj | ConvertTo-Json -Depth 5
    $bytes = [Text.Encoding]::UTF8.GetBytes($json)
    $ctx.Response.StatusCode = $code
    $ctx.Response.ContentType = 'application/json; charset=utf-8'
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $ctx.Response.Close()
    Write-Host ("{0}  {1} {2} -> {3}" -f (Get-Date -Format HH:mm:ss), $ctx.Request.HttpMethod, $ctx.Request.Url.AbsolutePath, $code)
}

try {
    while ($listener.IsListening) {
        $ctx  = $listener.GetContext()
        $pad  = $ctx.Request.Url.AbsolutePath.TrimEnd('/')
        $verb = $ctx.Request.HttpMethod
        switch ("$verb $pad") {
            'GET /api/sessie'      { Stuur $ctx 200 @{ sessiecode = $sessiecode } }
            'GET /api/medewerkers' { Stuur $ctx 200 @{ aantal = $personeel.Count; medewerkers = @($personeel) } }
            'POST /api/rapport' {
                $tekst = [IO.StreamReader]::new($ctx.Request.InputStream).ReadToEnd()
                try { $body = $tekst | ConvertFrom-Json } catch { Stuur $ctx 400 @{ fout = 'Body is geen geldige JSON (ContentType/ConvertTo-Json vergeten?)' }; break }
                if (-not $body.sessiecode -or -not $body.accounts) { Stuur $ctx 400 @{ fout = 'Velden sessiecode en accounts zijn verplicht' }; break }
                if ($body.sessiecode -ne $sessiecode) { Stuur $ctx 401 @{ fout = 'Onbekende sessiecode' }; break }
                $verwacht   = $personeel | ForEach-Object { "$($_.voornaam) $($_.achternaam)" }
                $gemeld     = @($body.accounts | ForEach-Object { $_.naam })
                $ontbrekend = @($verwacht | Where-Object { $_ -notin $gemeld })
                $onbekend   = @($gemeld   | Where-Object { $_ -notin $verwacht })
                Stuur $ctx 201 @{
                    bevestigingsnummer = 'BEV-' + (Get-Date -Format 'HHmmss') + '-' + (Get-Random -Maximum 999)
                    ontvangen  = $gemeld.Count
                    compleet   = ($ontbrekend.Count -eq 0 -and $onbekend.Count -eq 0)
                    ontbrekend = $ontbrekend
                    onbekend   = $onbekend
                }
            }
            default {
                if ($pad -in '/api/sessie','/api/medewerkers','/api/rapport') { Stuur $ctx 405 @{ fout = "Methode $verb niet toegestaan op $pad" } }
                else { Stuur $ctx 404 @{ fout = "Endpoint $pad bestaat niet" } }
            }
        }
    }
} finally { $listener.Stop() }
