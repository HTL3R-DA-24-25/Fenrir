#import "@preview/htl3r-da:0.1.0" as htl3r

#htl3r.author("Julian Burger")
= Provisionierung und IaC

In der Industrie gibt es einen stetigen Trend, alles zu automatisieren. Eine Automatisierung der #htl3r.short[it]-Infrastruktur bringt Zeit- und Ressourcenersparnisse. Diese Ersparnisse gilt es nicht zu vernachlässigen, demnach ist es das Ziel der Diplomarbeit, das gesamte #htl3r.short[it]-Netzwerk automatisch zu provisionieren und somit zukunftssicher zu gestalten.

Automatische Provisionierung bedeutet, die gesamte oder auch nur Teile einer Firmen/Organisations-#htl3r.short[it]-Infrastruktur, sei es in physischer oder virtueller Form, ohne Eingriff von Personal aufzusetzen. Um solch einen Prozess zu realisieren, wird meist eine Form von #htl3r.short[iac] (= Infrastructure as Code) verwendet. Somit kann das Firmen/Organisations-Netzwerk und dessen #htl3r.short[it]-Infrastruktur als strukturierte Datei oder auch als Code dargestellt werden.

Sollten somit Änderungen der bestehenden #htl3r.short[it]-Infrastruktur notwendig sein, wird der #htl3r.short[iac] Quelltext abgeändert und so angepasst, dass er den neuen Anforderungen gerecht wird. Nun kann das verwendete Tool die Änderungen einlesen und generieren, welche Änderungen bzw. welche Schritte eingeleitet werden müssen, um die Anforderungen, die definiert worden sind, zu erfüllen. Diese Arbeitsschritte können jetzt ausgeführt werden, um den Änderungen gerecht zu werden.

== Verwendete Tools
Um die Anforderungen der Topologie umzusetzen, kommen mehrere Provisionierungs-Tools zum Einsatz:
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

Somit kann auf die ```hcl "vsphere-iso"``` Packer-Source zugegriffen werden. Dies ermöglicht es nun, eine #htl3r.short[vm] in der vSphere-Umgebung zu provisionieren:
#htl3r.code-file(
  caption: "Packer vSphere-VM Beispiel",
  filename: [golden_linux_server/main.pkr.hcl],
  lang: "hcl",
  ranges: ((10, 19), (80, 80),),
  skips: ((19,0),),
  text: read("../assets/scripts/golden_linux_server.pkr.hcl")
)

Durch das ```hcl convert_to_template = true``` im vorherigen Beispiel wird die #htl3r.short[vm] automatisch nach Abschluss des Provisioniervorganges zu einer Template-#htl3r.short[vm] umgewandelt und kann dadurch direkt geklont werden.
#pagebreak()
Insgesamt werden vier Template-#htl3r.shortpl[vm] provisioniert, allerdings werden nur drei davon in der Topologie, wie sie im physischen Netzplan sind, verwendet. Das extra Template ist eine Bastion. Die Verwendung dieser wird im @prov-mit-bastion beschrieben. Die restlichen drei Templates sind folgende:
#[
#set par(hanging-indent: 12pt)
- #strong[Linux Golden Image:] Template für alle Linux-Server in der Topologie. Hierbei wird Ubuntu-Server 24.04 verwendet.
- #strong[Windows Server Golden Image:] Template für alle Windows-Server in der Topologie. Hierbei wird Windows-Server 2022 verwendet.
- #strong[Windows Desktop Golden Image:] Template für alle Windows-Clients in der Topologie. Hierbei wird Windows 11 23H2 verwendet.
]
Das Linux-Server-Image wird mittels Cloud-Init, einer plattformübergreifenden Software für das Aufsetzen von Cloudinstanzen, welche sich als Industriestandard etabliert hat @ci-docs[comp], aufgesetzt. Cloud-Init liest eine gegebene #htl3r.short[yaml] Datei, im passenden Format, aus und konfiguriert damit den Server. Die Windows-Images werden ähnlich aufgesetzt, jedoch wird eine ```autounatend.xml``` Datei verwendet. Das Prinzip bleibt jedoch dasselbe.

