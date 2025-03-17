#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author("David Koch")
= Weitere Absicherung des Netzwerks <weitere-absicherung>

Bei der Absicherung eines Netzwerks kann man sich nicht auf ein Gerät beziehungsweise auf eine Art von Gerät, wie z.B. Firewalls, verlassen. Wenn nun beispielsweise ein Zero-Day-Exploit in FortiGate-Firewalls entdeckt wird, ist das Netzwerk so schwach wie vor der Absicherung durch Firewalls.

Eine Lösung wäre, Firewalls von unterschiedlichen Herstellern zu nutzen, um das Problem von Zero-Day-Exploits teilweise unterbinden zu können. Was aber auch wichtig für ein sicheres Netzwerk notwendig ist sind nicht nur Firewalls, sondern auch z.B. die Härtung von Endgeräten, inklusive Patch-Management.

#htl3r.author("Gabriel Vogler")
== Active Directory Härtung

=== LAPS

Dass die Admin-Passwörter beim Provisionierungsvorgang auf allen Geräten gleich gesetzt werden ist klarerweise ein Sicherheitsrisiko. Wenn ein Angreifer eines der Passwörter herausfindet, kann er sich auf allen anderen Geräten ebenfalls mit diesem Passwort anmelden -- Es kommt zu Lateral Movement.

TODO

#htl3r.author("David Koch")
== Patch-Management <patch>

Eine der wichtigsten Methoden zur Absicherung einzelner Geräte ist das Patch-Management. Die Einspielung neuer Updates bzw. Firmware die vom Hersteller dazu konzipiert worden sind, um die Sicherheit des Gerätes gezielt zu erhöhen, ist von großer Wichtigkeit.

Zwar lassen sich durch Updates sogenannte "Zero-Day-Exploits" -- Schwachstellen, die dem Hersteller des Geräts noch nicht bekannt sind -- nicht verhindern, trotzdem bieten Sicherheitsupdates ausreichenden Schutz gegen die große Mehrheit an Cyberangriffen, da die Ausbeutung von veralteter Gerätschaft mit Abstand am einfachsten ist.

Leider wird bei vielen Betrieben das Patch-Management stark vernachlässigt, da die Philosophie "Never touch a running system" (Deutsch: "Verändere nie ein laufendes System") bei vielen Systemadministrator*innen noch tief verankert ist. Wenn keine Updates notwendig sind, um die Geräte weiterhin ohne Veränderung zu betreiben, werden diese nicht eingespielt.

Das Risiko eines Update-bezogenen Fehlers ist zwar realistisch, lässt sich jedoch durch gut geplantes Patch-Management minimieren. Backups von bestehenden Geräten oder Update-Testläufe in virtuellen Testumgebungen erlauben Systemadministrator*innen das ausprobieren von (Sicherheits-)Updates, ohne dabei ein laufendes System zu gefährden.

In der Projekttopologie erhalten #htl3r.short[it]-Endgeräte, auf denen als Betriebssystem Windows läuft, automatisch regelmäßige Sicherheitsupdates von Microsoft. Die Firewalls erlauben den Microsoft-spezifischen Datenverkehr ins Internet. Auf betriebskritische Geräte wie #htl3r.shortpl[sps] müssen Updates vorsichtiger als bei #htl3r.short[it]-Endgeräten eingespielt werden. Hierbei muss die #htl3r.short[sps] gestoppt und vom restlichen #htl3r.short[ot]-Netzwerk abgetrennt werden, bevor eine neue Firmware installiert werden kann. Dieser Prozess ist zwar sehr aufwendig, vermeidet aber letztendlich Angriffe wie "#htl3r.short[dos] einer #htl3r.short[sps]", die in @dos-sps beschrieben sind.

=== Firmware-Update einer S7-1200

Um den in @dos-sps beschriebenen #htl3r.short[dos]-Angriff gegenüber der S7-1200 #htl3r.short[sps] zu vermeiden, muss die neuste Firmware auf das Gerät eingespielt werden. Der #htl3r.short[cve]-2019-10936 beschreibt, dass alle Firmware-Versionen unter V4.4.0 von der Schwachstelle betroffen sind. Wenn nun auf eine neuere beziehungsweise die neuste Firmware-Version geupdatet wird, ist die #htl3r.short[sps] vor diesem Angriff geschützt.

...

Das Update muss aufgrund der benötigten Neustarts zu einer Zeit durchgeführt werden, wo die #htl3r.short[sps] nicht aktiv in der Betriebsumgebung gebraucht wird. Bei vielen Betrieben sind diese Geräte aber 24/7 im Einsatz, somit muss entweder ein kurzes Zeitfenster für diese wichtigen Updates eingeplant werden oder alternativ die Absicherung vom Netzwerk bis hin zur betroffenen #htl3r.short[sps] so stattfinden, dass die Netzwerk-Schwachstelle überhaupt nicht ausgenutzt werden kann.

== Mikrosegmentierung <mikrosegmentierung>

Wenn durch die in beschriebene Netzwerksegmentierung mittels Firewalls im #htl3r.short[ot]-Bereich die einzelnen Betriebszellen trotz gemeinsamer Purdue-Ebene in mehrere Subnetze aufteilt spricht man von Mikrosegmentierung.

Die #htl3r.shortpl[sps] der Modell-Kläranlage können somit zwischen Betriebszellen nicht direkt miteinander kommunizieren und müssen über das #htl3r.short[scada] gehen, wenn Inter-Zellen-Kommunikation notwendig ist.

