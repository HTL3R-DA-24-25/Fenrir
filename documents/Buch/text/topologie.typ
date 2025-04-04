#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("David Koch")
= Topologie

Der Aufbau einer realistischen Netzwerktopologie, wie sie in einer echten Kläranlage zu finden ist, ist unabdingbar, wenn es darum geht, die Gefahr von Cyberangriffen auf #htl3r.short[ot]-Systeme zu dokumentieren.

In den nächsten Abschnitten wird das Zusammenspiel von physischen und virtuellen Geräten im Rahmen der Diplomarbeitstopologie genauer gezeigt und erklärt. Man bedenke, dass es nicht möglich ist, die gesamte Topologie in einer einzigen Grafik im vollen Detail zu erfassen. Demnach wurde mit vereinzelten Abstraktionen gearbeitet.

#htl3r.fspace(
  total-width: 90%,
  figure(
    image("../assets/grobe_topologie.png"),
    caption: [Die Projekttopologie in grober Darstellung]
  )
)

== Purdue-Modell <purdue>

Das Purdue-Modell (auch bekannt als "Purdue Enterprise Reference Architecture", kurz PERA), ähnlich zum #htl3r.short[osi]-Schichtenmodell, dient zur Einteilung bzw. Segmentierung eines #htl3r.short[ics]-Netzwerks. Je niedriger die Ebene, desto kritischer sind die Prozesskontrollsysteme, und desto strenger sollten die Sicherheitsmaßnahmen sein, um auf diese zugreifen zu können. Die Komponenten der niedrigeren Ebenen werden jeweils von Systemen auf höhergelegenen Ebenen angesteuert. Kommunikation darf ohne weiteres auch nur zwischen direkt benachbarten Ebenen stattfinden.

#pagebreak(weak: true)
Level 0 bis 3 gehören zur #htl3r.short[ot], 4 bis 5 sind Teil der #htl3r.short[it].
Es gibt nicht nur ganzzahlige Ebenen, denn im Falle einer #htl3r.short[dmz] zwischen beispielsweise den Ebenen 3 und 4 wird diese als Ebene 3.5 gekennzeichnet.

#htl3r.fspace(
  total-width: 90%,
  figure(
    image("../assets/purdue.png"),
    caption: [Die Projekttopologie im Purdue-Modell]
  )
)

Die Netzwerksegmentierung der in dieser Diplomarbeit aufgebauten Topologie wurde anhand des Purdue-Modells durchgeführt. Dies bedeutet, dass das gesamte Netzwerk durch Fortigate-Firewalls den Ebenen des Purdue-Modells entsprechend segmentiert worden ist und der Datenverkehr zwischen den Ebenen durch granulare Firewall-Policies, die nur den nötigsten Datenverkehr erlauben, eingeschränkt worden ist.

== Logische Topologie <logische-topo>

Durch die Limitationen an verfügbarer physischer Hardware ist die in @logische-topo-bild gezeigte logische Topologie physisch nicht direkt umsetzbar. Durch den Einsatz von Virtualisierung, welcher in @physische-topo genauer erklärt wird, lassen sich alle nötigen Geräte, für die sonst keine physische Hardware verfügbar wäre, trotzdem in das Netzwerk einbinden.

Die gezeigte Topologie ist somit eine Darstellung, in welcher die für die Virtualisierung genutzte physische Hardware und somit auch die Verknüpfung von physischer zu virtueller Gerätschaft nicht eingezeichnet ist.

#htl3r.fspace(
  total-width: 95%,
  [
    #figure(
      image("../assets/logical_topo_fenrir.png"),
      caption: [Die Projekttopologie in logischer Darstellung]
    )
    <logische-topo-bild>
  ]
)

=== Alle Geräte in der logischen Topologie

