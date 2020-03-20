FROM python:2.7.16

ENV VERSION=13.0.1

RUN set -x \
    && apt -y update \
    && apt install -y libffi-dev python-dev libssl-dev default-mysql-client python-mysqldb \
    && apt -y clean \
    && pip install pymysql

RUN curl -fSL https://github.com/openstack/keystone/archive/${VERSION}.tar.gz -o keystone-${VERSION}.tar.gz \
    && tar xvf keystone-${VERSION}.tar.gz && cp -r ./keystone-13.0.1/etc/ /etc/keystone && cd keystone-${VERSION} \
    && pip install -r requirements.txt \
    && PBR_VERSION=${VERSION}  pip install . \
    && pip install uwsgi \
    && pip install python-openstackclient \
    && cd - \
    && rm -rf keystone-${VERSION}*

COPY keystone.conf /etc/keystone/keystone.conf
COPY keystone.sql /root/keystone.sql

# Add bootstrap script and make it executable
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh && chmod a+x /etc/bootstrap.sh

WORKDIR /etc/keystone
ENTRYPOINT ["/etc/bootstrap.sh"]
EXPOSE 5000 35357

#HEALTHCHECK --interval=10s --timeout=5s \
#  CMD curl -f http://localhost:5000/v3 2> /dev/null || exit 1; \
#  curl -f http://localhost:35357/v3 2> /dev/null || exit 1; \


#######################################
#
# for VERSION, see https://releases.openstack.org/queens/index.html
#
# docker build -t openstack-keystone:queens .
#
# docker run -d -ti -p 35357:35357 --name keystone -p 5000:5000 openstack-keystone:queens
#
# curl http://localhost:5000/
# curl http://localhost:5000/v3
