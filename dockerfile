# Use the official Tomcat image as the base image
FROM amd64/tomcat:7

# Remove the default Tomcat webapps
# RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the hello-webapp directory to the Tomcat webapps directory
COPY ./ROOT /usr/local/tomcat/webapps/ROOT

EXPOSE 8080