#htl3r.fspace(
  total-width: 100%,
  [
    #figure(
    table(
      columns: (4fr, 3fr, 4fr),
      inset: 10pt,
      align: (horizon + left, horizon + center, horizon + left),
      table.header(
        [*Name*], [*Netzwerksegment*], [*#htl3r.short[ip]-Adresse(n)*],
      ),
      [Exchange], [#htl3r.short[it]-#htl3r.short[dmz]], [192.168.30.100/24],
      [#htl3r.short[adds]-Primary], table.cell(rowspan: 4, "IT-SEC"), [192.168.31.1/24],
      [#htl3r.short[adds]-Secondary], [192.168.31.2/24],
      [Grafana], [192.168.31.50/24],
      [File Server], [192.168.31.100/24],
      [#htl3r.short[it] Workstations], [IT-Net], [#htl3r.short[dhcp]],
      [Jump-Server], table.cell(rowspan: 1, "OT-DMZ"), [192.168.33.50/24],
      [#htl3r.short[scada]], table.cell(rowspan: 3, "OT-NET"), [10.34.0.50/16],
      [#htl3r.short[mes]], [10.34.0.100/16],
      [#htl3r.short[ot] Workstations], [#htl3r.short[dhcp]],
      [#htl3r.short[sps] Zelle Eins], table.cell(rowspan: 3, "Kläranlage"), [10.79.84.1/30],
      [#htl3r.short[sps] Zelle Zwei], [10.79.84.5/30],
      [#htl3r.short[sps] Zelle Drei], [10.79.84.9/30],
    ),
    caption: [Alle Geräte die in der logischen Topologie vorhanden sind],
  )
  <logisch-geraete>
  ]
)

#pagebreak(weak: true)
Die in @logisch-geraete aufgelisteten Netzwerksegmente werden durch drei physische FortiGate-Firewalls miteinander verbunden. Für nähere Details zu den Hardwaremodellen siehe @physisch-geraete. Die Konfiguration der Firewalls ist in @firewall-config dokumentiert.

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (3.8fr, 3fr, 3fr, 4fr),
      inset: 10pt,
      align: (horizon + left, horizon + center, horizon + center, horizon + left),
      table.header(
        [*Name*], [*Interface*], [*Netzwerksegment \ / Gerät*], [*#htl3r.short[ip]-Adresse(n)*],
      ),
      table.cell(rowspan: 5, "Uplink Firewall"),
      [wan1], [Internet], [#htl3r.short[dhcp]],
      [wan2], [Seperation Firewall], [172.16.10.2/30],
      [internal2 \ (VLAN 332)], [IT-Net], [10.32.255.254/16],
      [internal2 \ (VLAN 330)], [IT-DMZ], [192.168.30.254/24],
      [internal2 \ (VLAN 331)], [IT-SEC], [192.168.31.254/24],
      table.cell(rowspan: 4, "Seperation Firewall"),
      [wan1], [Uplink Firewall], [172.16.10.1/30],
      [wan2], [Zellen Firewall], [172.16.10.6/30],
      [internal2 \ (VLAN 334)], [OT-Net], [10.34.255.254/16],
      [internal2 \ (VLAN 333)], [OT-DMZ], [192.168.33.254/24],
      table.cell(rowspan: 4, "Zellen Firewall"),
      [wan1], [Seperation Firewall], [172.16.10.5/30],
      [internal1], [SPS Zelle Eins], [10.79.84.2/30],
      [internal2], [SPS Zelle Zwei], [10.79.84.6/30],
      [internal3], [SPS Zelle Drei], [10.79.84.10/30],
    ),
    caption: [Die eingesetzten Firewalls und deren Verbindungen],
  )
)

#htl3r.author("Julian Burger")
== Physische Topologie <physische-topo>

Logisch betrachtet scheint die Topologie zunächst recht simpel, jedoch kommen mehrere abstraktions Ebenen zum Einsatz, um die #htl3r.short[it]-Infrastruktur einer Kläranlage zu emulieren. So kommen zum Beispiel #htl3r.shortpl[vlan] zum Einsatz, um die einzelnen Netzwerke zu separieren.

Physische Server- und Clientgeräte werden virtualisiert und mittels #htl3r.fullpl[dvs] mit #htl3r.short[vlan]-Tags versehen, um diese dann wiederrum zu einem physischen Switch zu enkapsuliert weiterzuleiten, welcher die #htl3r.shortpl[vlan] dann zu den physischen Firewalls, ebenfalls enkapsuliert, weiterleitet. Dies geschieht für ein jedes Netzwerk in der Kläranlagen-Topologie. Besondere Netzwerke wie ein Management, Storage und Internet werden ähnlich, jedoch etwas abgewandelt realisiert, siehe @conf_vsphere.

Durch die enkapsulierten Netzwerke ist es möglich, auf den Firewalls mit Sub-Interfaces zu arbeiten und anhand von diesen die notwendigen Policies zu realisieren. Die Absicherung der Kläranlagen-Topologie ist ein großer Teil dieser Diplomarbeit. Für mehr Informationen über die Absicherung siehe @firewall-config.

Die #htl3r.shortpl[vlan] werden ebenfalls mittels #htl3r.short[span] an ein #htl3r.short[ids] weitergeleitet, welches die Informationen verarbeitet und Alerts Rückmeldet, siehe @nozomi-guardian.

Um einen groben Überblick über den physischen Aufbau des Netzwerks zu bekommen, kann man sich an @fenrir_phys_topo orientieren. Es werden alle essentiellen Netzwerkkomponenten aufgeführt, für genauere Informationen siehe die vorherig aufgeführte Abschnitte und @aufbau-klaeranlage.

#htl3r.fspace(
  total-width: 100%,
  [
  #figure(
    image("../assets/fenrir_physical_topology.png"),
    caption: [Die Projekttopologie in physischer Darstellung]
  ) <fenrir_phys_topo>
  ]
)

Die Geräte der physischen Topologie sind -- mit Ausnahme der #htl3r.short[ot]-Gerätschaft -- in einem leicht transportierbarem Server-Rack untergebracht:

#htl3r.fspace(
  figure(
    image("../assets/rack.jpg", width: 52%),
    caption: [Das rollende Serverrack der Diplomarbeit "Fenrir"]
  )
)

=== Verwendete Geräte in der physischen Topologie

In der physischen Topologie kommen -- mit der Ausnahme der Aktorik und Sensorik der Modell-Kläranlage -- folgende Geräte zum Einsatz. Die logische Funktion dieser Geräte wird in späteren Abschnitten genauer erläutert.

#htl3r.fspace(
  total-width: 100%,
  [
    #figure(
    table(
      columns: (3fr, 5fr, 2fr),
      inset: 10pt,
      align: (horizon + left, horizon + center, horizon + left),
      table.header(
        [*Name*], [*Model*], [*Herstelller*],
      ),
      [ESXi 1], [Precision 5820 Tower X-Series], [DELL],
      [ESXi 2], [PRIMERGY TX1330 M1], [Fujitsu],
      [ESXi 3], [PRIMERGY TX1330 M1], [Fujitsu],
      [Shared-Storage], [PRIMERGY TX1330 M1], [Fujitsu],
      [Cluster Switch], [WS-C2960X-48TS-L], [Cisco],
      [Uplink Firewall], [FortiGate 60E], [Fortinet],
      [Separation Firewall], [FortiGate 92D], [Fortinet],
      [Rugged Firewall], [FortiGateRugged 60F], [Fortinet],
      [SPS Zelle Eins], [SIMATIC S7-1200], [Siemens],
      [SPS Zelle Zwei], [Raspberry Pi 4 2GB], [Raspberry Pi Foundation],
      [SPS Zelle Drei], [LOGO! 12/24V RCEo], [Siemens],
    ),
    caption: [Verwendete physische Hardware],
  )
  <physisch-geraete>
  ]
)

#htl3r.author("Julian Burger")
== Virtualisierungsplattform und Umgebung <virt_env>
Innerhalb der Diplomarbeit werden alle #htl3r.short[it]-Geräte virtualisiert. Dies bringt mehrere Vorteile mit sich; unter anderem schnelles und ressourcensparendes Deployment, da #htl3r.shortpl[vm] mit exakt den Ressourcen gestartet werden können, welche sie auch tatsächlich benötigen. Natürlich ist es ebenso von großer Wichtigkeit, dass die Virtualisierungsplattform gute Integrationen mit #htl3r.long[iac]-Tools bietet. Eine Plattform, welche diese Anforderungen erfüllt und ebenso leicht verwaltbar ist, ist VMware-ESXi. VMware bietet ebenso einen Clusteringdienst, namens vCenter, an. Dieser Dienst ermöglicht es, mehrere ESXi-Instanzen in ein logisches Datacenter zusammenzufassen. Somit können die #htl3r.shortpl[vm] auf einem geteiltem Speichermedium abgespeichert und beliebig von den ESXi-Instanzen gestartet werden.

#htl3r.fspace(
  [
  #figure(
    image("../assets/vcenter_logical.png"),
    caption: [Logischer Plan der vCenter Umgebung]
  ) <vcenter_logical>
  ]
)

Dies ermöglicht ebenso eine gewisse Ausfallsicherheit, da #htl3r.shortpl[vm] unabhängig von den ESXi-Instanzen sind und im Falle eines Ausfalls von einer Instanz auf eine andere übertragen werden können. Hier gibt es bei VMware Lösungen wie vMotion, welche Live-Migrationen durchführen kann. Im Rahmen dieser Diplomarbeit kommt dies jedoch nicht zum Einsatz; es wird lediglich #htl3r.long[drs] verwendet, um die #htl3r.shortpl[vm] auf die ESXi-Instanzen aufzuteilen.

=== vCenter Umgebung <vcenter_env>
Der vCenter-Dienst läuft als #htl3r.short[vm] auf ESXi 1 und kommuniziert mit den restlichen ESXi-Instanzen über ein Management-Netzwerk. Dieses Mangement-Netzwerk ist als #htl3r.short[vlan] realisiert. Die #htl3r.short[vlan]-ID des Netzwerks ist 120 und als Subnetz wird 10.40.20.0/24 verwendet. Da vCenter eine #htl3r.short[sso]-Domain erstellt, welche eine #htl3r.short[dns]-Domäne benötigt, existiert innerhalb des Management-Netzwerkes die #htl3r.short[dns]-Domain fenrir.local mit folgenden #htl3r.short[dns]-Einträgen:

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (2fr, 1fr, 1fr),
      inset: 10pt,
      align: (horizon + left, horizon + center, horizon + left),
      table.header(
        [*#htl3r.short[dns]-Name*], [*Adresse*], [*Gerät*],
      ),
      [vcenter.fenrir.local], [10.40.20.10], [vCenter #htl3r.short[vm]],
      [esxi1.fenrir.local], [10.40.20.11], [ESXi 1],
      [esxi2.fenrir.local], [10.40.20.12], [ESXi 2],
      [esxi3.fenrir.local], [10.40.20.13], [ESXi 3],
      [shared-storage.fenrir.local], [10.40.20.80], [Shared-Storage],
      [nozomi.fenrir.local], [10.40.20.100], [Nozomi Guardian],
      [cluster-switch.fenrir.local], [10.40.20.200], [Cluster Switch],
    ),
    caption: [Management-Netzwerk DNS-Einträge],
  )
)

