#!/bin/bash
export COUCH_HOST=$COUCHDB_PORT_5984_TCP_ADDR
export COUCH_PORT=$COUCHDB_PORT_5984_TCP_PORT
export INDEXER_HOST=$DATAINDEXER_PORT_9102_TCP_ADDR
export INDEXER_PORT=$DATAINDEXER_PORT_9102_TCP_PORT

while ! curl -s $COUCHDB_PORT_5984_TCP_ADDR:$COUCHDB_PORT_5984_TCP_PORT; do sleep 5; done
while ! curl -s $DATAINDEXER_PORT_9102_TCP_ADDR:$DATAINDEXER_PORT_9102_TCP_PORT; do sleep 5; done

/usr/local/lib/node_modules/cozy-controller/bin/cozy-controller & sleep 5
while ! curl -s 127.0.0.1:9002; do sleep 5; done
/usr/cozy/cozy-monitor/bin/cozy-monitor install data-system --repo https://github.com/obigroup/cozy-data-system.git
/usr/cozy/cozy-monitor/bin/cozy-monitor install home
/usr/cozy/cozy-monitor/bin/cozy-monitor install proxy --repo https://github.com/obigroup/cozy-proxy.git
/usr/cozy/cozy-monitor/bin/cozy-monitor restart-cozy-stack
sleep 5
/usr/local/bin/supervisord -n -c /etc/supervisord.conf