# Pull base image 
#From tomcat:8-jre8 
#COPY webapp/target/webapp.war /usr/local/tomcat/webapps/
#RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps

# Use a minimal OpenJDK runtime with Alpine
FROM openjdk:8-jre-alpine

# Set environment variables for Tomcat installation
ENV TOMCAT_VERSION=8.5.78
ENV TOMCAT_TAR_FILE=apache-tomcat-${TOMCAT_VERSION}.tar.gz
ENV TOMCAT_URL=http://apache.mirrors.tds.net/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/${TOMCAT_TAR_FILE}
ENV TOMCAT_HOME=/usr/local/tomcat

# Install dependencies: curl for downloading, awscli, and minimal setup
RUN apk add --no-cache curl aws-cli && \
    mkdir -p ${TOMCAT_HOME} && \
    curl -fsSL ${TOMCAT_URL} | tar xz -C ${TOMCAT_HOME} --strip-components=1 && \
    rm -rf /var/cache/apk/*

# Set environment variables for S3 bucket and WAR file name
ENV S3_BUCKET_NAME="appdeploywarfile"
ENV WAR_FILE_NAME="webapp.war"
ENV LOCAL_WAR_PATH="${TOMCAT_HOME}/webapps/${WAR_FILE_NAME}"

# Use AWS CLI to download the WAR file from S3
RUN aws s3 cp s3://${S3_BUCKET_NAME}/${WAR_FILE_NAME} ${LOCAL_WAR_PATH}

# Expose Tomcat's default port 8080
EXPOSE 8080

# Start Tomcat
CMD ["${TOMCAT_HOME}/bin/catalina.sh", "run"]


