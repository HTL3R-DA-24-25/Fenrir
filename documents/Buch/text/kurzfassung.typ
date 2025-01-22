Die Diplomarbeit "Fenrir -- Zum Schutz von OT-Netzwerken" beschäftigt sich mit der Absicherung von OT-Netzwerken. Dazu wird eine Netzwerktopologie gebaut, welche ein realitätsgetreues Firmennetzwerk repräsentieren soll, inklusive einem virtuellem IT-Bereich (Active Directory Büro- bzw. Serverumgebung) sowie einem physischen OT-Bereich (Speicherprogrammierbare Steuerungen, die anzusteuernden Aktoren/Sensoren, SCADA-System, HMIs).

Der IT-Bereich besteht aus virtualisierten Windows- bzw. Linux-Computern, die Teil einer Active-Directory-Domäne sind. Die Windows-Server sind zwei redundante Domain Controller als auch ein Microsoft Exchange Server, welcher als Mail-Server eingesetzt wird. Die Linux-Server dagegen dienen für VPNs und Netzwerküberwachung.

Der OT-Bereich besteht aus einem Modell einer Kläranlage und der zugehörigen Gerätschaft zu deren Überwachung und Administration. Diese setzt sich, unter anderem, aus einer archimedischen Schraube, einem Rechen, Wassertanks, Filtern, einem Staudamm und Pumpen zusammen, wobei diese Gegenstände mit verbauter Aktorik und Sensorik als Ansteuerungsziele mehrerer SPS gelten. Diese werden nach Aufbau auch als Angriffsziel verwendet, wobei ein Angriff beispielsweise die Pumpen komplett stilllegen, oder auch durch Manipulation gezielt einen Wasserschaden verursacht werden könnte.

Für die Sicherheit des Netzwerks sorgen FortiGate-Firewalls. Diese dienen, unter anderem, gemeinsam mit einer strikten AD-integrierten Zugriffskontrolle und einer Mikrosegmentierung der OT-Betriebszellen als auch des IT-Netzwerks für eine Einschränkung und Überwachung des Datenflusses. 

Zur stetigen Überwachung des Datenverkehrs innerhalb des Netzwerk dient eine Nozomi Guardian. Dieses Gerät ist mehr als nur ein IDS und kann anhand von Mirror-Traffic alle sich im Netzwerk befindenden Geräte gemeinsam mit ihren möglichen Schwachstellen erkennen und leicht ersichtlich für eine/n Netzwerkadministrator/in visualisieren.

Als Ziel gilt nicht nur ein vor externen sowie internen Cyberangriffen abgesichertes Netzwerk aufzustellen, sondern auch eine ausführliche Dokumentation des Konfigurations- beziehungsweise Absicherungsprozesses.