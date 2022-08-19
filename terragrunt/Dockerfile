FROM golang:alpine
LABEL org.opencontainers.image.authors="docker@binx.io"

ARG TERRAGRUNT_VERSION

RUN apk add --update bash

ADD https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 /usr/local/bin/terragrunt

RUN chmod +x /usr/local/bin/terragrunt
