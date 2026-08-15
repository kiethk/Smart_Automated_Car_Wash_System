FROM tomcat:9-jdk8-temurin

WORKDIR /app

RUN rm -rf /usr/local/tomcat/webapps/*

COPY backend /app/backend

WORKDIR /app/backend

RUN apt-get update \
    && apt-get install -y ant \
    && rm -rf /var/lib/apt/lists/*

RUN ant -f nbproject/build-impl.xml clean dist

RUN cp dist/backend.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]