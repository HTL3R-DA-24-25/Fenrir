$domain = "corp.fenrir-ot.at"
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ("$domain\Administrator", $passwordSecure)
Add-Computer -Credential $Credential -DomainName $domain -Restart -Force