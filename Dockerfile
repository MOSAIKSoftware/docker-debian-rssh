FROM mosaiksoftware/debian

ENV DEBIAN_FRONTEND=noninteractive

# set up run.sh
COPY run.sh /run.sh
RUN chmod +x /run.sh

# create missing directories
RUN mkdir -p /var/run/sshd

ENTRYPOINT ["/run.sh"]

CMD exec /usr/sbin/sshd -f /etc/ssh/sshd_config -D

