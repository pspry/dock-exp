# This works in Docker, trying to get it into OpenShift now.
FROM jetty
# this is the platform independent binary from GeoServer
# but I should really grab it from GeoServer.org and then add the specific files TRAN needs.
ADD geoserver /var/lib/jetty/webapps/geoserver
# override default location of -Djava.io.tmpdir
# this also contains the script to load the data_dir if it isn't found
ADD work /usr/local/jetty/work
CMD ["chmod","+x","/usr/local/jetty/work/tran.sh"]
# Environment variables expected by GeoServer
ENV GEOSERVER_HOME /var/lib/jetty
ENV GEOSERVER_DATA_DIR /data
CMD ["/usr/local/jetty/work/tran.sh"]
RUN chown -R 999:999 $GEOSERVER_DATA_DIR
# run jetty
ENTRYPOINT ["java","-DGEOSERVER_DATA_DIR=/var/lib/jetty/data_dir","-Djava.awt.headless=true","-DSTOP.PORT=8079","-DSTOP.KEY=geoserver","-jar","/usr/local/jetty/start.jar"]
