# Container image that runs your code
#FROM alpine:3.10
#FROM mcr.microsoft.com/oryx/build:slim
FROM ahmelsayed/oryx:node-build

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
