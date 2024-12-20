#import "@htl3r/document:0.1.0": *
#show: conf.with(
  title: [Fenrir Buch],
  subtitle: none,
  authors: ("Gabriel Vogler",),
  fach: "FACH",
  thema: "THEMA",
  enumerate: true
)

#let llist(..items) = box(align(left, list(..items.pos().map(item => list.item([#item])))))

= OT-Aufbau
== Staudamm (Betriebszelle 3)
=== Kompenenten
- #link("https://www.obi.at/aufbewahrungsboxen/eurobox-system-box-vollwand-30-x-20-x-7-cm-transparent/p/6691604")[Eurobox Vollwand 30x20x7 Transparent] <eurobox_30x20x7>
- Magnetventil <magnetventil>
- Siemens LOGO! SPS <logo_sps>
- #link("https://amzn.eu/d/0faSzN1W")[Wasserauslass] <wasserauslass>
=== Physischer Aufbau
Die letzte Zelle der Modell Kläranlage besteht grundsätzlich aus 3 wichtigen Komponenten.
==== Wasserspeicherbecken
Es handelt sich bei dem Becken um eine #link(<eurobox_30x20x7>)[Eurobox] mit den Maßen 30cm x 20cm x 7cm verwendet und hat an der Vorderseite ein Loch woran das #link(<magnetventil>)[Magnetventil] hängt. Mit dem Zusammenspiel dieser beiden Komponenten wird der Staudamm realisiert. Das Becken wird mit Wasser gefüllt und das Magnetventil kann geöffnet und geschlossen werden. Für diese Steuerung ist dann die #link(<logo_sps>)[Siemens LOGO! SPS] zuständig. Diese steuert das Magnetventil und somit den Wasserfluss. Für die Montage des Magnetventils wurde zunächst ein Loch in die #link(<eurobox_30x20x7>)[Eurobox] gebohrt. Dabei musste aufgepasst werden, dass man nicht zu schnell bohrt, weil sonst das Plastik entweder ausreißen oder wegschmelzen könnte. Anschließend wurde ein #link(<wasserauslass>)[Wasserauslass] durch das Loch gesteckt, mit Dichtungen wasserdicht gemacht und mit dem beigelegten Gegenstück verschraubt. An den Messingauslass wurden dann zwei 3D gedruckte Adapterstücke geschraubt, um daran das Magnetventil zu befestigen, da das Magnetventil eine 1/2 Zoll Schraubverbindung und der Messingauslass ein 3/4 Zoll Gewinde hat. Das Wasser vom Wasserspeicherbecken soll durch das Magnetventil in das Wassereinlaufbecken fließen. Aufgrunddessen wurde das Wasserspeicherbecken mit sechs Holzstücken erhöht, damit das Wasser mittels Gravitation in das Wassereinlaufbecken fließen kann.
==== Wassereinlaufbecken
Das Wasserinlaufbecken wird in zwei Teile geteilt. Einmal der See mit dem Fluss und einmal das trockene Land. Als Basis für das Becken wurde eine #link(<eurobox_30x20x7>)[Eurobox] verwendet.
==== Warnsirene
=== Elektronik
=== PLC-Programmierung (LOGO!)
=== Ablauf und Zusammenspiel
== 3D-Druck
Für einige Komponenten gab es keine passenden Teile, oder übermäßige Kosten für die Anschaffung dieser.
Deshalb wurde die Entscheidung getroffen diese Teile oder Abwandlungen, die für die Anlage sogar noch besser passen, selbst zu designen und zu drucken.
Die Anschaffung des 3D-Druckers wurde privat getätigt und die Filamentkosten wurden von unserm Sponsor der Ikarus übernommen.
=== Modellieren
Die Modelle wurden mittels Autodesk Fusion 360 erstellt.
Die Lizenz für die Software ist für SchülerInnen mit einem Nachweiß des aktiven Schulbesuchs kostenlos.
Die Modelle sind stark in ihrer komplexität variierend. Einige sind sehr einfach zu modellieren, wie zum Beispiel das Wasserspeicherbecken, andere sind sehr komplex und benötigen viel Zeit und Erfahrung, wie zum Beispiel die Tankdeckel der Zelle 2. Andere sind etwas aufwändiger, wie zum Beispiel die Archimedische Förderschnecke in der Zelle 1.
=== Drucken
Als Drucker wurde ein BambuLab A1 3D-Drucker verwendet.
Es wurde auf PLA und PETG Filament zurückgegriffen, da diese Materialien für den Einstieg in den 3D-Druck sehr gut geeignet sind und auf diesem Gebiet noch nicht sehr viele Erfahrungen vorhanden waren.
Außerdem sind diese Materialien in der Anschaffung günstiger als andere und bieten eine mehr als ausreichende Qualität, im Sinne von Stabilät und Strapazierfähigkeit, sowohl als auch in der Druckqualität.
Die Wahl des Filamentherstellers fiel auf das Filament von BambuLab, da diese das Filament und der Drucker aus dem selben Hause stammen und so perfekt aufeinander abgestimmt sind.
Außerdem ist das PLA Filament von BambuLab biologisch abbaubar und ist somit umweltfreundlicher und nachhaltiger als andere Filamente.
Für den Druck wurden die Standard Druckprofile von BambuLab verwendet, mit kleinen Anpassungen an die Druckgeschwindigkeit und die Temperatur, damit das für uns gewünschte Ergebnis erzielt werden konnte.
Diese Profile werden automatisch erfasst sobald eine originale BambuLab Spule Filament in das AMS eingelegt wird.
Das Ganze funktioniert mithilfe eines RFID-Chips, der auf der Spule angebracht ist und mit einem RFID-Lesegerät im AMS kommuniziert.
Die Druckprofile sind außerdem auch noch von dem Druckermodell, der verwendeten Spitze und dem zu druckenden Modell abhängig.
Das wird automatisch berechnet und angepasst, sobald das Modell in die Drucksoftware geladen wurde.


