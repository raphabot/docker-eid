FROM java:7-jdk

MAINTAINER Raphael Bottino<rbottino@id.uff.br>

############################## Dockerfile do openjdk-7-jdk ##############################

# A few problems with compiling Java from source:
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#       really hairy.

#RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
#ENV LANG C.UTF-8

#ENV JAVA_VERSION 7u79
#ENV JAVA_DEBIAN_VERSION 7u79-2.5.5-1~deb8u1

#RUN apt-get update && apt-get install -y openjdk-7-jdk="$JAVA_DEBIAN_VERSION" && rm -rf /var/lib/apt/lists/*

############################## Dockerfile do openjdk-7-jdk ##############################

############################## Dockerfile do tomcat:6-jre7  ##############################
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
	05AB33110949707C93A279E3D3EFE6B686867BA6 \
	07E48665A34DCAFAE522E5E6266191C37C037D42 \
	47309207D818FFD8DCD3F83F1931D684307A10A5 \
	541FBE7D8F78B25E055DDEE13C370389288584E7 \
	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
	80FF76D88A969FE46108558A80B953A041E49465 \
	8B39757B1D8A994DF2433ED58B3A601F08C975E5 \
	A27677289986DB50844682F8ACB77FC2E86E29AC \
	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
	B3F49CD3B9BD2996DA90F817ED3873F5D3262722 \
	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
	F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 6
ENV TOMCAT_VERSION 6.0.43
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& gpg --verify tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

EXPOSE 8080
CMD ["catalina.sh", "run"]

############################## Dockerfile do tomcat:6-jre7  ##############################


##### Seguindo o manual ######

## Variávies de ambiente ##

# Exportando o JARO_WINKLER_DIR
ENV JARO_WINKLER_DIR /opt/eid-1.3.7/lib/
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/
ENV TOMCAT_HOME /usr/local/tomcat/

# Exportando o TOMCAT6_SECURITY
ENV TOMCAT6_SECURITY no

# Exportando o JAVA_OPTS
ENV JAVA_OPTS -XX:MaxPermSize=512M -Xmx512M -Duser.timezone=America/Sao_Paulo -Djava.library.path=$JARO_WINKLER_DIR -Dfile.encoding=UTF-8 -Duser.language=pt -Duser.country=BR

## Fim das variávies de ambiente ##


## Baixando e instalando os arquivos e bibliotecas necessárias ##

# Baixando e instalando a biblioteca do tomcat-dbcp
RUN wget -O /usr/local/tomcat/lib/tomcat-dbcp.jar http://search.maven.org/remotecontent?filepath=org/apache/tomcat/tomcat-dbcp/7.0.30/tomcat-dbcp-7.0.30.jar

# Instalando o MySQL connector
RUN wget -O /usr/share/java/mysql-connector-java-3.1.8-bin.jar  http://www.docjar.com/jar/mysql-connector-java-3.1.8-bin.jar
RUN ln -sf /usr/share/java/mysql-connector-java-3.1.8-bin.jar /usr/local/tomcat/lib/

# Baixando e extraindo o eid
RUN mkdir /opt/eid-1.3.7/
RUN wget -O /tmp/eid.war --no-check-certificate https://svn.rnp.br/repos/CAFe/ubuntu/hardy/eid/eid.war
RUN unzip /tmp/eid.war -d /opt/eid-1.3.7/

# Bainxando e extraindo o eid2ldap
RUN mkdir /opt/eid2ldap-1.2.0/
RUN wget -O /tmp/eid2ldap.war --no-check-certificate 'http://downloads.sourceforge.net/project/eid2ldap/eid2ldap/1.2.0/eid2ldap.war?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Feid2ldap%2Ffiles%2Feid2ldap%2F1.2.0%2F&ts=1430420534&use_mirror=nbtelecom'
RUN unzip /tmp/eid2ldap.war -d /opt/eid2ldap-1.2.0/

# Compilando o JaroWrinkler
RUN apt-get update -y && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/eid-1.3.7/lib
WORKDIR /opt/eid-1.3.7/WEB-INF/classes/br/ufmg/lcc/eid/model/conciliator
RUN make compile

## Copiando os arquivos customizados para o container

# Copiando o eid.xml com as configurações do banco.
COPY eid.xml /usr/local/tomcat/conf/Catalina/localhost/eid.xml

# Copiando o eid2ldap.xml com as configurações do banco.
COPY eid2ldap.xml /usr/local/tomcat/conf/Catalina/localhost/eid2ldap.xml

# Copiando o tomcat-users.xml para permitir acesso a view do eid
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

## Fim da cópia dos arquivos ##


### Fim do manual ###