Das Linux-Server-Image wird mittels Cloud-Init, einer plattformübergreifenden Software für das Aufsetzen von Cloudinstanzen, welche sich als Industriestandard etabliert hat @ci-docs[comp], aufgesetzt. Cloud-Init liest eine gegebene #htl3r.short[yaml] Datei, im passenden Format, aus und konfiguriert damit den Server. Die Windows-Images werden ähnlich aufgesetzt, jedoch wird eine ```autounatend.xml``` Datei verwendet. Das Prinzip bleibt jedoch dasselbe.


=== Terraform <terraform-prov>
Terraform, ebenfalls ein Produkt von HashiCorp, ermöglicht es, die gesamte IT-Infrastruktur als Code darzustellen, dies beinhaltet #htl3r.shortpl[vm], #htl3r.shortpl[dvs], #htl3r.shortpl[dpg], etc. Allerdings existieren gewisse Limitationen, da Terraform einen konvergenten Zustand gewährleisten muss. Damit dies jederzeit der Fall ist, ist es nicht möglich, zu jeder Zeit beliebig auf die definierten Ressourcen zuzugreifen. Jedoch kann man gewisse "Create" und "Destroy" Provisioner definieren. So kann man Terraform mit anderen Tools integrieren. Packer kann zum Beispiel beim Erstellen einer DPG aufgerufen werden und eine Template-VM erzeugen. So ähnlich wurde dies auch umgesetzt:
#htl3r.code-file(
  caption: "Terraform Bastion Provisionierung",
  filename: [stage_00/main.tf],
  lang: "tf",
  ranges: ((58, 63), (76, 80), (109, 113)),
  skips: ((63,0), (80, 0),),
  text: read("../assets/scripts/stage_00.tf")
)

Dieser erzwungene konvergente Zustand hat jedoch -- vor allem während der Entwicklung -- Nachteile. Tritt ein Fehler während der Durchführung eines Erstellungsprozesses auf, so stoppt dies den Prozess und Terraform zerstört alle bereits angelegten Ressourcen. Dies stört vor allem dann, wenn ein Provisionierungsvorgang mehr als 30 Minuten andauert. Um dies zu umgehen, wird in sogenannten "Stages" provisioniert. Jede Stage ist abhängig von der Vorherigen, somit muss beispielsweise Stage null korrekt ausgeführt werden, damit Stage eins, in weiterer Folge, ausgeführt werden kann. Jede Stage ist dafür verantwortlich zu Beginn einen Snapshot von allen Ressourcen zu machen, die für die Durchführung der Stage benötigt werden. So kann, falls die Stage fehlerhaft ausführt, zu dem vorherigen Stand zurückgesprungen werden.

Solch ein Verfahren ist nicht allein mit Terraform möglich, da Terraform, falls ein Fehler auftritt, den erstellten Snapshot nur löscht und nicht auf diesen zurücksetzt. Somit werden alle fehlerhafte Änderungen, welche von Skript-Provisionieren durchgeführt wurden, auf den vorherigen Stand übertragen. Damit solch eine Situation nicht auftritt, werden Destroy-Provisioner auf den Snapshots konfiguriert:
#htl3r.code-file(
  caption: "Terraform Snapshot Destroy-Provisioner",
  filename: [stage_03/main.tf],
  lang: "tf",
  ranges: ((0, 6), (12, 16),),
  skips: ((6, 0),),
  text: read("../assets/scripts/stage_03.tf")
)
#pagebreak()
Die von der Ressource gebrauchte ``` vm_uuids``` Variable ist in einer anderen Datei enthalten:
#htl3r.code-file(
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
Ansible ist das dritte #htl3r.short[iac] Tool, welches zur Provisionierung verwendet wird. Es ermöglicht, Maschinen mittels Ansible-Playbooks zu konfigurieren. Diese Playbooks beinhalten mehrere Tasks, welche ausgeführt werden. Diese Tasks können sehr komplex, jedoch auch sehr simpel sein. Ansible wird in der Topologie hauptsächlich für das Ausführen von Bash- und PowerShell-Skripten verwendet, da oftmals ein Neustart nach der Ausführung eines Befehls notwendig ist. Dies ist vor allem auf Windows-Servern ein bekanntes Problem. Terraform kann mit solchen Neustarts nicht umgehen, Ansible jedoch schon.

