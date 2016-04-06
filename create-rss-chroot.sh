#!/bin/bash

set -e

chrootdir=/chroot


l2chroot() {
	if [ $# -eq 0 ]; then
	  echo "Syntax : $0 /path/to/executable"
	  echo "Example: $0 /usr/bin/php5-cgi"
	  exit 1
	fi

	[ ! -d $chrootdir ] && mkdir -p $chrootdir || :

	# iggy ld-linux* file as it is not shared one
	FILES="$(ldd $1 | awk '{ print $3 }' |egrep -v ^'\(')"

	echo "Copying shared files/libs to $chrootdir..."
	for i in $FILES
	do
	  d="$(dirname $i)"
	  [ ! -d $chrootdir$d ] && mkdir -p $chrootdir$d || :
	  cp $i $chrootdir$d
	done

	# copy /lib/ld-linux* or /lib64/ld-linux* to $chrootdir/$sldlsubdir
	# get ld-linux full file location
	sldl="$(ldd $1 | grep 'ld-linux' | awk '{ print $1}')"
	# now get sub-dir
	sldlsubdir="$(dirname $sldl)"

	if [ ! -f $chrootdir$sldl ];
	then
	  echo "Copying $sldl $chrootdir$sldlsubdir..."
	  [ ! -d $chrootdir$sldlsubdir ] && mkdir -p $chrootdir$sldlsubdir
	  cp $sldl $chrootdir$sldlsubdir
	else
	  :
	fi
}

# directories
mkdir "${chrootdir}"
mkdir -p "${chrootdir}"/{dev,etc,lib,lib64,usr,bin}
mkdir -p "${chrootdir}"/usr/bin
mkdir -p "${chrootdir}"/usr/lib/openssh
mkdir -p "${chrootdir}"/usr/lib/rssh

# devices
mknod -m 666 "${chrootdir}"/dev/null c 1 3

# config
cp /etc/ld.so.cache "${chrootdir}"/etc/
cp /etc/ld.so.conf "${chrootdir}"/etc/
cp -avr /etc/ld.so.conf.d/ "${chrootdir}"/etc/
cp /etc/nsswitch.conf "${chrootdir}"/etc/
cp /etc/hosts "${chrootdir}"/etc/
cp /etc/resolv.conf "${chrootdir}"/etc/

# binaries
cp /usr/bin/scp "${chrootdir}"/usr/bin/
cp /usr/bin/rssh "${chrootdir}"/usr/bin/
cp /usr/bin/sftp "${chrootdir}"/usr/bin/
cp /usr/lib/openssh/sftp-server "${chrootdir}"/usr/lib/openssh/
cp /usr/lib/rssh/rssh_chroot_helper "${chrootdir}"/usr/lib/rssh/

# libraries
l2chroot /usr/bin/scp
l2chroot /usr/bin/rssh
l2chroot /usr/bin/sftp
l2chroot /usr/lib/openssh/sftp-server
l2chroot /usr/lib/rssh/rssh_chroot_helper
cp /lib/x86_64-linux-gnu/libnss_* "${chrootdir}"/lib/x86_64-linux-gnu/
cp /lib/x86_64-linux-gnu/ld-* "${chrootdir}"/lib/x86_64-linux-gnu/
cp /lib/x86_64-linux-gnu/libc* "${chrootdir}"/lib/x86_64-linux-gnu/
cp /lib/x86_64-linux-gnu/libnsl* "${chrootdir}"/lib/x86_64-linux-gnu/

