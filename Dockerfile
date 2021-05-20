FROM python:3-alpine
WORKDIR /

RUN apk update && apk add --no-cache \
  bash \
  curl \
  git \
  jq \
  openssh \
  make \
  zip

RUN mkdir /root/.aws

## Install Pip Packages
RUN pip3 install --upgrade awscli wheel

## Install Terraform
ARG TERRAFORM_VERSION=0.14.10

RUN curl -L -o ./terraform.zip \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip -d /usr/local/bin ./terraform.zip && \
    rm terraform.zip

COPY assume-role.sh /usr/local/bin/assume-role

# Install SAML2AWS
RUN CURRENT_VERSION=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1) && \
    wget -c https://github.com/Versent/saml2aws/releases/download/v${CURRENT_VERSION}/saml2aws_${CURRENT_VERSION}_linux_amd64.tar.gz -O - | tar -xzv -C /usr/local/bin && \
    chmod u+x /usr/local/bin/saml2aws && \
    saml2aws --version

ENTRYPOINT "bash"
