FROM ubuntu:18.04
ENV DOCKERFILE_VERSION v1
ENV VERSION 2

# install software
RUN apt-get update -yqq
RUN apt-get -yqq install software-properties-common
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update -yqq

RUN apt-get -yqq install python3
RUN apt-get -yqq install python3-pip
RUN apt-get -yqq install git
RUN apt-get -yqq install ssh
RUN apt-get -yqq install openssh-client
RUN apt-get -yqq install ansible
RUN apt-get -yqq install curl wget unzip
RUN apt-get -yqq install rsync


# install node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN  apt-get install -y nodejs
RUN node --version
RUN npm --version

# install aws cli
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime
RUN python3 -m pip install awscli --upgrade --user
RUN ln -s /root/.local/bin/aws /usr/local/bin
RUN aws --version

# install terraform
RUN wget https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
RUN unzip terraform_0.12.28_linux_amd64.zip
RUN mv terraform /usr/local/bin/ && unlink terraform_0.12.28_linux_amd64.zip
RUN terraform --version

# clear apt cache
RUN rm -rf /var/lib/apt/lists/*
