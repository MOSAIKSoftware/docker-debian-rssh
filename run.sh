#!/bin/bash

set -e

chrootdir=/chroot

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
			-M \
			-d "${chrootdir}"/home/${USER} \
			-p $(echo ${PASSWORD} | openssl passwd -1 -stdin) \
			${USER}
	mkdir -p "${chrootdir}"/home/${USER}
	chown ${USER}:root "${chrootdir}"/home/${USER}
	sed -i -e "s#/root#/chroot/home/${USER}#" /etc/passwd
	cp /etc/passwd "${chrootdir}"/etc/
	cp /etc/group "${chrootdir}"/etc/
fi

