#import "@local/htl3r-da:0.1.0" as htl3r

#show: htl3r.diplomarbeit.with(
  titel: "Fenrir",
  titel_zusatz: "Zum Schutz von OT-Netzwerken",
  abteilung: "ITN",
  schuljahr: "2024/2025",
  autoren: (
    (name: "Julian Burger", betreuung: "Christian Schöndorfer", rolle: "Mitarbeiter"),
    (name: "David Koch", betreuung: "Christian Schöndorfer", rolle: "Projektleiter"),
    (name: "Bastian Uhlig", betreuung: "Clemens Kussbach", rolle: "Stv. Projektleiter"),
    (name: "Gabriel Vogler", betreuung: "Clemens Kussbach", rolle: "Mitarbeiter"),
  ),
  betreuer_inkl_titel: (
    "Prof, Dipl.-Ing. Christian Schöndorfer",
    "Prof, Dipl.-Ing. Clemens Kussbach",
  ),
  sponsoren: (
    "easyname GmbH",
    "Fortinet Austria GmbH",
    "IKARUS Security Software GmbH",
    "Nozomi Networks Inc.",
    "Cyber Security Austria – Verein zur Förderung der Sicherheit Österreichs strategischer Infrastruktur",
    "NTS Netzwerk Telekom Service AG",
  ),
  kurzfassung_text: [#lorem(180)],
  abstract_text: [#lorem(180)],
  datum: datetime.today(),
  druck_referenz: true,
  generative_ki_tools_klausel: none,
  abkuerzungen: (
    (abbr: "YAML", langform: [YAML Ain't Markup Language], bedeutung: [Eine menschlichlesbare strukturierte Textdatei, welche Daten beinhaltet.
      Wird oft zur konfiguration eingesetzt]),
    (abbr: "IaC", langform: [Infrastructure as Code], bedeutung: [Die Abbildung der Physischen und Virtuellen Infrastruktur als Datenstruktur
      oder auch Code.]),
    (abbr: "DVS", langform: [Distributed Virtual Switch], bedeutung: [Ein virtueller Switch welcher in einer vSphere-Umgebung mehreren Hosts
      zugewiesen sein kann. Dies ermöglicht es VMs auf mehrere Hosts zu verteilen und sie dennoch in dasselbe Netzwerk zu hängen, dieser virtuelle
      Switch dient zur verwaltung der Uplinks auf den jeweiligen Hosts.]),
    (abbr: "DPG", langform: [Distributed Port Group], bedeutung: [Ein virtuelles Netzwerksegment welches einem DVS zugewiesen werden kann.
      Dieses Netzwerksegment wird den VMs, welche über mehrere Hosts verteilt sein können, zugewiesen um somit ein LAN über mehrere Hosts zu schaffen.]),
    (abbr: "DHCP", langform: [Dynamic Host Configuration Protocol], bedeutung: [Ein Protokoll welches oft benutzt wird um dynamisch IP-Adressen über das
      Netzwerk zu verteilen.]),
    (abbr: "UUID", langform: [Universally Unique Identifier], bedeutung: [Eine Identifikationsnummer, welche Global nur ein einziges mal existiert.]),
    (abbr: "API", langform: [Application Programing Interface], bedeutung: [Eine Schnittstelle die eine Kommunikation zwischen Software ermöglicht.]),
    (abbr: "VM", langform: [Virtual Machine], bedeutung: none),
    (abbr: "IT", langform: [Informational Technology], bedeutung: none),
    (abbr: "OT", langform: [Operational Technology], bedeutung: none),
    (abbr: "LAN", langform: [Local Area Network], bedeutung: none),
    (abbr: "VLAN", langform: [Virtual Local Area Network], bedeutung: none),
    (abbr: "AD", langform: [Active Directory], bedeutung: none),
    (abbr: "ADDC", langform: [Active Directory Domain Controller], bedeutung: none),
    (abbr: "I2C", langform: [Inter-Integrated Circuit], bedeutung: [Ein Zweidraht-Datenbus mit Master-Slave-Konzept.]), // TODO: burger mach die abkürzungsaliase unterschiedlich zu den abkürzungen selbst
    (abbr: "IO", langform: [Input/Output], bedeutung: none),
    (abbr: "GAU", langform: [Größter Anzunehmender Unfall], bedeutung: none),
    (abbr: "SPS", langform: [Speicherprogrammierbare Steuerung], bedeutung: none),
    (abbr: "CRC", langform: [Cyclic Redundancy Check], bedeutung: none),
    (abbr: "PSM", langform: [Python Submodule (for OpenPLC)], bedeutung: none),
    (abbr: "DMZ", langform: [Demilitarisierte Zone], bedeutung: [Ein eigenes Netzwerk für Dienste, die aus dem Internet zugänglich sind und vom internen Netz abgetrennt sind, um die Sicherheit zu erhöhen. Die Trennung der Netze erfolgt durch zwei Firewalls. TODO: ÄNDERN WEIL YGGDRASSIL KOPIE]),
    (abbr: "SCADA", langform: [Supervisory Control and Data Acquisition], bedeutung: none),
    (abbr: "UART", langform: [Universal Asynchronous Receiver Transmitter], bedeutung: none),
    (abbr: "ICS", langform: [Industrial Control System], bedeutung: none),
  ),
  literatur: bibliography("refs.yml", full: true, title: [Literaturverzeichnis], style: "harvard-cite-them-right"),
)

= Vorwort
#htl3r.author("David Koch")

Die politische Lage der Welt spitzt sich zu, Angriffe auf kritische Infrastruktur nehmen zu. Immer mehr staatliche Akteure versuchen, die kritischen Industrie- sowie Infrastrukturdienste ihrer Feinde anzugreifen, und sind zu oft dabei erfolgreich, da die Absicherung des Übergangs zwischen #htl3r.abbr[IT]- und #htl3r.abbr[OT]-Netzwerken im Betrieb häufig suboptimal ist.

blablabal

Das Bewusstsein und der Wunsch nach einer gegen Cyberangriffe sicheren physischen Infrastruktur sollte auch in der allgemeinen Bevölkerung gestärkt werden. Mit unserer Modell-Kläranlage und den eigenen Angriffen darauf möchten wir zeigen, dass mangelnde #htl3r.abbr[OT]-Security zu "echten" Schäden führen kann – sei es ein überschaubarer Wasserschaden bei unserer Kläranlage oder Millionenschäden durch kaputte Hochöfen oder überhitzte Kühlsysteme von Kraftwerken. Zusätzlich soll unsere Dokumentation des Absicherungsprozesses als Literaturverzeichnis von "Dos" und "Dont's" für angehende #htl3r.abbr[OT]-Security-Expert*innen oder für interessierte Personen, die sich mit dem Thema auseinandersetzen möchten, dienen.

blablabla

== Danksagung

Die Planung, Umsetzung und Präsentation der Diplomarbeit Fenrir wäre ohne weitere Unterstützung in dieser Form nicht möglich gewesen. Das Diplomarbeitsteam bedankt sich herzlich bei allen natürlichen als auch juristischen Personen, die das Projekt durch ihre fachliche und/oder finanzielle Unterstützung das Projekt gefördert haben und es zu der Diplomarbeit gemacht haben, die sie letztendlich geworden ist.

HTL Rennweg
Schöni + Kussi
INNKOO
Atropos + 3BB
Yggdrassil (Stefan Tomp)

Des weiteren hat die tatkräftige Unterstützung externer Firmenpartner und deren Vertretern die Umsetzung und generelle Industrienähe der Diplomarbeit erlaubt. 
easyname, CSA, Fortinet, Ikarus, Nozomi Networks und NTS 
Herbert Dirnberger shoutout

= Topologie
#htl3r.author("Alle?")

#lorem(100)

== Logische Topologie

#lorem(100)

#htl3r.fspace(
  figure(
    image("assets/topology_logical.svg"),
    caption: [Die Projekttopologie in logischer Darstellung]
  )
)

