# Custom geoserver under jetty for TRAN
# many thanks for the example in https://hub.docker.com/r/kartoza/geoserver/~/dockerfile/
FROM jetty

# Environment variables expected by GeoServer
ENV GEOSERVER_HOME /var/lib/jetty
ENV GEOSERVER_DATA_DIR /data
ENV GS_VERSION 2.8.3

# Get GeoServer and required plugins.
WORKDIR /tmp
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/geoserver-${GS_VERSION}-bin.zip -O /tmp/geoserver.zip && \
	unzip /tmp/geoserver.zip -d /tmp/geoserver && \
	mkdir ${GEOSERVER_HOME}/webapps/geoserver && \
	mv /tmp/geoserver/geoserver-${GS_VERSION}/webapps/* ${GEOSERVER_HOME}/webapps && \
	rm -r /tmp/geoserver* && \
	wget -c http://sourceforge.net/projects/geoserver/files/GeoServer/${GS_VERSION}/extensions/geoserver-${GS_VERSION}-oracle-plugin.zip -O /tmp/oracle-plugin.zip && \
	unzip /tmp/oracle-plugin.zip -d /tmp/oracle-plugin && \
	mv /tmp/oracle-plugin/*.jar ${GEOSERVER_HOME}/webapps/geoserver/WEB-INF/lib && \
	rm -r /tmp/oracle-plugin* && \
	wget -c ${SVNPATH2JARS}${GS_VERSION}-oracle-plugin/ojdbc6.jar -O ${GEOSERVER_HOME}/webapps/geoserver/WEB-INF/lib/ojdbc6.jar --user ${SVN_USER} --password ${SVN_PASSWORD} ;
	
# override default location of -Djava.io.tmpdir
# this also contains the script to load the data_dir if it isn't found
ADD work /usr/local/jetty/work
RUN chmod +x /usr/local/jetty/work/tran.sh

# load data_dir from SVN if it isn't already and then run jetty
ENTRYPOINT ["/usr/local/jetty/work/tran.sh"]