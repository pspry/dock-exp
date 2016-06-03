# Custom geoserver under jetty for TRAN
FROM jetty
# this is a copy of the platform independent binary from GeoServer
# but I should really grab it from GeoServer.org and then add the specific files TRAN needs.
ADD geoserver /var/lib/jetty/webapps/geoserver
# override default location of -Djava.io.tmpdir
# this also contains the script to load the data_dir if it isn't found
ADD work /usr/local/jetty/work
RUN chmod +x /usr/local/jetty/work/tran.sh
# Environment variables expected by GeoServer
ENV GEOSERVER_HOME /var/lib/jetty
ENV GEOSERVER_DATA_DIR /data
# load data_dir if it isn't already
RUN /usr/local/jetty/work/tran.sh
# run jetty
ENTRYPOINT ["java","-DGEOSERVER_DATA_DIR=/data","-Djava.awt.headless=true","-DSTOP.PORT=8079","-DSTOP.KEY=geoserver","-jar","/usr/local/jetty/start.jar"]
