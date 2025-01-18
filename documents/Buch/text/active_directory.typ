#import "@preview/htl3r-da:0.1.0" as htl3r
#import "@preview/treet:0.1.1": *


#let llist(..items) = box(align(left, list(..items.pos().map(item => list.item([#item])))))

#htl3r.author("Gabriel Vogler")
= Active Directory

Active Directory Domain Services ist ein Verzeichnisdienst von Microsoft und dient der zentralen Verwaltung und Organisation von Benutzern, Benutzergruppen, Berechtigungen und Computern in einem Unternehmensnetzwerk. Diese zentrale Verwaltung erlaubt die Authentifizierung und Zugriffssteuerung dieser Benutzer und Computer, wobei auch ausserhalb von AD-integrierten Windows-Geräten diese Authentifizierung eingesetzt werden kann. Dieser wird auf einem Windows Server installiert und findet in dem meisten Unternehmen Anwendung.

== Domain und Forest
Im Szenario des Firmennetzwerkes der Firma "Fenrir", wird im #htl3r.long[ad] auf eine Domain und einen Forest gesetzt, da es sich um ein kleines Unternehmen handelt und nur ein Standort vorhanden ist. Dadurch sind die Konfiguration und die Verwaltung des #htl3r.short[ids] einfacher und übersichtlicher. Dennoch bietet die #htl3r.short[ad]-Struktur genug Flexibilität und Erweiterungsmöglichkeiten, wie es in der realen Welt auch der Fall sein sollte, falls das Unternehmen wächst.

== Logischer Aufbau
Der logische Aufbau des #htl3r.short[ad]s der Firma "Fenrir" wird mit Hilfe von #htl3r.short[ou], Benutzerkonten und Benutzergruppen strukturiert. Die Benutzerkonten und Benutzergruppen werden in den #htl3r.short[ou]s organisiert, um eine bessere Übersicht und Struktur zu gewährleisten:

=== OU-Struktur
#htl3r.fspace(
  total-width: 100%,
  figure(
    align(center, box(align(left, text[
      DC=corp,DC=fenrir-ot,DC=at\
      #tree-list[
        - OU=Accounts
          - OU=Sales
            - G_Sales
          - OU=Marketing
            - G_Marketing
          - OU=Operations
            - G_Operations
          - OU=Infrastructure
            - G_Infrastructure
          - OU=Management
            - G_Management
      ]
    ]))),
    caption: [GABI DENK DIR WAS AUS]
  )
)

=== Benutzerkonten
#show table.cell.where(y: 0): set text(size: 8pt)
#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (8em, auto, auto, auto,),
      align: (left, left, left, left),
      table.header[Benutzername][Vorname][Nachname][Abteilung],
      [buhlig], [Bastian], [Uhlig], [Infrastructure],
      [dkoch], [David], [Koch], [Management],
      [gvogler], [Gabriel], [Vogler], [Operations],
      [jbloggs], [Joe], [Bloggs], [Marketing],
      [jburger], [Julian], [Burger], [Infrastructure],
      [jdoe], [John], [Doe], [Sales],
      [jwinkler], [Johannes], [Winkler], [Sales],
      [mhuber], [Michael], [Huber], [Management],
      [mmeier], [Max], [Meier], [Operations],
      [mmuster], [Maria], [Mustermann], [Marketing],
    ),
    caption: [Visualisierung der Benutzer in der Domäne]
  )
)

=== Benutzergruppen
#show table.cell.where(y: 0): set text(size: 8pt)
#show table.cell.where(x: 0): set text(size: 8pt)
#let J = table.cell(
  fill: green.lighten(60%),
)[X]
#let N = table.cell(
  fill: red.lighten(60%),
)[]
#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (8em, auto, auto, auto, auto, auto),
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
    ),
    caption: [Visualisierung der Mitgliedschaft von Global Groups in Domain Local Groups],
  )
)

#htl3r.author("David Koch")
== Domain Controller

Es gibt insgesamt zwei Domain Controller in der #htl3r.short[it]-Infrastruktur der Firma "Fenrir".
Die Domain Controller teilen sich die Aufgaben:

#show table.cell.where(y: 0): strong
#show table.cell.where(x: 0): strong

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (5em, auto, auto),
      align: (left + horizon, center, center),
      table.header[][DC1][DC2],
      [Rollen], align(left + horizon, llist("Domain Naming Master", "Root/Primary Domain Controller")), llist("Infrastructure Master", "RID Pool Manager", "Schema Master"),
      [DHCP], "Ja", "Failover",
      [DNS], "Ja", "Ja",
      [Remoting], table.cell(colspan: 2, llist("PowerShell Remoting", "SSH Server", "RDP", "Remote Management"))
    ),
    caption: [Aufteilung der Features zwischen den Domain Controllern],
  )
)

== Exchange Server
Der Exchange Server ist ein E-Mail Server der Firma Micosoft.
Dieser Server wird weltweit in einigen Firmen eingesetzt und bietet die Grundlage für jegliche Inter- und Intraunternehmenskommunikation.

Damit der Exchange Server funktioniert, wird eine bestehenende #htl3r.short[ad] Struktur benötigt.

== File Server
