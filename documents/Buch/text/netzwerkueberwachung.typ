#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("Bastian Uhlig")
= Netzwerküberwachung <netzwerkueberwachung>
Ein wichtiger Teil der Sicherheit in einem Netzwerk ist die Überwachung dessen. Damit können die Zuverlässigkeit und der derzeitige Zustand sofort erkannt werden. Es ist nämlich niemals möglich, sämtliche Angriffe abzuwehren, bevor sie überhaupt stattfinden. Wenn ein Netzwerk jedoch mit modernen Mitteln überwacht wird, können Angriffe, die bereits in vollem Gange sind, entdeckt und (in weiterer Folge) unterbunden werden.

Hierbei ist der Begriff einer "Baseline" wichtig. Eine Baseline beschreibt einen Status des Netzwerks, in welchem dieses im Normalzustand agiert.

Falls in dem Netzwerk nun Besonderheiten aufkommen, sei dies ein neuer Kommunikationsteilnehmer oder ein bereits existierendes Gerät, so wird dies unter besondere Beobachtung gesetzt oder sogar sofort Alarm geschlagen.

== Theoretische Netzwerküberwachung

In der Theorie ist die Überwachung eines Netzwerks einfach. Es wird einfach der gesamte Datenverkehr aufgezeichnet und analysiert. Sollte jetzt ein unerwünschtes Paket auftreten, wird ein Alarm ausgelöst. Dieses Paket kann dann analysiert werden, um herauszufinden, was es genau ist und woher es kommt.

Praktisch ist eine 100-prozentige Überwachung jedoch im Echtbetrieb nicht möglich. Es gibt einfach zu viele Daten, die über ein Netzwerk laufen. Es ist jedoch möglich, mittels verschiedener Tools den Datenverkehr zu analysieren und Alarme auszulösen, sollte unerwünschter Datenverkehr auftreten.

== Eingesetzte Netzwerküberwachungstools
Tools zur Überwachung von Netzwerken gibt es tausende. Von dem selbst entwickeltem Packet Sniffer bis zu einem #htl3r.short[ids] auf Enterprise Level. Dabei gibt es kein Tool, welches "das richtige" ist.

=== Wireshark
Wireshark ist ein Packet-Sniffer. Das heißt, es liest einfach allen Datenverkehr, der auf einem gewissen Interface eines Computers läuft, und gibt diesen aus. Es gibt auch eine Version von Wireshark für die Kommandozeile, diese heißt "tshark".

Zur Benutzung von Wireshark muss nur das Interface angegeben werden, auf welchem der Datenverkehr mitgelesen werden soll. Sobald dies geschehen ist, wird jedes Paket, das gelesen wird, in einer Tabelle nach der Zeit geordnet dargestellt.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/wireshark_tabelle_beispiel.png"),
    caption: [Aufgezeichnete Kommunikation zwischen TIA-Portal v16 und der S7-1200 in Wireshark]
  )
)

Mit einem Doppelklick können über jedes Paket genauere Informationen angezeigt werden, sei dies von protokollspezifischen Daten bis hin zur reinen Hexadezimaldarstellung.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/wireshark_protocol_details.png"),
    caption: [Detailanzeige über Paketinformationen in Wireshark]
  )
)

#htl3r.fspace(
  figure(
    image("../assets/wireshark_hex_tcp.png"),
    caption: [Hexadezimaldarstellung eines Pakets in Wireshark]
  )
)

In großen Systemen wird eine Überwachung mittels Wireshark schnell unübersichtlich. Zwar kann der Anzeigebereich mit Filtern eingeschränkt werden, jedoch ist es schwer, unerwünschten Datenverkehr zu erkennen, weshalb Wireshark nur als stichprobenartiges Überwachungssystem verwendet werden sollte. Beispielsweise können Netzwerkadministratoren mittels Wireshark Netzwerktraffic auf einem Gerät aufzeichnen, auf welchem eine Kompromittierung vermutet wird. Diese Aufzeichnung kann dann analysiert werden, um die Ursache der Kompromittierung zu finden und dagegen vorzugehen.

In Live-Systemen ist die Verwendung von Wireshark als Überwachungssystem somit nur sinnvoll, um stichprobenartig Pakete zu untersuchen und diese zu überprüfen. Es kann beispielsweise ein Hardware-Network-Tap eingesetzt werden, um den Datenfluss zwischen zwei Geräten an eine neue Schnittstelle zu spiegeln und anschließend diese mittels Wireshark auszuwerten.

#htl3r.fspace(
  figure(
    image("../assets/physical_network_tap.jpg", width: 95%),
    caption: [Der eingesetzte Hardware-Network-Tap, ein Gigamon G-TAP-ATX]
  )
)

#htl3r.author("Gabriel Vogler")
=== Grafana Monitoring
Grafana ist ein mächtiges Open-Source-Tool zur Visualisierung von Daten. Es kann Daten aus verschiedensten Quellen, wie beispielsweise Prometheus, InfluxDB oder MySQL, visualisieren. Es wurde in Verbindung mit Prometheus eingesetzt, um die #htl3r.longpl[dc] zu überwachen.

==== Installation des Prometheus & Grafana Monitoring-Systems
Die Installation von Prometheus und Grafana erfolgt auf einem Ubuntu-22.04-Server mittels Docker.
Da Docker bereits in @provisionierung installiert wurde, kann die Installation von Prometheus und Grafana direkt erfolgen. Die ganze Installation erfolgt mittels einem Shell-Skript, damit das in @provisionierung umgesetzte Automatisierungskonzept weitergeführt wird.

