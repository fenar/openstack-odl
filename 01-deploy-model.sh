#!/bin/bash

model=`juju list-models |awk '{print $1}'|grep odl`

if [[ ${model:0:3} == "odl" ]]; then
	    echo "ODL model exists and reusing it !"
 	    juju switch odl
     	juju deploy odl-mitaka.yaml
else
     	echo "ODL model does NOT exist and creating it!"
     	juju add-model odl
     	juju switch odl
     	juju deploy odl-mitaka.yaml
fi