Als #htl3r.short[dns]-Server fungiert die Uplink-Firewall, siehe @fenrir_phys_topo. Diese ermöglicht ebenso einen Internetzugang, welcher benötigt wird, um Software auf den #htl3r.shortpl[vm] herunterzuladen.

Wie bereits in @virt_env erwähnt wurde, existiert ebenso ein geteiltes Speichermedium, den Shared-Storage Server, welches von den ESXi-Instanzen, über das Netzwerk mittels #htl3r.full[nfs], erreichbar ist. Der #htl3r.short[nfs]-Zugriff geschieht über ein eigenes #htl3r.short[vlan], das Storage-#htl3r.short[vlan]. Dies hat den Grund, dass #htl3r.short[nfs]-Zugriffe eine sehr hohe Auslastung des Netzwerks, aufgrund von vielen Lese- und Schreibzugriffen, bedeuten. Um dieser Auslastung gerecht zu werden, ist der Storage-Server mit vier Gigabit-Ethernet Links an den Cluster Switch, siehe @vcenter_logical und @cluster_switch_conf, angeschlossen. Diese vier physischen Links wurden mittels #htl3r.short[lacp] zu einem logischen Link zusammengefasst. Die ESXi-Instanzen haben jeweils einen dedizierten Gigabit-Ethernet Link für #htl3r.short[nfs]-Zugriffe. So ist es möglich, mit akzeptabler Geschwindigkeit auf den Shared-Storage zuzugreifen.

=== Konfiguration des vCenters/vSphere <conf_vsphere>

Innerhalb des vCenters wurden einige Dienste und Strukturen konfiguriert, um das saubere Arbeiten von den #htl3r.short[iac]-Tools, siehe @provisionierung, zu ermöglichen. Diese inkludiert: VMkernel Adapter, einen Datastore, #htl3r.short[drs], #htl3r.shortpl[dvs], eine Content Library und eine Ordnerstruktur für die #htl3r.shortpl[vm].

==== Netzwerkkonnektivität des Clusters <vmkernel_config>

Damit sich die Hosts innerhalb des vCenter-Clusters verbinden können, braucht es dafür einen VMkernel Adapter, welcher den Managementzugriff ermöglicht und ebenso Teil von einer #htl3r.short[dpg] ist, welche diesen -- wie im Falle dieser Diplomarbeit -- mit einem #htl3r.short[vlan]-Tag verseht.

