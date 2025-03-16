$domain = "corp.fenrir-ot.at"
$password = "&Administrator-!GuteDiese%4499"
$passwordSecure = $(ConvertTo-SecureString $password -AsPlainText -Force)
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ("$domain\Administrator", $passwordSecure)
Add-Computer -Credential $Credential -DomainName $domain -Restart -Force