== Physische Topologie

#lorem(100)

** BILD topo **
** BILD schrank bzw schränke **

=== OT-Bereich

Der OT-Bereich besteht aus einem von uns selbst gebauten Modell einer Kläranlage. Diese setzt sich aus einer archimedischen Schraube, einem Rechen, Wassertanks, Filtern, einem Staudamm und Pumpen zusammen. Diese Gegenstände sind mit verbauter Aktorik und/oder Sensorik ausgestattet und dienen als Ansteuerungsziele mehrerer #htl3r.abbr[SPS]. Diese werden nach Aufbau auch als Angriffsziele verwendet, wobei ein Angreifer beispielsweise die Pumpen komplett lahmlegen oder durch deren Manipulation einen Wasserschaden verursachen könnte.

** BILD topo **
** BILD Kläranlage **

Die Details bezüglich dem Aufbau der Modell-Kläranlage und der dazugehörigen #htl3r.abbr[OT]-Gerätschaft siehe >Aufbau der Modell-Kläranlage<

== Purdue-Modell

Das Purdue-Modell (auch bekannt als "Purdue Enterprise Reference Architecture", kurz PERA), ähnlich zum OSI-Schichtenmodell, dient zur Einteilung bzw. Segmentierung eines #htl3r.abbr[ICS]-Netzwerks. Je niedriger die Ebene, desto kritischer sind die Prozesskontrollsysteme, und desto strenger sollten die Sicherheitsmaßnahmen sein, um auf diese zugreifen zu können. Die Komponenten der niedrigeren Ebenen werden jeweils von Systemen auf höhergelegenen Ebenen angesteuert.