Es werden zwei VMkernel Adapter verwendet, welche über denselben physischen Adapter mit dem Netzwerk verbunden sind, da jeder Host nur ein Minimum von zwei Network-Interfaces besitzt. Eines dieser Interfaces ist für die Verwendung von Verwaltungstätigkeiten reserviert, während das andere für Verbindungen der #htl3r.shortpl[vm] in der Kläranlagen-Topologie verwendet wird. Die Verbindung von den VMkernel Adaptern zu dem Interface für die Verwaltung wird über einen #htl3r.short[dvs] geschaffen, welcher drei #htl3r.shortpl[dpg] hat:
- *ManagementPG*: Zuständig für die Web-Management Platformen der ESXi-Hosts, vCenter und vSphere. Tagged Frames mit #htl3r.short[vlan]-Nummer 120.
- *StoragePG*: Zuständig um auf den geteilten Datastore zuzugreifen, siehe @nfs_datastore. Tagged Frames mit #htl3r.short[vlan]-Nummer 80.
- *InternetPG*: Ermöglicht es #htl3r.shortpl[vm] mit dem Internet über ein abgekapseltes Netzwerk zu verbinden. Wird vorallem bei der Provisionierung der #htl3r.shortpl[vm] verwendet um Software herunterzuladen. Tagged Frames mit #htl3r.short[vlan]-Nummer 800. Hat keinen VMkernel Adapter mit sich assoziiert.

Die angesprochenen VMkernel Adapter existieren in identer Form auf allen ESXi-Hosts. VMkernel Adapter können verschiedene Dienste aktiviert haben, mit welchen es sich beeinflussen lässt, wie diese Dienste über das Netzwerk kommunizieren. Die VMkernel Adapter sind wiefolgt belegt:
- *vmk0*: Ist mit der _ManagementPG_ verbunden und hat den _Management_-Dienst aktiviert. Dies teilt vCenter/vSphere mit, dass sämtlicher Management-Traffic über diesen Adapter und somit über die _ManagementPG_ geschickt werden soll.
- *vmk1*: Ist mit der _StoragePG_ verbunden und hat den _vMotion_-Dienst aktiviert. vMotion ermöglicht es #htl3r.shortpl[vm], während diese gestartet sind, auf andere ESXi-Hosts zu migrieren mit minimalen Ausfällen.

Auch wenn vMotion nicht zwingend gebraucht wird, existiert der VMkernel Adapter aus Performance-Gründen, welche in @nfs_datastore beschrieben werden. Der andere VMkernel Adapter existiert aus Gründen der Segmentierung und somit auch der Sicherheit. Es ist möglich über einen #htl3r.short[vpn] in das Management-Netzwerk zu gelangen und somit den Provisionierungsvorgang einzuleiten, wie in @provisionierung beschrieben.

#htl3r.fspace(
  total-width: 75%,
  figure(
    image("../assets/vmkernel_adapter.png"),
    caption: [Screenshot der VMkernel Adapter aus vSphere]
  )
)

==== Konfiguration des NFS-Datastores <nfs_datastore>

Damit es allen ESXi-Hosts möglich ist, auf die gleichen Dateien, wie zum Beispiel #htl3r.shortpl[vm], #htl3r.short[vm]-Templates und ISOs, zuzugreifen, ist ein geteilter Datastore benötigt, welcher über das Netzwerk erreichbar ist. Die einfachste Lösung wäre ein vSAN (Virtual Storage Area Network), welches mehrere physische Festplatten über das Netzwerk zu einem Datastore zusammenfassen kann. Dies ist jedoch nur unter gewissen Hardwarekonfigurationen möglich und die Anforderungen sind zu hoch für den Rahmen der Diplomarbeit. Somit fiel die Wahl auf einen #htl3r.short[nfs]-Share, welcher von allen ESXi-Hosts über ein Storage-Netzwerk erreichbar ist. Dieses Storage-Netzwerk ist mittels #htl3r.short[vlan] realisiert und hat den #htl3r.short[vlan]-Tag 80. Damit alle ESXi-Hosts innerhalb des vCenters über dieses Netzwerk zugreifen, gibt es einen dedizierten VMkernel Adapter, siehe @vmkernel_config.

Der #htl3r.short[nfs]-Datastore hat insgesammt fünf physische Verbindungen mit dem Cluster Switch. Eine für das Management-#htl3r.short[vlan] 120 und vier weitere, welche mittels #htl3r.short[lacp] aggregiert sind und mit dem Storage-#htl3r.short[vlan] 80 verbunden sind. Es wurde ebenfalls die #htl3r.short[mtu]-Größe auf 9000 gestellt, um maximalen Durchsatz zu erzielen. Diese #htl3r.short[mtu]-Größe wurde ebenfalls auf dem VMkernel Adapter und dem #htl3r.short[dvs] konfiguriert.
So wird garantiert, dass alle ESXi-Hosts die volle Bandbreite ihrer Links -- ein Gigabit pro Sekunde -- nutzen können.

#htl3r.fspace(
  figure(
    image("../assets/datastore_connection.png"),
    caption: [Abstrakter überblick der NFS-Datastore-Anbindung]
  )
)

Die Einbindung des #htl3r.short[nfs]-Shares als Datastore erfolgt über vSphere, hierbei muss lediglich die #htl3r.short[ip]-Adresse, sowie Benutzername und Passwort des #htl3r.short[nfs]-Shares eingegeben werden. Die Konfiguration des #htl3r.short[nfs]-Shares ist simpel gehalten:

#htl3r.code(caption: "NFS-Share Export-Konfiguration", description: none)[
```
# /etc/exports: the access control list for filesystems which may be exported
#		to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#
/storage *(rw,fsid=0,sync,all_squash,no_subtree_check)
```
]

