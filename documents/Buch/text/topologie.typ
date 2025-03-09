#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author("David Koch")
= Topologie

Der Aufbau einer realistischen Netzwerktopologie wie sie in einer echten Kläranlage zu finden wäre ist unabdingbar wenn es darum geht, die Gefahr von Cyberangriffen auf #htl3r.short[ot]-Systeme zu dokumentieren.

In den nächsten Abschnitten wird das Zusammenspiel von physischen und virtuellen Geräten im Rahmen der Diplomarbeitstopologie genauer gezeigt und erklärt.

#htl3r.author("David Koch")
== Logische Topologie <logische-topo>

Durch die Limitationen an verfügbarer physischer Hardware ist die unten gezeigte logische Topologie physisch nicht direkt umsetzbar. Durch den Einsatz von Virtualisierung, welcher in @physische-topo genauer erklärt wird, lassen sich alle nötigen Geräte, für die sonst keine physische Hardware verfügbar wäre, trotzdem in das Netzwerk einbinden.

Die gezeigte Topologie ist somit eine Darstellung, in welcher die für die Virtualisierung genutzte physische Hardware und somit auch die Verknüpfung von physischer zu virtueller Gerätschaft nicht eingezeichnet ist.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/topology_logical.svg"),
    caption: [Die Projekttopologie in logischer Darstellung]
  )
)

=== Geräte

#htl3r.todo("Hier Tabelle oder so machen")

== Physische Topologie <physische-topo>

#lorem(100)

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/topology_physical.svg"),
    caption: [Die Projekttopologie in physischer Darstellung]
  )
)
ACHTUNG: VERALTET

* BILD schrank bzw schränke *

=== Verwendete Geräte


#htl3r.author("Julian Burger")
== Virtualisierungsplatform und Umgebung
Innerhalb der Diplomarbeit werden alle IT-Geräte virtualisiert. Dies bringt meherere Vorteile mit sich, unter anderem schnelles und resourcensparendes Deployment, da #htl3r.shortpl[vm] mit exact den Ressourcen gestartet werden können, welche sie auch tatsächlich benötigen. Natürlich ist es ebenso von großer Wichtigkeit, dass die Virtualisierungsplatform gute Integrationen mit #htl3r.long[iac]-Tools bietet. Eine Platform, welche gute #htl3r.short[iac]-Tools integration und leichtes Management bietet, ist VMware-ESXi. VMware bietet ebenso einen Clusteringdienst an, namens vCenter. VMware-vCenter ermöglicht es mehrere ESXi-Instanzen in ein logisches Datacenter zusammenzufassen. Somit können die #htl3r.shortpl[vm] auf einem geteiltem Speichermedium abgespeichert werden und beliebig von den ESXi-Instanzen gestartet werden.

#htl3r.fspace(
  figure(
    image("../assets/vcenter_logical.png"),
    caption: [Logischer Plan der vCenter Umgebung]
  )
)

Dies ermöglicht ebenso eine gewisse Ausfallsicherheit, da #htl3r.shortpl[vm] unabhängig von den ESXi-Instanzen sind und im Falle eines Ausfalls von einer Instanz auf eine andere Übertragen werden können. Hier gibt es bei VMware Lösungen wie vMotion, welche solche Live-Migrationen durchführen können. Im Rahmen dieser Diplomarbeit kommt dies jedoch nicht zum Einsatz. Es wird lediglich #htl3r.long[drs] verwendet um die #htl3r.shortpl[vm] auf die ESXi-Instanzen aufzuteilen.

=== vCenter Umgebung
Der vCenter-Dienst läuft als #htl3r.short[vm] auf ESXi 1 und kommuniziert mit den restlichen ESXi-Instanzen über ein Management-Netzwerk. Dieses Mangement-Netzwerk ist als #htl3r.short[vlan] realisiert. Die #htl3r.short[vlan]-ID des Netzwerks ist 120 und als Subnetz wird 10.40.20.0/24 verwendet. Da vCenter eine #htl3r.short[sso]-Domäne erstellt, welche eine #htl3r.short[dns]-Domäne benötigt, existiert innerhalb des Management-Netzwerkes die #htl3r.short[dns]-Domäne fenrir.local mit folgenden #htl3r.short[dns]-Einträgen:

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 10pt,
      align: (horizon + left, horizon + center, horizon + left),
      table.header(
        [*DNS-Name*], [*Adresse*], [*Gerät*],
      ),
      [vcenter.fenrir.local], [10.40.20.10], [vCenter VM],
      [esxi1.fenrir.local], [10.40.20.11], [ESXi 1],
      [esxi2.fenrir.local], [10.40.20.12], [ESXi 2],
      [esxi3.fenrir.local], [10.40.20.13], [ESXi 3],
      [shared-storage.fenrir.local], [10.40.20.80], [NFS Share],
      [nozomi.fenrir.local], [10.40.20.100], [Nozomi Guardian],
      [cluster-switch.fenrir.local], [10.40.20.200], [Cluster Switch],
    ),
    caption: [Management-Netzwerk DNS Einträge],
  )
)

