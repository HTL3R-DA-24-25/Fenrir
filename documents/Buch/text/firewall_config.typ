#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("Julian Burger")
= Firewall-Konfiguration <firewall-config>

Als Firewalls wurden exclusiv FortiGates, Produkte der Firma Fortinet, verwendet. Diese sind mittels Kommandozeile, oder aber auch Web-Oberfläche, konfigurierbar. Die Konfiguration auf der Kommandozeile erfolgt über eine Fortinet eigene Konfigurationsspprache. Diese ist in diverse Sub-Konfigurations-Menüs unterteilt, welche es jeweils erlauben die, für das ausgewählte Sub-Konfigurations-Menü, eigenen Objekte zu erstellen, bearbeiten, oder zu entfernen.

Insgesammt existieren innerhalb der Kläranlagen-Infrastruktur drei physische FortiGate-Firewalls. Diese unterteilen jeweils die verschiedenen Ebenen nach dem Purdue-Modell.

#htl3r.fspace(
  total-width: 100%,
  [
    #figure(
      image("../assets/firewall_intro_purdue.png"),
      caption: [Übersicht der Firewall Purdue-Ebenen Aufteilung]
    ) <firewall_intro_purdue>
  ]
)

In @firewall_intro_purdue ist die Aufteilung von Ebene zu Firewall dargestellt. Für genauere Informationen über das Purdue-Modell der Kläranlagen-Infrastruktur siehe @purdue.

Dieser Abschnitt beschäftigt sich hauptsächlich mit der Konfiguration der Firewall-Policies, sowie diverse andere Dienste, welche auf den Firewalls konfiguriert wurden. Die Verbindung zwischen den Firewalls und den #htl3r.shortpl[vm], welche in einer vCenter-Umgebung laufen, wird in @physische-topo und @vcenter_env beschrieben.

#htl3r.author("Bastian Uhlig")
== Uplink-Firewall <uplink_fw>
Die Uplink-Firewall -- eine FortiGate 60E -- dient zum Schutz des gesamten Netzwerks vor unerwünschtem Datenverkehr aus dem Internet. Sie ist die erste Verteidigungslinie und schützt das Netzwerk vor Angriffen von außen. Die Firewall ist so konfiguriert, dass sie nur den nötigen Datenverkehr durchlässt und alle anderen Pakete verwirft.

=== Grundkonfiguration
Hier sind lediglich die grundlegenden Konfigurationen der Uplink-Firewall dargestellt. Die Konfigurationen der Policies und der Interfaces sind hierbei nicht enthalten.

#htl3r.code-file(
  caption: "Uplink-Firewall Grundkonfiguration",
  filename: [Uplink-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((35, 39),),
  text: read("../assets/scripts/Uplink-FW-Fenrir.conf")
)

=== Interfaces
Bei der Konfiguration der Interfaces von der Uplink-Firewall ist zu beachten, dass auch das gesamte Management-Netzwerk über diese Firewall läuft. Dieses ist zwar komplett vom restlichen Netzwerk getrennt, jedoch sind sie trotzdem anzulegen. \
Da die meisten Links in Richtung #htl3r.short[it] gehen, sind diese nur mit #htl3r.shortpl[vlan] getrennt. Alle #htl3r.shortpl[vlan] werden dann entweder auf einem Switch oder in vCenter terminiert und an die entsprechenden #htl3r.shortpl[vm] weitergeleitet. \
Das INET-Interface ist dabei nur dazu da, um während der automatischen Provisionierung (siehe @provisionierung) #htl3r.shortpl[vm] den Zugriff auf das Internet zu ermöglichen. Über das Management-Interface kann währenddessen auf Management-Ressourcen zugegriffen werden, wie zum Beispiel die ESXis oder der vCenter-Server.

#htl3r.fspace(
  [
    #figure(
      image("../assets/Uplink-FW-Interfaces.png"),
      caption: [Logische Darstellung der Interfaces der Uplink-Firewall]
    )
  ]
)

