#!/bin/bash
appsPath="/usr/local/cozy/apps"
backupPath="/backup"
indexesPath="/usr/local/cozy-indexer/cozy-data-indexer/indexes"
DIRS=`find $appsPath -maxdepth 1 -type d -exec basename {} \;`
excludefolders=("apps" "data-system" "home" "proxy")
# Copy indexes (Cozy files) to backup
if [[ -e "$indexesPath" ]]; then
    cp -r "$indexesPath" "$backupPath/files"
fi
# Copy apps to backup
for d in $DIRS; do
    if [[ !("${excludefolders[*]}" =~ "$d") ]]; then
        cp -r "$appsPath/$d" "$backupPath/apps"
        echo "$d"
    fi
done