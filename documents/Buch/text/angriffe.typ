#import "@preview/htl3r-da:0.1.0" as htl3r

#htl3r.author("David Koch")
= Angriffe auf das Netzwerk

#htl3r.author("David Koch")
== Einführung

Um die Sicherheit der in den obigen Abschnitten erstellten Topologie,  herkömmlicher Firmennetzwerke mit OT-Abschnitten oder die Netzwerke von echter kritischer Infrastruktur zu gewährleisten braucht es ein theoretisches Verständnis von den möglichen Angriffsvektoren als auch die dazugehörige Absicherung, um gegen die bekannten Angriffsvektoren vorzugehen und somit Angriffen vorzubeugen.

=== Sicherheitsmängel bei Bus-Systemen
Im Vergleich zu anderen digitalen Netzwerksystemen der heutigen Zeit sind Bussysteme vom Grundprinzip aus außerordentlich unsicher und leicht manipulierbar. Alle Geräte eines Bussystems hängen an einer Broadcast-Domain. Das bedeutet, dass alle Geräte jeweils alle Informationen, die über den Bus geschickt werden, mitlesen können. Noch dazu werden die über den Bus versendeten Daten unter anderem nicht auf einen legitimen Absender oder Datensatz kontrolliert. Zwar bieten manche TCP/IP-enkapsulierten Bussysteme eine verschlüsselte End-to-End-Kommunikation, jedoch sind diese heutzutage auch nicht ansatzweise weit verbreitet aufzufinden. Konzepte wie die CIA-Triade und das Triple-A-System sind der Bus-Welt fremd.

Im Falle eines Angriffs auf ein Bussystem und somit auf das gesamte #htl3r.short[ot]-Netzwerk liegen dem Angreifer viele Möglichkeiten vor, große Schäden anzurichten. Ob nun lediglich alle Informationen mitgehört werden oder doch eine #htl3r.short[dos]-Attacke auf #htl3r.short[sps] innerhalb des Bussystems stattfindet, um den gesamten Betrieb lahmzulegen, ist offen. Eines ist jedoch klar: Durch eine ausreichende Absicherung des Übergangs zwischen #htl3r.short[it] und #htl3r.short[ot], das heißt der Firewall auf Ebene 2.5 des Purdue-Modells (siehe @purdue), sind Angriffe auf das #htl3r.short[ot]-Netzwerk leicht vermeidbar. Beispielsweise sollte bei der Ausbreitung eines Netzwerkwurms innerhalb des #htl3r.short[it]-Netzwerks dieser keinesfalls auch in das #htl3r.short[ot]-Netzwerk gelangen können.

=== Stuxnet <stuxnet>
Stuxnet ist ein Computerwurm, der im Juni 2010 entdeckt und zuerst unter dem Namen RootkitTmphider beschrieben wurde. Das Schadprogramm wurde speziell entwickelt zum Angriff auf ein System zur Überwachung und Steuerung (#htl3r.short[scada]-System), das speicherprogrammierbare Steuerungen des Herstellers Siemens vom Typ Simatic S7 verwendet. Dabei wurde in die Steuerung von Frequenzumrichtern in Teheran, der Hautpstadt Irans, eingegriffen. Frequenzumrichter dienen beispielsweise dazu, die Geschwindigkeit von Motoren zu steuern. Solche Steuerungen werden vielfach eingesetzt, etwa in Industrieanlagen wie Wasserwerken, Klimatechnik oder Pipelines.

Da bis Ende September 2010 der Iran den größten Anteil der infizierten Computer besaß und es zu außergewöhnlichen Störungen im iranischen Atomprogramm kam, lag es nah, dass Stuxnet hauptsächlich entstand, um als Schadsoftware die Leittechnik (Zentrifugen) der Urananreicherungsanlage in Natanz oder des Kernkraftwerks Buschehr zu stören @ndu-stuxnet.

Stuxnet gilt aufgrund seiner Komplexität und des Ziels, Steuerungssysteme von Industrieanlagen zu sabotieren, als bisher einzigartig @spiegel-10-jahre-stuxnet. Das heißt aber nicht, dass in der Zukunft nicht noch weitere Netzwerkwürmer auf das Internet losgelassen werden, dessen Hauptziel es seien wird, #htl3r.short[ot]-Netzwerke lahmzulegen.

=== Lateral Movement

Der Begriff "Lateral Movement" beschreibt das Vorgehen von Angreifern eines Netzwerks sich innerhalb dessen auf weitere Geräte auszubreiten, Schwachstellen auszukundschaften, Rechteausweitung (-> privilege escalation) durchzuführen und ihr endgültiges Angriffsziel zu erreichen. @lateral-movement-def

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
      "Internal Spear Phishing", "Angreifer nutzt das kompromitierte E-Mail-Konto eines Mitarbeiters aus, um mit deren Identität andere Mitarbeiter zu phishen", "Hoch", "Mittel",
      [#htl3r.long[lotl] (#htl3r.short[lotl])], "Angreifer nutzt die ihm bereits verfügbaren Admin-Tools um unaufällig in den Betriebsprozess einzugreifen und weitere Informationen zu erhalten", "Hoch", "Mittel/Schwer",
      "Default/Hardcoded Credentials", "Angreifer kann durch die öffentlich bekannten Standard-Zugangsdaten von im Netzwerk eingesetzer Software/Hardware diese übernehmen", "Niedrig", "Mittel",
      "Remote Services", "...", "...", "..."
    ),
    caption: [Bekannte #htl3r.longpl[lmp]],
  )
)
@lmp-list-1
@lmp-list-2