#htl3r.code-file(
  caption: "Uplink-Firewall Interface-Konfiguration",
  filename: [Uplink-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((58, 59),(62,63),(66, 68),(71,72),(74, 76),(79,80),(82, 84),(87,88),(90, 92),(95,96),(107,108)),
  text: read("../assets/scripts/Uplink-FW-Fenrir.conf")
)

=== DHCP Konfiguration <uplink_fw_dhcp>
Auf der Uplink-Firewall liegen mehrere #htl3r.short[dhcp]-Server für drei unterschiedliche Interfaces.
#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (1fr, 2fr, 1fr, 1fr),
      inset: 10pt,
      align: (horizon + left, horizon + left, horizon + left, horizon + left),
      table.header(
        [*Interface*], [*Adresspool*], [*Gateway*], [*#htl3r.short[dns]-Server*],
      ),
      [inet], [10.10.0.100 - 10.10.0.200], [10.10.0.254], [1.1.1.1],
      [mgmt], [10.40.20.210 - 10.40.20.230], [10.40.20.254], [10.40.20.254],
      [itnet], [10.32.0.10 - 	10.32.255.240], [10.32.255.254], [192.168.31.1, 192.168.31.2],
    ),
    caption: [Interfaces mit DHCP-Servern auf der Uplink-Firewall],
  )
)

=== LDAP Server

Zur Authentifizierung von Benutzern, welche den #htl3r.short[ras]-#htl3r.short[vpn] verwenden dürfen, wird mittels #htl3r.short[ldap] eine Verbindung zum #htl3r.short[ad] hergestellt. Dazu muss ein Account angegeben werden, welcher Leserechte hat, um die Benutzer zu überprüfen.

#htl3r.code-file(
  caption: "Uplink-Firewall LDAP-Konfiguration",
  filename: [Uplink-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((198, 207),),
  text: read("../assets/scripts/Uplink-FW-Fenrir.conf")
)

=== Remote Access VPN

Der Remote Access #htl3r.short[vpn] ermöglicht es Benutzern, sich von außerhalb des Netzwerks sicher mit dem Netzwerk zu verbinden. Dazu wird ein #htl3r.short[ipsec]-#htl3r.short[vpn] eingerichtet, welcher die Authentifizierung über den #htl3r.short[ldap]-Server durchführt. Benutzer bekommen Zugriff auf das #htl3r.short[it]-Netzwerk und können sich von dort aus weiter verbinden, falls dies notwendig ist.

=== Policies

Policies sind eine der wichtigsten Funktionen einer Firewall -- und damit auch der FortiGate. Mit ihnen wird der Datenverkehr reguliert und gesteuert. Standardmäßig lässt eine FortiGate-Firewall keinen Datenverkehr durch, es muss also alles explizit erlaubt werden.

Im Falle der Uplink-Firewall sind die Policies so konfiguriert, dass nur der nötige Datenverkehr durchgelassen wird. Das heißt, dass von außen nur Datenverkehr auf den Exchange-Server zugelassen wird, und auch da nur auf die Ports, die benötigt werden.

// avoids buggy behavior
#pagebreak(weak: true)
In die #htl3r.short[it]-SEC-Zone wird nur Datenverkehr zugelassen, der auch notwendig ist. Dies bedeutet alle für #htl3r.short[adds] notwendigen Ports und Protokolle, sowie Web-Access auf die Nozomi Guardian.

Richtung Downlink wird nur der #htl3r.short[vpn]-Traffic in Richtung Jumphost erlaubt.

#htl3r.author("Julian Burger")
== Übergangs-Firewall Konfiguration <separation_firewall>

