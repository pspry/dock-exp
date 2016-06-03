#!/bin/bash
# populate GEOSERVER_DATA_DIR from SVN if it isn't there.
cd /data

if [ ! -d workspaces ]; then
	wget -r --no-parent -nH -X $SVNIGNOREPATH --cut-dirs=6 --user $SVN_USER --password $SVN_PASSWORD $SVNPATH 
	chown -R 999:999 /data
fi
