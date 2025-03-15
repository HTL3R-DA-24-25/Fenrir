#import "@preview/htl3r-da:1.0.0" as htl3r

#htl3r.author("Bastian Uhlig")
= OT-Administration

== SCADA
#htl3r.short[scada] steht kurz für #htl3r.long[scada] und ist ein System zur Überwachung und Steuerung von mehreren Aktoren und Sensoren.

=== Was ist ein SCADA-System?
In einer Betriebszelle existieren üblicherweise einige unterschiedliche #htl3r.shortpl[sps], auf welche Mitarbeiter keinen Zugriff haben. Selbst wenn dieser Zugriff möglich wäre, so wäre es sehr anstrengend, aus den verscheidenen Registern die Werte auszulesen, um die Anlage zu überwachen. Ein #htl3r.short[scada]-System hilft dabei, indem es als grafische Oberfläche zur Überwachung und Steuerung von verschiedenen #htl3r.shortpl[sps] agiert.

Hierbei ist zu beachten, dass ein #htl3r.short[scada]-System keine Signale automatisch sendet, sondern nur auf User-Input reagiert. Alle selbstgesteuerten Aktionen werden immer von #htl3r.shortpl[sps] durchgeführt.

Normalerweise wird pro Betriebszelle mindestens ein #htl3r.short[scada]-System verwendet, manchmal mehrere für Redundanz. Dies sorgt für höhere Sicherheit, da jedes #htl3r.short[scada] nur mit der "eigenen" Zelle kommunizieren darf. Falls die Zellen jedoch simpel gehalten sind und nur aus einer einzigen #htl3r.short[sps]en bestehen, so ist die Verwendung von mehreren #htl3r.short[scada]-Systemen unnötig und macht die Konfiguration nur komplizierter. In solch einem Fall können mehrere Zellen zusammengefügt werden, damit das System leichter zu übersehen ist.

=== Scada-LTS
Als ein Fork von der Open-Source Software Scada-BR ist Scada-LTS der Nachfolger der vorhergehenden Software. Scada-LTS läuft virtualisiert auf einem Docker und ist über eine von tomcat veröffentlichten Website zu erreichen. Datenhistorien werden separat in einer MySQL-Datenbank gespeichert, die typischerweise auch dockerisiert läuft.

==== Aufsetzung von SCADA-LTS
Das Aufsetzen von Scada-LTS ist relativ simpel gestaltet, da nur die Docker-Images zu laden und zu starten sind. Auf dem öffentlichen Repository #footnote[https://github.com/SCADA-LTS/Scada-LTS] von Scada-LTS ist eine Docker-Compose Datei zu finden, mit welcher das ganze System gestartet werden kann. Es ist jedoch sinnvoll, diese Datei anzupassen, um einen reibungslosen Start zu gewährleisten.

Vor allem ist dabei zu beachten, dass der Scada-LTS Docker abstürzt, sollte keine Verbindung zur Datenbank hergestellt werden können. Deshalb sollte Scada-LTS in der Docker-Compose Datei eine Abhängigkeit von der Datenbank bekommen, damit es erst startet, wenn die Datenbank bereit ist.
```yaml
depends_on:
    database:
        condition: service_healthy
```
Falls man Scada-LTS unter einem anderen Port als dem standardmäßigen Port 8080 erreichen will, so sollte dieser Port freigeben und die Weiterleitung des gewünschten Ports auf den Port 8080 von Docker konfiguriert werden.
```yaml
ports:
    - "80:8080"
expose: ["80"]
```

==== Konfiguration von SCADA-LTS
Jegliche Konfiguration von Scada-LTS erfolgt über das Webdashbord, welches unter `10.34.0.50/Scada-LTS` zu finden ist. Bei einer Erstaufsetzung meldet man sich hier mit den Anmeldedaten admin:admin an, diese sollten jedoch geändert werden.

Die mit Abstand wichtigste Konfiguration in einem #htl3r.short[scada] sind die Datasources, da diese jegliche Datenquellen darstellen. In Scada-LTS konfiguriert man diese unter dem gleichnamigen Punkt, wobei zu Testzwecken es auch möglich ist, virtuelle Datenquellen anzulegen. Dies ist im Echtbetrieb jedoch kaum sinnvoll.

Stattessen werden reale Datenquellen angegeben, welche typischerweise Modbus IP Quellen sind. Bei der Konfiguration sind einige Daten anzugeben, die wichtigsten hierbei sind der Transport-Type, Host und Port.

