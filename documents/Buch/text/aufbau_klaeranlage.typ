#import "@preview/htl3r-da:0.1.0" as htl3r

= Aufbau der Modell-Kläranlage <aufbau-klaeranlage>

Um die Absicherung eines Produktionsbetriebs oder eines Stücks kritischer Infrastruktur ausreichend dokumentieren zu können, darf nicht ausschließlich auf virtualisierte Lösungen des #htl3r.short[ot]-Netzwerks vertraut werden. Dazu ist das Ausmaß eines "Super-#htl3r.short[gau]s" innerhalb eines virtualisierten #htl3r.short[ot]-Netzwerks für die meisten aussenstehenden Personen nicht begreifbar/realistisch genug. Eine selbstgebaute Modell-Kläranlage löst dieses Problem.

Zwar sind Kläranlagen nicht die beliebtesten #htl3r.short[ot]-Angriffsziele, Kraftwerke wären hierbei das beliebteste Ziel von Cyberangriffen auf kritische Infrastruktur @knowbe4-cyber-attacks-crit-infra[comp], jedoch gab es mit der Häufung an staatlich motivierten Cyberangriffen auch manche von pro-russischen Hacktivisten auf Kläranlagen im amerikanischen als auch europäischen Raum. @cisa-wastewater[comp]

#htl3r.author("David Koch")
== Planung der Betriebszellen

Um die Sicherheit der #htl3r.short[ot]-Komponenten so weit es geht zu gewährleisten, muss bereits bei der Planung der Anlage die Segmentierung in Betriebszellen in Betracht gezogen werden.
Die Gerätschaft einer Betriebszelle soll nur innerhalb dieser kommunizieren können, die einzige Ausnahme wäre beispielsweise die Kommunikation mit einem SCADA-System auf der nächst-höheren Purdue-Ebene. Eine solche Segmentierung lässt sich somit mit einer #htl3r.short[vlan]-Segmentierung in einem #htl3r.short[it]-Netzwerk vergleichen.

Unter anderem lässt sich durch eine physische Segmentierung der Kläranlage diese leicht ab- und wieder aufbauen. Wären alle Betriebszellen auf einer einzelnen Platte untergebracht, wäre diese ca 160x45cm groß und somit sehr unhandlich zu transportieren.

#htl3r.author("David Koch")
== Zelle Eins (Grobfiltration)

=== Aufbau

Als erster Schritt zur erfolgreichen Abwasserfiltration braucht es einen Weg, grobe Schmutzpartikel wie zum Beispiel Kieselsteine filtrieren zu können. Einen feinen Wasserfilter würden solche großen Partikel verstopfen oder sogar zerstören. Somit erfolgt die erste Filtration mit einem gröberen Metallgitter als Rechen.

Um das Abwasser zu sieben, wird es zuerst mit einer archimedischen Schraube in einen höhergelegenen Behälter geschraubt, welcher angewinkelt ist und am unteren Ende eine Öffnung hat. Diese Öffnung lässt das hochgeschraubte Wasser durch das Rechengitter fallen, was die groben Partikel wie zum Beispiel Kieselsteine aus dem Abwasser entfernt. Das restliche Abwasser fließt durch das Gitter durch und landet in einem Auffangbehälter, welcher der Anfang der Leitung in die zweite Zelle ist.

* BILD *

=== Schaltplan

* BILD *

=== Steuerungstechnik

Die in dieser Zelle verwendete #htl3r.short[sps] ist eine Siemens SIMATIC S7-1200 mit der CPU 1212C. Sie ist kompakt sowie modular erweiterbar und somit für kleinere bis mittlere Automatisierungsaufgaben konzipiert.

Europaweit hat sich die Siemens SIMATIC als die gängiste #htl3r.short[sps]-Marke durchgesetzt @siemens-marktanteil[comp]. Bereits im Jahre 1958 wurde die erste SIMATIC, eine verbindungsprogrammierte Steuerung (kurz VPS), auf den Markt gebracht @simatic-history[comp].

Die S7-1200 hat folgende Eingänge und Ausgänge:
- 8 digitale Eingänge 24V DC, davon TODO in Verwendung
- 6 digitale Ausgänge 24V/0,5A DC, davon TODO in Verwendung
- 2 analoge Eingänge 0-10V, davon TODO in Verwendung
- Eine Ethernet-Schnittstelle für die Kommunikation mit anderen Geräten über das Modbus TCP Protokoll

