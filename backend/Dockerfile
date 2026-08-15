FROM tomcat:9-jdk8-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY backend/dist/backend.war /usr/local/tomcat/webapps/backend.war

EXPOSE 8080

CMD ["catalina.sh", "run"]