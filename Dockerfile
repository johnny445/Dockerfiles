FROM nimmis/alpine-java:openjdk-8-jre

RUN apk update 

RUN apk add memcached

ENV TOMCAT_VERSION 8.0.30
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

WORKDIR /opt

COPY /tomcat /opt/tomcat/

COPY bosuiteCA.cer /opt/

COPY run.sh /opt/
COPY symphoni.jks /opt/

COPY development.jks /opt/

COPY bosuiteCA.cer /opt/
RUN  echo "http://dl-2.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories; \
    echo "http://dl-3.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories; \
    echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories; \
    echo "http://dl-5.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN keytool -importcert -file /opt/bosuiteCA.cer -alias bosuite -keystore /usr/lib/jvm/default-jvm/jre/lib/security/cacerts -keypass changeit -noprompt -storepass changeit

COPY bosuiteCA.pem /usr/local/share/ca-certificates

RUN update-ca-certificates
#EXPOSE 2001

RUN apk add openssl --force

RUN apk add --update bash

#RUN   apk add jq

EXPOSE 2222

RUN chmod +x /opt/run.sh

ENTRYPOINT /opt/run.sh