Die Ethernet-Schnittstelle wird verwendet, um die #htl3r.short[sps] mit der Zellen-Firewall und somit der restlichen Topologie zu verbinden.

* bild programm *

Aktorik:
- Schneckenmotor mit 50 RPM

Sensorik:
- keine?

#htl3r.author("David Koch")
== Zelle Zwei (Feinfiltration)

=== Aufbau

Die zweite Betriebszelle dient der Feinfiltration des bereits grobfiltrierten Abwassers aus der ersten Zelle. Die feinen im Abwasser aufgelösten Schmutzpartikel, die in der ersten Zelle nicht durch den Rechen entfernt worden konnten, werden hier endgültig aus dem Abwassser entfernt. Nach der zweiten Zelle ist das Abwasser klar und ohne jeglich Verfärbungen und kann sicher in die Natur (Zelle Drei) abgepumpt werden.

Sie besteht aus zwei durchsichtigen Acryl-Wassertanks welche jeweils ca. 3L an Volumen aufweisen. Diese sind oben offen, werden jedoch von Deckeln abgedeckt. Diese Deckel wurden mittels 3D-Modellierung speziell angefertigt und zweimal gedruckt. In diesen Deckeln ist die für den Wassertank jeweils notwendige Sensorik verbaut. Diese besteht aus einem Füllstandssensor mit Schwimmer -- welcher als Widerstand agiert -- sowie einem DS18B20-Temperatursensor.

Zwischen den Tanks befindet sich ein herkömmlicher Gartenpumpenfilter mit Filterball und eine Pumpe, welche Flüssigkeiten von einem Tank in den Nächsten durch den Filter hindurch transportiert.

* BILD *

=== Schaltplan

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/Zelle_2_Schaltplan.png"),
    caption: [Schaltplan der 2. Betriebszelle]
  )
)

=== Steuerungstechnik

Im Vergleich zu den anderen zwei Zellen wird in dieser eine Software-#htl3r.short[sps] eingesetzt: Die OpenPLC v3. Diese läuft auf einem Raspberry Pi 4 Mikrocomputer.

OpenPLC ist eine einfach bedienbare Open-Source Software-#htl3r.short[sps]. Sie ist die erste vollständig funktionsfähige standardisierte Open Source #htl3r.short[sps], im Software- als auch im Hardwarebereich. Das OpenPLC-Projekt wurde in Übereinstimmung mit der IEC 61131-3 Norm erstellt, welche die grundlegende Softwarearchitektur und Programmiersprache für #htl3r.shortpl[sps] festlegt. OpenPLC wird hauptsächlich für die Automatisierung in industriellen Anlagen, bei der Hausautomation (Internet of Things) und im Forschungsbereich eingesetzt @openplc-overview.

Aktorik:
- Gartenpumpe mit 800L/h Durchsatz (mit eigenem 12V Relais)

Sensorik:
- 2x OneWire DS18B20-Temperatursensor
- 2x Füllstandssensor mit Schwimmer (Widerstand mit 0-190 Ohm)

#htl3r.author("Gabriel Vogler")
== Zelle Drei (Staudamm)

=== Aufbau

Nach der erfolgreichen Filtration des Abwassers wird dies von der zweiten Zelle in ein Wasserspeicherbecken umgepumpt. Es handelt sich bei dem Becken um eine Eurobox mit den Maßen 30cm x 20cm x 7cm und hat an der Vorderseite ein Loch woran das Magnetventil befestigt ist. Mit dem Zusammenspiel dieser beiden Komponenten wird der Staudamm realisiert. Das Becken wird mit Wasser gefüllt und das Magnetventil kann geöffnet und geschlossen werden. Für diese Steuerung ist eine Siemens LOGO! #htl3r.short[sps] zuständig. Diese steuert das Magnetventil und somit den Wasserfluss. Für die Montage des Magnetventils wurde zunächst ein Loch in die Eurobox gebohrt. Dabei musste aufgepasst werden, dass man nicht zu schnell bohrt, weil sonst das Plastik entweder ausreißen oder wegschmelzen könnte. Anschließend wurde ein Wasserauslass durch das Loch gesteckt, mit Dichtungen wasserdicht gemacht und mit dem beigelegten Gegenstück verschraubt. An den Messingauslass wurden dann zwei 3D-gedruckte Adapterstücke geschraubt, um daran das Magnetventil zu befestigen, da das Magnetventil eine 1/2 Zoll Schraubverbindung und der Messingauslass ein 3/4 Zoll Gewinde hat. Das Wasser vom Wasserspeicherbecken soll durch das Magnetventil in das Wassereinlaufbecken fließen. Aufgrunddessen wurde das Wasserspeicherbecken mit sechs Holzstücken erhöht, damit das Wasser mittels Gravitation in das Wassereinlaufbecken fließen kann.

