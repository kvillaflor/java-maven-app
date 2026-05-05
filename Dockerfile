# Use Java 8 runtime (matches your pom.xml: source/target 1.8)
FROM --platform=linux/amd64 eclipse-temurin:8-jre-alpine

# Set working directory inside container
WORKDIR /app

# Copy the built jar from Maven's target/ folder into container
COPY ./target/java-maven-app-*.jar /app/java-maven-app.jar

# Spring Boot default port
EXPOSE 8080

# Command to run the app when container starts
ENTRYPOINT ["java", "-jar", "/app/java-maven-app.jar"]
