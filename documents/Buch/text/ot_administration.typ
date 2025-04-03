#import "@preview/htl3r-da:2.0.0" as htl3r

#htl3r.author("Bastian Uhlig")
= OT-Administration
Um ein #htl3r.short[ot]-Netzwerk zu administrieren, sind einige spezielle Tools notwendig. Diese Tools sind speziell auf die Anforderungen von #htl3r.short[ot]-Netzwerken zugeschnitten und können so die Sicherheit und Zuverlässigkeit eines solchen Netzwerks gewährleisten. Vorallem ein #htl3r.short[scada] und ein #htl3r.short[mes] sind hierbei von großer Bedeutung.

== SCADA
Ein #htl3r.full[scada] ist ein System zur Überwachung und Steuerung von mehreren Aktoren und Sensoren. Es ist ein wichtiger Bestandteil eines #htl3r.short[ot]-Netzwerks und stellt das Interface zwischen Mensch und Maschine dar. Ein #htl3r.short[scada] ist in der Lage, Daten von Sensoren zu lesen und Aktoren zu steuern. Es ist jedoch nicht in der Lage, eigenständig Aktionen durchzuführen, sondern reagiert nur auf User-Input.

=== Was ist ein SCADA-System?
In einer Betriebszelle existieren üblicherweise einige unterschiedliche #htl3r.shortpl[sps], auf welche Mitarbeiter keinen Zugriff haben. Selbst wenn dieser Zugriff möglich wäre, so wäre es sehr anstrengend, aus den verschiedenen Registern die Werte auszulesen oder in die Register Werte zu schreiben, um die Anlage zu überwachen oder zu steuern. Ein #htl3r.short[scada]-System hilft dabei, indem es als grafische Oberfläche zur Überwachung und Steuerung von verschiedenen #htl3r.shortpl[sps] agiert.

Hierbei ist zu beachten, dass ein #htl3r.short[scada]-System keine Signale automatisch sendet, sondern nur auf User-Input reagiert. Alle selbstgesteuerten Aktionen werden immer von #htl3r.shortpl[sps] durchgeführt.

Normalerweise wird pro Betriebszelle mindestens ein #htl3r.short[scada]-System verwendet, manchmal mehrere zur Redundanz. Dies sorgt für höhere Sicherheit, da jedes #htl3r.short[scada] nur mit der "eigenen" Zelle kommunizieren darf. Falls die Zellen jedoch simpel gehalten sind und nur aus einer einzigen #htl3r.short[sps]en bestehen, so ist die Verwendung von mehreren #htl3r.short[scada]-Systemen unnötig und macht die Konfiguration nur komplizierter. In solch einem Fall können mehrere Zellen zusammengefügt werden, damit das System überschaubarer ist.

=== Scada-LTS
Als ein Fork von der Open-Source Software Scada-BR ist Scada-LTS der Nachfolger der vorhergehenden Software. Scada-LTS läuft virtualisiert auf einem Docker und ist über eine von tomcat veröffentlichten Website zu erreichen. Datenhistorien werden separat in einer MySQL-Datenbank gespeichert, die typischerweise auch dockerisiert läuft.

==== Aufsetzen von SCADA-LTS
Das Aufsetzen von Scada-LTS ist relativ simpel gestaltet, da nur die Docker-Images zu laden und zu starten sind. Auf dem öffentlichen Repository #footnote[https://github.com/SCADA-LTS/Scada-LTS] von Scada-LTS ist eine Docker-Compose Datei zu finden, mit welcher das ganze System gestartet werden kann. Es ist jedoch sinnvoll, diese Datei anzupassen, um einen reibungslosen Start zu gewährleisten.

Vor allem ist dabei zu beachten, dass der Scada-LTS Docker abstürzt, sollte keine Verbindung zur Datenbank hergestellt werden können. Deshalb muss Scada-LTS in der Docker-Compose Datei eine Abhängigkeit von der Datenbank bekommen, damit es erst startet, wenn die Datenbank bereit ist.
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
Jegliche Konfiguration von Scada-LTS erfolgt über das Webdashbord, welches unter `10.34.0.50/Scada-LTS` zu finden ist. Bei einer Erstaufsetzung meldet man sich hier mit den Anmeldedaten admin:admin an, diese sollten jedoch später geändert werden.

