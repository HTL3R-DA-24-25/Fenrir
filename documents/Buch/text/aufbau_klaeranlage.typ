#import "@preview/htl3r-da:0.1.0" as htl3r

= Aufbau der Modell-Kläranlage <aufbau-klaeranlage>

Um die Absicherung eines Produktionsbetriebs oder eines Stücks kritischer Infrastruktur ausreichend dokumentieren zu können, darf nicht ausschließlich auf virtualisierte Lösungen des #htl3r.short[ot]-Netzwerks vertraut werden. Dazu ist das Ausmaß eines "Super-#htl3r.short[gau]s" innerhalb eines virtualisierten #htl3r.short[ot]-Netzwerks für die meisten aussenstehenden Personen nicht begreifbar/realistisch genug. Eine selbstgebaute Modell-Kläranlage löst dieses Problem.

Zwar sind Kläranlagen nicht die beliebtesten #htl3r.short[ot]-Angriffsziele, Kraftwerke wären hierbei das beliebteste Ziel von Cyberangriffen auf kritische Infrastruktur @knowbe4-cyber-attacks-crit-infra[comp], jedoch gab es mit der Häufung an staatlich motivierten Cyberangriffen auch manche von pro-russischen Hacktivisten auf Kläranlagen im amerikanischen als auch europäischen Raum. @cisa-wastewater[comp]

#htl3r.author("David Koch")
== Planung der Betriebszellen

Um die Sicherheit der #htl3r.short[ot]-Komponenten so weit es geht zu gewährleisten, muss bereits bei der Planung der Anlage die Segmentierung in Betriebszellen in Betracht gezogen werden.
Die Gerätschaft einer Betriebszelle soll nur innerhalb dieser kommunizieren können, die einzige Ausnahme wäre beispielsweise die Kommunikation mit einem SCADA-System auf der nächst-höheren Purdue-Ebene. Eine solche Segmentierung lässt sich somit mit einer #htl3r.short[vlan]-Segmentierung in einem #htl3r.short[it]-Netzwerk vergleichen.

Unter anderem lässt sich durch eine physische Segmentierung der Kläranlage diese leicht ab- und wieder aufbauen. Wären alle Betriebszellen auf einer einzelnen Platte untergebracht, wäre diese circa 160x45cm groß und somit sehr unhandlich zu transportieren.

#htl3r.author("David Koch")
== Zelle Eins (Grobfiltration)

=== Aufbau

Als erster Schritt zur erfolgreichen Abwasserfiltration braucht es einen Weg, grobe Schmutzpartikel wie zum Beispiel Kieselsteine filtrieren zu können. Einen feinen Wasserfilter würden solche großen Partikel verstopfen oder sogar zerstören. Somit erfolgt die erste Filtration mit einem gröberen Metallgitter als Rechen.

Um das Abwasser zu sieben, wird es zuerst mit einer archimedischen Schraube in einen höhergelegenen Behälter geschraubt, welcher angewinkelt ist und am unteren Ende eine Öffnung hat. Diese Öffnung lässt das hochgeschraubte Wasser durch das Rechengitter fallen, was die groben Partikel wie zum Beispiel Kieselsteine aus dem Abwasser entfernt. Das restliche Abwasser fließt durch das Gitter durch und landet in einem Auffangbehälter, welcher der Anfang der Leitung in die zweite Zelle ist.

Die Schraube wurde 3D-modelliert. Gestartet wurde mit dem Erstellen des Stabs in der Mitte, um welchen die Schraube sich dann wickelt. Außerdem befindet sich am Ende des Stabs eine Ausparung, welche zur Befestigung eines 50rpm Schneckenmotors dient. Dieser Motor treibt die Schraube an und sorgt somit für den Transport des Wassers und dessen Inhaltsstoffen. Im nächsten Schritt wurde um den Stab eine Spirale gezeichnet, diese hat eine Querschnittsfläche eines Dreiecks, mit zwei Ecken nach außen und die dritte Ecke in die Mitte zeigend. Damit konnte anschließend von der Ecke auf den Stab eine Linie projeziert werden, worum sich dann die Förderschnecke wickelt. Es wurde eine Skizze erstellt, was die Schraube für eine Querschnittsfläche haben soll und anhand davon dann die Schraube entlang des Stabs nach oben extrudiert. Der Vorteil eines solchen Modellierungsprzesses, ist die Möglichkeit die Schraube im Nachhinein noch beliebig zu verändern, da alle Skizzen und Aktionen von einander abhängen. Sobald eine Skizze verändert wird, wird das Modell automatisch angepasst. Dies war hilfreich, da die Schraube anfangs nicht genug Wasser transportierte, da dieses an den Seiten herauslief. Durch das Schließen der Spirale konnte dieses Problem behoben werden.

