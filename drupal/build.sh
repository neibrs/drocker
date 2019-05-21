#!/bin/bash

docker-compose up -d drupal

docker rm -f drupal
docker run -d --name drupal neibrs/drocker:drupal
if [ -d ../web.old ]; then
  sudo rm -rf ../web.old
fi
if [ -d ../web ]; then
  mv ../web ../web.old
fi
sudo docker cp drupal:/var/www/html ../web
docker stop drupal
docker rm drupal

# For linux
#sudo chown -R apache.apache ../web
#sudo chmod -R g+w ../web

# For Mac
sudo chown -R $USER ../web
sudo chmod -R g+w ../web
