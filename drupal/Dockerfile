FROM drupal:fpm-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

RUN set -ex \
  && apk add --no-cache \
        bash \
        git \
        curl \
        wget \
  && rm -rf /var/cache/apk/*

## TODO ADD yarn

ENV COMPOSER_PROCESS_TIMEOUT 1200
WORKDIR /var/www/html

RUN curl -sS https://install.phpcomposer.com/installer | php -- --install-dir=/usr/local/bin --filename=composer

## Use composer china mirror.
RUN composer install

###########################################################################
# Add Project Contribute Modules
###########################################################################

# Install Drupal modules
RUN composer require \
  drupal/address \
  drupal/ajax_links_api \
  drupal/block_class \
  drupal/block_style_plugins \
  drupal/bootstrap \
  drupal/charts \
  drupal/coffee \
#  drupal/commerce \
  drupal/commerce_recurring:1.x-dev \
  drupal/commerce_alipay \
  drupal/commerce_autosku \
  drupal/commerce_paypal \
  drupal/conditional_fields \
  drupal/console \
  drupal/config_rewrite \
  drupal/custom_formatters \
  drush/drush \
  drupal/drush_language \
  drupal/default_content \
  drupal/devel \
  drupal/entity_print \
  drupal/eva \
  drupal/facets \
  drupal/features \
  drupal/field_formatter_class \
  drupal/field_group \
#  drupal/field_widget_class \
  drupal/image_delta_formatter \
  drupal/inline_entity_form \
  drupal/languageicons \
  drupal/libraries \
  drupal/ludwig \
  drupal/login_destination \
  drupal/message \
  drupal/message_notify \
  drupal/message_subscribe \
  drupal/memcache \
  drupal/migrate_source_csv \
  drupal/migrate_source_xls \
  drupal/migrate_tools \
  drupal/page_manager \
  drupal/panelizer \
  drupal/panels \
  drupal/pinyin \
  drupal/quicktabs \
  drupal/reference_table_formatter \
  drupal/rules \
  drupal/search_api \
  drupal/search_api_solr \
  drupal/superfish \
  drupal/token \
  drupal/views_slideshow \
  kgaut/potx


# Install Drupal site
RUN mkdir -p /var/www/html/sites/default/files && \
  chmod a+rw /var/www/html/sites/default -R && \
  cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php && \
  cp /var/www/html/sites/default/default.services.yml /var/www/html/sites/default/services.yml && \
  chmod a+rw /var/www/html/sites/default/settings.php && \
  chmod a+rw /var/www/html/sites/default/services.yml && \
  chown -R root:root /var/www/html/

RUN mkdir -p /var/www/private && \
  chown -R root:root /var/www/private && \
  echo "\$settings['file_private_path'] = '/var/www/private';" >> /var/www/html/sites/default/settings.php

#RUN cd /var/www/html/profiles/neibrs/theme/isp/themes/smart && \
#  yarn install

# Set default work directory
WORKDIR /var/www/html
