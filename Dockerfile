# Pull base image
From tomcat:8-jre8

# Maintainer
#MAINTAINER "xxx <xxx@gmail.com">

# Copy configurations
COPY tomcat-users.xml /usr/local/tomcat/conf/
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/

# Copy to images tomcat path
ADD ProductosServicios.war /usr/local/tomcat/webapps/

