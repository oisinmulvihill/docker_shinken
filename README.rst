docker_shinken
==============

Shinken Monitoring inside docker will its configuration externally mountable.

.. contents::


Introduction
------------

This is currently a work in progress. You need to mount the configuration You
want shinken to use. For example:

sourcecode:: bash

    docker run ... -v /<path to my-config>:/etc/shinken ...

If you don't have any configuration you can create an initial set with the
"initconfig" command (WARNING: will overwrite any present):

sourcecode:: bash

    docker run -i -t -v /home/vagrant/host_home/src/scfg:/etc/shinken oisinmulvihill/shinken /bin/initconfig
    copying initial configuration to /etc/shinken


Build the docker image
----------------------

From the checked out source

sourcecode:: bash

    docker build -t oisinmulvihill/shinken .


Run the image
-------------

Currently I haven't wired together this part but will do tomorrow.

sourcecode:: bash

    docker build -t oisinmulvihill/shinken .

