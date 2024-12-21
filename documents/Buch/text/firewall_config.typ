#import "@local/htl3r-da:0.1.0" as htl3r

= Firewall-Konfiguration

#htl3r.author("Bastian Uhlig")
== Uplink-Firewall

#htl3r.author("Julian Burger")
== Übergangs-Firewall

#htl3r.author("David Koch")
== Zellen-Firewall

Die Zellen-Firewall -- eine FortiGateRugged60F -- dient dem Schutz des empfindlichsten Teil des gesamten Netzwerks: der OT. Konzepte wie die physischen Segmentierung von untereinander unabhängiger Aktorik/Sensorik in Betriebszellen bringt nichts, wenn sich diese aufgrund von einer fehlenden Netzwerksegmentierung trotzdem ohne weitere Umwege gegenseitig ansprechen können. Aus diesem Grund wird die Zellen-Firewall gebraucht. Sie bietet noch dazu Features wie DPI und mitgelieferten Signaturen für bekannte OT-Daten, um die empfangenen Daten so gut es geht zu identifizieren und im Falle eines Sicherheitsvorfalls die OT-Gerätschaft zu schützen. @fw-rugged-feats

=== Grundkonfiguration

#htl3r.code_file(
  caption: "Zellen-Firewall Grundkonfiguration",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "python", // TODO: wo fortios
  ranges: ((35, 41),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

=== Multi-VDOM-Mode

Eine #htl3r.short[vdom] (kurz für "Virtual Domain") ist eine von anderen #htl3r.shortpl[vdom] unabhängige administrative Einheit innerhalb einer FortiGate-Firewall. TODOOOO. Wenn kein Multi-#htl3r.short[vdom]-Mode verwendet wird, läuft alles auf der Firewall über die Root-#htl3r.short[vdom].

Fortinet gibt einige Verwendungsarten für #htl3r.short[vdom]s vor, wobei bei der Zellen-Firewall zwei dieser Arten gemeinsam eingesetzt werden:
+ *Internet access VDOM*

fdfdf
#htl3r.fspace(
  figure(
    image("../assets/internet_access_vdom_official.png"),
    caption: [Die offizielle "Internet access VDOM" Topologie]
  )
)

+ *Administrative VDOM* (on a management network)

fdfdfdf
#htl3r.fspace(
  figure(
    image("../assets/administrative_vdom_official.png"),
    caption: [Die offizielle "Administrative VDOM" Topologie]
  )
)

https://docs.fortinet.com/document/fortigate/7.6.1/administration-guide/597696/vdom-overview

#htl3r.code_file(
  caption: "Die Konfiguration der VDOM von Zelle 1",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "python", // TODO: wo fortios
  ranges: ((43, 86), (111, 111)),
  skips: ((87, 0),),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)

#htl3r.code_file(
  caption: "Zuweisung der Zelle 1 VDOM zum Interface",
  filename: [Zellen-FW-Fenrir.conf],
  lang: "python", // TODO: wo fortios
  ranges: ((113, 114), (123, 125), (133, 133), (162, 163)),
  skips: ((115, 0), (126, 0), (134, 0)),
  text: read("../assets/scripts/Zellen-FW-Fenrir.conf")
)
