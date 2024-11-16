# Usar una imagen base de Maven para la construcción
FROM maven:3.9.8 AS builder

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo pom.xml y el directorio de código fuente al contenedor
COPY pom.xml ./
COPY src ./src

# Ejecutar Maven para construir el proyecto y generar el archivo JAR
RUN mvn clean install package

# Verificar que el archivo JAR se generó correctamente
RUN ls /app/target/

# Fase final: Usar una imagen base de OpenJDK con JRE 17
FROM openjdk:17-jdk-slim

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo JAR de la aplicación generado por Maven a la imagen
COPY --from=builder /app/target/Certificaciondevops2024-0.0.1-SNAPSHOT.jar /app/myapp.jar

# Exponer el puerto en el que la aplicación estará escuchando
EXPOSE 8082

# Comando para ejecutar la aplicación Spring Boot
ENTRYPOINT ["java", "-jar", "/app/myapp.jar"]
