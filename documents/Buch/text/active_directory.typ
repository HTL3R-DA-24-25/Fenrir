#import "@preview/htl3r-da:1.0.0" as htl3r
#import "@preview/treet:0.1.1": *


#let llist(..items) = box(align(left, list(..items.pos().map(item => list.item([#item])))))

#htl3r.author("Gabriel Vogler")
= Active Directory <active_directory>

#htl3r.long[adds] ist ein Verzeichnisdienst von Microsoft und dient der zentralen Verwaltung und Organisation von Benutzern, Benutzergruppen, Berechtigungen und Computern in einem Unternehmensnetzwerk. Diese zentrale Verwaltung erlaubt die Authentifizierung und Zugriffssteuerung dieser Benutzer und Computer, wobei auch ausserhalb von AD-integrierten Windows-Geräten diese Authentifizierung eingesetzt werden kann. Dieser wird auf einem Windows Server installiert und findet in dem meisten Unternehmen Anwendung.

== Domain und Forest
Im Szenario des Firmennetzwerkes der Firma "Fenrir", wird im #htl3r.long[ad] auf eine Domain und einen Forest gesetzt, da es sich um ein kleines Unternehmen handelt und nur ein Standort vorhanden ist. Dadurch sind die Konfiguration und die Verwaltung des #htl3r.short[ids] einfacher und übersichtlicher. Dennoch bietet die #htl3r.short[ad]-Struktur genug Flexibilität und Erweiterungsmöglichkeiten, wie es in der realen Welt auch der Fall sein sollte, falls das Unternehmen wächst.

== Logischer Aufbau
Der logische Aufbau des #htl3r.short[ad]s der Firma "Fenrir" wird mit Hilfe von #htl3r.short[ou], Benutzerkonten und Benutzergruppen strukturiert. Die Benutzerkonten und Benutzergruppen werden in den #htl3r.short[ou]s organisiert, um eine bessere Übersicht und Struktur zu gewährleisten:

=== OU-Struktur

#htl3r.fspace(
  total-width: 100%,
  figure(
    align(center, box(align(left, text[
      DC=corp,DC=fenrir-ot,DC=at\
      #tree-list[
        - OU=Accounts
          - OU=Sales
            - G_Sales
          - OU=Marketing
            - G_Marketing
          - OU=Operations
            - G_Operations
          - OU=Infrastructure
            - G_Infrastructure
          - OU=Management
            - G_Management
      ]
    ]))),
    caption: [Die OU-Struktur der corp.fenrir-ot.at Domäne]
  )
)

Um die oben dargestellte OU-Struktur in der AD-Umgebung umzusetzen, muss auf einem Domain Controller folgendes PowerShell-Skript ausgeführt werden:

#htl3r.code(caption: "OU-Erstellung in PowerShell", description: none)[
```powershell
$ous = @(
    "OU=Accounts,DC=corp,DC=fenrir-ot,DC=at",
    "OU=Sales,OU=Accounts,DC=corp,DC=fenrir-ot,DC=at",
    "OU=Marketing,OU=Accounts,DC=corp,DC=fenrir-ot,DC=at",
    "OU=Operations,OU=Accounts,DC=corp,DC=fenrir-ot,DC=at",
    "OU=Infrastructure,OU=Accounts,DC=corp,DC=fenrir-ot,DC=at",
    "OU=Management,OU=Accounts,DC=corp,DC=fenrir-ot,DC=at"
)

foreach ($ou in $ous) {
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ou'" -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou.Split(",")[0].Split("=")[1] -Path $ou.Substring($ou.IndexOf(",") + 1)
        Write-Host "OU wurde erfolgreich erstellt: $ou"
    }
    else {
        Write-Host "OU existiert bereits: $ou"
    }
}
```
]