Für das Wassereinlaufbecken bzw. das Überschwemmungebiet wurde als Basis eine weitere 30cm x 20cm x 7cm Eurobox verwendet. Das Überschwemmungsgebiet ist mit kleinen Modell-Bäumen und 3D-gedruckten roten Häusern unterschiedlicher Größe bestückt. Unter anderem sind mehrere Wasserstandsensoren an der Seite des Behälters befestigt, um im Falle eines Hochwasser bzw. einer Überschwemmung einen Alarm auszulösen (Leuchte mit Alarmton neben dem Behälter).

* BILD *

=== Schaltplan

* BILD *

=== Steuerungstechnik

Siemens LOGO!

Aktorik:
- Magnetventil
- Alarmleuchte (+ Ton)

Sensorik:
- 2x Überschwemmungssensor

#htl3r.author("Gabriel Vogler")
== 3D-Druck

Für einige Komponenten gab es keine passenden Teile, oder übermäßige Kosten für die Anschaffung dessen.
Deshalb wurde die Entscheidung getroffen diese Teile oder Abwandlungen, die für die Anlage sogar noch besser passen, selbst zu designen und zu drucken.
Die Anschaffung des 3D-Druckers wurde privat getätigt und die Filamentkosten wurden von unserem Sponsor -- der Ikarus -- übernommen.

#htl3r.author("Gabriel Vogler")
=== Modellieren

Die Modelle wurden mittels Autodesk Fusion 360 erstellt.

Die Modelle sind stark in ihrer Komplexität variierend. Einige sind sehr einfach zu modellieren, wie zum Beispiel das Wasserspeicherbecken, andere sind sehr komplex und benötigen viel Zeit und Erfahrung, wie zum Beispiel die Tankdeckel der Zelle Zwei. Andere sind etwas aufwändiger, wie zum Beispiel die Archimedische Förderschnecke in der Zelle Eins.

#htl3r.author("Gabriel Vogler")
=== Drucken

Als Drucker wurde ein BambuLab A1 3D-Drucker verwendet.
Es wurde auf #htl3r.short[pla] und #htl3r.short[petg] Filament zurückgegriffen, da diese Materialien für den Einstieg in den 3D-Druck sehr gut geeignet sind und auf diesem Gebiet noch nicht sehr viele Erfahrungen vorhanden waren.
Außerdem sind diese Materialien in der Anschaffung günstiger als andere und bieten eine mehr als ausreichende Qualität, im Sinne von Stabilät und Strapazierfähigkeit, sowohl als auch in der Druckqualität.
Die Wahl des Filamentherstellers fiel auf das Filament von BambuLab, da diese das Filament und der Drucker aus dem selben Hause stammen und so perfekt aufeinander abgestimmt sind.
Außerdem ist das #htl3r.short[pla] Filament von BambuLab biologisch abbaubar und ist somit umweltfreundlicher und nachhaltiger als andere Filamente.
Für den Druck wurden die Standard Druckprofile von BambuLab verwendet, mit kleinen Anpassungen an die Druckgeschwindigkeit und die Temperatur, damit das für uns gewünschte Ergebnis erzielt werden konnte.
Diese Profile werden automatisch erfasst sobald eine originale BambuLab Spule Filament in das #htl3r.short[ams] eingelegt wird.
Das Ganze funktioniert mithilfe eines #htl3r.short[rfid]-Chips, der auf der Spule angebracht ist und mit einem #htl3r.short[rfid]-Lesegerät im #htl3r.short[ams] kommuniziert.
Die Druckprofile sind außerdem auch noch von dem Druckermodell, der verwendeten Spitze und dem zu druckenden Modell abhängig.
Das wird automatisch berechnet und angepasst, sobald das Modell in die Drucksoftware geladen wurde.

#htl3r.author("David Koch")
== Programmierung eines I2C-Kommunikationsbusses

Um einen Kommunikationskanal zwischen der Software-#htl3r.short[sps] (OpenPLC) auf dem RaspberryPi und dem Analogdigitalwandler ESP32 für die Füllstandssensoren in Betriebszelle zwei herzustellen, wird ein Zweidrahtbussystem mit dem Protokoll #htl3r.short[i2c] verwendet.

=== I2C Überblick

