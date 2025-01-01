# Busprotokolle

blabla kabel und protokolle für bus (einführung)

## Überblick

Hier ist eine kurze Übersicht über ein paar der bekanntesten Bus-Systeme gegeben. ACHTUNG: Alle Einträge hier sind ihre eigenen Bus-Systeme mit unterschiedlichen Verkabelungsanforderungen, haben aber somit auch ihre eigenen Protokolle!

\begin{itemize}
	\item[\acrshort{can}] Kurz für "'\acrlong{can}"'. Der \acrshort{can}-Bus ist ein serielles Bussystem, arbeitet nach dem "'Multi-Master-Prinzip"', das heißt er verbindet mehrere gleichberechtigte Steuergeräte und gehört zu den Feldbussen. Er wurde 1983 von Bosch entwickelt und 1986 zusammen mit Intel vorgestellt. Der Hauptanwendungsbereich des \acrshort{can}-Bus ist in der Automobilindustrie und sein Zweck ist es, Kabelbäume zu reduzieren und hiermit Kosten und Gewicht bei der Herstellung eines Autos zu sparen.
	^ https://de.wikipedia.org/wiki/Controller_Area_Network
	\item[Modbus] Siehe \autoref{sec:modbus}
	\item[\acrshort{i2c}] Kurz für "'\acrlong{i2c}"'. \acrshort{i2c} ist ein 1982 von Philips Semiconductors entwickelter serieller Datenbus, der als Master-Slave-Bus konzipiert ist, aber auch das Multi-Master-Prinzip unterstützt. Bei diesem Protokoll werden zwei Signalleitungen benötigt, eine Takt- (beziehungsweise Clock-) und eine Datenleitung. Eine Eigenschaft von \acrshort{i2c} ist die Tatsache, dass ein Mikrocontroller ein ganzes Netzwerk an integrierten Schaltungen mit nur zwei \acrshort{io}-Pins und einfacher Software kontrollieren kann. Daher wird \acrshort{i2c} hauptsächlich geräteintern für die Kommunikation zwischen verschiedenen Schaltungsteilen benutzt, kann aber auch geräteübergreifend verwendet werden.
	^ https://www.mikrocontroller.net/attachment/372171/I2C_bus.pdf
	^ https://de.wikipedia.org/wiki/I%C2%B2C
	\item[\acrshort{spi}] Kurz für "'\acrlong{spi}"'. Dieses Bus-System besteht aus den drei Hauptleitungen SLK (engl. für "'Serial Clock"'), MISO (engl. für "'Master Input, Slave Output"') und MOSI (engl. für "'Master Output, Slave Input"') für eine eine serielle synchrone Datenübertragung zwischen integrierten Schaltungen. Durch die drei Hauptleitungen ist \acrshort{spi} vollduplexfähig. Die vierte Leitung SS (engl. für "'Slave Select"') dient zur Ansteuerung der einzelnen Slave-Chips. Diese kann entweder als eine einzelne Leitung, die zwischen allen Teilnehmer als Bus agiert, existieren, kann aber auch für jeden Slave einzeln sein. Das würde heißen, dass jeder Slave seinen eigenen Anschluss am Master-Chip hat. Dies führt oftmals zu sehr viel Verkabelungsarbeit, was \acrshort{spi} für die meisten Bus-Angelegenheiten eher unbeliebt macht. Der einzige Vorteil gegenüber einem anderen Bus-System wie \acrshort{i2c} wäre die Vollduplexfähigkeit und somit der höhere Datendurchsatz.
	^ https://de.wikipedia.org/wiki/Serial_Peripheral_Interface
	^^^ BILDER VON WIKIPEDIA SUPER TOLL (kaskadierung vs sternverbindung von slaves)
	\item[\acrshort{profibus}] Kurz für "'\acrlong{profibus}"'. Als Standard für die Feldbus-Kommunikation in \acrshort{ics}-Systemen wurde \acrshort{profibus} unter anderem vom deutschen Bundesministerium für Bildung und Forschung gefördert, um dessen landesweite Umsetzung in, unter anderem, deutschen Industrieanlagen zu unterstützen.
	^ https://de.wikipedia.org/wiki/Profibus
	\item BLABLA 1-Wire bzw. One-Wire oder Eindraht-Bus beschreibt eine serielle Schnittstelle der Firma Dallas Semiconductor Corp. (Maxim Integrated, heute Analog Devices), die mit einer Datenader (DQ) auskommt, die sowohl als Stromversorgung als auch als Sende- und Empfangsleitung genutzt wird. Der Begriff 1-Wire ist irreführend, weil zudem noch eine Masse-Verbindung (GND) erforderlich ist. Die Verbindung arbeitet seriell und bidirektional, d. h. mit einer gemeinsamen Datenleitung für Senden und Empfangen. Die Datenübertragung erfolgt asynchron, d. h. es wird kein Taktsignal übertragen. Übertragen wird im Halbduplexverfahren, d. h. entweder wird ein Block gesendet, oder es wird ein Block empfangen, jedoch nicht beides zugleich. Die Übertragung erfolgt nach dem One-Master/Multi-Slave Prinzip.
\end{itemize}

Die für diese Diplomarbeit relevanten Busprotokolle sind Modbus (und dessen TCP/IP-enkapsulierte Variante), I²C und 1-Wire. 

## Enkapsulierung

Manche seriellen Busprotokolle lassen sich in Netzwerkprotokolle der 4ten OSI-Schicht (meistens TCP/IP) enkapsulieren und bilden somit ein eigenes/neues -- Ethernet-fähiges -- Busprotokoll, beispielsweise Modbus TCP (siehe \autoref{sec:modbus_tcp}). Das Übertragungsmedium solcher TCP/IP-enkapsulierten Busprotokolle ist somit ein herkömmliches CATx-Ethernetkabel mit RJ45-Steckern.

Zu den Vorteilen der Enkapsulierung von herkömmlichen Busprotokollen gehören die Vorteile, die das TCP/IP-Protokoll standardmäßig mit sich trägt. Dazu gehören beispielsweise die zuvor erwähnte Ethernet-Netzwerkfähigkeit sowie eine erhöhte Zuverlässigkeit und (automatische) Fehlerkorrektur, so wie sie bei TCP-Kommunikationen üblich ist. Diese Vorteile ermöglicht das TCP/IP-Protokoll mit seinen Retransmissions im Falle von Packet-Loss sowie von Prüfnummern und Sequenznummern innerhalb jedes Datenpakets.

Die Netzwerkfähigkeit von enkapsulierten Busprotokollen kann auch als Nachteil gesehen werden, da somit der Busdatenverkehr aus einem OT-Netzwerk in beispielsweise eine AD-Umgebung eines IT-Netzwerks "'überschwappen"' kann. Bei fehlender Netzwerksegmentierung und/oder mangelhafter Firewall-Konfiguration könnten somit externen Hosts unbefugt die betriebskritische Kommunikation zwischen OT-Komponenten manipulieren. Für weitere Details siehe \autoref{sec:bus_security}.

## Sicherheitsmängel

% VLLT HIER ETWAS MEHR SCHREIBEN!
Im Vergleich zu anderen digitalen Netzwerksystemen der heutigen Zeit sind Bussysteme vom Grundprinzip aus außerordentlich unsicher und leicht manipulierbar. Alle Geräte eines Bussystems hängen an einer Broadcast-Domain, was heißt, dass alle Geräte jeweils alle Informationen, die über den Bus geschickt werden, mitlesen können. Noch dazu werden die über den Bus versendeten Daten unter anderem nicht auf einen legitimen Absender oder Datensatz kontrolliert. Zwar bieten manche TCP/IP-enkapsulierten Bussysteme eine verschlüsselte End-to-End-Kommunikation, jedoch sind diese heutzutage auch nicht ansatzweise weit verbreitet aufzufinden. Konzepte wie die CIA-Triade und das Triple-A-System sind der Bus-Welt fremd.

Im Falle eines Angriffs auf ein Bussystem und somit auf das gesamte OT-Netzwerk liegen dem Angreifer viele Möglichkeiten vor, große Schäden anzurichten. Ob nun lediglich alle Informationen mitgehört werden oder doch eine DoS-Attacke auf \acrshort{sps}en innerhalb des Bussystems stattfindet, um den gesamten Betrieb lahmzulegen, ist offen. Eines ist jedoch klar: Durch eine ausreichende Absicherung des Übergangs zwischen IT und OT, das heißt der Firewall auf Ebene 2.5 des Purdue-Modells (siehe \autoref{sec:purdue}), sind Angriffe auf das OT-Netzwerk am einfachsten zu meiden. Beispielsweise sollte bei der Ausbreitung eines Netzwerkwurms innerhalb des IT-Netzwerks dieser keinesfalls auch in das OT-Netzwerk gelangen können.

### Stuxnet

Stuxnet ist ein Computerwurm, der im Juni 2010 entdeckt und zuerst unter dem Namen RootkitTmphider beschrieben wurde. Das Schadprogramm wurde speziell entwickelt zum Angriff auf ein System zur Überwachung und Steuerung (SCADA-System), das speicherprogrammierbare Steuerungen des Herstellers Siemens vom Typ Simatic S7 verwendet. Dabei wurde in die Steuerung von Frequenzumrichtern in Teheran, der Hautpstadt Irans, eingegriffen. Frequenzumrichter dienen beispielsweise dazu, die Geschwindigkeit von Motoren zu steuern. Solche Steuerungen werden vielfach eingesetzt, etwa in Industrieanlagen wie Wasserwerken, Klimatechnik oder Pipelines.
 
Da bis Ende September 2010 der Iran den größten Anteil der infizierten Computer besaß und es zu außergewöhnlichen Störungen im iranischen Atomprogramm kam, lag es nah, dass Stuxnet hauptsächlich entstand, um als Schadsoftware die Leittechnik (Zentrifugen) der Urananreicherungsanlage in Natanz oder des Kernkraftwerks Buschehr zu stören.

Stuxnet gilt aufgrund seiner Komplexität und des Ziels, Steuerungssysteme von Industrieanlagen zu sabotieren, als bisher einzigartig. Das heißt aber nicht, dass in der Zukunft nicht noch weitere Netzwerkwürmer auf das Internet losgelassen werden, dessen Hauptziel es seien wird, OT-Netzwerke lahmzulegen.

^ https://de.wikipedia.org/wiki/Stuxnet BZW https://docs.broadcom.com/doc/security-response-w32-stuxnet-dossier-11-en

## Modbus

\subsection{Modbus}
\label{sec:modbus}
Das Modbus-Protokoll artikuliert die Kommunikation zwischen Hosts/Servern (sogenannten "'Masters"') und Geräten/Clients (sogenannten "'Slaves"') und ermöglicht eine Abfrage zur Geräteüberwachung und -konfiguration.

Von Modbus übertragene Nachrichten bieten grundlegende Lese- und Schreiboperationen über Binärregister (bekannt als "'Coils"') und 16-Bit-Wörter. Slave-Geräte antworten ausschließlich auf Master-Anfragen. Der Master initiiert immer jede Kommunikation. Wenn mehrere Slaves parallel am RS485-Bus angeschlossen sind (Was im Regelfall zutrifft), benötigt jeder eine spezifische Adresse.

Jede Modbus-Anfrage beginnt damit, dass der Host die Adresse des gewünschten Geräts kontaktiert und die Antwort mit der Adresse des sendenden Slave-Geräts antwortet.
Jeder Busteilnehmer muss eine eindeutige Adresse besitzen. Die Adresse 0 ist dabei für einen Broadcast reserviert. Jeder Teilnehmer darf Nachrichten über den Bus senden. In der Regel wird dies jedoch durch den Client initiiert und ein adressierter Server antwortet.

Somit definieren Modbus-Protokolle buchstäblich die Nachrichtenstruktur, die beim Datenaustausch zwischen dem Master und dem/den Slave(s) verwendet wird. Man sollte Modbus jedoch niemals mit einem Kommunikationsmedium verwechseln. Modbus bildet als Protokoll nur die Nachrichtenstruktur, ist aber nicht das physikalische Medium der Datenübertragung. Diese übernimmt beispielsweise ein RS485-Serial-Kabel. RS232 und RS422 können auch Modbus übertragen, sind aber veraltet und nicht so funktionsreich wie Modbus-RS485.

\subsubsection{Modbus TCP}
\label{sec:modbus_tcp}
Neben Profinet, EtherCat und co. hat sich dieses Protokoll für die industrielle Kommunikation über Ethernet-Leitungen etabliert.
Schneider Automation hat der Organisation IETF (Internet Engineering Task Force), einer Organisation zuständig für die Internetstandardisierung, den Wunsch gebracht, Modbus auf einem TCP/IP-Übertragungsmedium laufen zu lassen. Dabei wurde das Modbus-Modell und der TCP/IP-Stack nicht verändert, da nur eine Enkapsulierung von Modbus in TCP-Packets stattfindet. Seit diesem Zeitpunkt wurde Modbus zu einem Überbegriff und besteht aus:
\begin{itemize}[leftmargin=17.5ex]
	\item[Modbus-RTU] Asynchrone Master/Slave-Kommunikation über RS-485, RS-422 oder RS-232 Serial-Leitungen
	\item[Modbus-TCP] Ethernet bzw. TCP/IP basierte Client-Server Kommunikation
	\item[Modbus-Plus] Wie bereits zuvor erwähnt hat Modbus ursprünglich eine Master/Slave-Architektur verwendet, dieses Konzept hat sich bei den Abstammungen von der Idee her nicht verändert, es heißt nur anders und wird anders gehandhabt, z.B.: Client/Server bei TCP/IP. Es ist hauptsächlich für Token-Passing Netzwerke gedacht.
\end{itemize}

Als Unterschied zwischen Modbus-RTU und Modbus-TCP kennzeichnet sich am Meisten die Redundanz bzw. Fehlerüberprüfung der Datenübertragung und die Adressierung der Slaves.
Modbus-RTU sendet zusätzlich zu Daten und einem Befehlscode eine CRC-Prüfsumme und die Slave-Adresse. Bei Modbus-TCP werden diese innerhalb des Payloads nicht mitgeschickt, da bei TCP die Adressierung bereits im TCP/IP-Wrapping vorhanden ist (Destination Address) und die Redundanzfunktionen durch die TCP/IP-Konzepte wie eigenen Prüfsummen, Acknowledgements und Retransmissions.

Bei der Enkapsulierung von Modbus in TCP werden nicht nur der Befehlscode und die zugehörigen Daten einfach in die Payload getan, sondern auch ein MBAP (Modbus Application Header), welcher dem Server Sachen wie die eindeutige Interpretation der empfangenen Modbus-Parameter sowie Befehle bietet.
\begin{figure}[h]
    \centering
    \includegraphics[width=0.8\textwidth]{modbus_encap}
    \caption[]{Visualisierung des Modbus TCP Headers\footnotemark}
\end{figure}

Durch die Enkapsulierung in TCP verliert die ursprünglich Serielle-Kommunikation des Modbus-Protokolls ca. 40% seines ursprünglichen Daten-Durchsatzes. Jedoch ist dieser Verlust es im Vergleich zu den bereits zuvor erwähnten -- von der TCP/IP-Enkapsulierung mitgebrachten -- Vorteilen definitiv wert. Nach der Enkapsulierung können im Idealfall 3,6 Mio. 16-bit-Registerwerte pro Sekunde in einem 100Mbit/s switched Ethernet-Netzwerk übertragen werden, und da diese Werte im Regelfall bei Weitem nicht erreicht werden, stellt der partielle Verlust an Daten-Durchsatz kein Problem dar.

Die Einführung dieses offenen Protokolls bedeutete auch gleichzeitig den Einzug der auf Ethernet gestützten Kommunikation in der Automationstechnik, da hierdurch zahlreiche Vorteile für die Entwickler und Anwender erschlossen wurden. So wird durch den Zusammenschluss von Ethernet mit dem allgegenwärtigen Netzwerkstandard von Modbus TCP und einer auf Modbus basierenden Datendarstellung ein offenes System geschaffen, das dies Dank der Möglichkeit des Austausches von Prozessdaten auch wirklich frei zugänglich macht. Zudem wird die Vormachtstellung dieses Protokolls auch durch die Möglichkeit gefördert, dass sich Geräte, die fähig sind den TCP/IP-Standard zu unterstützen, implementieren lassen. Modbus TCP definiert die am weitesten entwickelte Ausführung des offenen, herstellerneutralen Protokolls und sorgt somit für eine schnelle und effektive Kommunikation innerhalb der Teilnehmer einer Netzwerktopologie, die flexibel ablaufen kann. Zudem ist dieses Protokoll auch das einzige der industriellen Kommunikation, welches einen „Well known port“, den Port 502, besitzt und somit auch im Internet routingfähig ist. Somit können die Geräte eines Systems auch über das Internet per Fernzugriff gesteuert werden.
% obiger Absatz pure Kopiererei, OBACHT bei DA
^^^ stand 07.08.2024: ok wtf wieso habe ich hier diese info hingeschrieben, dass das pure kopiererei sein soll, ich finde jetzt keine quellen mehr diese texte sind im internet nicht so aufzufinden, ich hab das nicht mit chatgpt gemacht, hilfe hilfe hilfe quellen brauchen ich dfsfafawrda

## Umsetzung eines I²C-Buses

Zwar wird -- wie zuvor erwähnt -- I²C hauptsächlich als geräteinternes Busprotokoll verwendet, jedoch bietet es sich auch sehr gut an, wenn über kurze Distanzen mit sehr einfachen Mitteln, in diesem Falle über Jumperkabel, zwischen einem "Master"- und einem oder mehreren "Slave"-Gerät(en) geordnet kommuniziert werden soll. Mit lediglich einer Datenleitung, einem Clock-Signal, einer Stromversorgung (da der I²C-Bus "Pull-Up" ist, d.h. es fließt bei keinen Daten konstant Strom, im Gegensatz zum herrkömmlichen "Pull-Down") und ein wenig Programmcode kann bereits eine völlig funktionsfähige I²C-Kommunikation erreicht werden.

### Auf einem RaspberryPi

Der RaspberryPi bietet von Haus aus zwei Pins, nämlich jeweils GPIO2 als Daten-Pin und GPIO3 als Clock-Pin, um an einen I²C-Bus angeschlossen zu werden und über diese Daten zu erhalten beziehungsweise zu verschicken. Zudem unterstützt das Betriebssystem Raspbian standardmäßig bereits die I²C-Kommunikation, jedoch muss der Treiber für diese nachträglich aktiviert werden. Dies geht über mehrere Möglichkeiten, die einfachste ist jedoch auf der Kommandozeile folgenden Befehl auszuführen:
modprobe i2c-gpio
% BEZÜGLICH modprobe BEACHTEN: # TODO: PERSISTENT ALTERNATIVE IN /boot/firmware/config.txt !!!

Nach einer fertigen Verkabelung an einen I²C-Bus mit einem oder mehreren Slaves -- in diesem Fall mit nur einem Slave, dieser hat die Hex-Adresse 0x21 -- und einem Neustart nach dem aktivieren des I²C-Treibers kann eine erste Query an den Bus geschickt werden, um zu schauen, welche Slave-Adressen derzeit aktiv und antwortsfähig sind: 
i2cdetect -y 1
** SCREENSHOT VON SLAVE 21 HIER **

bla bla simples python program

### Integration mit OpenPLC

Um die über einen I²C-Bus erhaltenen Daten in OpenPLC auf einem RaspberryPi einsetzen zu können, müssen diese über das PSM (siehe OpenPLC PSM) auf eine SPS-Hardwareadresse gemappt werden. Beispielsweise BLABLABAL IW2:
data: list[int] = read_from_esp32(ESP_I2C_address, 32)
psm.set_var("IW2", data[0])

Nun kann die SPS-Hardwareadresse %IW2 in einem SPS-Programm mit einer Input-Variable verknüpft und somit verwendet werden:
** SCREEEEEENSHOTS, EDITOR + MONITORING? **

# Speicherprogrammierbare Steuerungen

again, svon dies das

## Ausführungen/Marken

### Siemens SIMATIC

Europaweit hat sich die Siemens SIMATIC als die gängiste \acrshort{sps}-Marke durchgesetzt. Bereits im Jahre 1958 wurde die erste SIMATIC, eine verbindungsprogrammierte Steuerung (kurz VPS), auf den Markt gebracht.

Das Automatisierungssystem ist modular und kann neben der CPU mit unterschiedlichen digitalen und analogen Peripheriebaugruppen sowie vorverarbeitenden, intelligenten Baugruppen bestückt werden. Die Baugruppen können zentral (in der Nähe der CPU) oder dezentral vor Ort in der Anlage aufgebaut sein. Vom kleinen Kompaktgerät bis zur Hochleistungs-\acrshort{sps} gibt es SIMATIC-Steuerungen für fast jeden Einsatzbereich in der industriellen Steuerungs- und Regelungstechnik. Allen SIMATIC-S7 Steuerungen gemeinsam ist ihre Robustheit gegenüber elektromagnetischen Störungen und klimatischer Beanspruchung sowie ihre Ausbaufähigkeit.

Das System an sich ist um viele solcher Signalverarbeitungsgruppen erweiterbar z.B. RS232-Schnittstellen, Feldbusmodule oder ganz spezielle Regeleinheiten können an das System durch Hinzufügen auf den Trägerschienen und anschließendes Verbinden erweitert werden. Ebenfalls kann Siemens über ihr favorisiertes Feldbussystem Profibus viele Teilnehmer nahezu unbegrenzt ansteuern. Abhängig ist dies durch die benutzte Serie und Zusatzmodule. Reichen Arbeitsspeicher und Rechenkapazität nicht aus, genügt eine Erweiterung um ein extra CPU-Modul.

Heutzutage wird die SIMATIC mittels der Programmiersoftware STEP 7, aber auch mittels Alternativsoftware von Fremdherstellern programmiert. 

https://de.wikipedia.org/wiki/Simatic
https://wiki.hshl.de/wiki/index.php/Speicherprogrammierbare_Steuerungen_(SPS)

### Siemens LOGO!

svon

### Software SPS

siehe openplc
https://de.wikipedia.org/wiki/Soft-SPS

## OpenPLC

OpenPLC ist ein Open-Source-Projekt, welches eine virtuelle \acrshort{sps}, die OpenPLC-Runtime, sowie eine Programmierumgebung für diese, den OpenPLC-Editor (siehe \autoref{sec:editor}), kostenlos zur Verfügung stellt.

### Editor
Die Bereits im \autoref{sec:sps_openplc} erwähnte Software-\acrshort{sps}-Runtime -- die "'OpenPLC-Runtime"' -- kann mithilfe des OpenPLC-Editors mittels grafischer Oberfläche mit Bausteinen oder auch mittels eingebautem Texteditor programmiert werden, je nach gewünschter \acrshort{sps}-Programmierart (siehe \autoref{sec:sps_programmierung}). 

Im Rahmen dieser Diplomarbeit wurden alle OpenPLC-Programme in der Kontaktplan-Sprache (siehe OBEN AAAAAAA) geschrieben.

### Runtime

Die Runtime kann entweder auf einer virtuellen Maschine installiert werden, um in einer virtualisierten Produktionsanlagen-Topologie im Zusammenspiel mit anderen virtuellen Elementen zu arbeiten, oder auch auf einem physischen Stück Hardware ("'bare metal"'), beispielsweise wie zuvor erwähnt auf einem RaspberryPi, um in einer echten Produktionsumgebung verwendet zu werden.

### PSM

Als "Treiberprogramm" zwischen den virtuellen Input- bzw. Output-Coils der SPS und den physischen GPIO-Pins des RaspberryPi kann ein standardmäßig mit OpenPLC mitinstallierter Treiber für neuere RaspberryPi-Modelle verwendet werden, jedoch limitiert dieser somit natürlich auch die Anzahl an nutzbaren Pins und verfügt nur über die vorprogrammierte Pin-Zuordnung.

Da dieser "Stock"-Treiber zu einschränkend war, musste ein selbstgeschriebener Treiber her. OpenPLC bietet auch schon von Haus aus genau das: nämlich das OpenPLC Python Submodule, kurz PSM. Mittels dem PSM kann ein eigener Treiber programmiert werden, welcher Direktzugriff auf alle gewünschten GPIO-Pins bietet.

blablabla

### Limitation auf Modbus

Im Vergleich zu anderen SPSen unterstützt OpenPLC lediglich nur ein Busprotokoll: Modbus. Zwar ist Modbus und dessen TCP/IP-enkapsulierte Variante Modbus TCP (siehe Abschnitt Modbus)

### Installation

Um die OpenPLC-Runtime auf einem RaspberryPi zu installieren um diesen als SPS nutzen zu können, muss zuerst das WiringPi-Package installiert werden, um OpenPLC Zugriff auf die GPIO-Pins zu gewähren.

curl -OL https://github.com/WiringPi/WiringPi/releases/download/3.6/wiringpi_3.6_arm64.deb
dpkg -i wiringpi_3.6_arm64.deb
gpio -v

Danach braucht es nichts weiteres als das OpenPLCv3-GitHub-Repository unter `https://github.com/thiagoralves/OpenPLC_v3` zu clonen und das mitgelieferte Installationsskript auszuführen.

git clone https://github.com/thiagoralves/OpenPLC_v3.git
cd OpenPLC_v3
./install.sh rpi

Als Argument wird dem Installationsskript "'rpi"' mitgegeben, da im Rahmen dieser Diplomarbeit die Runtime auf einem RaspberryPi installiert werden soll, und somit, zum Beispiel, die Treiber für die Ansteurung der GPIO-Pins gleich mitgeliefert werden.

### Webdashboard

## Programmierung

\subsection{Programmierung}
\label{sec:sps_programmierung}
\acrlong{sps}en können, im Vergleich zu "'festverdrahteten"'  verbindungsprogrammierten Steuerungen (VPS), jederzeit digital umprogrammiert werden. Sie bieten somit einen viel flexibleren Umgang bei der Steuerung von industriellen Anlagen.  

Bei der Programmierung von \acrshort{sps}en wird zwischen 5 in der EN 61131-3\footnote{Europäische Norm EN 61131, basierend auf der internationalen Norm IEC 61131} genormten Programmiersprachen unterschieden. Diese wären:

\begin{itemize}
	\item[\acrshort{awl}] Kurz für "'\acrlong{awl}"'. Basierend auf reinem ASCII-Text und vergleichbar mit Assemblerprogrammierung. Bei Siemens heißt sie STL (engl. kurz für "'Statement List"'). Diese Art der Programmierung gilt als veraltet und wird mit der Zeit hauptsächlich von \acrshort{st} abgelöst.
	\item[\acrshort{st}] Kurz für "'\acrlong{st}"'. Basierend auf reinem ASCII-Text und angelehnt an konventionelle Programmiersprachen. Die Syntax der Sprachelemente ähneln denen der Programmiersprache Pascal und es wird bei Schlüsselwörtern keine Unterscheidung zwischen Groß- und Kleinschreibung gemacht (case insensitive). \acrshort{st} bietet mehr Strukturierungsmöglichkeiten als \acrshort{awl} und löst diese daher immer mehr ab.
	\item[\acrshort{kop}] Kurz für "'\acrlong{kop}"'. Vergleichbar mit einem Stromlaufplan, der um 90° gedreht ist. In fast allen modernen \acrshort{kop}-Sprachen sind aber auch Funktionsblöcke verfügbar, die weit über die eigentliche Verknüpfungssteuerung hinausgehen und ähneln somit eher einem \acrshort{fup}.
	\begin{figure}[H]
		\centering
		\begin{subfigure}{.49\textwidth}
			\centering
			\includegraphics[width=.4\linewidth]{Stromlaufplan}
			\caption{Stromlaufplan}
			\label{fig:sub1}
		\end{subfigure}
		\begin{subfigure}{.49\textwidth}
			\centering 
			\includegraphics[width=.4\linewidth]{Kontaktplan}
			\caption{Kontaktplan}
			\label{fig:sub2}
		\end{subfigure}
		\caption{Man beachte die Ähnlichkeit zwischen dem Stromlaufplan und dem \acrshort{kop}}
		\label{fig:test}
	\end{figure}
	\footnotetext{Quelle: https://de.wikipedia.org/wiki/Kontaktplan\#/}
	\item[\acrshort{fup}] Kurz für "'\acrlong{fup}"'. Auch als "'Funktionsbausteinsprache"' (kurz FBS) bekannt, diese Art der \acrshort{sps}-Programmierung ähnelt Logik-Schaltplänen.
	\item[\acrshort{as}] Kurz für "'\acrlong{as}"'. Auch als Ablaufsteuerung bekannt, diese Art der \acrshort{sps}-Programmierung ist besteht aus einer Kette von Steuerungsschritten, welche durch Weiterschaltbedingungen (auch bekannt als "'Transitionen"') miteinander verbunden sind. An den einzelnen Schritten werden Befehle bzw. Aktionen eingebunden, diese dienen zur gezielten Ansteuerung von der jeweiligen Aktorik im System. Somit kann die \acrlong{as} als quasi "'Flowchart-Programmierung"' angesehen werden.
\end{itemize}

https://de.wikipedia.org/wiki/Speicherprogrammierbare_Steuerung
https://de.wikipedia.org/wiki/EN_61131
https://de.wikipedia.org/wiki/Anweisungsliste
https://de.wikipedia.org/wiki/Kontaktplan
https://de.wikipedia.org/wiki/Funktionsbausteinsprache
https://de.wikipedia.org/wiki/Ablaufsprache
https://de.wikipedia.org/wiki/Strukturierter_Text

für lustige statistik/grafik (NOCH NICHT VERWENDET):
%cool stuff: https://wiki.hshl.de/wiki/index.php/Speicherprogrammierbare_Steuerungen_%28SPS%29


# Aufbau der Modell-Kläranlage

Wieso Kläranlage?
https://www.nozominetworks.com/blog/cisa-warns-of-pro-russia-hacktivist-ot-attacks-on-water-wastewater-sector?utm_source=linkedin&utm_medium=social&utm_term=nozomi+networks&utm_content=281b8432-049c-435e-805a-ea5872a057eb

Um die Absicherung eines Produktionsbetriebes oder eines Stücks kritischer Infrastruktur ausreichend dokumentieren zu können, kann sich nicht auf ausschließlich virtualisierte Lösungen des OT-Netzwerks verlassen werden. Dazu ist das Ausmaß eines Super-GAUs innerhalb eines virtualisierten OT-Netzwerks nicht begreifbar/realistisch für die meisten aussenstehenden Personen. Es braucht eine angreifbare und physisch vorhandene Lösung: eine selbstgemachte Modell-Kläranlage.

## Planung der Betriebszellen

Wieso unterteilen in Betriebszellen?
tipp: security lol

Um die Sicherheit der OT-Komponenten so weit es geht zu gewährleisten, muss bereits bei der Planung der Anlage die Segmentierung in Betriebszellen in Betracht gezogen werden. 
Der Inhalt einer Betriebszelle soll nur untereinander kommunizieren können, die einzige Ausnahme wäre beispielsweise die Kommunikation mit einem SCADA-System auf der nächst-höheren Purdue-Ebene. Eine solche Segmentierung lässt sich somit quasi mit einer VLAN-Segmentierung in einem IT-Netzwerk vergleichen.

### Zelle 1 (Vorbearbeitung)

Besteht aus Schraube und Rechen und so
** BILD **

### Zelle 2 (Filtration)

Besteht aus zwei durchsichtigen Acryl-Wassertanks welche jeweils ca. 3L an Volumen aufweisen. Diese sind oben offen, werden jedoch von Deckeln abgedeckt. In diesen Deckeln ist die für den Wassertank jeweils notwendige Sensorik verbaut.
Zwischen den Tanks befindet sich ein Aktivkohlewasserfilter als auch eine Pumpe, die die Flüssigkeiten von einem Tank in den Nächsten durch den Filter hindurch transporiert.
** BILD **

### Zelle 3 (Staudamm)

Besteht aus Damm???
** BILD **