Eine Datasource kann mehrere Datenpunkte haben, womit verschiedene Werte gemeint sind, die von der #htl3r.short[sps] ausgegeben werden. Datenpunkte beziehen sich immer auf eine Register range, Datentyp und einem Offset. Es können pro Datenquelle beliebig viele Datenpunkte konfiguriert werden, diese müssen jedoch mit der Konfiguration der Register auf der gegenüberliegenden #htl3r.short[sps] übereinstimmen, um die Binärwerte richtig auslesen zu können.

Sinnvoll zu konfigurieren ist auch ein grafisches Interface, da dies einen schnellen Überblick über ein System bringt. Vor allem, wenn dies mit interaktiven Bildern kombiniert wird, ist die Überwachung um einiges angenehmer. Hierbei sollte für jede Betriebszelle ein eigenes grafisches Interface erstellt werden, um eine optische Trennung zu ermöglichen.

Eine weitere Art der Übersicht ist durch Watchlists gegeben. Diese können sich als einfache Listen vorgestellt werden, wobei die derzeitigen Werte von konfigurierten Datapoints angezeigt werden. Im generellen Einsatz ist dies nur begrenzt sinnvoll, da ein grafisches  Interface eine benutzerfreundlichere Übersicht gibt, jedoch können Watchlists verwendet werden, um genauere Informationen zu geben.

==== Automatische Konfiguration von SCADA-LTS
Im Falle einer automatischen Aufsetzung von Scada-LTS ist es am sinnvollsten, das System erst manuell zu konfigurieren, um danach via der Export-Funktion die Konfiguration als .zip-Datei abzuspeichern. Mittels einiger Befehle kann diese .zip-Datei dann automatisch eingefügt werden.
```bash
curl -d "username=admin&password=admin&submit=Login" -c cookies http://localhost/Scada-LTS/login.htm

curl -b cookies -v -F importFile=@project.zip http://localhost/Scada-LTS/import_project.htm

curl 'http://localhost/Scada-LTS/dwr/call/plaincall/EmportDwr.loadProject.dwr' -X POST -b cookies --data-raw $'callCount=1\npage=/Scada-LTS/import_project.htm\nhttpSessionId=\nscriptSessionId=D15BC242A0E69D4251D5585A07806324697\nc0-scriptName=EmportDwr\nc0-methodName=loadProject\nc0-id=0\nbatchId=5\n'

rm cookies
```
Zur Authentifizierung wird dabei eine Datei "cookies" gespeichert, um den Login mit den Default-Anmeldedaten admin:admin zu ermöglichen. Dieses Konto sollte logischerweise nach der Konfiguration -- am besten direkt mit dem Import der .zip-Datei -- deaktiviert werden, bzw. die Logindaten geändert werden.

=== Administration der Modell-Kläranlage

Die Administration der Modell-Kläranlage erfolgt ausschließlich über das #htl3r.short[scada]. Hierbei sind drei Betriebszellen zu unterscheiden, jedoch werden alle drei Betriebszellen über das gleiche #htl3r.short[scada] gesteuert, weil jede Anlage nur eine einzige #htl3r.short[sps] besitzt. In einer Echtumgebung wäre das Einsetzen von mehreren #htl3r.shortpl[scada] sinnvoll, um eine physische Trennung zu haben. \
Im Falle der Modell-Kläranlage ist es nicht der Fall. Hier wird jede Betriebszelle durch Verwendung eines unterschiedlichen grafischen Interface unterteilt, um damit eine optische Trennung herzustellen.

==== Betriebszelle Eins

In der ersten Betriebszelle ist nur die Schraube mittels #htl3r.short[sps] gesteuert, wodurch auch das #htl3r.short[scada] nur diese Schraube steuern kann. Über das #htl3r.short[scada] kann die Schraube ein- bzw. ausgeschalten werden. \
Das grafische Interface der ersten Betriebszelle zielt vor allem stark darauf ab, den Fluss des Wassers zu visualisieren. So sind die Tanks und die Schraube grafisch dargestellt, um Endnutzern eine einfache Übersicht zu geben.

#htl3r.fspace(
  figure(
    image("../assets/scada_cell1.png", width: 95%),
    caption: [Das SCADA-Dashboard der ersten Betriebszelle]
  )
)


==== Betriebszelle Zwei

