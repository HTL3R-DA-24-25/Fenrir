#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author[Bastian Uhlig]

= Nozomi Guardian <nozomi-guardian>

Die Nozomi Guardian ist ein #htl3r.short[ids]. Wie auch Wireshark liest sie allen Datenverkehr auf einem Interface aus und verarbeitet diesen. Es können je nach Anwendungsfall jedoch auch mehrere Interfaces aufgezeichnet werden. Im Gegensatz zu Wireshark kann die Guardian diesen Datenverkehr automatisch verwerten. Sie erstellt von alleine eine Baseline und kann dann aufgrund dieser erkennen, ob unerwünschter Datenverkehr in dem Netzwerk unterwegs ist.

Dazu sind in der Guardian Phasen definiert, in welchen die Funktionsweise stets etwas unterschiedlich ist.
- *Learning:*
  In dieser Phase wird einfach nur auf den Netzwerktraffic geachtet. Es wird eine Baseline erstellt, in welcher alle Geräte des Netzwerks  erfasst sind. Es werden jedoch noch keine Alarme ausgelöst.
- *Protecting:*
  In dieser Phase wird auf den Netzwerktraffic geachtet und aufgrund der Baseline entschieden, ob ein Paket unerwünscht ist. Sollte dies der Fall sein, wird ein Alarm ausgelöst.

Die Nozomi Guardian nennt alle Geräte in einem Netzwerk Assets. Über diese Assets bringt sie so viel wie möglich in Erfahrung. Sei dies von einer #htl3r.short[ip]-Adresse bis hin zu dem laufenden Betriebssystem oder Firmware-Version. Es werden offene Sessions und Verbindungen erkannt und auch, ob ein Asset ein gewisses Service anbietet, wie beispielsweise #htl3r.short[ntp].

#htl3r.todo[lesbarer machen]
#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/nozomi_dc1_sessions.png"),
    caption: [Aktive Sessions des primary Domain Controllers]
  )
)

Zu jedem Asset wird auch ein risk assessment erstellt, in welchem auf bekannte und erkannte Vulnerabilitäten eingegangen wird.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/nozomi_risk_assessment.png"),
    caption: [Aktive Sessions des primary Domain Controllers]
  )
)

Durch die automatische Erkennung ist die Guardian vor allem in Netzwerken, in welchen der genaue Aufbau nicht bekannt ist, sehr nützlich. Sie kann Administratoren und Administratorinnen helfen, unbekannte Geräte zu entdecken, falls sich beispielsweise ein Angreifer vor Ort an das System anstecken will. Doch sie hilft auch, die Übersicht eines Netzwerks zu erlangen und zu halten, indem sie Kommunikationspartner auch grafisch anzeigen kann. In dieser Übersicht ist auch zu sehen, über welche Protokolle die Kommunikation stattfindet.

#htl3r.todo[Tool? (SDO)]
#htl3r.fspace(
  figure(
    image("../assets/nozomi_graph.png", width: 95%),
    caption: [Graph der Kommunikation zwischen den AD-Geräten]
  )
)

== Arc Sensor
Der Arc Sensor ist eine Komponente der Guardian, welche ein Endpoint-Schutzsystem darstellt und speziell für #htl3r.short[ot]-Netzwerke entwickelt wurde. Er fungiert als hostbasierter Sensor zur erkennung von kompromittierten Endpunkten und kann auf allen gängigen Betriebssystemen installiert werden.  @takeponint-arc-sensor[comp] Er erfasst Daten wie installierte Software, Treiber und ähnliches @ikarus-arc-sensor[comp].

== Abwehr von üblichen OT-Angriffen
Durch die verschiedenen Funktionen der Guardian ist sie ein ideales #htl3r.short[ids] für #htl3r.short[ot]-Netzwerke. Sie hilft, schnell Angriffe zu erkennen und zu stoppen. Vorallem in der Welt der #htl3r.short[ot] ist die Guardian ein sehr nützliches Tool, da sie auf solch Umgebungen spezialisiert ist.

=== Zero Threat Visibility
Einer der häufigsten Angriffe auf #htl3r.short[ot]-Netzwerke fungiert über sogenannte "Zero Threat Visibilty". 73 % aller Organisationen geben an, mindestens 20 % ihrer Assets nicht zu kennen. Genau hier springt die Guardian mit ihrer automatischen Asset-Erkennung und ihrem risk assessment ein.
#htl3r.todo[Quelle - für jeden absatz gleiche?]

=== Angriffe von innen
Ein weiterer Angriffsvektor sind Angriffe von innen. Dies kann durch unzufriedene Mitarbeiter oder auch durch einen versehentlichen Klick auf eine Phishing-Mail bzw. das Anstecken eines #htl3r.short[usb]-Sticks passieren. Doch auch hier kann die Guardian helfen. Sie erkennt, wenn ein Gerät plötzlich anfängt, ungewöhnliche Datenpakete zu senden, und kann so einen Angriff erkennen.

=== 3rd Party Angriffe
Abhängigkeiten von 3rd Party Software können leicht zu einem Angriffsvektor werden. Nur 13 % aller Organisationen überwachen 3rd Party Software auf Schwachstellen. Die Guardian kann auch hier helfen, indem sie automatisch Software auf bekannte Schwachstellen überprüft und Alarm schlägt, sollte eine gefunden werden.

=== Malware via Wechseldatenträger
Ein "unschuldig" aussehender #htl3r.short[usb]-Stick kann schnell zu einem Angriffsvektor werden. Er wird angesteckt, um einfach nur zu kontrollieren, wem der #htl3r.short[usb]-Stick gehört, und sobald dies geschieht, ist der Angriff schon im Gange. Der optimale Weg ist hier zwar die Schulung von Mitarbeitern und Mitarbeiterinnen, doch selbst dies kann nicht 100 % aller Angriffe verhindern. Die Nozomi Guardian füllt das fehlende Loch, indem sie die Angriffe erkennt und Alarm schlägt, sobald er erkannt wird.

=== Malware via Inter- oder Intranet
Angriffe auf #htl3r.short[ot]-Netzwerke können auch via bekannteren Angriffsvektoren wie Phishing-Mails oder Drive-By-Downloads erfolgen. Auch hier kann die Guardian helfen, indem sie den Datenverkehr überwacht und Alarm schlägt, sollte sie unerwünschten Datenverkehr erkennen, wie beispielsweise das Herunterladen von Dateien von einer unbekannten Quelle.

@scadafence-ot-angriffe[comp]

//wäre lustig mit dem blog von einem nozomi networks konkurrenten die häufigsten ot schwachstellen aufzulisten und zu sagen, dass die guardian das alles kann und mehr:
