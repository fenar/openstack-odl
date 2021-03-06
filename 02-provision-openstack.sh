#!/bin/bash
# Author: Fatih E. NAR
# 
set -ex
v4num=`hostname | cut -c 10- -`

NEUTRON_DNS="172.27.$((v4num+3)).254"
NEUTRON_NET_NAME="private_net"
NEUTRON_NET_CIDR="192.168.$((v4num+3)).0/24"
NEUTRON_SUBNET_NAME="private_subnet"
NEUTRON_SUBNET_GW="192.168.$((v4num+3)).1"

NEUTRON_EXT_NET_NAME="ext-net"
NEUTRON_EXT_SUBNET_NAME="ext-subnet"
NEUTRON_EXT_NET_GW="172.27.$((v4num+3)).254"
NEUTRON_EXT_NET_CIDR="172.27.$((v4num+2)).0/23"
NEUTRON_EXT_NET_FLOAT_RANGE_START="172.27.$((v4num+3)).150"
NEUTRON_EXT_NET_FLOAT_RANGE_END="172.27.$((v4num+3)).200"
NEUTRON_EXT_NET_DNS="8.8.8.8"

keystone=$(juju status keystone | grep keystone/0 | awk '{print $5}' )

echo "
#!/bin/bash
export OS_AUTH_URL=http://$keystone:5000/v2.0/
export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_TENANT_NAME=admin
export OS_REGION_NAME=RegionOne
" > nova.rc
source nova.rc

#Configure the default security group to allow ICMP and SSH
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default
openstack security group rule create --proto tcp --dst-port 80 default
openstack security group rule create --proto tcp --dst-port 443 default
openstack security group rule create --proto tcp --dst-port 3389 default
openstack security group rule create --proto tcp --dst-port 8081 default

chmod +x neutron-ext-net
chmod +x neutron-tenant-net

#EXT NET
./neutron-ext-net -g $NEUTRON_EXT_NET_GW -c $NEUTRON_EXT_NET_CIDR  -f $NEUTRON_EXT_NET_FLOAT_RANGE_START:$NEUTRON_EXT_NET_FLOAT_RANGE_END $NEUTRON_EXT_NET_NAME

#PRIVATE NET
./neutron-tenant-net -t admin -r provider-router -N $NEUTRON_DNS private $NEUTRON_NET_CIDR


# Tenant Network
#neutron net-create --shared $NEUTRON_NET_NAME
#neutron subnet-create --gateway $NEUTRON_SUBNET_GW --enable-dhcp --ip-version 4 --name $NEUTRON_SUBNET_NAME $NEUTRON_NET_NAME $NEUTRON_NET_CIDR

#EXT NET
#neutron net-create $NEUTRON_EXT_NET_NAME --router:external=True --shared --provider:physical_network=physnet1 --provider:network_type=flat
#neutron subnet-create --gateway $NEUTRON_EXT_NET_GW --enable-dhcp --ip-version 4 --allocation-pool start=$NEUTRON_EXT_NET_FLOAT_RANGE_START,end=$NEUTRON_EXT_NET_FLOAT_RANGE_END --dns-nameserver $NEUTRON_EXT_NET_DNS --name $NEUTRON_EXT_SUBNET_NAME $NEUTRON_EXT_NET_NAME $NEUTRON_EXT_NET_CIDR

#Provider Router
#neutron router-create ext-router
#neutron router-interface-add ext-router $NEUTRON_SUBNET_NAME
#neutron router-gateway-set ext-router $NEUTRON_EXT_NET_NAME

#Upload a default SSH key
openstack keypair create  --public-key ~/.ssh/id_rsa.pub default

#Remove the m1.tiny as it is too small for Ubuntu.
openstack flavor create m1.small --id auto --ram 1024 --disk 20 --vcpus 2
openstack flavor create m1.medium --id auto --ram 2048 --disk 20 --vcpus 2
openstack flavor create m1.large --id auto --ram 4096 --disk 20 --vcpus 4
openstack flavor create m1.xlarge --id auto --ram 8192 --disk 20 --vcpus 4

#Modify quotas for the tenant to allow large deployments
openstack quota  set --ram 204800 --cores 200 --instances 100 admin
neutron quota-update --security-group 100 --security-group-rule 500 

#Glance image uploads
glance image-create --name=Cirros-QCOW --visibility=public --container-format=ovf --disk-format=qcow2 <  /srv/data/cirros-0.3.5-x86_64-disk.img
#glance image-create --name=Trusty-QCOW --visibility=public --container-format=ovf --disk-format=qcow2 <  /srv/data/trusty-server-cloudimg-amd64-disk1.img
#glance image-create --name=Xenial-QCOW --visibility=public --container-format=ovf --disk-format=qcow2 <  /srv/data/xenial-server-cloudimg-amd64-disk1.img
exit
