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

= Provisionierung und IaC
#htl3r.author("Julian Burger")

In der Industrie gibt es einen stetigen Trend, alles zu automatisieren. Eine Automatisierung der IT-Infrastruktur bringt ebenfalls Zeit- und Ressourcenersparnisse.
Diese Ersparnisse gilt es nicht zu vernachlässigen, demnach ist es das Ziel der Diplomarbeit, das gesamte IT-Netzwerk automatisch zu provisionieren und somit
zukunftssicher zu gestalten.

Automatische Provisionierung bedeutet, die gesamte oder auch nur Teile einer Firmen/Organisations-IT-Infrastruktur, sei es in physischer oder virtueller Form, ohne Eingriff von Personal
aufzusetzen. Um solch einen Prozess zu realisieren, wird meist eine Form von #htl3r.abbr[IaC] (= Infrastructure as Code) verwendet. Somit kann das Firmen/Organisations-Netzwerk und
dessen IT-Infrastruktur als strukturierte Datei oder auch als Code dargestellt werden.

Sollten somit Änderungen der bestehenden IT-Infrastruktur notwendig sein, so wird der #htl3r.abbr[IaC] Quelltext abgeändert und so angepasst, dass er den neuen
Anforderungen gerecht wird. Nun kann das verwendete Tool die Änderungen einlesen und ausrechnen, welche Änderungen bzw. welche Schritte eingeleitet werden müssen
um den Anforderungen, die definiert worden sind, gerecht zu werden. Diese Arbeitsschritte können jetzt ausgeführt werden, um den Änderungen gerecht zu werden.

== Verwendete Tools
Um den Anforderungen der Topologie gerecht zu werden, kommen mehrere Provisionierungs-Tools zum Einsatz:
#[
#set par(hanging-indent: 12pt)
- #strong[Packer:] Um mehrere Template-VMs, oder auch Golden-Images genannt, zu provisionieren.
- #strong[Terraform:] Um diese Template-VMs zu klonen und ihren Netzen so zuzuweisen, dass dies der Topologie entspricht.
- #strong[Ansible:] Um die mit Terraform provisionierten VMs zu konfigurieren oder auch benötigte Dateien bereitzustellen.
- #strong[pyVmomi:] Um besondere Änderungen in der vSphere-Umgebung zu tätigen, welche nicht von den anderen Tools unterstützt werden.
]
Um den gesamten Ablauf zu automatisieren, werden Bash-Skripts eingesetzt, welche das leichte Zusammenspiel der Software ermöglichen. So kann
Terraform Packer aufrufen, um die Template-VMs zu erzeugen, oder auch Ansible, um die VMs zu konfigurieren.

=== Packer
Packer, ein Produkt von HashiCorp, ermöglicht es, System-Images oder auch Container aus Code zu erzeugen. Dies ist nützlich, um Template-VMs in einer vSphere-Umgebung zu erstellen.
Damit dies jedoch möglich ist, braucht es das passende Packer-Plugin, dies ist in diesem Fall ```hcl "github.com/hashicorp/vsphere"```. Dieses Plugin kann wie folgt eingebunden werden:
#htl3r.code(caption: "Packer vSphere-Plugin einbindung", description: none)[
```hcl
packer {
  required_plugins {
    vsphere = {
      version = "~> 1"
      source = "github.com/hashicorp/vsphere"
    }
  }
}
```
]

Somit kann auf die ```hcl "vsphere-iso"``` Packer-Source zugegriffen werden. Dies ermöglicht es nun, eine VM in der vSphere-Umgebung zu provisionieren:
#htl3r.code_file(
  caption: "Packer vSphere-VM Beispiel",
  filename: [golden_linux_server/main.pkr.hcl],
  lang: "hcl",
  ranges: ((10, 19), (80, 80),),
  skips: ((19,0),),
  text: read("assets/scripts/golden_linux_server.pkr.hcl")
)

