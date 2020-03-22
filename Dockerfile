FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y keystone apache2 libapache2-mod-wsgi curl jq lsof

COPY keystone.conf /etc/keystone/keystone.conf
COPY setup.sh /root/setup.sh

RUN echo "ServerName keystone-server" >> /etc/apache2/apache2.conf

COPY ./exec.sh /root/exec.sh
RUN chmod +x /root/exec.sh /root/setup.sh

CMD ["/root/exec.sh"]

EXPOSE 5000
