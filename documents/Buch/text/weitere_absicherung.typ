#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("David Koch")
= Weitere Absicherung des Netzwerks <weitere-absicherung>

Bei der Absicherung eines Netzwerks kann man sich nicht auf ein Gerät beziehungsweise auf eine Art von Gerät, wie z.B. Firewalls, verlassen. Wenn nun beispielsweise ein Zero-Day-Exploit in FortiGate-Firewalls entdeckt wird, ist das Netzwerk so schwach wie vor der Absicherung durch Firewalls.

Eine Lösung wäre, Firewalls von unterschiedlichen Herstellern zu nutzen, um das Problem von Zero-Day-Exploits teilweise unterbinden zu können. Was aber auch wichtig für ein sicheres Netzwerk notwendig ist sind nicht nur Firewalls, sondern auch z.B. die Härtung von Endgeräten, inklusive Patch-Management.

#htl3r.author("Gabriel Vogler")
== Active Directory Härtung <ad_hardening>
Das #htl3r.long[ad] ist ein zentraler Bestandteil des Netzwerks. Es ist für die Verwatung von Benutzerkonten, Gruppenrichtlinien und Zugriffsberechtigungen zuständig. Ein Angriff auf das #htl3r.short[ad] kann schwerwiegende Folgen haben. Daher ist es wichtig, das #htl3r.long[ad] abzusichern. Dies wird durch die Segmentierung des Netzwerks und die Härtung der #htl3r.short[ad]-Geräte erreicht. Gehärtet werden einerseits die #htl3r.short[ad]-Server selbst und andererseits die Benutzerkonten (inklusive die Authentifizierung mit diesen).

=== Credential Guard
Credential Guard ist eine Funktion von Windows Systemen die es ermöglicht, die Anmeldeinformationen von Benutzern zu schützen. Diese werden in einem abgekapseleten Bereich gepeichert. Dieser Bereich ist eine Art virtuelle Maschine, die neben dem eigentlichen Betriebssystem läuft. #htl3r.long[vbs] ist eine Voraussetzung für Credential Guard und ermöglicht die Isolation von Prozessen. Durch Credential Guard wird es Angreifern erschwert, an die Anmeldeinformationen von Benutzern zu gelangen. Dies kann Pass-the-Hash-Angriffe verhindern. Credential Guard wird mittels Gruppenrichtlinie aktiviert. Die Registry-Einträge für Credential Guard selbst -- Secure Boot und #htl3r.long[vbs] -- werden in der Gruppenrichtlinie gesetzt.

#htl3r.code-file(
  caption: "Aktivierung von Credential Guard mittels Gruppenrichtlinie",
  filename: [ansible/playbooks/stages/stage_03/DC1_part_3.ps1],
  skips: ((3, 0), (31, 0)),
  ranges: ((4, 30),),
  lang: "powershell",
  text: read("../assets/scripts/AD_Hardening.ps1")
)

Credential Guard kann aufgrund des fehlenden Secure Boot nicht in der Topologie aktiviert werden. Die Konfiguration und die Gruppenrichtlinie sind jedoch vorbereitet und können bei Bedarf aktiviert werden.

=== Protected Users <protected-users>
Protected Users ist ein Benutzergruppe, die es ermöglicht, die Anmeldeinformationen von Benutzern zu schützen. Benutzer, die Mitglied der Gruppe Protected Users sind, können keine Legacy Protokolle verwenden. Dazu zählt z.B. NTLM. Da NTLM ein veraltetes Protokoll ist, das anfällig für Angriffe ist, ist es wichtig, dieses zu deaktivieren. Aufpassen muss man jedoch, wenn Benutzer weiterhin NTLM-basierte Anwendungen verwenden müssen. Ein Problem könnte bei #htl3r.short[rdp] auftreten, da dort NTLM verwendet wird. Vorallem die Administratoren sollten in der Gruppe Protected Users sein, da mit diesen im Falle eines Angriffs am meisten Schaden angerichtet werden kann. Alle Benutzer die nicht der Abteilung Operations oder Infrastructure angehören, sollten in der Gruppe Protected Users sein, da diese kein #htl3r.short[rdp] benötigen.

