# Postgres docker container with wale

Based on https://github.com/docker-library/postgres with [WAL-E](https://github.com/wal-e/wal-e) installed.

Environment variables to pass to the container for WAL-E, all of these must be present or WAL-E is not configured.

Create an IAM user in a group with GetObject, ListBucket and PutObject on the bucket you want to use (and that it's not public).

This image backups at 3 am and cleanups backups at 4 am.
This image retains up to 7 backups.

This image has a Volume at /etc/wal-e/env

Add a volume container with the data files as follows

| File | Description |
| AWS_SECRET_KEY | from IAM user's credentials, used to authenticate with S3 |
| AWS_ACCESS_KEY | from IAM user's credentials, used to authenticate with S3 |
| WALE_S3_PREFIX | from S3 bucket, used as the destination for database backups |
