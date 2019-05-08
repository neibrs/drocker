FROM jianhe/php

# Install system packages
RUN apt-get install -y \
  curl \
  git \
  unzip \
  sshpass \
  wget

#RUN apt-get install -y gnupg apt-transport-https && \
#  curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#  apt-get update && apt-get install -y yarn
RUN apt-get install -y gnupg apt-transport-https && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get install -y nodejs
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

# Mysql server config
COPY files/60-drupal.cnf /etc/mysql/conf.d/60-drupal.cnf

# Install Drupal
RUN rm -rf /var/www/html
ENV DRUPAL_VERSION 20190321
RUN git clone -b 8.8.x https://git.drupalcode.org/project/drupal.git /var/www/html

WORKDIR /var/www/html
ENV COMPOSER_PROCESS_TIMEOUT 1200
RUN composer install

# Manage localization on module install (import locales first, default language)
# https://www.drupal.org/project/drupal/issues/571380

# Patch: View output is not used for entityreference options
# https://www.drupal.org/node/2174633
#RUN wget https://www.drupal.org/files/issues/2174633-143-entity-reference.patch && \
#  patch -p1 < 2174633-143-entity-reference.patch && \
#  rm 2174633-143-entity-reference.patch

# StringFormatter generates links in wrong language when linking to entity
# https://www.drupal.org/project/drupal/issues/2648288
RUN wget https://www.drupal.org/files/issues/2019-03-23/2648288-string-formatter-30.patch && \
  patch -p1 < 2648288-string-formatter-30.patch && \
  rm 2648288-string-formatter-30.patch

# Add a language will never import the translation for modules
# https://www.drupal.org/project/drupal/issues/2654322
RUN wget https://www.drupal.org/files/issues/2654322-translation-import-2.patch && \
  patch -p1 < 2654322-translation-import-2.patch && \
  rm 2654322-translation-import-2.patch

# datetime_range: Allow end date to be optional
# https://www.drupal.org/project/drupal/issues/2794481
RUN wget https://www.drupal.org/files/issues/2018-05-14/2794481-60.patch && \
  patch -p1 < 2794481-60.patch && \
  rm 2794481-60.patch
COPY files/datetimerange.patch datetimerange.patch
RUN patch -p1 < datetimerange.patch && \
  rm datetimerange.patch

# EntityReferenceAutocompleteWidget getAutoCreateBundle unnecessarily requires target_bundles setting
# https://www.drupal.org/project/drupal/issues/2821352
RUN wget https://www.drupal.org/files/issues/2019-03-24/2821352-entity-reference-auto-create-12.patch && \
  patch -p1 < 2821352-entity-reference-auto-create-12.patch && \
  rm 2821352-entity-reference-auto-create-12.patch

# Patch: Can't create comments when comment is a base field
# https://www.drupal.org/project/drupal/issues/2855068
RUN wget https://www.drupal.org/files/issues/2855068-8_0.patch && \
  patch -p1 < 2855068-8_0.patch && \
  rm 2855068-8_0.patch

# Patch: Allow updating modules with new service dependencies
# https://www.drupal.org/project/drupal/issues/2863986
#RUN wget https://www.drupal.org/files/issues/2863986-2-49.patch && \
#  patch -p1 < 2863986-2-49.patch && \
#  rm 2863986-2-49.patch

# Patch: Enable block contextual link
# https://www.drupal.org/project/drupal/issues/2940015
RUN wget https://www.drupal.org/files/issues/2019-03-24/2940015-seven-theme-10.patch && \
  patch -p1 < 2940015-seven-theme-10.patch && \
  rm 2940015-seven-theme-10.patch

# Patch: TypeError: Argument 1 passed to _editor_get_file_uuids_by_field() must implement interface Drupal\\Core\\Entity\\EntityInterface
# https://www.drupal.org/project/drupal/issues/2974156
RUN wget https://www.drupal.org/files/issues/2018-11-08/2974156-editor-typeerror-9.patch && \
  patch -p1 < 2974156-editor-typeerror-9.patch && \
  rm 2974156-editor-typeerror-9.patch