Als DNS-Server fungiert eine Uplink-Firewall. Diese ermöglicht ebenso einen Internetzugang, welcher benötigt wird um Software auf den #htl3r.shortpl[vm] herunterzuladen.

Wie bereits beschrieben existiert ebenso ein Storage-Server, welcher von den ESXi-Instanzen erreichbar ist. Dies passiert allerdings nicht über das Management-Netzwerk, sondern über ein eigenes Storage #htl3r.short[vlan]. Dies hat den Grund, dass das Storage-Netzwerk eine sehr hohe Auslastung aufgrund von #htl3r.short[nfs] Lese- und Schreibzugriffen hat. Um dieser Auslastung gerecht zu werden ist der Storage-Server mit vier Gigabit-Ethernet Links angeschlossen. Diese vier physischen Links wurden mittels #htl3r.short[lacp] zu einem logischen Link zusammengefasst. Die ESXi-Instanzen haben jeweils einen dedizierten Gigabit-Ethernet Link für #htl3r.short[nfs]. So ist es möglich mit akzeptabler Geschwindigkeit auf das Speicher-Medium zuzugreifen.

=== Konfiguration des vCenters

#htl3r.author("David Koch")
== OT-Bereich

Der OT-Bereich besteht aus einem von uns selbst gebauten Modell einer Kläranlage. Diese setzt sich aus einer archimedischen Schraube, einem Rechen, Wassertanks, Filtern, einem Staudamm und Pumpen zusammen. Diese Gegenstände sind mit verbauter Aktorik und/oder Sensorik ausgestattet und dienen als Ansteuerungsziele mehrerer #htl3r.short[sps]. Diese werden nach Aufbau auch als Angriffsziele verwendet, wobei ein Angreifer beispielsweise die Pumpen komplett lahmlegen oder durch deren Manipulation einen Wasserschaden verursachen könnte.

* BILD topo *

* BILD Kläranlage *

Die Details bezüglich des Aufbaus der Modell-Kläranlage und der dazugehörigen #htl3r.short[ot]-Gerätschaft siehe @aufbau-klaeranlage.

#htl3r.author("David Koch")
== Purdue-Modell <purdue>

Das Purdue-Modell (auch bekannt als "Purdue Enterprise Reference Architecture", kurz PERA), ähnlich zum OSI-Schichtenmodell, dient zur Einteilung bzw. Segmentierung eines #htl3r.short[ics]-Netzwerks. Je niedriger die Ebene, desto kritischer sind die Prozesskontrollsysteme, und desto strenger sollten die Sicherheitsmaßnahmen sein, um auf diese zugreifen zu können. Die Komponenten der niedrigeren Ebenen werden jeweils von Systemen auf höhergelegenen Ebenen angesteuert.

Level 0 bis 3 gehören zur #htl3r.short[ot], 4 bis 5 sind Teil der #htl3r.short[it].
Es gibt nicht nur ganzzahlige Ebenen, denn im Falle einer #htl3r.short[dmz] zwischen beispielsweise den Ebenen 3 und 4 wird diese als Ebene 3.5 gekennzeichnet.

#htl3r.fspace(
  figure(
    image("../assets/fenrir_purdue.svg", width: 95%),
    caption: [Die Projekttopologie im Purdue-Modell]
  )
)

== Verknüpfung physisch & virtuell

=== Modbus TCP

Neben Profinet, EtherCat und co. hat sich dieses Protokoll für die industrielle Kommunikation über Ethernet-Leitungen etabliert.

Schneider Automation hat der Internetstandardisierungs-Organisation #htl3r.short[ietf] den Wunsch gebracht, Modbus auf einem #htl3r.short[tcp]/#htl3r.short[ip]-Übertragungsmedium laufen zu lassen. Dabei wurde das Modbus-Modell und der #htl3r.short[tcp]/#htl3r.short[ip]-Stack nicht verändert, da nur eine Enkapsulierung von Modbus in #htl3r.short[tcp]-Packets stattfindet. Seit diesem Zeitpunkt wurde Modbus zu einem Überbegriff und besteht aus:

#[
#set par(hanging-indent: 12pt)
- *Modbus-#htl3r.short[rtu]:* Asynchrone Master/Slave-Kommunikation über RS-485, RS-422 oder RS-232 Serial-Leitungen
- *Modbus-#htl3r.short[tcp]:* Ethernet bzw. #htl3r.short[tcp]/#htl3r.short[ip] basierte Client-Server Kommunikation
- *Modbus-Plus:* Wie bereits zuvor erwähnt hat Modbus ursprünglich eine Master/Slave-Architektur verwendet, dieses Konzept hat sich bei den Abstammungen von der Idee her nicht verändert, es heißt nur anders und wird anders gehandhabt, z.B.: Client/Server bei #htl3r.short[tcp]/#htl3r.short[ip]. Es ist hauptsächlich für Token-Passing Netzwerke gedacht.
]

#htl3r.todo("QUELLEN HIER")

Als Unterschied zwischen Modbus-#htl3r.short[rtu] und Modbus-#htl3r.short[tcp] kennzeichnet sich am Meisten die Redundanz bzw. Fehlerüberprüfung der Datenübertragung und die Adressierung der Slaves.

Modbus-#htl3r.short[rtu] sendet zusätzlich zu Daten und einem Befehlscode eine #htl3r.short[crc]-Prüfsumme und die Slave-Adresse. Bei Modbus-#htl3r.short[tcp] werden diese innerhalb des Payloads nicht mitgeschickt, da bei #htl3r.short[tcp] die Adressierung bereits im #htl3r.short[tcp]/#htl3r.short[ip]-Wrapping vorhanden ist (Destination Address) und die Redundanzfunktionen durch die #htl3r.short[tcp]/#htl3r.short[ip]-Konzepte wie eigenen Prüfsummen, Acknowledgements und Retransmissions.

Bei der Enkapsulierung von Modbus in #htl3r.short[tcp] werden nicht nur der Befehlscode und die zugehörigen Daten einfach in die Payload getan, sondern auch ein MBAP (Modbus Application Header), welcher dem Server Sachen wie die eindeutige Interpretation der empfangenen Modbus-Parameter sowie Befehle bietet.
#htl3r.fspace(
  figure(
    image("../assets/modbus_encap_copy.svg"),
    caption: [Visualisierung des Modbus TCP Headers]
  )
)
@modbus-tcp-encap

Durch die Enkapsulierung in #htl3r.short[tcp] verliert die ursprünglich Serielle-Kommunikation des Modbus-Protokolls ca. 40\% seiner ursprünglichen Daten-Durchsatzes. Jedoch ist dieser Verlust es im Vergleich zu den bereits zuvor erwähnten, von #htl3r.short[tcp] mitgebrachten Vorteilen, definitiv Wert. Nach der Enkapsulierung können im Idealfall 3,6 Mio. 16-bit-Registerwerte pro Sekunde in einem 100Mbit/s switched Ethernet-Netzwerk übertragen werden, und da diese Werte im Regelfall bei Weitem nicht erreicht werden, stellt der partielle Verlust an Daten-Durchsatz kein Problem dar.

Die Einführung dieses offenen Protokolls bedeutete auch gleichzeitig den Einzug der auf Ethernet gestützten Kommunikation in der Automationstechnik, da hierdurch zahlreiche Vorteile für die Entwickler und Anwender erschlossen wurden. So wird durch den Zusammenschluss von Ethernet mit dem allgegenwärtigen Netzwerkstandard von Modbus #htl3r.short[tcp] und einer auf Modbus basierenden Datendarstellung ein offenes System geschaffen, das dies Dank der Möglichkeit des Austausches von Prozessdaten auch wirklich frei zugänglich macht. Zudem wird die Vormachtstellung dieses Protokolls auch durch die Möglichkeit gefördert, dass sich Geräte, die fähig sind den #htl3r.short[tcp]/IP-Standard zu unterstützen, implementieren lassen. Modbus #htl3r.short[tcp] definiert die am weitesten entwickelte Ausführung des offenen, herstellerneutralen Protokolls und sorgt somit für eine schnelle und effektive Kommunikation innerhalb der Teilnehmer einer Netzwerktopologie, die flexibel ablaufen kann. Zudem ist dieses Protokoll auch das einzige der industriellen Kommunikation, welches einen "Well known port", den Port 502, besitzt und somit auch im Internet routingfähig ist. Somit können die Geräte eines Systems auch über das Internet per Fernzugriff gesteuert werden, was aber gleichzeitig viele Gefahren mit sich bringt.
// obiger absatz pure kopiererei von svon und somit aus undokumentierten quellen und so grrrr

=== BURGER DU HIER MACHEN
#htl3r.todo("Bitte drüber schreiben wie die VMs in vSphere über den Switch per VLANs und so mit der echten Welt kommunizieren")
