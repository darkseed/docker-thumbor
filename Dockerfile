FROM ubuntu:14.04
MAINTAINER mulder.tom@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

ENV LC_ALL C.UTF-8

# Basic requirements
RUN apt-get -y install python-pip python-dev python-pycurl python-tornado python-crypto python-imaging python-numpy webp libpng-dev libtiff-dev libjasper-dev libjpeg-dev libtbb-dev

# Supervisord
RUN apt-get -y install supervisor
RUN pip install supervisor-stdout

# Thumbor
RUN pip install thumbor
RUN mkdir -p /var/www /var/log/supervisor /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apt-get -y install nginx

RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD nginx-thumbor.conf /etc/nginx/sites-available/default

ADD thumbor.conf /etc/thumbor.conf

VOLUME ["/var/www"]

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord", "-n"]
