# Pull base image 
#From tomcat:8-jre8 
#COPY webapp/target/webapp.war /usr/local/tomcat/webapps/
#RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps


# Use a base image with Java and Tomcat
FROM tomcat:8-jre8

# Install AWS CLI to interact with S3
RUN apt-get update && \
    apt-get install -y awscli && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for S3 bucket and WAR file name
ENV S3_BUCKET_NAME="appdeploywarfile"
ENV WAR_FILE_NAME="webapp.war"
ENV LOCAL_WAR_PATH="/usr/local/tomcat/webapps/${WAR_FILE_NAME}"

# Use AWS CLI to download the WAR file from S3
RUN aws s3 cp s3://${S3_BUCKET_NAME}/${WAR_FILE_NAME} ${LOCAL_WAR_PATH}

# (Optional) Ensure the copied WAR file is placed in the correct Tomcat directory
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps

# Expose Tomcat's default port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
