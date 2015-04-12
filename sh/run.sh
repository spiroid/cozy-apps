#!/bin/bash
while ! curl -s $COUCH_HOST:$COUCH_PORT; do sleep 5; done
while ! curl -s $INDEXER_HOST:$INDEXER_PORT; do sleep 5; done

/usr/local/lib/node_modules/cozy-controller/bin/cozy-controller & sleep 5
while ! curl -s 127.0.0.1:9002; do sleep 5; done

chown -hR cozy /etc/cozy
chown -R cozy:cozy /usr/local/cozy-indexer
chown cozy-data-system /etc/cozy/couchdb.login
chmod 640 /etc/cozy/couchdb.login

/usr/cozy/cozy-monitor/bin/cozy-monitor install data-system
/usr/cozy/cozy-monitor/bin/cozy-monitor install home
/usr/cozy/cozy-monitor/bin/cozy-monitor install proxy

chgrp cozy-data-system /etc/cozy/stack.token
chmod 640 /etc/cozy/stack.token
/usr/cozy/cozy-monitor/bin/cozy-monitor restart-cozy-stack
sleep 5

/usr/local/bin/supervisord -n -c /etc/supervisord.conf