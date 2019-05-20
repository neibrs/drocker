#!/bin/bash

docker-compose up -d

docker rm -f drupal_alpine
docker run -d --name drupal_alpine neibrs/drupal_alpine
if [ -d ./web.old ]; then
  sudo rm -rf ./web.old
fi
if [ -d ./web ]; then
  mv ./web ./web.old
fi
sudo docker cp drupal_alpine:/var/www/html ./web
docker stop drupal_alpine
docker rm drupal_alpine

sudo chown -R apache.apache ./web
sudo chmod -R g+w ./web

