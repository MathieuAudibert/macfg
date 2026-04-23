FROM eclipse-temurin:21-jdk-alpine AS builder

LABEL mpp.macfg.maintainer="mathieu.audibert@edu.devinci.fr"
LABEL mpp.macfg.version="0.1.0"
LABEL mpp.macfg.vendor="Mathieu Personnal Projects"
LABEL mpp.macfg.name="macfg"
LABEL mpp.macfg.description="Machine Configuration Tool - Dev Environment Installer"

WORKDIR /build

RUN apk add --no-cache maven

COPY pom.xml .
COPY config/pom.xml ./config/
COPY core/pom.xml ./core/

RUN mvn dependency:go-offline -B

COPY config/src ./config/src
COPY core/src ./core/src

RUN mvn clean package -DskipTests -B

FROM eclipse-temurin:21-jre-alpine AS config

WORKDIR /app

COPY --from=builder /build/config/target/*.jar app.jar

EXPOSE 7777

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:7777/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]

FROM eclipse-temurin:21-jre-alpine AS core

WORKDIR /app

RUN apk add --no-cache \
    bash \
    git \
    curl \
    ncurses

COPY --from=builder /build/core/target/*.jar app.jar

EXPOSE 7778
VOLUME ["/root/dev"]

ENV TERM=xterm-256color

ENTRYPOINT ["java", "-jar", "app.jar"]
