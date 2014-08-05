#!/bin/bash
#
# Start the services checking they are running. Don't exit but loop sleeping
# so docker doesn't exit.
#

function show_errors () {
    for f in `ls /tmp/bad_start_for*` ; do
        echo -e "\n$f:\n"
        cat $f
    done
}

echo "Starting shinken services."
service shinken start
if [ "$?" -ne 0 ] ; then
    echo -e "Error starting shinken services.\n"
    show_errors
    exit 1
fi

echo "Starting ssh"
service ssh start
if [ "$?" -ne 0 ] ; then
    echo -e "Error starting SSH service."
    exit 1
fi

service shinken check
if [ "$?" -ne 0 ] ; then
    echo -e "Error verifying all shinken services.\n"
    show_errors
    exit 1
fi

# Don't exit or docker will.
echo "Shinken is running."
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon 2>&1 >/dev/null
