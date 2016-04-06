# Restricted sftp/scp/rsync/rdist via rssh and docker

The user logs into the container via username/password and ends up
in a restricted rssh shell that only allows sftp/scp operations.

## Installation

```sh
docker build -t mosaiksoftware/debian-sftp .
```

## Running

You need to mount in the folder you want to expose.

```sh
docker run -ti \
	--name=sftp \
	-p 4000:4000 \
	-e SSH_PORT=4000 \
	-e USER=foo \
	-e PASSWORD=bar \
	-v /host/folder:/chroot/home/foo \
	mosaiksoftware/debian-rssh
```

By default, both scp and sftp access is enabled. If you want to control
which commands are enabled for rssh, you can pass any of the following
environment variables to `docker run`, which will override the default
behavior:

* `ALLOW_SCP=yes`
* `ALLOW_SFTP=yes`
* `ALLOW_RDIST=yes`
* `ALLOW_RSYNC=yes`

## Login

With the above running container the user will be able to login via e.g.:

```sh
sftp -P 4000 foo@<hostname>
```

An example command to rsync from this container is:

```sh
rsync -e "ssh -p 4000" foo@<hostname>:/home/foo/* .
```

