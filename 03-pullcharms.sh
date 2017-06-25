#!/bin/bash/
sudo mkdir /srv/data/charms
cd /srv/data/charms
charm pull cs:$distro/odl-controller $distro/odl-controller
charm pull cs:~narindergupta/neutron-api-odl-11 $distro/neutron-api-odl
charm pull cs:~narindergupta/openvswitch-odl-3 $distro/openvswitch-odl
charm pull cs:~narindergupta/neutron-gateway-6 $distro/neutron-gateway
