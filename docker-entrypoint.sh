#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [ "${1:0:1}" = '-' ]; then
    set -- node server.js "$@"
fi

if [ "$1" = 'node' ]; then
    echo "Initializing cozy controller"

    # Setting permissions here
    mkdir -p /etc/cozy
    chown -hR cozy /etc/cozy

    # Configure couchdb login & passwd information
    if [ "$COUCHDB_USER" ] && [ "$COUCHDB_PASSWORD" ]; then
        echo $COUCHDB_USER > /etc/cozy/couchdb.login
        echo $COUCHDB_PASSWORD >> /etc/cozy/couchdb.login
    fi

    chown cozy-data-system /etc/cozy/couchdb.login
    chmod 640 /etc/cozy/couchdb.login
fi

exec "$@"
