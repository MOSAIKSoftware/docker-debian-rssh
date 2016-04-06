#!/bin/bash

set -e

if [[ ${SSH_PORT} ]] ; then
	sed -i -e \
		"s/^Port .*$/Port ${SSH_PORT}/" \
		/etc/ssh/sshd_config
fi


if [[ ! ${USER} || ! ${PASSWORD} ]] ; then
	exit 1
else
	useradd -o \
			-u 0 \
			-G root \
			-s /usr/bin/rssh \
			-m \
			-p $(echo ${PASSWORD} | openssl passwd -1 -stdin) \
			${USER}
	mkdir -p /chroot/home/${USER}
	chown ${USER}:root /chroot/home/${USER}
fi

