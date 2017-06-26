ODL = Open DayLight is a fully opensource SDN in consortium with the OPNFV organization.<br>
There are two bundles included in this project folder: <br>
(1) odl-mitaka.yaml, this bundle is based on openstack mitaka release and ODL Beryllium-SR2 Release. <br>
(2) odl-ocata.yaml, this bundle is based on openstack ocata release and ODL Boron-SR4 Release.<br>

Pre-Condition:<br>
(X) MaaS Node interfaces are named as "eth0" and "eth1"<br>
(Y) Mikrotik Switch Setup Corrected to move 172.27.v4n#+2.0/23 network to vlan1 bridge to allow ingress/egress traffic.<br>

Prep:<br>
(A) Bootstrap Juju Controller<br>
(B) Execute get-cloud-images from openstack demo folder<br>

Bundle is straight forward:<br>
(1) Execute 01-deploy.sh script that Builds ODL Model and Deploys the Bundle.<br>
->Once All Juju Nodes reach Active and Ready<br>
(2) Execute 02-orange-box-confugure-openstack to provision Openstack IaaS.<br>
(3) Setup ODL Web GUI:<br>
  (a) juju ssh odl-controller/0<br>
  (b) cd /opt/distribution-karaf-*/bin<br>
  (c) ./client -u karaf feature:install odl-dlux-all<br>
  (d) go to http://<odl-controller-ipaddr>:8181/index.html admin/admin<br>

You are Good to Go to Demo VM Launch and Access over Floating IP, SSH to it etc and see on ODL Gui How the Flows are Provisoned!<br>

(4) Execute 99-reset-model script to destroy ODL Model.<br>
