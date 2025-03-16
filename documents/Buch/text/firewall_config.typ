#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author("Bastian Uhlig")
= Firewall-Konfiguration <firewall-config>

#htl3r.author("Bastian Uhlig")
== Uplink-Firewall
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
Das INET-Interface ist dabei nur dazu da, um während der automatischen Provisionierung (siehe @provisionierung) #htl3r.shortpl[vm] den Zugriff auf das Internet zu ermöglichen. Über das Management-Interface kann währenddessen auf Management-Ressourcen zugegriffen werden, wie zum Beispiel die esxis oder der vCenter-Server. 

#htl3r.fspace(
  total-width: 95%,
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
Policies sind eins der wichtigsten Tools einer Firewall -- und damit auch der FortiGate. Mit ihnen wird der Datenverkehr reguliert und gesteuert. Standardmäßig lässt eine FortiGate-Firewall keinen Datenverkehr durch, es muss also alles explizit erlaubt werden. 

Im Falle der Uplink-Firewall sind die Policies so konfiguriert, dass nur der nötige Datenverkehr durchgelassen wird. Das heißt, dass von außen nur Datenverkehr auf den Exchange-Server zugelassen wird, und auch da nur auf die Ports, die benötigt werden. \
In die #htl3r.short[it]-SEC-Zone wird nur Datenverkehr zugelassen, der auch notwendig ist. Dies bedeutet alle für #htl3r.short[adds] notwendigen Ports und Protokolle, sowie Web-Access auf die Nozomi Guardian. \
Richtung Downlink wird nur der #htl3r.short[vpn]-Traffic in Richtung Jumpbox erlaubt.

#htl3r.author("Julian Burger")
== Übergangs-Firewall

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

=== Multi-VDOM-Mode

Eine #htl3r.short[vdom] (kurz für "Virtual Domain") ist eine von anderen #htl3r.shortpl[vdom] unabhängige administrative Einheit innerhalb einer FortiGate-Firewall.

Wenn kein Multi-#htl3r.short[vdom]-Mode verwendet wird, läuft alles auf der Firewall über die Root-#htl3r.short[vdom] und alle vorgenommenen Konfigurationen sind global auf dem Gerät vorhanden. Die Root-#htl3r.short[vdom] kann somit nicht gelöscht werden. @vdom-overview[comp]

Fortinet gibt einige Verwendungsarten für #htl3r.shortpl[vdom] vor, wobei bei der Zellen-Firewall zwei dieser Arten gemeinsam eingesetzt werden:

+ *Internet access VDOM*: \
  In dieser Konfiguration ist der Internetzugang über eine einzelne #htl3r.short[vdom] -- beispielsweise die Root-VDOM in @internet-access-vdom -- bereitgestellt.
  #htl3r.fspace(
    total-width: 95%,
    [
      #figure(
        image("../assets/internet_access_vdom_official.png"),
        caption: [Eine Beispieltopologie für die "Internet access VDOM"]
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

Zur Konfiguration dieser VDOMs ... TODO

#htl3r.code-file(
  caption: "Die Grundkonfiguration der VDOM von Zelle Eins",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((78, 103),),
  skips: ((77, 0), (104, 0),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

Eine Alternative zu der Verwendung von #htl3r.shortpl[vdom] zur Segmentierung von den Betriebszellen wäre die Verwendung von #htl3r.shortpl[vlan] mit folgendem Aufbau:

#htl3r.fspace(
    [
      #figure(
        image("../assets/zellen_router_on_a_stick.svg"),
        caption: ["Router on a Stick" als Alternative zu VDOMs]
      )
    ]
  )

Hierbei werden alle #htl3r.shortpl[sps] an einen gemeinsamen #htl3r.short[ot]-Switch angebunden, welcher ähnlich zur Zellen-Firewall direkt im Schaltschrank hängt. Dieser weißt den einzelnen Interfaces, die zu den #htl3r.shortpl[sps] führen, eigene #htl3r.shortpl[vlan] zu, um die Verbindungen in mehrere Netzwerk aufzuspalten.