=== Benutzerkonten <benutzerkonten>
#show table.cell.where(y: 0): set text(size: 8pt)
#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (8em, auto, auto, auto,),
      align: (left, left, left, left),
      table.header[Benutzername][Vorname][Nachname][Abteilung],
      [buhlig], [Bastian], [Uhlig], [Infrastructure],
      [dkoch], [David], [Koch], [Management],
      [gvogler], [Gabriel], [Vogler], [Operations],
      [jbloggs], [Joe], [Bloggs], [Marketing],
      [jburger], [Julian], [Burger], [Infrastructure],
      [jdoe], [John], [Doe], [Sales],
      [jwinkler], [Johannes], [Winkler], [Sales],
      [mhuber], [Michael], [Huber], [Management],
      [mmeier], [Max], [Meier], [Operations],
      [mmuster], [Maria], [Mustermann], [Marketing],
    ),
    caption: [Visualisierung der Benutzer in der Domäne]
  )
)

Um die Benutzerkonten zu erstellen, gibt es eine CSV-Datei mit den Benutzerdaten, die von einem PowerShell-Skript verarbeitet wird. Die Tabelle oben, zeigt wie die CSV Datei aussieht. Statt den Überschriften oben wird in der CSV Datei SamAccountName, GivenName, Surname und Department verwendet. Die Benutzerkonten werden mit folgendem PowerShell-Skript erstellt:
```powershell
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
```

Damit die Benutzer auch in die richtige Gruppe eingefügt werden, wird in der letzten Zeile des Skripts der Benutzer in die Global-Group eingefügt, die der Abteilung entspricht. Im Skript wurde ein Standardpasswort für alle Benutzer verwendet, welches beim ersten Anmelden geändert werden muss.


=== Benutzergruppen <benutzergruppen>
#show table.cell.where(y: 0): set text(size: 8pt)
#show table.cell.where(x: 0): set text(size: 8pt)
#let J = table.cell(
  fill: green.lighten(60%),
)[X]
#let N = table.cell(
  fill: red.lighten(60%),
)[]
#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (8em, auto, auto, auto, auto, auto),
      align: (left, center, center, center, center, center, center),
      table.header[Name][G_Infrastructure][G_Operations][G_Sales][G_Management][G_Marketing],
      [DL_Infrastructure_R],  J, J, N, J, N,
      [DL_Infrastructure_M],  J, N, N, N, N,
      [DL_Operations_R],      J, J, N, N, N,
      [DL_Operations_M],      N, J, N, N, N,
      [DL_Sales_R],           N, N, J, J, J,
      [DL_Sales_M],           N, N, J, N, N,
      [DL_Management_R],      N, N, N, J, N,
      [DL_Management_M],      N, N, N, J, N,
      [DL_Marketing_R],       N, N, J, J, J,
      [DL_Marketing_M],       N, N, N, N, J
    ),
    caption: [Visualisierung der Mitgliedschaft von Global Groups in Domain Local Groups],
  )
)

Die Benutzergruppen werden in der AD-Umgebung der Firma "Fenrir" in Domain Local Groups und Global Groups unterteilt. Die Global Groups entsprechen den Abteilungen der Firma und die Domain Local Groups den Rollen, die die Benutzer auf den Network Shares auf dem Fileserver haben.

Die Benutzergruppen sind einer CSV Datei erstellt, die folgendes Format hat:
#htl3r.code-file(
  caption: "CSV für die Gruppenerstellung",
  filename: [ansible/playbooks/stages/stage_03/extra/groups_fenrir_ad.csv],
  skips: ((4, 0),(9, 0)),
  ranges: ((0, 3), (7, 8)),
  lang: "csv",
  text: read("../assets/scripts/groups_fenrir_ad.csv")
)

