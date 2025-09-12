# ---- Build stage ----
FROM maven:3.9.11-eclipse-temurin-17-alpine AS build

# Install git
RUN apk add --no-cache git

# Clone the repo and build the project
RUN git clone https://github.com/spring-projects/spring-petclinic.git /app
WORKDIR /app
RUN mvn package -DskipTests

# ---- Runtime stage ----
FROM eclipse-temurin:17-jre-alpine AS run

# Create non-root user
RUN adduser -D -h /usr/share/demo -s /bin/bash testuser
USER testuser
WORKDIR /usr/share/demo

# Copy jar from build stage (renaming to app.jar)
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