Die IPv4-Adressen der VMs im Managementnetzwerk sind oft unklar, denn sie werden über #htl3r.short[dhcp] bezogen. Demnach wird die IPv4-Adresse mittels Terraform ausgelesen und als Argument einem Bash-Skript weiter gegeben. Dieses Bash-Skript erstellt nun ein Ansible-Inventory und führt das dazugehörige Ansible-Playbook aus. Die genaue Funktion des Managementnetzwerks ist in @prov-mit-bastion beschrieben. Der Ablauf von einem Ansible-Aufruf sieht wie folgt aus:
#htl3r.code-file(
  caption: "Terraform Ansible Provisioning",
  filename: [stage_03/main.tf],
  range: (29, 43),
  lang: "tf",
  text: read("../assets/scripts/stage_03.tf")
)
#htl3r.code-file(
  caption: "Ansible Execute Script",
  filename: [ansible/execute_stage_03.sh],
  range: (6, 21),
  lang: "bash",
  text: read("../assets/scripts/stage_03_execute_script.sh")
)
#pagebreak()
#htl3r.code-file(
  caption: "Stage-03 Ansible-Playbook",
  filename: [ansible/playbooks/stages/stage_03/setup_dc_primary.yml],
  range: (0, 12),
  skips: ((12, 0),),
  lang: "yml",
  text: read("../assets/scripts/setup_dc_primary.yml")
)
Der Grund, warum die ``` ansible_ssh_common_args``` Variable solch einen komplexen Inhalt hat, wird in @prov-mit-bastion beschrieben.

=== pyVmomi
Obwohl Packer, Terraform und Ansible ein sehr breites Spektrum abdecken, gibt es dennoch Limitationen. Um diese Limitationen zu umgehen, wird direkt auf die VMware-vSphere #htl3r.short[api] zurückgegriffen. Hierzu wird pyVmomi, die offizielle Python-Bibliothek für vSphere, verwendet. Mit pyVmomi ist es möglich, mit jeglicher Art von vSphere-Objekt zu interagieren. Es ist ebenfalls möglich, Parameter zu setzen, welche im Web-#htl3r.short[gui] von vSphere nicht sichtbar sind. Der Anwendungszweck, welcher vom größten Interesse ist, ist das Setzen von Traffic-Filter Regeln auf #htl3r.shortpl[dpg]. Dies ist in keinem der vorher genannten Tools direkt möglich, allerdings ist es zwingend nötig, um das geplante Security-Konzept umzusetzen. Es soll kein Datenverkehr zwischen Managed-#htl3r.shortpl[vm] möglich sein, jedoch sollte sie trotzdem die Möglichkeit haben mit der Bastion zu kommunizieren und #htl3r.short[dhcp]-Requests zu verschicken. Hierzu werden folgende Traffic-Filter-Regeln verwendet:
#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/filtering_rules.jpg"),
    caption: [Management Traffic-Filtering Regeln]
  )
)
#htl3r.todo("Obigen Screenshot mit whitemode erneut machen")

Um nun diese Regeln zu definieren, muss zunächst eine Authentifizierung in vSphere stattfinden:
#htl3r.code-file(
  caption: "pyVmomi Authentifizierung",
  filename: [ansible/custom/create_filtering_rules.py],
  range: (152, 161),
  lang: "py",
  text: read("../assets/scripts/create_filtering_rules.py")
)

In weiterer Folge werden das Datacenter sowie die #htl3r.short[dpg] abgefragt:
#htl3r.code-file(
  caption: "pyVmomi Ressourcen Abfrage",
  filename: [ansible/custom/create_filtering_rules.py],
  ranges: ((163, 164), (171, 172)),
  skips: ((164, 0),),
  lang: "py",
  text: read("../assets/scripts/create_filtering_rules.py")
)
Um nun die #htl3r.short[dpg] zu bearbeiten, wird ein ```ConfigSpec``` Objekt gebraucht. Dieses Objekt beinhaltet alle Änderungen, die vorgenommen werden sollen. In diesem Fall sind diese Änderungen in zwei Gruppen zu unterteilen:

+ Alle eingetragenen Traffic-Filter Regeln löschen.
+ Die gebrauchten Traffic-Filter Regeln hinzufügen.

Der erste Schritt ist notwendig, damit das Skript bei mehreren Aufrufen dasselbe Resultat erzielt.

Dies sieht in der Umsetzung wie folgt aus:
#htl3r.code-file(
  caption: "pyVmomi Traffic-Filter Regel Bearbeitung",
  filename: [ansible/custom/create_filtering_rules.py],
  ranges: ((178, 191),),
  lang: "py",
  text: read("../assets/scripts/create_filtering_rules.py")
)
Man beachte, dass die ``` filterConfig``` Liste anfangs auf das Resultat der ```py create_filter_config()``` Funktion gesetzt wird. In dieser Funktion sind die gewollten Regeln definiert.
Solch eine Regel sieht folgendermaßen aus:
#htl3r.code-file(
  caption: "pyVmomi Traffic-Filter Regel Erstellung",
  filename: [ansible/custom/create_filtering_rules.py],
  ranges: ((58, 81), (131, 145),),
  skips: ((81, 0),),
  lang: "py",
  text: read("../assets/scripts/create_filtering_rules.py")
)
Die gezeigte Regel erlaubt #htl3r.short[dhcp]-Requests von den Managed #htl3r.shortpl[vm] auf die Bastion. Die restlichen Regeln werden verwendet, um nur die Kommunikation mit der Bastion zu erlauben, demnach sind sie relativ simpel gehalten.

== Provisionierung mittels Bastion <prov-mit-bastion>
Bei der Provisionierung eines großen Netzwerkes kann es zu verschiedensten Problemen kommen. Ein großes Problem welches sich häufiger entpuppt ist Trust. Um diverse Dienste und Programme zu Konfigurieren braucht es einen Remote-Shell zugriff in beliebigen Form. Da im Rahmen dieser Diplomarbeit vor allem auf Packer, Terraform und Ansible gesetzt wird, macht es sinn #htl3r.short[ssh] für diesen Zweck einzusetzen, da jedes dieser Tools dies unterstützt.

#htl3r.short[ssh] erfordert eine authentifizierung, demnach ist es wichtig Passwörter oder auch Schlüsselpaare bei der Provisionierung, sowie im laufenden Betrieb, zu verwalten. Um diesen Prozess zu erleichtern gibt es eine zentrale Quelle des Vertrauens. Dies wird in Form einer besonderen #htl3r.short[vm] erzielt. Diese #htl3r.short[vm] besitzt einen besonderen Schlüssel, welcher ihr den Zugriff auf alle anderen #htl3r.shortpl[vm] gewährt. Diese #htl3r.short[vm] wird Bastion genannt, denn diese #htl3r.short[vm] darf unter keinen Umständen kompromentiert werden. Schafft es ein Angreifer die Bastion einzunehmen, so bekommt er Zugriff auf das gesamte Netzwerk, da jede #htl3r.short[vm] dem Schlüssel der Bastion vertraut. Um Angriffe auf die Bastion zu vermeiden wird diese in kein produktiv Netzwerk eingebunden und Internetzugriff wird untersagt. Es ist lediglich möglich über das Management-Netzwerk auf die Bastion zuzugreifen, da eine Schnittstelle für die #htl3r.short[iac]-Tools gebraucht wird. Der Zugriff in das Management-Netzwerk ist jedoch nur über einen #htl3r.short[vpn] möglich.

=== Ablauf der Provisionierung
Wie in @terraform-prov bereits erklärt worden ist, wird in Stages provisioniert. Die Bastion wird hierbei innerhalb von Stage Null aufgesetzt. Damit der erstamlige #htl3r.short[ssh]-Zugriff auf die Bastion gelingt wird ein vordefinierten Passwort verwendet. Dieser Zugriff ist nötig um das Schlüsselpaar auf die Bastion zu kopieren.

