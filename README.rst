docker_shinken
==============

Shinken Monitoring inside docker with its configuration externally mountable.

.. contents::


Introduction
------------

This is currently a work in progress. You need to mount the configuration You
want shinken to use. For example:

code-block:: bash

    sudo docker run ... -v /<path to my-config>:/etc/shinken ...

If you don't have any configuration you can create an initial set with the
"initconfig" command (WARNING: will overwrite any present):

code-block:: bash

    sudo docker run -i -t -v /home/vagrant/host_home/src/scfg:/etc/shinken oisinmulvihill/shinken /bin/initconfig
    copying initial configuration to /etc/shinken


Build the docker image
----------------------

From the checked out source directory a new image can be built as follows:

code-block:: bash

    sudo docker build -t oisinmulvihill/shinken .


Run the image
-------------

I'm currently running manual checks using the following script:

code-block:: bash

    $ ./run_test.sh
    Starting shinken services.
    Starting scheduler:
       ...done.
    Starting poller:
       ...done.
    Starting reactionner:
       ...done.
    Starting broker:
       ...done.
    Starting receiver:
       ...done.
    Starting arbiter:
       ...done.
    Starting ssh
     * Starting OpenBSD Secure Shell server sshd         [ OK ]
    Doing config check
       ...done.
    Shinken is running.

This script does the following in interactive mode. You can use as many of the
following options as you want.

code-block:: bash

    # For an interactive run (you'll need to strip comments to copy-n-paste)
    sudo docker run -i -t \
        # If you want to access to debug problems or have a nose around.
        -p 10022:22 \
        # WEBUI default port
        -p 7767:7767 \
        -p 7768:7768 \
        -p 7769:7769 \
        -p 7770:7770 \
        -p 7771:7771 \
        -p 7772:7772 \
        -p 7773:7773 \
        # where I'll store sqlite database:
        -v /home/vagrant/host_home/tmp:/data \

        # where the configuration specific to my set lives:
        -v /home/vagrant/host_home/src/docker_shinken/test_etc:/etc/shinken \

        # The docker image to use :)
        oisinmulvihill/shinken \

        # Start shinken, sshd and don't exit (can be control-Ced)
        /bin/start

The start will run all of the shinken service parts and check they have
started and stay running. If there are any problems it will exiting printing
the contents of any /tmp/bad_start_for_* files to aid problem diagnosis.


Debug Access
------------

If you are forwarding the ssh port you can gain access to the shinken account
using 'shiken' as the password. The shinken user is set up with sudo access.

For example with the "-p 10022:22" option access can be gained as follows:

code-block:: bash

    $ ssh shinken@localhost -p 10022
    shinken@localhost's password:
    Welcome to Ubuntu 14.04 LTS (GNU/Linux 3.2.0-37-generic x86_64)

     * Documentation:  https://help.ubuntu.com/

    The programs included with the Ubuntu system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
    applicable law.

    shinken@8a150395d755:~$ ls /etc/shinken/
    arbiters  commands       daemons       discovery    hosts             packs         realms      sample      servicegroups  templates
    brokers   contactgroups  dependencies  escalations  modules           pollers       receivers   sample.cfg  services       timeperiods
    certs     contacts       dev.cfg       hostgroups   notificationways  reactionners  resource.d  schedulers  shinken.cfg
    shinken@8a150395d755:~$
    shinken@8a150395d755:~$ sudo ls /
    [sudo] password for shinken:
    bin  boot  data  dev  etc  home  lib  lib64  logs  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
    shinken@8a150395d755:~$


How am I running docker?
------------------------

I'm developing with docker, however I'm running on a Mac. If you don't have a
setup on your Mac to do this, have a look at my other project handy_setups
https://github.com/oisinmulvihill/handy-setups. The "dockerbox" is a VM using
virtualbox, vagrant and saltstack which will allow building and running of
docker images.
