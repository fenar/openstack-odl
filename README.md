ODL = OpenDayLight is a fully opensource SDN in collaboration with the OPNFV organization.<br>

There are three bundles included in this project folder: <br>
	(a) odl-mitaka-beryllium.yaml<br>	
	--->This Deployment is Tested with Success!<br>
	(b) odl-newton-boron.yaml<br> 	
	--->This Deployment Succeeds but Floating IP does not work.<br>
	(c) odl-ocata-carbon.yaml<br> 
	--->This Deployment is failing and issue reported to charm-devops team: <br>
	----->https://bugs.launchpad.net/charm-odl-controller/+bug/1700628<br>
	<br>

Bundle is straight forward:<br>
(1) Execute 01-deploy.sh script that Builds ODL Model and Deploys the Bundle.<br>
-> Once All Juju Nodes reach Active and Ready<br>
(2) Execute 02-provision-openstack.sh to provision Openstack IaaS.<br>
(3) Setup ODL Web GUI:<br>
-> juju ssh odl-controller/0<br>
-> cd /opt/opendaylight-karaf/bin<br>
-> ./client -u karaf feature:install odl-dlux-all<br>
-> go to http://<odl-controller-ipaddr>:8181/index.html admin/admin<br>

You are Good to Go to Demo VM Launch and Access over Floating IP, SSH to it etc and see on ODL Gui How the Flows are Provisoned!<br>

(4) Execute 08-destroy-model script to destroy ODL Model.<br>