Level 0 bis 3 gehören zur #htl3r.abbr[OT], 4 bis 5 sind Teil der #htl3r.abbr[IT].
Es gibt nicht nur ganzzahlige Ebenen, denn im Falle einer #htl3r.abbr[DMZ] zwischen beispielsweise den Ebenen 2 und 3 wird diese als Ebene 2.5 gekennzeichnet.

FENRIR PURDUE SUPER TOLL:

#htl3r.fspace(
  figure(
    image("assets/fenrir_purdue.svg"),
    caption: [Die Projekttopologie im Purdue-Modell]
  )
)

= Aufbau der Modell-Kläranlage
#htl3r.author("David Koch")

Wieso Kläranlage?
https://www.nozominetworks.com/blog/cisa-warns-of-pro-russia-hacktivist-ot-attacks-on-water-wastewater-sector?utm_source=linkedin&utm_medium=social&utm_term=nozomi+networks&utm_content=281b8432-049c-435e-805a-ea5872a057eb

Um die Absicherung eines Produktionsbetriebes oder eines Stücks kritischer Infrastruktur ausreichend dokumentieren zu können, kann sich nicht auf ausschließlich virtualisierte Lösungen des #htl3r.abbr[OT]-Netzwerks verlassen werden. Dazu ist das Ausmaß eines Super-#htl3r.abbr[GAU]s innerhalb eines virtualisierten #htl3r.abbr[OT]-Netzwerks nicht begreifbar/realistisch für die meisten aussenstehenden Personen. Es braucht eine angreifbare und physisch vorhandene Lösung: eine selbstgemachte Modell-Kläranlage.

== Planung der Betriebszellen

Wieso unterteilen in Betriebszellen?
tipp: security lol

Um die Sicherheit der #htl3r.abbr[OT]-Komponenten so weit es geht zu gewährleisten, muss bereits bei der Planung der Anlage die Segmentierung in Betriebszellen in Betracht gezogen werden.
Der Inhalt einer Betriebszelle soll nur untereinander kommunizieren können, die einzige Ausnahme wäre beispielsweise die Kommunikation mit einem SCADA-System auf der nächst-höheren Purdue-Ebene. Eine solche Segmentierung lässt sich somit quasi mit einer #htl3r.abbr[VLAN]-Segmentierung in einem #htl3r.abbr[IT]-Netzwerk vergleichen.

Unter anderem lässt sich durch eine physische Segmentierung der Kläranlage diese leicht ab- und wieder aufbauen. Wären alle Betriebszellen auf einer einzelnen Platte untergebracht, wäre diese ca 160x45cm groß und somit sehr unhandlich zu transportieren.

== Zelle 1 (Vorbearbeitung)

=== Aufbau

Als erster Schritt zur erfolgreichen Abwasserfiltration braucht es einen Weg, grobe Schmutzpartikel wie zum Beispiel Kieselsteine filtrieren zu können. Einen feinen Wasserfilter würden solche großen Partikel verstopfen oder sogar zerstören, noch dazu erlaubt der Aufbau mit herkömmlichen AAAA. Somit erfolgt die erste Filtration mit einem gröberen Metallgitter als Rechen.

Um das Abwasser zu rechen, wird es zuerst mit einer archimedischen Schraube in einen höhergelegenen Behälter geschraubt, welcher angewinkelt ist und am unteren Ende eine Öffnung hat. Diese Öffnung lässt das hochgeschraubte Wasser durch das Rechengitter fallen, was die groben Partikel wie zum Beispiel Kieselsteine aus dem Abwasser entfernt. Das restliche Abwasser fließt durch das Gitte durch und landet in einem Auffangbehälter, welcher der Anfang der Leitung in die zweite Zelle ist.

=== Schaltplan

** BILD **

=== Steuerungstechnik

Aktorik:
- Schneckenmotor mit 50 RPM

Sensorik:
- keine?

== Zelle 2 (Filtration)

=== Aufbau

Die zweite Betriebszelle dient der Feinfiltration des bereits grobfiltrierten Abwassers aus der ersten Zelle. Die feinen im Abwasser aufgelösten Schmutzpartikel, die in der ersten Zelle nicht durch den Rechen entfernt worden konnten, werden hier endgültig aus dem Abwassser entfernt. Nach der zweiten Zelle ist das Abwasser klar und ohne jeglich Verfärbungen und kann sicher in die Natur (Zelle 3) abgepumpt werden.

Besteht aus zwei durchsichtigen Acryl-Wassertanks welche jeweils ca. 3L an Volumen aufweisen. Diese sind oben offen, werden jedoch von Deckeln abgedeckt. Diese Deckel wurden speziell angefertigt mittels 3D-Modellierung und darauf zweimal gedruckt. In diesen Deckeln ist die für den Wassertank jeweils notwendige Sensorik verbaut, diese besteht aus einem kapazitiven Füllstandssensor als auch einem Temperatursensor.