Es werden die Gruppenname, der Pfad, der Scope, die Kategorie und die Domain Local Groups, in die die Global Groups eingefügt werden, angegeben. Anhand der CSV Datei können die Gruppen mit folgendem PowerShell-Skript erstellt werden:
#htl3r.code-file(
  caption: "Powershell-Skript für die Gruppenerstellung",
  filename: [ansible/playbooks/stages/stage_03/extra/DC1_part_3.ps1],
  skips: ((1, 0), (56, 0)),
  lang: "powershell",
  text: read("../assets/scripts/Gruppen_erstellen.ps1")
)
Es werden zuerst die Domain Local Groups und dann die Global Groups erstellt. Anschließend werden die Global Groups in die Domain Local Groups eingefügt, die in der CSV Datei angegeben sind.

#htl3r.author("Bastian Uhlig")
== GPOs
#htl3r.fullpl[gpo] sind Richtlinien, die in einer #htl3r.long[ad]-Domäne definiert werden und die Konfiguration von Benutzern und Computern in einem Netzwerk steuern. Mit #htl3r.short[gpo] können Administratoren Einstellungen für Benutzer und Computer festlegen, wie z.B. Sicherheitseinstellungen, Softwareinstallationen, Netzwerkeinstellungen und vieles mehr. In der Firma "Fenrir" werden #htl3r.shortpl[gpo] verwendet, um die Konfiguration der Benutzer und Computer in der #htl3r.long[ad]-Domäne zu steuern. \ 
Effektiv setzen #htl3r.shortpl[gpo] Registy-Einträge, weshalb man in den Skriptausschnitten auch die Pfade dieser zu sehen bekommt.

=== GPOs in der Firma "Fenrir"
In der Firma "Fenrir" sind einige relativ grundlegende #htl3r.shortpl[gpo] definiert, die die Konfiguration der Benutzer und Computer in der #htl3r.long[ad]-Domäne steuern. Alle #htl3r.shortpl[gpo] werden wie auch der Rest vom #htl3r.long[ad] mittels PowerShell-Skripten erstellt:

- *Minimum Password Length:* Diese #htl3r.shortpl[gpo] legt die Mindestlänge des Passworts für Benutzer in der #htl3r.long[ad]-Domäne fest. In der Firma "Fenrir" wurde die Mindestlänge auf 8 Zeichen festgelegt.
#htl3r.code(caption: "OU für minimale Passwortlänge", description: none)[
```powershell
$minPasswordLengthGpoName = "Minimum Password Length Policy"
New-GPO -Name $minPasswordLengthGpoName | Out-Null
Set-GPRegistryValue -Name $minPasswordLengthGpoName -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Network" -ValueName "MinPwdLen" -Type DWORD -Value 8
```
]
- *Desktop Wallpaper:* Diese #htl3r.shortpl[gpo] legt das Hintergrundbild für die Desktops der Benutzer in der #htl3r.long[ad]-Domäne fest. In der Firma "Fenrir" wurde das Hintergrundbild auf das Firmenlogo festgelegt.
#htl3r.code(caption: "OU für den Desktop Hintergrund", description: none)[
```powershell
$desktopWallpaperGpoName = "Desktop Wallpaper Policy"
$wallpaperPath = "\\nfs\wallpapers\wallpaper.jpg"
New-GPO -Name $desktopWallpaperGpoName | Out-Null
Set-GPRegistryValue -Name $desktopWallpaperGpoName -Key "HKCU\Control Panel\Desktop" -ValueName "WallPaper" -Type String -Value $wallpaperPath
Set-GPRegistryValue -Name $desktopWallpaperGpoName -Key "HKCU\Control Panel\Desktop" -ValueName "TileWallpaper" -Type String -Value "0"
Set-GPRegistryValue -Name $desktopWallpaperGpoName -Key "HKCU\Control Panel\Desktop" -ValueName "WallpaperStyle" -Type String -Value "10"
Set-GPRegistryValue -Name $desktopWallpaperGpoName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "NoChangingWallPaper" -Type DWord -Value 1
```
]
- *Default Browser Homepage:* Diese #htl3r.shortpl[gpo] legt die Startseite von Internet Explorer auf die Firmenwebsite fest.
#htl3r.code(caption: "OU für die Standard-Startseite des Browsers", description: none)[
```powershell
$defaultBrowserHomepageGpoName = "Default Browser Homepage Policy"
$homepageUrl = "https://www.fenrir-ot.at" 
New-GPO -Name $defaultBrowserHomepageGpoName | Out-Null
Set-GPRegistryValue -Name $defaultBrowserHomepageGpoName -Key "HKCU\Software\Microsoft\Internet Explorer\Main" -ValueName "Start Page" -Type String -Value $homepageUrl
Set-GPRegistryValue -Name $defaultBrowserHomepageGpoName -Key "HKCU\Software\Microsoft\Internet Explorer\Main" -ValueName "Default_Page_URL" -Type String -Value $homepageUrl
```
]
- *Hiding Last User:* Diese #htl3r.shortpl[gpo] versteckt den letzten angemeldeten Benutzer auf dem Anmeldebildschirm, sodass jeder User bei neuen Anmeldungen seinen Benutzernamen eingeben muss.
#htl3r.code(caption: "OU für das Verstecken des letzten Benutzers", description: none)[
```powershell
$hidingLastUserGpoName = "Hiding Last User Policy"
New-GPO -Name $hidingLastUserGpoName | Out-Null
Set-GPRegistryValue -Name $hidingLastUserGpoName -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "dontdisplaylastusername" -Type DWORD -Value 1
$gpo = Get-GPO -Name $hidingLastUserGpoName
$gpo | Set-GPPermission -PermissionLevel GpoApply -TargetName "Domain Computers" -TargetType Group 
```
]	
- *Login Screen:* Diese #htl3r.shortpl[gpo] legt das Firmenlogo auf dem Anmeldebildschirm fest, also der Bildschirm, den man auf bei Passwort und Benutzernameneingabe sieht.
#htl3r.code(caption: "OU für das Firmenlogo auf dem Anmeldebildschirm", description: none)[
```powershell
$loginScreenGpoName = "Login Screen Policy"
$loginScreenPath = "\\nfs\wallpapers\loginscreen.jpg"
New-GPO -Name $loginScreenGpoName | Out-Null
Set-GPRegistryValue -Name $loginScreenGpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" -ValueName "LockScreenImage" -Type String -Value "$loginScreenPath"
$gpo = Get-GPO -Name $loginScreenGpoName
$gpo | Set-GPPermission -PermissionLevel GpoApply -TargetName "Domain Computers" -TargetType Group 
```
]
- *Drive Mount:* Diese #htl3r.shortpl[gpo] legt fest, dass bei der Anmeldung der Benutzer automatisch das Firmeninterne Netzlaufwerk gemountet bekommt.
#htl3r.code(caption: "OU für das Mounten des Firmenlaufwerks", description: none)[
```powershell
$driveMountGpoName = "Drive Mount Policy"
$sharePath = "\\nfs\share"
New-GPO -Name $driveMountGpoName | Out-Null
$keyPath = "HKCU\Network\F:"
Set-GPRegistryValue -Name $driveMountGpoName -Key $keyPath -ValueName "ConnectFlags" -Type DWord -Value 0
Set-GPRegistryValue -Name $driveMountGpoName -Key $keyPath -ValueName "ConnectionType" -Type DWord -Value 1
Set-GPRegistryValue -Name $driveMountGpoName -Key $keyPath -ValueName "DeferFlags" -Type DWord -Value 1
Set-GPRegistryValue -Name $driveMountGpoName -Key $keyPath -ValueName "ProviderName" -Type String -Value "Microsoft Windows Network"
Set-GPRegistryValue -Name $driveMountGpoName -Key $keyPath -ValueName "RemotePath" -Type String -Value "$sharePath"
Set-GPRegistryValue -Name $driveMountGpoName -Key $keyPath -ValueName "UserName" -Type String -Value ""
```
]
- *Firewall:* Diese #htl3r.shortpl[gpo] erzwingt die Aktivierung von allen 3 Windows-Firewalls (Domain, Private, Public).
#htl3r.code(caption: "OU für die Aktivierung der Windows-Firewall", description: none)[
```powershell
$firewallGpoName = "Firewall Policy"
New-GPO -Name $firewallGpoName | Out-Null
Set-GPRegistryValue -Name $firewallGpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -ValueName "EnableFirewall" -Type DWord -Value 1
Set-GPRegistryValue -Name $firewallGpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -ValueName "EnableFirewall" -Type DWord -Value 1
Set-GPRegistryValue -Name $firewallGpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -ValueName "EnableFirewall" -Type DWord -Value 1
$gpo = Get-GPO -Name $firewallGpoName
$gpo | Set-GPPermission -PermissionLevel GpoApply -TargetName "Domain Computers" -TargetType Group 
```
]

