#import "@preview/htl3r-da:0.1.0" as htl3r

#show: htl3r.diplomarbeit.with(
  title: "Fenrir",
  subtitle: "Zum Schutz von OT-Netzwerken",
  department: "ITN",
  school-year: "2024/2025",
  authors: (
    (name: "Julian Burger", supervisor: "Christian Schöndorfer", role: "Mitarbeiter"),
    (name: "David Koch", supervisor: "Christian Schöndorfer", role: "Projektleiter"),
    (name: "Bastian Uhlig", supervisor: "Clemens Kussbach", role: "Stv. Projektleiter"),
    (name: "Gabriel Vogler", supervisor: "Clemens Kussbach", role: "Mitarbeiter"),
  ),
  supervisor-incl-ac-degree: (
    "Prof. Dipl.-Ing. Christian Schöndorfer",
    "Prof. Dipl.-Ing. Clemens Kussbach",
  ),
  sponsors: (
    "easyname GmbH",
    "Fortinet Austria GmbH",
    "IKARUS Security Software GmbH",
    "Nozomi Networks Inc.",
    "Cyber Security Austria – Verein zur Förderung der Sicherheit Österreichs strategischer Infrastruktur",
    "NTS Netzwerk Telekom Service AG",
  ),
  abstract-german: [#include "text/kurzfassung.typ"],
  abstract-english: [#include "text/abstract.typ"],
  date: datetime.today(),
  print-ref: true,
  generative-ai-clause: none,
  abbreviation: yaml("abbr.yml"),
  bibliography: bibliography("refs.yml", full: true, title: [Literaturverzeichnis], style: "harvard-cite-them-right"),
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

#include "text/weitere_absicherung.typ"

#include "text/angriffe_gesichert.typ"
