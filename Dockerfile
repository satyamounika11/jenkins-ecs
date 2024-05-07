# Use the official Jenkins LTS image as a parent image
FROM jenkins/jenkins:lts

# Disable Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Set the Jenkins user
USER jenkins

# Pre-install desired plugins
COPY plugins.txt /usr/share/jenkins/ref/
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# Optionally, configure Jenkins settings and jobs
COPY --chown=jenkins:jenkins config/*.groovy /var/jenkins_home/init.groovy.d/
COPY --chown=jenkins:jenkins jobs /var/jenkins_home/jobs/

# Tweak JVM options for better performance and efficiency
ENV JAVA_OPTS="-Xmx2048m -Xms512m -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ExplicitGCInvokesConcurrent -Djava.awt.headless=true $JAVA_OPTS"

# Expose the default Jenkins port
EXPOSE 8080

# Expose the slave agent port
EXPOSE 50000

# Set the default user for Jenkins (back to root for any further root commands, if necessary)
USER root

# Any other configurations or scripts you might need to add
# RUN your-command-here

# Switch back to Jenkins user before running
USER jenkins

