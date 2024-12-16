#import "@local/htl3r-da:0.1.0" as htl3r

= Netzwerküberwachung
#htl3r.author("Bastian Uhlig")

== Theoretische Netzwerküberwachung
Ein wichtiger Teil der Sicherheit in einem Netzwerk ist die Überwachung dieses. Es ist nämlich niemals möglich, einhundertprozentig alle Angriffe abzuwehren bevor sie überhaupt stattfinden. Wenn ein Netzwerk jedoch mit modernden Mitteln überwacht wird, so können Angriffe, die bereits in vollem Gange sind, entdeckt werden und in weiterer Folge unterbunden werden. 

Hierbei ist der Begriff einer Baseline wichtig. Eine Baseline beschreibt einen Status des Netzwerkes, in welchem dieses im Normalzustand agiert. 

Falls in dem Netzwerk nun Besonderheiten aufkommen, sei dies ein neuer Kommunikationsteilnehmer oder ein bereits existierendes Gerät, so wird dies unter besondere Beobachtung gesetzt oder sogar sofort Alarm geschlagen.

=== Tools
Tools zur Überwachung von Netzwerken gibt es tausende. Von dem selbstentwickeltem Packet Sniffer bis zu einem #htl3r.abbr[IDS] auf Enterprise Level. Dabei gibt es kein Tool, welches "das Richtige" ist. 

==== Wireshark
Wireshark ist ein Packet Sniffer. Das heißt, es liest einfach allen Traffic der auf einem gewissen Interface eines Computers läuft und gibt diesen aus. Es gibt auch einer Version von Wireshark für die Kommandozeile, diese heißt dann tshark. 

Zur Benutzung von Wireshark muss nur das Interface angegeben werden, auf welchem der Traffic mitgelesen werden soll. Sobald dies geschehen ist, wird auch schon jedes Paket, das gelesen wird, in einer Tabelle nach der Zeit geordnet dargestellt. Mit einem Doppelklick können über jedes Paket genauere Informationen angezeigt werden, sei dies von protokollspezifischen Daten bis hin zur reinen Hexadezimaldarstellung.
In großen System wird eine Überwachung mittels Wireshark schnell unübersichtlich. Zwar kann mit Filtern der Anzeigebereich eingeschränkt werden, jedoch ist es schwer unerwünschten Traffic zu erkennen.

In live-Systemen ist die Verwendung von Wireshark als Überwachungssystem nur sinnvoll, um stichprobenartig Pakete zu untersuchen, und diese zu überprüfen. 

=== Nozomi Guardian
Die Nozomi Guardian ist ein #htl3r.abbr[IDS]. Wie auch Wireshark ließt sie allen Traffic auf einem Interface aus und verwendet diesen, jedoch kann die Guardian diesem Traffic automatisch verwerten. Sie erstellt automatisch eine Baseline und kann dann Aufgrund dieser erkennen, ob unerwünschter Traffic in dem Netzwerk unterwegs ist. 