#htl3r.code-file(
  caption: "Hinzufügen von Benutzern zur Gruppe Protected Users",
  filename: [ansible/playbooks/stages/stage_03/DC1_part_3.ps1],
  skips: ((32, 0),(44,0)),
  ranges: ((33, 43),),
  lang: "powershell",
  text: read("../assets/scripts/AD_Hardening.ps1")
)

=== LAPS
Dass die Admin-Passwörter beim in @provisionierung beschriebenen Provisionierungsvorgang auf allen Geräten gleich gesetzt werden ist klarerweise ein Sicherheitsrisiko. Wenn ein Angreifer eines der Passwörter herausfindet, kann er sich auf allen anderen Geräten ebenfalls mit diesem Passwort anmelden -- Es kommt zu Lateral Movement.

Local Administrator Password Solution, kurz LAPS, ist ein Tool von Microsoft, welches es ermöglicht, zentral über das #htl3r.short[ad] die lokalen Administrator-Passwörter von Windows-Computern zu verwalten. Zufällige Passwörter werden generiert und in einem #htl3r.long[ad]-Objekt gespeichert. Die Computer rufen die Passwörter ab und speichern sie lokal. Dadurch wird einerseits sichergestellt, dass alle lokalen Administrator-Passwörter auf den Computern unterschiedlich sind und andererseits, dass sie regelmäßig geändert werden. Dies erhöht die Sicherheit, da ein Angreifer, der ein Passwort herausfindet, nicht auf alle Computer zugreifen kann.

LAPS wurde in der Topologie auf den Servern im #htl3r.short[it]-Netzwerk installiert und konfiguriert. Auf den Clients wurde LAPS nicht aktiviert. Dies resultiert daraus, dass auf den Windows Server 2022 Systemen LAPS nachinstalliert wird, was mittlerweile die Legacy Version ist. Die Clients sind Windows 11 Systeme, welche allerdings LAPS mitgeliefert bekommen, genauso wie Windows Server 2025. Dabei handelt es sich jedoch um die aktuelle Version von LAPS. Die beiden Versionen sind nicht kompatibel zueinander, weshalb LAPS auf den Clients nicht installiert wurde.

Installiert wurde LAPS auf den Domain Controllern mittels des PowerShell-Skripts:
#htl3r.code-file(
  caption: "Installation von LAPS mittels PowerShell",
  filename: [ansible/playbooks/stages/stage_03/DC1_part_3.ps1],
  skips: ((45, 0), (48, 0)),
  ranges: ((46, 47),),
  lang: "powershell",
  text: read("../assets/scripts/AD_Hardening.ps1")
)

Damit die Server wissen, dass sie über LAPS gesteuert werden, musste eine Gruppenrichtlinie erstellt werden. Diese legt die Parameter von LAPS fest. Dabei werden die Häufigkeit der Änderung des Passworts, die Passwortlänge und die Komplexität des Passworts angegeben. Die #htl3r.short[gpo] wurde mit folgendem PowerShell-Skript erstellt:
#htl3r.code-file(
  caption: "Erstellung der Gruppenrichtlinie für LAPS mittels PowerShell",
  filename: [ansible/playbooks/stages/stage_03/DC1_part_3.ps1],
  skips: ((47, 0), (69, 0)),
  ranges: ((48, 68),),
  lang: "powershell",
  text: read("../assets/scripts/AD_Hardening.ps1")
)

Auf den Servern wurde LAPS auch installiert, jedoch ist es nicht notwendig, die Managementtools wie beim Domain Controller zu installieren. Dies pasiert mit folgendem PowerShell-Befehl:
#htl3r.code(caption: "Installation von LAPS auf den Servern", description: none)[
```powershell
D:\LAPS\x64\LAPS.x64.msi /quiet
```
]

