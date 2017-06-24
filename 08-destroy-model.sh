#!/bin/bash
# Author: Fatih E. Nar (fenar)
# Destroy ODL Model
#
model=`juju list-models |awk '{print $1}'|grep odl`

if [[ ${model:0:3} == "odl" ]]; then
     echo "Model:ODL Found -> Destroy in Progress!"
     juju destroy-model "odl" -y
else
     echo "Model:ODL NOT Found!"
fi
