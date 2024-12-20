#import "@local/htl3r-da:0.1.0" as htl3r

#let llist(..items) = box(align(left, list(..items.pos().map(item => list.item([#item])))))

= Active Directory
#htl3r.author("Gabriel Vogler")

== Logischer Aufbau
=== Gruppenstruktur
=== OU Struktur
== Exchange Server
== File Server

Active Directory Domain Services ist ein Verzeichnisdienst von Microsoft und dient der zentralen Verwaltung und Organisation von Benutzern, Benutzergruppen, Berechtigungen und Computern und einem Unternehmensnetzwerk. Es wird in der Regel auf eineem Windows Server installiert und findet in dem meisten Unternehmen Anwendung.

== Domain und Forest
Im Szenario des Firmennetzwerkes der Firma Fenrir, wird im #htl3r.longs[ad] auf eine Domain und einen Forest gesetzt, da es sich um ein kleines Unternehmen handelt und nur ein Standort vorhanden ist. Dadurch sind die Konfiguration und die Verwaltung des #htl3r.shorts[ids]s einfacher und übersichtlicher. Dennoch bietet die #htl3r.shorts[ad] Struktur genug Flexibilität und Erweiterungsmöglichkeiten, wie es in der realen Welt auch der Fall sein sollte, falls das Unternehmen wachsen sollte.

== Logischer Aufbau

=== OU-Struktur

=== Benutzerkonten

=== Benutzergruppen
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

== Domain Controller
#htl3r.author("David Koch")

Es gibt insgesamt zwei Domain Controller in der #htl3r.shorts[it]-Infrastruktur der Firma Fenrir.
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

== Exchange Server
Der Exchange Server ist ein E-Mail Server der Firma Micosoft.
Dieser Server wird welweit in einigen Firmen eingesetzt und bietet die Grundlage für jegliche Inter- und Intraunternehmen Kommunikation.

Damit der Exchange Server funktioniert, wird eine bestehenende #htl3r.shorts[ad] Struktur benötigt.

== File Server
