### Dockerfile1 

# the first stage of our build will use a maven 3.6.1 parent image
FROM maven:3.6.1-jdk-8-alpine AS MAVEN_BUILD

# copy the pom and src code to the container
COPY ./ ./

# package our application code
RUN mvn clean package

# the second stage of our build will use open jdk 8 on alpine 3.9
#FROM openjdk:8-jre-alpine3.9
FROM openjdk:11.0.15-jre-slim-buster

# Create new a group and user in a single go
RUN addgroup -S puma && adduser -S docker -G puma
 
# Let docker know that all future Alpine Linux images commands should run as the 'myappuser' user
USER docker


# copy only the artifacts we need from the first stage and discard the rest
COPY --from=MAVEN_BUILD /docker-multi-stage-build-demo/target/demo-0.0.1-SNAPSHOT.jar /demo.jar

# set the startup command to execute the jar
CMD ["java", "-jar", "/demo.jar"]