Das Dateisystem, welches auf `/storage` gemounted ist, ist ein #htl3r.short[lvm]. Dies hat den Vorteil, dass das Dateisystem jederzeit vergrößert werden und sogar auf mehreren physischen Festplatten verteilt liegen kann, ohne ein #htl3r.short[raid] zu verwenden.

==== Konfiguration von DRS und Resource-Pool

#htl3r.full[drs] ist eine Technologie von VMware, welche #htl3r.shortpl[vm] automatisch auf ESXi-Hosts -- welche dem selben Cluster zugewiesen sind -- load-balanced. Das heißt, dass #htl3r.shortpl[vm] automatisch auf alle ESXi-Hosts in einem Cluster verteilt werden, sodass alle ungefähr die gleiche CPU-, Arbeitspeicher- und Netzwerkauslastung haben. Im Rahmen dieser Diplomarbeit wird #htl3r.short[drs] verwendet, um #htl3r.longpl[vm] während des Provisioniervorgangs gleichmäßig auf die ESXi-Hosts zu verteilen.

Desweiteren besteht die Möglichkeit, ein Resource-Pool anzulegen. Einem Resource-Pool können gewisse Anteile der CPU und des Arbeitsspeichers zugewiesen werden, welche er nicht überschreiten kann. Ebenso können Resource-Pools gewisse Hardware-Resourcen für sich reservieren. Dies ermöglicht einem Nutzer mehrere Resource-Pools für unterschiedlichste Verwendungen anzulegen und gewisse Hardware-Anteile zu garantieren.

Dies wird im Rahmen dieser Diplomarbeit verwendet, um -- wie in @provisionierung beschrieben -- mittels #htl3r.short[drs] die #htl3r.shortpl[vm] auf alle ESXi-Hosts, welche dem Cluster angehören, zu verteilen. Der Resource-Pool hilft zu garantieren, dass die vCenter-#htl3r.short[vm], welche nicht Teil des Resource-Pools ist, immer genug Ressourcen hat um zu arbeiten.

vSphere erstellt im Hintergrund einen #htl3r.short[drs]-Score, welcher die Verteilung der #htl3r.longpl[vm] bewertet. Man bedenke, dass im Rahmen dieser Diplomarbeit sehr unterschiedliche Hardware für die ESXi-Hosts verwendet wurde und #htl3r.short[drs] daher nicht optimal funktioniert:

#htl3r.fspace(
  figure(
    image("../assets/drs_example.png"),
    caption: [Beispiel für eine DRS-Score bewertung]
  )
)
#pagebreak(weak: true)
#htl3r.short[drs] selbst wird vollautomatisch betrieben, es besteht jedoch die möglichkeit, dass #htl3r.short[drs] nur Vorschläge macht und dem Benutzer freie Wahl lässt diese umzusetzen. Die Konfiguration für #htl3r.short[drs] ist recht simpel, zunächst wählt man das Cluster aus welches konfiguriert werden soll, danach sind die Einstellungen unter #htl3r.breadcrumbs(("Configure", "Services", "vSphere DRS", "Edit...")) zu finden:

#htl3r.fspace(
  figure(
    image("../assets/drs_settings.png"),
    caption: [Konfiguration von vSphere DRS]
  )
)

Unter #htl3r.breadcrumbs(("Monitor", "vSphere DRS", "Recommendations")) ist es nun möglich, die Vorschläge von #htl3r.short[drs] einzusehen und umzusetzen. Wird `Fully Automated` unter `Automation Level` eingestellt, so gibt es keine Vorschläge.

==== Content Library und Ordnerstruktur von VMs und DVS

Eine Content Library in VMware vSphere ist ein zentraler Ort, um #htl3r.short[vm]-Templates und andere Dateien abzulegen. #htl3r.short[vm]-Templates welche in einer Content Library liegen sind versioniert und können nach Belieben aktualisiert werden. Hierzu gibt es eine "Check-Out" und "Check-In" funktion, mit welcher #htl3r.short[vm]-Templates zu normalen #htl3r.shortpl[vm] konvertiert werden, Änderungen getätigt werden können und letzendlich diese wieder zu #htl3r.short[vm]-Templates zurückkonvertiert werden können. Solch ein Vorgang ist besonders nützlich für _Golden Image Pipelines_. Im Rahmen dieser Diplomarbeit wird eine Art von #htl3r.full[gip] verwendet. Diese ist zwar nicht optimal, allerdings passend für den Anwendungszweck innerhalb des Projektes.

Content Libraries unterscheiden zwischen zwei Arten von #htl3r.short[vm]-Templates. Zunächst gibt es _OVF/OVA Templates_, welche einfach nur Dateien auf einem Datastore sind und Metadaten und Disks beinhalten. Diese stehen in Kontrast zu normalen #htl3r.short[vm]-Templates, welche ebenso im vSphere-Inventar registriert sein müssen. Normale #htl3r.short[vm]-Templates werden über OVF/OVA-Templates bevorzugt, da der Erstellungsprozess wesentlich kürzer ist und Linked-Clones möglich sind.

Im Rahmen dieser Diplomarbeit werden alle verwendeten #htl3r.short[vm]-Templates mittels Packer erstellt, für genauere Informationen siehe @provisionierung, mit Ausnahme von der #htl3r.short[ot]-Workstation-Template. Diese benötigt spezielle Software für die Programmierung und Verwaltung von #htl3r.shortpl[sps] und kann nur schwer automatisiert aufgesetzt werden.

Wie bereits angesprochen müssen normale #htl3r.short[vm]-Templates, welche in einer Content Library liegen, ebenso im vSphere-Inventar registriert sein. Dies geschieht innerhalb des Projektes mithilfe eines Ordners namens "Templates":

#htl3r.fspace(
  total-width: 80%,
  // figure(
  //   image("../assets/templates_inventory.png"),
  //   caption: [Templates im Inventar]
  // ),
  figure(
    image("../assets/content_library.png"),
    caption: [Inhalt der Content Library]
  )
)

