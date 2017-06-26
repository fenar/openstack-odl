ODL = OpenDayLight is a fully opensource SDN in collaboration with the OPNFV organization.<br>

There are two bundles included in this project folder: <br>
	(a) odl-mitaka-beryllium.yaml<br>	
	(b) odl-newton-boron.yaml<br> 	
	(c) odl-ocata-carbon.yaml<br>

Pre-Condition:<br>
(X) MaaS Node interfaces are named as "eth0" and "eth1"<br>
(Y) Mikrotik Switch Setup Corrected to move 172.27.[v4n#+2].0/23 network to vlan1 bridge to allow ingress/egress traffic.<br>

Prep:<br>
(A) Bootstrap Juju Controller<br>
(B) Execute get-cloud-images from openstack demo folder<br>

Bundle is straight forward:<br>
(1) Execute 01-deploy.sh script that Builds ODL Model and Deploys the Bundle.<br>
-> Once All Juju Nodes reach Active and Ready<br>
(2) Execute 02-orange-box-confugure-openstack to provision Openstack IaaS.<br>
(3) Setup ODL Web GUI:<br>
-> juju ssh odl-controller/0<br>
-> cd /opt/opendaylight-karaf/bin<br>
-> ./client -u karaf feature:install odl-dlux-all<br>
-> go to http://<odl-controller-ipaddr>:8181/index.html admin/admin<br>

You are Good to Go to Demo VM Launch and Access over Floating IP, SSH to it etc and see on ODL Gui How the Flows are Provisoned!<br>

(4) Execute 99-reset-model script to destroy ODL Model.<br>