Die Übergangs-Firewall -- eine FortiGate92D -- separiert #htl3r.short[it]- und #htl3r.short[ot]-Geräte, indem sie den Zugriff nur indirekt erlaubt. Auf die #htl3r.short[ot]-Geräte selbst haben nur die #htl3r.short[ot]-Workstations und das #htl3r.short[scada] Zugriff. Die #htl3r.short[ot]-Workstations sind von den #htl3r.short[it]-Workstations über #htl3r.short[rdp] erreichbar, doch selbst diese Verbindung ist nur möglich, wenn die #htl3r.short[it]-Workstations mit einem OpenVPN-Server über OpenVPN verbunden sind. Dieser Zugriff wird jedoch vom #htl3r.short[ad] eingeschränkt, siehe @active_directory. Die Übergangs-Firewall selbst ist so konfiguriert, dass nur eine bestimmte Art von Traffic-Flow erlaubt ist.

#htl3r.fspace(
  total-width: 80%,
  figure(
    image("../assets/separation_firewall_traffic_flow.png"),
    caption: [Der von der Übergangs-Firewall erlaubte Traffic-Flow]
  )
)

Farblich markiert erkennt man gut die einzelnen Policies, welche gemeinsam den minimalen Traffic erlauben, welcher notwendig ist um auf die #htl3r.short[ot] zuzugreifen. Es existieren noch zusätzliche Einschränkungen, welche nur OpenVPN-Zugriffe auf die Jump-Server erlauben und nur #htl3r.short[rdp] auf die #htl3r.short[ot]-Workstations. Das #htl3r.short[scada] und die #htl3r.short[ot]-Workstations haben uneingeschränkten Zugriff auf die #htl3r.shortpl[sps], welche an die Zellen-Firewall angeschlossen sind. Die Begründung dafür ist, dass die diversen Programme, welche für die Programmierung der #htl3r.shortpl[sps] verwendet werden, proprietäre Protokolle sowie Protokolle auf der 2ten Schicht des #htl3r.short[osi]-Modells -- wie z.B. Profinet DCP -- verwenden, welche schwer bis gar nicht mittels FortiGate regulierbar sind.

=== Grundkonfiguration

Die Grundkonfiguration der Übergangs-Firewall bzw. Seperation-Firewall beinhaltet das Einrichten des Management-#htl3r.short[vlan]s, sowie die Konfiguration von statischen #htl3r.short[ip]-Adressen und #htl3r.short[vlan]-Subinterfaces für die Kläranlagen-Topologie. Andere Aspekte wie Hostname und Zeitzone werden ebenfalls gesetzt.

#htl3r.code-file(
  caption: "Übergangs-Firewall Grundkonfiguration",
  filename: [Seperation-FW-Fenrir.conf],
  lang: "fortios",
  skips: ((35, 0), (50, 0), (76, 0)),
  ranges: ((35, 49), (58, 75), (85, 85)),
  text: read("../assets/firewall/Seperation-FW-Fenrir.conf")
)

Da die Grundkonfiguration mehrere Seiten in Anspruch nehmen würde, wurde die Konfiguration von ein paar Interfaces nicht inkludiert.

=== OT-Net DHCP-Konfiguration

Innerhalb des #htl3r.short[ot]-Net Netzwerkes werden #htl3r.short[ip]-Adressen an #htl3r.short[ot]-Workstations mittels #htl3r.short[dhcp] verteilt. Der #htl3r.short[dhcp]-Server ist dabei mithilfe der Übergangs-Firewall realisiert. Das Interface, auf dem der #htl3r.short[dhcp]-Server läuft, ist das #htl3r.short[vlan]-Subinterface des #htl3r.short[ot]-Net Netzwerkes.

#htl3r.code-file(
  caption: "Übergangs-Firewall OT-NET DHCP-Konfiguration",
  filename: [Seperation-FW-Fenrir.conf],
  lang: "fortios",
  skips: ((210, 0),),
  ranges: ((210, 225),),
  text: read("../assets/firewall/Seperation-FW-Fenrir.conf")
)

=== Jump-Server Policy

