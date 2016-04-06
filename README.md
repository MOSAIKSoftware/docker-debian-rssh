# Restricted sftp/scp via rssh and docker

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
	mosaiksoftware/debian-sftp
```

## Login

With the above running container the user will be able to login via e.g.

```sh
sftp -P 4000 foo@<hostname>
```

