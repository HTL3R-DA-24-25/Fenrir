# Programmierung eines I2C-Kommunikationsbusses

Um einen Kommunikationskanal zwischen der Software SPS (OpenPLC) auf dem RaspberryPi und dem Analogdigitalwandler ESP32 für die Füllstandssensoren herzustellen, wird der ein Zweidrahtbussystem mit dem Protokoll I2C verwendet.

## I2C Überblick

Kurz für "'\acrlong{i2c}"'. \acrshort{i2c} ist ein 1982 von Philips Semiconductors entwickelter serieller Datenbus, der als Master-Slave-Bus konzipiert ist, aber auch das Multi-Master-Prinzip unterstützt. Bei diesem Protokoll werden zwei Signalleitungen benötigt, eine Takt- und eine Datenleitung. Eine Eigenschaft von \acrshort{i2c} ist die Tatsache, dass ein Mikrocontroller ein ganzes Netzwerk an integrierten Schaltungen mit nur zwei \acrshort{io}-Pins und einfacher Software kontrollieren kann. Daher wird \acrshort{i2c} hauptsächlich geräteintern für die Kommunikation zwischen verschiedenen Schaltungsteilen benutzt, zum Beispiel innerhalb eines Fernsehers.

Im PC wird ein dem I2C-Bus sehr ähnliches System benutzt, um z.B. die Daten eines SDRAM-Modules auszulesen. Dieser nennt sich SMBus (System Management Bus).

--> https://www.mikrocontroller.net/articles/I%C2%B2C

## Aufbau

** INSERT BILD HERE **

## Kodierung

Bei der Datenübertragungen über einen I2C-Bus wird folgendes Frame-Format verwendet:

** INSERT BILD HERE **

Das Protokoll des I²C-Bus ist von der Definition her recht einfach, aber auch recht störanfällig[(https://repo.uni-hannover.de/items/3e39f8b0-b3a8-47b9-bc70-af4c513f37c9)]. Wie man erkennen kann, werden pro Frame insgesamt 16 Bits an Nutzdaten übertragen. Dazu gibt es keinen Mechanismus zur Erkennenung von Übertragungsfehlern, nur ACK/NACK Bits, ob Bits überhaupt angekommen sind. 

Um dieses Problem zu lösen wird über die I2C-Kommunikation zwischen RaspberryPi und ESP32 eine weitere Kommunikationsschicht erstellt. Beispiel aus der Netzwerktechnik: Frames der OSI-Schicht 2 übertragen in ihren Nutzdaten alle Bits der Packets auf OSI-Schicht 3, somit bildet I2C die quasi Unterschicht und das Custom-Fenrir-Protokoll die Oberschicht.

** INSERT BILD HERE **

Die Länge des Fenrir-Frames wurde trotz lediglich 2 Bits an benötigten Nutzdaten bewusst auf 128 Bits gesetzt (somit max. 124 Bits an Nutzdaten), da die AdaFruit-SMBus-Library immer auf eine Datenmenge von 128 Bits wartet, bevor sie diese weiterverarbeitet. FACT CHECK PLS

frame start, length, data + buffer, fsdfgswgr

Die CRC8-Prüfsumme der Nutzdaten-Bits wird auf dem RaspberryPi mittels Python folgend berechnet:

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

Das ganze findet klarerweise auch auf der Slave-Seite statt, dort ist der CRC8-Code jedoch in C implementiert worden.

## Integrierung in OpenPLC

OpenPLC Version 3 basiert auf dem Busprotokoll Modbus bzw. Modbus-TCP. Somit kann nicht ohne weitere Konfiguration ein Gerät mittels I2C oder einem anderen Busprotokoll mit OpenPLC verbunden und automatisch erkannt werden. Mit dem PSM von OpenPLC (siehe OpenPLC -> PSM Kapitel TODO) lassen sich software-defined Modbus-Register schnitzen, welchen die über den I2C-Bus erhaltenen Daten des ESP32 enthalten.

Bevor die Daten per PSM gemappt werden können, müssen sie zuerst empfangen und dekodiert werden. Dazu wird folgende Python-Funktion verwendet:

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

Die Adafruit-SMBus-Library bietet die Methode ```.read_bytes()``` an, um von einer zuvor mit ```bus = SMBus(1)``` deklarierten I2C/SMBus-Leitung die Nutzdaten der I2C-Frames zu lesen. Diese werden dem selbstgeschriebenen I2C-Decoder übergeben, damit dieser aus den I2C-Rohnutzdaten den Fenrir-Frame rekonstruieren und somit die gewünschten Nutzdaten (Füllstandsmesswerte) inklusive Prüfsumme gewinnen kann.

Um die Werte vom ESP32 zu erhalten, welcher ein I2C-Slave-Gerät ist, muss der RaspberryPi als I2C-Master-Gerät zuerst eine Nachricht an den Slave schicken, dass dieser überhaupt mit dem Füllstandsdaten antwortet. Dies wird mit folgender Python-Funktion gemacht:

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

Beide Funktionen nehmen als ersten Parameter die I2C-Adresse des gewünschten ESP32 bzw. I2C-Slave-Gerätes. In diesem Fall wird nur ein einzelner ESP32 (Slave-Adresse: ```0x21```) verwendet, falls jedoch mehrere Geräte auf dem I2C-Bus angeschlossen wären könnten unterschiedliche Adressen mitgegeben werden, um jeweils nur die gewünschten Geräte anzusteuern.

Einen Zweidrahtbus aufbauen und mit dem I2C-Protokoll verwenden ist für eine simple peer-to-peer Kommunikation tatsächlich eine unnötig überkomplizierte Umsetzung. Es sprechen jedoch trotzdem mehrere Gründe für diese Umsetzungsart im Vergleich zu einer Kommunikation über UART z.B.:
- I2C ist ein weitverbreitetes Busprotokoll und dient als guter Kontrast zum komplizierteren Modbus-Protokoll
- Bei Bedarf kann ein weiterer ESP32 oder ein anderes I2C-Slave-Gerät angeschlossen werden und es müssen nur die bereits programmierten Funktion erneut aufgerufen werden
- noch ein grund :^)


