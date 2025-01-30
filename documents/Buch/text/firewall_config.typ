#import "@preview/htl3r-da:0.1.0" as htl3r

#htl3r.author("Julian Burger")
= Firewall-Konfiguration <firewall-config>

#htl3r.author("Bastian Uhlig")
== Uplink-Firewall

#htl3r.author("Julian Burger")
== Übergangs-Firewall

#htl3r.author("David Koch")
== Zellen-Firewall

Die Zellen-Firewall -- eine FortiGateRugged60F -- dient dem Schutz des empfindlichsten Teil des gesamten Netzwerks: der #htl3r.short[ot]. Konzepte wie die physischen Segmentierung von untereinander unabhängiger Aktorik/Sensorik in Betriebszellen ist nutzlos, wenn sich diese aufgrund von einer fehlenden Netzwerksegmentierung trotzdem ohne weitere Umwege gegenseitig ansprechen können. Aus diesem Grund wird die Zellen-Firewall gebraucht. Sie bietet noch dazu Features wie #htl3r.short[dpi] und mitgelieferte Signaturen für bekannte #htl3r.short[ot]-Daten, um die empfangenen Daten so gut es geht zu identifizieren und im Falle eines Sicherheitsvorfalls die #htl3r.short[ot]-Gerätschaft zu schützen. @fw-rugged-feats[comp]

=== Grundkonfiguration

#htl3r.code-file(
  caption: "Zellen-Firewall Grundkonfiguration",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "python", // TODO: wo fortios
  ranges: ((35, 41),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

=== Multi-VDOM-Mode

Eine #htl3r.short[vdom] (kurz für "Virtual Domain") ist eine von anderen #htl3r.shortpl[vdom] unabhängige administrative Einheit innerhalb einer FortiGate-Firewall.

Wenn kein Multi-#htl3r.short[vdom]-Mode verwendet wird, läuft alles auf der Firewall über die Root-#htl3r.short[vdom] und alle vorgenommenen Konfigurationen sind global auf dem Gerät vorhanden. Die Root-#htl3r.short[vdom] kann somit logischerweise nicht gelöscht werden. @vdom-overview[comp]

Fortinet gibt einige Verwendungsarten für #htl3r.shortpl[vdom] vor, wobei bei der Zellen-Firewall zwei dieser Arten gemeinsam eingesetzt werden:

+ *Internet access VDOM*:
  #linebreak()
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

+ *Administrative VDOM* (on a management network)
  #linebreak()
  In dieser Konfiguration ist der Managementzugang auf die FortiGate über eine eigene #htl3r.short[vdom] bereitgestellt. Somit werden die Daten von den Geräten, die am Management-Interface hängen, von der Firewall nicht in andere Netzwerke geroutet (so lange kein #htl3r.short[vdom]-Link vorhanden ist, siehe @administrative-vdom).
  #htl3r.fspace(
    total-width: 95%,
    [
      #figure(
        image("../assets/administrative_vdom_official.png"),
        caption: [Eine Beispieltopologie für die "Administrative VDOM"]
      )
      <administrative-vdom>
    ]
  )

@vdom-overview

Die Aspekte der "Internet access #htl3r.short[vdom]" finden sich in der Segmentierung der Betriebszellen-spezifischen Konfiguration mittels eigenen #htl3r.shortpl[vdom] für jede Zelle wider. Somit ist beispielsweise die Konfiguration der Policies für den Datenverkehr von Zelle 1 zum #htl3r.short[scada] vom Datenverkehr von Zelle 2 zum #htl3r.short[scada] voneinander getrennt. Dies macht zwar die Konfiguration neuer Policies und deren Anwendung zwar umständlicher, es garantiert aber, dass sich der/die Systemadministrator*in immer dessen bewusst ist, im Rahmen welcher Zelle er/sie gerade handelt und somit weniger Konfigurationsfehler auftreten können.

Die "Administrative #htl3r.short[vdom]" ist implementiert worden, um eine vom restlichen Netzwerk möglichst abgetrennte Verbindung zur Firewall bereitzustellen, über welche der Konfigurationszugriff gestattet ist.

Zur Konfiguration dieser VDOMs ...

#htl3r.code-file(
  caption: "Die Konfiguration der VDOM von Zelle 1",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "python", // TODO: wo fortios
  ranges: ((43, 86), (111, 111)),
  skips: ((87, 0),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

#htl3r.code-file(
  caption: "Zuweisung der Zelle 1 VDOM zum Interface",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "python", // TODO: wo fortios
  ranges: ((113, 114), (123, 125), (133, 133), (162, 163)),
  skips: ((115, 0), (126, 0), (134, 0)),
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

Die Firewall erhält über eine Trunk-Verbindung vom Switch alle Daten aus den einzelnen #htl3r.shortpl[vlan] und leitet diese je nach ihrer Herkunft anders weiter, als wären sie aus verschiedenen Netzwerken gekommen, wobei nie die dritte OSI-Schicht verwendet worden ist. Diese Methode wird "Router on a Stick" genannt.

Eine der Tücken bei der Verwendung von #htl3r.shortpl[vdom] in diesem Kontext ist die, dass für die Verbindung zwischen der Zellen-Firewall und der Übergangs-Firewall nicht direkt das WAN-Interface genutzt werden kann. Ein Interface kann immer jeweils nur einer #htl3r.short[vdom] zugewiesen sein. Somit können aber keine Policies erstellt werden, die beispielsweise Datenverkehr aus den einzelnen Betriebszellen (also vom Interface ```internal1``` z.B., das der #htl3r.short[vdom] ```VDOM-CELL-1``` zugewiesen ist) in Richtung der Übergangs-Firewall erlauben, da das WAN-Interface teil der Root-#htl3r.short[vdom] ist. Um dieses Problem zu lösen, muss das WAN-Interface auf mehrere logische Interfaces aufgeteilt werden, so, dass jeweils ein Interface-Paar (innen nach außen) für jede #htl3r.short[vdom] existiert. Eine einfache Umsetzungsart dieser logischen Interfaces wäre die Nutzung von IEEE 802.1Q Enkapsulierung, d.h. #htl3r.shortpl[vlan] zwischen der Zellen- und Übergangs-Firewall.

#htl3r.code-file(
  caption: "Zuweisung der Zelle 1 VDOM zum Interface",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "python", // TODO: wo fortios
  ranges: ((124, 163), (200, 201),),
  skips: ((164, 0),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

Hierbei werden VLAN 10 für die erste Betriebszelle, VLAN 20 für die zweite und VLAN 30 für die dritte Betriebszelle verwendet.

ACHTUNG: Die einzelnen Verbindung von der Zellen-Firewall aus zu den #htl3r.shortpl[sps] sind nicht enkapsuliert und es findet dort keine #htl3r.short[vlan]-Unterteilung statt. Nur auf dem Point-to-Point Link zwischen den zwei Firewalls werden die #htl3r.shortpl[vlan] angewendet, um das Problem mit "#htl3r.short[vdom]-übergreifenden" Policies zu lösen.

#htl3r.todo("Das ganze mit VDOM-Links lösen und somit diese gesamte Seite umschreiben...")

=== Lizensierte Features

yup
