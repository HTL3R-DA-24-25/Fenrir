#import "@local/htl3r-da:0.1.0" as htl3r

= Aufbau der Modell-Kläranlage
#htl3r.author("David Koch")

Wieso Kläranlage?
https://www.nozominetworks.com/blog/cisa-warns-of-pro-russia-hacktivist-ot-attacks-on-water-wastewater-sector?utm_source=linkedin&utm_medium=social&utm_term=nozomi+networks&utm_content=281b8432-049c-435e-805a-ea5872a057eb

Um die Absicherung eines Produktionsbetriebes oder eines Stücks kritischer Infrastruktur ausreichend dokumentieren zu können, kann sich nicht auf ausschließlich virtualisierte Lösungen des #htl3r.shorts[ot]-Netzwerks verlassen werden. Dazu ist das Ausmaß eines Super-#htl3r.shorts[gau]s innerhalb eines virtualisierten #htl3r.shorts[ot]-Netzwerks nicht begreifbar/realistisch für die meisten aussenstehenden Personen. Es braucht eine angreifbare und physisch vorhandene Lösung: eine selbstgemachte Modell-Kläranlage.

== Planung der Betriebszellen

Wieso unterteilen in Betriebszellen?
tipp: security lol

Um die Sicherheit der #htl3r.shorts[ot]-Komponenten so weit es geht zu gewährleisten, muss bereits bei der Planung der Anlage die Segmentierung in Betriebszellen in Betracht gezogen werden.
Der Inhalt einer Betriebszelle soll nur untereinander kommunizieren können, die einzige Ausnahme wäre beispielsweise die Kommunikation mit einem SCADA-System auf der nächst-höheren Purdue-Ebene. Eine solche Segmentierung lässt sich somit quasi mit einer #htl3r.shorts[vlan]-Segmentierung in einem #htl3r.shorts[it]-Netzwerk vergleichen.

Unter anderem lässt sich durch eine physische Segmentierung der Kläranlage diese leicht ab- und wieder aufbauen. Wären alle Betriebszellen auf einer einzelnen Platte untergebracht, wäre diese ca 160x45cm groß und somit sehr unhandlich zu transportieren.

== Zelle 1 (Grobfiltration)

=== Aufbau

Als erster Schritt zur erfolgreichen Abwasserfiltration braucht es einen Weg, grobe Schmutzpartikel wie zum Beispiel Kieselsteine filtrieren zu können. Einen feinen Wasserfilter würden solche großen Partikel verstopfen oder sogar zerstören, noch dazu erlaubt der Aufbau mit herkömmlichen AAAA. Somit erfolgt die erste Filtration mit einem gröberen Metallgitter als Rechen.

Um das Abwasser zu rechen, wird es zuerst mit einer archimedischen Schraube in einen höhergelegenen Behälter geschraubt, welcher angewinkelt ist und am unteren Ende eine Öffnung hat. Diese Öffnung lässt das hochgeschraubte Wasser durch das Rechengitter fallen, was die groben Partikel wie zum Beispiel Kieselsteine aus dem Abwasser entfernt. Das restliche Abwasser fließt durch das Gitte durch und landet in einem Auffangbehälter, welcher der Anfang der Leitung in die zweite Zelle ist.

=== Schaltplan

* BILD *

=== Steuerungstechnik

Aktorik:
- Schneckenmotor mit 50 RPM

Sensorik:
- keine?

== Zelle 2 (Feinfiltration)

=== Aufbau

Die zweite Betriebszelle dient der Feinfiltration des bereits grobfiltrierten Abwassers aus der ersten Zelle. Die feinen im Abwasser aufgelösten Schmutzpartikel, die in der ersten Zelle nicht durch den Rechen entfernt worden konnten, werden hier endgültig aus dem Abwassser entfernt. Nach der zweiten Zelle ist das Abwasser klar und ohne jeglich Verfärbungen und kann sicher in die Natur (Zelle 3) abgepumpt werden.