Durch das ```hcl convert_to_template = true``` im vorherigen Beispiel wird die VM automatisch nach Abschluss des Provisioniervorganges zu einer Template-VM umgewandelt
und kann dadurch direkt geklont werden.
#pagebreak()
Insgesamt werden 4 Template-VMs provisioniert, allerdings werden nur 3 davon in der Topologie, wie sie im physischen Netzplan sind, verwendet. Das extra Template ist eine
Bastion. Die Verwendung dieser wird im @prov-mit-bastion beschrieben. Die 3 restlichen Templates sind folgende:
#[
#set par(hanging-indent: 12pt)
- #strong[Linux Golden Image:] Template für alle Linux-Server in der Topologie. Hierbei wird Ubuntu-Server 24.04 verwendet.
- #strong[Windows Server Golden Image:] Template für alle Windows-Server in der Topologie. Hierbei wird Windows-Server 2022 verwendet.
- #strong[Windows Desktop Golden Image:] Template für alle Windows-Clients in der Topologie. Hierbei wird Windows 11 23H2 verwendet.
]
Das Linux-Server-Image wird mittels Cloud-Init, eine #emph["industry standard multi-distribution method for cross-platform cloud instance initialisation."] @ci-docs,
aufgesetzt. Cloud-Init liest eine gegebene #htl3r.abbr[YAML] Datei, im passenden Format, aus und konfiguriert aufgrund dessen den Server. Die Windows-Images werden ähnlich
aufgesetzt, jedoch wird eine ``` autounatend.xml``` Datei verwendet. Das Prinzip bleibt jedoch dasselbe.

=== Terraform
Terraform, ebenfalls ein Produkt von HashiCorp, ermöglicht es, die gesamte IT-Infrastruktur als Code darzustellen, dies beinhaltet VMs, #htl3r.abbrp[DVSs], #htl3r.abbrp[DPGs], etc. Allerdings existieren
gewisse Limitationen, da Terraform einen konvergenten Zustand gewährleisten muss. Damit dies jederzeit der Fall ist, ist es nicht möglich, zu jeder Zeit beliebig auf die definierten
Ressourcen zuzugreifen. Jedoch kann man gewisse "Create" und "Destroy" Provisioner definieren. So kann man Terraform mit anderen Tools integrieren.
Packer kann zum Beispiel beim Erstellen einer DPG aufgerufen werden und eine Template-VM erzeugen. So ähnlich wurde dies auch umgesetzt:
#htl3r.code_file(
  caption: "Terraform Bastion Provisionierung",
  filename: [stage_00/main.tf],
  lang: "tf",
  ranges: ((58, 63), (76, 80), (109, 113)),
  skips: ((63,0), (80, 0),),
  text: read("assets/scripts/stage_00.tf")
)

Dieser erzwungene konvergente Zustand hat jedoch, vor allem während der Entwicklung, Nachteile. Tritt ein Fehler während der Durchführung eines Erstellungsprozesses auf, so stoppt dies den Prozess und
Terraform zerstört alle bereits angelegten Ressourcen. Dies führt vor allem dann zu Frustration, wenn so ein Provisionierungsvorgang mehr als 30 Minuten andauert. Um dies zu umgehen, wird in sogenannten
"Stages" Provisioniert. Jede Stage ist abhängig von der Vorherigen, somit muss beispielsweise Stage 0 korrekt ausgeführt werden, damit Stage 1, in weiterer Folge, ausgeführt werden kann. Jede Stage ist
dafür verantwortlich zu beginnen einen Snapshot von allen Ressourcen zu machen, die für die Durchführung der Stage benötigt werden. So kann, falls die Stage fehlerhaft ausführt, zu dem vorherigen Stand
zurückgesprungen werden.

Solch ein Verfahren ist jedoch nicht allein mit Terraform möglich, da Terraform, falls ein Fehler auftritt, den erstellten Snapshot nur löscht und nicht auf diesen zurücksetzt. Somit werden alle
fehlerhafte Änderungen, welche von Skript-Provisionieren durchgeführt wurden, auf den vorherigen Stand übertragen. Damit solch eine Situation nicht auftritt, werden Destroy-Provisioner auf den Snapshots
konfiguriert:
#htl3r.code_file(
  caption: "Terraform Snapshot Destroy-Provisioner",
  filename: [stage_03/main.tf],
  lang: "tf",
  ranges: ((0, 6), (12, 16),),
  skips: ((6, 0),),
  text: read("assets/scripts/stage_03.tf")
)
#pagebreak()
Die von der Ressource gebrauchte ``` vm_uuids``` Variable ist in einer anderen Datei enthalten:
#htl3r.code_file(
  caption: "Terraform Snapshot Destroy-Provisioner VMs",
  filename: [stage_03/vms.tf],
  lang: "tf",
  text: read("assets/scripts/stage_03_vms.tf")
)
Terraform fragt mithilfe des Skriptes die #htl3r.abbrp[UUIDs] der ADDCs ab und befüllt mit ihnen die lokale Variable ``` vm_uuids```.