Nach dem LAPS installiert und konfiguriert wurde, können die neuen Passwörter abgerufen werden. Dies geschieht mit folgendem PowerShell-Befehl:
#htl3r.code(caption: "Abrufen von LAPS-Passwort", description: none)[
```powershell
Get-AdmPwdPassword -ComputerName "Exchange"
```
]
#htl3r.fspace(
  figure(
    image("../assets/LAPS_Get_Password.png"),
    caption: [Abrufen des LAPS-Passworts für den Exchange Server],
  )
)

Mit diesem Passwort kann man sich nun auf dem Exchange Server als "Administrator" anmelden.


=== Windows Security Baseline
Die Windows Security Baseline ist eine Sammlung von Microsoft bereitgestelllten Gruppenrichtlinien zur Absicherung von Windows Systemen. In der Topologie wurde die Windows Security Baseline für Windows Server 2022 verwendet. \
Diese umfasst folgende #htl3r.shortpl[gpo]:
- MSFT Internet Explorer 11 - Computer
- MSFT Internet Explorer 11 - User
- MSFT Windows Server 2022 - Defender Antivirus
- MSFT Windows Server 2022 - Domain Controller
- MSFT Windows Server 2022 - Domain Controller Virtualization Based Security
- MSFT Windows Server 2022 - Domain Security
- MSFT Windows Server 2022 - Member Server
- MSFT Windows Server 2022 - Member Server Credential Guard

Die beiden #htl3r.shortpl[gpo] "MSFT Windows Server 2022 - Domain Controller Virtualization Based Security" und "MSFT Windows Server 2022 - Member Server Credential Guard" wurden in der Topologie nicht aktiviert, da die Voraussetzungen, wie in @protected-users beschrieben, nicht erfüllt sind.

Die "MSFT Internet Explorer 11 - Computer" wurde auf alle Computer angewendet, die "MSFT Internet Explorer 11 - User" auf alle Benutzer. Beide #htl3r.shortpl[gpo] legen Sicherheitseinstellungen für den Internet Explorer fest, wie zum Beispiel das Erzwingen einer bestimmten Version von #htl3r.short[tls].

#htl3r.shortpl[gpo], die "Domain" im Namen haben, wurden auf die Domain-Controller angewendet. Diese legen Sicherheitseinstellungen für die Domain fest, wie zum Beispiel der Aktivierung von AES-Verschlüsselung für Kerberos.

Die #htl3r.shortpl[gpo] für die Member-Server wurden auf die Server angewendet, die keine Domain-Controller sind. Diese legen Sicherheitseinstellungen, wie zum Beispiel das Deaktivieren eines #htl3r.short[rdp]-Zugriffs für die Standard Administratoren fest.

Die #htl3r.short[gpo] "MSFT Windows Server 2022 - Defender Antivirus" wurde allen Servern zugewiesen. Dieser legt Einstellungen für den Windows Defender fest, wie zum Beispiel das Aktivieren von Echtzeitschutz.

Importiert wurden die #htl3r.shortpl[gpo] mittels der PowerShell:
#htl3r.code-file(
  caption: "Importieren der Windows Security Baseline mittels PowerShell",
  filename: [ansible/playbooks/stages/stage_03/DC1_part_3.ps1],
  skips: ((68, 0),),
  ranges: ((69, 73),),
  lang: "powershell",
  text: read("../assets/scripts/AD_Hardening.ps1")
)

Dabei wird zuerst das ZIP-Archiv heruntergeladen und entpackt. Anschließend werden die #htl3r.shortpl[gpo] mithilfe des Skripts `Baseline-ADImport.psq1` importiert.

#htl3r.author("David Koch")
== Patch-Management <patch>