Die mit Abstand wichtigste Konfiguration in einem #htl3r.short[scada] sind die Datasources, da diese jegliche Datenquellen darstellen. In Scada-LTS konfiguriert man diese unter dem gleichnamigen Punkt, wobei zu Testzwecken es auch möglich ist, virtuelle Datenquellen anzulegen. Dies ist im Echtbetrieb jedoch kaum sinnvoll.

Stattdessen werden reale Datenquellen angegeben, welche typischerweise Modbus-#htl3r.short[ip] Quellen sind. Bei der Konfiguration sind einige Daten anzugeben, die wichtigsten hierbei sind der Transport-Type, Host und Port.

Eine Datasource kann mehrere Datenpunkte haben, womit verschiedene Werte gemeint sind, die von der #htl3r.short[sps] ausgegeben werden. Datenpunkte beziehen sich immer auf eine Register range, Datentyp und einem Offset. Es können pro Datenquelle beliebig viele Datenpunkte konfiguriert werden, diese müssen jedoch mit der Konfiguration der Register auf der gegenüberliegenden #htl3r.short[sps] übereinstimmen, um die Binärwerte richtig auslesen zu können.

#htl3r.fspace(
  [
    #figure(
    image("../assets/scada_datasource.png", width: 100%),
    caption: [Anlegen einer Datasource in Scada-LTS]
  )
  <scada-datasource>
  ]
)

In @scada-datasource ist die Konfiguration einer Datasource zu sehen. Dabei ist der Transport-Type von #htl3r.short[tcp] zu beachten, sowie die verwendete Host-#htl3r.short[ip]. Scada-LTS stellt einen Modbus-Scan in der Konfiguration zur Verfügung, mit welchem nach verwendeten Coils gesucht werden kann. Wenn man nun den Offset der Register weiß, erstellt man im unteren Teil der Oberfläche neue Points, wobei man hier diese auch schon sehen kann.  

Bei dem Hinzufügen eines neuen Datapoints unter einer Datasource ist darauf zu achten, dass der Datentyp mit dem auf der #htl3r.short[sps] konfigurierten Datentyp übereinstimmt, damit auch die richtige Anzahl an Bits gelesen wird. Weiters ist der Offset von großer Bedeutung, da dieser angibt, ab welchem Register der Datapoint gelesen werden soll. Meist findet man in der Dokumentation der #htl3r.short[sps] den benötigten Offset, falls nicht, muss dieser gescannt werden. Auch die Register range ist wichtig, da diese verschiedene Typen von Registern repräsentiert. Nur Input- oder Holding-Register können Datentypen annehmen, die nicht binär sind. Coil status sowie Input status sind dagegen immer binär. Außerdem kann man nur Input-Register setzen, alle anderen sind read-only. \

#htl3r.fspace(
  [
    #figure(
    image("../assets/scada_datapoint.png", width: 100%),
    caption: [Anlegen eines Datapoints in Scada-LTS]
  )
  ]
)

Es ist auch sinnvoll, ein grafisches Interface zu konfigurieren, da dies einen schnellen Überblick über ein System bringt. Vor allem, wenn dies mit interaktiven Bildern kombiniert wird, ist die Überwachung um einiges angenehmer. Hierbei sollte für jede Betriebszelle ein eigenes grafisches Interface erstellt werden, um eine optische Trennung zu ermöglichen.

Eine weitere Art der Übersicht ist durch Watchlists gegeben. Diese können sich als einfache Listen vorgestellt werden, wobei die derzeitigen Werte von konfigurierten Datapoints angezeigt werden. Im generellen Einsatz ist dies nur begrenzt sinnvoll, da ein grafisches  Interface eine benutzerfreundlichere Übersicht gibt, jedoch können Watchlists verwendet werden, um genauere Informationen zu geben.

==== Automatische Konfiguration von SCADA-LTS
Im Falle einer automatischen Aufsetzen von Scada-LTS ist es am sinnvollsten, das System erst manuell zu konfigurieren, um danach via der Export-Funktion die Konfiguration als .zip-Datei abzuspeichern. Mittels einiger Befehle kann diese .zip-Datei dann automatisch eingefügt werden.
#htl3r.code(caption: "Skript zum Import eines Projektes in Scada-LTS", description: none)[
```bash
curl -d "username=admin&password=admin&submit=Login" -c cookies http://localhost/Scada-LTS/login.htm

curl -b cookies -v -F importFile=@project.zip http://localhost/Scada-LTS/import_project.htm

curl 'http://localhost/Scada-LTS/dwr/call/plaincall/EmportDwr.loadProject.dwr' -X POST -b cookies --data-raw $'callCount=1\npage=/Scada-LTS/import_project.htm\nhttpSessionId=\nscriptSessionId=D15BC242A0E69D4251D5585A07806324697\nc0-scriptName=EmportDwr\nc0-methodName=loadProject\nc0-id=0\nbatchId=5\n'

rm cookies
```
]
Zur Authentifizierung wird dabei eine Datei "cookies" gespeichert, um den Login mit den Default-Anmeldedaten admin:admin zu ermöglichen. Dieses Konto sollte logischerweise nach der Konfiguration -- am besten direkt mit dem Import der .zip-Datei -- deaktiviert werden, bzw. die Logindaten geändert werden.

=== Administration der Modell-Kläranlage

Die Administration der Modell-Kläranlage erfolgt ausschließlich über das #htl3r.short[scada]. Hierbei sind drei Betriebszellen zu unterscheiden, jedoch werden alle drei Betriebszellen über das gleiche #htl3r.short[scada] gesteuert, weil jede Anlage nur eine einzige #htl3r.short[sps] besitzt. In einer Echtumgebung wäre das Einsetzen von mehreren #htl3r.shortpl[scada] sinnvoll, um eine physische Trennung zu haben. \
Im Falle der Modell-Kläranlage ist es nicht der Fall. Hier wird jede Betriebszelle durch Verwendung eines unterschiedlichen grafischen Interface unterteilt, um damit eine optische Trennung herzustellen.

==== Betriebszelle Eins

In der ersten Betriebszelle ist nur die Schraube, welche das Wasser in den obersten Wassertank befördert, mittels #htl3r.short[sps] gesteuert, wodurch auch das #htl3r.short[scada] nur diese Schraube steuern kann. Über das #htl3r.short[scada] kann die Schraube ein- bzw. ausgeschalten werden. \
Das grafische Interface der ersten Betriebszelle zielt vor allem stark darauf ab, den Fluss des Wassers zu visualisieren. So sind die Tanks und die Schraube grafisch dargestellt, um Endnutzern eine einfache Übersicht zu geben. \
Man erkennt hier auch den Fluss des Wassers, dieser ist zwar nicht live animiert, jedoch wird einem Benutzer so klar, dass das Wasser erst die Schnecke hinauf befördert werden muss, bevor es durch den Rechen in das Auffangbecken gelangt und von dort weiter in die nächste Zelle befördert wird. Steine werden hierbei ausgefiltert. 

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

#htl3r.author("David Koch")
=== Konfiguration der Modbus TCP Kommunikation auf den SPSen

Damit das #htl3r.short[scada]-System auf die #htl3r.shortpl[sps] zugreifen und deren Werte auslesen kann, müssen die #htl3r.shortpl[sps] Kommunikation über Modbus #htl3r.short[tcp] zulassen. Bei der OpenPLC-#htl3r.short[sps] zum Beispiel ist diese Kommunikationsschnittstelle standardmäßig aktiviert, bei der Siemens LOGO! und der S7-1200 nicht.

Um auf der LOGO! die Modbus #htl3r.short[tcp] Kommunikation zu aktivieren, muss in den Einstellungen unter #htl3r.breadcrumbs(("Offline Settings", "General", "Ethernet connections")) die Checkbox für "Allow Modbus access" aktiviert werden. Danach muss noch unterhalb dieser Checkbox der konkrete Modbus-Server, also das #htl3r.short[scada]-System, konfiguriert werden.

#htl3r.fspace(
  figure(
    image("../assets/ot-work/logo_modbus_checkbox.png"),
    caption: [Die aktivierte Modbus-Schnittstelle auf der LOGO! SPS]
  )
)

Bei der Konfiguration des Modbus-Servers muss lediglich der Port und die #htl3r.short[ip]-Adresse eingetragen werden. Es kann auch ausgewählt werden, dass unabhängig von der #htl3r.short[ip]-Adresse alle Anfragen akzeptiert werden, dies sollte jedoch sicherheitstechnisch nicht verwendet werden.

#htl3r.fspace(
  figure(
    image("../assets/ot-work/logo_modbus_server.png", width: 70%),
    caption: [SCADA-System als Modbus-Server auf der LOGO! SPS]
  )
)

Im Gegenteil zur LOGO! und OpenPLC ist die nötige Konfiguration für eine Modbus-Kommunikation auf der S7-1200 um einiges komplizierter gestaltet. Parallel zum Programm der ersten Zelle muss ein weiteres Programm laufen, welches nur aus einem Modbus-Server-Funktionsbaustein besteht. Der `MB_SERVER` Funktionsbaustein ist unter #htl3r.breadcrumbs(("Communication", "Others", "MODBUS TCP")) zu finden.

#htl3r.fspace(
  figure(
    image("../assets/ot-work/modbus_fup.png", width: 90%),
    caption: [Der `MB_SERVER` Funktionsbaustein]
  )
)

Der Funktionsbaustein bietet drei Eingabe- und vier Ausgabe-Variablen, wobei auf beiden Seiten jeweils nur zwei verwendet werden. Die Eingabe-Variable `MB_HOLD_REG` ist der Speicherbereich für die "Holding Register" des Modbus-Servers. Der Modbus-Client kann auf diese Register lesend und schreibend zugreifen. Die Größe des Arrays bestimmt, wie viele Register zur Verfügung stehen. Die Variable `CONNECT` dient zur Angabe der Verbindungseinstellungen. Zu den Verbindungseinstellungen gehören, unter anderem, die #htl3r.short[ip]-Adresse des Remote-Hosts, der Modbus-Port, die Connection-ID und der Connection-Type.

#htl3r.fspace(
  figure(
    image("../assets/ot-work/modbus_config_db.png"),
    caption: [Inhalt des "ModbusConfigDB"-Datenbausteins]
  )
)

#htl3r.author("Bastian Uhlig")
#pagebreak(weak: true)
== MES
Ein #htl3r.short[mes] ist ein System, mit welchem Prozesse etwas "grober" als mit einem #htl3r.short[scada] angesteuert werden. So können in einem #htl3r.short[mes] beispielsweise Zeitintervalle angegeben werden, in welchen die Maschinerie ein- oder ausgeschalten sein soll. Auch wird in einem #htl3r.short[mes] die gesamte Kette einer Produktionsanlage überwacht, nicht nur einzelne Abschnitte, und dadurch können Optimierungen leichter durchgeführt werden. Man kann jedoch unterschiedliche Aktoren nicht individuell verwenden werden -- dazu wird ein #htl3r.short[scada] verwendet. @symestic-mes[comp]

=== Entwicklung des MES
Da Lizenzkosten und Anschaffung eines industriereifen #htl3r.short[mes] für das Projekt nicht möglich waren, ist das verwendete #htl3r.short[mes] selbst geschrieben. Hierbei ist eine Web-App im Einsatz, welche mit dem #htl3r.short[scada] kommuniziert. Diese Web-App ist mit Next.js geschrieben, wobei Komponenten von shadcn verwendet werden, um sie leichter bedienbar und visuell ansprechbarer zu machen.

#htl3r.fspace(
  figure(
    image("../assets/mes-ablaufdiagram.png"),
    caption: [Ablauf von Userinteraktionen im MES]
  )
)

==== Authentifizierung
Zur Authentifizierung bei der Anmeldung an das #htl3r.short[mes] ist ein Benutzer in den Umgebungsvariablen festgelegt. Nur bei der Neuanmeldung eines Benutzers wird der Benutzername kontrolliert. Danach wird mittels #htl3r.short[jwt] ein Token generiert, welcher als Authentifizierung dient. Dieser Token ist nur für eine bestimmte Zeit (4h) gültig, damit ein eingeloggter Benutzer nach dieser Zeit das Passwort neu eingeben muss, um die Sicherheit zu gewährleisten. Dies bewirkt auch, dass ein gehijackter Token nicht unendlich lange ausgenutzt werden kann, da solch ein Angriff im Falle von #htl3r.short[jwt]-Tokens relativ häufig ist. \

#htl3r.code(caption: "Funktion zum Anmelden am MES", description: none)[
```ts
export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }
  const { username, password } = req.body;
  const { USER, PASSWORD } = process.env;
  const JWT_SECRET = process.env.JWT_SECRET;
  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password are required' });
  }
  if (!USER || !PASSWORD) {
    return res.status(500).json({ error: 'USER and PASSWORD are not set' });
  }
  if (username !== USER) {
    return res.status(401).json({ error: 'Invalid username or password' });
  }
  const isValidPassword = await bcrypt.compare(password, await bcrypt.hash(PASSWORD, 10));
  if (!isValidPassword) {
    return res.status(401).json({ error: 'Invalid username or password' });
  }
  if (!JWT_SECRET) {
    return res.status(500).json({ error: 'JWT_SECRET is not set' });
  }
  const token = jwt.sign({ username }, JWT_SECRET, { expiresIn: '4h' });
  res.setHeader('Set-Cookie', `token=${token}; Path=/; HttpOnly; SameSite=Strict`);
  res.status(200).json({ message: "Set cookie" });
}
```
]

Versucht ein Benutzer, auf eine Seite zuzugreifen, ohne angemeldet zu sein, oder sollte der vorgewiesene Token ungültig sein, so wird dieser von einer Middleware abgefangen und der Benutzer auf die Anmeldeseite weitergeleitet. Gleichfalls fängt die Middleware auch bereits angemeldete Benutzer davon ab, sich erneut anzumelden. Damit werden auch die #htl3r.short[api]-Endpunkte geschützt, sodass nur angemeldete Benutzer darauf zugreifen können.

#htl3r.code(caption: "Middleware zum Überprüfen des Tokens und Weiterleitung", description: none)[
```ts
export default function handler(req: NextApiRequest, res: NextApiResponse) {}
export const config = {
    matcher: ["/login", "/dashboard", "/api/add_datapoint_timer", "/api/get_datapoint_timers", "/api/delete_datapoint_timer"],
};
export async function middleware(request: NextRequest) {
    const { pathname }: { pathname: string } = request.nextUrl;
    const token = request.cookies.get("token");
    const response = await fetch(`${request.nextUrl.origin}/api/authenticate`, {
        method: "GET",
        headers: { Authorization: `Bearer ${token?.value}` },
    });
    await response.json();

    if (response.ok && pathname === "/login") {
        return NextResponse.redirect(new URL("/dashboard", request.nextUrl));
    } else if (!response.ok) {
        if (pathname !== "/login") {
            return NextResponse.redirect(new URL("/login", request.nextUrl));
        }
    }
}
```
]

==== Funktionsweise im Frontend
Während sich der Benutzer auf der Website befindet, findet eine permanente Kommunikation mit dem Backend statt, um Daten aktuell zu halten. Alle vorhandenen Datenpunkte werden dabei in einem eigenen Typen gespeichert, um eine einfache Verwaltung zu ermöglichen. die ersteren Variablen kommen dabei vom #htl3r.short[scada], die letzteren sind Einstellungen, die nur im #htl3r.short[mes] vorgenommen werden können, da sie sich auf dieses beziehen. \
#htl3r.code(caption: "Middleware zum Überprüfen des Tokens und Weiterleitung", description: none)[
```ts
export type Datapoint = {
    id: number;
    xid: string;
    name: string;
    extendName: string;
    dataType: "NUMERIC" | "STRING" | "BINARY";
    enabled: boolean;
    description: string;
    type: number;
    typeId: number;
    dataSourceName: string;
    // MES Settings, not from the SCADA
    date?: Date;
    startTime?: string;
    endTime?: string;
    active: boolean;
};
```
]
Die #htl3r.short[mes] spezifischen Variablen dürfen dabei nicht überschrieben werden, sollten die vom #htl3r.short[scada] stammendenden Daten aktualisiert werden.
#htl3r.code(caption: "Codeabschnitt zum Aktualisieren der Datenpunkte", description: none)[
```ts
const updatedData = data.map((datapoint: Datapoint) => {
          const existingDatapoint = prevDatapoints.find(xid => xid.xid === datapoint.xid);
          return {
            ...datapoint,
            date: existingDatapoint?.date,
            startTime: existingDatapoint?.startTime,
            endTime: existingDatapoint?.endTime,
            active: existingDatapoint?.active ?? datapoint.active ?? false
          };
        });
```
]
All die Datenpunkte werden schlussendlich in einer Tabelle dargestellt, in welche Benutzer Daten sowie Uhrzeiten auswählen können, um Jobs zu erstellen. \

Die zweite Tabelle zeigt alle derzeitig geplanten Jobs an, welche in der Zukunft ausgeführt werden sollen. Diese Jobs können nicht bearbeitet werden, sondern nur gelöscht, womit die Tabelle fast ausschließlich zum Einsehen gemacht ist. Falls ein Job abgeschlossen ist, wird dieser automatisch gelöscht. \
Um auch die Namen der Datenpunkte anzeigen zu können, werden diese mit den Datenpunkten vom #htl3r.short[scada] abgeglichen, da im #htl3r.short[mes] nur die xid gespeichert wird.
#htl3r.code(caption: "Codeabschnitt zum Abgleichen der Datenpunktnamen", description: none)[
```ts
const updatedData = data.map((timerItem: { xid: string; }) => ({
        ...timerItem,
        name: currentDatapoints.find(item => item.xid === timerItem.xid)?.name
      }));
```
]
Soll nun ein Datenpunkt gelöscht werden, so wird mittels eines #htl3r.short[api]-calls an das Backend ein Request gesendet, welcher den Datenpunkt löscht. Hierbei wird über eine #htl3r.short[mes]-interne ID gearbeitet, da die xid nicht eindeutig ist. Dies ist der Fall, da ein Datenpunkt, welcher von einer xid beschrieben wird, gleichzeitig mehrere aktive Jobs haben kann. \


==== Funktionsweise im Backend
User-Inputs in der Web-App werden mittels #htl3r.short[api]-calls an das Backend geleitet, welches diese verarbeitet und dann erneut via #htl3r.short[api]-calls an das #htl3r.short[scada] weiterleitet. Im Backend findet die Verarbeitung von Anfragen statt, sowie auch das ausführen, hinzufügen und löschen von Jobs. Jobs sind in diesem Fall Zeitintervalle, in welchen ein Aktor ein- oder ausgeschalten werden soll. Diese Jobs sind unabhängig vom Client, also sind sie für jeden User gleich. Außerdem kann die Webpage geschlossen werden, ohne dass Jobs terminiert werden. \
Alle Jobs werden mittels Node-Cron verwaltet, um sie zur gewünschten Uhrzeit auszuführen. Das Hinzufügen und Löschen von Jobs erfolgt über die im folgenden Quellcode 5.7 zu sehenden Funktionen, welche je über einen #htl3r.short[api]-Call aufgerufen werden. Mehr zu den Jobs ist im Abschnitt @cron-jobs zu finden.

#htl3r.code-file(
  caption: "Funktionen, zur Erstellung und Löschung von Jobs",
  filename: [datapoint_timers.ts],
  lang: "ts",
  ranges: ((12, 14),(16, 20),(26, 33)),
  text: read("../assets/scripts/mes_datapoint_timers.ts")
)

Die Kommunikation zwischen #htl3r.short[mes] und #htl3r.short[scada] erfolgt via #htl3r.short[api]-calls, die vom Backend des #htl3r.short[mes] verwaltet werden, wie sie in @scadalts-api-docs beschrieben ist. Es ist stark zu empfehlen, diese #htl3r.short[api] vor der Verwendung mittels eines Tools wie Postman zu testen, um sich mit der Funktionsweise dieser vertraut zu machen. Dazu sind auf dem #htl3r.short[mes] mehrere Endpunkte definiert, welche die Kommunikation mit dem #htl3r.short[scada] ermöglichen.

#htl3r.code-file(
  caption: "API zum Setzen eines Datenpunktes",
  filename: [set_datapoint.ts],
  lang: "ts",
  ranges: ((6, 31),),
  text: read("../assets/scripts/mes_set_datapoint.ts")
)


==== Cron Jobs <cron-jobs>
Cron Jobs sind in der Web-App dafür zuständig, dass Jobs zur gewünschten Zeit ausgeführt werden. Diese Jobs werden mittels Node-Cron verwaltet und sind unabhängig von der Web-App. Sie werden beim Hinzufügen von neuen Jobs erstellt und laufen auch weiter, wenn die Web-App geschlossen wird. Ein Job besteht immer aus zwei Teilen: der Aktivierung sowie der Deaktivierung. Dabei geht es nicht strikt um das Ein- oder Ausschalten von einem Datenpunkt, sondern um das setzen und zurücksetzen des gewünschten Wertes. \

#htl3r.code-file(
  caption: "In einen Cron-Job ausgeführter Job",
  filename: [datapoint_timers.ts],
  lang: "ts",
  ranges: ((53, 58), ),
  text: read("../assets/scripts/mes_datapoint_timers.ts")
)

=== Funktionsweise für Enduser
Im Falle, dass der Client einen gültigen #htl3r.short[jwt] Token vorweisen kann, besitzt dieser die Berechtigung, auf das Dashboard des #htl3r.short[mes] zuzugreifen. Über diese kann nun das #htl3r.short[scada] gesteuert werden, jedoch sind im Vergleich zum #htl3r.short[scada] nur gröbere Einstellungen möglich, welche jederzeit im #htl3r.short[scada] überschrieben werden können. Das #htl3r.short[mes] ruft automatisch alle vorhandenen Datenpunkte vom #htl3r.short[scada] ab und stellt alle binären -- also alle, welche nur ein- und ausschalten sind -- auf dem Dashboard dar. \

#htl3r.fspace(
  figure(
    image("../assets/MES-Dashboard-Datapoints.png", width: 100%),
    caption: [Alle Datenpunkte des SCADA-Systems auf dem Dashboard des MES]
  )
)

Weiters sind auf dem Dashboard alle geplanten Jobs zu sehen, welche in der Zukunft ausgeführt werden sollen. Diese Jobs können nicht bearbeitet werden, sondern nur gelöscht. Falls ein Job abgeschlossen ist, wird dieser automatisch gelöscht. \

#htl3r.fspace(
  figure(
    image("../assets/MES-Dashboard-Jobs.png", width: 100%),
    caption: [Alle upcoming Jobs auf dem Dashboard des MES]
  )
)

Falls kein gültiger #htl3r.short[jwt] Token vorliegt, wird der Client auf die Anmeldeseite weitergeleitet. Hierbei wird der Benutzername und das Passwort abgefragt, wobei der Benutzername in den Umgebungsvariablen festgelegt ist. Nach der Anmeldung wird ein #htl3r.short[jwt] Token generiert, welcher für vier Stunden gültig ist. Dieser Token wird in einem Cookie gespeichert, um den Benutzer automatisch anzumelden, sollte dieser die Seite neu laden. Weiters erhält der Client auch den Token zur Anmeldung am #htl3r.short[scada], damit dieser nicht im Backend verwaltet werden muss. \

#htl3r.fspace(
  figure(
    image("../assets/MES-Login.png", width: 100%),
    caption: [Der Login-Screen des MES]
  )
)

=== Aufsetzen
Da das #htl3r.short[mes] mittels Next.js geschrieben ist, kann das fertige System in einen Docker-Image gepackt werden. Dieses Image ist dann auf den Server zu kopieren und mit Einbindung der .env Datei zu starten. Diese .env Datei enthält die Konfiguration des #htl3r.short[mes], wie beispielsweise die Anmeldedaten für die #htl3r.short[api] des #htl3r.short[scada] oder die Adresse des #htl3r.short[scada]-Servers.

