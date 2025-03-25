$hostname = "Exchange"
$domain = "corp.fenrir-ot.at"
$netbios = "CORP"
$password = "&Administrator-!GuteDiese%4499"
$passwordSecure = $(ConvertTo-SecureString $password -AsPlainText -Force)
$packages = ("Server-Media-Foundation", "NET-Framework-45-Core", "NET-Framework-45-ASPNET", "NET-WCF-HTTP-Activation45", "NET-WCF-Pipe-Activation45", "NET-WCF-TCP-Activation45", "NET-WCF-TCP-PortSharing45", "RPC-over-HTTP-proxy", "RSAT-Clustering", "RSAT-Clustering-CmdInterface", "RSAT-Clustering-PowerShell", "WAS-Process-Model", "Web-Asp-Net45", "Web-Basic-Auth", "Web-Client-Auth", "Web-Digest-Auth", "Web-Dir-Browsing", "Web-Dyn-Compression", "Web-Http-Errors", "Web-Http-Logging", "Web-Http-Redirect", "Web-Http-Tracing", "Web-ISAPI-Ext", "Web-ISAPI-Filter", "Web-Metabase", "Web-Mgmt-Service", "Web-Net-Ext45", "Web-Request-Monitor", "Web-Server", "Web-Stat-Compression", "Web-Static-Content", "Web-Windows-Auth", "Web-WMI", "RSAT-ADDS")

$adapterTable = @(
    @{
        "Name"      = "Ethernet1"
        "NewName"   = "DMZ"
        "IPAddress" = "192.168.30.100/24"
        "Gateway"   = "192.168.30.254"
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
