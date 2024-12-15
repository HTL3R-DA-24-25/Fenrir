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
  kurzfassung_text: [#lorem(180)],
  abstract_text: [#lorem(180)],
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
    (abbr: "VM", langform: [Virtual Machine], bedeutung: none),
    (abbr: "IT", langform: [Informational Technology], bedeutung: none),
    (abbr: "LAN", langform: [Local Area Network], bedeutung: none),
    (abbr: "AD", langform: [Active Directory], bedeutung: none),
    (abbr: "ADDC", langform: [Active Directory Domain Controller], bedeutung: none),
  ),
  literatur: bibliography("refs.yml", full: true, title: [Literaturverzeichnis], style: "harvard-cite-them-right"),
)

#include "text/provisionierung_und_iac.typ"
