FROM debian:bullseye-20230227

CMD ["bash"]

LABEL maintainer="Ehsan Mozaffari <Ehsan.Mozaffari@yahoo.com>"

ENV REFRESHED_AT=2023-03-18
ENV KAMAILIO_VERSION=5.5.6+bpo11
ENV SHM_MEMORY=64
ENV PKG_MEMORY=8

RUN rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -qq --assume-yes gnupg wget gpg sngrep iputils-ping net-tools # buildkit and sip track app


RUN echo "deb http://deb.kamailio.org/kamailio55 bullseye main" > /etc/apt/sources.list.d/kamailio.list # buildkit

RUN wget -O- http://deb.kamailio.org/kamailiodebkey.gpg | apt-key add - # buildkit
#RUN wget -O- http://deb.kamailio.org/kamailiodebkey.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/kamailio.gpg # buildkit

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq --assume-yes \
        kamailio=${KAMAILIO_VERSION} \
        kamailio-autheph-modules=${KAMAILIO_VERSION} \
        kamailio-berkeley-bin=${KAMAILIO_VERSION} \
        kamailio-berkeley-modules=${KAMAILIO_VERSION} \
        kamailio-cnxcc-modules=${KAMAILIO_VERSION} \
        kamailio-cpl-modules=${KAMAILIO_VERSION} \
        kamailio-dbg=${KAMAILIO_VERSION} \
        kamailio-erlang-modules=${KAMAILIO_VERSION} \
        kamailio-extra-modules=${KAMAILIO_VERSION} \
        kamailio-geoip-modules=${KAMAILIO_VERSION} \
        kamailio-geoip2-modules=${KAMAILIO_VERSION} \
        kamailio-ims-modules=${KAMAILIO_VERSION} \
        kamailio-json-modules=${KAMAILIO_VERSION} \
        kamailio-kazoo-modules=${KAMAILIO_VERSION} \
        kamailio-ldap-modules=${KAMAILIO_VERSION} \
        kamailio-lua-modules=${KAMAILIO_VERSION} \
        kamailio-lwsc-modules=${KAMAILIO_VERSION} \
        kamailio-memcached-modules=${KAMAILIO_VERSION} \
        kamailio-mongodb-modules=${KAMAILIO_VERSION} \
        kamailio-mono-modules=${KAMAILIO_VERSION} \
        kamailio-mqtt-modules=${KAMAILIO_VERSION} \
        kamailio-mysql-modules=${KAMAILIO_VERSION} \
        kamailio-nth=${KAMAILIO_VERSION} \
        kamailio-outbound-modules=${KAMAILIO_VERSION} \
        kamailio-perl-modules=${KAMAILIO_VERSION} \
        kamailio-phonenum-modules=${KAMAILIO_VERSION} \
        kamailio-postgres-modules=${KAMAILIO_VERSION} \
        kamailio-presence-modules=${KAMAILIO_VERSION} \
        kamailio-python-modules=${KAMAILIO_VERSION} \
        kamailio-python3-modules=${KAMAILIO_VERSION} \
        kamailio-rabbitmq-modules=${KAMAILIO_VERSION} \
        kamailio-radius-modules=${KAMAILIO_VERSION} \
        kamailio-redis-modules=${KAMAILIO_VERSION} \
        kamailio-ruby-modules=${KAMAILIO_VERSION} \
        kamailio-sctp-modules=${KAMAILIO_VERSION} \
        kamailio-secsipid-modules=${KAMAILIO_VERSION} \
        kamailio-snmpstats-modules=${KAMAILIO_VERSION} \
        kamailio-sqlite-modules=${KAMAILIO_VERSION} \
        kamailio-systemd-modules=${KAMAILIO_VERSION} \
        kamailio-tls-modules=${KAMAILIO_VERSION} \
        kamailio-unixodbc-modules=${KAMAILIO_VERSION} \
        kamailio-utils-modules=${KAMAILIO_VERSION} \
        kamailio-websocket-modules=${KAMAILIO_VERSION} \
        kamailio-xml-modules=${KAMAILIO_VERSION} \
        kamailio-xmpp-modules=${KAMAILIO_VERSION} # buildkit

VOLUME ["/etc/kamailio"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* # clean up

RUN echo "SIP_DOMAIN=sip.wesupported.com" >> /etc/kamailio/kamctlrc
RUN echo "DBENGINE=MYSQL" >> /etc/kamailio/kamctlrc
RUN echo "DBHOST=db" >> /etc/kamailio/kamctlrc
RUN echo "DBPORT=3306" >> /etc/kamailio/kamctlrc
RUN echo "DBNAME=kamailio" >> /etc/kamailio/kamctlrc
RUN echo "DBROOTUSER=root" >> /etc/kamailio/kamctlrc
RUN echo "DBROOTPW=rootpassword" >> /etc/kamailio/kamctlrc
RUN echo "DBINITASK=no" >> /etc/kamailio/kamctlrc
RUN echo "CHARSET="utf32"" >> /etc/kamailio/kamctlrc
RUN echo "INSTALL_EXTRA_TABLES=yes" >> /etc/kamailio/kamctlrc
RUN echo "INSTALL_DBUID_TABLES=yes" >> /etc/kamailio/kamctlrc
RUN echo "STORE_PLAINTEXT_PW=1" >> /etc/kamailio/kamctlrc

#RUN for i in a; do echo "$i"; done

#RUN kamdbctl create # Table creation

ENTRYPOINT ["/bin/sh","-c","kamailio -DD -E -m ${SHM_MEMORY} -M ${PKG_MEMORY}"]