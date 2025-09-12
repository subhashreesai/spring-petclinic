FROM maven:3.9.11-eclipse-temurin-17-alpine as build
RUN apk add git
RUN git clone https://github.com/spring-projects/spring-petclinic.git  && \
    cd spring-petclinic && \
    mvn package

FROM openjdk:25-ea-17-jdk as run 
RUN adduser -D -h /usr/share/demo -s /bin/bash testuser
USER testuser
WORKDIR /user/share/demo
COPY --from=build /target/*.jar .
EXPOSE 8080/tcp
CMD ["java", "-jar", "*.jar"]    
