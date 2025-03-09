#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author("Bastian Uhlig")
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
  lang: "fortios",
  ranges: ((35, 41),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

=== Multi-VDOM-Mode

Eine #htl3r.short[vdom] (kurz für "Virtual Domain") ist eine von anderen #htl3r.shortpl[vdom] unabhängige administrative Einheit innerhalb einer FortiGate-Firewall.

Wenn kein Multi-#htl3r.short[vdom]-Mode verwendet wird, läuft alles auf der Firewall über die Root-#htl3r.short[vdom] und alle vorgenommenen Konfigurationen sind global auf dem Gerät vorhanden. Die Root-#htl3r.short[vdom] kann somit nicht gelöscht werden. @vdom-overview[comp]

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

#htl3r.todo("GRAFIK VERTIKAL MACHEN (d.h. nicht nur drehen)")

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