Die obigen Techniken sind natürlich miteinander kombinierbar, z.B. #htl3r.short[lotl] und Remote Services. Es auch ebenfalls zu beachten, dass die Bewertung der Wahrscheinlichkeit und Erkennbarkeit in der obigen Tabelle von einer bestehenden Absicherung des Netzwerks und vorhandenen #htl3r.short[ids]-Geräten ausgeht.

Bevor der Angreifer jedoch mögliche #htl3r.shortpl[lmp] ausnutzen kann, muss dieser überhaupt in das Netzwerk eindringen. Dies geschieht meist durch Identity-Angriffe wie Phishing-Mails, aber auch durch maliziöse Downloads und kompromitierter Hardware.

Zur Entdeckung von möglicher Lateral-Movement-Aktivität im Netzwerk können folgende Strategien eingesetzt werden:

- Mögliche #htl3r.shortpl[lmp] innerhalb des eigenen Netzwerks vorab auskundschaften, quasi in Form einer Risikoanalyse. Mit der fertigen Risikoanalyse kann proaktiv gegen #htl3r.shortpl[lmp] vorgegangen werden, aber auch für den Angriffsfall ein #htl3r.long[icp] zur Reaktion auf die ausgenutzten Schwachstellen erstellt werden, falls die Vorbeugung dieser zu umständlich seien sollte.
- Netzwerküberwachungs-Tools bzw. #htl3r.shortpl[ids], die den Systemadministrator*innen Analysedaten über den Datenverkehr im Netzwerk liefern und somit auf die Ausnutzung eines #htl3r.short[lmp] hinweisen.
- In Kombination mit der Nutzung von Überwachungs-Tools detailierte Dokumentationen führen, welche Geräte und Benutzer sich im Netzwerk aufhalten sollten und welche Rollen sie haben, um bei der Erkennung von unbekannten Geräten im Netzwerk als auch bei unberechtigten Zugriffen zu helfen.
@lateral-movement-def

Zur Verhinderung von Lateral Movement können unter anderem Netzwerksegmentierung, Patchmanagement zur Behebung von bekannten Sicherheitslücken als auch Zugriffskontrolle auf bestimmte Daten, Geräte oder Netzwerkabschnitte implementiert werden.
@lateral-movement-def

Die Umsetzung dieser Entdeckungs- als auch Verhinderungsstrategien in der "Fenrir"-Topologie wird in @netzwerkueberwachung, @firewall-config und @weitere-absicherung genauer beschrieben.

== Angriffe auf das IT-Netzwerk

=== Exchange

=== ...

== Angriffe auf das OT-Netzwerk

=== Physische Manipulation

Bevor die digitale Absicherung des OT-Netzwerks in Betracht zieht, sollte die physische Sicherheit der OT-Umgebung bereits gewährleistet sein. Wenn eine unauthorisierte Person beispielsweise in eine Fabrik einbrechen und dort die Steuerungstechnik manipulieren sollte -- egal ob das durch die Trennung eines Kabels oder der gezielten Umprogrammierung einer SPS durch ihre serielle Schnittstelle passiert -- ist vom schlimmsten auszugehen.

Die Menschheit ist sich schon seit langer Zeit über die Wichtigkeit der physischen Sicherheit bewusst, somit ...

... Überwachungssysteme wie CCTV, Perimeterschutz durch Stacheldrahtzäune und Alarmanlagen ...

=== DoS einer SPS

=== Manipulation einer SPS

Ein Angreifer sollte unter keinen Umständen die Programmierlogik einer #htl3r.short[sps] manipulieren können. Im Vergleich zu einem #htl3r.short[dos]-Angriff auf eine SPS oder andere Geräte im #htl3r.short[ot]-Netzwerk kann durch die gezielte Umprogrammierung einer #htl3r.short[sps] ein viel größerer Schaden in einem Bruchteil der Zeit angerichtet werden.

Der im obigen @stuxnet beschriebenen Stuxnet-Angriff wurden bestimmte Register ...

Da die Entdeckung eines Zero-Day-Exploits in einer Siemens #htl3r.short[sps] oder der OpenPLC-Codebasis den Rahmen dieser Diplomarbeit sprengen würde, wird ein vereinfachtes aber trotzdem realistisches Angriffsszenario zur Manipulation einer #htl3r.short[sps] durchgeführt. Dieses besteht aus einer von einem Angreifer per #htl3r.short[rdp]-Verbindung übernommenen Engineer-Workstation, welche Zugriff auf die Umprogrammierung von #htl3r.shortpl[sps] im OT-Netzwerk hat.

...

=== SCADA

=== ...

#htl3r.author("David Koch")
== Konkretes Angriffsszenario

Phishing Mail an Buchhaltung von außen --> mittels stolen identity eines BH Mitarbeiters eine interne Spear-Phishing-Mail an OT-Engineer schicken bzgl. Inventurliste z.B. --> Angreifer nutzt die RDP Berechtigungen des OT-Engineers um weiter einzudringen --> LotL, Angreifer sammelt Infos über SCADA wie die Anlage intern ausschaut --> Default Credentials auf OpenPLC upsi --> Steuerung der Zelle 2 wird gesprengt/umprogrammiert --> Super GAU
