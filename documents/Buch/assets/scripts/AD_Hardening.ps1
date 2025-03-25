# Hardening
Import-Module GroupPolicy
## Credential Guard
$GPOName = "Enable Credential Guard"

New-GPO -Name $GPOName | Out-Null

$CredGuard = Get-GPO -Name $GPOName

$RegistryPath1 = "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard"
$RegistryKey1 = "EnableVirtualizationBasedSecurity"
$RegistryValue1 = 1

$RegistryPath2 = "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard"
$RegistryKey2 = "RequirePlatformSecurityFeatures "
$RegistryValue2 = 1

$RegistryPath3 = "HKLM\SYSTEM\CurrentControlSet\Control\Lsa"
$RegistryKey3 = "LsaCfgFlags"
$RegistryValue3 = 2



Set-GPRegistryValue -Name $GPOName -Key $RegistryPath1 -ValueName $RegistryKey1 -Type DWord -Value $RegistryValue1
Set-GPRegistryValue -Name $GPOName -Key $RegistryPath2 -ValueName $RegistryKey2 -Type DWord -Value $RegistryValue2
Set-GPRegistryValue -Name $GPOName -Key $RegistryPath3 -ValueName $RegistryKey3 -Type DWord -Value $RegistryValue3

$DCOU = "OU=Domain Controllers,DC=corp,DC=fenrir-ot,DC=at"

New-GPLink -Name $GPOName -Target $DCOU -LinkEnabled Yes -Enforced Yes

## Protected Users
$users = @("dkoch", "jbloggs", "jdoe", "jwinkler", "mhuber", "mmuster", "Administrator")

foreach ($user in $users) {
    try {
        Add-ADGroupMember -Identity "Protected Users" -Members $user -ErrorAction Stop
        Write-Host "Benutzer $user wurde erfolgreich hinzugefügt." -ForegroundColor Green
    }
    catch {
        Write-Host "Fehler beim Hinzufügen von $user $_" -ForegroundColor Red
    }
}

## LAPS
D:\LAPS.x64.msi /quiet /norestart
D:\LAPS.x64.msi ADDLOCAL=Management.UI,Management.PS,Management.ADMX /quiet /norestart
Import-Module -Name AdmPwd.PS
Update-AdmPwdADSchema

New-ADOrganizationalUnit -Name "LAPS-Server" -Path "DC=corp,DC=fenrir-ot,DC=at"
$TargetOU = "OU=LAPS-Server,DC=corp,DC=fenrir-ot,DC=at"
Get-ADComputer -Filter 'Name -like "*Exchange*"' | Move-ADObject -TargetPath $TargetOU
Get-ADComputer -Filter 'Name -like "*File*"' | Move-ADObject -TargetPath $TargetOU

Set-AdmPwdComputerSelfPermission -OrgUnit $TargetOU


$GPOName = "LAPS Password Policy"
New-GPO -Name $GPOName


Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft Services\AdmPwd" -ValueName "AdmPwdEnabled" -Type DWord -Value 1
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft Services\AdmPwd" -ValueName "PasswordComplexity" -Type DWord -Value 4
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft Services\AdmPwd" -ValueName "PasswordAgeDays" -Type DWord -Value 30
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft Services\AdmPwd" -ValueName "PasswordLength" -Type DWord -Value 14

New-GPLink -Name $GPOName -Target $TargetOU -LinkEnabled Yes -Enforced Yes

# Windows Security Baseline
Invoke-WebRequest "https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/Windows%20Server%202022%20Security%20Baseline.zip" -OutFile Windows_Server_2022_Security_Baseline.zip
tar -xf Windows_Server_2022_Security_Baseline.zip
Set-Location '.\Windows Server-2022-Security-Baseline-FINAL\Scripts\'
.\Baseline-ADImport.ps1
