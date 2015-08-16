#!/bin/bash

while ! curl -s $COUCH_HOST:$COUCH_PORT; do sleep 5 && echo "waiting for couchdb"; done
# Waiting for indexer to be available
while ! curl -s $INDEXER_HOST:$INDEXER_PORT; do sleep 5 && echo "waiting for data indexer" ; done

# Waiting for local controller to be up and running
while ! curl -s 127.0.0.1:9002; do sleep 5 && echo "waiting for controller"; done

(cozy-monitor status || exit 3)
if [ $? = 3 ]; then
    chown -hR cozy /etc/cozy
    chown -R cozy:cozy /usr/local/cozy-indexer
    chown cozy-data-system /etc/cozy/couchdb.login
    chmod 640 /etc/cozy/couchdb.login

    cozy-monitor install data-system
    cozy-monitor install home
    cozy-monitor install proxy
fi