Der Schneckenmotor ist mittels einer 3D-gedruckten Halterung befestigt. Diese Halterung wurde genau an die Maße des Motors angepasst und schließt diesen somit fest ein. Die Halterung hat auf jeder Seite zwei 1cm große Löcher, welche zur Begestigung dienen, da der Motor über einem offen Behälter hängt. In diese Löcher werden jeweils ein etwas längerer und ein etwas kürzerer Bolzen gesteckt, um den Motor zu befestigen. Der kürzere Bolzen liegt dann auf dem Behälter auf und der längere wird auf den jeweils links und rechts vom Behälter platzierten Stützen befestigt. Die Bolzen und Stützen sind ebenfalls 3D-gedruckt und sind mit der Halterung ausschließlich durch Steckverbindungen verbunden. Durch eine genaue Anpassung der Maße, konnte die Halterung ohne Schrauben oder Kleber befestigt werden und dennoch fest sitzen.

#htl3r.fspace(
  figure(
    image("../assets/zelle_1.png"),
    caption: [Der Aufbau der 1. Betriebszelle]
  )
)

=== Schaltplan

* BILD *

=== Steuerungstechnik

Die in dieser Zelle verwendete #htl3r.short[sps] ist eine Siemens SIMATIC S7-1200 mit der CPU 1212C. Sie ist kompakt sowie modular erweiterbar und somit für kleinere bis mittlere Automatisierungsaufgaben konzipiert.

Europaweit hat sich die Siemens SIMATIC als die gängiste #htl3r.short[sps]-Marke durchgesetzt @siemens-marktanteil[comp]. Bereits im Jahre 1958 wurde die erste SIMATIC, eine verbindungsprogrammierte Steuerung (kurz VPS), auf den Markt gebracht @simatic-history[comp].

Die S7-1200 hat folgende Eingänge und Ausgänge:
- 8 digitale Eingänge 24V DC
- 6 digitale Ausgänge 24V/0,5A DC
- 2 analoge Eingänge 0-10V
- Eine Profinet-Schnittstelle für die Kommunikation mit anderen Ethernet-Geräten

Die Ethernet-Schnittstelle wird verwendet, um die #htl3r.short[sps] mit der Zellen-Firewall und somit der restlichen Topologie zu verbinden.

* bild programm *

*Aktorik:*
- 12V Schneckenmotor mit 50 RPM

#htl3r.author("David Koch")
== Zelle Zwei (Feinfiltration)

=== Aufbau

Die zweite Betriebszelle dient der Feinfiltration des bereits grobfiltrierten Abwassers aus der ersten Zelle. Die feinen im Abwasser aufgelösten Schmutzpartikel, die in der ersten Zelle nicht durch den Rechen entfernt worden konnten, werden hier endgültig aus dem Abwassser entfernt. Nach der zweiten Zelle ist das Abwasser klar und ohne jeglich Verfärbungen und kann sicher in die Natur (Zelle Drei) abgepumpt werden.

Sie besteht aus zwei durchsichtigen Acryl-Wassertanks welche jeweils ca. 3L an Volumen aufweisen. Diese sind oben offen, werden jedoch von Deckeln abgedeckt. Diese Deckel wurden mittels 3D-Modellierung speziell angefertigt und zweimal gedruckt. In diesen Deckeln ist die für den Wassertank jeweils notwendige Sensorik verbaut. Diese besteht aus einem Füllstandssensor mit Schwimmer -- welcher als Widerstand agiert -- sowie einem DS18B20-Temperatursensor.
Außerdem hat jeder Tankdeckel auch noch eine Öffnung für einen Schlauch, welcher als Zufluss dient. Als Gegenstück besitzt jeder Tank an der Unterseite einen Messing Auslass mit Gewinde, an welchem dann ein Harnverbinder angeschraubt um eine Steckverbindung für die weiteren Schläuche zu ermöglichen.

Zwischen den Tanks befindet sich ein herkömmlicher Gartenpumpenfilter mit Filterball und eine Pumpe, welche Flüssigkeiten von einem Tank in den Nächsten durch den Filter hindurch transportiert. Die Pumpe wurde hinter dem Filter platziert, um dieser vor Verstopfungen durch Schmutzpartikel zu schützen. Der Filterball wurde dem Filter hinzugefügt, da dieser die Schmutzpartikel sehr gut aufnimmt und die Belastung des Filters verringert und somit die Effizienz der Filration erhöht und die Lebensdauer des Filters verlängert.

#htl3r.fspace(
  figure(
    image("../assets/zelle_2.png"),
    caption: [Der Aufbau der 2. Betriebszelle]
  )
)

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

#htl3r.fspace(
  total-width: 90%,
  figure(
    table(
      columns: (15em, auto, auto, auto, auto),
      align: (left, left, left, left, left),
      table.header[Name][Datentyp][Location][Startwert][Konstant],
      [TANK_1_TEMP], [INT], [%IW0], [-], [Nein],
      [TANK_2_TEMP], [INT], [%IW1], [-], [Nein],
      [TANK_1_LEVEL], [INT], [%IW2], [-], [Nein],
      [TANK_2_LEVEL], [INT], [%IW3], [-], [Nein],
      [FILTER_PUMP_ACTIVE], [BOOL], [%QX0], [-], [Nein],[PROGRESSION_PUMP_ACTIVE], [BOOL], [%QX1], [-], [Nein],
      [TANK_FULL], [INT], [-], [100], [Ja],
      [PUMP_DELAY], [TIME], [-], [T\#2000ms], [Ja],
    ),
    caption: [Die Variablen des OpenPLC-Programms]
  )
)

#htl3r.fspace(
  figure(
    image("../assets/Zelle_2_Programm.png"),
    caption: [Kontaktplan-Darstellung des OpenPLC-Programms]
  )
)

*Aktorik:*
- 2x Gartenpumpe mit 800L/h Durchsatz (mit eigenem 12V Relais)

*Sensorik:*
- 2x OneWire DS18B20-Temperatursensor
- 2x Füllstandssensor mit Schwimmer (Widerstand mit 0-190 Ohm)

Um die analogen Widerstandswerte der Füllstandssensoren an die digitalen Pins des RaspberryPi zu übermitteln, wird ein ESP32 als ADC verwendet, welcher dem RaspberryPi über einen eigenen #htl3r.short[i2c]-Bus laufend die Füllstandsmesswerte als 8-bit Integer-Werte übermittelt. Mehr Informationen zu der Umsetzung dessen sind in @diy-i2c zu finden.

#htl3r.author("Gabriel Vogler")
== Zelle Drei (Staudamm)

=== Aufbau

Nach der erfolgreichen Filtration des Abwassers wird dies von der zweiten Zelle in ein Wasserspeicherbecken umgepumpt. Es handelt sich bei dem Becken um eine Eurobox mit den Maßen 30cm x 20cm x 7cm und hat an der Vorderseite ein Loch woran das Magnetventil befestigt ist. Mit dem Zusammenspiel dieser beiden Komponenten wird der Staudamm realisiert. Das Becken wird mit Wasser gefüllt und das Magnetventil kann geöffnet und geschlossen werden. Für die Montage des Magnetventils wurde zunächst ein Loch in die Eurobox gebohrt. Dabei musste aufgepasst werden, dass man nicht zu schnell bohrt, weil sonst das Plastik entweder ausreißen oder wegschmelzen könnte. Anschließend wurde ein Wasserauslass durch das Loch gesteckt, mit Dichtungen wasserdicht gemacht und mit dem beigelegten Gegenstück verschraubt. An den Messingauslass wurden dann zwei 3D-gedruckte Adapterstücke geschraubt, um daran das Magnetventil zu befestigen, da das Magnetventil eine 1/2 Zoll Schraubverbindung und der Messingauslass ein 3/4 Zoll Gewinde hat. Das Wasser vom Wasserspeicherbecken soll durch das Magnetventil in das Wassereinlaufbecken fließen. Aufgrunddessen wurde das Wasserspeicherbecken mit sechs Holzstücken erhöht, damit das Wasser mittels Gravitation in das Wassereinlaufbecken fließen kann.

#htl3r.fspace(
  figure(
    image("../assets/zelle_3.jpeg"),
    caption: [Die dritte Betriebszelle mit Wasserspeicherbecken und Wassereinlaufbecken]
  )
)

Für das Wassereinlaufbecken bzw. das Überschwemmungebiet wurde als Basis eine weitere 30cm x 20cm x 7cm Eurobox verwendet. Das Überschwemmungsgebiet ist mit kleinen Modell-Bäumen und 3D-gedruckten roten Häusern unterschiedlicher Größe bestückt. Unter anderem sind mehrere Wasserstandsensoren an der Seite des Behälters befestigt, um im Falle eines Hochwasser bzw. einer Überschwemmung einen Alarm auszulösen (Leuchte mit Alarmton neben dem Behälter).

#htl3r.fspace(
  figure(
    image("../assets/zelle_3_gebiet.jpeg"),
    caption: [Das Überschwemmungsgebiet]
  )
)

=== Schaltplan

* bild *

=== Steuerungstechnik

Für die Steuerung des Magnetventils und die Auswertung der Überschwemmungssensoren ist eine Siemens LOGO! #htl3r.short[sps] zuständig. Diese steuert das Magnetventil und somit den Wasserfluss.

#htl3r.fspace(
  figure(
    image("../assets/Zelle_3_Programm.png"),
    caption: [Kontaktplan-Darstellung des LOGO!-Programms]
  )
)

*Aktorik:*
- 12V Magnetventil
- 24V Alarmleuchte (+ Ton)

*Sensorik:*
- 3x Überschwemmungssensor

#htl3r.author("Gabriel Vogler")
== 3D-Druck

Für einige Komponenten gab es keine passenden Teile, oder übermäßige Kosten für die Anschaffung dessen.
Deshalb wurde die Entscheidung getroffen diese Teile oder Abwandlungen, die für die Anlage sogar noch besser passen, selbst zu designen und zu drucken.
Die Anschaffung des 3D-Druckers wurde privat getätigt und die Filamentkosten wurden von unserem Sponsor -- der Ikarus -- übernommen.

#htl3r.author("Gabriel Vogler")
=== Modellieren

Die Modelle wurden mittels Autodesk Fusion 360 erstellt.

Die Modelle sind stark in ihrer Komplexität variierend. Einige sind sehr einfach zu modellieren, wie zum Beispiel die Tankdeckel der Zelle Zwei. Andere sind etwas aufwändiger, wie zum Beispiel die Archimedische Förderschnecke in der Zelle Eins.

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

Für das reibungslose Drucken wurde außerdem #htl3r.short[pva]-Filament verwendet, um Stützstrukturen zu drucken, die nach dem Druck einfach in Wasser aufgelöst werden können. Dies half uns dabei, auch komplexere Modelle zu drucken, die ohne Stützstrukturen nicht möglich gewesen wären und die dennoch eine hoheh Qualität des Drucks zu gewährleisten. Das #htl3r.short[pva]-Filament stammt ebenfalls aus dem Hause BambuLab. Die Problematik bei der Vernwedung von #htl3r.short[pva]-Filament ist, dass dieses eine sehr trockene Umgebung benötigt, da es sehr emplindlich gegenüber Feuthigkeit ist. Anfänglich wurde probiert das Filament im Vorhinein mit einem Filamenttrockner zu trocknen und anschließend aus dem #htl3r.short[ams] zu drucken. Obwohl in einem trockenen Raum gedruckt wurde, wollte das Filament nicht so wie geünscht auf der Druckplatte und dem zu druckenden Körper haften. Nach einigen Anpassungen an den Druckeinstellungen sowie dem Wechsel von #htl3r.short[petg] auf #htl3r.short[pla] als Druckmaterial, konnte das Problem gelöst werden. Dies liegt daran, dass #htl3r.short[petg] heißer gedruckt werden muss als #htl3r.short[pla] und die Temperatur für das #htl3r.short[pva]-Filament zu hoch war und das Stützmaterial zum kochen begonnnen hat. Dies führte zum Ziehen von Fäden und somit zu einem unbrauchbaren Druck. Außerdem wurde das #htl3r.short[pva]-Filament direkt aus dem Filamenttrockner gedruckt, somit konnte auch während des Druckens die Trockenheit gewährleistet werden. 