Besteht aus zwei durchsichtigen Acryl-Wassertanks welche jeweils ca. 3L an Volumen aufweisen. Diese sind oben offen, werden jedoch von Deckeln abgedeckt. Diese Deckel wurden speziell angefertigt mittels 3D-Modellierung und darauf zweimal gedruckt. In diesen Deckeln ist die für den Wassertank jeweils notwendige Sensorik verbaut, diese besteht aus einem kapazitiven Füllstandssensor als auch einem Temperatursensor.

Zwischen den Tanks befindet sich ein herkömmlicher Gartenpumpenfilter mit Filterball als auch eine Pumpe, die die Flüssigkeiten von einem Tank in den Nächsten durch den Filter hindurch transporiert.
* BILD *

=== Schaltplan

#htl3r.fspace(
  figure(
    image("../assets/Zelle_2_Schaltplan.png"),
    caption: [Schaltplan der 2. Betriebszelle]
  )
)

=== Steuerungstechnik

Im Vergleich zu den anderen zwei Zellen wird in dieser eine Software-#htl3r.shorts[sps] eingesetzt: Die OpenPLC v3. Diese läuft auf einem Raspberry Pi 4 Mikrocomputer.

Aktorik:
- Gartenpumpe mit 800L/h Durchsatz (mit eigenem 12V Relais)

Sensorik:
- 2x OneWire DS18B20 Temperatursensor
- 2x Füllstandssensor (Widerstand mit 0-190 Ohm)

== Zelle 3 (Staudamm)

=== Aufbau

Nach der erfolgreichen Filtration des Abwassers wird dies von der zweiten Zelle in einen Staudamm-Behälter umgepumpt. Dieser hält das Wasser durch ein geschlossenes Magnetventil zurück, um ein aus Pappmaschee, Lackfarbe und Epoxidharz modelliertes vor Überschwemmung zu schützen.

Das Überschwemmungsgebiet ist mit kleinen Modell-Bäumen und 3D-gedruckten roten Häusern unterschiedlicher Größe bestückt. Unter anderem sind mehrere Wasserstandsensoren an der Seite des Behälters befestigt, um im Falle eines Hochwasser bzw. einer Überschwemmung einen Alarm auszulösen (Leuchte mit Alarmton neben dem Behälter).
* BILD *

=== Schaltplan

* BILD *

=== Steuerungstechnik

Aktorik:
- Magnetventil
- Alarmleuchte (+ Ton)

Sensorik:
- 2x Überschwemmungssensor

== Programmierung eines I2C-Kommunikationsbusses

Um einen Kommunikationskanal zwischen der Software-#htl3r.shorts[sps] (OpenPLC) auf dem RaspberryPi und dem Analogdigitalwandler ESP32 für die Füllstandssensoren herzustellen, wird der ein Zweidrahtbussystem mit dem Protokoll #htl3r.shorts[i2c] verwendet.

=== I2C Überblick

Kurz für "Inter-Integrated Circuit". #htl3r.shorts[i2c] ist ein 1982 von Philips Semiconductors entwickelter serieller Datenbus, der als Master-Slave-Bus konzipiert ist, aber auch das Multi-Master-Prinzip unterstützt. Bei diesem Protokoll werden zwei Signalleitungen benötigt, eine Takt- und eine Datenleitung. Eine Eigenschaft von #htl3r.shorts[i2c] ist die Tatsache, dass ein Mikrocontroller ein ganzes Netzwerk an integrierten Schaltungen mit nur zwei #htl3r.shorts[io]-Pins und einfacher Software kontrollieren kann. Daher wird #htl3r.shorts[i2c] hauptsächlich geräteintern für die Kommunikation zwischen verschiedenen Schaltungsteilen benutzt, zum Beispiel innerhalb eines Fernsehers.

Im PC wird ein dem #htl3r.shorts[i2c]-Bus sehr ähnliches System benutzt, um z.B. die Daten eines SDRAM-Modules auszulesen. Dieser nennt sich SMBus (System Management Bus).