Wie bereits beschrieben, darf die Jump-Server nur mit OpenVPN von den #htl3r.short[it]-Workstations erreichbar sein. Der einzige Traffic, welcher ansonsten erlaubt ist, sind die #htl3r.short[rdp]-Verbindungen zu den #htl3r.short[ot]-Workstations. Für die OpenVPN-Verbindungen gibt es zwei Adress-Objekte `Jump-Server` und `IT_Workstations`.

#htl3r.code-file(
  caption: "Übergangs-Firewall Jump-Server Policy Adress-Objekte",
  filename: [Seperation-FW-Fenrir.conf],
  lang: "fortios",
  skips: ((87, 0), (114, 0), (126, 0)),
  ranges: ((87, 87), (114, 125), ),
  text: read("../assets/firewall/Seperation-FW-Fenrir.conf")
)

Der #htl3r.short[ip]-Adress-Bereich, welcher in `IT_Workstations` angegeben ist, wird von der Uplink-Firewall hergeleitet, siehe @uplink_fw_dhcp. Diese Adress-Objekte werden dann in der Policy verwendet, um den Zugriff einzuschränken.

#htl3r.code-file(
  caption: "Übergangs-Firewall Jump-Server Policy",
  filename: [Seperation-FW-Fenrir.conf],
  lang: "fortios",
  skips: ((158, 0), (183, 0), (196, 0)),
  ranges: ((158, 158), (183, 195)),
  text: read("../assets/firewall/Seperation-FW-Fenrir.conf")
)

Man beachte, dass für OpenVPN ein eigener Service auf der FortiGate angelegt wurde. Dies ist notwendig, da es standardmäßig keinen Service und damit Port-Mapping hierfür gibt. Für die Policy jedoch ist es essenziell, dass sie weiß, welche Art von Traffic sie durchlassen darf. Des Weiteren ist ein statischer Routeneintrag notwendig, damit die Firewall den Traffic vom #htl3r.short[it]-Netzwerk weiterleiten kann.

=== OT-Workstation Policy

Die Konfiguration für den #htl3r.short[rdp]-Zugriff auf die #htl3r.short[ot]-Workstations von der Jump-Server aus gleicht der zuvor angeführten Konfiguration. Es wird jedoch ein neues Adress-Objekt für die #htl3r.short[ot]-Workstations angelegt.

#htl3r.code-file(
  caption: "Übergangs-Firewall RDP Policy Adress-Objekte",
  filename: [Seperation-FW-Fenrir.conf],
  lang: "fortios",
  skips: ((87, 0), (108, 0), (125, 0), (126, 0)),
  ranges: ((87, 87), (108, 113), (125, 125)),
  text: read("../assets/firewall/Seperation-FW-Fenrir.conf")
)

Dieses `OT_Workstation` Adress-Objekt wird dann in der Policy verwendet.

#htl3r.code-file(
  caption: "Übergangs-Firewall RDP Policy",
  filename: [Seperation-FW-Fenrir.conf],
  lang: "fortios",
  skips: ((158, 0), (171, 0), (195, 0), (196, 0)),
  ranges: ((158, 158), (171, 182), (195, 195)),
  text: read("../assets/firewall/Seperation-FW-Fenrir.conf")
)

=== SPS Policy

Die #htl3r.short[ot]-Workstations und das #htl3r.short[scada] benötigen ebenso Zugriff auf die drei #htl3r.shortpl[sps] hierzu existiert pro #htl3r.short[sps] ein Adress-Objekt. Diese drei Adress-Objekte werden dann in eine gemeinsame Adress-Gruppe hinzugefügt. Dies erleichtert das Definieren der Policy und das Setzen der statischen Route.

#htl3r.code-file(
  caption: "Übergangs-Firewall SPS Policy Adress-Objekte",
  filename: [Seperation-FW-Fenrir.conf],
  lang: "fortios",
  skips: ((87, 0), (125, 0), (147, 0), (157, 0)),
  ranges: ((87, 103), (125, 125), (147, 156)),
  text: read("../assets/firewall/Seperation-FW-Fenrir.conf")
)