#pagebreak(weak: true)
== 3D-Modelle
=== Förderschnecke
Die Schraube wurde 3D modelliert. Gestartet wurde mit dem Erstellen des Stabs in der Mitte, um welchen die Schraube sich dann wickelt. Außerdem befindet sich am Ende des Stabs eine Ausparung, welche zur Befestigung eines 50rpm Schneckenmotors dient. Dieser Motor treibt die Schraube an und sorgt somit für den Transport des Wassers und dessen Inhaltsstoffen. Im nächsten Schritt wurde um den Stab eine Spirale gezeichnet, diese hat eine Querschnittsfläche eines Dreiecks, mit zwei Ecken nach außen und die dritte Ecke in die Mitte zeigend. Damit konnte anschließend von der Ecke auf den Stab eine Linie projeziert werden, worum sich dann die Förderschnecke wickelt. Es wurde eine Skizze erstellt, was die Schraube für eine Querschnittsfläche haben soll und anhand davon dann die Schraube entlang des Stabs nach oben extrudiert. Der Vorteil eines solchen Modellierungsprzesses, ist die Möglichkeit die Schraube im Nachhinein noch beliebig zu verändern, da alle Skizzen und Aktionen von einander abhängen. Sobald eine Skizze verändert wird, wird das Modell automatisch angepasst. Dies war hilfreich, da die Schraube anfangs nicht genug Wasser transportierte, da dieses an den Seiten herauslief. Durch das Schließen der Spirale konnte das Problem behoben werden.

#figure(
  image("../assets/3D-Modelle/Fenrir_Förderschnecke.png", width: 90%),
  caption: [3D-Modell der Förderschnecke]
)
#pagebreak(weak: true)
=== Schneckenmotor-Halterung
Der Schneckenmotor ist mittels einer 3D-gedruckten Halterung befestigt. Diese Halterung wurde genau an die Maße des Motors angepasst und schließt diesen somit fest ein. Die Halterung hat auf jeder Seite zwei 1cm große Löcher, welche zur Begestigung dienen, da der Motor über einem offen Behälter hängt. In diese Löcher werden jeweils ein etwas längerer und ein etwas kürzerer Bolzen gesteckt, um den Motor zu befestigen. Der kürzere Bolzen liegt dann auf dem Behälter auf und der längere wird auf den jeweils links und rechts vom Behälter platzierten Stützen befestigt. Die Bolzen und Stützen sind ebenfalls 3D-gedruckt und sind mit der Halterung ausschließlich durch Steckverbindungen verbunden. Durch eine genaue Anpassung der Maße, konnte die Halterung ohne Schrauben oder Kleber befestigt werden und dennoch fest sitzen. Dabei wurden die Innenwände um 0,1 mm nach außen vesetzt. Um zu garantieren, dass der Motor nicht frontal herausfällt wurde außerdem eine abdeckung gedruckt. diese wird einfach auf den Motor gesetzt und anschließend mit der Halterung mit 4 M3 Schrauben befestigt. Das Gewinde ist in die Halterung gedruckt und die Löcher in der Abdeckung sind abgesenkt, damit der Senkkopf der Schraube nicht übersteht.

