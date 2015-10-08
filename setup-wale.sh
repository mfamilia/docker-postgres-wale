#!/bin/bash

if [ "$AWS_ACCESS_KEY" = "" ]
then
  echo "AWS_ACCESS_KEY does not exist"
  exit 1
fi

if [ "$AWS_SECRET_KEY" = "" ]
then
  echo "AWS_SECRET_KEY does not exist"
  exit 1
fi

if [ "$WALE_S3_PREFIX" = "" ]
then
  echo "WALE_S3_PREFIX does not exist"
  exit 1
fi

umask u=rwx,g=rx,o=
mkdir -p /etc/wal-e.d/env

echo "$AWS_SECRET_KEY" > /etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY
echo "$AWS_ACCESS_KEY" > /etc/wal-e.d/env/AWS_ACCESS_KEY_ID
echo "$WALE_S3_PREFIX" > /etc/wal-e.d/env/WALE_S3_PREFIX
chown -R root:postgres /etc/wal-e.d

echo "wal_level = archive" >> /var/lib/postgresql/data/postgresql.conf
echo "archive_mode = on" >> /var/lib/postgresql/data/postgresql.conf
echo "archive_command = 'envdir /etc/wal-e.d/env /usr/local/bin/wal-e wal-push %p'" >> /var/lib/postgresql/data/postgresql.conf
echo "archive_timeout = 60" >> /var/lib/postgresql/data/postgresql.conf

su - postgres -c "crontab -l | { cat; echo \"$BACKUP_CRON /usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e backup-push /var/lib/postgresql/data\"; } | crontab -"
su - postgres -c "crontab -l | { cat; echo \"$BACKUP_CLEANUP_CRON /usr/bin/envdir /etc/wal-e.d/env /usr/local/bin/wal-e delete --confirm retain $RETAIN_BACKUP_COUNT\"; } | crontab -"
