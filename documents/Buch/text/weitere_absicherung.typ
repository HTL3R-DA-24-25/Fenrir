#import "@preview/htl3r-da:0.1.0" as htl3r

#htl3r.author("David Koch")
= Weitere Absicherung des Netzwerks <weitere-absicherung>

Bei der Absicherung eines Netzwerks kann man sich nicht auf ein Gerät beziehungsweise auf eine Art von Gerät, wie z.B. Firewalls, verlassen. Wenn nun beispielsweise ein Zero-Day-Exploit in FortiGate-Firewalls entdeckt wird, ist das Netzwerk so schwach wie vor der Absicherung durch Firewalls.

Eine Lösung wäre, Firewalls von unterschiedlichen Herstellern zu nutzen, um das Problem von Zero-Day-Exploits teilweise unterbinden zu können. Was aber auch wichtig für ein sicheres Netzwerk notwendig ist sind nicht nur Firewalls, sondern auch z.B. die Härtung von Endgeräten, inklusive Patch-Management.

#htl3r.author("Gabriel Vogler")
== Active Directory Härtung

#htl3r.author("David Koch")
== Patch-Management

Eine der wichtigsten Methoden zur Absicherung einzelner Geräte ist das Patch-Management. Die Einspielung neuer Updates bzw. Firmware die vom Hersteller dazu konzipiert worden sind, um die Sicherheit des Gerätes gezielt zu erhöhen, ist von großer Wichtigkeit.

Zwar lassen sich durch Updates sogenannte "Zero-Day-Exploits" -- Schwachstellen, die dem Hersteller des Geräts noch nicht bekannt sind -- nicht verhindern, trotzdem bieten Sicherheitsupdates ausreichenden Schutz gegen die große Mehrheit an Cyberangriffen, da die Ausbeutung von veralteter Gerätschaft mit Abstand am einfachsten ist.

Leider wird bei vielen Betrieben das Patch-Management stark vernachlässigt, da die Philosophie "Never touch a running system" (Deutsch: "Verändere nie ein laufendes System") bei vielen Systemadministrator*innen noch tief verankert ist. Wenn keine Updates notwendig sind, um die Geräte weiterhin ohne Veränderung zu betreiben, werden diese nicht eingespielt.

Das Risiko eines Update-bezogenen Fehlers ist zwar realistisch, lässt sich jedoch durch gut geplantes Patch-Management minimieren. Backups von bestehenden Geräten oder Update-Testläufe in virtuellen Testumgebungen erlauben Systemadministrator*innen das ausprobieren von (Sicherheits-)Updates, ohne dabei ein laufendes System zu gefährden.

In der Projekttopologie erhalten IT-Endgeräte, auf denen als Betriebssystem Windows läuft, automatisch regelmäßige Sicherheitsupdates von Microsoft. Die Firewalls erlauben den Microsoft-spezifischen Datenverkehr ins Internet. Auf betriebskritische Geräte wie #htl3r.shortpl[sps] müssen Updates vorsichtiger als bei #htl3r.short[it]-Endgeräten eingespielt werden. Hierbei muss die #htl3r.short[sps] gestoppt und vom restlichen #htl3r.short[ot]-Netzwerk abgetrennt werden, bevor eine neue Firmware installiert werden kann. Dieser Prozess ist zwar sehr aufwendig, vermeidet aber letztendlich Angriffe wie "#htl3r.short[dos] einer SPS", die in @dos-sps beschrieben sind.

== Mikrosegmentierung

Wenn durch die in beschriebene Netzwerksegmentierung mittels Firewalls im #htl3r.short[ot]-Bereich die einzelnen Betriebszellen trotz gemeinsamer Purdue-Ebene in mehrere Subnetze aufteilt spricht man von Mikrosegmentierung.

Die #htl3r.shortpl[sps] der Modell-Kläranlage können somit zwischen Betriebszellen nicht direkt miteinander kommunizieren und müssen über das #htl3r.short[scada] gehen, wenn Inter-Zellen-Kommunikation notwendig ist.
