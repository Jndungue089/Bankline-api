FROM ubuntu:latest AS build
 
 RUN apt-get update
 RUN apt-get install openjdk-17-jdk -y
 COPY . .

 RUN apt-get install maven -y
 RUN mvn clean install

 FROM openjdk:17-jdk-slim

 EXPOSE 8080

 COPY --from=build target\bankline-api-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT [ "java", "-jar", "app.jar" ]
VOLUME /tmp
ARG JAVA_OPTS
ENV JAVA_OPTS=$JAVA_OPTS
COPY target/bankline-api-0.0.1-SNAPSHOT.jar banklineapi.jar
EXPOSE 8080
ENTRYPOINT exec java $JAVA_OPTS -jar banklineapi.jar
# For Spring-Boot project, use the entrypoint below to reduce Tomcat startup time.
#ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar banklineapi.jar
