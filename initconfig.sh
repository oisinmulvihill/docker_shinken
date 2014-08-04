#!/bin/bash
#
# Copy the skeletal files from the master source checkout.
#
echo "copying initial configuration to /etc/shinken"
cp -r /home/shinken/shinken-master/etc/* /etc/shinken