Die eigentlichen #htl3r.shortpl[vm] sind tatsächlich in einem Ordner namens "Topology VMs", welcher mehrere Unterordner für die verwendeten Netzwerke besitzt. Einzig und allein die Bastion, siehe @prov-mit-bastion, liegt direkt innerhalb des "Topology VMs" Ordners.

Ein ähnliches Konzept existiert auch bei den vSwitches. Hier liegt der "ManagementDVS" ohne Ordner direkt auf der Datacenter-Node gemeinsam mit den Standard-vSwitches, während der "FenrirDVS", welcher die #htl3r.shortpl[dpg] beinhaltet, welche verwendet werden, um #htl3r.shortpl[vm] mit einem #htl3r.short[vlan] zu versehen, in einem Ordner namens "Topology Networks" liegt.

#htl3r.author("David Koch")
== OT-Bereich

Der #htl3r.short[ot]-Bereich besteht aus einem von uns selbst gebauten Modell einer Kläranlage. Diese setzt sich aus einer archimedischen Schraube, einem Rechen, Wassertanks, Filtern, Sensoren, einem Staudamm und Pumpen zusammen. Diese Gegenstände sind mit verbauter Aktorik und/oder Sensorik ausgestattet und dienen als Ansteuerungsziele mehrerer #htl3r.shortpl[sps]. Diese werden nach Aufbau auch als Angriffsziele verwendet, wobei ein Angreifer beispielsweise die Pumpen komplett lahmlegen oder durch deren Manipulation einen Wasserschaden verursachen kann.

Für die Details bezüglich des Aufbaus der Modell-Kläranlage und der dazugehörigen #htl3r.short[ot]-Gerätschaft siehe @aufbau-klaeranlage.

#pagebreak(weak: true)
== Verknüpfung der physischen & virtuellen Netzwerke

Um die physisch vorhandenen und virtualisierten Bestandteile der gesamten Topologie miteinander zu verknüpfen, braucht es gleich mehrere zusammenarbeitende Konzepte:

=== Modbus TCP als Kommunikationsprotokoll

Neben Profinet, EtherCat und co. hat sich dieses Protokoll für die industrielle Kommunikation über Ethernet-Leitungen etabliert. @ethernet-bus-protocols-comp[comp]

Modbus #htl3r.short[tcp] wird innerhalb dieser Diplomarbeit als Ethernet-fähiges Bus-Protokoll genutzt, um die #htl3r.shortpl[sps] der Modell-Kläranlage mit dem virtualisierten #htl3r.short[it]-Netzwerk über herkömmliche Ethernet-Leitungen zu verknüpfen.

Die Einführung dieses offenen Protokolls bedeutete auch gleichzeitig den Einzug der auf Ethernet gestützten Kommunikation in der Automationstechnik, da hierdurch zahlreiche Vorteile für die Entwickler und Anwender erschlossen wurden. So wird durch den Zusammenschluss von Ethernet mit dem allgegenwärtigen Netzwerkstandard von Modbus #htl3r.short[tcp] und einer auf Modbus basierenden Datendarstellung ein offenes System geschaffen, das dies Dank der Möglichkeit des Austausches von Prozessdaten auch wirklich frei zugänglich macht. Zudem wird die Vormachtstellung dieses Protokolls auch durch die Möglichkeit gefördert, dass sich Geräte, die fähig sind den #htl3r.short[tcp]/IP-Standard zu unterstützen, implementieren lassen. Modbus #htl3r.short[tcp] definiert die am weitesten entwickelte Ausführung des offenen, herstellerneutralen Protokolls und sorgt somit für eine schnelle und effektive Kommunikation innerhalb der Teilnehmer einer Netzwerktopologie, die flexibel ablaufen kann. Zudem ist dieses Protokoll auch das einzige der industriellen Kommunikation, welches einen "Well known port", den Port 502, nützt und somit auch routingfähig ist. Somit können die Geräte eines Systems auch über per Fernzugriff gesteuert werden, was aber gleichzeitig viele Gefahren mit sich bringt. @modbustcp_intro[comp]
// obiger absatz pure kopiererei von svon und somit aus undokumentierten quellen und so grrrr

Schneider Automation hat der Internetstandardisierungs-Organisation #htl3r.short[ietf] darum gebeten, Modbus auf einem #htl3r.short[tcp]/#htl3r.short[ip]-Übertragungsmedium zu übertragen @modbus-ietf[comp]. Dabei wurde das Modbus-Modell und der #htl3r.short[tcp]/#htl3r.short[ip]-Stack nicht verändert, da nur eine Enkapsulierung von Modbus in #htl3r.short[tcp]-Packets stattfindet @modbus-ietf[comp]. Seit diesem Zeitpunkt wurde Modbus zu einem Überbegriff und besteht nun aus:

#[
#set par(hanging-indent: 12pt)
- *Modbus #htl3r.short[rtu]:* Asynchrone Master/Slave-Kommunikation über RS-485, RS-422 oder RS-232 Serial-Leitungen @modbus-comp[comp].
- *Modbus #htl3r.short[tcp]:* Ethernet bzw. #htl3r.short[tcp]/#htl3r.short[ip] basierte Client-Server Kommunikation @modbus-comp[comp].
- *Modbus Plus:* Bietet eine Peer-to-Peer-Kommunikation über Serial-Leitungen. Ist hauptsächlich für stark vernetzte "Token-Passing" Netzwerke gedacht @modbus-plus-extra[comp].
]

Als Unterschied zwischen Modbus #htl3r.short[rtu] und Modbus #htl3r.short[tcp] zeigt sich am Meisten die Redundanz bzw. Fehlerüberprüfung der Datenübertragung und die Adressierung der Slaves @modbus-ietf[comp].

