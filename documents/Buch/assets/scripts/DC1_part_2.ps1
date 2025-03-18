# AD DS Installation (Creating Forest & Domain)
$domain = "corp.fenrir-ot.at"
$password = "&Administrator-!GuteDiese%4499"
$passwordSecure = $(ConvertTo-SecureString $password -AsPlainText -Force)
Install-ADDSForest `
    -DomainName $domain `
    -DomainMode WinThreshold -ForestMode WinThreshold `
    -InstallDns:$true `
    -SafeModeAdministratorPassword $passwordSecure `
    -Force
