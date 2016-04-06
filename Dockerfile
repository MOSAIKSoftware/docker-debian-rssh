FROM mosaiksoftware/debian

ENV DEBIAN_FRONTEND=noninteractive

# install required packages
RUN begin-apt && \
	apt-get install -y wget curl locales && \
	apt-get install -y rssh openssh-server openssl binutils && \
	end-apt && \
	echo "Europe/Stockholm" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata && \
	export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	dpkg-reconfigure locales && \
	apt-get autoremove

# copy config
COPY config/sshd_config /etc/ssh/sshd_config
COPY config/rssh.conf /etc/rssh.conf

# set up run.sh
COPY run.sh /run.sh
RUN chmod +x /run.sh

# create missing directories
RUN mkdir -p /var/run/sshd

# set up rssh chroot
COPY create-rss-chroot.sh /
RUN chmod +x create-rss-chroot.sh
RUN /create-rss-chroot.sh

CMD /run.sh && exec /usr/sbin/sshd -f /etc/ssh/sshd_config -D