Um diese definierten #htl3r.short[ip]-Adressen zu erreichen, wird eine statische Route definiert, welche den Traffic über die Zellen-Firewall weiterleitet. Dazu wird die Adress-Gruppe `PLC_Group` verwendet. Die andere definierte Adress-Gruppe `PLC_Accessor` definiert alle Geräte, welche auf die #htl3r.shortpl[sps] zugreifen dürfen.

#htl3r.code-file(
  caption: "Übergangs-Firewall SPS-Routen",
  filename: [Seperation-FW-Fenrir.conf],
  lang: "fortios",
  skips: ((197, 0), (203, 0), (209, 0)),
  ranges: ((197, 197), (203, 208)),
  text: read("../assets/firewall/Seperation-FW-Fenrir.conf")
)

Final ist die Policy für den Zugriff auf die #htl3r.shortpl[sps] definiert. Diese weicht leicht von den anderen Policies ab. Allerdings wird als Service alles erlaubt. Dies ist, obwohl nicht komplett sicher, die beste Möglichkeit, die Funktion der diversen #htl3r.short[sps]-Programmierprogramme zu garantieren, siehe @separation_firewall.

#htl3r.code-file(
  caption: "Übergangs-Firewall SPS-Policy",
  filename: [Seperation-FW-Fenrir.conf],
  lang: "fortios",
  skips: ((158, 0), (195, 0), (196, 0)),
  ranges: ((158, 170), (195, 195)),
  text: read("../assets/firewall/Seperation-FW-Fenrir.conf")
)

So wird mit insgesamt drei simplen Policies der in diesem Abschnitt definierte Traffic-Flow über die Übergangs-Firewall realisiert. Die Adress-Gruppen sind jederzeit erweiterbar und die Konfiguration ist leicht zu verifizieren.

#htl3r.author("David Koch")
== Zellen-Firewall

Die Zellen-Firewall -- eine FortiGateRugged60F -- dient dem Schutz des empfindlichsten Teil des gesamten Netzwerks: der #htl3r.short[ot]. Konzepte wie die physischen Segmentierung von untereinander unabhängiger Aktorik/Sensorik in Betriebszellen ist nutzlos, wenn sich diese aufgrund von einer fehlenden Netzwerksegmentierung trotzdem ohne weitere Umwege gegenseitig ansprechen können. Aus diesem Grund wird die Zellen-Firewall gebraucht. Sie bietet noch dazu Features wie #htl3r.short[dpi] und mitgelieferte Signaturen für bekannte #htl3r.short[ot]-Daten, um die empfangenen Daten so gut es geht zu identifizieren und im Falle eines Sicherheitsvorfalls die #htl3r.short[ot]-Gerätschaft zu schützen. @fw-rugged-feats[comp]

=== Grundkonfiguration

