#import "@local/htl3r-da:0.1.0" as htl3r

= Provisionierung und IaC
#htl3r.author("Julian Burger")

In der Industrie gibt es einen stetigen Trend, alles zu automatisieren. Eine Automatisierung der #htl3r.shorts[it]-Infrastruktur bringt Zeit- und Ressourcenersparnisse. Diese Ersparnisse gilt es nicht zu vernachlässigen, demnach ist es das Ziel der Diplomarbeit, das gesamte #htl3r.shorts[it]-Netzwerk automatisch zu provisionieren und somit zukunftssicher zu gestalten.

Automatische Provisionierung bedeutet, die gesamte oder auch nur Teile einer Firmen/Organisations-#htl3r.shorts[it]-Infrastruktur, sei es in physischer oder virtueller Form, ohne Eingriff von Personal aufzusetzen. Um solch einen Prozess zu realisieren, wird meist eine Form von #htl3r.shorts[iac] (= Infrastructure as Code) verwendet. Somit kann das Firmen/Organisations-Netzwerk und dessen #htl3r.shorts[it]-Infrastruktur als strukturierte Datei oder auch als Code dargestellt werden.

Sollten somit Änderungen der bestehenden #htl3r.shorts[it]-Infrastruktur notwendig sein, so wird der #htl3r.shorts[iac] Quelltext abgeändert und so angepasst, dass er den neuen Anforderungen gerecht wird. Nun kann das verwendete Tool die Änderungen einlesen und ausrechnen, welche Änderungen bzw. welche Schritte eingeleitet werden müssen um den Anforderungen, die definiert worden sind, gerecht zu werden. Diese Arbeitsschritte können jetzt ausgeführt werden, um den Änderungen gerecht zu werden.

== Verwendete Tools
Um den Anforderungen der Topologie gerecht zu werden, kommen mehrere Provisionierungs-Tools zum Einsatz:
#[
#set par(hanging-indent: 12pt)
- #strong[Packer:] Um mehrere Template-#htl3r.shortpl[vm], oder auch Golden-Images genannt, zu provisionieren.
- #strong[Terraform:] Um diese Template-#htl3r.shortpl[vm] zu klonen und ihren Netzen so zuzuweisen, dass dies der Topologie entspricht.
- #strong[Ansible:] Um die mit Terraform provisionierten #htl3r.shortpl[vm] zu konfigurieren oder auch benötigte Dateien bereitzustellen.
- #strong[pyVmomi:] Um besondere Änderungen in der vSphere-Umgebung zu tätigen, welche nicht von den anderen Tools unterstützt werden.
]
Um den gesamten Ablauf zu automatisieren, werden Bash-Skripts eingesetzt, welche das leichte Zusammenspiel der Software ermöglichen. So kann Terraform Packer aufrufen, um die Template-#htl3r.shortpl[vm] zu erzeugen, oder auch Ansible, um die #htl3r.shortpl[vm] zu konfigurieren.

=== Packer
Packer, ein Produkt von HashiCorp, ermöglicht es, System-Images oder auch Container aus Code zu erzeugen. Dies ist nützlich, um Template-#htl3r.shortpl[vm] in einer vSphere-Umgebung zu erstellen. Damit dies jedoch möglich ist, braucht es das passende Packer-Plugin, dies ist in diesem Fall ```hcl "github.com/hashicorp/vsphere"```. Dieses Plugin kann wie folgt eingebunden werden:
#htl3r.code(caption: "Packer vSphere-Plugin Einbindung", description: none)[
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

Somit kann auf die ```hcl "vsphere-iso"``` Packer-Source zugegriffen werden. Dies ermöglicht es nun, eine #htl3r.shorts[vm] in der vSphere-Umgebung zu provisionieren:
#htl3r.code_file(
  caption: "Packer vSphere-VM Beispiel",
  filename: [golden_linux_server/main.pkr.hcl],
  lang: "hcl",
  ranges: ((10, 19), (80, 80),),
  skips: ((19,0),),
  text: read("../assets/scripts/golden_linux_server.pkr.hcl")
)

