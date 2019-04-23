#!/bin/sh

docker build --no-cache -t nibs/drocker . && \
  docker push nibs/drocker
