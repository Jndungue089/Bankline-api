# Use a specific version of Ubuntu as the base image
FROM ubuntu:20.04 AS build

# Install necessary tools
RUN apt-get update && \
    apt-get install -y curl sudo

# Download Oracle JDK 21
RUN curl -O https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb

# Manually install the Oracle JDK package
RUN dpkg -i jdk-21_linux-x64_bin.deb

# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/jdk-21
ENV PATH $PATH:$JAVA_HOME/bin

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project files
COPY . .

# Set JAVA_HOME environment variable for Maven
ENV JAVA_HOME /usr/lib/jvm/jdk-21
ENV PATH $PATH:$JAVA_HOME/bin

# Install Maven with debugging output
RUN apt-get install maven -y -o Debug::pkgProblemResolver=yes

# Build the project with Maven
RUN mvn clean install -y

# Set JAVA_HOME environment variable for subsequent commands
ENV JAVA_HOME /usr/lib/jvm/jdk-21

# Create a new image with a smaller base image
FROM openjdk:21-jdk-slim

# Set the working directory
WORKDIR /app

# Expose the port
EXPOSE 8080

# Copy the JAR file from the build stage
COPY --from=build /app/target/bankline-api-0.0.1-SNAPSHOT.jar app.jar

# Set the entry point
ENTRYPOINT ["java", "-jar", "app.jar"]