Im ersten Schritt werden Netzwerk und Hostname für den Server konfiguriert. Für die Netzwerkkonfiguration wird Netplan verwendet, um die #htl3r.short[ip]-Adresse des Servers zu setzen. Es gibt dabei zwei Netzwerkadapter, wobei der erste für das Management-Netzwerk und der zweite für das SEC Netzwerk verwendet wird. Wichtig zu beachten sind die Einstellungen die auf dem Netzwerkinterface des Managementnetzwerks getroffen werden. Diese werden benötigt um die in @provisionierung beschriebene Provisionierung zu ermöglichen.
#htl3r.code-file(
  caption: "Netwerk- und Hostname-Konfiguration von Grafana",
  filename: [/terraform/stage_06/scripts/grafana.sh],
  ranges: ((7, 32),),
  lang: "bash",
  text: read("../assets/scripts/grafana.sh")
)

Im Anschluss wird das notwendige docker-compose File erstellt, welches die Konfiguration für Prometheus und Grafana beinhaltet. In diesem File wird die Version von Prometheus und Grafana festgelegt, sowie die Ports für die Web-Oberflächen definiert. Jegliche konfigurationen für die beiden Tools werden im Verzeichnis `/grafana-prometheus` abgelegt, welches zuvor erstellt wurde.

#htl3r.code-file(
  caption: "Docker-Compose-File für Prometheus und Grafana",
  filename: [/terraform/stage_06/scripts/grafana.sh],
  ranges: ((34, 70),),
  lang: "bash",
  text: read("../assets/scripts/grafana.sh")
)

==== Automatisches Einspielen von Dashboards in Grafana
Damit die Installation voll automatisiert erfolgen kann, werden die Dashboards in Grafana automatisch importiert. Dafür wird eine Konfigurationsdatei erstellt, welche die Dashboards in Grafana importiert. Diese Konfigurationsdatei wird in das Verzeichnis `/grafana-prometheus/provisioning/dashboards` abgelegt.
Damit das Dashboard vollständig importiert werden kann, muss außerdem eine Datenquelle für das Dashboard definiert werden. Diese wird in das Verzeichnis `/grafana-prometheus/provisioning/datasources` abgelegt.

#htl3r.code-file(
  caption: "Konfigurationsdateien erstellen für das Importieren von Dashboards in Grafana",
  filename: [/terraform/stage_06/scripts/grafana.sh],
  ranges: ((72, 97),),
  lang: "bash",
  text: read("../assets/scripts/grafana.sh")
)

Jetzt werden alle Dashboards, die in das Verzeichnis `/grafana-prometheus/dashboards` abgelegt wurden, automatisch in Grafana importiert. Die Datenquelle für die Dashboards wird ebenfalls automatisch erstellt.

==== Konfiguration von Prometheus
Die `prometheus.yml` Konfigurationsdatei wird in `/grafana-prometheus` erstellt, um Prometheus zu konfigurieren, damit es die Daten von den #htl3r.long[dc]n sammeln kann. Diese Konfigurationsdatei wird in das Verzeichnis `/grafana-prometheus` abgelegt und über das Docker-Compose-File eingebunden.

#htl3r.code-file(
  caption: "Konfigurationsdatei für Prometheus",
  filename: [/terraform/stage_06/scripts/grafana.sh],
  ranges: ((99, 112),),
  lang: "bash",
  text: read("../assets/scripts/grafana.sh")
)

==== Installieren des Node Exporters auf den Domain Controllern
Der Node Exporter wird auf den #htl3r.longpl[dc]n installiert, um die Metriken der #htl3r.longpl[dc] an Prometheus zu senden. Dafür wird mit einem Powershell-Skript zunächst der Node Exporter heruntergeladen und anschließend installiert. Zusätzlich muss eine Firewall-Regel erstellt werden, um den Zugriff auf den Node Exporter zu ermöglichen.

#htl3r.code-file(
  caption: "Powershell-Skript zum Installieren des Node Exporters auf den Domain Controllern",
  filename: [/terraform/stage_03/scripts/extra/DC1_part_4.ps1],
  ranges: ((1, 22),),
  lang: "powershell",
  text: read("../assets/scripts/Grafana_Windows_Exporter.ps1")
)

==== Dashboard für die Überwachung der Domain Controller
Das Dashboard für die Überwachung der #htl3r.longpl[dc] wird in Grafana importiert. Es zeigt die wichtigsten Metriken der #htl3r.longpl[dc] an, wie beispielsweise die CPU-Auslastung, den Arbeitsspeicher und die Netzwerkauslastung. Das Dashboard basiert auf dem "Windows Exporter Dashboard"#footnote[#link("https://grafana.com/grafana/dashboards/14694-windows-exporter-dashboard/")], welches von Grafana Labs installiert werden kann. Es wurden jedoch einige Anpassungen vorgenommen, um eine bessere Übersicht über die wichtigsten Werte zu erhalten. Da Zeit im Active Directory eine wichtige Rolle spielt, vorallem bei der Replikation der #htl3r.longpl[dc], wurde auch eine Anzeige für die aktuelle Zeit, sowie die Zeitzone auf den #htl3r.longpl[dc]n hinzugefügt. In der linken oberen Ecke des Dashboards, kann man zwischen den einzelnen #htl3r.longpl[dc]n wechseln, um die Werte der einzelnen Server anzuzeigen.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/Grafana_Monitoring_Dashboard.png"),
    caption: [Dashboard für die Überwachung der Domain Controller in Grafana]
  )
)
