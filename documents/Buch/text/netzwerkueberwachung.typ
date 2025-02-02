#import "@preview/htl3r-da:0.1.0" as htl3r

#htl3r.author("Bastian Uhlig")
= Netzwerküberwachung <netzwerkueberwachung>

== Theoretische Netzwerküberwachung
Ein wichtiger Teil der Sicherheit in einem Netzwerk ist Überwachung dessen. Damit kann die Zuverlässlichkeit und der derzeitige Zustand sofort erkannt werden. Es ist nämlich niemals möglich, sämtliche Angriffe abzuwehren, bevor sie überhaupt stattfinden. Wenn ein Netzwerk jedoch mit modernen Mitteln überwacht wird, können Angriffe, die bereits in vollem Gange sind, entdeckt und (in weiterer Folge) unterbunden werden. 

Hierbei ist der Begriff einer Baseline wichtig. Eine Baseline beschreibt einen Status des Netzwerkes, in welchem dieses im Normalzustand agiert.

Falls in dem Netzwerk nun Besonderheiten aufkommen, sei dies ein neuer Kommunikationsteilnehmer oder ein bereits existierendes Gerät, so wird dies unter besondere Beobachtung gesetzt oder sogar sofort Alarm geschlagen.

=== Tools
Tools zur Überwachung von Netzwerken gibt es tausende. Von dem selbstentwickeltem Packet Sniffer bis zu einem #htl3r.short[ids] auf Enterprise Level. Dabei gibt es kein Tool, welches "das Richtige" ist.

==== Wireshark
Wireshark ist ein Packet-Sniffer. Das heißt, es liest einfach allen Datenverkehr, der auf einem gewissen Interface eines Computers läuft, und gibt diesen aus. Es gibt auch eine Version von Wireshark für die Kommandozeile, diese heißt "tshark".

Zur Benutzung von Wireshark muss nur das Interface angegeben werden, auf welchem der Datenverkehr mitgelesen werden soll. Sobald dies geschehen ist, wird jedes Paket, das gelesen wird, in einer Tabelle nach der Zeit geordnet dargestellt. Mit einem Doppelklick können über jedes Paket genauere Informationen angezeigt werden, sei dies von protokollspezifischen Daten bis hin zur reinen Hexadezimaldarstellung.
In großen Systemen wird eine Überwachung mittels Wireshark schnell unübersichtlich. Zwar kann mit Filtern der Anzeigebereich eingeschränkt werden, jedoch ist es schwer unerwünschten Datenverkehr zu erkennen, weshalb Wireshark nur als stichprobenartiges Überwachungssystem verwendet werden sollte. Beispielsweise können Netzwerkadministratoren mittels Wireshark Netzwerktraffic auf einem Gerät aufzeichnen, auf welchem eine Kompromitierung vermutet wird. Diese Aufzeichnung kann dann analysiert werden, um die Ursache der Kompromitierung zu finden und dagegen vorzugehen.

In Live-Systemen ist die Verwendung von Wireshark als Überwachungssystem nur sinnvoll, um stichprobenartig Pakete zu untersuchen, und diese zu überprüfen.

==== Nozomi Guardian
Siehe @nozomi-guardian.
