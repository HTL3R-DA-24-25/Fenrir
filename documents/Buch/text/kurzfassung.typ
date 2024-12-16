Die Diplomarbeit "Fenrir -- Zum Schutz von OT-Netzwerken" beschäftigt sich mit der Absicherung von OT-Netzwerken. Dazu wird eine Netzwerktopologie gebaut, welche ein realitätsgetreues Firmennetzwerk, inklusive virtuellem IT- (Active Directory Büro- bzw. Serverumgebung) sowie physischen OT-Bereich (Speicherprogrammierbare Steuerungen, die anzusteuernden Aktoren/Sensoren, SCADA-System, HMIs), repräsentieren soll.

Der IT-Bereich besteht aus virtualisierten Windows- bzw. Linux-Computern, die Teil einer Active-Directory-Domäne sind.

Der OT-Bereich besteht aus einem Modell einer Kläranlage und der zugehörigen Gerätschaft zur Überwachung/Administration dessen. Diese setzt sich, unter anderem, aus einer archimedischen Schraube, einem Rechen, Wassertanks, Filtern, einem Staudamm, Pumpen und vielem mehr zusammen, wobei diese Gegenstände mit verbauter Aktorik und/oder Sensorik als Ansteuerungsziele mehrerer SPS gelten. Diese werden nach Aufbau auch als Angriffsziel verwendet, wobei ein Angreifer beispielsweise die Pumpen komplett lahmlegen, oder auch mit der Manipulation dessen gezielt einen Wasserschaden verursachen könnte.

Für die Sicherheit des Netzwerks sorgen FortiGate-Firewalls, die gemeinsam mit einer strikten AD-integrierten Zugriffskontrolle, Mikrosegmentierung der OT-Betriebszellen, .... für eine Einschränkung und Überwachung des Datenflusses dienen. 

Zur stetigen Überwachung des Datenverkehrs innerhalb des Netzwerk dient eine Nozomi Guardian. Dieses Gerät ist mehr als nur ein IDS und kann anhand von Mirror-Traffic alle sich im Netzwerk befindeden Geräte gemeinsam mit ihren möglichen Schwachstellen erkennen und leicht ersichtlich für eine/n Netzwerkadministrator/in visualisieren.

Als Ziel gilt nicht nur ein vor äußeren sowie inneren Cyberangriffen abgesichertes Netzwerk aufzustellen, sondern auch eine ausführliche Dokumentation des Konfigurations- bzw. Absicherungsprozesses.

// warnung: manche sätze hier sind 1 zu 1 die von yggrassil aber mit paar wörten ausgetauscht