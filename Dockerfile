# This works in Docker, trying to get it into OpenShift now.
FROM jetty
# currently this is the stock data_dir from GeoServer
ADD data_dir /var/lib/jetty/data_dir
# this is the platform independent binary from GeoServer
ADD geoserver /var/lib/jetty/webapps/geoserver
# Environment variables expected by GeoServer
ENV GEOSERVER_HOME /var/lib/jetty
ENV GEOSERVER_DATA_DIR /var/lib/jetty/data_dir
RUN chown -R 999:999 /var/lib/jetty/data_dir
# not sure if it is necessary to bother changing this from default of 8080 or not.
EXPOSE 8081
# run it with all the additional parameters
ENTRYPOINT ["java","-XX:MaxPermSize=128m","-Djava.io.tmpdir=/tmp/jetty","-DGEOSERVER_DATA_DIR=/var/lib/jetty/data_dir","-Djava.awt.headless=true","-DSTOP.PORT=8079","-DSTOP.KEY=geoserver","-jar","/usr/local/jetty/start.jar","jetty.http.port=8081"]