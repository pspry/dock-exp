# Custom geoserver under jetty for TRAN
FROM jetty
# this is a copy of the platform independent binary from GeoServer
# but I should really grab it from GeoServer.org and then add the specific files TRAN needs.
# ADD geoserver /var/lib/jetty/webapps/geoserver

# Get GeoServer 
WORKDIR /tmp
# Environment variables expected by GeoServer
ENV GEOSERVER_HOME /var/lib/jetty
ENV GEOSERVER_DATA_DIR /data
ENV GS_VERSION 2.8.3
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GS_VERSION}/geoserver-${GS_VERSION}-bin.zip -O /tmp/geoserver.zip && \
	unzip /tmp/geoserver.zip -d /tmp/geoserver && \
	mkdir ${GEOSERVER_HOME}/webapps/geoserver && \
	mv /tmp/geoserver/geoserver-${GS_VERSION}/webapps/* ${GEOSERVER_HOME}/webapps && \
	rm -r /tmp/geoserver* ;
# override default location of -Djava.io.tmpdir
# this also contains the script to load the data_dir if it isn't found
ADD work /usr/local/jetty/work
RUN chmod +x /usr/local/jetty/work/tran.sh
# load data_dir from SVN if it isn't already and then run jetty
ENTRYPOINT ["/usr/local/jetty/work/tran.sh"]