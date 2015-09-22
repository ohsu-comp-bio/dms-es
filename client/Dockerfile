############################################################
# Dockerfile to build the ga4gh demo
# Based on CentOS7
############################################################
FROM centos:7

# File Author / Maintainer
MAINTAINER walsbr@ohsu.edu


################## BEGIN INSTALLATION ######################
# Install prereqs
RUN yum -y update && yum -y install \
  curl \
  git \
  python-backports \
  python-backports-ssl_match_hostname \
  python-devel \
  python-setuptools \
  tar \
  wget \
  zlib-devel \
  libffi-dev

RUN yum -y groupinstall "Development Tools"

RUN yum -y install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel mysql-devel \
  libffi-devel openssl-devel libxslt-devel libxml2-devel java

RUN yum clean all

RUN mkdir -p /root/
WORKDIR /root/

# Install pyenv, which works like rbenv:
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:$PATH"
RUN pyenv install 2.7.10 ; pyenv global 2.7.10
RUN pyenv rehash

RUN pip install -U pip



# make sure mime types are configured
RUN curl https://raw.githubusercontent.com/hashbang/shell-etc/master/mime.types > /etc/mime.types

# keep in sync with requirements.txt
RUN pip install xlrd
RUN pip install ipython
RUN pip install requests


##################### INSTALLATION END #####################
