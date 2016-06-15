#!/bin/bash
# this relies on OpenShift set environment variables, so needs to run after build.
wget -c ${SVNPATH2JARS}${GS_VERSION}-oracle-plugin/ojdbc6.jar -O ${GEOSERVER_HOME}/webapps/geoserver/WEB-INF/lib/ojdbc6.jar --user ${SVN_USER} --password ${SVN_PASSWORD} 2>&1 | tee -a wget.log

# populate GEOSERVER_DATA_DIR from SVN if it isn't there.
if [ ! -z ${SVNPATH+x} ]; then 
	if [ -d $GEOSERVER_DATA_DIR ]; then
		cd $GEOSERVER_DATA_DIR
		if [ ! -d workspaces ]; then
			wget -r --no-parent --reject="index.html*" -nH -X /OGS/trunk/src/geoserver_data_dirs/DEV/INT --cut-dirs=6 --user $SVN_USER --password $SVN_PASSWORD $SVNPATH 2>&1 | tee -a wget_log
			chown -R 999:999 /data
		fi
	fi
fi
# run jetty
cd $JETTY_BASE
java -DGEOSERVER_DATA_DIR=$GEOSERVER_DATA_DIR -Djava.awt.headless=true -DSTOP.PORT=8079 -DSTOP.KEY=geoserver -jar $JETTY_HOME/start.jar