--> https://www.mikrocontroller.net/articles/I%C2%B2C

=== Aufbau

#htl3r.fspace(
  figure(
    image("../assets/rpi_esp32_i2c_fenrir.svg"),
    caption: [Der Kommunikationsaufbau zwischen RPI, ESP32 und Sensorik]
  )
)

=== Kodierung

Bei der Datenübertragungen über einen #htl3r.shorts[i2c]-Bus wird folgendes Frame-Format verwendet:

#htl3r.fspace(
  figure(
    image("../assets/i2c_standard_frame.png"),
    caption: [Das #htl3r.shorts[i2c]-Frame-Format]
  )
)

Das Protokoll des #htl3r.shorts[i2c]-Bus ist von der Definition her recht einfach, aber auch recht störanfällig[(https://repo.uni-hannover.de/items/3e39f8b0-b3a8-47b9-bc70-af4c513f37c9)]. Wie man erkennen kann, werden pro Frame insgesamt 16 Bits an Nutzdaten übertragen. Dazu gibt es keinen Mechanismus zur Erkennenung von Übertragungsfehlern, nur ACK/NACK Bits, ob Bits überhaupt angekommen sind.

Um dieses Problem zu lösen wird über die #htl3r.shorts[i2c]-Kommunikation zwischen RaspberryPi und ESP32 eine weitere Kommunikationsschicht erstellt. Beispiel aus der Netzwerktechnik: Frames der OSI-Schicht 2 übertragen in ihren Nutzdaten alle Bits der Packets auf OSI-Schicht 3, somit bildet #htl3r.shorts[i2c] die quasi Unterschicht und das Custom-Fenrir-Protokoll die Oberschicht.

#htl3r.fspace(
  figure(
    image("../assets/custom_i2c_frame_fenrir.svg"),
    caption: [Das Fenrir-Frame-Format]
  )
)

Die Länge des Fenrir-Frames wurde trotz lediglich 2 Bits an benötigten Nutzdaten bewusst auf 128 Bits gesetzt (somit max. 124 Bits an Nutzdaten), da die AdaFruit-SMBus-Library immer auf eine Datenmenge von 128 Bits wartet, bevor sie diese weiterverarbeitet. FACT CHECK PLS

frame start, length, data + buffer, fsdfgswgr

Die #htl3r.shorts[crc]8-Prüfsumme der Nutzdaten-Bits wird auf dem RaspberryPi mittels Python folgend berechnet:

```Python
def crc8(data: list):
    crc = 0

    for _byte in data:
        extract = _byte
        for j in range(8, 0, -1):
            _sum = (crc ^ extract) & 0x01
            crc >>= 1
            if _sum:
                crc ^= 0x8C
            extract >>= 1

    return crc
```

Das ganze findet klarerweise auch auf der Slave-Seite statt, dort ist der #htl3r.shorts[crc]8-Code jedoch in C implementiert worden.

=== Integration in OpenPLC

OpenPLC Version 3 basiert auf dem Busprotokoll Modbus bzw. Modbus-TCP. Somit kann nicht ohne weitere Konfiguration ein Gerät mittels #htl3r.shorts[i2c] oder einem anderen Busprotokoll mit OpenPLC verbunden und automatisch erkannt werden. Mit dem #htl3r.shorts[psm] von OpenPLC (siehe OpenPLC -> PSM Kapitel TODO) lassen sich software-defined Modbus-Register schnitzen, welchen die über den #htl3r.shorts[i2c]-Bus erhaltenen Daten des ESP32 enthalten.

Bevor die Daten per #htl3r.shorts[psm] gemappt werden können, müssen sie zuerst empfangen und dekodiert werden. Dazu wird folgende Python-Funktion verwendet:

```Python
# read data from ESP32
def read_from_esp32(i2caddress: hex, size: int):
    decoder = I2C_Decoder()
    try:
        # get data sent by ESP32, in raw format
        stream = bus.read_bytes(i2caddress, size)
        # convert to a list to ease handling
        data = decoder.write(stream)
        return data

    except Exception as e:
        print("ERROR: {}".format(e))
```

