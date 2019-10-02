FROM adoptopenjdk/openjdk8:latest

ENV DEPS            unzip wget gawk sed
ENV CATALINA_HOME   /opt/tomcat/jws-5.1/tomcat
ENV TC_CONF_DIR     ${CATALINA_HOME}/conf/
ENV TC_WEBAPPS      ${CATALINA_HOME}/webapps/
ENV OPENSSL_CONF    ${CATALINA_HOME}/conf/openssl/pki/tls/openssl.cnf
ENV LD_LIBRARY_PATH ${CATALINA_HOME}/lib/:$LD_LIBRARY_PATH
#ENV PATH            /opt/tomcat/jws-5.1/openssl/bin/:${CATALINA_HOME}/bin/:$PATH
ENV PATH            ${CATALINA_HOME}/bin/:$PATH
ENV JAVA_HOME       /opt/java/openjdk
ENV JWS_ZIP         jws-5.1.0-application-server.zip
#ENV JWS_PATCH_ZIP   jws-application-servers-3.1.1-RHEL7-x86_64.zip

RUN apt-get -y update && apt-get -y install ${DEPS} && apt-get clean all
RUN useradd -s /sbin/nologin tomcat && mkdir -p /opt/tomcat /opt/tomcat/certs && chown tomcat /opt/tomcat -R && chgrp tomcat /opt/tomcat -R && chmod ug+rwxs /opt/tomcat -R

WORKDIR /opt/tomcat

EXPOSE 8080/tcp
EXPOSE 8009/tcp
EXPOSE 8443/tcp
EXPOSE 8005/tcp

USER tomcat

#Download (or copy) and install JWS

#ADD ["${JWS_ZIP}", "${JWS_PATCH_ZIP}", "/opt/tomcat/"]
ADD ["${JWS_ZIP}", "/opt/tomcat/"]

#RUN unzip ${JWS_ZIP} 'jws-5.1/tomcat/*' 'jws-5.1/openssl/*' -d . && \
RUN unzip ${JWS_ZIP} 'jws-5.1/tomcat/*' -d . && \
    #yes && \
    rm -rf ${JWS_ZIP} && \
    chmod 777 'jws-5.1'


ADD server.xml ${TC_CONF_DIR}
ADD tomcat-users.xml ${TC_CONF_DIR}
ADD tomcat.sh /opt/tomcat/

#CMD ["/opt/tomcat/tomcat.sh"]
#CMD [${CATALINA_HOME}/bin/catalina.sh, "run"]