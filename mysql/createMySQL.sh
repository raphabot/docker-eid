#!/bin/bash
CONTAINER_NAME="eid-mysql-teste"

MYSQL_USER="eid"
MYSQL_PASSWORD="1234"
MYSQL_ROOT_PASSWORD="12345"

EID_DB="eid"
PCOLLECTA_DB="pcollecta"
EID2LDAP_DB="eid2ldap"

# Mata o container atual, util durante testes
docker kill ${CONTAINER_NAME} && docker rm ${CONTAINER_NAME}

# Cria o servidor MySQL
docker run --name ${CONTAINER_NAME} -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} -e MYSQL_USER=${MYSQL_USER} -e MYSQL_PASSWORD=${MYSQL_PASSWORD} -e MYSQL_DATABASE=${EID_DB} -d mysql:5.6.24

# Tempo a aguardar para o servico MySQL startar no servidor
sleep 20

# Cria os databases
docker run -it --link ${CONTAINER_NAME}:mysql -v $(pwd)/dumps/:/tmp/ --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e "show databases; create database '$PCOLLECTA_DB'; create database '$EID2LDAP_DB'; show databases;"'

# Popula o eid
docker run -it --link ${CONTAINER_NAME}:mysql -v $(pwd)/dumps/:/tmp/ --rm mysql  sh -c ' exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" '$EID_DB' < /tmp/eid-1.3.7.dump'

# Popula o eid2ldap
docker run -it --link ${CONTAINER_NAME}:mysql -v $(pwd)/dumps/:/tmp/ --rm mysql  sh -c ' exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" '$EID2LDAP_DB' < /tmp/eid2ldap-1.2.0.sql'

# Popula o pcollecta
docker run -it --link ${CONTAINER_NAME}:mysql -v $(pwd)/dumps/:/tmp/ --rm mysql  sh -c ' exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" '$PCOLLECTA_DB' < /tmp/pcollecta-1.3.7.dump'
