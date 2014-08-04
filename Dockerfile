FROM ubuntu:trusty

MAINTAINER Oisin Mulvihill <oisin.mulvihill@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install -y python-software-properties
RUN apt-get install -y git
RUN apt-get install -y python-pip
RUN apt-get install -y curl
RUN apt-get install -y nagios-plugins
RUN apt-get install -y openssh-server
RUN apt-get install -y supervisor

RUN apt-get update

# This will be mounted so can host different set ups:
RUN mkdir /etc/shinken

# Set up the shinken user
RUN groupadd shinken
RUN useradd -g shinken -s /bin/bash -m -d /home/shinken shinken

RUN chown -R shinken: /etc/shinken

# Get the latest Shinken:
RUN git clone https://github.com/naparuba/shinken.git /home/shinken/shinken-master

RUN chown -R shinken: /etc/shinken
RUN su -c 'cd /home/shinken/shinken-master && python setup.py install'

RUN su - shinken -c '/usr/bin/shinken --init'
RUN su - shinken -c '/usr/bin/shinken install webui'
RUN su - shinken -c '/usr/bin/shinken install sqlitedb'

ADD initconfig.sh /bin/initconfig

# run permissions for user `shinken`
RUN chmod u+s /usr/lib/nagios/plugins/check_icmp
RUN chmod u+s /bin/ping
RUN chmod u+s /bin/ping6

VOLUME ["/etc/shinken"]



EXPOSE 80
EXPOSE 22

CMD ["/usr/bin/supervisord"]