Eine der wichtigsten Methoden zur Absicherung einzelner Geräte ist das Patch-Management. Die Einspielung neuer Updates bzw. Firmware die vom Hersteller dazu konzipiert worden sind, um die Sicherheit des Gerätes gezielt zu erhöhen, ist von großer Wichtigkeit.

Zwar lassen sich durch Updates sogenannte "Zero-Day-Exploits" -- Schwachstellen, die dem Hersteller des Geräts noch nicht bekannt sind -- nicht verhindern, trotzdem bieten Sicherheitsupdates ausreichenden Schutz gegen die große Mehrheit an Cyberangriffen, da die Ausbeutung von veralteter Gerätschaft mit Abstand am einfachsten ist.

Leider wird bei vielen Betrieben das Patch-Management stark vernachlässigt, da die Philosophie "Never touch a running system" (Deutsch: "Verändere nie ein laufendes System") bei vielen Systemadministrator*innen noch tief verankert ist. Wenn keine Updates notwendig sind, um die Geräte weiterhin ohne Veränderung zu betreiben, werden diese nicht eingespielt.

Das Risiko eines Update-bezogenen Fehlers ist zwar realistisch, lässt sich jedoch durch gut geplantes Patch-Management minimieren. Backups von bestehenden Geräten oder Update-Testläufe in virtuellen Testumgebungen erlauben Systemadministrator*innen das ausprobieren von (Sicherheits-)Updates, ohne dabei ein laufendes System zu gefährden.

In der Projekttopologie erhalten #htl3r.short[it]-Endgeräte, auf denen als Betriebssystem Windows läuft, automatisch regelmäßige Sicherheitsupdates von Microsoft. Die Firewalls erlauben den Microsoft-spezifischen Datenverkehr ins Internet. Auf betriebskritische Geräte wie #htl3r.shortpl[sps] müssen Updates vorsichtiger als bei #htl3r.short[it]-Endgeräten eingespielt werden. Hierbei muss die #htl3r.short[sps] gestoppt und vom restlichen #htl3r.short[ot]-Netzwerk abgetrennt werden, bevor eine neue Firmware installiert werden kann. Dieser Prozess ist zwar sehr aufwendig, vermeidet aber letztendlich Angriffe wie "#htl3r.short[dos] einer #htl3r.short[sps]", die in @dos-sps beschrieben sind.

=== Firmware-Update einer S7-1200

Um den in @dos-sps beschriebenen #htl3r.short[dos]-Angriff gegenüber der S7-1200 #htl3r.short[sps] zu vermeiden, muss die neuste Firmware auf das Gerät eingespielt werden. Der #htl3r.short[cve]-2019-10936 beschreibt, dass alle Firmware-Versionen unter v4.4.0 von der Schwachstelle betroffen sind. Wenn nun auf eine neuere -- beziehungsweise die neuste -- Firmware-Version geupdatet wird, ist die #htl3r.short[sps] vor diesem Angriff geschützt.

Die neuste Firmware-Version für das in dieser Diplomarbeit verwendete Modell der S7-1200 ist v4.6.0. Mit einem Siemens-Support-Konto lässt sich diese aus dem Internet herunterladen und mittels dem "Gerät Tauschen"-Feature auf die #htl3r.short[sps] einspielen.

#htl3r.fspace(
  figure(
    image("../assets/simatic_firmware_update.png"),
    caption: [Die Aktualisierung der Firmware-Version auf der S7-1200],
  )
)

Das Update muss aufgrund der benötigten Neustarts zu einer Zeit durchgeführt werden, wo die #htl3r.short[sps] nicht aktiv in der Betriebsumgebung gebraucht wird. Bei vielen Betrieben sind diese Geräte aber 24/7 im Einsatz, somit muss entweder ein kurzes Zeitfenster für diese wichtigen Updates eingeplant werden oder alternativ die Absicherung vom Netzwerk bis hin zur betroffenen #htl3r.short[sps] so stattfinden, dass die Netzwerk-Schwachstelle überhaupt nicht ausgenutzt werden kann.