Durch das ```hcl convert_to_template = true``` im vorherigen Beispiel wird die #htl3r.shorts[vm] automatisch nach Abschluss des Provisioniervorganges zu einer Template-#htl3r.shorts[vm] umgewandelt und kann dadurch direkt geklont werden.
#pagebreak()
Insgesamt werden 4 Template-#htl3r.shortpl[vm] provisioniert, allerdings werden nur 3 davon in der Topologie, wie sie im physischen Netzplan sind, verwendet. Das extra Template ist eine Bastion. Die Verwendung dieser wird im @prov-mit-bastion beschrieben. Die restlichen drei Templates sind folgende:
#[
#set par(hanging-indent: 12pt)
- #strong[Linux Golden Image:] Template für alle Linux-Server in der Topologie. Hierbei wird Ubuntu-Server 24.04 verwendet.
- #strong[Windows Server Golden Image:] Template für alle Windows-Server in der Topologie. Hierbei wird Windows-Server 2022 verwendet.
- #strong[Windows Desktop Golden Image:] Template für alle Windows-Clients in der Topologie. Hierbei wird Windows 11 23H2 verwendet.
]
Das Linux-Server-Image wird mittels Cloud-Init, einer #emph["industry standard multi-distribution method for cross-platform cloud instance initialisation."] @ci-docs, aufgesetzt. Cloud-Init liest eine gegebene #htl3r.shorts[yaml] Datei, im passenden Format, aus und konfiguriert damit den Server. Die Windows-Images werden ähnlich aufgesetzt, jedoch wird eine ```autounatend.xml``` Datei verwendet. Das Prinzip bleibt jedoch dasselbe.

=== Terraform
Terraform, ebenfalls ein Produkt von HashiCorp, ermöglicht es, die gesamte IT-Infrastruktur als Code darzustellen, dies beinhaltet #htl3r.shortpl[vm], #htl3r.shortpl[dvs], #htl3r.shortpl[dpg], etc. Allerdings existieren gewisse Limitationen, da Terraform einen konvergenten Zustand gewährleisten muss. Damit dies jederzeit der Fall ist, ist es nicht möglich, zu jeder Zeit beliebig auf die definierten Ressourcen zuzugreifen. Jedoch kann man gewisse "Create" und "Destroy" Provisioner definieren. So kann man Terraform mit anderen Tools integrieren. Packer kann zum Beispiel beim Erstellen einer DPG aufgerufen werden und eine Template-VM erzeugen. So ähnlich wurde dies auch umgesetzt:
#htl3r.code_file(
  caption: "Terraform Bastion Provisionierung",
  filename: [stage_00/main.tf],
  lang: "tf",
  ranges: ((58, 63), (76, 80), (109, 113)),
  skips: ((63,0), (80, 0),),
  text: read("../assets/scripts/stage_00.tf")
)

Dieser erzwungene konvergente Zustand hat jedoch, vor allem während der Entwicklung, Nachteile. Tritt ein Fehler während der Durchführung eines Erstellungsprozesses auf, so stoppt dies den Prozess und Terraform zerstört alle bereits angelegten Ressourcen. Dies führt vor allem dann zu Frustration, wenn so ein Provisionierungsvorgang mehr als 30 Minuten andauert. Um dies zu umgehen, wird in sogenannten "Stages" Provisioniert. Jede Stage ist abhängig von der Vorherigen, somit muss beispielsweise Stage 0 korrekt ausgeführt werden, damit Stage 1, in weiterer Folge, ausgeführt werden kann. Jede Stage ist dafür verantwortlich zu beginnen einen Snapshot von allen Ressourcen zu machen, die für die Durchführung der Stage benötigt werden. So kann, falls die Stage fehlerhaft ausführt, zu dem vorherigen Stand zurückgesprungen werden.

