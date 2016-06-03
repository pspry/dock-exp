# This works in Docker, trying to get it into OpenShift now.
FROM jetty
# this is the platform independent binary from GeoServer
ADD geoserver /var/lib/jetty/webapps/geoserver
# override default location of -Djava.io.tmpdir
ADD work /usr/local/jetty/work
# Environment variables expected by GeoServer
ENV GEOSERVER_HOME /var/lib/jetty
ENV GEOSERVER_DATA_DIR /data
RUN chown -R 999:999 /var/lib/jetty/data_dir
# run it with all the additional parameters less one
ENTRYPOINT ["java","-DGEOSERVER_DATA_DIR=/var/lib/jetty/data_dir","-Djava.awt.headless=true","-DSTOP.PORT=8079","-DSTOP.KEY=geoserver","-jar","/usr/local/jetty/start.jar"]