== Passwörter für SPS-Zugriff konfigurieren

Der administrative Zugriff auf die Siemens #htl3r.shortpl[sps] ist standardmäßig nicht passwortgeschützt. Da dies unglaublich unsicher ist, werden im Rahmen dieser Diplomarbeit auf allen #htl3r.shortpl[sps] Passwörter hinterlegt. 

Das Passwort für den Vollzugriff auf die S7-1200 lässt sich in den Einstellungen der #htl3r.short[sps]-CPU unter #htl3r.breadcrumbs(("Allgemein", "Schutz & Security", "Zugriffsstufe")) konfigurieren. Es lässt sich ebenfalls die Zugriffsstuffe konfigurieren, hierbei wird "Kein Zugriff (kompletter Schutz)" ausgewählt, um maximale Sicherheit zu gewährleisten.

#htl3r.fspace(
  figure(
    image("../assets/simatic_password.png"),
    caption: [Das PLC-Zugriffsschutz-Menü der S7-1200],
  )
)

In den Einstellungen der LOGO!-#htl3r.short[sps] lässt sich unter #htl3r.breadcrumbs(("Online Settings", "Access control settings", "LSC & LWE access")) das Passwort für den Zugriff auf die #htl3r.short[sps] über LSC und LWE konfigurieren, wobei LSC für "LOGO! Soft Comfort" und LWE für "LOGO! Web Editor" steht. Das heißt, dass auf der L2-Netzwerkschnittstelle, welche von der Entwicklungsumgebung genutzt wird, als auch auf der optionalen Weboberfläche nun ein Passwort mitgeschickt werden muss, um Konfigurationen vorzunehmen.

#htl3r.fspace(
  total-width: 90%,
  figure(
    image("../assets/ot-work/logo_password.png"),
    caption: [Konfiguration des Passworts auf der LOGO!-SPS],
  )
)

Was anzumerken ist: Das Passwort auf der LOGO!-#htl3r.short[sps] ist auf eine maximale Anzahl von 10 Zeichen begrenzt. Man muss kein Cybersicherheitsexperte sein, um zu erkennen, dass solch eine Limitation die von einem Passwort gebrachte Sicherheit stark einschränkt. Mittels eines Brute-Force-Angriffs lässt sich ein 10 Zeichen langes Passwort in kürzester Zeit knacken.

#htl3r.fspace(
  total-width: 90%,
  figure(
    image("../assets/ot-work/logo_access_secured.png"),
    caption: [Der Access Security Status der LOGO!-SPS],
  )
)

== Mikrosegmentierung der Betriebszellen <mikrosegmentierung>

Wenn durch die in beschriebene Netzwerksegmentierung mittels Firewalls im #htl3r.short[ot]-Bereich die einzelnen Betriebszellen trotz gemeinsamer Purdue-Ebene in mehrere Subnetze aufteilt spricht man von Mikrosegmentierung.

Die #htl3r.shortpl[sps] der Modell-Kläranlage können somit zwischen Betriebszellen nicht direkt miteinander kommunizieren und müssen über das #htl3r.short[scada] gehen, wenn Inter-Zellen-Kommunikation notwendig ist.

Die Zellen-Firewall ist "stateful", das heißt, dass keine Policies für Rückantworten erstellt werden müssen. Es wird somit per Policy nur Kommunikation vom #htl3r.short[scada]-System zu den einzelnen #htl3r.shortpl[sps] erlaubt, die Rückantworten werden automatisch erlaubt und der restliche Verkehr wird blockiert. In diesem restlichen Verkehr ist die Kommunikation zwischen #htl3r.shortpl[sps] inkludiert, somit ist eine erfolgreiche Mikrosegmentierung der Betriebszellen umgesetzt worden.

