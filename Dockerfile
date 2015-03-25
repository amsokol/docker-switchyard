FROM amsokol/oraclelinux-java-wildfly:7.1-7u75-8.1.0
MAINTAINER Alexander Sokolovsky <amsokol@gmail.com>

# User root user to install software
USER root

# Execute system update
RUN yum -y update && yum clean all

# Set the WILDFLY_VERSION env variable
ENV SWITCHYARD_VERSION 2.0.0.CR1

ADD assets/switchyard-$SWITCHYARD_VERSION-WildFly.tar.gz /opt/jboss/wildfly
ADD assets/jasper-jdt-fix.tar.gz /opt/jboss/wildfly
RUN chown -R jboss:jboss /opt/jboss/wildfly

# Specify the user which should be used to execute all commands below
USER jboss

# Set the working directory to jboss' user home directory
WORKDIR /opt/jboss

# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /usr/java/latest

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly

# Expose the folders we're interested in
VOLUME ["/opt/jboss/wildfly/standalone/log"]
VOLUME ["/opt/jboss/wildfly/standalone/deployments"]

# Expose the ports we're interested in
EXPOSE 8080 9990

# Set the default command to run on boot
# This will boot WildFly in the standalone mode
ENTRYPOINT ["java", "-D[Standalone]", "-server", "-Xms64m", "-Xmx512m", "-XX:MaxPermSize=256m", "-Dfile.encoding=UTF-8", "-Djava.net.preferIPv4Stack=true", "-Djboss.modules.system.pkgs=org.jboss.byteman", "-Djava.awt.headless=true", "-Dorg.jboss.boot.log.file=/opt/jboss/wildfly/standalone/log/server.log", "-Dlogging.configuration=file:/opt/jboss/wildfly/standalone/configuration/logging.properties", "-jar", "/opt/jboss/wildfly/jboss-modules.jar", "-mp", "/opt/jboss/wildfly/modules", "org.jboss.as.standalone", "-Djboss.home.dir=/opt/jboss/wildfly", "-Djboss.server.base.dir=/opt/jboss/wildfly/standalone"]
