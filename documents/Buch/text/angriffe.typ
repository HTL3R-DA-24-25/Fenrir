#import "@preview/htl3r-da:0.1.0" as htl3r

= Angriffe auf das Netzwerk

== Einführung
#htl3r.author("David Koch")

=== Sicherheitsmängel bei Bus-Systemen
Im Vergleich zu anderen digitalen Netzwerksystemen der heutigen Zeit sind Bussysteme vom Grundprinzip aus außerordentlich unsicher und leicht manipulierbar. Alle Geräte eines Bussystems hängen an einer Broadcast-Domain, was heißt, dass alle Geräte jeweils alle Informationen, die über den Bus geschickt werden, mitlesen können. Noch dazu werden die über den Bus versendeten Daten unter anderem nicht auf einen legitimen Absender oder Datensatz kontrolliert. Zwar bieten manche TCP/IP-enkapsulierten Bussysteme eine verschlüsselte End-to-End-Kommunikation, jedoch sind diese heutzutage auch nicht ansatzweise weit verbreitet aufzufinden. Konzepte wie die CIA-Triade und das Triple-A-System sind der Bus-Welt fremd.

Im Falle eines Angriffs auf ein Bussystem und somit auf das gesamte #htl3r.short[ot]-Netzwerk liegen dem Angreifer viele Möglichkeiten vor, große Schäden anzurichten. Ob nun lediglich alle Informationen mitgehört werden oder doch eine DoS-Attacke auf #htl3r.short[sps] innerhalb des Bussystems stattfindet, um den gesamten Betrieb lahmzulegen, ist offen. Eines ist jedoch klar: Durch eine ausreichende Absicherung des Übergangs zwischen #htl3r.short[it] und #htl3r.short[ot], das heißt der Firewall auf Ebene 2.5 des Purdue-Modells (siehe @purdue), sind Angriffe auf das #htl3r.short[ot]-Netzwerk am einfachsten zu meiden. Beispielsweise sollte bei der Ausbreitung eines Netzwerkwurms innerhalb des #htl3r.short[it]-Netzwerks dieser keinesfalls auch in das #htl3r.short[ot]-Netzwerk gelangen können.

=== Stuxnet
Stuxnet ist ein Computerwurm, der im Juni 2010 entdeckt und zuerst unter dem Namen RootkitTmphider beschrieben wurde. Das Schadprogramm wurde speziell entwickelt zum Angriff auf ein System zur Überwachung und Steuerung (#htl3r.short[scada]-System), das speicherprogrammierbare Steuerungen des Herstellers Siemens vom Typ Simatic S7 verwendet. Dabei wurde in die Steuerung von Frequenzumrichtern in Teheran, der Hautpstadt Irans, eingegriffen. Frequenzumrichter dienen beispielsweise dazu, die Geschwindigkeit von Motoren zu steuern. Solche Steuerungen werden vielfach eingesetzt, etwa in Industrieanlagen wie Wasserwerken, Klimatechnik oder Pipelines.

Da bis Ende September 2010 der Iran den größten Anteil der infizierten Computer besaß und es zu außergewöhnlichen Störungen im iranischen Atomprogramm kam, lag es nah, dass Stuxnet hauptsächlich entstand, um als Schadsoftware die Leittechnik (Zentrifugen) der Urananreicherungsanlage in Natanz oder des Kernkraftwerks Buschehr zu stören.

Stuxnet gilt aufgrund seiner Komplexität und des Ziels, Steuerungssysteme von Industrieanlagen zu sabotieren, als bisher einzigartig. Das heißt aber nicht, dass in der Zukunft nicht noch weitere Netzwerkwürmer auf das Internet losgelassen werden, dessen Hauptziel es seien wird, #htl3r.short[ot]-Netzwerke lahmzulegen.

=== Lateral Movement

Der Begriff "Lateral Movement" beschreibt das Vorgehen von Angreifern eines Netzwerks sich innerhalb dessen auf weitere Geräte auszubreiten, Schwachstellen auszukundschaften, Rechteausweitung (-> privilege escalation) durchzuführen und ihr endgültiges Angriffsziel zu erreichen. @lateral-movement-def

Bei der Durchführung von Lateral Movement gibt es einige bekannte Techniken, sogenannte Lateral Movement Techniques bzw. #htl3r.longpl[lmp] (#htl3r.shortpl[lmp]):

#htl3r.fspace(
  total_width: 100%,
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

Die obigen Techniken sind natürlich miteinander kombinierbar, z.B. (#htl3r.short[lotl]) und Remote Services. Es auch ebenfalls zu beachten, dass die Bewertung der Wahrscheinlichkeit und Erkennbarkeit in der obigen Tabelle von einer bestehenden Absicherung des Netzwerks und vorhandenen #htl3r.short[ids]-Geräten ausgeht.

Bevor der Angreifer jedoch mögliche #htl3r.shortpl[lmp] ausnutzen kann, muss dieser überhaupt in das Netzwerk eindringen. Dies geschieht meist durch Identity-Angriffe wie Phishing-Mails, aber auch durch maliziöse Downloads und kompromitierter Hardware.

Zur Entdeckung von möglicher Lateral-Movement-Aktivität im Netzwerk ...

Zur Verhinderung solcher Angriffe können ...

== Angriffe auf das IT-Netzwerk

=== Exchange

=== ...

== Angriffe auf das OT-Netzwerk

=== Physische Manipulation

=== DoS einer SPS

=== Manipulation einer SPS

=== SCADA

=== ...

== Konkretes Angriffsszenario

Phishing Mail an Buchhaltung von außen --> mittels stolen identity eines BH Mitarbeiters eine interne Spear-Phishing-Mail an OT-Engineer schicken bzgl. Inventurliste z.B. --> Angreifer nutzt die RDP Berechtigungen des OT-Engineers um weiter einzudringen --> LotL, Angreifer sammelt Infos über SCADA wie die Anlage intern ausschaut --> Default Credentials auf OpenPLC upsi --> Steuerung der Zelle 2 wird gesprengt/umprogrammiert --> Super GAU
