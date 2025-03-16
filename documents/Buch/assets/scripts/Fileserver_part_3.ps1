$csvPath = "D:\users.csv"
$basePath = "C:\Fenrir-Share"
$shareName = "Fenrir-Share"

$users = Import-Csv -Path $csvPath -Delimiter ";"

if (!(Test-Path $basePath)) {
    New-Item -ItemType Directory -Path $basePath -Force
}

$departments = $users | Select-Object -ExpandProperty Department -Unique
foreach ($dept in $departments) {
    $deptPath = "$basePath\$dept"
    if (!(Test-Path $deptPath)) {
        New-Item -ItemType Directory -Path $deptPath -Force
    }
    
    $acl = Get-Acl $deptPath
    $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("DL_$($dept)_M", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule("DL_$($dept)_R", "ReadandExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule1)
    $acl.SetAccessRule($rule2)
    Set-Acl -Path $deptPath -AclObject $acl
}

foreach ($user in $users) {
    $userPath = "$($basePath)\$($user.Department)\$($user.SamAccountName)"
    if (!(Test-Path $userPath)) {
        New-Item -ItemType Directory -Path $userPath -Force
    }

    $acl = Get-Acl $userPath
    $acl.SetAccessRuleProtection($true, $false)
    foreach ($accessRule in $acl.Access) {
        $acl.RemoveAccessRule($accessRule)
    }

    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$($user.SamAccountName)", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl -Path $userPath -AclObject $acl
}

New-SmbShare -Name $shareName -Path $basePath -FullAccess "Everyone"
Write-Host "File share and folder permissions configured successfully."
