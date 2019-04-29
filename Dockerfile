FROM ubuntu:18.04
ENV DOCKERFILE_VERSION v1

# install software
RUN apt-get update -yqq
RUN apt-get -yqq install software-properties-common
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update -yqq

RUN apt-get -yqq install python3
RUN apt-get -yqq install git
RUN apt-get -yqq install ssh
RUN apt-get -yqq install openssh-client
RUN apt-get -yqq install ansible

# clear apt cache
RUN rm -rf /var/lib/apt/lists/*
