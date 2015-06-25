docker run --name="centos7-openjdk7-wildfly8.1.0-switchyard2.0.0.Final" -d -p 8080:8080 -p 9990:9990 -v ~/Development/docker/wildfly/log:/opt/jboss/wildfly/standalone/log -v ~/Development/docker/wildfly/deployments:/opt/jboss/wildfly/standalone/deployments -m 1g amsokol/centos-openjdk-wildfly-switchyard:7-1.7.0-8.1.0-2.0.0.Final -b 0.0.0.0 -bmanagement 0.0.0.0

