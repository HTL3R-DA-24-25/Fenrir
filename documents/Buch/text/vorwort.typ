#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("David Koch")
= Vorwort

Die politische Lage der Welt spitzt sich zu, Angriffe auf kritische Infrastruktur nehmen zu @cyberattacks-crit-infra. Immer mehr staatliche Akteure versuchen, die kritischen Industrie- sowie Infrastrukturdienste anderer Länder anzugreifen, und sind dabei zu oft erfolgreich, da die Absicherung des Übergangs zwischen #htl3r.short[it]- und #htl3r.short[ot]-Netzwerken im Betrieb häufig suboptimal ist @cisa-wastewater.

Das Bewusstsein und der Wunsch nach einer -- gegen Cyberangriffe -- sicheren physischen Infrastruktur sollte auch in der allgemeinen Bevölkerung gestärkt werden. Mit unserer Modell-Kläranlage und den selbstorchestrierten Angriffen auf diese möchten wir zeigen, dass mangelnde #htl3r.short[ot]-Security zu "echten" Schäden führen kann -- sei es ein überschaubarer Wasserschaden bei unserer Kläranlage oder Millionenschäden durch kaputte Hochöfen oder überhitzte Kühlsysteme von Kraftwerken @it-sec-de. Zusätzlich soll unsere Dokumentation des Absicherungsprozesses als Literaturverzeichnis von "Dos" und "Don'ts" für angehende #htl3r.short[ot]-Security-Expert*innen oder für interessierte Personen, die sich mit dem Thema auseinandersetzen möchten, dienen.

== Danksagung

Die Planung, Umsetzung und Präsentation der Diplomarbeit "Fenrir" wäre ohne weitere Unterstützung in dieser Form nicht möglich gewesen. Das Diplomarbeitsteam bedankt sich herzlich bei allen natürlichen als auch juristischen Personen, die das Projekt durch ihre fachliche und/oder finanzielle Unterstützung gefördert haben und es zu der Diplomarbeit gemacht haben, die sie letztendlich geworden ist.

Innerhalb der HTL Rennweg gibt es einige Unterstützer denen besonderer Dank ausgesprochen werden muss. Ohne den ursprünglichen Vorschlag von den Betreuern Christian Schöndorfer und Clemens Kussbach hätte das Diplomarbeitsteam sich nie mit der #htl3r.short[ot]-Security befasst und der Ablauf dieser Diplomarbeit wäre ohne sie ein ganz anderer gewesen. Durch ihre andauernde Unterstützung bei der Suche nach externen Firmenpartnern und ihren Rat bezüglich der Umsetzung wurde die Diplomarbeit "Fenrir" um einiges bereichert.

Auch dem schulinternen Förderungsverein INNKOO ist zu danken, denn dieser hat uns ein Finanzierungspolster im Falle von fehlender Finanzierung durch externe Partner geboten, welches zum Glück nicht verwendet werden musste, trotzdem aber eine Sorge weniger garantiert hat.

Gemeinsam mit der Diplomarbeit "Atropos" wäre der Ansatz bei der Virtualisierung und Provisionierung ein ganz anderer und vermutlich schlechterer gewesen, somit möchten wir uns auch bei ihnen für ihre andauernde Kooperation bedanken.

Das Diplomarbeitsteam möchte sich ebenfalls bei Stefan Tomp der vorjährigen Diplomarbeit "Yggdrassil" für seine Unterstützung im Bereich der Virtualiserung mit der UCS und seiner wiederholten Hilfe bei technischen Fragen bedanken.

Des Weiteren hat die tatkräftige Unterstützung externer Firmenpartner und deren Vertreter die Umsetzung und generelle Industrienähe der Diplomarbeit ermöglicht.
Ein recht herzlicher Dank gebührt den folgenden Firmenpartnern:
- *CSA* im Namen von Herbert Dirnberger für die Bereitstellung von Server-Hardware als auch #htl3r.short[ot]-Gerätschaft.
- *easyname* für die Bereitstellung einer Domäne und eines Webservers für das Hosting der Diplomarbeitswebsite.
- *Fortinet* für die Bereitstellung mehrerer Hardware-Firewalls und deren Lizenzen.
- *Ikarus* für die finanzielle Unterstützung beim Aufbau der Modell-Kläranlage als auch die Hilfe bei der Gewinnung von weiteren Firmenpartnern durch Werbung der Diplomarbeit Fenrir.
- *Nozomi Networks* für die Bereitstellung der Guardian sowie Arc Sensor Software und deren Lizenzen, ohne welche die Netzwerkanalyse, besonders in Bezug auf den #htl3r.short[ot]-Teil, unvorstellbar komplizierter gewesen wäre.
- *NTS* für die Bereitstellung einer Cisco UCS zur ursprünglichen Virtualisierung des IT-Netzwerks.
- Das #htl3r.short[ot]-Cybersecurity-Team der *Wien Energie* für die Bereitstellung von Informationsquellen bezüglich der Absicherung von #htl3r.short[ot]-Netzwerken und einer privaten Führung durch die Sondermüll- und Klärschlamm-Verbrennungsanlage Simmeringer Haide.
