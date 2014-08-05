FROM ubuntu:trusty

MAINTAINER Oisin Mulvihill <oisin.mulvihill@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install -y python-software-properties
RUN apt-get install -y git
RUN apt-get install -y python-pip
RUN apt-get install -y python-pycurl
RUN apt-get install -y python-paramiko
RUN apt-get install -y python-setuptools
RUN apt-get install -y curl
RUN apt-get install -y supervisor
RUN apt-get install -y nagios-plugins
RUN apt-get install -y openssh-server

RUN apt-get update

# This will be mounted so can host different set ups:
RUN mkdir /etc/shinken
RUN mkdir /data
RUN mkdir /logs

# Set up the shinken user
RUN groupadd shinken

RUN useradd -g shinken -g sudo -s /bin/bash -m -d /home/shinken shinken
# shinken is the password for shinken user to aid debugging issues over ssh.
RUN usermod -p $(mkpasswd -H md5 shinken) shinken

RUN chown -R shinken: /etc/shinken

# Get the latest Shinken:
RUN git clone https://github.com/naparuba/shinken.git /home/shinken/shinken-master

RUN chown -R shinken: /etc/shinken
RUN su -c 'cd /home/shinken/shinken-master && python setup.py install'
# Generate ssh keys
RUN su - shinken -c 'ssh-keygen -q -f /home/shinken/.ssh/id_rsa -N ""'
RUN su - shinken -c '/usr/bin/shinken --init'
RUN su - shinken -c '/usr/bin/shinken install webui'
RUN su - shinken -c '/usr/bin/shinken install linux-ssh'
RUN su - shinken -c '/usr/bin/shinken install sqlitedb'
RUN su - shinken -c '/usr/bin/shinken install auth-cfg-password'

# Scripts to aid usage and management:
ADD initconfig.sh /bin/initconfig
ADD start.sh /bin/start

# Allow a hosts/localhost.cfg to use linux-ssh and auto login to get the
# system parameters.
RUN cat /home/shinken/.ssh/id_rsa.pub > /home/shinken/.ssh/authorized_keys
RUN chmod 600 /home/shinken/.ssh/authorized_keys
RUN chown shinken:shinken /home/shinken/.ssh/authorized_keys

# run permissions for user `shinken`
RUN chmod u+s /usr/lib/nagios/plugins/check_icmp
RUN chmod u+s /bin/ping
RUN chmod u+s /bin/ping6

VOLUME ["/etc/shinken"]
VOLUME ["/logs"]
VOLUME ["/data"]

# webui:
EXPOSE 7767
EXPOSE 7768
# reactionerd:
EXPOSE 7769
# arbiter:
EXPOSE 7770
EXPOSE 7771
# broker:
EXPOSE 7772
# receiverd:
EXPOSE 7773


# Run shinken as the default. The /etc/shiken will need to be present and
# error free. If the services don't start this will exit.
CMD ["/bin/start"]
