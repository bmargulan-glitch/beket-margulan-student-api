# Multi-stage Dockerfile — Student API by Beket Margulan (ID 38109)
# Build:  docker build -t beket-margulan-student-api:v1.0-beket-margulan-38109 .

# ---------- Stage 1: build with Gradle on an official JDK image ----------
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Copy wrapper and build files first so dependencies are cached between builds
COPY gradlew settings.gradle build.gradle ./
COPY gradle ./gradle
RUN chmod +x gradlew && ./gradlew dependencies --no-daemon > /dev/null

# Copy sources and build the JAR (tests run in Jenkins, so skip them here)
COPY src ./src
RUN ./gradlew bootJar --no-daemon -x test

# ---------- Stage 2: small runtime image with only the JRE ----------
FROM eclipse-temurin:17-jre
WORKDIR /app

LABEL maintainer="Beket Margulan <bmargulan@iitu.edu.kz>" \
      student.id="38109" \
      student.group="it2-2302"

# Run as non-root user
RUN useradd --system --create-home spring
USER spring

COPY --from=build /app/build/libs/beket-margulan-student-api.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
