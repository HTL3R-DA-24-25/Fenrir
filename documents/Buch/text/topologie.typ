#import "@local/htl3r-da:0.1.0" as htl3r

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