#htl3r.code(caption: "Die Policy für die Kommunikation vom SCADA zur SPS der zweiten Betriebszelle", description: none)[
```fortios
config firewall policy
  edit 1
    set name "Root_to_OpenPLC"
    set srcintf "Cell2Vlnk1"
    set dstintf "internal2"
    set srcaddr "SCADA"
    set dstaddr "OpenPLC"
    set anti-replay enable
    set action accept
    set schedule "always"
    set service "PING" "MODBUS_TCP"
    set ips-sensor "OT-Security-IPS"
    set application-list "OT-DPI"
    set logtraffic all
    set status enable
  next
end
```
]

#htl3r.author("Julian Burger")
== Jump-Server für IT/OT Kommunikation

Um einen abgesicherten und nur eingeschränkten Zugriff auf die #htl3r.short[ot]-Infrastruktur zu ermöglichen, muss jegliche Kommunikation über einen sogenannten Jump-Server verlaufen. Die Firewall-Richtlinien dafür wurden bereits in @separation_firewall beschrieben. In diesem Kapitel wird primär auf die OpenVPN und #htl3r.full[rdp] Verbindungen eingegangen.

=== OpenVPN auf dem Jump-Server

Wie schon erwähnt wurde der Jump-Server, welcher als Übergang von der #htl3r.short[it] in die #htl3r.short[ot] dient, mit einem OpenVPN-Server realisiert. Es wurde OpenVPN über WireGuard, IPSec oder Ähnliches bevorzugt, da OpenVPN mehrere Client-Verbindungen mit derselben Konfiguration ermöglicht. So kann der Zugriff auf die Client-Konfiguration mittels #htl3r.short[ad]-Richtlinien abgesichert werden und es muss nicht für eine eigene Konfiguration pro Benutzer gesorgt werden. Die Vertraulichkeit ist somit ebenfalls leichter gewährt, da die Zertifikate ebenfalls über #htl3r.long[ad] verwaltet werden können. Für genauere Informationen über die Konfiguration des #htl3r.short[ad]s, siehe @active_directory.

OpenVPN arbeitet anhand von Zertifikaten, diese wurden mit einem Tool namens "easy-rsa", welches ebenfalls von der OpenVPN-Organisation entwickelt wird, erstellt. easy-rsa erlaubt es dem Benutzer mithilfe von simplen Befehlen eine Art #htl3r.short[pki] zu erstellen, um anhand einer Root-#htl3r.short[ca] Zertifikate für den Server, als auch für den Client auszustellen. Diese Root-#htl3r.short[ca] kann im Anschluss innerhalb des #htl3r.short[ad]s eingebunden werden, um diese automatisch auf die #htl3r.short[it]-Clients auszurollen. Im Rahmen dieser Diplomarbeit werden die Zertifikate allerdings nur über einen File-Share zur Verfügung gestellt.

Die Konfiguration des OpenVPN-Servers selbst wird mittels automatischer Provisionierung, wie in @provisionierung beschrieben, eingespielt. Die Konfiguration beinhaltet die #htl3r.short[pki], Zertifikate und die Serverkonfigurationsdatei, welche die Tunnel-Konfiguration beinhaltet.

#htl3r.code-file(caption: [OpenVPN-Server Konfiguration], filename: [/etc/openvpn/server.conf], text: read("../assets/openvpn/server.conf"))

Diese OpenVPN-Server-Konfiguration ist bis auf folgende zwei Ausnahmen sehr einfach gehalten:
- `duplicate-cn`: Gibt an, dass sich mehrere Clients mit dem gleichen Zertifikat, zur selben Zeit, verbinden können.
- `push "route 10.34.0.0 255.255.0.0"`: Übermittelt den verbundenen Clients, dass das Netzwerk 10.34.0.0/16 über den VPN-Tunnel erreichbar ist.

