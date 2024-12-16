The diploma thesis "Fenrir -- Zum Schutz von OT-Netzwerken" is all about securing OT networks. To achieve (MAYBE: pursue?) this, a network topology is built, which is a realistic depiction of an enterprise network. This network is made up of a virtual IT (Active Directory Office/Server environment) and a physical OT (programmable logic controllers, the respective actors/sensors, SCADA-System, HMIs) area respectively.

IT TODO

The OT area is represented by a model of a waste water treatment plant and its associated devices for surveillance/administration purposes. This plant consists of, among other things, an Archimedean screw, a rake, water tanks, filters, a dam, pumps and much more. These parts are the sensor/actuation targets of multiple PLCs. These are then also used as attack targets, whereas an attack might bring the pumps to a halt or manipulate them to cause water damage.

To ensure network safety, multiple FortiGate firewalls are deployed, which together with strict AD-integrated access control, microsegmentation of the operation cells, ... provide limitation and surveillance of the dataflow inside the network.

For continuos surveillance of the traffic inside the network a Nozomi Guardian is used. This device is more than just an IDS and can detect all devices and their possible security flaws located inside the network using only mirror traffic. It proceeds to then display the gathered information in an easy to understand way for network administrators.

The goal is to not only create a network secure from inside and outside cyberattacks, but to also document the configuration and protection process extensively.