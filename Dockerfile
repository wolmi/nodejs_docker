FROM node:8-alpine

WORKDIR /

# Enable SSL
RUN apk --update add ca-certificates wget python curl tar

# Install gcloud and kubectl
# kubectl will be available at /google-cloud-sdk/bin/kubectl
# This is added to $PATH
ENV HOME /
ENV PATH /google-cloud-sdk/bin:$PATH
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app kubectl alpha beta
# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Helm plugins require git
# helm-diff requires bash, curl
RUN apk --update add git bash

# Install Docker daemon

RUN apk add docker

RUN npm i -g standard-version