# layout_bulider: Support third party settings for components within a section
# https://www.drupal.org/project/drupal/issues/3015152
RUN wget https://www.drupal.org/files/issues/2019-02-26/3015152-tps-5.patch && \
  patch -p1 < 3015152-tps-5.patch && \
  rm 3015152-tps-5.patch

# layout_builder: Blocks with fixed width elements can break multi-column Layout Builder layouts
# https://www.drupal.org/project/drupal/issues/3028979
RUN wget https://www.drupal.org/files/issues/2019-02-28/3028979.29.patch && \
  patch -p1 < 3028979.29.patch && \
  rm 3028979.29.patch

# Config entity label and other fields translation doesn't work
# https://www.drupal.org/project/drupal/issues/3030949
RUN wget https://www.drupal.org/files/issues/2019-02-17/config-entity-label-translation-3030949-16.patch && \
  patch -p1 < config-entity-label-translation-3030949-16.patch && \
	rm config-entity-label-translation-3030949-16.patch

# PHP 7.0 got error: Undefined class constant 'SOURCE_IDS_HASH'
# https://www.drupal.org/project/drupal/issues/3034599
RUN wget https://www.drupal.org/files/issues/2019-02-26/3034599-php70-6.patch && \
  patch -p1 < 3034599-php70-6.patch && \
  rm 3034599-php70-6.patch

# REST views: field alias should support human readable name
# https://www.drupal.org/project/drupal/issues/3038610

# locale: Could not update translation for an imported config
# https://www.drupal.org/project/drupal/issues/3040979
RUN wget https://www.drupal.org/files/issues/2019-03-18/3040979-updateConfigTranslations-2.patch && \
  patch -p1 < 3040979-updateConfigTranslations-2.patch && \
  rm 3040979-updateConfigTranslations-2.patch

# EntityReferenceLabelFormatter generates links in wrong language
# https://www.drupal.org/project/drupal/issues/3042392
RUN wget https://www.drupal.org/files/issues/2019-03-22/3042392-entity-reference-label-wrong-language-2.patch && \
  patch -p1 < 3042392-entity-reference-label-wrong-language-2.patch && \
  rm 3042392-entity-reference-label-wrong-language-2.patch

# views: The EntityOperations field plugin generate links in wrong language
# https://www.drupal.org/project/drupal/issues/3043057
RUN wget https://www.drupal.org/files/issues/2019-03-25/3043057-views-EntityOperations-language-5.patch && \
  patch -p1 < 3043057-views-EntityOperations-language-5.patch && \
  rm 3043057-views-EntityOperations-language-5.patch

# Install Drupal modules
RUN composer require \
  drupal/r4032login \
  drupal/address \
  drupal/ajax_links_api \
  drupal/block_style_plugins:dev-2.x \
	drupal/bootstrap \
  drupal/conditional_fields \
  drupal/custom_formatters \
  drupal/facets \
  drupal/features \
  drupal/field_formatter_class \
  drupal/field_group \
  drupal/inline_entity_form \
  drupal/pinyin \
  drupal/quicktabs \
  drupal/reference_table_formatter \
  drupal/rules \
  drupal/search_api_solr \
  drupal/token \
  drupal/token_filter

# ajax_links_api: No schema for ajax_links_api.admin_settings
# https://www.drupal.org/project/ajax_links_api/issues/3015840
RUN cd modules/contrib/ajax_links_api && \
  wget https://www.drupal.org/files/issues/2019-03-21/3015840-schema-2.patch && \
  patch -p1 < 3015840-schema-2.patch && \
  rm 3015840-schema-2.patch

# If PHP filter is empty, module should return TRUE and not execute code
# https://www.drupal.org/project/php/issues/2678430
#RUN cd modules/contrib/php && \
#  wget https://www.drupal.org/files/issues/php_condition_check_empty-2678430-13.patch && \
#  patch -p1 < php_condition_check_empty-2678430-13.patch && \
#  rm php_condition_check_empty-2678430-13.patch