Um all dies zu ermöglichen, braucht Terraform den passenden Provider. Ein Terraform-Provider gibt an, wie mit einem gegebenen System zu interagieren ist. Durch einen Provider werden Ressourcen definiert
welche angelegt werden können und ebenso welche Daten abgefragt werden können. Um den Provider einzubinden, ist dieser zuerst zu definieren:
#htl3r.code(caption: "Terraform vSphere-Provider einbindung", description: none)[
```hcl
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.9.2"
    }
  }
}
```
]
Nachdem der Provider in einer Datei definiert ist, wird er automatisch, mit dem Befehl ```bash terraform init```, aus dem Terraform-Repository heruntergeladen. Nun müssen die Zugangsdaten von der
vSphere-Instanz an Terraform übermittelt werden:
#htl3r.code(caption: "Terraform vSphere-Provider definieren", description: none)[
```hcl
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_vcenter
  allow_unverified_ssl = true
  api_timeout          = 10
}
```
]
Die realen Zugangsdaten stehen in einer externen Datei, welche nicht Teil des Git-Repositorys ist.

=== Ansible
Ansible ist das dritte verwendete #htl3r.abbr[IaC] Tool, welches verwendet wird. Es ermöglicht es, Maschinen mittels Ansible-Playbooks zu konfigurieren. Diese Playbooks beinhalten mehrere Tasks, welche
ausgeführt werden. Diese Tasks können sehr komplex, jedoch auch sehr simpel sein. Ansible wird in der Topologie hauptsächlich für das Ausführen von Bash- und PowerShell-Skripten verwendet. Da oftmals
ein Neustart nach der Ausführung eines Befehls notwendig ist. Dies ist vor allem auf Windows-Servern ein bekanntes Problem. Terraform kann mit solchen Neustarts nicht umgehen, Ansible jedoch schon.

Die IPv4-Adressen der VMs im Managementnetzwerk sind oft unklar, denn sie werden über #htl3r.abbr[DHCP] bezogen. Demnach wird die IPv4-Adresse mittels Terraform ausgelesen und als Argument einem Bash-Skript
weiter gegeben. Dieses Bash-Skript erstellt nun ein Ansible-Inventory und führt das dazugehörige Ansible-Playbook aus. Die genaue Funktion des Managementnetzwerks ist in @prov-mit-bastion beschrieben. Der Ablauf von einem
Ansible aufruf sieht wie folgt aus:
#htl3r.code_file(
  caption: "Terraform Ansible Provisioning",
  filename: [stage_03/main.tf],
  range: (29, 43),
  lang: "tf",
  text: read("assets/scripts/stage_03.tf")
)
#htl3r.code_file(
  caption: "Ansible Execute Script",
  filename: [ansible/execute_stage_03.sh],
  range: (6, 21),
  lang: "bash",
  text: read("assets/scripts/stage_03_execute_script.sh")
)
#pagebreak()
#htl3r.code_file(
  caption: "Stage-03 Ansible-Playbook",
  filename: [ansible/playbooks/stages/stage_03/setup_dc_primary.yml],
  range: (0, 12),
  skips: ((12, 0),),
  lang: "yml",
  text: read("assets/scripts/setup_dc_primary.yml")
)
Der Grund, warum die ``` ansible_ssh_common_args``` Variable solch einen komplexen Inhalt hat, wird in @prov-mit-bastion beschrieben.

=== pyVmomi
Obwohl Packer, Terraform und Ansible ein sehr breites Spektrum abdecken, gibt es dennoch Limitationen. Um diese Limitationen zu umgehen, wird direkt auf die VMware-vSphere #htl3r.abbr[API] zurückgegriffen. Hierzu wird
pyVmomi verwendet, die offizielle Python-Bibliothek für vSphere. Mit pyVmomi ist es möglich, mit jeglicher Art von vSphere-Objekt zu interagieren. Es ist ebenfalls möglich, Parameter zu setzen, welche im
Web-GUI von vSphere nicht sichtbar sind. Der Anwendungszweck, welcher vom größten Interesse ist, ist das Setzen von Traffic-Filter Regeln auf #htl3r.abbrp[DPGs]. Dies ist in keinem der vorher genannten Tools
direkt möglich, allerdings ist es zwingend nötig, um das geplante Security-Konzept umzusetzen. Es soll kein Traffic zwischen Managed-VMs möglich sein, jedoch sollte sie trotzdem die Möglichkeit haben mit der Bastion zu
kommunizieren und DHCP-Requests zu verschicken. Hierzu nutzen wir folgende Traffic-Filter-Regeln:
#htl3r.fspace(
  figure(
    image("assets/filtering_rules.jpg"),
    caption: [Management Traffic-Filtering Regeln]
  )
)
#lorem(180)

== Provisionierung mittels Bastion <prov-mit-bastion>
#lorem(180)