#htl3r.author("David Koch")
== Domain Controller

Es gibt insgesamt zwei Domain Controller in der #htl3r.short[it]-Infrastruktur der Firma "Fenrir".
Die Domain Controller teilen sich die Aufgaben:

#show table.cell.where(y: 0): strong
#show table.cell.where(x: 0): strong

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (5em, auto, auto),
      align: (left + horizon, center, center),
      table.header[][DC1][DC2],
      [Rollen], align(left + horizon, llist("Domain Naming Master", "Root/Primary Domain Controller")), llist("Infrastructure Master", "RID Pool Manager", "Schema Master"),
      [DHCP], "Ja", "Failover",
      [DNS], "Ja", "Ja",
      [Remoting], table.cell(colspan: 2, llist("PowerShell Remoting", "SSH Server", "RDP", "Remote Management"))
    ),
    caption: [Aufteilung der Features zwischen den Domain Controllern],
  )
)

=== Aufsetzung der Domain Controller

Durch den in @provisionierung beschriebenen Provisionierungsvorgang lassen sich die Domain Controller automatisiert aufsetzen. Zu den für die DC-Provisionierung notwendigen Dateien und Skripts zählen, unter anderem, das Ansible-Playbook, die PowerShell-Skripts für die Hochstufung und Konfigurations der DCs und jegliche Extra-Dateien wie eine CSV-Tabelle mit den AD-Gruppen, die von den PowerShell-Skripts verarbeitet wird.

#htl3r.code-file(
  caption: "Ansible-Playbook für die Aufsetzung von DC1",
  filename: [ansible/playbooks/stages/stage_03/setup_dc_primary.yml],
  lang: "yml",
  text: read("../assets/scripts/setup_dc_primary.yml")
)

Der Aufsetzungsprozess wird im Playbook durch die sogenannten "Tasks" gesteuert. Eine Task ist jeweils eine zu erledigende Aufgabe, bevor die nächsten Tasks abgearbeitet werden können. Somit wird als erste Task das "part_1"-PowerShell-Skript ausgeführt, welches für die Grundkonfiguration des Geräts zuständig ist. Hierbei wird der Hostname, das Admin-Passwort und der Netzwerkadapter konfiguriert und es wird das für die DC-Hochstufung notwendige Package ```AD-Domain-Services``` installiert.

#htl3r.code-file(
  caption: "Part-1-Skript für die Aufsetzung von DC1",
  filename: [ansible/playbooks/stages/stage_03/extra/DC1_part_1.ps1],
  skips: ((26, 0),),
  ranges: ((0, 25), (63, 63)),
  lang: "powershell",
  text: read("../assets/scripts/DC1_part_1.ps1")
)

Nach der fertigen Ausführung vom Part-1-Skript ist ein Neustart des Domain Controllers notwendig. Dieser wird auch durch die im Ansible Playbook eingetragenen Tasks durchgeführt.

Es folgen nach der Grundkonfiguration noch zwei weitere Parts, wobei im zweiten die Hochstufung und im dritten -- unter anderem -- die Konfiguration der OU-Struktur, Benutzer, Gruppen und #htl3r.shortpl[gpo] stattfindet.

