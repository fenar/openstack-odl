#!/bin/bash
set -ex
v4num=`hostname | cut -c 10- -`
NEUTRON_DNS="172.27.$((v4num+3)).254"
NEUTRON_EXT_NET_NAME="ext_net"
NEUTRON_EXT_NET_GW="172.27.$((v4num+3)).254"
NEUTRON_EXT_NET_CIDR="172.27.$((v4num+2)).0/23"
NEUTRON_EXT_NET_FLOAT_RANGE_START="172.27.$((v4num+3)).100"
NEUTRON_EXT_NET_FLOAT_RANGE_END="172.27.$((v4num+3)).140"

NEUTRON_FIXED_NET_CIDR="192.168.$((v4num)).0/24"
NEUTRON_FIXED_NET_NAME="admin_net"

keystone=$(juju status keystone | grep keystone/0 | awk '{print $5}' )

echo "
#!/bin/bash
export OS_AUTH_URL=http://$keystone:5000/v2.0/
export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_TENANT_NAME=admin
export OS_REGION_NAME=RegionOne
" > ~/nova.rc

. ~/nova.rc

# Determine the tenant id for the configured tenant name.
export TENANT_ID=$(keystone tenant-list | grep $OS_TENANT_NAME | awk '{print $2}')

#create ext networks with neutron for floating IPs
EXTERNAL_NETWORK_ID=$(neutron net-create ext_net --shared --provider:physical_network=physnet1 --provider:network_type=flat --router:external=True | grep " id" | awk '{print $4}')
neutron subnet-create ext_net $NEUTRON_EXT_NET_CIDR --name ext_net_subnet \
--allocation-pool start=$NEUTRON_EXT_NET_FLOAT_RANGE_START,end=$NEUTRON_EXT_NET_FLOAT_RANGE_END \
--gateway $NEUTRON_EXT_NET_GW --dns_nameservers $NEUTRON_DNS list=true

#Create private network for neutron for tenant VMs
neutron net-create private
SUBNET_ID=$(neutron subnet-create private $NEUTRON_FIXED_NET_CIDR -- --name private_subnet --dns_nameservers list=true $NEUTRON_DNS | grep " id" | awk '{print $4}')

#Create router for external network and private network
ROUTER_ID=$(neutron router-create --tenant-id $TENANT_ID provider-router | grep " id" | awk '{print $4}')
neutron router-interface-add $ROUTER_ID $SUBNET_ID
neutron router-gateway-set $ROUTER_ID $EXTERNAL_NETWORK_ID

#Configure the default security group to allow ICMP and SSH
nova  secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova  secgroup-add-rule default tcp 22 22 0.0.0.0/0
#for rdp
nova secgroup-add-rule default tcp 3389 3389 0.0.0.0/0

#Upload a default SSH key
nova keypair-add --pub-key ~/.ssh/id_rsa.pub default

#Upload images to glance
glance image-create --name=Xenial-QCOW --visibility=public --container-format=ovf --disk-format=qcow2 <  /srv/data/xenial-server-cloudimg-amd64-disk1.img
glance image-create --name=Cirros-QCOW --visibility=public --container-format=ovf --disk-format=qcow2 <  /srv/data/cirros-0.3.5-x86_64-disk.img
exit
