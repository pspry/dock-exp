#!/bin/bash
# populate GEOSERVER_DATA_DIR from SVN if it isn't there.
if [ -d $GEOSERVER_DATA_DIR ]; then
	cd $GEOSERVER_DATA_DIR
	if [ ! -d workspaces ]; then
		wget -r --no-parent -nH -X /OGS/trunk/src/geoserver_data_dirs/DEV/INT --cut-dirs=6 --user $SVN_USER --password $SVN_PASSWORD $SVNPATH 
		chown -R 999:999 /data
	fi
fi
# run jetty
cd $JETTY_BASE
java -DGEOSERVER_DATA_DIR=$GEOSERVER_DATA_DIR -Djava.awt.headless=true -DSTOP.PORT=8079 -DSTOP.KEY=geoserver -jar $JETTY_HOME/start.jar
