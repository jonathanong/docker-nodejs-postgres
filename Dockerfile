FROM ubuntu:16.04

ENV NODEJS_VERSION 6
ENV POSTGRESQL_VERSION 9.6

RUN apt-get update && apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_$NODEJS_VERSION.x | bash -
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y \
  nodejs \
  python-software-properties \
  software-properties-common \
  postgresql-$POSTGRESQL_VERSION \
  postgresql-client-$POSTGRESQL_VERSION \
  postgresql-contrib-$POSTGRESQL_VERSION

RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/$POSTGRESQL_VERSION/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf

USER postgres
RUN service postgresql start && \
  psql -c "create database pgdb;" && \
  psql -c "create role pgrole with login password 'pgrole'; grant all privileges on database pgdb to pgrole;"