#htl3r.code-file(
  caption: "Zellen-Firewall Grundkonfiguration",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((35, 41),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

=== Multi-VDOM-Mode zur Mikrosegmentierung der Zellen <vdoms>

Eine #htl3r.short[vdom] (kurz für "#htl3r.long[vdom]") ist eine von anderen #htl3r.shortpl[vdom] unabhängige administrative Einheit innerhalb einer FortiGate-Firewall.

Wenn kein Multi-#htl3r.short[vdom]-Mode verwendet wird, läuft alles auf der Firewall über die Root-#htl3r.short[vdom] und alle vorgenommenen Konfigurationen sind global auf dem Gerät vorhanden. Die Root-#htl3r.short[vdom] kann somit nicht gelöscht werden. @vdom-overview[comp]

Fortinet gibt einige Verwendungsarten für #htl3r.shortpl[vdom] vor, wobei bei der Zellen-Firewall zwei dieser Arten gemeinsam eingesetzt werden:

+ *Internet access VDOM*: \
  In dieser Konfiguration ist der Internetzugang über eine einzelne #htl3r.short[vdom] -- beispielsweise die Root-#htl3r.short[vdom] in @internet-access-vdom -- bereitgestellt.
  #htl3r.fspace(
    total-width: 95%,
    [
      #figure(
        image("../assets/internet_access_vdom_official.png"),
        caption: [Eine Beispieltopologie für die "Internet access VDOM" @vdom-overview]
      )
      <internet-access-vdom>
    ]
  )
  Die Root-#htl3r.short[vdom] versorgt die #htl3r.shortpl[vdom] der Betriebszellen durch sogenannte #htl3r.short[vdom]-Links -- virtuelle Netzwerke innerhalb der FortiGate, die dazu dienen, #htl3r.shortpl[vdom] untereinander zu vernetzen. Im Falle der Zellen-Firewall ist die Root-#htl3r.short[vdom] nicht für den Internetzugang zuständig, sondern für die Verbindung mit dem restlichen Firmennetzwerk über die Übergangs-Firewall.

+ *Administrative VDOM* (on a management network) \
  In dieser Konfiguration ist der Managementzugang auf die FortiGate über eine eigene #htl3r.short[vdom] bereitgestellt. Somit werden die Daten von den Geräten, die am Management-Interface hängen, von der Firewall nicht in andere Netzwerke geroutet (so lange kein #htl3r.short[vdom]-Link vorhanden ist, siehe @administrative-vdom).
  #htl3r.fspace(
    total-width: 95%,
    [
      #figure(
        image("../assets/administrative_vdom_official.png"),
        caption: [Eine Beispieltopologie für die "Administrative VDOM" @vdom-overview]
      )
      <administrative-vdom>
    ]
  )

Die Aspekte der "Internet access #htl3r.short[vdom]" finden sich in der Segmentierung der Betriebszellen-spezifischen Konfiguration mittels eigenen #htl3r.shortpl[vdom] für jede Zelle wider. Somit ist beispielsweise die Konfiguration der Policies für den Datenverkehr von Zelle Eins zum #htl3r.short[scada] vom Datenverkehr von Zelle Zwei zum #htl3r.short[scada] voneinander getrennt. Dies macht zwar die Konfiguration neuer Policies und deren Anwendung zwar umständlicher, es garantiert aber, dass sich der/die Systemadministrator*in immer dessen bewusst ist, im Rahmen welcher Zelle er/sie gerade handelt und somit weniger Konfigurationsfehler auftreten können.

Die "Administrative #htl3r.short[vdom]" ist implementiert worden, um eine vom restlichen Netzwerk möglichst abgetrennte Verbindung zur Firewall bereitzustellen, über welche der Konfigurationszugriff gestattet ist.

Zur Konfiguration dieser #htl3r.shortpl[vdom] muss zuerst mittels `config vdom` in den #htl3r.short[vdom]-Konfigurationsmodus gewechselt werden. Anschließend kann mit `edit <NAME>` eine neue #htl3r.short[vdom] erstellt werden bzw. eine bestehende bearbeitet werden.

#htl3r.code-file(
  caption: "Die Grundkonfiguration der VDOM von Zelle Eins",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((78, 103),),
  skips: ((77, 0), (104, 0),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

Wie in Quellcode 10.14 zu sehen ist, müssen jegliche Konfigurationsschritte (z.B. die Erstellung von Adressobjekten), die normalerweise systemweit durchgeführt werden, pro #htl3r.short[vdom] einzeln durchgeführt werden. Dies ist zwar zuerst lästig, bei einer fertigen Konfiguration dient dies jedoch zur Vorbeugung von Flüchtigkeitsfehlern beim zukünftigen Umkonfigurieren.

Eine Alternative zu der Verwendung von #htl3r.shortpl[vdom] zur Segmentierung von den Betriebszellen wäre die Verwendung von #htl3r.shortpl[vlan] mit folgendem Aufbau:

#htl3r.fspace(
    [
      #figure(
        image("../assets/zellen_router_on_a_stick.png"),
        caption: ["Router on a Stick" als Alternative zu VDOMs]
      )
    ]
  )