Zwischen den Tanks befindet sich ein herkömmlicher Gartenpumpenfilter mit Filterball als auch eine Pumpe, die die Flüssigkeiten von einem Tank in den Nächsten durch den Filter hindurch transporiert.
** BILD **

=== Schaltplan

#htl3r.fspace(
  figure(
    image("assets/Zelle_2_Schaltplan.png"),
    caption: [Schaltplan der 2. Betriebszelle]
  )
)

=== Steuerungstechnik

Im Vergleich zu den anderen zwei Zellen wird in dieser eine Software-#htl3r.abbr[SPS] eingesetzt: Die OpenPLC v3. Diese läuft auf einem Raspberry Pi 4 Mikrocomputer.

Aktorik:
- Gartenpumpe mit 800L/h Durchsatz (mit eigenem 12V Relais)

Sensorik:
- 2x OneWire DS18B20 Temperatursensor
- 2x Füllstandssensor (Widerstand mit 0-190 Ohm)

== Zelle 3 (Staudamm)

=== Aufbau

Nach der erfolgreichen Filtration des Abwassers wird dies von der zweiten Zelle in einen Staudamm-Behälter umgepumpt. Dieser hält das Wasser durch ein geschlossenes Magnetventil zurück, um ein aus Pappmaschee, Lackfarbe und Epoxidharz modelliertes vor Überschwemmung zu schützen.

Das Überschwemmungsgebiet ist mit kleinen Modell-Bäumen und 3D-gedruckten roten Häusern unterschiedlicher Größe bestückt. Unter anderem sind mehrere Wasserstandsensoren an der Seite des Behälters befestigt, um im Falle eines Hochwasser bzw. einer Überschwemmung einen Alarm auszulösen (Leuchte mit Alarmton neben dem Behälter).
** BILD **

=== Schaltplan

** BILD **

=== Steuerungstechnik

Aktorik:
- Magnetventil
- Alarmleuchte (+ Ton)

Sensorik:
- 2x Überschwemmungssensor

== Programmierung eines I2C-Kommunikationsbusses

Um einen Kommunikationskanal zwischen der Software-#htl3r.abbr[SPS] (OpenPLC) auf dem RaspberryPi und dem Analogdigitalwandler ESP32 für die Füllstandssensoren herzustellen, wird der ein Zweidrahtbussystem mit dem Protokoll #htl3r.abbr[I2C] verwendet.

=== I2C Überblick

Kurz für "Inter-Integrated Circuit". #htl3r.abbr[I2C] ist ein 1982 von Philips Semiconductors entwickelter serieller Datenbus, der als Master-Slave-Bus konzipiert ist, aber auch das Multi-Master-Prinzip unterstützt. Bei diesem Protokoll werden zwei Signalleitungen benötigt, eine Takt- und eine Datenleitung. Eine Eigenschaft von #htl3r.abbr[I2C] ist die Tatsache, dass ein Mikrocontroller ein ganzes Netzwerk an integrierten Schaltungen mit nur zwei #htl3r.abbr[IO]-Pins und einfacher Software kontrollieren kann. Daher wird #htl3r.abbr[I2C] hauptsächlich geräteintern für die Kommunikation zwischen verschiedenen Schaltungsteilen benutzt, zum Beispiel innerhalb eines Fernsehers.

Im PC wird ein dem #htl3r.abbr[I2C]-Bus sehr ähnliches System benutzt, um z.B. die Daten eines SDRAM-Modules auszulesen. Dieser nennt sich SMBus (System Management Bus).

--> https://www.mikrocontroller.net/articles/I%C2%B2C

=== Aufbau

#htl3r.fspace(
  figure(
    image("assets/rpi_esp32_i2c_fenrir.svg"),
    caption: [Der Kommunikationsaufbau zwischen RPI, ESP32 und Sensorik]
  )
)

=== Kodierung

Bei der Datenübertragungen über einen #htl3r.abbr[I2C]-Bus wird folgendes Frame-Format verwendet:

#htl3r.fspace(
  figure(
    image("assets/i2c_standard_frame.png"),
    caption: [Das #htl3r.abbr[I2C]-Frame-Format]
  )
)

Das Protokoll des #htl3r.abbr[I2C]-Bus ist von der Definition her recht einfach, aber auch recht störanfällig[(https://repo.uni-hannover.de/items/3e39f8b0-b3a8-47b9-bc70-af4c513f37c9)]. Wie man erkennen kann, werden pro Frame insgesamt 16 Bits an Nutzdaten übertragen. Dazu gibt es keinen Mechanismus zur Erkennenung von Übertragungsfehlern, nur ACK/NACK Bits, ob Bits überhaupt angekommen sind. 

