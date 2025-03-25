$csvPath = "D:\groups_fenrir_ad.csv"
$groups = Import-Csv -Path $csvPath -Delimiter ";"

$dlGroups = $groups | Where-Object { $_.scope -like "DomainLocal" }
foreach ($group in $dlGroups) {
    Write-Host "Erstelle Domain Local Gruppe: $($group.name)"

    if (-not (Get-ADGroup -Filter "Name -eq '$($group.name)'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $group.name `
            -Path $group.path `
            -GroupScope $group.scope `
            -GroupCategory $group.category
        Write-Host "Gruppe $($group.name) wurde erstellt." -ForegroundColor Green
    }
    else {
        Write-Host "Gruppe $($group.name) existiert bereits." -ForegroundColor Yellow
    }
}

$gGroups = $groups | Where-Object { $_.scope -like "Global" }
foreach ($group in $gGroups) {
    Write-Host "Erstelle Global Gruppe: $($group.name)"

    if (-not (Get-ADGroup -Filter "Name -eq '$($group.name)'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $group.name `
            -Path $group.path `
            -GroupScope $group.scope `
            -GroupCategory $group.category
        Write-Host "Gruppe $($group.name) wurde erstellt." -ForegroundColor Green
    }
    else {
        Write-Host "Gruppe $($group.name) existiert bereits." -ForegroundColor Yellow
    }

    if (-not [string]::IsNullOrEmpty($group.DL_Groups)) {
        $dlGroupsList = $group.DL_Groups -split ", "
        foreach ($dlGroup in $dlGroupsList) {
            Write-Host "Fuege $($group.name) zur Gruppe $dlGroup hinzu"

            if (Get-ADGroup -Filter "Name -eq '$dlGroup'" -ErrorAction SilentlyContinue) {
                if (-not (Get-ADGroupMember -Identity $dlGroup | Where-Object { $_.name -eq $group.name })) {
                    Add-ADGroupMember -Identity $dlGroup -Members $group.name
                    Write-Host "Gruppe $($group.name) wurde zu $dlGroup hinzugefuegt." -ForegroundColor Green
                }
                else {
                    Write-Host "Gruppe $($group.name) ist bereits Mitglied von $dlGroup." -ForegroundColor Yellow
                }
            }
            else {
                Write-Host "Die DL-Gruppe $dlGroup existiert nicht und kann nicht verknuepft werden." -ForegroundColor Red
            }
        }
    }
}
Write-Host "Die Gruppenerstellung und -verknuepfung wurde abgeschlossen." -ForegroundColor Green
