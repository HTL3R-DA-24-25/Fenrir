#import "@preview/htl3r-da:0.1.0" as htl3r

= Vorwort
#htl3r.author("David Koch")

Die politische Lage der Welt spitzt sich zu, Angriffe auf kritische Infrastruktur nehmen zu. Immer mehr staatliche Akteure versuchen, die kritischen Industrie- sowie Infrastrukturdienste ihrer Feinde anzugreifen, und sind dabei zu oft erfolgreich, da die Absicherung des Übergangs zwischen #htl3r.short[it]- und #htl3r.short[ot]-Netzwerken im Betrieb häufig suboptimal ist.

blablabal

Das Bewusstsein und der Wunsch nach einer gegen Cyberangriffe sicheren physischen Infrastruktur sollte auch in der allgemeinen Bevölkerung gestärkt werden. Mit unserer Modell-Kläranlage und den eigenen Angriffen darauf möchten wir zeigen, dass mangelnde #htl3r.short[ot]-Security zu "echten" Schäden führen kann -- sei es ein überschaubarer Wasserschaden bei unserer Kläranlage oder Millionenschäden durch kaputte Hochöfen oder überhitzte Kühlsysteme von Kraftwerken. Zusätzlich soll unsere Dokumentation des Absicherungsprozesses als Literaturverzeichnis von "Dos" und "Don'ts" für angehende #htl3r.short[ot]-Security-Expert*innen oder für interessierte Personen, die sich mit dem Thema auseinandersetzen möchten, dienen.

blablabla

== Danksagung

Die Planung, Umsetzung und Präsentation der Diplomarbeit Fenrir wäre ohne weitere Unterstützung in dieser Form nicht möglich gewesen. Das Diplomarbeitsteam bedankt sich herzlich bei allen natürlichen als auch juristischen Personen, die das Projekt durch ihre fachliche und/oder finanzielle Unterstützung gefördert haben und es zu der Diplomarbeit gemacht haben, die sie letztendlich geworden ist.

Innerhalb der HTL Rennweg gibt es einige Unterstützer denen besonderer Dank ausgesprochen werden muss. Ohne den ursprünglichen Vorschlag von den Betreuern Christian Schöndorfer und Clemens Kussbach hätte das Diplomarbeitsteam sich nie mit der #htl3r.short[ot]-Security befasst und der Ablauf dieser Diplomarbeit wäre ohne sie ein ganz anderer gewesen. Durch ihre andauernde Unterstützung bei der Suche nach externen Firmenpartnern und ihren Rat bezüglich der Umsetzung wurde die Diplomarbeit Fenrir um einiges bereichert.

Auch dem schulinternen Förderungsverein INNKOO ist zu danken, denn dieser hat uns ein Finanzierungspolster im Falle von fehlender Finanzierung durch externe Partner geboten, welches zum Glück nicht verwendet werden musste, trotzdem aber eine Sorge weniger garantiert hat.

Gemeinsam mit der Diplomarbeit Atropos wäre der Ansatz bei der Virtualisierung und Provisionierung ein ganz anderer und vermutlich schlechterer gewesen, somit möchten wir uns auch bei ihnen für ihre andauernde Kooperation bedanken.

Das Diplomarbeitsteam möchte sich ebenfalls bei Stefan Tomp der vorjährigen Diplomarbeit Yggdrassil für seine Unterstützung im Bereich der Virtualiserung mit der UCS und seiner wiederholten Hilfe bei technischen Fragen bedanken.

Des weiteren hat die tatkräftige Unterstützung externer Firmenpartner und deren Vertretern die Umsetzung und generelle Industrienähe der Diplomarbeit erlaubt.
Ein recht herzlicher Dank gebührt den folgenden Firmenpartnern:
- *easyname* für die Bereitstellung einer Domäne und eines Webservers für das Hosting der Diplomarbeitswebsite.
- *CSA* im Namen von Herbert Dirnberger für die Bereitstellung von Server-Hardware als auch OT-Gerätschaft.
- *Fortinet* für die Bereitstellung mehrerer Hardware-Firewalls und deren Lizenzen.
- *Ikarus* für die Bereitstellung der Lizenzen für die Nozomi Guardian als auch den Arc Sensor, die finanzielle Unterstützung beim Aufbau der Modell-Kläranlage als auch die Hilfe bei der Gewinnung von weiteren Firmenpartnern durch Werbung der Diplomarbeit Fenrir.
- *Nozomi Networks* für die Bereitstellung der Guardian sowie Arc Sensor Software, ohne welche die Netzwerkanalyse, besonders in Bezug auf den OT-Teil, unvorstellbar komplizierter gewesen wäre.
- *NTS* für die Bereitstellung einer Cisco UCS zur ursprünglichen Virtualisierung des IT-Netzwerks gemeinsam mit Splunk-Lizenzen für das SIEM.
- Das OT-Cybersecurity-Team der *Wien Energie* für die Bereitstellung von Informationsquelle bezüglich der Absicherung von OT-Netzwerken und einer Führung TODO