Um dieses Problem zu lösen wird über die #htl3r.abbr[I2C]-Kommunikation zwischen RaspberryPi und ESP32 eine weitere Kommunikationsschicht erstellt. Beispiel aus der Netzwerktechnik: Frames der OSI-Schicht 2 übertragen in ihren Nutzdaten alle Bits der Packets auf OSI-Schicht 3, somit bildet #htl3r.abbr[I2C] die quasi Unterschicht und das Custom-Fenrir-Protokoll die Oberschicht.

#htl3r.fspace(
  figure(
    image("assets/custom_i2c_frame_fenrir.svg"),
    caption: [Das Fenrir-Frame-Format]
  )
)

Die Länge des Fenrir-Frames wurde trotz lediglich 2 Bits an benötigten Nutzdaten bewusst auf 128 Bits gesetzt (somit max. 124 Bits an Nutzdaten), da die AdaFruit-SMBus-Library immer auf eine Datenmenge von 128 Bits wartet, bevor sie diese weiterverarbeitet. FACT CHECK PLS

frame start, length, data + buffer, fsdfgswgr

Die #htl3r.abbr[CRC]8-Prüfsumme der Nutzdaten-Bits wird auf dem RaspberryPi mittels Python folgend berechnet:

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

Das ganze findet klarerweise auch auf der Slave-Seite statt, dort ist der #htl3r.abbr[CRC]8-Code jedoch in C implementiert worden.

=== Integration in OpenPLC

OpenPLC Version 3 basiert auf dem Busprotokoll Modbus bzw. Modbus-TCP. Somit kann nicht ohne weitere Konfiguration ein Gerät mittels #htl3r.abbr[I2C] oder einem anderen Busprotokoll mit OpenPLC verbunden und automatisch erkannt werden. Mit dem #htl3r.abbr[PSM] von OpenPLC (siehe OpenPLC -> PSM Kapitel TODO) lassen sich software-defined Modbus-Register schnitzen, welchen die über den #htl3r.abbr[I2C]-Bus erhaltenen Daten des ESP32 enthalten.

Bevor die Daten per #htl3r.abbr[PSM] gemappt werden können, müssen sie zuerst empfangen und dekodiert werden. Dazu wird folgende Python-Funktion verwendet:

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

Die Adafruit-SMBus-Library bietet die Methode ```.read_bytes()``` an, um von einer zuvor mit ```bus = SMBus(1)``` deklarierten #htl3r.abbr[I2C]/SMBus-Leitung die Nutzdaten der #htl3r.abbr[I2C]-Frames zu lesen. Diese werden dem selbstgeschriebenen #htl3r.abbr[I2C]-Decoder übergeben, damit dieser aus den #htl3r.abbr[I2C]-Rohnutzdaten den Fenrir-Frame rekonstruieren und somit die gewünschten Nutzdaten (Füllstandsmesswerte) inklusive Prüfsumme gewinnen kann.

Um die Werte vom ESP32 zu erhalten, welcher ein #htl3r.abbr[I2C]-Slave-Gerät ist, muss der RaspberryPi als #htl3r.abbr[I2C]-Master-Gerät zuerst eine Nachricht an den Slave schicken, dass dieser überhaupt mit dem Füllstandsdaten antwortet. Dies wird mit folgender Python-Funktion gemacht:

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

Beide Funktionen nehmen als ersten Parameter die #htl3r.abbr[I2C]-Adresse des gewünschten ESP32 bzw. #htl3r.abbr[I2C]-Slave-Gerätes. In diesem Fall wird nur ein einzelner ESP32 (Slave-Adresse: ```0x21```) verwendet, falls jedoch mehrere Geräte auf dem #htl3r.abbr[I2C]-Bus angeschlossen wären könnten unterschiedliche Adressen mitgegeben werden, um jeweils nur die gewünschten Geräte anzusteuern.

Einen Zweidrahtbus aufbauen und mit dem #htl3r.abbr[I2C]-Protokoll verwenden ist für eine simple peer-to-peer Kommunikation tatsächlich eine unnötig überkomplizierte Umsetzung. Es sprechen jedoch trotzdem mehrere Gründe für diese Umsetzungsart im Vergleich zu einer Kommunikation über #htl3r.abbr[UART] z.B.:
- #htl3r.abbr[I2C] ist ein weitverbreitetes Busprotokoll und dient als guter Kontrast zum komplizierteren Modbus-Protokoll
- Bei Bedarf kann ein weiterer ESP32 oder ein anderes #htl3r.abbr[I2C]
- Slave-Gerät angeschlossen werden und es müssen nur die bereits programmierten Funktion erneut aufgerufen werden
- noch ein grund :^)

