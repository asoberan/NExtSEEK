FROM python:3.9-slim-buster

RUN apt-get update -qq && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends build-essential cron python3-dev curl iputils-ping default-mysql-client pkg-config libmariadb-dev libhdf5-dev locales vim-tiny
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8

RUN groupadd -g 48 apache
RUN useradd -ms /bin/bash -u 48 -g 48 apache

RUN mkdir -p /logs
RUN mkdir -p /static
RUN mkdir -p /app

WORKDIR /app

COPY . .

USER apache

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt

USER root

RUN chown -R apache /app
RUN chown -R apache /logs
RUN chmod +x docker/entrypoint.sh

USER apache

CMD ["docker/entrypoint.sh"]