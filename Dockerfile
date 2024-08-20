FROM openjdk:8-jdk-alpine
LABEL maintainer="Nathaniel Malmrose nathanielmalmrose@gmail.com"

ADD target/uberjar/example-webapp.jar /example-webapp/app.jar

EXPOSE 3000

CMD ["java", "-jar", "/example-webapp/app.jar"]