// TODO UMSCHREIBEN (alt und hässlich):
Um die über einen #htl3r.abbr[I2C]-Bus erhaltenen Daten in OpenPLC auf einem RaspberryPi einsetzen zu können, müssen diese über das #htl3r.abbr[PSM] (siehe OpenPLC PSM) auf eine #htl3r.abbr[SPS]-Hardwareadresse gemappt werden. Beispielsweise BLABLABAL IW2:
data: list[int] = read_from_esp32(ESP_I2C_address, 32)
psm.set_var("IW2", data[0])

Nun kann die #htl3r.abbr[SPS]-Hardwareadresse ```%IW2``` in einem #htl3r.abbr[SPS]-Programm mit einer Input-Variable verknüpft und somit verwendet werden:
** SCREEEEEENSHOTS, EDITOR + MONITORING? **


= Provisionierung und IaC
#htl3r.author("Julian Burger")

In der Industrie gibt es einen stetigen Trend, alles zu automatisieren. Eine Automatisierung der IT-Infrastruktur bringt ebenfalls Zeit- und Ressourcenersparnisse.
Diese Ersparnisse gilt es nicht zu vernachlässigen, demnach ist es das Ziel der Diplomarbeit, das gesamte IT-Netzwerk automatisch zu provisionieren und somit
zukunftssicher zu gestalten.

Automatische Provisionierung bedeutet, die gesamte oder auch nur Teile einer Firmen/Organisations-IT-Infrastruktur, sei es in physischer oder virtueller Form, ohne Eingriff von Personal
aufzusetzen. Um solch einen Prozess zu realisieren, wird meist eine Form von #htl3r.abbr[IaC] (= Infrastructure as Code) verwendet. Somit kann das Firmen/Organisations-Netzwerk und
dessen IT-Infrastruktur als strukturierte Datei oder auch als Code dargestellt werden.

Sollten somit Änderungen der bestehenden IT-Infrastruktur notwendig sein, so wird der #htl3r.abbr[IaC] Quelltext abgeändert und so angepasst, dass er den neuen
Anforderungen gerecht wird. Nun kann das verwendete Tool die Änderungen einlesen und ausrechnen, welche Änderungen bzw. welche Schritte eingeleitet werden müssen
um den Anforderungen, die definiert worden sind, gerecht zu werden. Diese Arbeitsschritte können jetzt ausgeführt werden, um den Änderungen gerecht zu werden.

== Verwendete Tools
Um den Anforderungen der Topologie gerecht zu werden, kommen mehrere Provisionierungs-Tools zum Einsatz:
#[
#set par(hanging-indent: 12pt)
- #strong[Packer:] Um mehrere Template-VMs, oder auch Golden-Images genannt, zu provisionieren.
- #strong[Terraform:] Um diese Template-VMs zu klonen und ihren Netzen so zuzuweisen, dass dies der Topologie entspricht.
- #strong[Ansible:] Um die mit Terraform provisionierten VMs zu konfigurieren oder auch benötigte Dateien bereitzustellen.
- #strong[pyVmomi:] Um besondere Änderungen in der vSphere-Umgebung zu tätigen, welche nicht von den anderen Tools unterstützt werden.
]
Um den gesamten Ablauf zu automatisieren, werden Bash-Skripts eingesetzt, welche das leichte Zusammenspiel der Software ermöglichen. So kann
Terraform Packer aufrufen, um die Template-VMs zu erzeugen, oder auch Ansible, um die VMs zu konfigurieren.

=== Packer
Packer, ein Produkt von HashiCorp, ermöglicht es, System-Images oder auch Container aus Code zu erzeugen. Dies ist nützlich, um Template-VMs in einer vSphere-Umgebung zu erstellen.
Damit dies jedoch möglich ist, braucht es das passende Packer-Plugin, dies ist in diesem Fall ```hcl "github.com/hashicorp/vsphere"```. Dieses Plugin kann wie folgt eingebunden werden:
#htl3r.code(caption: "Packer vSphere-Plugin einbindung", description: none)[
```hcl
packer {
  required_plugins {
    vsphere = {
      version = "~> 1"
      source = "github.com/hashicorp/vsphere"
    }
  }
}
```
]

Somit kann auf die ```hcl "vsphere-iso"``` Packer-Source zugegriffen werden. Dies ermöglicht es nun, eine VM in der vSphere-Umgebung zu provisionieren:
#htl3r.code_file(
  caption: "Packer vSphere-VM Beispiel",
  filename: [golden_linux_server/main.pkr.hcl],
  lang: "hcl",
  ranges: ((10, 19), (80, 80),),
  skips: ((19,0),),
  text: read("assets/scripts/golden_linux_server.pkr.hcl")
)