Kurz für "Inter-Integrated Circuit". #htl3r.short[i2c] ist ein 1982 von Philips Semiconductors entwickelter serieller Datenbus, der als Master-Slave-Bus konzipiert ist, aber auch das Multi-Master-Prinzip unterstützt. Bei diesem Protokoll werden zwei Signalleitungen benötigt, eine Takt- und eine Datenleitung. Eine Eigenschaft von #htl3r.short[i2c] ist die Tatsache, dass ein Mikrocontroller ein ganzes Netzwerk an integrierten Schaltungen mit nur zwei #htl3r.short[io]-Pins und einfacher Software kontrollieren kann. Daher wird #htl3r.short[i2c] hauptsächlich geräteintern für die Kommunikation zwischen verschiedenen Schaltungsteilen benutzt, zum Beispiel innerhalb eines Fernsehers.
@i2c-manual

Im PC wird ein dem #htl3r.short[i2c]-Bus sehr ähnliches System benutzt, um z.B. die Daten eines SDRAM-Modules auszulesen. Dieser nennt sich SMBus (System Management Bus).

=== Aufbau ???

#htl3r.fspace(
  [
    #figure(
      image("../assets/rpi_esp32_i2c_fenrir.svg"),
      caption: [Der Kommunikationsaufbau zwischen RPI, ESP32 und Sensorik]
    )
    <i2c-aufbau>
  ]
)

Der in @i2c-aufbau sichtbare Aufbau

=== Kodierung der #htl3r.short[i2c]-Daten

Bei der Datenübertragungen über einen #htl3r.short[i2c]-Bus wird folgendes Frame-Format verwendet:

#htl3r.fspace(
  figure(
    image("../assets/i2c_standard_frame.png"),
    caption: [Das #htl3r.short[i2c]-Frame-Format]
  )
)

Das Protokoll des #htl3r.short[i2c]-Bus ist von der Definition her recht einfach, aber auch recht störanfällig @i2c-disturbance. Wie man erkennen kann, werden pro Frame insgesamt 16 Bits an Nutzdaten übertragen. Dazu gibt es keinen Mechanismus zur Erkennenung von Übertragungsfehlern, nur ACK/NACK Bits, ob Bits überhaupt angekommen sind.

Um dieses Problem zu lösen wird über die #htl3r.short[i2c]-Kommunikation zwischen RaspberryPi und ESP32 eine weitere Kommunikationsschicht erstellt. Beispiel aus der Netzwerktechnik: Frames der OSI-Schicht zwei übertragen in ihren Nutzdaten alle Bits der Packets auf OSI-Schicht drei, somit bildet #htl3r.short[i2c] die quasi Unterschicht und das Custom-Fenrir-Protokoll die Oberschicht.

#htl3r.fspace(
  [
    #figure(
      image("../assets/custom_i2c_frame_fenrir.svg"),
      caption: [Das "Fenrir"-Frame-Format]
    )
    <fenrir-frame>
  ]
)

Die Länge des "Fenrir"-Frames wurde trotz lediglich 2 Bytes an benötigten Nutzdaten bewusst auf 16 Bytes gesetzt (somit max. 12 Bytes an Nutzdaten), da die AdaFruit-SMBus-Library immer auf eine Datenmenge von 128 Bits (= 16 Bytes) wartet, bevor sie diese weiterverarbeitet. @esp32-meets-rpi[comp]
// ggf auch folgendes zitieren: https://adafruit-pureio.readthedocs.io/en/latest/api.html#Adafruit_PureIO.smbus.SMBus

Wie in @fenrir-frame zu erkennen ist, besitzt der Frame abgesehen von Nutzdaten auch einen Frame-Start-Fixwert von ```0x02```, eine Angabe der Frame-Länge in Bytes TODO, eine #htl3r.short[crc]8-Prüfsumme der Nutzdaten-Bits und einen Frame-End-Fixwert von ```0x04```.

Die #htl3r.short[crc]8-Prüfsumme der Nutzdaten-Bits wird auf dem RaspberryPi mittels Python folgend berechnet:

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

Das ganze findet klarerweise auch auf der Slave-Seite statt, dort ist der #htl3r.short[crc]8-Code jedoch in C implementiert worden.

=== Integration in OpenPLC

OpenPLC Version drei basiert auf dem Busprotokoll Modbus bzw. Modbus-TCP. Somit kann nicht ohne weitere Konfiguration ein Gerät mittels #htl3r.short[i2c] oder einem anderen Busprotokoll mit OpenPLC verbunden und automatisch erkannt werden. Mit dem #htl3r.short[psm] von OpenPLC (siehe OpenPLC -> PSM Kapitel TODO) lassen sich software-defined Modbus-Register erstellen, welchen die über den #htl3r.short[i2c]-Bus erhaltenen Daten des ESP32 enthalten.

