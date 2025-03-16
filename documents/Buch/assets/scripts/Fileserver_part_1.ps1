$hostname = "Fileserver"
$domain = "corp.fenrir-ot.at"
$netbios = "CORP"
$password = "&Administrator-!GuteDiese%4499"
$passwordSecure = $(ConvertTo-SecureString $password -AsPlainText -Force)
$packages = ("FS-FileServer")

$adapterTable = @(
    @{
        "Name"      = "Ethernet1"
        "NewName"   = "OT-DMZ"
        "IPAddress" = "192.168.33.100/24"
        "Gateway"   = "192.168.33.254"
        "DNS"       = "192.168.31.1"
        "DNSAlt"    = "192.168.31.2"
    }
)

# Packages installieren
foreach ($package in $packages) {
    Install-WindowsFeature -Name $package -IncludeManagementTools -IncludeAllSubFeature
}

Rename-Computer -NewName $hostname -Force
foreach ($adapter in $adapterTable) {
    $adapterObject = $null
    if ( Get-NetAdapter | Where-Object { $_.MacAddress -contains $adapter.MAC }) {
        $adapterObject = Get-NetAdapter | Where-Object { $_.MacAddress -eq $adapter.MAC }
    }
    elseif ((Get-NetAdapter).Name -contains $adapter.Name) {
        $adapterObject = Get-NetAdapter $adapter.Name
    }
    else {
        Write-Host "Adapter not found: $($adapter.Name)"
        continue
    }
    if ($adapter.NewName) {
        Rename-NetAdapter -Name $adapterObject.Name -NewName $adapter.NewName
    }
    if ($adapter.IPAddress -eq "DHCP") {
        Set-NetIPInterface -InterfaceIndex $adapterObject.ifIndex -Dhcp Enabled
    }
    else {
        $ip = $adapter.IPAddress.Split("/")
        $subnet = $ip[1]
        $ip = $ip[0]
        if ($null -ne $adapter.Gateway) {
            New-NetIPAddress -InterfaceIndex $adapterObject.ifIndex -IPAddress $ip -PrefixLength $subnet -DefaultGateway $adapter.Gateway
        }
        else {
            New-NetIPAddress -InterfaceIndex $adapterObject.ifIndex -IPAddress $ip -PrefixLength $subnet
        }
        Set-NetIPInterface -InterfaceIndex $adapterObject.ifIndex -InterfaceMetric 10 
    }
    if ($adapter.DNS) {
        if ($adapter.DNSAlt) {
            Set-DnsClientServerAddress -InterfaceIndex $adapterObject.ifIndex -ServerAddresses ($adapter.DNS", "$adapter.DNSAlt)
        }
        else {
            Set-DnsClientServerAddress -InterfaceIndex $adapterObject.ifIndex -ServerAddresses $adapter.DNS
        }
    }
}
