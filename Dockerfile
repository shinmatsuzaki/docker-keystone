FROM python:2.7.16

ENV VERSION=13.0.1

RUN set -x \
    && apt -y update \
    && apt install -y libffi-dev python-dev libssl-dev default-mysql-client python-mysqldb vim \
    && pip install pymysql \
    && pip install uwsgi

RUN DEBIAN_FRONTEND=noninteractive apt install -y keystone

#RUN curl -fSL https://github.com/openstack/keystone/archive/${VERSION}.tar.gz -o keystone-${VERSION}.tar.gz \
#    && tar xvf keystone-${VERSION}.tar.gz && cp -r ./keystone-13.0.1/etc/ /etc/keystone && cd keystone-${VERSION} \
#    && pip install -r requirements.txt \
#    && PBR_VERSION=${VERSION}  pip install . \
#    && pip install uwsgi \
#    && pip install python-openstackclient \
#    && cd - \
#    && rm -rf keystone-${VERSION}*

COPY keystone.conf /etc/keystone/keystone.conf
#COPY keystone.sql /root/keystone.sql

# Add bootstrap script and make it executable
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh && chmod a+x /etc/bootstrap.sh

WORKDIR /etc/keystone
ENTRYPOINT ["/etc/bootstrap.sh"]
EXPOSE 5000 35357