Modbus #htl3r.short[rtu] sendet zusätzlich zu Daten und Befehlscode eine #htl3r.short[crc]-Prüfsumme und die Slave-Adresse. Bei Modbus #htl3r.short[tcp] werden diese innerhalb des Payloads nicht mitgeschickt, da bei #htl3r.short[tcp] die Adressierung bereits im #htl3r.short[tcp]/#htl3r.short[ip]-Wrapping vorhanden ist (Destination Address) und die Redundanzfunktionen durch die #htl3r.short[tcp]/#htl3r.short[ip]-Konzepte wie eigenen Prüfsummen, Acknowledgements und Retransmissions @tcpip-fortinet-doc[comp].

Bei der Enkapsulierung von Modbus in #htl3r.short[tcp] werden nicht nur der Befehlscode und die zugehörigen Daten einfach als Payload verschickt, sondern auch ein MBAP (Modbus Application Header), welcher dem Server Möglichkeiten wie die eindeutige Interpretation der empfangenen Modbus-Parameter sowie Befehle bietet @modbus-ietf[comp].
#htl3r.fspace(
  figure(
    image("../assets/modbus_encap_copy.svg"),
    caption: [Visualisierung des Modbus TCP Headers @modbus-tcp-encap]
  )
)

Um den Unterschied zwischen Modbus #htl3r.short[rtu] und der Enkapsulierung der #htl3r.short[pdu] in Modbus #htl3r.short[tcp] besser zu visualisieren, kann z.B. folgender Modbus #htl3r.short[rtu] Frame genutzt werden: \ *`11 03 006B 0003 7687`*

Dieser Frame ist dafür konzipiert, die drei analogen "Holding"-Register im Adressbereich 40108 bis 40110 des Slave-Geräts mit der ID 17 auszulesen.

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (0.3fr, 1fr, 1fr),
      inset: 10pt,
      align: (horizon + left, horizon + center, horizon + left),
      table.header(
        [*Daten*], [*Parameter*], [*Beschreibung*],
      ),
      [*`11`*], [Slave ID], [Die Adresse des Slave-Geräts (17 = 11 hex)],
      [*`03`*], [Function Code], [Funktionscode für das Auslesen eines analogen "Holding"-Registers],
      [*`006B`*], table.cell(rowspan: 2, "Data"), [Kennzeichnet die Adresse des ersten auszulesenden Registers (40108-40001 = 107 = 6B hex)],
      [*`0003`*], [Die Anzahl der zu lesenden Register (3 Register, d.h. Adressen 40108 bis 40110)],
      [*`7687`*], [#htl3r.short[crc]], [#htl3r.short[crc]-Prüfsumme],
    ),
    caption: [Details des beispielhaften Modbus RTU Frames],
  )
)

Wenn dieser Frame nun als Teil von Modbus #htl3r.short[tcp] enkapsuliert werden soll, ändert sich seine Datenstruktur auf die folgende: \ *`0001 0000 0006 11 03 006B 0003`*

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (0.3fr, 1fr, 1fr),
      inset: 10pt,
      align: (horizon + left, horizon + center, horizon + left),
      table.header(
        [*Daten*], [*Parameter*], [*Beschreibung*],
      ),
      [*`0001`*], [Transaction identifier], [Dient zur Identifizierung der Übertragungsreinfolge bei mehreren Transaktionen],
      [*`0000`*], [Protocol identifier], [Der "protocol identifier" für Modbus #htl3r.short[tcp] ist immer 0],
      [*`0006`*], [Length], [Die Länge der restlichen #htl3r.short[pdu] in Bytes (Slave ID bis Data, insgesamt 6 Bytes)],
      [*`11`*], [Slave ID], [Die Adresse des Slave-Geräts (17 = 11 hex)],
      [*`03`*], [Function Code], [Funktionscode für das Auslesen eines analogen "Holding"-Registers],
      [*`006B`*], table.cell(rowspan: 2, "Data"), [Kennzeichnet die Adresse des ersten auszulesenden Registers (40108-40001 = 107 = 6B hex)],
      [*`0003`*], [Die Anzahl der zu lesenden Register (3 Register, d.h. Adressen 40108 bis 40110)],
    ),
    caption: [Details der beispielhaften Modbus TCP PDU],
  )
)

Es darf bei der Enkapsulierung nicht vergessen werden, dass die #htl3r.short[pdu] lediglich das Datenfeld des gesamten #htl3r.short[tcp]/#htl3r.short[ip]-Packets belegt. Durch diese Enkapsulierung in #htl3r.short[tcp] verliert die ursprünglich Serielle-Kommunikation des Modbus-Protokolls ca. 40\% seiner ursprünglichen Daten-Durchsatzes. Jedoch wird dieser Verlust durch die zuvor erwähnten -- von #htl3r.short[tcp] mitgebrachten -- Vorteile ausgeglichen. Nach der Enkapsulierung können im Idealfall 3,6 Mio. 16-bit-Registerwerte pro Sekunde in einem 100Mbit/s switched Ethernet-Netzwerk übertragen werden, und da diese Werte im Regelfall bei Weitem nicht erreicht werden, stellt der partielle Verlust an Daten-Durchsatz kein Problem dar.

#htl3r.author("Julian Burger")
=== Cluster Switch Konfiguration <cluster_switch_conf>

Die gesamte physische Topologie, wie in @physische-topo beschrieben, wird mit einem einzigen Switch verbunden: dem Cluster Switch. Dies ist ein Cisco-Catalyst welcher Gigabit-Ethernet fähig ist, ein Feature welches unabdingbar ist um den Shared-Storage mit akzeptabler Bandbreite anzubinden. Der Switch selbst hat mittels einem #htl3r.full[svi] eine #htl3r.short[ip]-Adresse im Management-Netzwerk über welche er mit Telnet konfigurierbar ist. Es wurde Telnet über #htl3r.short[ssh] gewählt, da die kryptografischen Fähigkeiten des Switches, aufgrund des Alters, zu wünschen übrig lassen.