# Install entity_print
RUN composer require drupal/entity_print \
  mikehaertl/phpwkhtmltopdf
# PDF generation errors with DomPDF due to drupalSettings
# https://www.drupal.org/project/entity_print/issues/2969184
RUN cd modules/contrib/entity_print && \
  wget https://www.drupal.org/files/issues/2018-05-03/entity_print-dompdf-2969184.patch && \
  patch -p1 < entity_print-dompdf-2969184.patch && \
  rm entity_print-dompdf-2969184.patch

# Install latest eva
RUN git clone https://git.drupal.org/project/eva.git -b 8.x-1.x /var/www/html/modules/contrib/eva

# Install field_widget_class
#RUN composer require drupal/field_widget_class
RUN git clone https://git.drupal.org/project/field_widget_class.git -b 8.x-1.x /var/www/html/modules/contrib/field_widget_class
# Patch: No hook alter to override Field Widget wrappers created by WidgetBase::form
# https://www.drupal.org/node/2872162
RUN wget https://www.drupal.org/files/issues/2872162-field-widget-hook-3.patch && \
  patch -p1 < 2872162-field-widget-hook-3.patch && \
  rm 2872162-field-widget-hook-3.patch

# Patch: Fatal error: Call to a member function buildMultiple() on null in EntityToTableRenderer.php
# https://www.drupal.org/project/reference_table_formatter/issues/2866712
RUN cd modules/contrib/reference_table_formatter && \
  wget https://www.drupal.org/files/issues/2866712-call-to-a-member-function-on-null-4.patch && \
  patch -p1 < 2866712-call-to-a-member-function-on-null-4.patch && \
  rm 2866712-call-to-a-member-function-on-null-4.patch

# Install drush
RUN composer require drush/drush

# Install Drupal site
RUN mkdir -p /var/www/html/sites/default/files && \
  chmod a+rw /var/www/html/sites/default -R && \
  cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php && \
  cp /var/www/html/sites/default/default.services.yml /var/www/html/sites/default/services.yml && \
  chmod a+rw /var/www/html/sites/default/settings.php && \
  chmod a+rw /var/www/html/sites/default/services.yml && \
  chown -R www-data:www-data /var/www/html/

# install-drupal.sh will setup /var/www/private as file_private_path, create it first
RUN mkdir -p /var/www/private && \
  chown -R www-data:www-data /var/www/private

RUN composer require drupal/console

# Install migrate modules
RUN composer require \
  drupal/csv_serialization \
  drupal/default_content \
  #drupal/migrate_plus \
  drupal/migrate_source_csv \
  drupal/migrate_source_xls \
  #drupal/migrate_tools \
  drupal/xls_serialization
# Install recent migrate_tools
RUN git clone https://git.drupal.org/project/migrate_tools.git /var/www/html/modules/contrib/migrate_tools
# Install recent migrate_plus module
RUN git clone https://git.drupal.org/project/migrate_plus.git /var/www/html/modules/contrib/migrate_plus

# PATCH: EntityGenerate does not process the values correctly
# https://www.drupal.org/node/2975266
# TODO
#RUN cd modules/contrib/migrate_plus && \
#  wget https://www.drupal.org/files/issues/2018-05-25/2975266-values-2.patch && \
#  patch -p1 < 2975266-values-2.patch && \
#  rm 2975266-values-2.patch

# migrate_source_xls: prepareColumns does not use the correct sheet_name defined by migration configuration
# https://www.drupal.org/project/migrate_source_xls/issues/2954462
RUN cd modules/contrib/migrate_source_xls && \
  wget https://www.drupal.org/files/issues/2019-03-23/2954462-sheet-name-3.patch && \
  patch -p1 < 2954462-sheet-name-3.patch && \
  rm 2954462-sheet-name-3.patch