Bevor die Daten per #htl3r.short[psm] gemappt werden können, müssen sie zuerst empfangen und dekodiert werden. Dazu wird folgende Python-Funktion verwendet:

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

Die Adafruit-SMBus-Library bietet die Methode ```.read_bytes()``` an, um von einer zuvor mit ```bus = SMBus(1)``` deklarierten #htl3r.short[i2c]/SMBus-Leitung die Nutzdaten der #htl3r.short[i2c]-Frames zu lesen. Diese werden dem selbstgeschriebenen #htl3r.short[i2c]-Decoder übergeben, damit dieser aus den #htl3r.short[i2c]-Rohnutzdaten den "Fenrir"-Frame rekonstruieren und somit die gewünschten Nutzdaten (Füllstandsmesswerte) inklusive Prüfsumme gewinnen kann.

Um die Werte vom ESP32 zu erhalten, welcher ein #htl3r.short[i2c]-Slave-Gerät ist, muss der RaspberryPi als #htl3r.short[i2c]-Master-Gerät zuerst eine Nachricht an den Slave schicken, dass dieser überhaupt mit dem Füllstandsdaten antwortet. Dies wird mit folgender Python-Funktion gemacht:

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

Beide Funktionen nehmen als ersten Parameter die #htl3r.short[i2c]-Adresse des gewünschten ESP32 bzw. #htl3r.short[i2c]-Slave-Gerätes. In diesem Fall wird nur ein einzelner ESP32 (Slave-Adresse: ```0x21```) verwendet, falls jedoch mehrere Geräte auf dem #htl3r.short[i2c]-Bus angeschlossen wären könnten unterschiedliche Adressen mitgegeben werden, um jeweils nur die gewünschten Geräte anzusteuern.

Einen Zweidrahtbus aufzubauen und mit dem #htl3r.short[i2c]-Protokoll zu verwenden ist für eine simple peer-to-peer Kommunikation tatsächlich eine unnötig überkomplizierte Umsetzung. Es sprechen jedoch trotzdem mehrere Gründe dafür, diese Umsetzungsart im Vergleich zu einer Kommunikation über z.B. #htl3r.short[uart] zu realisieren:
- #htl3r.short[i2c] ist ein weitverbreitetes Busprotokoll und dient als guter Kontrast zum komplizierteren Modbus-Protokoll.
- Bei Bedarf kann ein weiterer ESP32 oder ein anderes #htl3r.short[i2c]-Slave-Gerät angeschlossen werden und es müssen nur die bereits programmierten Funktion erneut aufgerufen werden.

Um die über einen #htl3r.short[i2c]-Bus erhaltenen Daten in OpenPLC auf einem RaspberryPi einsetzen zu können, müssen diese über das #htl3r.short[psm] (siehe OpenPLC PSM) auf eine #htl3r.short[sps]-Hardwareadresse gemappt werden. Beispielsweise kann der erste vom ESP32 erhaltenene Wert auf die Hardwareadresse ```%IW2``` gemappt werden:
#htl3r.code(caption: "PSM-Mapping einer SPS-Hardwareadresse", description: none)[
```Python
data: list[int] = read_from_esp32(ESP_I2C_address, 32)
psm.set_var("IW2", data[0])
```
]

Nun kann die #htl3r.short[sps]-Hardwareadresse ```%IW2``` in einem #htl3r.short[sps]-Programm mit einer Input-Variable verknüpft und verwendet werden:

#htl3r.fspace(
  [
    #figure(
      image("../assets/openplc_vars.png", width: 115%),
      caption: [Alle Variablen der OpenPLC-SPS]
    )
    <openplc-vars>
  ]
)

Im Screenshot von @openplc-vars sind alle Variablen der OpenPLC-#htl3r.short[sps] in Zelle Zwei zu sehen, darunter auch die Variable ``` TANK_1_LEVEL```, welche zuvor per #htl3r.short[psm] aus Python in eine Hardwareadresse geladen worden ist.

#htl3r.fspace(
  figure(
    image("../assets/openplc_tank_comp.png", width: 50%),
    caption: [Einsatz der PSM-gemappten Hardwareadresse ```%IW2``` als ``` TANK_1_LEVEL``` in der SPS-Logik]
  )
)
