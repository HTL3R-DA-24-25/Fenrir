$users = Import-CSV -Path "D:\users.csv" -Delimiter ";"
$Password = ConvertTo-SecureString "ganzgeheim123!" -AsPlainText -Force

foreach ($user in $users) {
    New-ADUser `
        -Name "$($user.GivenName) $($user.Surname)" `
        -GivenName $user.GivenName `
        -Surname $user.Surname `
        -SamAccountName $user.SamAccountName `
        -UserPrincipalName "$($user.SamAccountName)@corp.fenrir-ot.at" `
        -AccountPassword $Password `
        -Enabled $true `
        -ChangePasswordAtLogon $true `
        -PasswordNeverExpires $true `
        -Department $user.Department
    $groupName = "G_" + $user.Department
    Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName
}