Durch das ```hcl convert_to_template = true``` im vorherigen Beispiel wird die VM automatisch nach Abschluss des Provisioniervorganges zu einer Template-VM umgewandelt
und kann dadurch direkt geklont werden.
#pagebreak()
Insgesamt werden 4 Template-VMs provisioniert, allerdings werden nur 3 davon in der Topologie, wie sie im physischen Netzplan sind, verwendet. Das extra Template ist eine
Bastion. Die Verwendung dieser wird im @prov-mit-bastion beschrieben. Die 3 restlichen Templates sind folgende:
#[
#set par(hanging-indent: 12pt)
- #strong[Linux Golden Image:] Template für alle Linux-Server in der Topologie. Hierbei wird Ubuntu-Server 24.04 verwendet.
- #strong[Windows Server Golden Image:] Template für alle Windows-Server in der Topologie. Hierbei wird Windows-Server 2022 verwendet.
- #strong[Windows Desktop Golden Image:] Template für alle Windows-Clients in der Topologie. Hierbei wird Windows 11 23H2 verwendet.
]
Das Linux-Server-Image wird mittels Cloud-Init, eine #emph["industry standard multi-distribution method for cross-platform cloud instance initialisation."] @ci-docs,
aufgesetzt. Cloud-Init liest eine gegebene #htl3r.abbr[YAML] Datei, im passenden Format, aus und konfiguriert aufgrund dessen den Server. Die Windows-Images werden ähnlich
aufgesetzt, jedoch wird eine ``` autounatend.xml``` Datei verwendet. Das Prinzip bleibt jedoch dasselbe.

=== Terraform
Terraform, ebenfalls ein Produkt von HashiCorp, ermöglicht es, die gesamte IT-Infrastruktur als Code darzustellen, dies beinhaltet VMs, #htl3r.abbrp[DVSs], #htl3r.abbrp[DPGs], etc. Allerdings existieren
gewisse Limitationen, da Terraform einen konvergenten Zustand gewährleisten muss. Damit dies jederzeit der Fall ist, ist es nicht möglich, zu jeder Zeit beliebig auf die definierten
Ressourcen zuzugreifen. Jedoch kann man gewisse "Create" und "Destroy" Provisioner definieren. So kann man Terraform mit anderen Tools integrieren.
Packer kann zum Beispiel beim Erstellen einer DPG aufgerufen werden und eine Template-VM erzeugen. So ähnlich wurde dies auch umgesetzt:
#htl3r.code_file(
  caption: "Terraform Bastion Provisionierung",
  filename: [stage_00/main.tf],
  lang: "tf",
  ranges: ((58, 63), (76, 80), (109, 113)),
  skips: ((63,0), (80, 0),),
  text: read("assets/scripts/stage_00.tf")
)

Dieser erzwungene konvergente Zustand hat jedoch, vor allem während der Entwicklung, Nachteile. Tritt ein Fehler während der Durchführung eines Erstellungsprozesses auf, so stoppt dies den Prozess und
Terraform zerstört alle bereits angelegten Ressourcen. Dies führt vor allem dann zu Frustration, wenn so ein Provisionierungsvorgang mehr als 30 Minuten andauert. Um dies zu umgehen, wird in sogenannten
"Stages" Provisioniert. Jede Stage ist abhängig von der Vorherigen, somit muss beispielsweise Stage 0 korrekt ausgeführt werden, damit Stage 1, in weiterer Folge, ausgeführt werden kann. Jede Stage ist
dafür verantwortlich zu beginnen einen Snapshot von allen Ressourcen zu machen, die für die Durchführung der Stage benötigt werden. So kann, falls die Stage fehlerhaft ausführt, zu dem vorherigen Stand
zurückgesprungen werden.

Solch ein Verfahren ist jedoch nicht allein mit Terraform möglich, da Terraform, falls ein Fehler auftritt, den erstellten Snapshot nur löscht und nicht auf diesen zurücksetzt. Somit werden alle
fehlerhafte Änderungen, welche von Skript-Provisionieren durchgeführt wurden, auf den vorherigen Stand übertragen. Damit solch eine Situation nicht auftritt, werden Destroy-Provisioner auf den Snapshots
konfiguriert:
#htl3r.code_file(
  caption: "Terraform Snapshot Destroy-Provisioner",
  filename: [stage_03/main.tf],
  lang: "tf",
  ranges: ((0, 6), (12, 16),),
  skips: ((6, 0),),
  text: read("assets/scripts/stage_03.tf")
)
#pagebreak()
Die von der Ressource gebrauchte ``` vm_uuids``` Variable ist in einer anderen Datei enthalten:
#htl3r.code_file(
  caption: "Terraform Snapshot Destroy-Provisioner VMs",
  filename: [stage_03/vms.tf],
  lang: "tf",
  text: read("assets/scripts/stage_03_vms.tf")
)
Terraform fragt mithilfe des Skriptes die #htl3r.abbrp[UUIDs] der ADDCs ab und befüllt mit ihnen die lokale Variable ``` vm_uuids```.

