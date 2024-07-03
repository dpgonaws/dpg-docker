# Base image for your application
#FROM ubuntu:20.04
FROM amazonlinux:latest

#FROM centos:7

RUN yum update
RUN yum install -y gettext


# Update package lists
#RUN apt-get update
#RUN yum update

#RUN yum install gnupg2

# Install dependencies (consider using specific versions if needed)
RUN yum install -y jq

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Make the downloaded binary executable
RUN chmod +x kubectl

# Move the binary to a standard location (optional)
RUN mv kubectl /usr/local/bin/kubectl

COPY EsignetEval.sh /

COPY esignet.properties /

RUN chmod +x /EsignetEval.sh

ENV AWS_KAFKA_ARN=

ENV DB_HOSTNAME=

ENV DB_PORT=

ENV DB_USERNAME=

ENV DB_PASSWORD=



CMD ["/bin/bash", "/EsignetEval.sh"]