#htl3r.code-file(
  caption: "Part-2-Skript für die Aufsetzung von DC1",
  filename: [ansible/playbooks/stages/stage_03/extra/DC1_part_2.ps1],
  lang: "powershell",
  text: read("../assets/scripts/DC1_part_2.ps1")
)

#htl3r.author("Gabriel Vogler")
== Exchange Server
Der Exchange Server ist ein E-Mail Server der Firma Microsoft.
Dieser Server wird weltweit in einigen Firmen eingesetzt und bietet die Grundlage für jegliche Inter- und Intraunternehmenskommunikation.

Damit der Exchange Server funktioniert, wird eine bestehenende #htl3r.short[ad] Struktur benötigt.



=== Aufsetzung des Exchange Servers
Wie auch schon bei den Domain Controllern, wird der Exchange Server durch ein Ansible-Playbook aufgesetzt. Dieses Playbook besteht aus mehreren Parts, die jeweils für eine spezifische Aufgabe zuständig sind. Die Aufteilung ist notwendig, da der Exchange Server während der Installation mehrmals neu gestartet werden muss. Außerdem wird eine Exchange-Server ISO benötigt, die später verwendet wird un den Exchange Server zu installieren. Diese ist unter folgendem Link zu finden: \
#link("https://www.microsoft.com/en-us/download/details.aspx?id=104131").
#htl3r.code-file(
  caption: "Ansible-Playbook für die Aufsetzung von Exchange",
  filename: [ansible/playbooks/stages/stage_04/setup_exchange.yml],
  lang: "yml",
  text: read("../assets/scripts/setup_exchange.yml")
)

Im ersten Part des Playbooks wird das PowerShell-Skript `Exchange_part_1.ps1` ausgeführt. Dieses Skript ist für die Grundkonfiguration des Exchange Servers zuständig. Hierbei wird der Hostname, das Admin-Passwort und der Netzwerkadapter konfiguriert und es werden zahlreiche Windows Features installiert, die für den Exchange Server notwendig sind.

#htl3r.code-file(
  caption: "Part-1-Skript für die Aufsetzung von Exchange",
  filename: [ansible/playbooks/stages/stage_04/extra/Exchange_part_1.ps1],
  skips: ((26, 0),),
  ranges: ((0, 25), (63, 63)),
  lang: "powershell",
  text: read("../assets/scripts/Exchange_part_1.ps1")
)

Im zweiten Part des Playbooks wird das PowerShell-Skript `Exchange_part_2.ps1` ausgeführt. Dieses Skript ist für den Beitritt des Exchange Servers in die #htl3r.short[ad] Domain zuständig.
#htl3r.code-file(
  caption: "Part-2-Skript für die Aufsetzung von Exchange",
  filename: [ansible/playbooks/stages/stage_04/extra/Exchange_part_2.ps1],
  lang: "powershell",
  text: read("../assets/scripts/Exchange_part_2.ps1")
)

Im dritten Part des Playbooks wird das PowerShell-Skript `Exchange_part_3.ps1` ausgeführt. Es wird damit begonnen, ein Verzeichnis zu erstellen, in dem die Installationsdateien für den Exchange Server benötigte Software abgelegt werden. Im Anschluss wird die `vcredist_x64.exe` heruntergeladen und installiert. Diese enthält die Visual C++ Redistributable Packages, die für den Exchange Server benötigt werden. Danach wird das mit der ISO-Datei mitgelieferte UCMARedist (Unified Communications Managed API) installiert. Dieses ist in diesem Fall nicht unbedingt notwendig, da es dabei um die Einbindung von Skype for Business und anderen Voricemaildiensten geht, jedoch kann es nicht schaden es zu installieren, falls es in der Zukunft benötigt wird. Als letzes Paket wird das "IIS URL rewrite Module" heruntergeladen und im Anschluss installiert. IIS ist der Webserver von Microsoft und wird für den Exchange Server benötigt und das URL rewrite Module ist ein Modul, das die URL-Umschreibung für den IIS-Webserver ermöglicht, um die Webzugriffe auf den Exchange Server zu steuern.

