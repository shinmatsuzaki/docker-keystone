FROM ubuntu:18.04

# apt実行時の対話モードの抑止
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    # keystoneとhttpdのinstall
    && apt install -y keystone apache2 libapache2-mod-wsgi \
    # 運用用コマンドの追加
    && apt install -y curl jq lsof

# python-openstack clientのinstall
RUN apt install -y python-dev python-pip
RUN pip install python-openstackclient

###################  Configuration
#
# keystone
#
COPY keystone.conf /etc/keystone/keystone.conf
COPY setup.sh /root/setup.sh
# httpd
#
RUN echo "ServerName keystone-server" >> /etc/apache2/apache2.conf

#
# keystoneの実行＆初期設定用
COPY ./exec.sh /root/exec.sh
RUN chmod +x /root/exec.sh /root/setup.sh

CMD ["/root/exec.sh"]

# keystoneのREST API
EXPOSE 5000
