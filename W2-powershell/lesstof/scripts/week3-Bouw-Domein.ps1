<#
  Scriptnaam : Bouw-Domein.ps1            (week 3 - De server uit het niets)
  Functie    : Statisch IP + DNS, hernoemen, AD DS installeren en een nieuw forest.
  Auteur     : Kyan Wossink
  LET OP     : MAAK EERST EEN SNAPSHOT/CHECKPOINT VAN DE VM!
  Gebruik    : Fase 1 (IP + naam, daarna herstart):  .\Bouw-Domein.ps1 -Fase 1
               Fase 2 (rol + forest, herstart auto): .\Bouw-Domein.ps1 -Fase 2
#>
param (
    [ValidateSet(1, 2)]
    [int]$Fase = 1,
    [string]$NieuweNaam = "DC-KYAN",
    [string]$IpAdres    = "192.168.42.10",
    [int]$Prefix        = 24,                 # 24 = 255.255.255.0
    [string]$Gateway    = "192.168.42.1",
    [string]$DomeinNaam = "rkst-kyan42.local",
    [string]$Netbios    = "RKST-KYAN"
)

if ($Fase -eq 1) {
    # 3.1 Kijken voordat je verandert
    Get-NetIPConfiguration
    $nic = Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1
    Write-Host "Netwerkkaart: $($nic.Name) (InterfaceIndex $($nic.ifIndex))"

    # Statisch IP + gateway, DNS naar zichzelf (wordt straks de DNS-server)
    New-NetIPAddress -InterfaceIndex $nic.ifIndex -IPAddress $IpAdres -PrefixLength $Prefix -DefaultGateway $Gateway
    Set-DnsClientServerAddress -InterfaceIndex $nic.ifIndex -ServerAddresses $IpAdres

    # 3.2 Hernoemen VOOR het promoveren; pas actief na herstart
    Rename-Computer -NewName $NieuweNaam -Restart       # eerst proberen met -WhatIf
}
else {
    # 3.3 Rol installeren (incl. beheertools zoals ADUC)
    Get-WindowsFeature *AD*
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools    # lees de uitvoer: Success / SuccessRestartRequired

    # 3.4 Promoveren tot DC in een nieuw forest (= de hele promotiewizard)
    Install-ADDSForest `
        -DomainName $DomeinNaam `
        -DomainNetbiosName $Netbios `
        -InstallDns `
        -SafeModeAdministratorPassword (Read-Host -AsSecureString "DSRM-wachtwoord")
    # server herstart automatisch; daarna inloggen als RKST-KYAN\Administrator en controleren:
    # Get-ADDomain | Select DNSRoot, NetBIOSName, PDCEmulator
    # Get-ADForest | Select Name, ForestMode, RootDomain
}
