FROM ubuntu:18.04
RUN apt-get update
# install dependencies
RUN apt-get install apt-transport-https  -y &&  apt-get install ca-certificates  -y && apt-get install curl -y
RUN apt-get install gnupg-agent  -y
RUN apt-get install software-properties-common -y

# add Docker’s official GPG key
RUN curl -fsSL https:/download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update -y -allow-unauthenticated
RUN apt-get install -y docker-ce-cli -allow-unauthenticated