==== Interfacekonfiguration

Auf dem Cluster Switch wurden vorallem #htl3r.shortpl[vlan] und #htl3r.short[span]-Session konfiguriert. Letztere senden den gesammten Traffic der Kläranlagen-Topologie an ein #htl3r.short[ids], siehe @nozomi-guardian. Die #htl3r.shortpl[vlan] segmentieren die einzelnen Netzwerke der Topologie und werden ebenso für Management, Network Storage und Internet-Zugriff verwendet.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/ClusterSwitch.png"),
    caption: [Interface Konfiguration des Cluster Switches]
  )
)

Das Konzept hinter der Interface aufteilung ist, dass jeweils zwölf Interfaces zu einem Block gruppiert werden. Interfaces eines Blocks haben einen gemeinsamen Zweck und praktisch, bis auf ein paar ausnahmen, die gleiche Konfiguration. Das letzte Interface pro Block ist jeweils eine #htl3r.short[span]-Session zum #htl3r.short[ids]. Die #htl3r.short[span]-Session pro Block überliefert jeweils immer den Traffic aller #htl3r.shortpl[vlan] innerhalb des Blocks, mit ausnahme des Storage-#htl3r.shortpl[vlan], welches, aufgrund der hohen Auslastung, das #htl3r.short[ids] verlangsamen würde. Die Daten, welche über das Storage-#htl3r.short[vlan] geschickt werden, sind von geringer Interesse. Demnach ist das letzte Interface des Switches nicht aktiv in Verwendung, sonder nur reserviert. Die Interface-Gerätezuordnung ist in @int_table beschrieben.

#figure(
  caption: [Cluster Switch Interface verkabelung],
  table(
    columns: (auto, 1fr, auto),
    align: (horizon + left, horizon + left, horizon + left),
    table.header(
      [*Interface am Switch*], [*Gerät*], [*Interface am Gerät*]
    ),
    [GigabitEthernet1/0/1], [Uplink-Firewall], [internal1],
    [GigabitEthernet1/0/2], [Separation-Firewall], [internal1],
    [GigabitEthernet1/0/13], [Shared-Storage], [mgmt (ens0)],
    [GigabitEthernet1/0/15], [ESXi 1], [vmnic0],
    [GigabitEthernet1/0/17], [ESXi 2], [vmnic0],
    [GigabitEthernet1/0/19], [ESXi 3], [vmnic0],
    [GigabitEthernet1/0/23], [Nozomi Guardian], [mgmt],
    [GigabitEthernet1/0/24], [Nozomi Guardian], [port1],
    [GigabitEthernet1/0/25], [ESXi 1], [vmnic1],
    [GigabitEthernet1/0/27], [ESXi 2], [vmnic1],
    [GigabitEthernet1/0/29], [ESXi 3], [vmnic1],
    [GigabitEthernet1/0/36], [Nozomi Guardian], [port2],
    [GigabitEthernet1/0/37], [Shared-Storage], [storage-bond (ens1f0)],
    [GigabitEthernet1/0/38], [Shared-Storage], [storage-bond (ens1f1)],
    [GigabitEthernet1/0/39], [Shared-Storage], [storage-bond (ens1f2)],
    [GigabitEthernet1/0/40], [Shared-Storage], [storage-bond (ens1f3)],
  )
) <int_table>

Das Storage-#htl3r.short[vlan] ist dafür zuständig, alle ESXi-Hosts der physischen Topologie, siehe @physische-topo, an einen #htl3r.short[nfs]-Share anzubinden. Der Server welcher diesen #htl3r.short[nfs]-Share hosted, ist mit vier Links an den Switch angebunden und es wird #htl3r.short[lacp], zur Lastaufteilung zwischen diesen, verwendet. Ebenso ist die #htl3r.short[mtu]-Größe auf dem switch auf 9000 gestellt, um maximalen Durchsatz zu erzielen.

#htl3r.code(caption: [Storage Channel-Group des Cluster Switches], description: [Storage LACP])[
```
system mtu jumbo 9000

interface range gig 1/0/37 - 40
  channel-group 1 mode active
  no shutdown

interface port-channel 1
  switchport mode access
  switchport access vlan 80
  no shutdown
```
]

==== SPAN-Sessions des Cluster Switches

Die Konfiguration der #htl3r.short[span]-Sessions ist simpel und leicht verständlich. Die #htl3r.shortpl[vlan] der Kläranlagen-Topologie erstrecken sich von 330 bis 336, mit der Ausnahme von 335, welches unbelegt ist. Historisch war gedacht, dass das #htl3r.short[ids], siehe @nozomi-guardian, als #htl3r.short[vm] realisiert wird und daher ebenfalls ein extra #htl3r.short[vlan] für die Managementoberfläche benötigt. Da nun eine Hardware-Appliance verwendet wird, wird dieses nicht mehr benötigt.

#htl3r.code(caption: [SPAN-Sessions des Cluster Switches], description: [SPAN-Session Konfiguration])[
```
default interface gig 1/0/24
default interface gig 1/0/36
no monitor session 1
monitor session 1 source vlan 120 , 800 both
monitor session 1 destination interface gig 1/0/24 encapsulation replicate ingress dot1q vlan 1
no monitor session 2
monitor session 2 source vlan 330 - 334 , 336 both
monitor session 2 destination interface gig 1/0/36 encapsulation replicate ingress dot1q vlan 1
```
]

Es ist bei der Konfiguration von #htl3r.short[span]-Session 2 zu sehen, dass #htl3r.short[vlan] 335 bei den Quell-#htl3r.shortpl[vlan] ausgelassen wird. Ebenso wird bei #htl3r.short[span]-Session 1 #htl3r.short[vlan] 80 ausgelassen, welches das Storage-#htl3r.short[vlan] ist.
