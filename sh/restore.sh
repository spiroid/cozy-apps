#!/bin/bash
appsPath="/usr/local/cozy/apps"
backupPath="/backup"
indexesPath="/usr/local/cozy-indexer/cozy-data-indexer"
DIRS=`find $backupPath/apps -maxdepth 1 ! -path $backupPath/apps -type d -exec basename {} \;`
# Restore backup indexes to dataindexer
if [[ -e "$backupPath/files/indexes"  ]]; then
    cp -r "$backupPath/files/indexes" "$indexesPath"
    chown -R cozy:cozy "$indexesPath/indexes"
fi
# Restore backup apps to cozy apps
for d in $DIRS; do
    cp -r "$backupPath/apps/$d" "$appsPath"
    useradd -M "cozy-$d"
    chown -R "cozy-$d:cozy-$d" "$appsPath/$d"
    echo "$d"
done
supervisorctl restart cozy-controller