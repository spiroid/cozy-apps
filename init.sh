#!/bin/bash
while ! curl -s $COUCH_HOST:$COUCH_PORT; do sleep 2 && echo "waiting for couchdb"; done

# Waiting for local controller to be up and running
while ! curl -s 127.0.0.1:9002; do sleep 2 && echo "waiting for controller"; done

(cozy-monitor status || exit 3)
if [ $? = 3 ]; then
    cozy-monitor install data-system
    cozy-monitor install home
    cozy-monitor install proxy
fi
