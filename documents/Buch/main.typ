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
  abkuerzungen: yaml("abbr.yml"),
  literatur: bibliography("refs.yml", full: true, title: [Literaturverzeichnis], style: "harvard-cite-them-right"),
)

#include "text/vorwort.typ"

#include "text/topologie.typ"

#include "text/active_directory.typ"

#include "text/aufbau_klaeranlage.typ"

#include "text/ot_administration.typ"

#include "text/provisionierung_und_iac.typ"

#include "text/angriffe.typ"

#include "text/netzwerkueberwachung.typ"

#include "text/nozomi_guardian.typ"

#include "text/firewall_config.typ"

#include "text/angriffe_gesichert.typ"
