# Programmierung eines I2C-Kommunikationsbusses

Um einen Kommunikationskanal zwischen der Software SPS (OpenPLC) auf dem RaspberryPi und dem Analogdigitalwandler ESP32 für die Füllstandssensoren herzustellen, wird der ein Zweidrahtbussystem mit dem Protokoll I2C verwendet.

## I2C Überblick

** INSERT SVON I2C OVERVIEW HERE **

## Aufbau

** INSERT BILD HERE **

## Kodierung



## Integrierung in OpenPLC

OpenPLC Version 3 basiert auf dem Busprotokoll Modbus bzw. Modbus-TCP. Somit kann nicht ohne weitere Konfiguration ein Gerät mittels I2C oder einem anderen Busprotokoll mit OpenPLC verbunden und automatisch erkannt werden. Mit dem PSM von OpenPLC (siehe OpenPLC -> PSM Kapitel TODO) lassen sich software-defined Modbus-Register schnitzen, welchen die über den I2C-Bus erhaltenen Daten des ESP32 enthalten.

Bevor die Daten per PSM gemappt werden können, müssen sie zuerst empfangen und dekodiert werden. Dazu wird folgende Python-Funktion verwendet:

```Python
# read data from EPS32
def read_from_esp32(i2caddress: hex, size: int):
    decoder = I2C_Decoder()
    try:
        # get data sent by ESP32, in raw format.
        stream = bus.read_bytes(i2caddress, size)
        # convert to a list to ease handling
        data = decoder.write(stream)
        return data

    except Exception as e:
        print("ERROR: {}".format(e))
```

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
        print("{}".format(e))
```

Beide Funktionen nehmen als ersten Parameter die I2C-Adresse des gewünschten ESP32 bzw. I2C-Slave-Gerätes. In diesem Fall wird nur ein einzelner ESP32 (Slave-Adresse: ```0x21```) verwendet, falls jedoch mehrere Geräte auf dem I2C-Bus angeschlossen wären könnten unterschiedliche Adressen mitgegeben werden, um jeweils nur die gewünschten Geräte anzusteuern.

Einen Zweidrahtbus aufbauen und mit dem I2C-Protokoll verwenden ist für eine simple peer-to-peer Kommunikation tatsächlich eine unnötig überkomplizierte Umsetzung. Es sprechen jedoch trotzdem mehrere Gründe für diese Umsetzungsart im Vergleich zu einer Kommunikation über UART z.B.:
- I2C ist ein weitverbreitetes Busprotokoll und dient als guter Kontrast zum komplizierteren Modbus-Protokoll
- Bei Bedarf kann ein weiterer ESP32 oder ein anderes I2C-Slave-Gerät angeschlossen werden und es müssen nur die bereits programmierten Funktion erneut aufgerufen werden
- noch ein grund :^)


