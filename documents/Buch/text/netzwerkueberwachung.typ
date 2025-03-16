#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author("Bastian Uhlig")
= Netzwerküberwachung <netzwerkueberwachung>
#htl3r.info[Hier MUSS text hin]

== Theoretische Netzwerküberwachung
Ein wichtiger Teil der Sicherheit in einem Netzwerk ist die Überwachung dessen. Damit können  die Zuverlässigkeit und der derzeitige Zustand sofort erkannt werden. Es ist nämlich niemals möglich, sämtliche Angriffe abzuwehren, bevor sie überhaupt stattfinden. Wenn ein Netzwerk jedoch mit modernen Mitteln überwacht wird, können Angriffe, die bereits in vollem Gange sind, entdeckt und (in weiterer Folge) unterbunden werden.

Hierbei ist der Begriff einer Baseline wichtig. Eine Baseline beschreibt einen Status des Netzwerks, in welchem dieses im Normalzustand agiert.

Falls in dem Netzwerk nun Besonderheiten aufkommen, sei dies ein neuer Kommunikationsteilnehmer oder ein bereits existierendes Gerät, so wird dies unter besondere Beobachtung gesetzt oder sogar sofort Alarm geschlagen.

== Eingesetzte Netzwerküberwachungstools
Tools zur Überwachung von Netzwerken gibt es tausende. Von dem selbst entwickeltem Packet Sniffer bis zu einem #htl3r.short[ids] auf Enterprise Level. Dabei gibt es kein Tool, welches "das Richtige" ist.

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
    caption: [WIP]
  )
)

#htl3r.fspace(
  figure(
    image("../assets/wireshark_hex_tcp.png"),
    caption: [WIP]
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
