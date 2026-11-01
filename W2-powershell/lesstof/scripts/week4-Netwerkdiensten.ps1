<#
  Scriptnaam : Netwerkdiensten.ps1        (week 4 - DNS en DHCP)
  Functie    : DNS-records en reverse zone + DHCP installeren, autoriseren,
               scope met opties en een reservering. Met param-blok en logging.
  Auteur     : Kyan Wossink
  Gebruik    : .\Netwerkdiensten.ps1
               .\Netwerkdiensten.ps1 -Zone "rkst-kyan42.local" -Netwerk "192.168.42"
#>
param (
    [string]$Zone      = "rkst-kyan42.local",
    [string]$Netwerk   = "192.168.42",          # eerste drie octetten
    [string]$DcNaam    = "dc-kyan",
    [int]$DcHost       = 10,                    # DC = .10
    [int]$Gateway      = 1,                     # router = .1
    [int]$ScopeStart   = 50,
    [int]$ScopeEind    = 150,
    [string]$PrinterMac = "00-11-22-33-44-55",
    [string]$LogPad    = "C:\Scripts\netwerk-log.txt"
)

function Schrijf-Log {
    param ([string]$Tekst)
    Add-Content -Path $LogPad -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Tekst"
}

$DcIp = "$Netwerk.$DcHost"
$o = $Netwerk.Split('.')
$RevZone = "$($o[2]).$($o[1]).$($o[0]).in-addr.arpa"      # 192.168.42 -> 42.168.192.in-addr.arpa

# ---------------- DNS ----------------
try {
    # A-record (naam -> IP) en CNAME (alias -> naam)
    Add-DnsServerResourceRecordA -ZoneName $Zone -Name "srv-web" -IPv4Address "$Netwerk.20" -ErrorAction Stop
    Add-DnsServerResourceRecordCName -ZoneName $Zone -Name "intranet" -HostNameAlias "srv-web.$Zone" -ErrorAction Stop

    # Reverse lookup zone (IP -> naam) + PTR-record
    if (-not (Get-DnsServerZone -Name $RevZone -ErrorAction SilentlyContinue)) {
        Add-DnsServerPrimaryZone -NetworkId "$Netwerk.0/24" -ReplicationScope "Forest" -DynamicUpdate Secure -ErrorAction Stop
    }
    Add-DnsServerResourceRecordPtr -ZoneName $RevZone -Name "20" -PtrDomainName "srv-web.$Zone" -ErrorAction Stop
    Schrijf-Log "DNS: A srv-web, CNAME intranet, reverse zone + PTR aangemaakt"
}
catch {
    Write-Warning "DNS-fout: $($_.Exception.Message)"
    Schrijf-Log "FOUT DNS: $($_.Exception.Message)"
}

# ---------------- DHCP ----------------
try {
    Install-WindowsFeature DHCP -IncludeManagementTools -ErrorAction Stop | Out-Null
    # AUTORISEREN in AD - anders deelt de server geen adressen uit (bescherming tegen rogue DHCP)
    Add-DhcpServerInDC -DnsName "$DcNaam.$Zone" -IPAddress $DcIp -ErrorAction Stop

    Add-DhcpServerv4Scope -Name "Vestiging Kyan" `
        -StartRange "$Netwerk.$ScopeStart" -EndRange "$Netwerk.$ScopeEind" `
        -SubnetMask 255.255.255.0 -State Active -ErrorAction Stop

    # Optie 3 (router) en 6 (DNS); ScopeId = netwerkadres (.0), niet het serveradres
    Set-DhcpServerv4OptionValue -ScopeId "$Netwerk.0" -Router "$Netwerk.$Gateway" -DnsServer $DcIp -ErrorAction Stop

    # Reservering: printer krijgt altijd .60
    Add-DhcpServerv4Reservation -ScopeId "$Netwerk.0" -IPAddress "$Netwerk.60" -ClientId $PrinterMac -Name "Printer" -ErrorAction Stop
    Schrijf-Log "DHCP: geinstalleerd, geautoriseerd, scope $ScopeStart-$ScopeEind, opties, reservering .60"
}
catch {
    Write-Warning "DHCP-fout: $($_.Exception.Message)"
    Schrijf-Log "FOUT DHCP: $($_.Exception.Message)"
}

# ---------------- Controle ----------------
Resolve-DnsName "srv-web.$Zone"
Resolve-DnsName "$Netwerk.20"
Get-DhcpServerInDC
Get-DhcpServerv4Scope
Get-DhcpServerv4Reservation -ScopeId "$Netwerk.0"
