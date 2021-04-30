FROM digitalbits/base:latest

ENV DIGITALBITS_CORE_VERSION 1.0.5
ENV FRONTIER_VERSION 1.0.3

EXPOSE 5432
EXPOSE 8000
EXPOSE 11625
EXPOSE 11626

ADD dependencies /
RUN ["chmod", "+x", "dependencies"]
RUN /dependencies

ADD install /
RUN ["chmod", "+x", "install"]
RUN /install

RUN ["mkdir", "-p", "/opt/digitalbits"]
RUN ["touch", "/opt/digitalbits/.docker-ephemeral"]

RUN [ "adduser", \
  "--disabled-password", \
  "--gecos", "\"\"", \
  "--uid", "10011001", \
  "digitalbits"]

RUN ["ln", "-s", "/opt/digitalbits", "/digitalbits"]
RUN ["ln", "-s", "/opt/digitalbits/core/etc/digitalbits-core.cfg", "/digitalbits-core.cfg"]
RUN ["ln", "-s", "/opt/digitalbits/frontier/etc/frontier.env", "/frontier.env"]
ADD common /opt/digitalbits-default/common
ADD pubnet /opt/digitalbits-default/pubnet
ADD testnet /opt/digitalbits-default/testnet


ADD start /
RUN ["chmod", "+x", "start"]

ENTRYPOINT ["/init", "--", "/start" ]
