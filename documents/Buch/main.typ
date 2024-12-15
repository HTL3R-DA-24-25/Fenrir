#import "@local/htl3r-da:0.1.0" as htl3r

#show: htl3r.diplomarbeit.with(
  titel: "Fenrir",
  titel_zusatz: "Zum Schutz von OT-Netzwerken",
  abteilung: "ITN",
  schuljahr: "2024/2025",
  autoren: (
    (name: "Julian Burger", betreuung: "Christian Schöndorfer", rolle: "Mitarbeiter"),
    (name: "David Koch", betreuung: "Christian Schöndorfer", rolle: "Projektleiter"),
    (name: "Bastian Uhlig", betreuung: "Clemens Kussbach", rolle: "Stv. Projektleiter"),
    (name: "Gabriel Vogler", betreuung: "Clemens Kussbach", rolle: "Mitarbeiter"),
  ),
  betreuer_inkl_titel: (
    "Prof, Dipl.-Ing. Christian Schöndorfer",
    "Prof, Dipl.-Ing. Clemens Kussbach",
  ),
  sponsoren: (
    "easyname GmbH",
    "Fortinet Austria GmbH",
    "IKARUS Security Software GmbH",
    "Nozomi Networks Inc.",
    "Cyber Security Austria – Verein zur Förderung der Sicherheit Österreichs strategischer Infrastruktur",
    "NTS Netzwerk Telekom Service AG",
  ),
  kurzfassung_text: [#include "text/kurzfassung.typ"],
  abstract_text: [#include "text/abstract.typ"],
  datum: datetime.today(),
  druck_referenz: true,
  generative_ki_tools_klausel: none,
  abkuerzungen: (
    (abbr: "YAML", langform: [YAML Ain't Markup Language], bedeutung: [Eine menschlichlesbare strukturierte Textdatei, welche Daten beinhaltet.
      Wird oft zur konfiguration eingesetzt]),
    (abbr: "IaC", langform: [Infrastructure as Code], bedeutung: [Die Abbildung der Physischen und Virtuellen Infrastruktur als Datenstruktur
      oder auch Code.]),
    (abbr: "DVS", langform: [Distributed Virtual Switch], bedeutung: [Ein virtueller Switch welcher in einer vSphere-Umgebung mehreren Hosts
      zugewiesen sein kann. Dies ermöglicht es VMs auf mehrere Hosts zu verteilen und sie dennoch in dasselbe Netzwerk zu hängen, dieser virtuelle
      Switch dient zur verwaltung der Uplinks auf den jeweiligen Hosts.]),
    (abbr: "DPG", langform: [Distributed Port Group], bedeutung: [Ein virtuelles Netzwerksegment welches einem DVS zugewiesen werden kann.
      Dieses Netzwerksegment wird den VMs, welche über mehrere Hosts verteilt sein können, zugewiesen um somit ein LAN über mehrere Hosts zu schaffen.]),
    (abbr: "DHCP", langform: [Dynamic Host Configuration Protocol], bedeutung: [Ein Protokoll welches oft benutzt wird um dynamisch IP-Adressen über das
      Netzwerk zu verteilen.]),
    (abbr: "UUID", langform: [Universally Unique Identifier], bedeutung: [Eine Identifikationsnummer, welche Global nur ein einziges mal existiert.]),
    (abbr: "API", langform: [Application Programing Interface], bedeutung: [Eine Schnittstelle die eine Kommunikation zwischen Software ermöglicht.]),
    (abbr: "VM", langform: [Virtuelle Maschine], bedeutung: none),
    (abbr: "IT", langform: [Informational Technology], bedeutung: none),
    (abbr: "OT", langform: [Operational Technology], bedeutung: none),
    (abbr: "LAN", langform: [Local Area Network], bedeutung: none),
    (abbr: "VLAN", langform: [Virtual Local Area Network], bedeutung: none),
    (abbr: "AD", langform: [Active Directory], bedeutung: none),
    (abbr: "ADDC", langform: [Active Directory Domain Controller], bedeutung: none),
    (abbr: "I2C", langform: [Inter-Integrated Circuit], bedeutung: [Ein Zweidraht-Datenbus mit Master-Slave-Konzept.]), // TODO: burger mach die abkürzungsaliase unterschiedlich zu den abkürzungen selbst
    (abbr: "IO", langform: [Input/Output], bedeutung: none),
    (abbr: "GAU", langform: [Größter Anzunehmender Unfall], bedeutung: none),
    (abbr: "SPS", langform: [Speicherprogrammierbare Steuerung], bedeutung: none),
    (abbr: "CRC", langform: [Cyclic Redundancy Check], bedeutung: none),
    (abbr: "PSM", langform: [Python Submodule (for OpenPLC)], bedeutung: none),
    (abbr: "DMZ", langform: [Demilitarisierte Zone], bedeutung: [Ein eigenes Netzwerk für Dienste, die aus dem Internet zugänglich sind und vom internen Netz abgetrennt sind, um die Sicherheit zu erhöhen. Die Trennung der Netze erfolgt durch zwei Firewalls. TODO: ÄNDERN WEIL YGGDRASSIL KOPIE]),
    (abbr: "SCADA", langform: [Supervisory Control and Data Acquisition], bedeutung: none),
    (abbr: "UART", langform: [Universal Asynchronous Receiver Transmitter], bedeutung: none),
    (abbr: "ICS", langform: [Industrial Control System], bedeutung: none),
    (abbr: "GUI", langform: [Graphical User Interface], bedeutung: none),
  ),
  literatur: bibliography("refs.yml", full: true, title: [Literaturverzeichnis], style: "harvard-cite-them-right"),
)

#include "text/vorwort.typ"

#include "text/topologie.typ"

#include "text/aufbau_klaeranlage.typ"

#include "text/provisionierung_und_iac.typ"

#include "text/angriffe.typ"

#include "text/netzwerkanalyse.typ"

#include "text/nozomi_guardian.typ"

#include "text/firewall_config.typ"

#include "text/angriffe_gesichert.typ"

