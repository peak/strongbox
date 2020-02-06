# -----------------------------------------------------------------------------
# Build...
FROM maven:3.5-jdk-8-slim AS build

WORKDIR /app/
COPY . .
RUN apt-get update && apt-get install -y git
RUN mkdir ~/.m2
RUN cp ./settings.xml ~/.m2/settings-strongbox.xml
RUN mvn -s ~/.m2/settings-strongbox.xml clean install -DskipTests

# -----------------------------------------------------------------------------
# Image...
FROM openjdk:8-jdk-slim
WORKDIR /app/
RUN apt-get update && apt-get install -y procps
COPY --from=build /app/strongbox-distribution/target/strongbox-distribution-1.0-SNAPSHOT.tar.gz /tmp
RUN tar xzf /tmp/strongbox-distribution-1.0-SNAPSHOT.tar.gz --strip-components=2 -C .
ENTRYPOINT [ "/app/bin/strongbox", "console" ]