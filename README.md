# Postgres docker container with wale

Based on https://github.com/docker-library/postgres with [WAL-E](https://github.com/wal-e/wal-e) installed.

Environment variables to pass to the container for WAL-E, all of these must be present or WAL-E is not configured.

Create an IAM user in a group with GetObject, ListBucket and PutObject on the bucket you want to use (and that it's not public).

This image backups at 9 am UTC and cleanups backups at 9:30 am UTC.
This image retains up to 10 backups.

This image has a Volume at /etc/wal-e/env
