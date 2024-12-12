# Aufbau der Modell-Kläranlage

Wieso Kläranlage?
https://www.nozominetworks.com/blog/cisa-warns-of-pro-russia-hacktivist-ot-attacks-on-water-wastewater-sector?utm_source=linkedin&utm_medium=social&utm_term=nozomi+networks&utm_content=281b8432-049c-435e-805a-ea5872a057eb

Um die Absicherung eines Produktionsbetriebes oder eines Stücks kritischer Infrastruktur ausreichend dokumentieren zu können, kann sich nicht auf ausschließlich virtualisierte Lösungen des OT-Netzwerks verlassen werden. Dazu ist das Ausmaß eines Super-GAUs innerhalb eines virtualisierten OT-Netzwerks nicht begreifbar/realistisch für die meisten aussenstehenden Personen. Es braucht eine angreifbare und physisch vorhandene Lösung: eine selbstgemachte Modell-Kläranlage.

## Planung der Betriebszellen

Wieso unterteilen in Betriebszellen?
tipp: security lol

Um die Sicherheit der OT-Komponenten so weit es geht zu gewährleisten, muss bereits bei der Planung der Anlage die Segmentierung in Betriebszellen in Betracht gezogen werden.
Der Inhalt einer Betriebszelle soll nur untereinander kommunizieren können, die einzige Ausnahme wäre beispielsweise die Kommunikation mit einem SCADA-System auf der nächst-höheren Purdue-Ebene. Eine solche Segmentierung lässt sich somit quasi mit einer VLAN-Segmentierung in einem IT-Netzwerk vergleichen.

Unter anderem lässt sich durch eine physische Segmentierung der Kläranlage diese leicht ab- und wieder aufbauen. Wären alle Betriebszellen auf einer einzelnen Platte untergebracht, wäre diese ca 160x45cm groß und somit sehr unhandlich zu transportieren.

## Zelle 1 (Vorbearbeitung)

### Aufbau

Als erster Schritt zur erfolgreichen Abwasserfiltration braucht es einen Weg, grobe Schmutzpartikel wie zum Beispiel Kieselsteine filtrieren zu können. Einen feinen Wasserfilter würden solche großen Partikel verstopfen oder sogar zerstören, noch dazu erlaubt der Aufbau mit herkömmlichen AAAA. Somit erfolgt die erste Filtration mit einem gröberen Metallgitter als Rechen.

Um das Abwasser zu rechen, wird es zuerst mit einer archimedischen Schraube in einen höhergelegenen Behälter geschraubt, welcher angewinkelt ist und am unteren Ende eine Öffnung hat. Diese Öffnung lässt das hochgeschraubte Wasser durch das Rechengitter fallen, was die groben Partikel wie zum Beispiel Kieselsteine aus dem Abwasser entfernt. Das restliche Abwasser fließt durch das Gitte durch und landet in einem Auffangbehälter, welcher der Anfang der Leitung in die zweite Zelle ist.

### Schaltplan

** BILD **

### Steuerungstechnik

Aktorik:
- Schneckenmotor mit 50 RPM

Sensorik:
- keine?

## Zelle 2 (Filtration)

### Aufbau

Die zweite Betriebszelle dient der Feinfiltration des bereits grobfiltrierten Abwassers aus der ersten Zelle. Die feinen im Abwasser aufgelösten Schmutzpartikel, die in der ersten Zelle nicht durch den Rechen entfernt worden konnten, werden hier endgültig aus dem Abwassser entfernt. Nach der zweiten Zelle ist das Abwasser klar und ohne jeglich Verfärbungen und kann sicher in die Natur (Zelle 3) abgepumpt werden.

Besteht aus zwei durchsichtigen Acryl-Wassertanks welche jeweils ca. 3L an Volumen aufweisen. Diese sind oben offen, werden jedoch von Deckeln abgedeckt. Diese Deckel wurden speziell angefertigt mittels 3D-Modellierung und darauf zweimal gedruckt. In diesen Deckeln ist die für den Wassertank jeweils notwendige Sensorik verbaut, diese besteht aus einem kapazitiven Füllstandssensor als auch einem Temperatursensor.

Zwischen den Tanks befindet sich ein herkömmlicher Gartenpumpenfilter mit Filterball als auch eine Pumpe, die die Flüssigkeiten von einem Tank in den Nächsten durch den Filter hindurch transporiert.
** BILD **

### Schaltplan

** BILD **

### Steuerungstechnik

Im Vergleich zu den anderen zwei Zellen wird in dieser eine Software-SPS eingesetzt: Die OpenPLC v3. Diese läuft auf einem Raspberry Pi 4 Mikrocomputer.

Aktorik:
- Gartenpumpe mit 800L/h Durchsatz (mit eigenem 12V Relais)

Sensorik:
- 2x OneWire DS18B20 Temperatursensor
- 2x Füllstandssensor (Widerstand mit 0-190 Ohm)

## Zelle 3 (Staudamm)

### Aufbau

Nach der erfolgreichen Filtration des Abwassers wird dies von der zweiten Zelle in einen Staudamm-Behälter umgepumpt. Dieser hält das Wasser durch ein geschlossenes Magnetventil zurück, um ein aus Pappmaschee, Lackfarbe und Epoxidharz modelliertes vor Überschwemmung zu schützen.

Das Überschwemmungsgebiet ist mit kleinen Modell-Bäumen und 3D-gedruckten roten Häusern unterschiedlicher Größe bestückt. Unter anderem sind mehrere Wasserstandsensoren an der Seite des Behälters befestigt, um im Falle eines Hochwasser bzw. einer Überschwemmung einen Alarm auszulösen (Leuchte mit Alarmton neben dem Behälter).
** BILD **

### Schaltplan

** BILD **

### Steuerungstechnik

Aktorik:
- Magnetventil

Sensorik:
- sdfdsgsdg



