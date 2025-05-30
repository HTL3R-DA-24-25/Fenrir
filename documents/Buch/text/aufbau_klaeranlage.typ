#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("David Koch")
= Aufbau der Modell-Kläranlage <aufbau-klaeranlage>

Um die Absicherung eines Produktionsbetriebs oder eines Stücks kritischer Infrastruktur ausreichend dokumentieren zu können, darf nicht ausschließlich auf virtualisierte Lösungen des #htl3r.short[ot]-Netzwerks vertraut werden. Dazu ist das Ausmaß eines "Super-#htl3r.short[gau]s" innerhalb eines virtualisierten #htl3r.short[ot]-Netzwerks für die meisten aussenstehenden Personen nicht begreifbar bzw. realistisch genug. Eine selbstgebaute Modell-Kläranlage löst dieses Problem.

Zwar sind Kläranlagen nicht die beliebtesten #htl3r.short[ot]-Angriffsziele, Kraftwerke wären hierbei das beliebteste Ziel von Cyberangriffen auf kritische Infrastruktur @knowbe4-cyber-attacks-crit-infra[comp], jedoch gab es mit der Häufung an staatlich motivierten Cyberangriffen auch manche von pro-russischen Hacktivisten auf Kläranlagen im amerikanischen als auch europäischen Raum. @cisa-wastewater[comp]

#htl3r.fspace(
  total-width: 90%,
  figure(
    image("../assets/klaeranlage_blockschaltbild.png"),
    caption: [Die drei Betriebszellen der Modell-Kläranlage]
  )
)

#htl3r.fspace(
  figure(
    image("../assets/klaeranlage_blocks.png", width: 65%),
    caption: [Schematische Darstellung aller Betriebszellen und deren Verbindungen untereinander]
  )
)

#htl3r.author("David Koch")
== Planung der Betriebszellen

Um die Sicherheit der #htl3r.short[ot]-Komponenten so weit es geht zu gewährleisten, muss bereits bei der Planung der Anlage die Segmentierung in Betriebszellen in Betracht gezogen werden.
Die Gerätschaft einer Betriebszelle soll nur innerhalb dieser kommunizieren können, die einzige Ausnahme wäre beispielsweise die Kommunikation mit einem #htl3r.short[scada]-System auf der nächst-höheren Purdue-Ebene. Eine solche Segmentierung lässt sich somit mit einer #htl3r.short[vlan]-Segmentierung in einem #htl3r.short[it]-Netzwerk vergleichen.

Unter anderem lässt sich durch eine physische Segmentierung der Kläranlage diese leicht ab- und wieder aufbauen. Wären alle Betriebszellen auf einer einzelnen Platte untergebracht, wäre diese circa 160x45cm groß und somit sehr unhandlich zu transportieren.

== Zelle Eins (Grobfiltration)

Die erste Betriebszelle dient der Grobfiltration des schmutzigen Wassers. Falls im Wasser gröbere Schmutzpartikel -- wie z.B. Kieselsteine -- enthalten sind, müssen sie aus dem Abwasser filtriert werden, bevor sie in den feineren Filter der zweiten Betriebszelle kommen, um diesen nicht zu beschädigen. Nach der ersten Zelle wird das Abwasser durch einen Höhenunterschied zwischen dem Auffangbecken und dem ersten Tank der Zelle Zwei mittels Schwerkraft abtransportiert.

#htl3r.fspace(
  figure(
    image("../assets/grobfiltration_block.png", width: 75%),
    caption: [Schematische Darstellung der ersten Betriebszelle]
  )
)

=== Aufbau der ersten Betriebszelle

Als erster Schritt zur erfolgreichen Abwasserfiltration braucht es einen Weg, grobe Schmutzpartikel wie zum Beispiel Kieselsteine filtrieren zu können. Einen feinen Wasserfilter würden solche großen Partikel verstopfen oder sogar zerstören. Somit erfolgt die erste Filtration mit einem gröberen Metallgitter als Rechen.

Um das Abwasser zu sieben, wird es zuerst mit einer archimedischen Schraube in einen höhergelegenen Behälter befördert, welcher angewinkelt ist und am unteren Ende eine Öffnung hat. Diese Öffnung lässt das hochbeförderte Wasser durch das Rechengitter fließen, was die groben Partikel wie zum Beispiel Kieselsteine aus dem Abwasser entfernt. Das restliche Abwasser fließt durch das Gitter durch und landet in einem Auffangbehälter, welcher eine Öffnung für die Leitung in die zweite Zelle birgt.

Für Details zur Modellierung der archimedischen Schraube und der Halterung des Schneckenmotors siehe @schnegge und @motor-halterung.

#htl3r.fspace(
  figure(
    image("../assets/zelle_1.jpg"),
    caption: [Der Aufbau der 1. Betriebszelle]
  )
)

=== Steuerungstechnik der ersten Betriebszelle

Die in dieser Zelle verwendete #htl3r.short[sps] ist eine Siemens SIMATIC S7-1200 mit der CPU 1212C. Sie ist kompakt sowie modular erweiterbar und somit für kleinere bis mittlere Automatisierungsaufgaben konzipiert.

Europaweit hat sich die Siemens SIMATIC als die gängiste #htl3r.short[sps]-Marke durchgesetzt @siemens-marktanteil[comp]. Bereits im Jahre 1958 wurde die erste SIMATIC, eine verbindungsprogrammierte Steuerung (kurz VPS), auf den Markt gebracht @simatic-history[comp].

#pagebreak(weak: true)
Die S7-1200 hat folgende Eingänge und Ausgänge:
- 8 digitale Eingänge 24V DC
- 6 digitale Ausgänge 24V/0,5A DC
- 2 analoge Eingänge 0-10V
- Eine Profinet-Schnittstelle für die Kommunikation mit anderen Ethernet-Geräten

Die Ethernet-Schnittstelle wird verwendet, um die #htl3r.short[sps] mit der Zellen-Firewall und somit der restlichen Topologie zu verbinden.

*Aktorik:*
- 12V Schneckenmotor mit 50 RPM

Das Programm für die Steuerung dieser Betriebszelle ist von allen drei Zellen das simpelste. Es wird lediglich ein digitaler Eingang und ein digitaler Ausgang verwendet, um die Stromzufuhr zur Förderschnecke zu kontrollieren. Für diesen Zweck bräuchte man eigentlich keine #htl3r.short[sps] wie die S7-1200, mit der einzigen Ausnahme, dass der digitale Eingang auch per Ethernet-Schnittstelle -- z.B. vom #htl3r.short[scada]-System -- gesteuert werden kann. Somit kann der Motor der Förderschnecke nicht nur vor Ort durch einen herkömmlichen Ein-Aus-Knopf, sondern auch aus der Ferne gesteuert werden.

#htl3r.fspace(
  [
    #figure(
      image("../assets/Zelle_1_Programm.png"),
      caption: [Kontaktplan-Darstellung des Programms der S7-1200]
    )
    <zelle-1-programm>
  ]
)

Das in @zelle-1-programm abgebildete Programm -- welches in der Kontaktplan-Programmiersprache erstellt worden ist (Erklärung in @sps-programmierung) -- nutzt wie zuvor erwähnt den digitalen Eingang `%I0.1` als Kontakt und den digitalen Ausgang `%Q0.1` als Spule zur Steuerung der Stromzufuhr zum Schneckenmotor. Sie sind direkt miteinander verbunden, das heißt, dass wenn der Kontakt im Zustand "AN" ist, dann ist die Spule ebenfalls im Zustand "AN".

=== Schaltplan der ersten Betriebszelle

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/Zelle_1_Schaltplan.png"),
    caption: [Schaltplan der 1. Betriebszelle]
  )
)

#pagebreak(weak: true)
== Zelle Zwei (Feinfiltration)

Die zweite Betriebszelle dient der Feinfiltration des bereits grobfiltrierten Abwassers aus der ersten Zelle. Die feinen, im Abwasser aufgelösten Schmutzpartikel, die in der ersten Zelle nicht durch den Rechen entfernt worden konnten, werden hier endgültig aus dem Abwassser entfernt. Nach der zweiten Zelle ist das Abwasser klar und ohne jeglich Verfärbungen und kann sicher in die Natur (Zelle Drei) abgepumpt werden.

#htl3r.fspace(
  figure(
    image("../assets/feinfiltration_block.png", width: 90%),
    caption: [Schematische Darstellung der zweiten Betriebszelle]
  )
)

=== Aufbau der zweiten Betriebszelle

Sie besteht aus zwei durchsichtigen Acryl-Wassertanks welche jeweils ca. 3L an Volumen aufweisen. Diese sind oben offen, werden jedoch von Deckeln abgedeckt. Diese Deckel wurden mittels 3D-Modellierung speziell angefertigt und zweimal gedruckt. In diesen Deckeln ist die für den Wassertank jeweils notwendige Sensorik verbaut. Diese besteht aus einem Füllstandssensor mit Schwimmer -- welcher als Widerstand agiert -- sowie einem DS18B20-Temperatursensor.
Außerdem hat jeder Tankdeckel auch noch eine Öffnung für einen Schlauch, welcher als Zufluss dient. Als Gegenstück besitzt jeder Tank an der Unterseite einen Messing Auslass mit Gewinde, an welchem dann ein Harnverbinder angeschraubt um eine Steckverbindung für die weiteren Schläuche zu ermöglichen.

Zwischen den Tanks befindet sich ein herkömmlicher Gartenpumpenfilter mit Filterball und eine Pumpe, welche Flüssigkeiten von einem Tank in den Nächsten durch den Filter hindurch transportiert. Die Pumpe wurde hinter dem Filter platziert, um dieser vor Verstopfungen durch Schmutzpartikel zu schützen. Ein Filterball wurde innerhalb des Filters hinzugefügt, da dieser die Schmutzpartikel sehr gut aufnimmt und die Belastung des Filters verringert und somit die Effizienz der Filration erhöht und die Lebensdauer des Filters verlängert.

#htl3r.fspace(
  figure(
    image("../assets/zelle_2.jpg"),
    caption: [Der Aufbau der 2. Betriebszelle]
  )
)

=== Steuerungstechnik der zweiten Betriebszelle <steuerung-zwei>

Im Vergleich zu den anderen zwei Zellen wird in dieser eine Software-#htl3r.short[sps] eingesetzt: Die OpenPLC-Runtime v3. Diese läuft auf einem Raspberry Pi 4 Mikrocomputer.

OpenPLC ist eine einfach bedienbare Open-Source Software-#htl3r.short[sps]. Sie ist die erste vollständig funktionsfähige standardisierte Open Source #htl3r.short[sps], im Software- als auch im Hardwarebereich. Das OpenPLC-Projekt wurde in Übereinstimmung mit der IEC 61131-3 Norm erstellt, welche die grundlegende Softwarearchitektur und Programmiersprache für #htl3r.shortpl[sps] festlegt. Als Teil des Projekts wird die OpenPLC-Runtime -- die tatsächliche #htl3r.short[sps]-Steuerungssoftware -- und der OpenPLC-Editor zur Programmierung der Runtime bereitgestellt. OpenPLC wird hauptsächlich für die Automatisierung in industriellen Anlagen, bei der Hausautomation (Internet of Things) und im Forschungsbereich eingesetzt @openplc-overview[comp].

*Aktorik:*
- 2x Gartenpumpe mit 800L/h Durchsatz (mit eigenem 12V Relais)

*Sensorik:*
- 2x OneWire DS18B20-Temperatursensor
- 2x Füllstandssensor mit Schwimmer (Widerstand mit 0-190 Ohm)

Um die analogen Widerstandswerte der Füllstandssensoren an die digitalen Pins des Raspberry Pi zu übermitteln, wird ein ESP32 als Analogdigitalwandler verwendet, welcher dem Raspberry Pi über einen eigenen #htl3r.short[i2c]-Bus laufend die Füllstandsmesswerte als 8-bit Integer-Werte übermittelt. Mehr Informationen zu der Umsetzung sind in @diy-i2c zu finden.

Der Raspberry Pi ist auch nicht direkt in der Lage, eine klassische Relay-Steuerung zu ersetzen. Die Pins liefern maximal 3,3V, wobei die meisten Aktoren und Sensoren in der Modell-Kläranlage 12V oder auch 24V brauchen. Somit muss ein externes Relaismodul verwendet werden, um die gewünschte Funktionalität zu erreichen. Für diesen Zweck werden zwei KY-019 Relaismodule von AZ-Delivery eingesetzt. Diese können jeweils mit 5V DC betrieben werden, wobei das Schaltsignal auch lediglich 3,3V sein kann @relais-datenblatt[comp]. Wenn das Schaltsignal auf "hoch" gesetzt wird, fließt auf der anderen Seite der Strom von einer 12V-Stromversorgung zur Pumpe. Somit werden insgesamt zwei Pins des Raspberry Pi verwendet, um jeweils das Relay für die Filterpumpe und die Übergangspumpe anzusteuern.

#htl3r.fspace(
  total-width: 40%,
  figure(
    image("../assets/extra_relay.jpg"),
    caption: [Das verwendete KY-019 Relaismodul]
  )
)

#htl3r.fspace(
  figure(
    image("../assets/relay_beschriftung.png"),
    caption: [Beschriftete Ein- und Ausgänge des Relaismoduls für die Filter-Pumpe]
  )
)

Für die Steuerung der Betriebszelle "Feinfiltration" ist ein Programm zuständig, welches die Werte der Füllstandssensoren in Betracht zieht, um je nach Füllstand in den Tanks die jeweilige Pumpe zum Abpumpen des Wassers in den nächsten Behälter per Relay einzuschalten.

#htl3r.fspace(
  total-width: 95%,
  figure(
    table(
      columns: (15em, auto, auto, auto, auto),
      align: (left, left, left, left, left),
      table.header[*Name*][*Datentyp*][*Location*][*Startwert*][*Konstant*],
      [TANK_1_TEMP], [INT], [%IW0], [-], [Nein],
      [TANK_2_TEMP], [INT], [%IW1], [-], [Nein],
      [TANK_1_LEVEL], [INT], [%IW2], [-], [Nein],
      [TANK_2_LEVEL], [INT], [%IW3], [-], [Nein],
      [FILTER_PUMP_OVERRIDE], [BOOL], [%QX1.0], [-], [Nein],
      [PROGRESSION_PUMP_OVERRIDE], [BOOL], [%QX1.1], [-], [Nein],
      [FILTER_PUMP_ACTIVE], [BOOL], [%QX0.0], [-], [Nein],
      [PROGRESSION_PUMP_ACTIVE], [BOOL], [%QX0.1], [-], [Nein],
      [TANK_FULL], [INT], [-], [100], [Ja],
      [PUMP_DELAY], [TIME], [-], [T\#2000ms], [Ja],
    ),
    caption: [Die Variablen des OpenPLC-Programms]
  )
)

#htl3r.fspace(
  total-width: 90%,
  [
    #figure(
      image("../assets/Zelle_2_Programm.png"),
      caption: [Kontaktplan-Darstellung des OpenPLC-Programms]
    )
    <zelle-2-programm>
  ]
)

Das Ziel des Programms ist es, je nach Füllstand der Tanks die jeweiligen Pumpen einzuschalten. Einmal um das schmutzige Wasser aus dem ersten Tank durch den Filter in den zweiten Tank zu befördern und einmal, um aus dem zweiten Tank das saubere Wasser in den Staudamm zu befördern. Hierfür wird zuerst ein Vergleich mittels eines "Greater Than"-Funktionsbausteins getätigt, ob der Füllstand des Tanks (`TANK_1_LEVEL` bzw. `TANK_2_LEVEL`) den für das Umpumpen festgelegten konstanten Füllstandswert `TANK_FULL` überschreitet. Falls dies der Fall ist, wird das Signal zum Einschalten der jeweiligen Pumpe an einen "Off Delay Timer"-Funktionsbaustein weitergeleitet. Dieser versichert, dass durch die Unterschreitung des zum Umpumpen nötigen Füllstandswerts während des Pumpvorgangs dieser nicht mittendrin abbricht. Die von diesem Funktionsbaustein getätigte Zeitverzögerung wird durch die konstante Variable `PUMP_DELAY` -- die 2000 Millisekunden entspricht -- gesteuert. Das vom "Off Delay Timer"-Funktionsbaustein manipulierte Signal wird final noch an ein "Or"-Funktionsbaustein weitergegeben, welcher dazu dient, dem #htl3r.short[scada] einen Override der Pumpenaktivierung über die Variablen `FILTER_PUMP_OVERRIDE` bzw. `PROGRESSION_PUMP_OVERRIDE` zu gewähren.

Das in @zelle-2-programm sichtbare Programm ist ein Kontaktplan-Programm -- erkennbar an den vertikalen Stromleitung links und rechts als auch den zwei Spulen zum Setzen der Output-Werte -- nutzt aber einige Funktionsbausteine, welche charakteristisch für ein #htl3r.long[fup]-Programm sind. Mehr Informationen zu dieser Überschneidung sind in @sps-programmierung zu finden.

Nachdem das Signal an den Output-Spulen ankommt, werden diese aktiv und setzen den Wert der ihnen zugehörigen Adresse auf "hoch". In @i2c-integration wird genauer erläutert, wie die Modbus-Output-Adresse mit den #htl3r.short[gpio]-Pins des Raspberry Pi verknüpft ist.

=== Schaltplan der zweiten Betriebszelle

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/Zelle_2_Schaltplan.png"),
    caption: [Schaltplan der 2. Betriebszelle]
  )
)

#htl3r.author("Gabriel Vogler")
== Zelle Drei (Staudamm)

Die dritte Betriebszelle besteht aus einem Wasserspeicherbecken und einem Überschwemmungsgebiet. Sie dient einerseits der Speicherung des in Zelle Zwei gefilterten Wassers und andererseits der Simulation eines ländlichen Wohngebiets, welches durch einen Fluss gespalten wird. Das Wasser kann bei Bedarf in den Fluss abgelassen werden. Anhand dieser Zelle kann die Gefahr einer Fehlfunktion der Steuerung anhand einer Überschwemmung des Wohngebiets dargestellt werden.

#htl3r.fspace(
  figure(
    image("../assets/staudamm_block.png", width: 90%),
    caption: [Schematische Darstellung der dritten Betriebszelle]
  )
)

=== Aufbau der dritten Betriebszelle

Nach der erfolgreichen Filtration des Abwassers wird dies von der zweiten Zelle in ein Wasserspeicherbecken umgepumpt. Es handelt sich bei dem Becken um eine Eurobox mit den Maßen 30cm x 20cm x 7cm und hat an der Vorderseite ein Loch woran das Magnetventil befestigt ist. Mit dem Zusammenspiel dieser beiden Komponenten wird der Staudamm realisiert. Das Becken wird mit Wasser gefüllt und das Magnetventil kann geöffnet und geschlossen werden.

Für die Montage des Magnetventils wurde zunächst ein Loch in die Eurobox gebohrt. Dabei musste aufgepasst werden, dass man nicht zu schnell bohrt, weil sonst das Plastik entweder ausreißen oder wegschmelzen könnte. Anschließend wurde ein Wasserauslass durch das Loch gesteckt, mit Dichtunsringen abgedichtet und mit dem beigelegten Gegenstück verschraubt. An den Messingauslass wurden dann zwei 3D-gedruckte Adapterstücke geschraubt, um daran das Magnetventil zu befestigen, da das Magnetventil eine 1/2 Zoll Schraubverbindung und der Messingauslass ein 3/4 Zoll Gewinde hat. Das Wasser vom Wasserspeicherbecken soll durch das Magnetventil in das Wassereinlaufbecken fließen. Aufgrunddessen wurde das Wasserspeicherbecken mit sechs Holzstücken erhöht, damit das Wasser mittels Schwerkraft in das Wassereinlaufbecken fließen kann.

#htl3r.fspace(
  figure(
    image("../assets/zelle_3.jpeg"),
    caption: [Die dritte Betriebszelle mit Wasserspeicherbecken und Wassereinlaufbecken]
  )
)

Für das Wassereinlaufbecken bzw. das Überschwemmungebiet wurde als Basis eine weitere 30 cm x 20 cm x 7 cm Eurobox verwendet. Das Überschwemmungsgebiet ist mit kleinen Modell-Bäumen und 3D-gedruckten roten Häusern unterschiedlicher Größe bestückt. Unter anderem sind mehrere Wasserstandsensoren an der Seite des Behälters befestigt, um im Falle eines "Hochwasser" bzw. einer Überschwemmung einen Alarm auszulösen (Leuchte mit Alarmton neben dem Behälter).

#htl3r.fspace(
  figure(
    image("../assets/zelle_3_gebiet.jpeg"),
    caption: [Das Überschwemmungsgebiet]
  )
)

=== Steuerungstechnik der dritten Betriebszelle

Für die Steuerung des Magnetventils und die Auswertung der Überschwemmungssensoren ist eine Siemens LOGO! #htl3r.short[sps] zuständig. Diese steuert das Magnetventil und somit den Wasserfluss.

*Aktorik:*
- 12V Magnetventil
- 12V Alarmleuchte (+ Ton)

*Sensorik:*
- 2x Füllstandssensor
- 3x Überschwemmungssensor

Für die Steuerung der Betriebszelle "Staudamm" ist ein Programm zuständig, welches die offenen Kontakte im Staudamm- und Überschwemmungsgebiet-Behälter auf ihre anliegende Spannung überwacht und je nach den aktivierten Kontakten das Magnetventil öffnet oder den Alarm für das Überschwemmungsgebiet auslöst.

#htl3r.fspace(
  total-width: 70%,
  figure(
    table(
      columns: (15em, auto, auto),
      align: (left, left, left),
      table.header[*Name*][*Datentyp*][*Location*],
      [SCADA_Sound_Override], [BOOL], [I1],
      [Damm-Sensor-1], [BOOL], [I2],
      [Damm-Sensor-2], [BOOL], [I3],
      [Flut-Sensor-1], [BOOL], [I8],
      [Flut-Sensor-2], [BOOL], [I6],
      [Flut-Sensor-3], [BOOL], [I7],
      [Alarmlicht_AN], [BOOL], [Q1],
      [Alarmsound_AN], [BOOL], [Q2],
      [Magnetventil_AN], [BOOL], [Q3],
    ),
    caption: [Die Variablen des LOGO!-Programms]
  )
)

#htl3r.fspace(
  total-width: 90%,
  [
    #figure(
      image("../assets/Zelle_3_Programm.png"),
      caption: [Funktionsplan-Darstellung des LOGO!-Programms]
    )
    <zelle-3-programm>
  ]
)

@zelle-3-programm zeigt das #htl3r.long[fup]-Programm, welches von der Siemens LOGO! #htl3r.short[sps] ausgeführt wird, um die dritte Betriebszelle zu steuern.

Das Programm ist auf zwei wesentliche Bestandteile aufgeteilt:
  - Die Messung der Überschwemmungsgebiet-Füllstandssensoren und die Auslösung des Alarms. Dieser Teil ist in der oberen Hälfte von @zelle-3-programm zu sehen.
  - Die Messung der Damm-Füllstandssensoren und die Ansteuerung des Magnetventils. Dieser Teil ist in der unteren Hälfte zu sehen.

Bei der Messung der Flut-Sensoren Eins bis Drei wird darauf geachtet, ob diese eine Spannung von ca. 24V aufweisen. Diese Spannung wird durch ein eigenes Kabel in das Wasser vom Überschwemmungsgebiet übertragen. Da das innerhalb der Kläranlage verwendete Wasser nicht destilliert ist, leitet dieses Strom recht gut. Wenn nun das Spannungskabel und die offenen Kontakte der Flut-Sensoren (weitere Kabel, die in den Behälter ragen) per gemeinsamen Wasserkörper miteinander verbunden sind, fließt durch das Wasser Strom und aktiviert somit die Flut-Sensoren. Wenn alle drei Flut-Sensoren Spannung aufweisen -- was per "AND"-Funktionsbaustein überprüft wird -- das Signal an die Alarm-Outputs `Alarmsound_AN` und `Alarmlicht_AN` weitergeleitet. Da wie bei OpenPLC die LOGO! #htl3r.short[sps] keine direkte Setzung der Output-Variablen-Wert per #htl3r.short[scada] erlaubt, muss ein eigener Override-Wert `SCADA_Sound_Override` für das Ausschalten des Alarmsounds im Programm integriert sein. Dieser wird mit einem "NOT"-Funktionsbaustein invertiert, da hier eine Deaktivierung bei eingeschaltetem Wert erwünscht ist, darauf mit dem gemeinsamen Output der Flut-Sensoren per weiterem "AND"-Funktionsbaustein kombiniert und anschließlend in die Output-Variable `Alarmsound_AN` gespeichert. Für das Alarmlicht ist kein Override implementiert, sondern ein Impulsblock, welcher jede Sekunde das eingehende Signal aus- bzw. wieder einschaltet, um ein blinkendes Alarmlicht zu bewirken.

=== Schaltplan der dritten Betriebszelle

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/Zelle_3_Schaltplan.png"),
    caption: [Schaltplan der 3. Betriebszelle]
  )
)

#htl3r.author("Gabriel Vogler")
== 3D-Druck zur Herstellung passender Teile

Für einige Komponenten gab es keine passenden Teile, oder übermäßige Kosten für die Anschaffung.
Deshalb wurde die Entscheidung getroffen, diese Teile und ihre angepassten Varianten, die für die Anlage sogar noch besser passen, selbst zu designen und zu drucken.
Die Anschaffung des 3D-Druckers wurde privat getätigt und die Filamentkosten wurden von unserem Sponsor -- Ikarus -- übernommen.

#htl3r.author("Gabriel Vogler")
=== Modellierung der Teile

Die Modelle wurden mittels Autodesk Fusion 360 erstellt.

Die Modelle sind stark in ihrer Komplexität variierend. Einige sind sehr einfach zu modellieren, wie zum Beispiel die Tankdeckel der Zelle Zwei. Andere sind etwas aufwändiger, wie zum Beispiel die Archimedische Förderschnecke in der Zelle Eins.

#htl3r.author("Gabriel Vogler")
=== Details zum Druckprozess

Als Drucker wurde ein BambuLab A1 3D-Drucker verwendet.
Es wurde auf #htl3r.short[pla] und #htl3r.short[petg] Filament zurückgegriffen, da diese Materialien für den Einstieg in den 3D-Druck sehr gut geeignet sind und auf diesem Gebiet noch nicht sehr viele Erfahrungen vorhanden waren.
Außerdem sind diese Materialien in der Anschaffung günstiger als andere und bieten eine mehr als ausreichende Qualität, im Sinne von Stabilität und Strapazierfähigkeit, sowohl als auch in der Druckqualität.

Die Wahl des Filamentherstellers fiel auf das Filament von BambuLab, da diese das Filament und der Drucker aus dem selben Hause stammen und so perfekt aufeinander abgestimmt sind.
Außerdem ist das #htl3r.short[pla] Filament von BambuLab biologisch abbaubar und ist somit umweltfreundlicher und nachhaltiger als andere Filamente.

Für den Druck wurden die Standard Druckprofile von BambuLab verwendet, mit kleinen Anpassungen an die Druckgeschwindigkeit und die Temperatur, damit das für uns gewünschte Ergebnis erzielt werden konnte. Beim Druck von #htl3r.short[pva] wurde die Geschwindigkeit auf 50% reduziert, da das Filament sehr schlecht auf der Druckplatte haftet. Außerdem wurde die Temperatur um 10° verringert, da das #htl3r.short[pva] Filament bei zu hohen Temperaturen Feden zieht. 
Diese Profile werden automatisch erfasst sobald eine originale BambuLab Spule Filament in das #htl3r.short[ams] eingelegt wird.
Das Ganze funktioniert mithilfe eines #htl3r.short[rfid]-Chips, der auf der Spule angebracht ist und mit einem #htl3r.short[rfid]-Lesegerät im #htl3r.short[ams] kommuniziert.
Die Druckprofile sind außerdem auch noch von dem Druckermodell, der verwendeten Spitze und dem zu druckenden Modell abhängig.
Das wird automatisch berechnet und angepasst, sobald das Modell in die Drucksoftware geladen wurde.

Für das reibungslose Drucken wurde außerdem #htl3r.short[pva]-Filament verwendet, um Stützstrukturen zu drucken, die nach dem Druck einfach in Wasser aufgelöst werden können. Dies half dabei, auch komplexere Modelle zu drucken, die ohne Stützstrukturen nicht möglich gewesen wären und die dennoch eine hohe Qualität des Drucks gewährleisten. Das #htl3r.short[pva]-Filament stammt ebenfalls vom Hersteller BambuLab. Die Problematik bei der Verwendung von #htl3r.short[pva]-Filament ist, dass dieses eine sehr trockene Umgebung benötigt, da es sehr empfindlich gegenüber Feuchtigkeit ist. Anfänglich wurde probiert, das Filament im Vorhinein mit einem Filamenttrockner zu trocknen und anschließend aus dem #htl3r.short[ams] zu drucken. Obwohl in einem trockenen Raum gedruckt wurde, wollte das Filament nicht so wie gewünscht auf der Druckplatte und dem zu druckenden Körper haften. Nach einigen Anpassungen an den Druckeinstellungen sowie dem Wechsel von #htl3r.short[petg] auf #htl3r.short[pla] als Druckmaterial, konnte das Problem gelöst werden. Dies liegt daran, dass #htl3r.short[petg] heißer gedruckt werden muss als #htl3r.short[pla] und die Temperatur für das #htl3r.short[pva]-Filament zu hoch war und das Stützmaterial zum kochen begonnnen hat. Dies führte zum Ziehen von Fäden und somit zu einem unbrauchbaren Druck. Außerdem wurde das #htl3r.short[pva]-Filament direkt aus dem Filamenttrockner gedruckt, somit konnte auch während des Druckens die Trockenheit gewährleistet werden.

#pagebreak(weak: true)
== 3D-Modelle
Damit sowohl die Förderschnecke als auch die Tankeinlässe in der Anlage so umgesetzt werden konnten, wie sie geplant waren, mussten einige Teile selbst modelliert und gedruckt werden, da es keine passenden Teile auf dem Markt gab. Im Folgenden werden die 3D-Modelle der Teile vorgestellt, die für die Anlage gedruckt wurden. Gerade die Förderschnecke und die Halterung des Schneckenmotors sind essentiell für die Funktionsweise der Anlage.

=== Förderschnecke <schnegge>
Die archimedische Schraube wurde 3D-modelliert. Gestartet wurde mit dem Erstellen des Stabs in der Mitte, um welchen die Schraube sich dann wickelt. Außerdem befindet sich am Ende des Stabs eine Ausparung, welche zur Befestigung eines 50rpm Schneckenmotors dient. Dieser Motor treibt die Schraube an und sorgt somit für den Transport des Wassers und dessen Inhaltsstoffen. Im nächsten Schritt wurde um den Stab eine Spirale gezeichnet, diese hat eine Querschnittsfläche eines Dreiecks, mit zwei Ecken nach außen und die dritte Ecke in die Mitte zeigend. Damit konnte anschließend von der Ecke auf den Stab eine Linie projeziert werden, worum sich dann die Förderschnecke wickelt. Es wurde eine Skizze erstellt, was die Schraube für eine Querschnittsfläche haben soll und anhand davon dann die Schraube entlang des Stabs nach oben extrudiert. Der Vorteil eines solchen Modellierungsprozesses, ist die Möglichkeit die Schraube im Nachhinein noch beliebig zu verändern, da alle Skizzen und Aktionen von einander abhängen. Sobald eine Skizze verändert wird, wird das Modell automatisch angepasst. Dies war hilfreich, da die Schraube anfangs nicht genug Wasser transportierte, da dieses an den Seiten herauslief. Durch das Schließen der Spirale konnte das Problem behoben werden.

#htl3r.fspace(
  figure(
    image("../assets/3D-Modelle/Fenrir_Förderschnecke.png", width: 90%),
    caption: [3D-Modell der Förderschnecke]
  )
)

=== Schneckenmotor-Halterung <motor-halterung>
Der Schneckenmotor ist mittels einer 3D-gedruckten Halterung befestigt. Diese Halterung wurde genau an die Maße des Motors angepasst und schließt diesen somit fest ein. Die Halterung hat auf jeder Seite zwei 1 cm große Löcher, welche zur Begestigung dienen, da der Motor über einem offen Behälter hängt. In diese Löcher werden jeweils ein etwas längerer und ein etwas kürzerer Bolzen gesteckt, um den Motor zu befestigen. Der kürzere Bolzen liegt dann auf dem Behälter auf und der längere wird auf den jeweils links und rechts vom Behälter platzierten Stützen befestigt. Die Bolzen und Stützen sind ebenfalls 3D-gedruckt und sind mit der Halterung ausschließlich durch Steckverbindungen verbunden. Durch eine genaue Anpassung der Maße, konnte die Halterung ohne Schrauben oder Kleber befestigt werden und dennoch fest sitzen. Dabei wurden die Innenwände um 0,1 mm nach außen versetzt. Um zu garantieren, dass der Motor nicht frontal herausfällt, wurde außerdem eine Abdeckung gedruckt. Diese wird einfach auf den Motor gesetzt und anschließend an die Halterung mit vier M3 Schrauben befestigt. Das Gewinde ist in die Halterung gedruckt und die Löcher in der Abdeckung sind abgesenkt, damit der Senkkopf der Schraube nicht übersteht.

#htl3r.fspace(
  figure(
    image("../assets/3D-Modelle/Motor_Halterung.png"),
    caption: [3D-Modell der Halterung für den Schneckenmotor]
  )
)

#pagebreak(weak: true)

=== Tankabdeckungen für Zelle Zwei
Für beide Tanks der Zelle Zwei wurden idente Deckel entworfen und gedruckt. Diese Deckel haben eine Öffnung für einen Schlauch, welcher als Zufluss dient. Außerdem sind im Deckel die notwendigen Sensoren befestigt. Der Füllstandssensor wird durch die Öffnung von oben in den Tank gesteckt und liegt auf dem Deckel auf. Der Temparatursensor hat eine eigene Öffnung, in welche dieser dann ebenfalls von oben in den Tankgesteckt werden kann. Die Deckel sind so konzipiert, dass die 3 Löcher nur so groß wie nötig sind, damit keine Verunreinigungen ins Wasser kommen können. Die Löcher wurden mit kreisförmigen Skizzen erstellt und anschließend Extrudiert und damit Deckel ausgeschnitten. damit diese nicht verrutschen gibt es an der Unerseite des Deckels eine Erhöhung, die in den Tank hineinragt. Damit ist der Deckel ohne jeglichen Einsatz von Schrauben oder Kleber befestigt.

#htl3r.fspace(
  figure(
    image("../assets/3D-Modelle/Fenrir-Betriebszelle-2-Abdeckung.png", width: 90%),
    caption: [3D-Modell des Tankdeckels]
  )
)

#pagebreak(weak: true)

=== Zelle Zwei Elektronikbox
Die Elektronikbox, die den Raspberry Pi 4 und den ESP32, sowie die notwendige Verkabelung befindet sich in einer 3D-gedruckten Box. Diese Box wurde so konzipiert, dass der Raspberry Pi 4 und der ESP32 in der Box Platz finden und die Kabel ordentlich verlegt werden können. Die Box hat an der rechten Seite eine runde Öffnung für die Kabel, die in die Box hinein- und herausgehen. Auf der Vorderseite gibt es ein Loch für den RJ45 Anschluss des Raspberry Pi 4, damit dieser mit dem Netzwerk verbunden werden kann. Der Deckel hat ein weißes Fenrir Logo, welches mithilfe eines SVG Bildes in den Deckel modelliert werden konnte. Anschließend wurde mithilfe des #htl3r.short[ams] das Logo mitsamt des Deckels gedruckt. Beim Deckel wurde darauf geachtet, dass dieser in die Box gesteckt werden kann und nicht abfällt. Dafür wurde am Deckel eine Erhöhung gedruckt, die in die Box hineinragt und somit den Deckel festhält. Diese Erhöhung wurde vom Rand der Box 0.1 mm nach innen versetzt, damit der Deckel nicht zu fest sitzt und dennoch nicht abfällt.
#htl3r.fspace(
  figure(
    image("../assets/3D-Modelle/Fenrir_Zelle_2_Box.png", width: 80%),
    caption: [3D-Modell der Elektronikbox]
  )
)

#pagebreak(weak: true)

=== Zelle Drei "Einlasshalterung"
Für das Wassereinlaufbecken in der Zelle Drei wurde eine Halterung für den Wasserschlauch modelliert und gedruckt. Diese ist an den Beckenrändern links und rechts montiert. Dies wurde mithilfe von zwei Steckverbindungen erreicht. Das Becken hat etwa 2 cm x 0,5 cm große Löcher in die die Halterung gesteckt wird. Modelliert wurden die beiden Einschübe mit einer Skizze die anschließend 1 cm lang extrudiert wurde. Die Öffnung für den Schlauch wurde mit einer runden Skizze erstellt und anschließend extrudiert. Die Öffnung für den Schlauch wurde so angepasst, dass bei Bedarf der Schlauch einfach entfernt werden kann und dennoch bei Benutzung fest sitzt.

#htl3r.fspace(
  figure(
    image("../assets/3D-Modelle/Fenrir-Betriebszelle-3-Abdeckung.png"),
    caption: [3D-Modell der Einlasshalterung]
  )
)

#pagebreak(weak: true)

=== Zelle Drei Überschwemmungsgebiet Häuser
Für die Zelle Drei wurden mehrere kleine Häuser gedruckt. Es wurde ein Modell erstellt und anschließend im Slicer nach Belieben skaliert. Dabei enstanden drei Häuser in Originalgröße (4 cm Länge) und drei weitere halb so groß. Der Modellierungsprozess begann mit der Grundform des Hauses, einem Quader, auf dem dann ein Dreieck, was anschließend extrudiert wurde, platziert wurde. Der Reichfang ist durch einen Zylinder dargestellt. Dabei wurde eine Kreisförmige Skizze durch das Dach des Hauses hindurch extrudiert. Das Haus ist innen hohl, damit weniger Material verbraucht wird und es nicht notwendig ist, das Haus zu füllen.

#htl3r.fspace(
  figure(
    image("../assets/3D-Modelle/Fenrir_house_4.png", width: 90%),
    caption: [3D-Modell der Häuser]
  )
)

#htl3r.author("David Koch")
== Programmierung der Speicherprogrammierbaren Steuerungen <sps-programmierung>

#htl3r.shortpl[sps] können, im Vergleich zu "festverdrahteten" verbindungsprogrammierten Steuerungen (VPS), jederzeit digital umprogrammiert werden. Sie bieten somit einen viel flexibleren Umgang bei der Steuerung von industriellen Anlagen @vps-vs-sps[comp].

=== Überblick über die SPS-Programmiersprachen <sps-langs>

Bei der Programmierung von #htl3r.shortpl[sps] wird zwischen 5 in der EN 61131-3 #footnote("Europäische Norm EN 61131, basierend auf der internationalen Norm IEC 61131") genormten Programmiersprachen unterschieden. Diese wären:

/ #htl3r.short[awl] - "#htl3r.long[awl]": Basierend auf reinem #htl3r.short[ascii]-Text und vergleichbar mit Assemblerprogrammierung. Bei Siemens heißt sie STL (engl. kurz für "Statement List"). Diese Art der Programmierung gilt als veraltet und wird mit der Zeit hauptsächlich von #htl3r.short[st] abgelöst @sps-programmierung-1[comp].
/ #htl3r.short[st] - "#htl3r.long[st]": Basierend auf reinem #htl3r.short[ascii]-Text und angelehnt an konventionelle Programmiersprachen. Die Syntax der Sprachelemente ähneln denen der Programmiersprache Pascal und es wird bei Schlüsselwörtern keine Unterscheidung zwischen Groß- und Kleinschreibung gemacht. #htl3r.short[st] bietet mehr Strukturierungsmöglichkeiten als #htl3r.short[awl] und löst diese daher immer weiter ab @sps-programmierung-2[comp].
/ #htl3r.short[kop] - "#htl3r.long[kop]": Vergleichbar mit einem Stromlaufplan, der um 90° gedreht ist. In fast allen modernen #htl3r.short[kop]-Sprachen sind aber auch Funktionsblöcke verfügbar, die weit über die eigentliche Verknüpfungssteuerung hinausgehen und ähneln somit eher einem #htl3r.short[fup] @sps-programmierung-1[comp].
#htl3r.fspace(
    figure(
          image("../assets/Kontaktplan.svg"),
          caption: [Kontaktplan @kontaktplan-sps-image]
        ),
        figure(
          image("../assets/Stromlaufplan.svg", width: 55%),
          caption: [Stromlaufplan @kontaktplan-image]
        ),
)

/ #htl3r.short[fup] - "#htl3r.long[fup]": Auch als "Funktionsbausteinsprache" (kurz FBS) bekannt, diese Art der #htl3r.short[sps]-Programmierung ähnelt Logik-Schaltplänen @sps-programmierung-1[comp].
/ #htl3r.short[as] - "#htl3r.long[as]": Auch als Ablaufsteuerung bekannt, diese Art der #htl3r.short[sps]-Programmierung ist besteht aus einer Kette von Steuerungsschritten, welche durch Weiterschaltbedingungen (auch bekannt als "Transitionen") miteinander verbunden sind. An den einzelnen Schritten werden Befehle bzw. Aktionen eingebunden, diese dienen zur gezielten Ansteuerung von der jeweiligen Aktorik im System. Somit kann die #htl3r.long[as] als quasi "Flowchart-Programmierung" angesehen werden @sps-programmierung-2[comp].

Im Rahmen dieser Diplomarbeit werden #htl3r.short[kop]- und #htl3r.short[fup]-Programme verwendet.

=== Verwendete Entwicklungsumgebungen für die SPS-Programmierung

Je nach #htl3r.short[sps]-Modell bzw. Hersteller wird jeweils eine eigene Entwicklungsumgebung für die Programmierung benötigt. Jede der drei #htl3r.shortpl[sps], die in der Modell-Kläranlage verwendet werden, brauchen eine eigene Entwicklungsumgebung, die vom jeweiligen Hersteller zur Verfügung gestellt wird.

#htl3r.author("Gabriel Vogler")
==== OT-Workstation
Aufgrund der später in @firewall-config umgesetzten Netzwerksegmentierung wird man aus dem #htl3r.short[it]-Netz nicht direkt die #htl3r.shortpl[sps] programmieren bzw. erreichen können. Dafür wurde eine #htl3r.short[ot]-Workstation eingerichtet, auf die man sich dann mit #htl3r.short[rdp] über den Jump-Server verbinden kann. Die #htl3r.short[ot]-Workstation gibt es in zwei Formen. Einerseits als #htl3r.long[vm] auf dem vCenter und andererseits als physische Maschine. Die physische Maschine ist ein Lenovo Thinkpad T440. Auf beiden Ausführungen der #htl3r.short[ot]-Workstation ist die idente Konfiguration vorhanden.

#htl3r.fspace(
  figure(
    image("../assets/ot-laptop.png"),
    caption: [Der Laptop zur OT-Administration]
  )
)

Als Betriebssystem ist Windows 10 installiert, mit allen notwendigen Programmen, die für die Programmierung der #htl3r.shortpl[sps] benötigt werden. Dazu zählen das Siemens TIA Portal für die Programmierung der Siemens SIMATIC-#htl3r.short[sps], der OpenPLC-Editor für die OpenPLC-Runtime welche am Raspberry Pi läuft und das Siemens LOGO! Soft Comfort, welches für die Programmierung der Siemens LOGO!-#htl3r.short[sps] benötigt wird.

Die Installation des OpenPLC-Editors ist ziemlich einfach gehalten. Man muss lediglich die .exe-Datei von der OpenPLC-Website herunterladen und installieren. Im Vergleich ist die Installation des Siemens TIA Portals etwas komplizierter. Es gibt eine .exe-Datei und drei .iso-Dateien, dabei ist zu beachten, dass alle Dateien in einem Ordner liegen müssen. Anschließend wird die .exe-Datei ausgeführt und das TIA Portal installiert. Dies kann einige Zeit in Anspruch nehmen, da das TIA Portal sehr groß ist. Für die Installation des Siemens LOGO! Soft Comforts gibt es eine .exe-Datei, die einfach ausgeführt werden muss. Die Installation dauert nicht so lange wie die des TIA Portals, da das LOGO! Soft Comfort deutlich kleiner ist. Beim TIA Portal und beim LOGO! Soft Comfort gab es öfters Probleme mit der Installation, was dazu führte, dass sie mehrmals installiert werden mussten. Außerdem ist es zweimal, einmal beim TIA Portal und einmal beim LOGO! Soft Comfort, vorgekommen, dass die Installation das Betriebssystem beschädigt hat und Windows 10 neu installiert werden musste.

Sowohl die physische Maschine als auch die #htl3r.short[vm] haben ihre Vor- und Nachteile. Die physische Maschine ist unabhängig vom vCenter und kann direkt Vorort benutzt werden, auch wenn das VCenter nicht erreichbar ist. Die #htl3r.short[vm] hingegen ist leichter zu verwalten und kann mehrfach ausgerollt werden, sodass mehrere Personen gleichzeitig an der Programmierung arbeiten können. Ein weiterer Vorteil der #htl3r.short[vm] ist, dass sie die Fernwartung der #htl3r.shortpl[sps] ermöglicht.

#htl3r.author("David Koch")
==== Siemens TIA Portal

Das Siemens TIA ("Totally Integrated Automation") Portal ist eine Kombination aus verschiedenen Konfigurations- und Diagnose-Tools für von Siemens hergestellten #htl3r.shortpl[sps], #htl3r.shortpl[hmi] und sonstiger Peripherie @tia-portal-ref[comp].

Aus dieser Suite wird für die Programmierung der Siemens SIMATIC-#htl3r.short[sps] das Tool "STEP 7" verwendet. Die verwendeten Versionen sind hierbei V16 des TIA Portals und ebenfalls V16 von STEP 7.

Wichtig zu beachten ist, dass STEP 7 als einzige im Rahmen dieser Diplomarbeit verwendete #htl3r.short[sps]-Programmierungssoftware die Konfiguration von einem #htl3r.short[scada]-Override zulässt @s7-put-get[comp]. Bei der Konfiguration einer Variable in STEP 7 können Optionen aktiviert werden, die diese Variable sichtbar oder bearbeitbar von einem #htl3r.short[hmi] oder einem #htl3r.short[scada]-System aus machen. Bei den Programmierungsumgebungen von der OpenPLC- und der LOGO!-#htl3r.short[sps] sind alle Output-Variablen standardmäßig von äußeren Quellen aus sichtbar sowie bearbeitbar.

