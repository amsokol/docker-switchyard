FROM amsokol/centos-openjdk-wildfly:7-1.7.0-8.1.0
MAINTAINER Alexander Sokolovsky <amsokol@gmail.com>

# User root user to install software
USER root

# Execute system update
RUN yum -y update && yum -y install bsdtar && yum clean all

# Set the SWITCHYARD_VERSION env variable
ENV JBOSS_SY_VERSION 2.0.0.Final
ENV JBOSS_SY_VERSION_MAIN v2.0.Final

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly

# Install switchyard
RUN cd $JBOSS_HOME && curl -L http://downloads.jboss.org/switchyard/releases/$JBOSS_SY_VERSION_MAIN/switchyard-$JBOSS_SY_VERSION-WildFly.zip | bsdtar -xvf-

ADD assets/jasper-jdt-fix.tar.gz /opt/jboss/wildfly
RUN chown -R jboss:jboss /opt/jboss/wildfly

# Specify the user which should be used to execute all commands below
USER jboss

# Set the working directory to jboss' user home directory
WORKDIR /opt/jboss

# Expose the folders we're interested in
VOLUME ["/opt/jboss/wildfly/standalone/log"]
VOLUME ["/opt/jboss/wildfly/standalone/deployments"]

# Expose the ports we're interested in
EXPOSE 8080 9990

# Set the default command to run on boot
# This will boot WildFly in the standalone mode
ENTRYPOINT ["java", "-D[Standalone]", "-server", "-Xms64m", "-Xmx512m", "-XX:MaxPermSize=256m", "-Dfile.encoding=UTF-8", "-Djava.net.preferIPv4Stack=true", "-Djboss.modules.system.pkgs=org.jboss.byteman", "-Djava.awt.headless=true", "-Dorg.jboss.boot.log.file=/opt/jboss/wildfly/standalone/log/server.log", "-Dlogging.configuration=file:/opt/jboss/wildfly/standalone/configuration/logging.properties", "-jar", "/opt/jboss/wildfly/jboss-modules.jar", "-mp", "/opt/jboss/wildfly/modules", "org.jboss.as.standalone", "-Djboss.home.dir=/opt/jboss/wildfly", "-Djboss.server.base.dir=/opt/jboss/wildfly/standalone"]
