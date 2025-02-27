#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author[Bastian Uhlig]

= Nozomi Guardian <nozomi-guardian>

Die Nozomi Guardian ist ein #htl3r.short[ids]. Wie auch Wireshark ließt sie allen Datenverkehr auf einem Interface aus und verarbeitet diesen. Es können je nach Anwendungsfall jedoch auch mehrere Interfaces aufgezeichnet werden. Im Gegensatz zu Wireshark, kann die Guardian diesen Datenverkehr automatisch verwerten. Sie erstellt von alleine eine Baseline und kann dann Aufgrund dieser erkennen, ob unerwünschter Datenverkehr in dem Netzwerk unterwegs ist.

Dazu sind in der Guardian Phasen definiert, in welchen die Funktionsweise stets etwas unterschiedlich ist. 
- *Learning:*
  In dieser Phase wird einfach nur auf den Netzwerktraffic geachtet. Es wird eine Baseline erstellt, in welcher alle Geräte des Netzwerkes erfasst sind. Es werden jedoch noch keine Alarme ausgelöst.
- *Protecting:* 
  In dieser Phase wird auf den Netzwerktraffic geachtet und aufgrund der Baseline entschieden, ob ein Paket unerwünscht ist. Sollte dies der Fall sein, wird ein Alarm ausgelöst.

Die Nozomi Guardian nennt alle Geräte in einem Netzwerk Assets. Über diese Assets bringt sie so viel wie möglich in Erfahrung. Sei dies von einer #htl3r.short[ip]-Adresse bis hin zu dem laufenden Betriebssystem oder Firmware-Version. Zu jedem Asset wird auch ein risk assessment erstellt, in welchem auf bekannte und erkannte Vulnerabilitäten eingeganen wird. 
#htl3r.todo[Bild vom Risk Assessment eines Assets]

Durch die automatische Erkennung ist die Guardian vorallem in Netzwerken, in welchen der genaue Aufbau nicht bekannt ist, sehr nützlich. Sie kann Administratoren und Administratorinnen helfen, unbekannte Geräte zu entdecken, falls sich beispielsweise ein Angreifer vor Ort an das System anstecken will. Doch sie hilft auch, die Übersicht eines Netzwerks zu erlangen und halten, indem sie Kommunikationspartner auch grafisch anzeigen kann. 
#htl3r.todo[Bild von Netzwerkübersicht (Graph)]

== Arc Sensor
#htl3r.todo[arc sensor]

== Abwehr von üblichen OT-Angriffen
Durch die verschiedenen Funktionen der Guardian ist sie ein ideales #htl3r.short[ids] für #htl3r.short[ot]-Netzwerke.

=== Zero Threat Visibility
Einer der häufigsten Angriffe auf #htl3r.short[ot]-Netwerke fungiert über sogenannte "Zero Threat Visibilty". 73% aller Organisationen geben an, mindestens 20% ihrer Assets nicht zu kenen. Genau hier springt die Guardian mit ihrer automatischen Asset-Erkennung und ihrem risk assessment ein.

=== Angriffe von innen
Ein weiterer Angriffsvektor sind Angriffe von innen. Dies kann durch unzufriendene Mitarbeiter oder auch durch einen versehentlichen Klick auf eine Phishing-Mail bzw. das Anstecken eines #htl3r.short[usb]-Sticks passieren. Doch auch hier kann die Guardian helfen. Sie erkennt, wenn ein Gerät plötzlich anfängt, ungewöhnliche Datenpakete zu senden und kann so einen Angriff erkennen.

=== 3rd Party Angriffe
Abhängigkeiten von 3rd Party Software kann leicht zu einem Angriffsvektor werden. Nur 13% aller Organisationen überwachen 3rd Party Software auf Schwachstellen. Die Guardian kann auch hier helfen, indem sie automatisch Software auf bekannte Schwachstellen überprüft und Alarm schlägt, sollte eine gefunden werden.

=== Malware via Wechseldatenträger
Ein unschuldig aussehender #htl3r.short[usb]-Stick kann schnell zu einem Angriffsvektor werden. Er wird angesteckt um einfach nur zu kontrollieren, wem der #htl3r.short[usb]-Stick gehört und sobald dies geschieht ist der Angriff schon im Gange. Der optimalste Weg ist hier zwar die Schulung von Mitarbeitern und Mitarbeiterinnen, doch selbst dies kann nicht 100% aller Angriffe verhindern. Die Nozomi Guardian füllt das fehlende Loch, indem sie die Angriffe erkennt und Alarm schlägt sobald er auffällt.

=== Malware via Inter- oder Intranet
Angriffe auf #htl3r.short[ot]-Netzwerke kann auch via bekannteren Angriffsvektoren wie Phishing-Mails oder Drive-By-Downloads erfolgen. Auch hier kann die Guardian helfen, indem sie den Datenverkehr überwacht und Alarm schlägt, sollte sie unerwünschten Datenverkehr erkennen, wie beispielsweise das Herunterladen von Dateien von einer unbekannten Quelle.

@scadafence-ot-angriffe[comp]

//wäre lustig mit dem blog von einem nozomi networks konkurrenten die häufigsten ot schwachstellen aufzulisten und zu sagen, dass die guardian das alles kann und mehr: