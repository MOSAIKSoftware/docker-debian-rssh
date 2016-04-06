#!/bin/bash

set -e

chrootdir=/chroot

if [[ ${SSH_PORT} ]] ; then
	sed -i -e \
		"s/^Port .*$/Port ${SSH_PORT}/" \
		/etc/ssh/sshd_config
fi

if [[ ${ALLOW_SCP} ]] ; then
	echo "Enabling scp"
	echo "allowscp" >> /etc/rssh.conf
fi

if [[ ${ALLOW_SFTP} ]] ; then
	echo "Enabling sftp"
	echo "allowsftp" >> /etc/rssh.conf
fi

if [[ ${ALLOW_RDIST} ]] ; then
	echo "Enabling rdist"
	echo "allowrdist" >> /etc/rssh.conf
fi

if [[ ${ALLOW_RSYNC} ]] ; then
	echo "Enabling rsync"
	echo "allowrsync" >> /etc/rssh.conf
fi

if [[ ! ${ALLOW_SCP} && ! ${ALLOW_SFTP} &&
		! ${ALLOW_RDIST} && ! ${ALLOW_RSYNC} ]] ; then
	echo "Enabling scp and sftp"
	echo "allowscp" >> /etc/rssh.conf
	echo "allowsftp" >> /etc/rssh.conf
fi


if [[ ${USER} && ${PASSWORD} ]] ; then
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

exec "$@"