= Active Directory
Active Directory Domain Services  ist ein Verzeichnisdienst von Microsoft und dient der zentralen Verwaltung und Organisation von Benutzern, Benutzergruppen, Berechtigungen und Computern und einem Unternehmensnetzwerk. Es wird in der Regel auf eineem Windows Server installiert und findet in dem meisten Unternehmen Anwendung.
== Domain und Forest
Im Szenario des Firmennetzwerkes der Firma Fenrir, wird im Active Directory auf eine Domain und einen Forest gesetzt, da es sich um ein kleines Unternehmen handelt und nur ein Standort vorhanden ist. Dadurch sind die Konfiguration und die Verwaltung des ADs einfacher und übersichtlicher. Dennoch bietet die AD Struktur genug Flexibilität und Erweiterungsmöglichkeiten, wie es in der realen Welt auch der Fall sein sollte, falls das Unternehmen wachsen sollte.
== Domain Controller
Es gibt insgesamt zwei Domain Controller in der IT-Infrastruktur der Firma Fenrir.
Die Domain Controller teilen sich die Aufgaben:

#show table.cell.where(y: 0): strong
#show table.cell.where(x: 0): strong
#table(
  columns: (auto, 1fr, 1fr),
  align: (left, center, center),
  table.header[][DC1][DC2],
  [Rollen], align(left, llist("Domain Naming Master", "Primary Domain Controller")), llist("Infrastructure Master", "RID Pool Manager", "Schema Master"),
  [DHCP], "Ja", "Failover",
  [DNS], "Ja", "Ja",
  [Remoting], table.cell(colspan: 2, llist("PowerShell Remoting", "SSH Server", "RDP", "Remote Management"))
  
)


== OU-Struktur
== Benutzerkonten
== Benutzergruppen
#show table.cell.where(y: 0): set text(size: 8pt)
#show table.cell.where(x: 0): set text(size: 8pt)
#let J = table.cell(
  fill: green.lighten(60%),
)[X]
#let N = table.cell(
  fill: red.lighten(60%),
)[]
#table(
  columns: (1fr, auto, auto, auto, auto, auto),
  align: (left, center, center, center, center, center, center),
  table.header[Name][G_Infrastructure][G_Operations][G_Sales][G_Management][G_Marketing], 
  [DL_Infrastructure_R],  J, J, N, J, N,
  [DL_Infrastructure_M],  J, N, N, N, N,
  [DL_Operations_R],      J, J, N, N, N,
  [DL_Operations_M],      N, J, N, N, N,
  [DL_Sales_R],           N, N, J, J, J,
  [DL_Sales_M],           N, N, J, N, N,
  [DL_Management_R],      N, N, N, J, N,
  [DL_Management_M],      N, N, N, J, N,
  [DL_Marketing_R],       N, N, J, J, J,
  [DL_Marketing_M],       N, N, N, N, J
)

== AD Härtung

=== Exchange Server
Der Exchange Server ist ein E-Mail Server der Firma Micosoft.
Dieser Server wird welweit in einigen Firmen eingesetzt und bietet die Grundlage für jegliche Inter- und Intraunternehmen Kommunikation.

Damit der Exchange Server funktioniert, wird eine besthenende AD Struktur benötigt.

=== File Server


Begriffe:
- OU: Organizational Unit
- AD: Active Directory
- PLC: Programmable Logic Controller
- AMS: Automatic Material System
- RFID: Radio-Frequency Identification