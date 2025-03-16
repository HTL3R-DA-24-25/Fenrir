$users = Import-CSV -Path "D:\users.csv" -Delimiter ";"

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
$mbdb = (Get-MailboxDatabase).Name

foreach ($user in $users) {
    Enable-Mailbox `
        -Identity $user.SamAccountName `
        -Alias $user.SamAccountName `
        -Database "$mbdb"
}
