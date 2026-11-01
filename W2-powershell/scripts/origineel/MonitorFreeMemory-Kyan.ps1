<#
  Scriptnaam : MonitorFreeMemory-Kyan.ps1
  Functie    : Meet het vrije fysieke geheugen van deze machine gedurende een aantal seconden
               en schrijft de metingen weg als SQL-query (INSERT) in een resultatenbestand.
  Origineel  : Olaf Ritman (versie 1.0, 12 oktober 2022)
  Aangepast  : Kyan Wossink
  Versie     : 1.1
  Datum      : 13 oktober 2026

  Gebruik    : .\MonitorFreeMemory-Kyan.ps1
               .\MonitorFreeMemory-Kyan.ps1 -Seconden 30 -Resultaatbestand Geheugen.sql
               .\MonitorFreeMemory-Kyan.ps1 30 Geheugen.sql
#>

param(
    [ValidateRange(1, 3600)]
    [int]$Seconden = 15,
    [string]$Resultaatbestand = "Resultaten.sql"
)

# ---- Instellingen ----
$Interval = 3                      # aantal seconden tussen twee metingen
$Computer = $env:COMPUTERNAME
$Kopregel = "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"

Clear-Host

# ---- Bestaat het resultatenbestand al? ----
if (Test-Path -LiteralPath $Resultaatbestand) {
    Write-Host "LET OP: " -ForegroundColor Yellow -NoNewline
    Write-Host "$Resultaatbestand bestaat al. Wat wil je doen?"
    Write-Host "  [1] Nieuwe metingen toevoegen"
    Write-Host "  [2] Bestand leegmaken en opnieuw beginnen"
    Write-Host "  [9] Stoppen"

    # blijf vragen tot er een geldige keuze is
    do {
        $keuze = Read-Host "Maak je keuze"
    } until ($keuze -in "1", "2", "9")

    switch ($keuze) {
        "1" {
            # nieuw INSERT-blok, want het vorige blok is afgesloten met ;
            Add-Content -Path $Resultaatbestand -Value $Kopregel
        }
        "2" {
            Set-Content -Path $Resultaatbestand -Value "DELETE FROM MemoryUsage WHERE ID > 0;"
            Add-Content -Path $Resultaatbestand -Value $Kopregel
        }
        "9" {
            Write-Host "Script gestopt, er is niets gemeten."
            exit
        }
    }
}
else {
    Set-Content -Path $Resultaatbestand -Value "DELETE FROM MemoryUsage WHERE ID > 0;"
    Add-Content -Path $Resultaatbestand -Value $Kopregel
}

# ---- Meten ----
$stopTijd       = (Get-Date).AddSeconds($Seconden)
$aantalMetingen = 0

Clear-Host
$titel = "Vrij fysiek geheugen meten op $Computer gedurende $Seconden seconden"
Write-Host $titel -ForegroundColor Cyan
Write-Host ("-" * $titel.Length)

while ((Get-Date) -lt $stopTijd) {
    $os       = Get-CimInstance -ClassName Win32_OperatingSystem
    $vrijKB   = $os.FreePhysicalMemory          # Windows geeft dit in KB
    $vrijMB   = [math]::Round($vrijKB / 1024)
    $sqlDatum = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Add-Content -Path $Resultaatbestand -Value "('$Computer',$vrijKB,'$sqlDatum'),"
    $aantalMetingen++

    Write-Host "$sqlDatum   vrij geheugen: $vrijMB MB ($vrijKB KB)"

    # aftellen tot de volgende meting
    for ($i = $Interval; $i -gt 0; $i--) {
        Write-Host -NoNewline "   volgende meting over $i sec...`r"
        Start-Sleep -Seconds 1
    }
}

# ---- SQL netjes afsluiten ----
# de laatste regel eindigt op een komma; die moet een ; worden, anders is de query ongeldig
$regels = @(Get-Content -Path $Resultaatbestand)
$regels[-1] = $regels[-1].TrimEnd(",") + ";"
Set-Content -Path $Resultaatbestand -Value $regels

# ---- Afronden ----
$volledigPad = (Resolve-Path -LiteralPath $Resultaatbestand).Path

Clear-Host
Write-Host "Klaar! $aantalMetingen metingen opgeslagen in: " -NoNewline
Write-Host $volledigPad -ForegroundColor Green

do {
    $openen = Read-Host "`nWil je het bestand openen? (j/n)"
} until ($openen -in "j", "n")

if ($openen -eq "j") {
    notepad.exe $volledigPad
}
else {
    Write-Host "Prima, het bestand wordt niet geopend."
}

Write-Host ("=" * 45)
Write-Host "Script afgerond op $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')"