Hierbei werden alle #htl3r.shortpl[sps] an einen gemeinsamen #htl3r.short[ot]-Switch angebunden, welcher ähnlich zur Zellen-Firewall direkt im Schaltschrank hängt. Dieser weißt den einzelnen Interfaces, die zu den #htl3r.shortpl[sps] führen, eigene #htl3r.shortpl[vlan] zu, um die Verbindungen in mehrere Netzwerk aufzuspalten. Die Firewall erhält über eine Trunk-Verbindung vom Switch alle Daten aus den einzelnen #htl3r.shortpl[vlan] und leitet diese je nach ihrer Herkunft anders weiter, als wären sie aus verschiedenen Netzwerken gekommen, wobei nie die dritte #htl3r.short[osi]-Schicht verwendet worden ist. Diese Methode wird "Router on a Stick" genannt.

Einer der Nachteile bei der Verwendung von #htl3r.shortpl[vdom] in diesem Kontext ist, dass für die Verbindung und nötige Absicherung zwischen der Zellen-Firewall und der Übergangs-Firewall nicht direkt das #htl3r.short[wan]-Interface genutzt werden kann. Ein Interface kann immer jeweils nur einer #htl3r.short[vdom] zugewiesen sein. Somit können aber keine Policies erstellt werden, die beispielsweise Datenverkehr aus den einzelnen Betriebszellen (also z.B. vom Interface `internal1`, welches der #htl3r.short[vdom] `VDOM-CELL-1` zugewiesen ist) in Richtung der Übergangs-Firewall erlauben, da das #htl3r.short[wan]-Interface Teil der Root-#htl3r.short[vdom] ist. Alle Interfaces, die in einer Policy genutzt werden, müssen in der gleichen #htl3r.short[vdom] wie die Policy selbst sein. Um dieses Problem zu lösen, müssen innerhalb der Zellen-Firewall zwischen den #htl3r.shortpl[vdom] sogenannte #htl3r.short[vdom]-Links erstellt werden (wie in @internet-access-vdom).

#htl3r.code-file(
  caption: "Zuweisung der Zelle Eins VDOM zu den Interfaces",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((205, 205), (214, 227), (262, 270),),
  skips: ((206, 0), (228, 0), (271, 0)),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

#htl3r.short[vdom]-Links stellen virtuelle Netzwerke dar, die nur innerhalb der FortiGate existieren und zur Verbindung zwischen zwei #htl3r.shortpl[vdom] dienen. Sie lösen das Problem mit dem gemeinsamen #htl3r.short[wan]-Interface nach außen, indem die Policies nicht direkt auf das #htl3r.short[wan]-Interface selbst angewendet werden, sondern auf die Virtual-Link-Interfaces, die an der Root-#htl3r.short[vdom] und somit am #htl3r.short[wan]-Interface angeschlossen sind.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/VDOM_Links.png"),
    caption: [Graphische Darstellung der VDOMs und deren Links untereinander]
  )
)

=== Policies der Zellen-Firewall

Eines der wichtigsten Werkzeuge, die eine FortiGate -- wie viele andere Firewalls auch -- bietet, sind Policies. Standardmäßig lässt eine FortiGate-Firewall keinerlei Datenverkehr durch, ein "implicit deny" wird verwendet. Es müssen durch den/die zuständige Netzwerkadministrator/in beim Einsatz einer FortiGate die nötigen Firewall-Policies erstellt werden, um den Datenverkehr auf das nötige Minimum einzuschränken, ohne dabei die Funktionalität des (bestehenden) Netzwerks zu beeinträchtigen.

