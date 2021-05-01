FROM python:3-alpine
WORKDIR /

RUN apk update && apk add --no-cache \
  bash \
  curl \
  git \
  jq \
  openssh \
  make \
  zip \
  gcc \
  g++ \
  python3-dev

RUN mkdir /root/.aws

## Install Pip Packages
RUN pip3 install --upgrade awscli wheel pytest pytest_mock pyspark pandas

## Install Terraform
ARG TERRAFORM_VERSION=0.14.10

RUN curl -L -o ./terraform.zip \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip -d /usr/local/bin ./terraform.zip && \
    rm terraform.zip

COPY assume-role.sh /usr/local/bin/assume-role

ENTRYPOINT "bash"
