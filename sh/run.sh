#!/bin/bash
while ! curl -s $COUCH_HOST:$COUCH_PORT; do sleep 5; done
while ! curl -s $INDEXER_HOST:$INDEXER_PORT; do sleep 5; done

(/usr/cozy/cozy-monitor/bin/cozy-monitor status || exit 3)
if [ $? = 3 ]; then
    /usr/local/bin/supervisord -c /etc/supervisord.conf
    while ! curl -s 127.0.0.1:9002; do sleep 5; done

    chown -hR cozy /etc/cozy
    chown -R cozy:cozy /usr/local/cozy-indexer
    chown cozy-data-system /etc/cozy/couchdb.login
    chmod 640 /etc/cozy/couchdb.login

    /usr/cozy/cozy-monitor/bin/cozy-monitor install data-system
    /usr/cozy/cozy-monitor/bin/cozy-monitor install home
    /usr/cozy/cozy-monitor/bin/cozy-monitor install proxy

    # supervisorctl restart cozy-controller
    pkill supervisor
fi
/usr/local/bin/supervisord -n -c /etc/supervisord.conf