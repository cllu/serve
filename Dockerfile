FROM ubuntu:12.04
MAINTAINER Chunliang Lyu, hi@chunlianglyu.com

# Non-interactive front end when runing apt-get
ENV DEBIAN_FRONTEND noninteractive

# CUHK rocks
#RUN printf "deb http://ftp.cuhk.edu.hk/pub/Linux/ubuntu precise main universe\ndeb-src http://ftp.cuhk.edu.hk/pub/Linux/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe\ndeb-src http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# make sure we get basic package
RUN apt-get install -y curl apt-utils fakeroot

# MongoDB
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 # it may fails due to timeout
RUN cd /tmp && curl -O http://docs.mongodb.org/10gen-gpg-key.asc && apt-key add 10gen-gpg-key.asc
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list
RUN apt-get update && apt-get install -y mongodb-10gen=2.4.8

# Nginx
RUN cd /tmp && curl -O http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key
RUN echo 'deb http://nginx.org/packages/ubuntu/ precise nginx' > /etc/apt/sources.list.d/nginx.list
RUN apt-get update && apt-get install -y nginx

# Redis
RUN apt-get install -y redis-server

# Java, need to install fuse but has bugs
# https://github.com/dotcloud/docker/issues/514
RUN fakeroot apt-get install -y fuse && apt-get install -y openjdk-7-jdk

# Elastic Search
RUN cd /tmp && curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.9.tar.gz
RUN cd /opt && tar zxf /tmp/elasticsearch-0.90.9.tar.gz && ln -s elasticsearch-0.90.9 elasticsearch

# Python 3.3
RUN apt-get -y build-dep python3.2
RUN apt-get -y install libreadline-dev libncurses5-dev libssl1.0.0 tk8.5-dev zlib1g-dev liblzma-dev
RUN cd /tmp && curl -O http://www.python.org/ftp/python/3.3.3/Python-3.3.3.tgz
RUN cd /tmp && tar zxf Python-3.3.3.tgz && cd Python-3.3.3 && ./configure && make && make install

# install python packages, just install them globally with pip
RUN cd /tmp && curl -O http://python-distribute.org/distribute_setup.py && python3.3 distribute_setup.py && python3.3 -m easy_install pip
# install packages
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Supervisor
RUN apt-get install -y supervisor

# Start the entire enviroment with supervisor
ENTRYPOINT ["/usr/bin/supervisord"]