# migrate_source_xls: Needs support constants defined in source configuration
# https://www.drupal.org/project/migrate_source_xls/issues/2954477
RUN cd modules/contrib/migrate_source_xls && \
  wget https://www.drupal.org/files/issues/2019-03-23/2954477-constants-3.patch && \
  patch -p1 < 2954477-constants-3.patch && \
  rm 2954477-constants-3.patch

# Install layout modules
RUN composer require \
  drupal/page_manager \
  drupal/panels \
  drupal/panelizer

# Page variants cannot be selected
# https://www.drupal.org/project/page_manager/issues/2868216
RUN cd modules/contrib/page_manager && \
  wget https://www.drupal.org/files/issues/page_manager-page_variants_selection-2868216-7.patch && \
  patch -p1 < page_manager-page_variants_selection-2868216-7.patch && \
  rm page_manager-page_variants_selection-2868216-7.patch

# Patch: Page Manager currently not working with CTools 3.1
# https://www.drupal.org/project/page_manager/issues/3033057
RUN cd modules/contrib/page_manager && \
  wget https://www.drupal.org/files/issues/2019-02-17/page_manager-user_tempstore_fix-3033057-3.patch && \
  patch -p1 < page_manager-user_tempstore_fix-3033057-3.patch && \
  rm page_manager-user_tempstore_fix-3033057-3.patch

# Patch: Custom attributes in panels blocks
# https://www.drupal.org/node/2849867
RUN cd modules/contrib/panels && \
  wget https://www.drupal.org/files/issues/2849867-custom_attributes_in_panels_blocks-11.patch && \
  patch -p1 < 2849867-custom_attributes_in_panels_blocks-11.patch && \
  rm 2849867-custom_attributes_in_panels_blocks-11.patch

# Patch: Change panels store
# https://www.drupal.org/project/panels/issues/3031778
# TODO template delete
#RUN cd modules/contrib/panels && \
#  wget https://www.drupal.org/files/issues/2019-02-21/panels_tempstore-updated-3031778-37.patch && \
#  patch -p1 < panels_tempstore-updated-3031778-37.patch && \
#  rm panels_tempstore-updated-3031778-37.patch

# Install api-first modules
RUN composer require \
  #drupal/graphql \
  drupal/restui
  # [ERROR] Incomplete or missing schema for simple_oauth.oauth2_token.bundle.
  #drupal/simple_oauth

# Add missing @group annotations for several test classes.
# https://github.com/drupal-graphql/graphql/pull/679
RUN composer require webonyx/graphql-php && \
  git clone https://github.com/drupal-graphql/graphql.git /var/www/html/modules/contrib/graphql

# Configuration management
RUN composer require drupal/config_rewrite

# Install memcache modules
RUN composer require \
  drupal/memcache
COPY files/settings.memcache.php sites/default/settings.memcache.php

# Install varnish_purge
RUN composer require \
  drupal/purge \
  drupal/varnish_purge


RUN composer require \
  drupal/ajax_links_api \
#  drupal/block_class \
  drupal/coffee \
  drupal/commerce \
  drupal/commerce_recurring:1.x-dev \
  drupal/commerce_alipay \
  drupal/commerce_autosku \
  drupal/commerce_paypal \
#  drupal/conditional_fields \
  drupal/config_update \
  drupal/drush_language \
#  drupal/devel \
#  drupal/entity_print \
#  drupal/features \
#  drupal/field_formatter_class \
#  drupal/field_group \
##  drupal/field_widget_class \
#  drupal/image_delta_formatter \
#  drupal/languageicons \
  drupal/libraries \
  drupal/ludwig \
  drupal/login_destination \
  drupal/message \
  drupal/message_notify \
  drupal/message_subscribe \
#  drupal/page_manager \
#  drupal/panelizer \
#  drupal/panels \
#  drupal/search_api \
#  drupal/search_api_solr \
  drupal/superfish \
  drupal/views_slideshow \
  kgaut/potx

COPY files/install-drupal.sh install-drupal.sh
RUN chmod +x install-drupal.sh

# Finish
EXPOSE 80 3306 22 443
CMD exec supervisord -n