Die Zellen-Firewall ist "stateful", das heißt, dass keine Policies für Rückantworten manuell erstellt werden müssen. Es wird somit per Policy nur Kommunikation vom #htl3r.short[scada]-System zu den einzelnen #htl3r.shortpl[sps] erlaubt, die Rückantworten werden automatisch erlaubt und der restliche Verkehr wird blockiert. In diesem restlichen Verkehr ist die Kommunikation zwischen #htl3r.shortpl[sps] inkludiert, somit ist eine erfolgreiche Mikrosegmentierung der Betriebszellen umgesetzt worden.

#htl3r.code(caption: "Die Policy für die Kommunikation vom SCADA zur SPS der zweiten Betriebszelle", description: none)[
```fortios
config firewall policy
  edit 1
    set name "Root_to_OpenPLC"
    set srcintf "Cell2Vlnk1"
    set dstintf "internal2"
    set srcaddr "SCADA"
    set dstaddr "OpenPLC"
    set anti-replay enable
    set action accept
    set schedule "always"
    set service "PING" "MODBUS_TCP"
    set ips-sensor "OT-Security-IPS"
    set application-list "OT-DPI"
    set logtraffic all
    set status enable
  next
end
```
]

#htl3r.author("David Koch")
== NIS-2

Beim Betreiben von Industriebetrieben oder kritischer Infrastruktur ist es wichtig, die gesetzlich vorgelegten Spezifikationen einzuhalten. Diese gibt es auch für den digitalen Bereich, wobei die bekannteste und derzeit relevanteste Spezifikation bzw. Richtlinie die #htl3r.short[nis]-2 wäre.

"Die #htl3r.short[nis]-2-Richtlinie soll die Resilienz und die Reaktion auf Sicherheitsvorfälle des öffentlichen und des privaten Sektors in der EU verbessern. Der bisherige Anwendungsbereich der #htl3r.short[nis]-Richtlinie nach Sektoren wird mit #htl3r.short[nis]-2 auf einen größeren Teil der Wirtschaft und des öffentlichen Sektors ausgeweitet, um eine umfassende Abdeckung jener Sektoren und Dienste zu gewährleisten, die im Binnenmarkt für grundlegende gesellschaftliche und wirtschaftliche Tätigkeiten von entscheidender Bedeutung sind. Betroffene Einrichtungen müssen daher geeignete Risikomanagementmaßnahmen für dise Sicherheit ihrer Netz- und Informationssysteme treffen und unterliegen Meldepflichten." @nis-2-wko

Die #htl3r.short[nis]-2-Richtlinie unterscheidet zwischen wesentlichen und wichtigen Einreichtungen, für die teilweise unterschiedliche Vorschriften gelten @nis-2-massnahmen. Eine Kläranlage fällt laut Anhang I der Richtlinie in den siebten Sektor "Abwasser": "Unternehmen, die kommunales Abwasser, häusliches Abwasser oder industrielles Abwasser im Sinne des Artikels 2 Nummern 1, 2 und 3 der Richtlinie 91/271/EWG des Rates (23) sammeln, entsorgen oder behandeln, jedoch unter Ausschluss der Unternehmen, für die das Sammeln, die Entsorgung oder die Behandlung solchen Abwassers ein nicht wesentlicher Teil ihrer allgemeinen Tätigkeit ist" @nis2-richtlinie

#pagebreak(weak: true)
Unter anderem sind folgende Maßnahmen für eine wesentliche Einrichtung vorgesehen:

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (2fr, 3fr),
      inset: 10pt,
      align: (horizon + left, horizon + left),
      table.header(
        [*Maßnahme*], [*Im Rahmen der Diplomarbeit umgesetzt*],
      ),
      [Erstellung einer Risikoanalyse- \ und Informationssicherheitskonzepten], [Durch die Umsetzung eigener Angriffe ist eine partielle Risikoanalyse erstellt worden (siehe @angriffe-netzwerk).],
      [Maßnahmen zur Bewältigung \ von Sicherheitsvorfällen], [???],
      [Backup-Management und Wiederherstellung], [Es wurde kein Backup-Management umgesetzt. Es kann jedoch eine schnelle Wiederherstellung des virtualisierten Netzwerks mittels Provisionierung durchgeführt werden (siehe @provisionierung).],
      [Konzepte für Zugriffskontrollen], [Wurde durch den Einsatz des AGDLP-Prinzips in der AD-Umgebung umgesetzt (siehe @benutzerkonten).],
      [Software-Updates], [Es wurde manuelles Patch-Management durchgeführt (siehe @patch).],
      [Gerätekonfiguration], [AD-Geräte, Netzwerkgeräte sowie die SPSen wurden gehärtet.],
      [Netzwerksegmentierung], [Durch den Einsatz von FortiGate-Firewalls umgesetzt (siehe @firewall-config).],
      [Schulungen für Mitarbeiter/innen], [Da keine echten Mitarbeiter/innen vorhanden sind, wurden keine Schulungen organisiert.],
      [Zero-Trust-Prinzip], [Wurde nicht umgesetzt.]
    ),
    caption: [NIS-2-Maßnahmen für wesentliche Einrichtungen und deren Umsetzungsgrad in der Diplomarbeitstopologie],
  )
)

#htl3r.author("Julian Burger")
= Jumpbox für IT/OT Kommunikation