Da alle notwendigen Pakete installiert sind, wird von der ISO-Datei die Datei `Setup.exe` ausgeführt, um den Exchange Server zu installieren.

#htl3r.code-file(
  caption: "Part-3-Skript für die Aufsetzung von Exchange",
  filename: [ansible/playbooks/stages/stage_04/extra/Exchange_part_3.ps1],
  lang: "powershell",
  text: read("../assets/scripts/Exchange_part_3.ps1")
)

Im vierten Part des Playbooks wird das PowerShell-Skript `Exchange_part_4.ps1` ausgeführt. In diesem Skript werden die Postfächer für alle Benutzer erstellt. Dafür wird eine CSV-Datei benötigt, die die Benutzerdaten enthält. Die CSV-Datei ist die gleiche, die auch für die Benutzererstellung in @benutzerkonten benutzt wurde..

#htl3r.code-file(
  caption: "Part-4-Skript für die Aufsetzung von Exchange",
  filename: [ansible/playbooks/stages/stage_04/extra/Exchange_part_4.ps1],
  lang: "powershell",
  text: read("../assets/scripts/Exchange_part_4.ps1")
)

=== Test des Exchange Servers
Nach der Installation kann der Exchange Server getestet werden. Dafür wird eine E-Mail vom Benuter gvogler an Benutzer dkoch gesendet. Um auf den Exchange Server zuzugreifen, wird in einem Webbrowser die URL `https://exchange.corp.fenrir-ot.at/owa` eingegeben. Dort wird sich mit dem Benutzernamen und dem Passwort angemeldet. Nach der Anmeldung kann eine E-Mail an den Benutzer dkoch gesendet werden:
#htl3r.fspace(
  figure(
    image("../assets/Test-Email_senden.png"),
    caption: [E-Mail senden auf dem Exchange Server]
  )
)
Nach dem Senden der E-Mail wird der Empfang der E-Mail überprüft. Dafür wird sich mit dem Benutzer dkoch auf dem Webinterface des Exchange Servers angemeldet und die E-Mail überprüft:
#htl3r.fspace(
  figure(
    image("../assets/Test-Email_empfangen.png"),
    caption: [E-Mail empfangen]
  )
)
Die E-Mail wurde erfolgreich empfangen und der Exchange Server funktioniert einwandfrei.

== Fileserver
Der Fileserver ist ein zentraler Ablageort für Dateien und Dokumente in einem Netzwerk. Er stellt Verzeichnisse zur Verfügung, auf die die Benutzer des Netzwerks zugreifen können. Der Fileserver ist ein wichtiger Bestandteil der IT-Infrastruktur eines Unternehmens, da er die Speicherung und Organisation von Dateien erleichtert und die Zusammenarbeit der Mitarbeiter fördert. In der IT-Infrastruktur der Firma "Fenrir" wird ein Fileserver eingesetzt, um zentrale Speicherbereiche für die Benutzer und Abteilungen bereitzustellen. Damit die Benutzer auf die Dateien zugreifen können, wird der Fileserver in die Active Directory-Domäne integriert und die Berechtigungen für die Benutzer und Gruppen verwaltet. Die Berechtigungen der Verzeichnisse der Abteilungen werden mithilfe der Domain Local Groups aus @benutzergruppen verwaltet.

=== Aufsetzung des File Servers
Mithilfe eines Ansible-Playbooks wird der Fileserver aufgesetzt. Dabei wird das Playbook in mehreren Parts aufgeteilt, da der Fileserver während der Installation mehrmals neu gestartet werden muss.

#htl3r.code-file(
  caption: "Ansible-Playbook für die Aufsetzung von Fileserver",
  filename: [ansible/playbooks/stages/stage_04/setup_fileserver.yml],
  lang: "yml",
  text: read("../assets/scripts/setup_fileserver.yml")
)

