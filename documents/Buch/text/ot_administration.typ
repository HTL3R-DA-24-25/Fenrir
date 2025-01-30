#import "@preview/htl3r-da:0.1.0" as htl3r

#htl3r.author("Bastian Uhlig")
= OT-Administration

== SCADA
#htl3r.short[scada] steht kurz für #htl3r.long[scada] und ist ein System zur Überwachung und Steuerung von mehreren Aktoren und Sensoren. 

=== Was ist ein SCADA-System?
In einer Betriebszelle existieren üblicherweise einige unterschiedliche #htl3r.shortpl[sps], auf welche Mitarbeiter keinen Zugriff haben. Selbst wenn dieser Zugriff möglich wäre, so wäre es sehr anstrengend aus den verscheidenen Registern die Werte auszulesen um die Anlage zu überwachen. Ein #htl3r.short[scada]-System hilft dabei, indem es als grafische Oberfläche zur Überwachung und Steuerung von verschiedenen #htl3r.shortpl[sps] agiert.

Hierbei ist zu beachten, dass ein #htl3r.short[scada]-System keine Signale automatisch sendet, sondern nur auf User-Input reagiert. Alle selbstgesteuerten Aktionen werden immer von #htl3r.shortpl[sps] durchgeführt.

Normalerweise wird pro Betriebszelle mindestens ein #htl3r.short[scada]-System verwendet, manchmal mehrere für Redundanz. Dies sorgt für höhere Sicherheit, da jedes #htl3r.short[scada] nur mit der "eigenen" Zelle kommunizieren darf. Falls die Zellen jedoch simpel gehalten sind und nur aus einer einzigen #htl3r.short[sps]en bestehen, so ist die Verwendung von mehreren #htl3r.short[scada]-Systemen unnötig und macht die Konfiguration nur komplizierter. In solch einem Fall  können mehrere Zellen zusammengefügt werden, damit das System leichter zu übersehen ist.

=== Scada-LTS
Als ein Fork von der Open-Source Software Scada-BR ist Scada-LTS der Nachfolger der vorhergehenden Software. Scada-LTS läuft virtualisiert auf einem Docker, und ist über eine von tomcat veröffentlichten Website zu erreichen. Datenhistorien werden separat in einer MySQL-Datenbank gespeichert, die typischer weise auch dockerisiert läuft.

==== Aufsetzen
Das Aufsetzten von Scada-LTS ist relativ simpel gestaltet, da nur die Docker-Images zu laden und zu starten sind. Auf dem öffentlichem Repository #footnote[https://github.com/SCADA-LTS/Scada-LTS] von Scada-LTS ist eine Docker-Compose Datei zu finden mit welcher das ganze System gestartet werden kann. Es ist jedoch sinnvoll, diese Datei anzupassen, um einen reibungslosen Start zu gewährleisten.

Vorallem ist dabei zu beachten, dass der Scada-LTS Docker abstürzt, sollte keine Verbindung zur Datenbank hergestellt werden können. Deshalb sollte Scada-LTS in der Docker-Compose Datei eine Abhängigkeit von der Datenbank bekommen, damit es erst startet, wenn die Datenbank bereit ist.
```yaml
depends_on:
    database:
        condition: service_healthy
```
Falls man Scada-LTS unter einem anderem Port als dem Standardmäßigem Port 8080 erreichen will, so sollte dieser Port freigeben und die Weiterleitung des gewünschten Ports auf den Port 8080 von Docker konfiguriert werden.
```yaml
ports:
    - "80:8080"
expose: ["80"]
```


==== Konfiguration
Jegliche Konfiguration von Scada-LTS erfolgt über das Webdashbord, welches unter `10.34.0.50/Scada-LTS` zu finden ist. Bei einer Erstaufsetzung meldet man sich hier mit den Anmeldedaten admin:admin an, diese sollten jedoch geändert werden.

Die mit Abstand wichtigste Konfiguration in einem #htl3r.short[scada] sind die Datasources, da diese jegliche Datenquellen darstellen. In Scada-LTS konfiguriert man diese unter dem gleichnamigem Punkt, wobei zu Testzwecken es auch möglich ist, virtuelle Datenquellen anzulegen. Dies ist im Echtbetrieb jedoch kaum sinnvoll.

