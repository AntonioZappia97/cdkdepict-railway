FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build

# 1. Builda la dipendenza mancante centres-cdk
RUN git clone https://github.com/SiMolecule/centres.git && \
    cd centres && \
    mvn -B -DskipTests install

# 2. Builda CDKDepict
RUN git clone https://github.com/cdk/depict.git && \
    cd depict && \
    mvn -B -DskipTests clean install -Pproduction

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /build/depict/cdkdepict-webapp/target/cdkdepict-webapp-*.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]
