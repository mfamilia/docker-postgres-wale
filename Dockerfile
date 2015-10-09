FROM postgres:9.4.4

MAINTAINER Manuel Familia

RUN apt-get update && apt-get install -y python-pip python-dev lzop pv daemontools
RUN easy_install wal-e

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV RETAIN_BACKUP_COUNT 7
ENV BACKUP_CLEANUP_CRON "0 4 * * *"
ENV BACKUP_CRON "0 3 * * *"

VOLUME "/etc/wal-e/env"

ADD fix-acl.sh /docker-entrypoint-initdb.d/
ADD setup-wale.sh /docker-entrypoint-initdb.d/