In weitere folge, ebenfalls in Stage Null, werden die Template-#htl3r.shortpl[vm] für alle anderen #htl3r.shortpl[vm], welche für das Produktivnetzwerk gebraucht werden, erstellt. Um den öffentlichen Schlüssel der Bastion auf die Template-#htl3r.shortpl[vm] zu kopieren wird unter Windows von einem Answer-File gebrauch gemacht und unter Linux, in diesem Fall Ubuntu-Server, von cloud-init. Packer ermöglicht es beim Provisioniervorgang temporäre virtuelle Floppy-Disks zu erstellen, welche die nötigen Dateien für den automatisierten Setup-Prozess und den öffentlichen Schlüssel der Bastion beinhalten. Die erstellten Template-#htl3r.shortpl[vm] können nun gekloned werden und über das Bastion-Management-Netzwerk weiter konfiguriert werden.
#pagebreak(weak: true)
Abstrakt betrachtet sieht dieser Provisionierungsvorgang wie folgt aus:
#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/prov_mit_bastion.png"),
    caption: [Abstrakte Provisionierung mittels Bastion]
  )
)

=== SSH Agent
Nun stellt sich vielleicht die Frage, wie die #htl3r.short[iac]-Tools über die Bastion eine Verbindung zu den #htl3r.shortpl[vm] aufbauen können und sich mit dem Schlüssel der Bastion authentifizieren können. Hierzu wird ein #htl3r.short[ssh]-Agent, oft auch #htl3r.short[ssh]-Forwarder genannt, benutzt. Wie der Name schon sagt, agiert hierbei die Bastion, mit ihrem Schlüssel, für die #htl3r.short[iac]-Tools. Im Idealfall kommen bei dem Verbindungsaufbau zur Bastion ebenfalls Schlüssel zum einsatz, im Rahmen dieser Diplomarbeit wurde jedoch auf eine Authentifizierung mittels Passwort gesetzt, da dies leichter zum verwalten ist. Das Passwort kann in einer Environment-Datei (`.env`) abgespeichert werden und mittels `.gitignore` aus dem Git-Repository excludiert werden.

Abstrakt betracht kann der Zugriff, welcher von den #htl3r.short[iac]-Tools durchführen, folgender maßen visualisiert werden:
#htl3r.fspace(
  total-width: 100%,
  figure(
    image("../assets/bastion_workflow.png"),
    caption: [Abstrakte SSH-Agent übersicht]
  )
)

==== Terraform und Packer
Terraform und Packer unterstützen die Nutzung eines #htl3r.short[ssh]-Agents Nativ, somit ist es lediglich nötig die passenden Konfigurationszeilen hinzuzufügen. Dies ist, wie später beschrieben wird, nicht bei jedem Tool der Fall.

Die Konfigurationsoptionen in Packer sind selbsterklärend benannt und verständlich. Veranschaulichen lässt sich dies gut an der Packer-Konfiguration des Golden Linux Images:
#htl3r.code-file(
  caption: "Packer verwendung von einer Bastion",
  filename: [packer/images/golde_linux_server/main.pkr.hcl],
  skips: ((0,9),(1, 62),),
  lang: "hcl",
  text: read("../assets/scripts/packer-ssh-example.pkr.hcl")
)

Ähnlich simpel ist es auch in Terraform. Zu sehen ist ein ausschnitt aus der zweiten Stage, in dieser Stage wird das Scada aufgesetzt:
#htl3r.code-file(
  caption: "Terraform verwendung von einer Bastion",
  filename: [terraform/stage_02/main.tf],
  skips: ((30, 0),(32,0), (42, 0), (45, 0)),
  ranges: ((30, 30), (32, 32), (34, 41), (45, 45), (59, 59)),
  lang: "hcl",
  text: read("../assets/scripts/stage02-main.tf")
)
Die nicht gezeigten Abschnitte werden ausgeblendet um für bessere Lesbarkeit zu sorgen. Es ist somit sehr gut erkennbar wie sich die Konfiguration zu der selbigen in Packer ähnelt.
==== Ansible
#htl3r.todo[Beschreiben warum Ansible SSH-Proxies über SSH-Agents bevorzugt, sowie auch auf die Unterschiede eingehen. Aufregen warum das ein schaß ist.]