#figure(
  image("../assets/3D-Modelle/Motor_Halterung.png"),
  caption: [3D-Modell der Halterung für den Schneckenmotor]
)
#pagebreak(weak: true)
=== Zelle Zwei Tankabdeckungen
Für beide Tanks der Zelle Zwei wurden idente Deckel entworfen und gedruckt. Diese Deckel haben eine Öffnung für einen Schlauch, welcher als Zufluss dient. Außerdem sind im Deckel die notwendigen Sensoren befestigt. Der Füllstandssensor wird durch die Öffnung von oben in den Tank gesteckt und liegt auf dem Deckel auf. Der Temparatursensor hat eine eigene Öffnung, in welche dieser dann ebenfalls von oben in den Tankgesteckt werden kann. Die Deckel sind so konzipiert, dass die 3 Löcher nur so groß wie nötig sind, damit keine Verunreinigungen ins Wasser kommen können. Die Löcher wurden mit kreisförmigen Skizzen erstellt und anschließend Extrudiert und damit Deckel ausgeschnitten. damit diese nicht verrutschen gibt es an der Unerseite des Deckels eine erhöhung die in den tank hineinragt. Damit ist der Deckel befestigt ohne jeglichen Einsatz von Schrauben oder Kleber.
#figure(
  image("../assets/3D-Modelle/Fenrir-Betriebszelle-2-Abdeckung.png"),
  caption: [3D-Modell des Tankdeckels]
)
#pagebreak(weak: true)
=== Zelle Drei Einlasshalterung
Für das Wassereinlaufbecken in der Zelle Drei gibt wurde eine Halterung für den Wasserschlauch modelliert und gedruckt. Diese ist im Becken an links und rechts montiert. Dies wurde mithilfe von zwei Steckverbindungen erreicht. Das Becken hat etwa 2 cm x 0,5 cm große Löcher in die die Halterung gesteckt wird. Modelliert wurden die beiden Einschübe mit einer Skizze die anschließend 1 cm lang extrudiert wurde. Die Öffnung für den Schlauch wurde mit einer Kreisförmigen Skizze erstellt und anschließend extrudiert. Die Öffnung für den Schlauch wurde so angepasst, dass bei Bedarf der Schlauch einfach entfernt werden kann und dennoch bei Benutzung fest sitzt.
#figure(
  image("../assets/3D-Modelle/Fenrir-Betriebszelle-3-Abdeckung.png"),
  caption: [3D-Modell der Einlasshalterung]
)
#pagebreak(weak: true)
=== Zelle Drei Überschwemmungsgebiet-Häuser
Für die Zelle Drei wurden mehrere kleine Häuser gedruckt. Es wurde ein Modell erstellt und anschließend im Slicer nach Belieben skaliert. Dabei wurde die volle Größe und die Hälfte genommen. Der Modellierungsprozess begann mit der Grundform des Hauses, einem Quader, auf dem dann ein Dreieck, was anschließend extrudiert wurde, platziert wurde. Der Reichfang ist durch einen Zylinder dargestellt. Dabei wurde eine Kreisförmige Skizze durch das Dach des Hauses hindurch extrudiert. Das Haus ist innen hohl, damit weniger Material verbraucht wird und es für nicht notwendig ist, das Haus zu füllen.
#figure(
  image("../assets/3D-Modelle/Fenrir_house_4.png"),
  caption: [3D-Modell der Häuser]
)

#htl3r.author("David Koch")
== Programmierung eines I²C-Kommunikationsbusses <diy-i2c>

Um einen Kommunikationskanal zwischen der Software-#htl3r.short[sps] (OpenPLC) auf dem RaspberryPi und dem Analogdigitalwandler ESP32 für die Füllstandssensoren in Betriebszelle zwei herzustellen, wird ein Zweidrahtbussystem mit dem Protokoll #htl3r.short[i2c] verwendet.

=== I²C Überblick

Kurz für "Inter-Integrated Circuit". #htl3r.short[i2c] ist ein 1982 von Philips Semiconductors entwickelter serieller Datenbus, der als Master-Slave-Bus konzipiert ist, aber auch das Multi-Master-Prinzip unterstützt. Bei diesem Protokoll werden zwei Signalleitungen benötigt, eine Takt- und eine Datenleitung. Eine Eigenschaft von #htl3r.short[i2c] ist die Tatsache, dass ein Mikrocontroller ein ganzes Netzwerk an integrierten Schaltungen mit nur zwei #htl3r.short[io]-Pins und einfacher Software kontrollieren kann. Daher wird #htl3r.short[i2c] hauptsächlich geräteintern für die Kommunikation zwischen verschiedenen Schaltungsteilen benutzt, zum Beispiel innerhalb eines Fernsehers.
@i2c-manual

Im PC wird ein dem #htl3r.short[i2c]-Bus sehr ähnliches System benutzt, um z.B. die Daten eines SDRAM-Modules auszulesen. Dieser nennt sich SMBus (System Management Bus).

=== Kommunikationskonzept

#htl3r.fspace(
  [
    #figure(
      image("../assets/rpi_esp32_i2c_fenrir.svg"),
      caption: [Der Kommunikationsaufbau zwischen RPI, ESP32 und Sensorik]
    )
    <i2c-aufbau>
  ]
)

Der in @i2c-aufbau sichtbare Aufbau zeigt den Weg, wie die Füllstandsmesswerte der Sensoren vom ESP32 analog gemessen werden und darauf per #htl3r.short[i2c]-Bus an OpenPLC geschickt wird.

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

== Schaltschrank

#htl3r.fspace(
  figure(
    image("../assets/schrank.png"),
    caption: [Der Schaltschrank der Modell-Kläranlage inklusive SPSen, Netzteilen und Firewall]
  )
)