OpenVPN leitet standardmäßig die Client-Tunnel-Adressen stumpf weiter. Somit müssten alle erreichbaren Geräte einen Routing-Eintrag für die Tunnel-Adressen besitzen. Um dies zu vermeiden, werden zusätzlich mittels #htl3r.short[nat] die Adressen innerhalb des Tunnels auf die Adresse des Interfaces, welches von dem Jump-Server aus in die #htl3r.short[ot]-#htl3r.short[dmz] führt, übersetzt. In diesem Falle wird die #htl3r.short[nat]-Konfiguration mit Linux #htl3r.short[ip]-Tables realisiert, siehe @ovpn_iptables.

#htl3r.code(caption: [OpenVPN-Server Tunnel NAT])[
```bash
iptables -t nat -A POSTROUTING -o ens224 -j MASQUERADE
iptables -A FORWARD -i tun0 -o ens224 -j ACCEPT
iptables -A FORWARD -i ens224 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
```
] <ovpn_iptables>

=== OpenVPN auf den IT-Workstations

Damit die Windows-Clients, beziehungsweise #htl3r.short[it]-Workstations, eine OpenVPN-Verbindung aufbauen können, benötigen diese die OpenVPN-Client-Software zu installieren. Die Installation dieser Software erfolgt, wie in @provisionierung beschrieben, bereits innerhalb des Golden-Images, welches mit Packer erzeugt wird. Dies geschieht über ein PowerShell-Skript, welches, wegen passender Konfiguration innerhalb einer `autounattend.xml`-Datei, vom Windows-Installations-Prozess aufgerufen wird.

#htl3r.code(caption: [OpenVPN-Client installation auf IT-Workstations])[
```ps1
(New-Object System.Net.WebClient).DownloadFile('https://swupdate.openvpn.org/community/releases/OpenVPN-2.6.13-I002-amd64.msi', 'C:\Windows\Temp\openvpn.msi')
C:\Windows\Temp\openvpn.msi /quiet /passive
Start-Sleep -Seconds 120
```
]

Die Software sollte jedoch nur für bestimmte #htl3r.short[ad]-Benutzer verfügbar sein, somit muss dieser Zugriff eingeschränkt werden. Für weitere Informationen über diese Einschränkung siehe @active_directory.

Damit sich ein Client mit dem Server verbinden kann, ist ein Zertifikat notwendig, welches zuvor von der #htl3r.short[pki], welche in diesem Fall ebenfalls am Jump-Host liegt, ausgestellt wurde. Zusätzlich wird das Zertifikat, jedoch nicht der private Schlüssel, der #htl3r.short[pki] benötigt.

#htl3r.code-file(caption: [OpenVPN-Client Konfiguration], filename: [client.ovpn], text: read("../assets/openvpn/client.conf")) <ovpn-client>

In @ovpn-client ist die finale Konfiguration der #htl3r.short[it]-Workstations enthalten. Man beachte, dass ein `tun`-Device, kurz für Tunnel, verwendet wird. Ein Tunnel ermöglicht #htl3r.short[osi]-Ebene 3 Verbindungen. Mittels `tap`-Device wären sogar #htl3r.short[osi]-Ebene 2 Verbindungen über OpenVPN möglich, dies wird allerdings im Rahmen dieser Diplomarbeit nicht benötigt.

#htl3r.fspace(
  [
  #figure(
    image("../assets/openvpn_client_verbindung.png", width: 100%),
    caption: [IT-Workstation OpenVPN-Client Verbindung]
  ) <openvpn-client-conn>
  ]
)

Wie in @openvpn-client-conn erkennbar ist, ist es möglich, mit der #htl3r.short[it]-Workstation auf den OpenVPN-Server zuzugreifen. Über den OpenVPN-Server kann anschließend eine #htl3r.short[rdp]-Session auf eine #htl3r.short[ot]-Workstation geöffnet werden. Dieser Zugriff ist dank des Jump-Servers Purdue-Modell konform.

#htl3r.author("David Koch")
== NIS-2

