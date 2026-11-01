<#
  NAGEBOOTSTE OEFEN-API (week 7 "Data terugsturen"), lijkt op de RKST Oefen-API van school.
    GET  /api/reizen     -> lijst reizen met id
    GET  /api/boekingen  -> boekingen van deze sessie
    POST /api/boekingen  -> body { naam, reisId }  -> 201 Created { boekingsnummer, ... }
                            400 = geen JSON / velden missen, 404 = reisId bestaat niet, 405 = verkeerd werkwoord
  Starten: .\boekingen-api-nagebootst.ps1     (http://localhost:8080)
#>
param([int]$Poort = 8080)

$reizen = @(
    [pscustomobject]@{ id = 1; bestemming = 'Barcelona'; dagen = 5; prijs = 499 }
    [pscustomobject]@{ id = 2; bestemming = 'Rome';      dagen = 4; prijs = 449 }
    [pscustomobject]@{ id = 3; bestemming = 'Berlijn';   dagen = 3; prijs = 299 }
    [pscustomobject]@{ id = 4; bestemming = 'Lissabon';  dagen = 6; prijs = 579 }
)
$boekingen = [System.Collections.Generic.List[object]]::new()

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$Poort/")
$listener.Start()
Write-Host "Oefen-API draait op http://localhost:$Poort" -ForegroundColor Green

function Stuur($ctx, [int]$code, $obj) {
    $bytes = [Text.Encoding]::UTF8.GetBytes(($obj | ConvertTo-Json -Depth 5))
    $ctx.Response.StatusCode = $code
    $ctx.Response.ContentType = 'application/json; charset=utf-8'
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $ctx.Response.Close()
    Write-Host ("{0}  {1} {2} -> {3}" -f (Get-Date -Format HH:mm:ss), $ctx.Request.HttpMethod, $ctx.Request.Url.AbsolutePath, $code)
}

try {
    while ($listener.IsListening) {
        $ctx = $listener.GetContext()
        $pad = $ctx.Request.Url.AbsolutePath.TrimEnd('/')
        switch ("$($ctx.Request.HttpMethod) $pad") {
            'GET /api/reizen'     { Stuur $ctx 200 $reizen }
            'GET /api/boekingen'  { Stuur $ctx 200 @($boekingen) }
            'POST /api/boekingen' {
                $tekst = [IO.StreamReader]::new($ctx.Request.InputStream).ReadToEnd()
                if ($ctx.Request.ContentType -notlike 'application/json*') { Stuur $ctx 400 @{ fout = 'ContentType moet application/json zijn' }; break }
                try { $b = $tekst | ConvertFrom-Json } catch { Stuur $ctx 400 @{ fout = 'Body is geen geldige JSON' }; break }
                if (-not $b.naam -or -not $b.reisId) { Stuur $ctx 400 @{ fout = 'Velden naam en reisId zijn verplicht' }; break }
                $reis = $reizen | Where-Object id -eq $b.reisId
                if (-not $reis) { Stuur $ctx 404 @{ fout = "Reis $($b.reisId) bestaat niet" }; break }
                $nieuw = [pscustomobject]@{
                    boekingsnummer = 'B' + (Get-Date -Format 'HHmmss') + (Get-Random -Minimum 10 -Maximum 99)
                    naam = $b.naam; reisId = $reis.id; bestemming = $reis.bestemming
                }
                $boekingen.Add($nieuw)
                Stuur $ctx 201 $nieuw
            }
            default {
                if ($pad -in '/api/reizen','/api/boekingen') { Stuur $ctx 405 @{ fout = 'Method Not Allowed' } }
                else { Stuur $ctx 404 @{ fout = 'Not Found' } }
            }
        }
    }
} finally { $listener.Stop() }
