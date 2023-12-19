FROM ubuntu:latest AS build

RUN apt-get update
RUN curl -O https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
RUN sudo apt install ./jdk-21_linux-x64_bin.deb

COPY . .

RUN apt-get install maven -y
RUN mvn clean install

FROM openjdk:21-jdk-slim

EXPOSE 8080

COPY --from=build target\bankline-api-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT [ "java", "-jar", "app.jar" ]