<#
  Scriptnaam : Serverrapport.ps1          (week 2 - Van commando naar script)
  Functie    : Maakt een rapport van een server: OS, vrije schijfruimte en de
               processen met het meeste geheugengebruik. Met param-blok, functie,
               try/catch/finally en logging.
  Auteur     : Kyan Wossink
  Datum      : november 2026
  Gebruik    : .\Serverrapport.ps1 -Servernaam SRV-KYAN
               .\Serverrapport.ps1 -Servernaam SRV-KYAN -AantalProcessen 10
#>
param (
    [Parameter(Mandatory = $true)]          # verplicht: PowerShell vraagt erom als je hem vergeet
    [string]$Servernaam,

    [ValidateRange(1, 50)]                  # alleen 1 t/m 50 toegestaan
    [int]$AantalProcessen = 5,              # standaardwaarde

    [string]$Werkmap = "C:\Scripts"
)

# ---- functies bovenaan (PowerShell leest van boven naar beneden) ----
function Schrijf-Log {
    param ([string]$Tekst)
    $stempel = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "$Werkmap\logboek.txt" -Value "$stempel - $Tekst"
}

# ---- start ----
if (-not (Test-Path $Werkmap)) { New-Item -Path $Werkmap -ItemType Directory | Out-Null }
Schrijf-Log -Tekst "Script gestart voor $Servernaam"
$rapport = "$Werkmap\rapport-$Servernaam-$(Get-Date -Format 'yyyyMMdd-HHmm').txt"

try {
    # -ErrorAction Stop: anders schiet een niet-afbrekende fout LANGS de catch
    $os = Get-CimInstance Win32_OperatingSystem -ComputerName $Servernaam -ErrorAction Stop
    $schijven = Get-CimInstance Win32_LogicalDisk -ComputerName $Servernaam -Filter "DriveType=3" -ErrorAction Stop
    $processen = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First $AantalProcessen

    "Serverrapport $Servernaam - $(Get-Date)"               | Out-File $rapport
    "OS: $($os.Caption)  (laatst opgestart: $($os.LastBootUpTime))" | Out-File $rapport -Append
    foreach ($s in $schijven) {
        "Schijf $($s.DeviceID): $([math]::Round($s.FreeSpace/1GB,1)) GB vrij van $([math]::Round($s.Size/1GB,1)) GB" | Out-File $rapport -Append
    }
    "Top $AantalProcessen processen (geheugen):"             | Out-File $rapport -Append
    $processen | Select-Object Name, Id, @{n='MB';e={[math]::Round($_.WorkingSet64/1MB)}} |
        Format-Table -AutoSize | Out-File $rapport -Append

    Write-Output "Rapport weggeschreven naar $rapport"
    Schrijf-Log -Tekst "Rapport weggeschreven: $rapport"
}
catch {
    Write-Warning "Kon het rapport niet maken: $($_.Exception.Message)"
    Schrijf-Log -Tekst "FOUT: $($_.Exception.Message)"
}
finally {
    Schrijf-Log -Tekst "Poging afgerond"        # draait ALTIJD, ook na een fout
}