Im ersten Part des Playbooks wird das PowerShell-Skript `Fileserver_part_1.ps1` ausgeführt. Hier wird die Grundkonfiguration des Fileservers durchgeführt. Es wird der Hostname, das Admin-Passwort und der Netzwerkadapter konfiguriert und es wird das für den Fileserver notwendige Feature `FS-FileServer` installiert.
#htl3r.code-file(
  caption: "Part-1-Skript für die Aufsetzung von Fileserver",
  filename: [ansible/playbooks/stages/stage_04/extra/Fileserver_part_1.ps1],
  skips: ((26, 0),),
  ranges: ((0, 25), (63, 63)),
  lang: "powershell",
  text: read("../assets/scripts/Fileserver_part_1.ps1")
)

Im zweiten Part des Playbooks wird das PowerShell-Skript `Fileserver_part_2.ps1` ausgeführt. Hier wird der Fileserver in die Active Directory-Domäne integriert.
#htl3r.code-file(
  caption: "Part-2-Skript für die Aufsetzung von Fileserver",
  filename: [ansible/playbooks/stages/stage_04/extra/Fileserver_part_2.ps1],
  lang: "powershell",
  text: read("../assets/scripts/Fileserver_part_2.ps1")
)

Im dritten Part des Playbooks wird das PowerShell-Skript `Fileserver_part_3.ps1` ausgeführt. Notwendig für dieses Skript ist die CSV Datei mit den Benutzern des #htl3r.short[ad] aus @benutzerkonten. Im Skript wird zunächst das Verzeichnis  `C:\Fenrir-Share` erstellt, in dem die Freigaben für die Benutzer und Abteilungen angelegt werden. Im nächsten Schritt, werden die Verzeichnisse für die Abteilungen erstellt und im Anschluss die Berechtigungen für die Domain Local Groups gesetzt. Danach werden die Verzeichnisse der einzelnen Benutzer in den Abteilungsverzeichnissen erstellt und die Berechtigungen für die Benutzer gesetzt. Abschließend wird das Verzeichnis `C:\Fenrir-Share` unter dem Namen `Fenrir-Share` freigegeben.
#htl3r.code-file(
  caption: "Part-3-Skript für die Aufsetzung von Fileserver",
  filename: [ansible/playbooks/stages/stage_04/extra/Fileserver_part_3.ps1],
  lang: "powershell",
  text: read("../assets/scripts/Fileserver_part_3.ps1")
)

=== Test des File Servers
Um den Fileserver zu testen, erstellt ein Benutzer zwei Dateien, eine liegt in seinem eigenen Verzeichnis und eine in dem seiner Abteilung. Der Benutzer `jburger` erstellt die Datei `test.txt` in seinem Verzeichnis und die Datei `test2.txt` im Verzeichnis der Abteilung `Infrastructure`. Der Benutzer `dkoch` sollte die Berechtigungen haben `test2.txt` zu lesen, `test.txt` jedoch nicht.  Um auf den Fileserver zuzugreifen, wird in einem Webbrowser die URL `\\fileserver.corp.fenrir-ot.at\Fenrir-Share` eingegeben.

Erfolgreicher Zugriff auf `test2.txt` im  Verzeichnis der Abteilung `Infrastructure`:
#htl3r.fspace(
  figure(
    image("../assets/Test-Fileshare_Zugriff_erfolgreich.png", width: 80%),
    caption: [Fileserver Test: Zugriff auf `test2.txt` im Verzeichnis der Abteilung `Infrastructure`]
  )
)

Nicht erfolgreicher Zugriff auf `test.txt` im Verzeichnis des Benutzers `jburger`, da der Benutzer `dkoch` keine Berechtigung hat:
#htl3r.fspace(
  figure(
    image("../assets/Test-Fileshare_Zugriff_nicht_erfolgreich.png", width: 80%),
    caption: [Fileserver Test: Zugriff auf `test.txt` im Verzeichnis des Benutzers `jburger`]
  )
)