In der zweiten Betriebszelle sind pro Tank je ein Füllstandssensor und ein Temperatursensor verbaut. Beide Sensoren können über das #htl3r.short[scada] ausgelesen werden, wobei die Temperatur in Grad Celsius ausgegeben wird. Auch die Pumpen können via das #htl3r.short[scada] gesteuert werden, wobei beide individuell ein- oder ausgeschalten werden können. \
Das grafische Oberfläche der zweiten Betriebszelle zeigt auch nicht ansteuerbare Elemente wie den Filter an, um eine klarere Übersicht zu geben.

#htl3r.fspace(
  figure(
    image("../assets/scada_cell2.png", width: 95%),
    caption: [Das SCADA-Dashboard der zweiten Betriebszelle]
  )
)

==== Betriebszelle Drei

In der dritten Betriebszelle ist der Stausee sowie das Überschwemmungsgebiet zu sehen. Hier ist über das #htl3r.short[scada] das Ventil manuell steuerbar. Auch der Sound-Alarm kann über das #htl3r.short[scada] überschrieben werden, um den Lärm bei einer Überflutung zu unterbinden. 

#htl3r.fspace(
  figure(
    image("../assets/scada_cell3.png", width: 95%),
    caption: [Das SCADA-Dashboard der dritten Betriebszelle]
  )
)

Wenn es in der Betriebszelle zu einer Überflutung kommt, so wird dies im #htl3r.short[scada] angezeigt grafisch dargestellt. Man sieht den Wasserstand steigen und dadurch, dass die #htl3r.short[sps] Alarme auslöst, werden auch diese aktiviert.

#htl3r.fspace(
  figure(
    image("../assets/scada_cell3_overflow.png", width: 95%),
    caption: [Das SCADA-Dashboard der dritten Betriebszelle bei einer Überflutung]
  )
)

== MES
Ein #htl3r.short[mes] ist ein System, mit welchem Prozesse etwas grober als mit einem #htl3r.short[scada] angesteuert werden. So können in einem #htl3r.short[mes] beispielsweise Zeitintervalle angegeben werden, in welchen die Maschinerie ein- oder ausgeschalten sein soll. Auch wird in einem #htl3r.short[mes] die gesamte Kette einer Produktionsanlage überwacht, nicht nur einzelne Abschnitte, und dadurch können Optimierungen leichter durchgeführt werden. Man kann jedoch unterschiedliche Aktoren nicht individuell verwenden werden -- dazu wird ein #htl3r.short[scada] verwendet. @symestic-mes[comp]

=== Next.js - shadcn
Da Lizenzkosten und Anschaffung eines industriereifen #htl3r.short[mes] für das Projekt nicht möglich wären, ist das verwendete #htl3r.short[mes] selbst geschrieben. Hierbei ist eine Web-App im Einsatz, welche mit dem #htl3r.short[scada] kommuniziert. Diese Web-App ist mit Next.js geschrieben, wobei Komponenten von shadcn verwendet werden, um sie leichter bedienbar zu machen.

=== Authentifizierung
Zur Authentifizierung bei der Anmeldung an das #htl3r.short[mes] sind Benutzer in einer Datenbank gespeichert. Diese Datenbank läuft auf dem #htl3r.short[mes]-Server, ist eine #htl3r.short[sql]-Lite Datenbank und ist nur über das eigene Netzwerk erreichbar, um Sicherheit zu gewährleisten. Unter Anwendung einer Middleware wird die Authentifizierung durchgeführt, wobei die Datenbankabfrage nur bei der Anmeldung durchgeführt wird. Dem Benutzer wird bei erfolgreicher Anmeldung ein #htl3r.short[jwt]-Token ausgestellt.

=== Funktionsweise
Im Falle, dass der Client einen gültigen #htl3r.short[jwt] Token vorweisen kann, besitzt dieser die Berechtigung, auf das Dashboard des #htl3r.short[mes] zuzugreifen. Über diese kann nun das #htl3r.short[scada] gesteuert werden, jedoch sind im Vergleich zum #htl3r.short[scada] nur gröbere Einstellungen möglich, welche jederzeit  im #htl3r.short[scada] überschrieben werden können. Die Kommunikation zwischen #htl3r.short[mes] und #htl3r.short[scada] erfolgt via #htl3r.short[api]-calls, die vom Backend des #htl3r.short[mes] verwaltet werden, wie sie in @scadalts-api-docs beschrieben ist. Es ist stark zu empfählen, diese #htl3r.short[api] vor der Verwendung mittels eines Tools wie Postman zu testen, um sich mit der Funktionsweise dieser vertraut zu machen.

=== Aufsetzen
#htl3r.todo("Dokumentation des Aufsetzens des MES")
