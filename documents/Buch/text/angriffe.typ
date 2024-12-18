#import "@local/htl3r-da:0.1.0" as htl3r

= Angriffe auf das Netzwerk

// temp maybe
== Sicherheitsmängel bei Bus-Systemen
Im Vergleich zu anderen digitalen Netzwerksystemen der heutigen Zeit sind Bussysteme vom Grundprinzip aus außerordentlich unsicher und leicht manipulierbar. Alle Geräte eines Bussystems hängen an einer Broadcast-Domain, was heißt, dass alle Geräte jeweils alle Informationen, die über den Bus geschickt werden, mitlesen können. Noch dazu werden die über den Bus versendeten Daten unter anderem nicht auf einen legitimen Absender oder Datensatz kontrolliert. Zwar bieten manche TCP/IP-enkapsulierten Bussysteme eine verschlüsselte End-to-End-Kommunikation, jedoch sind diese heutzutage auch nicht ansatzweise weit verbreitet aufzufinden. Konzepte wie die CIA-Triade und das Triple-A-System sind der Bus-Welt fremd.

Im Falle eines Angriffs auf ein Bussystem und somit auf das gesamte #htl3r.shorts[ot]-Netzwerk liegen dem Angreifer viele Möglichkeiten vor, große Schäden anzurichten. Ob nun lediglich alle Informationen mitgehört werden oder doch eine DoS-Attacke auf #htl3r.shorts[sps] innerhalb des Bussystems stattfindet, um den gesamten Betrieb lahmzulegen, ist offen. Eines ist jedoch klar: Durch eine ausreichende Absicherung des Übergangs zwischen #htl3r.shorts[it] und #htl3r.shorts[ot], das heißt der Firewall auf Ebene 2.5 des Purdue-Modells (siehe @purdue), sind Angriffe auf das #htl3r.shorts[ot]-Netzwerk am einfachsten zu meiden. Beispielsweise sollte bei der Ausbreitung eines Netzwerkwurms innerhalb des #htl3r.shorts[it]-Netzwerks dieser keinesfalls auch in das #htl3r.shorts[ot]-Netzwerk gelangen können.

=== Stuxnet
Stuxnet ist ein Computerwurm, der im Juni 2010 entdeckt und zuerst unter dem Namen RootkitTmphider beschrieben wurde. Das Schadprogramm wurde speziell entwickelt zum Angriff auf ein System zur Überwachung und Steuerung (#htl3r.shorts[scada]-System), das speicherprogrammierbare Steuerungen des Herstellers Siemens vom Typ Simatic S7 verwendet. Dabei wurde in die Steuerung von Frequenzumrichtern in Teheran, der Hautpstadt Irans, eingegriffen. Frequenzumrichter dienen beispielsweise dazu, die Geschwindigkeit von Motoren zu steuern. Solche Steuerungen werden vielfach eingesetzt, etwa in Industrieanlagen wie Wasserwerken, Klimatechnik oder Pipelines.

Da bis Ende September 2010 der Iran den größten Anteil der infizierten Computer besaß und es zu außergewöhnlichen Störungen im iranischen Atomprogramm kam, lag es nah, dass Stuxnet hauptsächlich entstand, um als Schadsoftware die Leittechnik (Zentrifugen) der Urananreicherungsanlage in Natanz oder des Kernkraftwerks Buschehr zu stören.

Stuxnet gilt aufgrund seiner Komplexität und des Ziels, Steuerungssysteme von Industrieanlagen zu sabotieren, als bisher einzigartig. Das heißt aber nicht, dass in der Zukunft nicht noch weitere Netzwerkwürmer auf das Internet losgelassen werden, dessen Hauptziel es seien wird, #htl3r.shorts[ot]-Netzwerke lahmzulegen.