Solch ein Verfahren ist jedoch nicht allein mit Terraform möglich, da Terraform, falls ein Fehler auftritt, den erstellten Snapshot nur löscht und nicht auf diesen zurücksetzt. Somit werden alle fehlerhafte Änderungen, welche von Skript-Provisionieren durchgeführt wurden, auf den vorherigen Stand übertragen. Damit solch eine Situation nicht auftritt, werden Destroy-Provisioner auf den Snapshots konfiguriert:
#htl3r.code_file(
  caption: "Terraform Snapshot Destroy-Provisioner",
  filename: [stage_03/main.tf],
  lang: "tf",
  ranges: ((0, 6), (12, 16),),
  skips: ((6, 0),),
  text: read("../assets/scripts/stage_03.tf")
)
#pagebreak()
Die von der Ressource gebrauchte ``` vm_uuids``` Variable ist in einer anderen Datei enthalten:
#htl3r.code_file(
  caption: "Terraform Snapshot Destroy-Provisioner VMs",
  filename: [stage_03/vms.tf],
  lang: "tf",
  text: read("../assets/scripts/stage_03_vms.tf")
)
Terraform fragt mithilfe des Skriptes die #htl3r.shortpl[uuid] der ADDCs ab und befüllt mit ihnen die lokale Variable ``` vm_uuids```.

Um all dies zu ermöglichen, braucht Terraform den passenden Provider. Ein Terraform-Provider gibt an, wie mit einem gegebenen System zu interagieren ist. Durch einen Provider werden Ressourcen definiert welche angelegt werden können und ebenso welche Daten abgefragt werden können. Um den Provider einzubinden, ist dieser zuerst zu definieren:
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
Nachdem der Provider in einer Datei definiert ist, wird er automatisch, mit dem Befehl ```bash terraform init```, aus dem Terraform-Repository heruntergeladen. Nun müssen die Zugangsdaten von der vSphere-Instanz an Terraform übermittelt werden:
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
Ansible ist das dritte verwendete #htl3r.shorts[iac] Tool, welches verwendet wird. Es ermöglicht es, Maschinen mittels Ansible-Playbooks zu konfigurieren. Diese Playbooks beinhalten mehrere Tasks, welche ausgeführt werden. Diese Tasks können sehr komplex, jedoch auch sehr simpel sein. Ansible wird in der Topologie hauptsächlich für das Ausführen von Bash- und PowerShell-Skripten verwendet. Da oftmals ein Neustart nach der Ausführung eines Befehls notwendig ist. Dies ist vor allem auf Windows-Servern ein bekanntes Problem. Terraform kann mit solchen Neustarts nicht umgehen, Ansible jedoch schon.

Die IPv4-Adressen der VMs im Managementnetzwerk sind oft unklar, denn sie werden über #htl3r.shorts[dhcp] bezogen. Demnach wird die IPv4-Adresse mittels Terraform ausgelesen und als Argument einem Bash-Skript weiter gegeben. Dieses Bash-Skript erstellt nun ein Ansible-Inventory und führt das dazugehörige Ansible-Playbook aus. Die genaue Funktion des Managementnetzwerks ist in @prov-mit-bastion beschrieben. Der Ablauf von einem Ansible-Aufruf sieht wie folgt aus:
#htl3r.code_file(
  caption: "Terraform Ansible Provisioning",
  filename: [stage_03/main.tf],
  range: (29, 43),
  lang: "tf",
  text: read("../assets/scripts/stage_03.tf")
)
#htl3r.code_file(
  caption: "Ansible Execute Script",
  filename: [ansible/execute_stage_03.sh],
  range: (6, 21),
  lang: "bash",
  text: read("../assets/scripts/stage_03_execute_script.sh")
)
#pagebreak()
#htl3r.code_file(
  caption: "Stage-03 Ansible-Playbook",
  filename: [ansible/playbooks/stages/stage_03/setup_dc_primary.yml],
  range: (0, 12),
  skips: ((12, 0),),
  lang: "yml",
  text: read("../assets/scripts/setup_dc_primary.yml")
)
Der Grund, warum die ``` ansible_ssh_common_args``` Variable solch einen komplexen Inhalt hat, wird in @prov-mit-bastion beschrieben.

