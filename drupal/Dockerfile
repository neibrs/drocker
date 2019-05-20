FROM neibrs/docker
#drupal:fpm-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

RUN set -ex \
  && apk add --no-cache \
        bash \
        git \
        curl \
        wget \
  && rm -rf /var/cache/apk/*

## TODO ADD yarn

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV COMPOSER_PROCESS_TIMEOUT 1200
######################################################
# Install Drupal
######################################################
RUN git clone -b 8.8.x https://github.com/drupal/drupal.git /var/www/drupal
###########################################################################
# Add Project
###########################################################################
RUN git clone -b 8.x-1.x https://git.drupalcode.org/project/neibrs.git /var/www/drupal/profiles/neibrs

WORKDIR /var/www/drupal
## Use composer china mirror.
RUN composer config -g repo.packagist composer https://packagist.laravel-china.org && \
  composer install

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


# Patch: TypeError: Argument 1 passed to _editor_get_file_uuids_by_field()
# https://www.drupal.org/project/drupal/issues/2974156
RUN wget https://www.drupal.org/files/issues/2018-11-08/2974156-editor-typeerror-9.patch && \
  git apply -v 2974156-editor-typeerror-9.patch && \
  rm 2974156-editor-typeerror-9.patch

# Patch: Can't create comments when comment is a base field
# https://www.drupal.org/project/drupal/issues/2855068
RUN wget https://www.drupal.org/files/issues/2855068-8_0.patch && \
  git apply -v 2855068-8_0.patch && \
  rm 2855068-8_0.patch

# Patch: Allow row header for views-view-table.html.twig
# Add support for tables with two headers in views table display
# Reference by: https://www.drupal.org/project/drupal/issues/2770835
RUN wget https://www.drupal.org/files/issues/2018-04-10/2770835-63.patch && \
  git apply -v 2770835-63.patch && \
  rm 2770835-63.patch

RUN cd modules/contrib/login_destination && \
#    git init && \
#    git add  . && \
#    git commit -m 'fix' && \
    wget https://www.drupal.org/files/issues/2018-04-19/login_destination-set-options-on-null-error-2947616-21.patch && \
    git apply -v login_destination-set-options-on-null-error-2947616-21.patch && \
    rm login_destination-set-options-on-null-error-2947616-21.patch

# Patch: Incompatible declaration of Drupal\migrate\Plugin\migrate\source\SqlBase::count()
RUN cd modules/contrib/migrate_source_xls && \
    wget https://www.drupal.org/files/issues/2018-10-09/3005241.patch && \
    git apply -v 3005241.patch && \
    rm 3005241.patch

# Patch: The configuration property label.0 doesn't exist
RUN cd modules/contrib/migrate_source_xls && \
    wget https://www.drupal.org/files/issues/2018-08-22/2933306-config_entity-4.patch && \
    git apply -v 2933306-config_entity-4.patch && \
    rm 2933306-config_entity-4.patch

COPY settings.local.php /var/www/drupal/sites/default/settings.local.php

# Install Drupal site
RUN mkdir -p /var/www/drupal/sites/default/files && \
  chmod a+rw /var/www/drupal/sites/default -R && \
  cp /var/www/drupal/sites/default/default.settings.php /var/www/drupal/sites/default/settings.php && \
  cp /var/www/drupal/sites/default/default.services.yml /var/www/drupal/sites/default/services.yml && \
  chmod a+rw /var/www/drupal/sites/default/settings.php && \
  chmod a+rw /var/www/drupal/sites/default/services.yml && \
  chown -R root:root /var/www/drupal/

RUN mkdir -p /var/www/private && \
  chown -R root:root /var/www/private && \
  echo "\$settings['file_private_path'] = '/Users/nie/tmp';" >> /var/www/drupal/sites/default/settings.php

#RUN cd /var/www/drupal/profiles/neibrs/theme/isp/themes/smart && \
#  yarn install

# Set default work directory
WORKDIR /var/www/drupal
