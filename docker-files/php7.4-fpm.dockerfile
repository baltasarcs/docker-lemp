FROM php:7.4-fpm

MAINTAINER Baltasar Santos <baltasarc.s@gmail.com>

# Additional tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl \
    libssl-dev \
    openssl \
    git \
    unzip

# Common php-ext and requirements
RUN apt-get install -y --no-install-recommends libpq-dev libz-dev \
 && docker-php-ext-install pcntl \
 && docker-php-ext-install session \
 && docker-php-ext-install phar \
 && docker-php-ext-install iconv \
 && docker-php-ext-install pdo

#####################################
# GD:
#####################################

ARG INSTALL_GD=false
RUN if [ ${INSTALL_GD} = true ]; then \
    # Install gd and requirements
    apt-get install -y --no-install-recommends libpng-dev libjpeg62-turbo-dev libfreetype6-dev \
 # && docker-php-ext-configure gd --with-freetype --with-jpg \
 && docker-php-ext-install gd \
;fi

#####################################
# FTP:
#####################################

ARG INSTALL_FTP=false
RUN if [ ${INSTALL_FTP} = true ]; then \
    # Install ftp
    docker-php-ext-install ftp \
;fi

#####################################
# Mbstring:
#####################################

ARG INSTALL_MBSTRING=false
RUN if [ ${INSTALL_MBSTRING} = true ]; then \
    # Install mbstring
    apt-get install -y --no-install-recommends libonig-dev \
    && docker-php-ext-install mbstring \
;fi

#####################################
# PDO_MYSQL:
#####################################

ARG INSTALL_PDO_MYSQL=false
RUN if [ ${INSTALL_PDO_MYSQL} = true ]; then \
    # Install pdo_mysql
    docker-php-ext-install pdo_mysql mysqli \
;fi

#####################################
# PDO_POSTGRESQL:
#####################################

ARG INSTALL_PDO_POSTGRESQL=false
RUN if [ ${INSTALL_PDO_POSTGRESQL} = true ]; then \
    # Install pdo_pgsql
    docker-php-ext-install pdo_pgsql \
;fi

#####################################
# PDO_ORACLE:
#####################################

#ARG INSTALL_PDO_ORACLE=false
#RUN if [ ${INSTALL_PDO_ORACLE} = true ]; then \
#COPY instantclient-basic-linux.x64-19.5.0.0.0dbru.zip /opt/oracle/instantclient-basic-linux.x64-19.5.0.0.0dbru.zip
#COPY instantclient-sdk-linux.x64-19.5.0.0.0dbru.zip /opt/oracle/instantclient-sdk-linux.x64-19.5.0.0.0dbru.zip
#RUN unzip /opt/oracle/instantclient-basic-linux.x64-19.5.0.0.0dbru.zip -d /opt/oracle \
#    unzip /opt/oracle/instantclient-sdk-linux.x64-19.5.0.0.0dbru.zip -d /opt/oracle \
#    && ln -s /opt/oracle/instantclient_19_5/libclntsh.so.12.1 /opt/oracle/instantclient_19_1/libclntsh.so \
#    && ln -s /opt/oracle/instantclient_19_5/libclntshcore.so.19.1 /opt/oracle/instantclient_19_1/libclntshcore.so \
#    && ln -s /opt/oracle/instantclient_19_5/libocci.so.12.1 /opt/oracle/instantclient_19_1/libocci.so \
#    && rm -rf /opt/oracle/*.zip
#RUN echo 'instantclient,/opt/oracle/instantclient_19_5/' | pecl install oci8 \
#    RUN docker-php-ext-install pdo_oci \
#;fi

#####################################
# bcmath:
#####################################

ARG INSTALL_BCMATH=false
RUN if [ ${INSTALL_BCMATH} = true ]; then \
    # Install bcmath extension
    docker-php-ext-install bcmath \
;fi

#####################################
# Opcache:
#####################################

ARG INSTALL_OPCACHE=false
RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    docker-php-ext-install opcache \
;fi

# Copy opcache configration
# COPY ./../php/7.4-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

#####################################
# xdebug:
#####################################

ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    # Install the xdebug
    pecl install xdebug \
    docker-php-ext-enable xdebug \
;fi

# Copy xdebug configration
# COPY ./../php/7.4-fpm/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

#####################################
# composer:
#####################################

ARG INSTALL_COMPOSER=false
RUN if [ ${INSTALL_COMPOSER} = true ]; then \
    # Install the composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
;fi

#####################################
# tokenizer:
#####################################

ARG INSTALL_TOKENIZER=false
RUN if [ ${INSTALL_TOKENIZER} = true ]; then \
    # Install tokenizer
    docker-php-ext-install tokenizer \
;fi

#####################################
# json, xml, dom xmlrpc, xsl:
#####################################

ARG INSTALL_JSON_XML=false
RUN if [ ${INSTALL_JSON_XML} = true ]; then \
    # Install xml, dom xmlrpc, xsl, and requirements
    apt-get install -y --no-install-recommends libxml2-dev libxslt-dev \
    && docker-php-ext-install json xml dom xmlrpc xsl \
;fi

# Clear package lists
RUN rm -rf /var/lib/apt/lists/*

# clear source
RUN docker-php-source delete

# Permissions
RUN chown -R root:www-data /var/www/html
RUN chmod u+rwx,g+rx,o+rx /var/www/html
RUN find /var/www/html -type d -exec chmod u+rwx,g+rx,o+rx {} +
RUN find /var/www/html -type f -exec chmod u+rw,g+rw,o+r {} +

CMD ["php-fpm"]

EXPOSE 9000 80