#htl3r.fspace(
  figure(
    image("../assets/ot-work/simatic_vars.png"),
    caption: [Der Laptop zur OT-Administration]
  )
)

==== OpenPLC-Editor

Die Bereits im @steuerung-zwei erwähnte Software-#htl3r.short[sps]-Runtime -- die "OpenPLC-Runtime" -- kann mithilfe des OpenPLC-Editors mittels grafischer Oberfläche mit Funktionsbausteinen oder auch mittels eingebautem Texteditor programmiert werden, je nach gewünschter #htl3r.short[sps]-Programmierart (siehe @sps-langs).

==== OpenPLC-Webdashboard

Der OpenPLC-Editor kann nicht direkt ein Programm auf die Runtime hochladen. Um dies zu tun, muss das OpenPLC-Webdashboard (der Runtime) geöffnet werden, wo, unter anderem, Programme hochgeladen und gestartet werden können, das #htl3r.short[psm] programmiert und Monitoring durchgeführt werden kann.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/ot-work/openplc_compile.png"),
    caption: [Kompilieren des OpenPLC-Programms im Webdashboard]
  )
)

Weil das Webdashboard als einziges Tool in der OpenPLC-Suite diese Funktionen bietet, kann es nicht gestoppt bzw. deaktiviert werden, ohne dabei die gesamte Runtime zu stoppen. Dies bietet im Vergleich zu anderen #htl3r.shortpl[sps] eine große Angriffsfläche. Es somit auch besonders wichtig, das Passwort vom Default-Admin "openplc" zu ändern (siehe @openplc-manipulation).

#htl3r.author("Gabriel Vogler")
==== Siemens LOGO! Soft Comfort

Im Vergleich zu einer Siemens SIMATIC-#htl3r.short[sps] kann eine Siemens LOGO!-#htl3r.short[sps] nicht mittels STEP-7 programmiert werden. Für die LOGO!-Reihe bietet Siemens eine vom TIA Portal unabhängige Entwicklungsumgebung an, die "Siemens LOGO! Soft Comfort".

#htl3r.author("David Koch")
=== OpenPLC Python Submodule <openplc-psm>

Um die aus der #htl3r.short[sps]-Programmierung bekannten Hardwareadressen auf einem Raspberry Pi sinnvoll umzusetzen, hat das OpenPLC-Team eine neue Hardwareebene -- das "Python Submodule" (kurz #htl3r.short[psm]) eingeführt. In der Weboberfläche der OpenPLC-Runtime können somit durch ein Python-Skript die #htl3r.short[gpio]-Pins des Raspberry Pi und die "software-defined" #htl3r.short[sps]-Hardwareadressen verknüpft bzw. gemeinsam verwendet werden @openplc-psm-guide[comp].

#htl3r.fspace(
  total-width: 40%,
  figure(
    table(
      columns: (auto, auto),
      align: (left, left),
      table.header[*#htl3r.short[gpio]-Pin*][*SPS-Adresse*],
      [GPIO 13], [`%QX0.0`],
      [GPIO 15], [`%QX0.1`],
    ),
    caption: [Mapping der GPIO-Pins zu den SPS-Output-Adressen]
  )
)

Die für das #htl3r.short[psm] notwendigen Funktionen sind:
- `hardware_init()` initialisiert die nötigen Hardware-Komponenten.
- `update_inputs()` setzt die Input-Hardwareadressen.
- `update_outputs()` setzt die #htl3r.short[gpio]-Pins laut Output-Hardwareadressen.
- Die Main-Funktion für die Initialisierung der Hardware per `hardware_init()` und die periodische Ausführung von `update_inputs()` und `update_outputs()` (mit einem Intervall von 100ms).

Bei der Initiliasierung wird das #htl3r.short[psm] gestartet, die Temperatursensoren per "W1ThermSensor"-Python-Library geladen und die für die Pumpen-Relays zuständigen #htl3r.short[gpio]-Pins werden als Output-Pins konfiguriert. Es ist hierbei wichtig zu beachten, dass die Variable `sensors`, die die Temperatursensoren beinhaltet, am Anfang der Funktion als globale Variable gekennzeichnet wird. Dies muss gemacht werden, da sie von dieser Funktion als auch der Funktion `update_inputs()` benötigt wird, aber keine direkte Referenz-Übergabe per Funktionsparameter möglich ist.

#htl3r.code(caption: "Die Initialisierung der Hardware-Komponenten im PSM", description: none)[
```python
def hardware_init():
    global sensors
    psm.start()
    sensors = W1ThermSensor.get_available_sensors([Sensor.DS18B20])
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(13, GPIO.OUT, initial=GPIO.LOW)
    GPIO.setup(15, GPIO.OUT, initial=GPIO.LOW)
```
]

In der `update_inputs()` Funktion werden sie Messwerte der Temperatursensoren und der Füllstandssensoren ausgelesen und in den Input-Variablen `%IW0` bis `%IW4` gespeichert. Die Werte des DS18B20-Temperatursensors lassen sich durch die Python-Bibliothek `w1thermsensor` ganz einfach mittels `.get_temperature()` auslesen. Da die Werte der Füllstandssensoren zuerst vom ESP32 verarbeitet werden müssen und erst danach per #htl3r.short[i2c] an OpenPLC geschickt werden fällt das Auslesen dieser etwas komplexer aus. Es wird zuerst eine Hello-Nachricht an den ESP32 geschickt, welcher auf diese mit den derzeitigen Messwerten antwortet. Da die Antwort nicht sofort stattfindet, ist eine 50ms Verzögerung zwischen der Hello-Nachricht und dem Auslesen der #htl3r.short[i2c]-Werte nötig. In @diy-i2c wird der nötige Programmcode für die #htl3r.short[i2c]-Kommunikation genauer erklärt.

#htl3r.code(caption: "Erfassung und Setzung der Input-Werte im PSM", description: none)[
```python
def update_inputs():
    global sensors
    temperature1 = int(sensors[0].get_temperature())
    psm.set_var("IW0", temperature1)
    temperature2 = int(sensors[1].get_temperature())
    psm.set_var("IW1", temperature2)
    write_to_esp32(ESP_I2C_address, "hello")
    time.sleep(0.05)
    data = read_from_esp32(ESP_I2C_address, 32)
    psm.set_var("IW2", data[0])
    psm.set_var("IW3", data[1])
```
]

In der `update_outputs()` Funktion werden die vom OpenPLC-Programm gesetzten Output-Variablen `%QX0.0` und `%QX0.1` ausgelesen und jeweils auf die #htl3r.short[gpio]-Pins 13 und 15 gemappt. Erst bei der Setzung der #htl3r.short[gpio]-Pins auf "Hoch" wird das jeweilige Pumpen-Relay aktiviert.

#pagebreak(weak: true)
#htl3r.code(caption: "Setzung der GPIO-Pins anhand der Output-Werte im PSM", description: none)[
```python
def update_outputs():
    filter_pump_active = psm.get_var("QX0.0")
    if filter_pump_active == 1:
        GPIO.output(13, GPIO.HIGH)
    else:
        GPIO.output(13, GPIO.LOW)

    prog_pump_active = psm.get_var("QX0.1")
    if prog_pump_active == 1:
        GPIO.output(15, GPIO.HIGH)
    else:
        GPIO.output(15, GPIO.LOW)
```
]

Um beim Start des #htl3r.short[sps]-Programms die Hardware zu initialisieren und die Update-Funktionen in einer Dauerschleife vereint aufzurufen, wird die folgende Main-Methode verwendet:

#htl3r.code(caption: "Main-Methode des PSM", description: none)[
```python
if __name__ == "__main__":
    hardware_init()
    while (not psm.should_quit()):
        update_inputs()
        update_outputs()
        time.sleep(0.1)
    psm.stop()
```
]

#pagebreak(weak: true)
#htl3r.author("David Koch")
== Programmierung eines I²C-Kommunikationsbusses <diy-i2c>

Um einen Kommunikationskanal zwischen der Software-#htl3r.short[sps] (OpenPLC) auf dem Raspberry Pi und dem Analogdigitalwandler ESP32 für die Füllstandssensoren in Betriebszelle zwei herzustellen, wird ein Zweidrahtbussystem mit dem Protokoll #htl3r.short[i2c] verwendet.

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

=== Kodierung der I²C-Daten

Bei der Datenübertragungen über einen #htl3r.short[i2c]-Bus wird folgendes Frame-Format verwendet:

#htl3r.fspace(
  figure(
    image("../assets/i2c_standard_frame.png"),
    caption: [Das I²C-Frame-Format]
  )
)

Das Protokoll des #htl3r.short[i2c]-Bus ist von der Definition her recht einfach, aber auch recht störanfällig @i2c-disturbance. Wie man erkennen kann, werden pro Frame insgesamt 16 Bits an Nutzdaten übertragen. Dazu gibt es keinen Mechanismus zur Erkennenung von Übertragungsfehlern, nur ACK/NACK Bits, ob Bits überhaupt angekommen sind.

Um dieses Problem zu lösen wird über die #htl3r.short[i2c]-Kommunikation zwischen Raspberry Pi und ESP32 eine weitere Kommunikationsschicht erstellt. Beispiel aus der Netzwerktechnik: Frames der #htl3r.short[osi]-Schicht zwei übertragen in ihren Nutzdaten alle Bits der Packets auf #htl3r.short[osi]-Schicht drei, somit bildet #htl3r.short[i2c] die quasi Unterschicht und das Custom-Fenrir-Protokoll die Oberschicht.

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

Wie in @fenrir-frame zu erkennen ist, besitzt der Frame abgesehen von Nutzdaten auch einen Frame-Start-Fixwert von `0x02`, eine Angabe der Frame-Länge in Bytes, eine #htl3r.short[crc]8-Prüfsumme der Nutzdaten-Bits und einen Frame-End-Fixwert von `0x04`.

Die #htl3r.short[crc]8-Prüfsumme der Nutzdaten-Bits wird auf dem Raspberry Pi mittels Python folgend berechnet:

#htl3r.code(caption: "Berechnung der CRC8-Prüfsumme in Python", description: none)[
```python
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
]

Das ganze findet klarerweise auch auf der Slave-Seite statt, dort ist der #htl3r.short[crc]8-Code jedoch in der Programmiersprache C implementiert worden.

=== Integration der I²C-Daten in OpenPLC <i2c-integration>

OpenPLC Version drei basiert auf dem Busprotokoll Modbus bzw. Modbus-#htl3r.short[tcp]. Somit kann nicht ohne weitere Konfiguration ein Gerät mittels #htl3r.short[i2c] oder einem anderen Busprotokoll mit OpenPLC verbunden und automatisch erkannt werden. Mit dem #htl3r.short[psm] von OpenPLC lassen sich software-defined Modbus-Register erstellen, welchen die über den #htl3r.short[i2c]-Bus erhaltenen Daten des ESP32 enthalten. Mehr Informationen zum #htl3r.short[psm] sind in @openplc-psm zu finden.

Bevor die Daten per #htl3r.short[psm] gemappt werden können, müssen sie zuerst empfangen und dekodiert werden. Dazu wird folgende Python-Funktion verwendet:

#htl3r.code(caption: "Auswertung der Daten am I²C-Datenbus für das PSM", description: none)[
```python
def read_from_esp32(i2caddress: hex, size: int):
    decoder = I2C_Decoder()
    try:
        # get data sent by ESP32, in raw format
        stream = bus.read_bytes(i2caddress, size)
        data = decoder.write(stream)
        return data

    except Exception as e:
        print("ERROR: {}".format(e))
```
]

Die Adafruit-SMBus-Library bietet die Methode ```.read_bytes()``` an, um von einer zuvor mit ```bus = SMBus(1)``` deklarierten #htl3r.short[i2c]/SMBus-Leitung die Nutzdaten der #htl3r.short[i2c]-Frames zu lesen. Diese werden dem selbstgeschriebenen #htl3r.short[i2c]-Decoder übergeben, damit dieser aus den #htl3r.short[i2c]-Rohnutzdaten den "Fenrir"-Frame rekonstruieren und somit die gewünschten Nutzdaten (Füllstandsmesswerte) inklusive Prüfsumme gewinnen kann.

Um die Werte vom ESP32 zu erhalten, welcher ein #htl3r.short[i2c]-Slave-Gerät ist, muss der Raspberry Pi als #htl3r.short[i2c]-Master-Gerät zuerst eine Nachricht an den Slave schicken, dass dieser überhaupt mit dem Füllstandsdaten antwortet. Dies wird mit folgender Python-Funktion gemacht:

#htl3r.code(caption: "I²C-Kommunikation von OpenPLC zu ESP32", description: none)[
```python
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

Um die über einen #htl3r.short[i2c]-Bus erhaltenen Daten in OpenPLC auf einem Raspberry Pi einsetzen zu können, müssen diese über das #htl3r.short[psm] (für genauere Erklärung siehe @openplc-psm) auf eine #htl3r.short[sps]-Hardwareadresse gemappt werden. Beispielsweise kann der erste vom ESP32 erhaltenene Wert auf die Hardwareadresse `%IW2` gemappt werden:
#htl3r.code(caption: "PSM-Mapping einer SPS-Hardwareadresse", description: none)[
```python
data: list[int] = read_from_esp32(ESP_I2C_address, 32)
psm.set_var("IW2", data[0])
```
]

Nun kann die #htl3r.short[sps]-Hardwareadresse `%IW2` in einem #htl3r.short[sps]-Programm mit einer Input-Variable verknüpft und verwendet werden:

#htl3r.fspace(
  [
    #figure(
      image("../assets/ot-work/openplc_vars.png", width: 115%),
      caption: [Alle Variablen der OpenPLC-SPS]
    )
    <openplc-vars>
  ]
)

Im Screenshot von @openplc-vars sind alle Variablen der OpenPLC-#htl3r.short[sps] in Zelle Zwei zu sehen, darunter auch die Variable `TANK_1_LEVEL`, welche zuvor per #htl3r.short[psm] aus Python in eine Hardwareadresse geladen worden ist.

#htl3r.fspace(
  figure(
    image("../assets/openplc/openplc_tank_comp.png", width: 50%),
    caption: [Einsatz der PSM-gemappten Hardwareadresse `%IW2` als `TANK_1_LEVEL` in der SPS-Logik]
  )
)

#htl3r.author("Gabriel Vogler")
== Schaltschrank der Modell-Kläranlage

Der Schaltschrank der Modell-Kläranlage ist ein 19 Zoll Netzwerkschrank der Firma Schrack. Darin sind  zwei Hutschienen verbaut.

An der oberen Hutschiene hängen die Netzwerkkomponenten des #htl3r.short[ot]-Netzwerks. Dazu gehören die Zellen-Firewall als auch ein industrieller Switch von Phoenix Contact für das #htl3r.short[span]-Mirroring des Datenverkehrs zwischen Zellen- und Übergangs-Firewall an die Nozomi Guardian.

An der unteren Hutschiene hängt die gesamte Steuerungstechnik aller Betriebszellen bis auf die von Betriebszelle Zwei. Unter anderem sind auch die nötigen Stromversorgungen bzw. Netzteile der #htl3r.short[ot]-Geräte an der unten Hutschiene angebracht.

#htl3r.fspace(
  figure(
    image("../assets/schrank.jpg", width: 92%),
    caption: [Der Schaltschrank der Modell-Kläranlage]
  )
)