Beim Betreiben von Industriebetrieben oder kritischer Infrastruktur ist es wichtig, die gesetzlich vorgelegten Spezifikationen einzuhalten. Diese gibt es auch für den digitalen Bereich, wobei die bekannteste und derzeit relevanteste Spezifikation bzw. Richtlinie die #htl3r.short[nis]-2 wäre.

"Die #htl3r.short[nis]-2-Richtlinie soll die Resilienz und die Reaktion auf Sicherheitsvorfälle des öffentlichen und des privaten Sektors in der EU verbessern. Der bisherige Anwendungsbereich der #htl3r.short[nis]-Richtlinie nach Sektoren wird mit #htl3r.short[nis]-2 auf einen größeren Teil der Wirtschaft und des öffentlichen Sektors ausgeweitet, um eine umfassende Abdeckung jener Sektoren und Dienste zu gewährleisten, die im Binnenmarkt für grundlegende gesellschaftliche und wirtschaftliche Tätigkeiten von entscheidender Bedeutung sind. Betroffene Einrichtungen müssen daher geeignete Risikomanagementmaßnahmen für dise Sicherheit ihrer Netz- und Informationssysteme treffen und unterliegen Meldepflichten." @nis-2-wko

Die #htl3r.short[nis]-2-Richtlinie unterscheidet zwischen wesentlichen und wichtigen Einreichtungen, für die teilweise unterschiedliche Vorschriften gelten @nis-2-massnahmen. Eine Kläranlage fällt laut Anhang I der Richtlinie in den siebten Sektor "Abwasser": "Unternehmen, die kommunales Abwasser, häusliches Abwasser oder industrielles Abwasser im Sinne des Artikels 2 Nummern 1, 2 und 3 der Richtlinie 91/271/EWG des Rates (23) sammeln, entsorgen oder behandeln, jedoch unter Ausschluss der Unternehmen, für die das Sammeln, die Entsorgung oder die Behandlung solchen Abwassers ein nicht wesentlicher Teil ihrer allgemeinen Tätigkeit ist" @nis2-richtlinie

#pagebreak(weak: true)
Unter anderem sind folgende Maßnahmen für eine wesentliche Einrichtung vorgesehen:

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (2fr, 3fr),
      inset: 10pt,
      align: (horizon + left, horizon + left),
      table.header(
        [*Maßnahme*], [*Im Rahmen der Diplomarbeit umgesetzt*],
      ),
      [Erstellung einer Risikoanalyse- \ und Informationssicherheitskonzepten], [Durch die Umsetzung eigener Angriffe ist eine partielle Risikoanalyse erstellt worden (siehe @angriffe-netzwerk).],
      [Maßnahmen zur Bewältigung \ von Sicherheitsvorfällen (Incident Response)], [Es wurde kein Incident Reponse Plan erstellt.],
      [Backup-Management und Wiederherstellung], [Es wurde kein Backup-Management umgesetzt. Es kann jedoch eine schnelle Wiederherstellung des virtualisierten Netzwerks mittels Provisionierung durchgeführt werden (siehe @provisionierung).],
      [Konzepte für Zugriffskontrollen], [Wurde durch den Einsatz des AGDLP-Prinzips in der AD-Umgebung umgesetzt (siehe @benutzerkonten).],
      [Software-Updates], [Es wurde manuelles Patch-Management durchgeführt (siehe @patch).],
      [Gerätekonfiguration], [AD-Geräte, Netzwerkgeräte sowie die SPSen wurden gehärtet.],
      [Netzwerksegmentierung], [Durch den Einsatz von FortiGate-Firewalls umgesetzt (siehe @firewall-config).],
      [Schulungen für Mitarbeiter/innen], [Da keine echten Mitarbeiter/innen vorhanden sind, wurden keine Schulungen organisiert.],
      [Zero-Trust-Prinzip], [Wurde nicht umgesetzt.]
    ),
    caption: [NIS-2-Maßnahmen für wesentliche Einrichtungen und deren Umsetzungsgrad in der Diplomarbeitstopologie],
  )
)