Die Adafruit-SMBus-Library bietet die Methode ```.read_bytes()``` an, um von einer zuvor mit ```bus = SMBus(1)``` deklarierten #htl3r.shorts[i2c]/SMBus-Leitung die Nutzdaten der #htl3r.shorts[i2c]-Frames zu lesen. Diese werden dem selbstgeschriebenen #htl3r.shorts[i2c]-Decoder übergeben, damit dieser aus den #htl3r.shorts[i2c]-Rohnutzdaten den Fenrir-Frame rekonstruieren und somit die gewünschten Nutzdaten (Füllstandsmesswerte) inklusive Prüfsumme gewinnen kann.

Um die Werte vom ESP32 zu erhalten, welcher ein #htl3r.shorts[i2c]-Slave-Gerät ist, muss der RaspberryPi als #htl3r.shorts[i2c]-Master-Gerät zuerst eine Nachricht an den Slave schicken, dass dieser überhaupt mit dem Füllstandsdaten antwortet. Dies wird mit folgender Python-Funktion gemacht:

#htl3r.code(caption: "I2C-Kommunikation von OpenPLC zu ESP32", description: none)[
```Python
# write data to ESP32
def write_to_esp32(i2caddress: hex, data: str):
    encoder = I2C_Encoder()
    try:
        # only if there is data
        if len(data) > 0:
            for c in data:
                encoder.write(ord(c))
        stream = encoder.end()

        # send stream to slave
        bus.write_bytes(i2caddress, bytearray(stream))

    except Exception as e:
        print("ERROR: {}".format(e))
```
]

Beide Funktionen nehmen als ersten Parameter die #htl3r.shorts[i2c]-Adresse des gewünschten ESP32 bzw. #htl3r.shorts[i2c]-Slave-Gerätes. In diesem Fall wird nur ein einzelner ESP32 (Slave-Adresse: ```0x21```) verwendet, falls jedoch mehrere Geräte auf dem #htl3r.shorts[i2c]-Bus angeschlossen wären könnten unterschiedliche Adressen mitgegeben werden, um jeweils nur die gewünschten Geräte anzusteuern.

Einen Zweidrahtbus aufbauen und mit dem #htl3r.shorts[i2c]-Protokoll verwenden ist für eine simple peer-to-peer Kommunikation tatsächlich eine unnötig überkomplizierte Umsetzung. Es sprechen jedoch trotzdem mehrere Gründe für diese Umsetzungsart im Vergleich zu einer Kommunikation über #htl3r.shorts[uart] z.B.:
- #htl3r.shorts[i2c] ist ein weitverbreitetes Busprotokoll und dient als guter Kontrast zum komplizierteren Modbus-Protokoll
- Bei Bedarf kann ein weiterer ESP32 oder ein anderes #htl3r.shorts[i2c]
- Slave-Gerät angeschlossen werden und es müssen nur die bereits programmierten Funktion erneut aufgerufen werden
- noch ein grund :^)

// TODO UMSCHREIBEN (alt und hässlich):
Um die über einen #htl3r.shorts[i2c]-Bus erhaltenen Daten in OpenPLC auf einem RaspberryPi einsetzen zu können, müssen diese über das #htl3r.shorts[psm] (siehe OpenPLC PSM) auf eine #htl3r.shorts[sps]-Hardwareadresse gemappt werden. Beispielsweise BLABLABAL IW2:
data: list[int] = read_from_esp32(ESP_I2C_address, 32)
psm.set_var("IW2", data[0])

Nun kann die #htl3r.shorts[sps]-Hardwareadresse ```%IW2``` in einem #htl3r.shorts[sps]-Programm mit einer Input-Variable verknüpft und somit verwendet werden:
* SCREEEEEENSHOTS, EDITOR + MONITORING? *