=== pyVmomi
Obwohl Packer, Terraform und Ansible ein sehr breites Spektrum abdecken, gibt es dennoch Limitationen. Um diese Limitationen zu umgehen, wird direkt auf die VMware-vSphere #htl3r.shorts[api] zurückgegriffen. Hierzu wird pyVmomi, die offizielle Python-Bibliothek für vSphere, verwendet. Mit pyVmomi ist es möglich, mit jeglicher Art von vSphere-Objekt zu interagieren. Es ist ebenfalls möglich, Parameter zu setzen, welche im Web-#htl3r.shorts[gui] von vSphere nicht sichtbar sind. Der Anwendungszweck, welcher vom größten Interesse ist, ist das Setzen von Traffic-Filter Regeln auf #htl3r.shortpl[dpg]. Dies ist in keinem der vorher genannten Tools direkt möglich, allerdings ist es zwingend nötig, um das geplante Security-Konzept umzusetzen. Es soll kein Traffic zwischen Managed-VMs möglich sein, jedoch sollte sie trotzdem die Möglichkeit haben mit der Bastion zu kommunizieren und #htl3r.shorts[dhcp]-Requests zu verschicken. Hierzu werden folgende Traffic-Filter-Regeln verwendet:
#htl3r.fspace(
  figure(
    image("../assets/filtering_rules.jpg"),
    caption: [Management Traffic-Filtering Regeln]
  )
)
Um nun diese Regeln zu definieren, muss sich zunächst bei vSphere authentifiziert werden:
#htl3r.code_file(
  caption: "pyVmomi Authentifizierung",
  filename: [ansible/custom/create_filtering_rules.py],
  range: (152, 161),
  lang: "py",
  text: read("../assets/scripts/create_filtering_rules.py")
)
In weiterer Folge wird das Datacenter sowie die #htl3r.shorts[dpg] abgefragt:
#htl3r.code_file(
  caption: "pyVmomi Ressourcen Abfrage",
  filename: [ansible/custom/create_filtering_rules.py],
  ranges: ((163, 164), (171, 172)),
  skips: ((164, 0),),
  lang: "py",
  text: read("../assets/scripts/create_filtering_rules.py")
)
#pagebreak()
Um nun die #htl3r.shorts[dpg] zu bearbeiten, wird ein ```ConfigSpec``` Objekt gebraucht. Dieses Objekt beinhaltet alle Änderungen, die vorgenommen werden sollen. In diesem Fall sind diese Änderungen in 2 Gruppen zu unterteilen:
+ Alle eingetragenen Traffic-Filter Regeln löschen.
+ Die gebrauchten Traffic-Filter Regeln hinzufügen.
Der erste Schritt ist notwendig, damit das Skript bei mehreren Aufrufen dasselbe Resultat erzielt.

Dies sieht in der Umsetzung wie folgt aus:
#htl3r.code_file(
  caption: "pyVmomi Traffic-Filter Regel Bearbeitung",
  filename: [ansible/custom/create_filtering_rules.py],
  ranges: ((178, 191),),
  lang: "py",
  text: read("../assets/scripts/create_filtering_rules.py")
)
Man beachte, dass die ``` filterConfig``` Liste anfangs auf das Resultat der ```py create_filter_config()``` Funktion gesetzt wird. In dieser Funktion sind die gewollten Regeln definiert.
Solch eine Regel sieht folgendermaßen aus:
#htl3r.code_file(
  caption: "pyVmomi Traffic-Filter Regel Erstellung",
  filename: [ansible/custom/create_filtering_rules.py],
  ranges: ((58, 81), (131, 145),),
  skips: ((81, 0),),
  lang: "py",
  text: read("../assets/scripts/create_filtering_rules.py")
)
Die gezeigte Regel erlaubt #htl3r.shorts[dhcp]-Requests von den Managed #htl3r.shortpl[vm] auf die Bastion. Die restlichen Regeln werden verwendet, um nur die Kommunikation mit der Bastion zu erlauben, demnach sind sie relativ simpel gehalten.

== Provisionierung mittels Bastion <prov-mit-bastion>
#lorem(90)
