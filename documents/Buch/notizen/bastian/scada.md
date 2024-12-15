# Scada
## Was ist ein SCADA?
In einer Betriebszelle existieren üblicherweise einige unterschiedliche PLCs, auf welche Mitarbeiter keinen Zugriff haben. Selbst wenn dieser Zugriff möglich wäre, so wäre es sehr anstrengend aus den verscheidenen Registern die Werte auszulesen um die Anlage zu überwachen. Ein SCADA System hilft dabei als Abhilfe, indem es als grafische Oberfläche zur Überwachung und Steuerung von verschiedenen PLCs agiert. 
Hierbei ist zu beachten, dass ein SCADA System keine Signale automatsich sendet, sondern nur auf User-Input reagiert. Alle selbstgesteuerten Aktionen werden immer von PLCs durchgeführt. 

Normalerweise wird pro Betriebszelle mindestens ein SCADA System verwendet, manchmal mehrere für Redundanz. Dies sorgt für höhere Sicherheit, da jedes SCADA nur mit der "eigenen" Zelle kommunizieren darf. Falls die Zellen jedoch simpel gehalten sind und nur aus einer einzigen PLC bestehen, so ist das verwenden von mehreren SCADA Systemen unnötig und macht die Konfiguration nur komplizierter, wodurch in solch einem Fall mehrere Zellen zusammengefügt werden können, damit das System Leichter zum Übersehen ist.

## [Scada-LTS](http://scada-lts.com/)
Als ein Fork von der Open-Source Software Sacad-BR, Scada-LTS ist der Nachfolger der vorherigen Software. Scada-LTS läuft virtualisiert auf einem Docker, und ist über eine von tomcat veröffentlichte Website zu erreichen. Datenhistorien werden separat in einer MySQL-Datenbank gespeichert, die typischer weise auch dockerisiert läuft.

### Aufsetzen
Das Aufsetzten von Scada-LTS ist relativ simpel gestaltet, da nur die Docker-Images zu laden und starten sind. Auf dem [öffentlichem Repository](https://github.com/SCADA-LTS/Scada-LTS) von Scada-LTS ist eine Docker-Compose Datei zu finden mit welcher das ganze System gestartet werden kann. Es ist jedoch sinnvoll, diese Datei anzupassen, um einen reibungslosen Start zu gewährleisten. 
Vorallem ist dabei zu beachten, dass der Scada-LTS Docker abstürzt, sollte keine Verbindung zur Datenbank hergestellt werden können. Deshalb sollte Scada-LTS in der Docker-Compose Datei eine Abhängigkeit von der Datenbank bekommen, damit es erst startet, wenn die Datenbank bereit ist.
```
depends_on:
    database:
        condition: service_healthy
```
Falls man Scada-LTS unter einem anderem Port als dem Standardmäßigem Port 8080 erreichen will, so sollte dieser Port freigeben und die Weiterleitung des gewünschten Ports auf den Port 8080 von Docker konfiguriert werden.

TODO: [https keygeneration](https://github.com/SCADA-LTS/Scada-LTS/wiki/Configuration-of-HTTPS-communication-for-Tomcat) (geht erst mit CA)

### Konfiguration
Jegliche Konfiguration von Scada-LTS erfolgt über das Webdashbord, welches unter `<IP-Adresse>/Scada-LTS` zu finden ist. Das mit Abstand wichtigste Tool hierbei sind die Datasources, da unter diesem Punkt jegliche Datenquellen konfiguriert sind. Zu Testzwecken ist es auch möglich, virtuelle Datenquellen anzulegen, jedoch dies im Echtbetrieb kaum sinnvoll. 
Stattessen werden tatsächliche Datasources angegeben, welche typischerweise Modbus IP Quellen sind. Bei der Konfiguration sind einige Daten anzugeben, die wichtigsten dabei der Transport Type, Host und Port. 
Nach dieser Konfiguration werden verschienede Datenpunkte angegeben. Diese beziehen sich immer auf eine Register range, Datentyp und einem Offset. Es klnnen pro Datenquelle beliebig viele Datenpunkte konfiguriert werden, diese müssen jedoch mit der Konfiguration der Register auf der gegenüberliegenden SPS übereinstimmen. 
Sinnvoll zu konfigurieren ist auch ein graphisches Interface, da diese schnellen Überblick über ein System bringen. Vorallem wenn dies mit Interaktiven Bildern kombiniert wird, ist die Überwachung um einiges angenehmer. 

Im Falle einer automatischen Aufsetzung von Scada-LTS ist es am sinnvollsten, das System erst manuell zu Konfigurieren um danach via der Export-Funktion die Konfiguration als .zip-Datei abzuspeichern. Via einiger Befehle kann diese .zip-Datei dann automatisch eingefügt werden.
```bash
curl -d "username=admin&password=admin&submit=Login" -c cookies http://localhost/Scada-LTS/login.htm

curl -b cookies  -v -F importFile=@project.zip http://localhost/Scada-LTS/import_project.htm

curl 'http://localhost/Scada-LTS/dwr/call/plaincall/EmportDwr.loadProject.dwr' -X POST -b cookies --data-raw $'callCount=1\npage=/Scada-LTS/import_project.htm\nhttpSessionId=\nscriptSessionId=D15BC242A0E69D4251D5585A07806324697\nc0-scriptName=EmportDwr\nc0-methodName=loadProject\nc0-id=0\nbatchId=5\n'

rm cookies
```
Zur Autorisierung wird dabei eine Datei "cookies" gespeichert, um den Login mit den Default-Anmeldedaten admin:admin zu ermöglichen. Dieses Konto sollte logischerweise nach der Konfiguration - am Besten direct mit dem Import der .zip-Datei - deaktiviert werden, bzw. die Logindaten geändert werden.