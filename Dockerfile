FROM openjdk:8-jdk-alpine
VOLUME /tmp
EXPOSE 8080
COPY target/shift-rest-1.0.0-SNAPSHOT.jar app.jar
COPY startup.sh startup.sh
RUN apk --no-cache add curl
#ENTRYPOINT ["java", "-jar", "app.jar", "--person.name=Brian"]
ENTRYPOINT ["/bin/sh", "startup.sh"]