Um all dies zu ermöglichen, braucht Terraform den passenden Provider. Ein Terraform-Provider gibt an, wie mit einem gegebenen System zu interagieren ist. Durch einen Provider werden Ressourcen definiert
welche angelegt werden können und ebenso welche Daten abgefragt werden können. Um den Provider einzubinden, ist dieser zuerst zu definieren:
#htl3r.code(caption: "Terraform vSphere-Provider einbindung", description: none)[
```hcl
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.9.2"
    }
  }
}
```
]
Nachdem der Provider in einer Datei definiert ist, wird er automatisch, mit dem Befehl ```bash terraform init```, aus dem Terraform-Repository heruntergeladen. Nun müssen die Zugangsdaten von der
vSphere-Instanz an Terraform übermittelt werden:
#htl3r.code(caption: "Terraform vSphere-Provider definieren", description: none)[
```hcl
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_vcenter
  allow_unverified_ssl = true
  api_timeout          = 10
}
```
]
Die realen Zugangsdaten stehen in einer externen Datei, welche nicht Teil des Git-Repositorys ist.

=== Ansible
Ansible ist das dritte verwendete #htl3r.abbr[IaC] Tool, welches verwendet wird. Es ermöglicht es, Maschinen mittels Ansible-Playbooks zu konfigurieren. Diese Playbooks beinhalten mehrere Tasks, welche
ausgeführt werden. Diese Tasks können sehr komplex, jedoch auch sehr simpel sein. Ansible wird in der Topologie hauptsächlich für das Ausführen von Bash- und PowerShell-Skripten verwendet. Da oftmals
ein Neustart nach der Ausführung eines Befehls notwendig ist. Dies ist vor allem auf Windows-Servern ein bekanntes Problem. Terraform kann mit solchen Neustarts nicht umgehen, Ansible jedoch schon.

Die IPv4-Adressen der VMs im Managementnetzwerk sind oft unklar, denn sie werden über #htl3r.abbr[DHCP] bezogen. Demnach wird die IPv4-Adresse mittels Terraform ausgelesen und als Argument einem Bash-Skript
weiter gegeben. Dieses Bash-Skript erstellt nun ein Ansible-Inventory und führt das dazugehörige Ansible-Playbook aus. Die genaue Funktion des Managementnetzwerks ist in @prov-mit-bastion beschrieben. Der Ablauf von einem
Ansible aufruf sieht wie folgt aus:
#htl3r.code_file(
  caption: "Terraform Ansible Provisioning",
  filename: [stage_03/main.tf],
  range: (29, 43),
  lang: "tf",
  text: read("assets/scripts/stage_03.tf")
)
#htl3r.code_file(
  caption: "Ansible Execute Script",
  filename: [ansible/execute_stage_03.sh],
  range: (6, 21),
  lang: "bash",
  text: read("assets/scripts/stage_03_execute_script.sh")
)
#pagebreak()
#htl3r.code_file(
  caption: "Stage-03 Ansible-Playbook",
  filename: [ansible/playbooks/stages/stage_03/setup_dc_primary.yml],
  range: (0, 12),
  skips: ((12, 0),),
  lang: "yml",
  text: read("assets/scripts/setup_dc_primary.yml")
)
Der Grund, warum die ``` ansible_ssh_common_args``` Variable solch einen komplexen Inhalt hat, wird in @prov-mit-bastion beschrieben.

=== pyVmomi
Obwohl Packer, Terraform und Ansible ein sehr breites Spektrum abdecken, gibt es dennoch Limitationen. Um diese Limitationen zu umgehen, wird direkt auf die VMware-vSphere #htl3r.abbr[API] zurückgegriffen. Hierzu wird
pyVmomi verwendet, die offizielle Python-Bibliothek für vSphere. Mit pyVmomi ist es möglich, mit jeglicher Art von vSphere-Objekt zu interagieren. Es ist ebenfalls möglich, Parameter zu setzen, welche im
Web-GUI von vSphere nicht sichtbar sind. Der Anwendungszweck, welcher vom größten Interesse ist, ist das Setzen von Traffic-Filter Regeln auf #htl3r.abbrp[DPGs]. Dies ist in keinem der vorher genannten Tools
direkt möglich, allerdings ist es zwingend nötig, um das geplante Security-Konzept umzusetzen. Es soll kein Traffic zwischen Managed-VMs möglich sein, jedoch sollte sie trotzdem die Möglichkeit haben mit der Bastion zu
kommunizieren und DHCP-Requests zu verschicken. Hierzu nutzen wir folgende Traffic-Filter-Regeln:
#htl3r.fspace(
  figure(
    image("assets/filtering_rules.jpg"),
    caption: [Management Traffic-Filtering Regeln]
  )
)
#lorem(180)

== Provisionierung mittels Bastion <prov-mit-bastion>
#lorem(180)
