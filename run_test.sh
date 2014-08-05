#!/bin/bash

sudo docker run -i -t \
    -p 10022:22 \
    -p 7767:7767 \
    -p 7768:7768 \
    -p 7769:7769 \
    -p 7770:7770 \
    -p 7771:7771 \
    -p 7772:7772 \
    -p 7773:7773 \
    -v /home/vagrant/host_home/tmp:/data \
    -v /home/vagrant/host_home/tmp:/logs \
    -v /home/vagrant/host_home/src/docker_shinken/test_etc:/etc/shinken \
    oisinmulvihill/shinken /bin/start
