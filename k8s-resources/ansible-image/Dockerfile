FROM jenkins/jenkins:lts
WORKDIR /Ansible
USER root
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main " >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install python -y --allow-unauthenticated
RUN apt-get install ansible -y --allow-unauthenticated






