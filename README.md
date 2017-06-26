ODL = Open DayLight is a fully opensource SDN in consortium with the OPNFV organization.<br>
There are two bundles included in this project folder: <br>
(1) odl-mitaka.yaml, this bundle is based on openstack mitaka release and ODL Beryllium-SR2 Release. <br>
(2) odl-ocata.yaml, this bundle is based on openstack ocata release and ODL Boron-SR4 Release.<br>

Pre-Condition:
(X) MaaS Node interfaces are named as "eth0" and "eth1"
(Y) Mikrotik Switch Setup Corrected to move 172.27.v4n#+2.0/23 network to vlan1 bridge to allow ingress/egress traffic.

Prep:
(A) Bootstrap Juju Controller
(B) Execute get-cloud-images from openstack demo folder

Bundle is straight forward:
(1) Execute 01-deploy.sh script that Builds ODL Model and Deploys the Bundle.
->Once All Juju Nodes reach Active and Ready
(2) Execute 02-orange-box-confugure-openstack to provision Openstack IaaS.
(3) Setup ODL Web GUI:
  (a) juju ssh odl-controller/0
  (b) cd /opt/distribution-karaf-*/bin
  (c) ./client -u karaf feature:install odl-dlux-all
  (d) go to http://<odl-controller-ipaddr>:8181/index.html admin/admin

You are Good to Go to Demo VM Launch and Access over Floating IP, SSH to it etc and see on ODL Gui How the Flows are Provisoned!

(4) Execute 99-reset-model script to destroy ODL Model.