Die Firewall erhält über eine Trunk-Verbindung vom Switch alle Daten aus den einzelnen #htl3r.shortpl[vlan] und leitet diese je nach ihrer Herkunft anders weiter, als wären sie aus verschiedenen Netzwerken gekommen, wobei nie die dritte #htl3r.short[osi]-Schicht verwendet worden ist. Diese Methode wird "Router on a Stick" genannt.

Eine der Tücken bei der Verwendung von #htl3r.shortpl[vdom] in diesem Kontext ist die, dass für die Verbindung und nötige Absicherung zwischen der Zellen-Firewall und der Übergangs-Firewall nicht direkt das #htl3r.short[wan]-Interface genutzt werden kann. Ein Interface kann immer jeweils nur einer #htl3r.short[vdom] zugewiesen sein. Somit können aber keine Policies erstellt werden, die beispielsweise Datenverkehr aus den einzelnen Betriebszellen (also vom Interface `internal1` z.B., das der #htl3r.short[vdom] `VDOM-CELL-1` zugewiesen ist) in Richtung der Übergangs-Firewall erlauben, da das #htl3r.short[wan]-Interface Teil der Root-#htl3r.short[vdom] ist. Alle Interfaces, die in einer Policy genutzt werden, müssen in der gleichen #htl3r.short[vdom] wie die Policy selbst sein. Um dieses Problem zu lösen, müssen innerhalb der Zellen-Firewall zwischen den #htl3r.shortpl[vdom] sogenannte #htl3r.short[vdom]-Links erstellt werden (wie in @internet-access-vdom).

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
    caption: [Graphische Darstellung der #htl3r.shortpl[vdom] und deren Links untereinander]
  )
)

=== Policies

Eines der wichtigsten Werkzeuge, die eine FortiGate -- wie viele andere Firewalls auch -- bietet, sind Policies. Standardmäßig lässt eine FortiGate-Firewall keinerlei Datenverkehr durch, ein "implicit deny" wird verwendet. Es müssen durch den/die zuständige Netzwerkadministrator/in beim Einsatz einer FortiGate die nötigen Firewall-Policies erstellt werden, um den Datenverkehr auf das nötige Minimum einzuschränken, ohne dabei die Funktionalität des (bestehenden) Netzwerks zu beeinträchtigen.



=== Lizensierte Features

Mit einer FortiGate-Firewall lassen sich nicht nur Policies schreiben, um den Datenverkehr zu regulieren. Es können die auch Daten laufend in Form eines #htl3r.short[ips] analysiert und anhand des Inhalts blockiert bzw. erlaubt werden.

Die Nutzung dieser Features ist von den auf der Firewall registrierten Lizenzen abhängig, da in der Basispaket-Lizenz der Fortiguard #htl3r.short[ips] Sicherheitsservice zum Beispiel nicht inkludiert ist.

#htl3r.short[ot]-Signaturen sind zwar Teil des Fortiguard #htl3r.short[ips] Sicherheitsservice, sind aber standardmäßig deaktiviert. Mit folgender Konfiguration werden die #htl3r.short[ot]-Signaturen der #htl3r.short[ips]-Engine freigegeben:

#htl3r.code-file(
  caption: "OT-Signaturen und Modbus-Decoder im IPS aktivieren",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "fortios",
  ranges: ((161, 170),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)
@fw-ips-modbus-decoder[comp]

Es wurde ebenfalls der Modbus-Decoder des #htl3r.short[ips] auf den Port 502 eingeschränkt, da Modbus-#htl3r.short[tcp] immer auf Port 502 kommuniziert. Der Modbus-Decoder sollte zwar standardmäßig bereits nur die Daten auf Port 502 bearbeiten, falls die Range jedoch größer konfiguriert sein sollte, kann dies zu erheblichen Perfomance-Problemen mit der Firewall führen.
