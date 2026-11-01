<#
  Scriptnaam : Vestiging-Bulk.ps1         (week 5 - De vestiging gaat open)
  Functie    : Deel A (eenmalig): datadisk, verborgen share Homedirs$, OU-structuur.
               Deel B: gebruikers in bulk aanmaken uit personeel.csv met home directory,
               bestaat-al-controle, logging en try/catch per gebruiker.
  Auteur     : Kyan Wossink
  Gebruik    : .\Vestiging-Bulk.ps1 -CsvPad C:\Scripts\personeel.csv
               .\Vestiging-Bulk.ps1 -MaakFundament     (alleen de eerste keer: disk/share/OU's)
  CSV-kolommen: Voornaam;Achternaam;Afdeling   (zie personeel.csv)
#>
param (
    [string]$CsvPad    = "C:\Scripts\personeel.csv",
    [string]$Domein    = "DC=rkst-kyan42,DC=local",
    [string]$UpnSuffix = "rkst-kyan42.local",
    [string]$Netbios   = "RKST-KYAN",
    [string]$Server    = "DC-KYAN",
    [string]$Suffix    = "42",
    [string]$LogPad    = "C:\Scripts\bulk-log.txt",
    [switch]$MaakFundament
)

function Schrijf-Log {
    param ([string]$Tekst)
    Add-Content -Path $LogPad -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Tekst"
}

$OuVestiging = "OU=Vestiging-Kyan,$Domein"
$OuMedew     = "OU=Medewerkers,$OuVestiging"

# =================================================================== DEEL A
if ($MaakFundament) {
    # 5.1 Disk: RAW-schijf -> GPT -> partitie D: -> NTFS "DATA"   (eerst Get-Disk los draaien en KIJKEN!)
    Get-Disk | Where-Object PartitionStyle -eq 'RAW' |
        Initialize-Disk -PartitionStyle GPT -PassThru |
        New-Partition -DriveLetter D -UseMaximumSize |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel "DATA-Kyan" -Confirm:$false

    # 5.2 Verborgen share ($ achter de naam)
    New-Item -Path "D:\Homedirs" -ItemType Directory -Force | Out-Null
    New-SmbShare -Name "Homedirs$" -Path "D:\Homedirs" `
        -FullAccess "$Netbios\Domain Admins" -ChangeAccess "$Netbios\Domain Users"

    # 5.3 OU's (krijgen automatisch ProtectedFromAccidentalDeletion = $true)
    New-ADOrganizationalUnit -Name "Vestiging-Kyan" -Path $Domein
    New-ADOrganizationalUnit -Name "Medewerkers"    -Path $OuVestiging
    Schrijf-Log "Fundament aangemaakt: disk D:, share Homedirs$, OU's"
}

# =================================================================== DEEL B
$wachtwoord = Read-Host -AsSecureString "Startwachtwoord voor alle nieuwe gebruikers"   # nooit platte tekst!
$personeel  = Import-Csv -Path $CsvPad -Delimiter ';'
$nieuw = 0; $overgeslagen = 0; $fout = 0

foreach ($p in $personeel) {
    # gebruikersnaam: eerste letter voornaam + achternaam zonder spaties + suffix, kleine letters
    $sam  = ($p.Voornaam.Substring(0,1) + ($p.Achternaam -replace '[^a-zA-Z]', '') + $Suffix).ToLower()
    $naam = "$($p.Voornaam) $($p.Achternaam)"

    try {
        if (Get-ADUser -Filter "SamAccountName -eq '$sam'") {
            Write-Warning "$sam bestaat al - overgeslagen"
            Schrijf-Log "OVERGESLAGEN: $sam bestaat al"
            $overgeslagen++
            continue
        }
        $homedir = "D:\Homedirs\$sam"
        New-Item -Path $homedir -ItemType Directory -Force -ErrorAction Stop | Out-Null

        New-ADUser -Name $naam -GivenName $p.Voornaam -Surname $p.Achternaam `
            -SamAccountName $sam -UserPrincipalName "$sam@$UpnSuffix" `
            -Department $p.Afdeling -Path $OuMedew `
            -AccountPassword $wachtwoord -Enabled $true -ChangePasswordAtLogon $true `
            -HomeDirectory "\\$Server\Homedirs$\$sam" -HomeDrive "H:" -ErrorAction Stop

        # NTFS: alleen de gebruiker zelf (en admins) in zijn eigen map
        icacls $homedir /grant "$Netbios\${sam}:(OI)(CI)M" | Out-Null

        Write-Host "Aangemaakt: $sam" -ForegroundColor Green
        Schrijf-Log "AANGEMAAKT: $sam ($naam, $($p.Afdeling))"
        $nieuw++
    }
    catch {
        Write-Warning "Fout bij $sam : $($_.Exception.Message)"
        Schrijf-Log "FOUT: $sam - $($_.Exception.Message)"
        $fout++
    }
}

Write-Host "Klaar: $nieuw aangemaakt, $overgeslagen overgeslagen, $fout fout(en)."
Schrijf-Log "Run klaar: $nieuw aangemaakt, $overgeslagen overgeslagen, $fout fout(en)"

# Controle:
# Get-ADUser -Filter * -SearchBase $OuMedew -Properties HomeDirectory | Select SamAccountName, HomeDirectory
# Get-SmbShare ; Get-ADOrganizationalUnit -Filter * | Select Name, ProtectedFromAccidentalDeletion
# OU toch verwijderen (alleen als het echt moet):
# Set-ADOrganizationalUnit $OuVestiging -ProtectedFromAccidentalDeletion $false ; Remove-ADOrganizationalUnit $OuVestiging -Recursive