Stattessen werden reale Datenquellen angegeben, welche typischerweise Modbus IP Quellen sind. Bei der Konfiguration sind einige Daten anzugeben, die wichtigsten hierbei sind der Transport Type, Host und Port.

Eine Datasource kann mehrere Datenpunkte haben, womit verschiedene Werte gemeint sind, die von der #htl3r.short[sps] ausgegeben werden. Datenpunkt beziehen sich immer auf eine Register range, Datentyp und einem Offset. Es können pro Datenquelle beliebig viele Datenpunkte konfiguriert werden, diese müssen jedoch mit der Konfiguration der Register auf der gegenüberliegenden #htl3r.short[sps] übereinstimmen um die Binärwerte richtig auslesen zu können.

Sinnvoll zu konfigurieren ist auch ein graphisches Interface, da dies einen schnellen Überblick über ein System bringt. Vorallem wenn dies mit interaktiven Bildern kombiniert wird, ist die Überwachung um einiges angenehmer. Hierbei sollte für jede Betriebszelle ein eigenes graphisches Interface erstellt werden, um eine optische Trennung zu ermöglichen.

Eine weitere Art der Übersicht ist durch Watchlists gegeben. Diese können sich als einfache Listen vorgestellt werden, wobei die derzeitigen Werte von konfigurierten Datapoints angezeigt werden. Im generellen Einsatz ist dies nur begrenzt sinvoll, da ein grafisches Interface eine benutzerfreundlichere Übersicht gibt, jedoch konnen Watchlists verwendet werden, um genauere Informationen zu geben.

==== Automatische Konfiguration
Im Falle einer automatischen Aufsetzung von Scada-LTS ist es am sinnvollsten, das System erst manuell zu konfigurieren, um danach via der Export-Funktion die Konfiguration als .zip-Datei abzuspeichern. Mittels einiger Befehle kann diese .zip-Datei dann automatisch eingefügt werden.
```bash
curl -d "username=admin&password=admin&submit=Login" -c cookies http://localhost/Scada-LTS/login.htm

curl -b cookies -v -F importFile=@project.zip http://localhost/Scada-LTS/import_project.htm

curl 'http://localhost/Scada-LTS/dwr/call/plaincall/EmportDwr.loadProject.dwr' -X POST -b cookies --data-raw $'callCount=1\npage=/Scada-LTS/import_project.htm\nhttpSessionId=\nscriptSessionId=D15BC242A0E69D4251D5585A07806324697\nc0-scriptName=EmportDwr\nc0-methodName=loadProject\nc0-id=0\nbatchId=5\n'

rm cookies
```
Zur Autorisierung wird dabei eine Datei "cookies" gespeichert, um den Login mit den Default-Anmeldedaten admin:admin zu ermöglichen. Dieses Konto sollte logischerweise nach der Konfiguration -- am Besten direct mit dem Import der .zip-Datei - deaktiviert werden, bzw. die Logindaten geändert werden.

== MES
Ein #htl3r.short[mes] ist ein System, mit welchem Prozesse etwas grober als mit einem SCADA angesteuert werden. So können in einem #htl3r.short[mes] beispielsweise Zeitintervalle angegeben werden, in welchen Maschinerie ein- oder ausgeschalten sein soll. Es können jedoch nicht unterschiedliche Aktoren individuell verwendet werden - dazu wird ein #htl3r.short[scada] verwendet. 

=== Laravel - shadcn
Da Lizenzkosten und Anschaffung eines industriereifen #htl3r.short[mes] für das Projekt nicht möglich wäre, ist das verwendete #htl3r.short[mes] selbst geschrieben. Hierbei ist eine simple WebApp im Einsatz, welche via #htl3r.short[http] mit dem #htl3r.short[scada] kommuniziert. Diese WebApp ist mit Laravel geschrieben, wobei Komponenten von shadcn verwendet werden. 