Durch den Einsatz von den bereits in @vdoms beschriebenen #htl3r.longpl[vdom] und deren #htl3r.short[vdom]-Links können nicht direkt Policies für den nötigen Datenverkehr zwischen dem #htl3r.short[scada] und den #htl3r.shortpl[sps] erstellt werden. Es müssen stattdessen Policies für den Datenverkehr, der über die einzelnen #htl3r.short[vdom]-Links gehen soll, erstellt werden.

Zuerst muss in der Root-#htl3r.short[vdom] pro Zelle eine Policy erstellt werden, die den #htl3r.short[icmp] und Modbus #htl3r.short[tcp] Datenverkehr vom Interface "wan1" -- die Anbindung an die Übergangs-Firewall -- zum internen #htl3r.short[vdom]-Link der jeweiligen Zelle erlaubt. Anschließend wird in der jeweiligen Zellen-#htl3r.short[vdom] die zweite Policy erstellt, die vom internen #htl3r.short[vdom]-Link den Datenverkehr wieder auf das physische Interface ("internal1", "internal2" oder "internal3") zu der Zelle erlaubt. Was nicht vergessen werden darf, ist, dass die #htl3r.shortpl[vdom] ebenfalls statische Routen brauchen, denn durch die Trennung der Netzwerke mittels #htl3r.short[vdom]-Links sind diese nicht mehr "directly connected" zueinander.

#htl3r.code-file(
  caption: "Root-VDOM-Policy für den VDOM-Link der dritten Betriebszelle",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((309, 327),),
  skips: ((328, 0),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

#pagebreak(weak: true)
Die Policy für den Datenverkehr zwischen der #htl3r.short[vdom] von Zelle Drei und der Root-#htl3r.short[vdom] sieht dann wiefolgt aus:

#htl3r.code-file(
  caption: "Policy innerhalb der Zelle-Drei-VDOM für Kommunikation von der Root-VDOM zur Zelle",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((400, 425),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

#pagebreak(weak: true)
Die Root-#htl3r.short[vdom] braucht für alle drei Zellen-#htl3r.short[vdom]-Links jeweils eine statische Route, hier wird die Route zur dritten Betriebszelle gezeigt:

#htl3r.code-file(
  caption: "Statische Route in der Root-VDOM für das Netzwerk von Zelle Drei",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((343, 347),),
  skips: ((342, 0),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

=== Lizensierte Features für OT-Security

Mit einer FortiGate-Firewall lassen sich nicht nur Policies schreiben, um den Datenverkehr zu regulieren. Es können die auch Daten laufend in Form eines #htl3r.short[ips] analysiert und anhand des Inhalts blockiert bzw. erlaubt werden.

Die Nutzung dieser Features ist von den auf der Firewall registrierten Lizenzen abhängig, da in der Basispaket-Lizenz der Fortiguard #htl3r.short[ips] Sicherheitsservice zum Beispiel nicht inkludiert ist./

#htl3r.short[ot]-Signaturen sind zwar Teil des Fortiguard #htl3r.short[ips] Sicherheitsservice, sind aber standardmäßig deaktiviert. Mit folgender Konfiguration werden die #htl3r.short[ot]-Signaturen der #htl3r.short[ips]-Engine freigegeben:

#htl3r.code-file(
  caption: "OT-Signaturen und Modbus-Decoder im IPS aktivieren",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((161, 170),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

In Quellcode 10.19 wurde ebenfalls der Modbus-Decoder des #htl3r.short[ips] auf den Port 502 eingeschränkt, da Modbus-#htl3r.short[tcp] immer auf Port 502 kommuniziert. Der Modbus-Decoder sollte zwar standardmäßig bereits nur die Daten auf Port 502 bearbeiten, falls die Range jedoch größer konfiguriert sein sollte, kann dies zu erheblichen Perfomance-Problemen mit der Firewall führen.
@fw-ips-modbus-decoder[comp]
