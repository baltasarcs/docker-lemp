FROM php:7.4-fpm

MAINTAINER Baltasar Santos <baltasarc.s@gmail.com>

# Additional tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl \
    libssl-dev \
    openssl \
    git \
    unzip \
    libxml2-dev

# Common php-ext and requirements
RUN apt-get install -y --no-install-recommends libpq-dev libz-dev libzip-dev \
 && docker-php-ext-install pcntl \
 && docker-php-ext-install session \
 && docker-php-ext-install phar \
 && docker-php-ext-install iconv \
 && docker-php-ext-install pdo \
 && docker-php-ext-install zip \
 && docker-php-ext-install soap \
 && docker-php-ext-install intl

#####################################
# NPM:
#####################################

ARG INSTALL_NPM=false
RUN if [ ${INSTALL_NPM} = true ]; then \
    # install nodejs and npm
    curl -sL https://deb.nodesource.com/setup_15.x | bash - && apt-get install -y --no-install-recommends nodejs \
;fi

#####################################
# GD:
#####################################

ARG INSTALL_GD=false
RUN if [ ${INSTALL_GD} = true ]; then \
    # Install gd and requirements
    apt-get install -y --no-install-recommends libpng-dev libjpeg62-turbo-dev libfreetype6-dev && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-install gd \
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
# OCI8_PDO_ORACLE:
#####################################

ARG INSTALL_OCI8_PDO_ORACLE=false
RUN if [ ${INSTALL_OCI8_PDO_ORACLE} = true ]; then \
    # Install pdo_oracle and oci8
    apt-get install -y --no-install-recommends wget bsdtar libaio1 && \
    wget https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-basiclite-linux.x64-19.5.0.0.0dbru.zip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-sqlplus-linux.x64-19.5.0.0.0dbru.zip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-sdk-linux.x64-19.5.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-19.5.0.0.0dbru.zip -d /usr/local && \
    unzip instantclient-sqlplus-linux.x64-19.5.0.0.0dbru.zip -d /usr/local && \
    unzip instantclient-sdk-linux.x64-19.5.0.0.0dbru.zip -d /usr/local && \
    ln -s /usr/local/instantclient_19_5 /usr/local/instantclient && \
    #ln -s /usr/local/instantclient_19_5/libclntsh.so.19.1 /usr/local/instantclient/libclntsh.so && \
    ln -s /usr/local/instantclient_19_5/lib* /usr/lib && \
    ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
    rm -rf *.zip && \
    echo 'instantclient,/usr/local/instantclient/' | pecl install oci8-2.2.0 && \
    docker-php-ext-enable oci8 && \
    docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/local/instantclient && \
    docker-php-ext-install pdo_oci \
;fi

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

#####################################
# xdebug:
#####################################

ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pecl install xdebug && docker-php-ext-enable xdebug && \
    printf "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so) \n\
        	xdebug.remote_enable=on \n\
        	xdebug.remote_handler=dbgp \n\
        	xdebug.remote_port=9001 \n\
        	xdebug.remote_autostart=on \n\
        	xdebug.remote_connect_back=on \n\
        	xdebug.idekey=docker \n\
        	xdebug.remote_log=/var/log/xdebug.log \n\
        	xdebug.default_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    touch /var/log/xdebug.log && \
    chown www-data /var/log/xdebug.log \
;fi

# Clear package lists
RUN rm -rf /var/lib/apt/lists/* && apt-get autoremove

# clear source
RUN docker-php-source delete

# Permissions
RUN chown -R root:www-data /var/www/html
RUN chmod u+rwx,g+rx,o+rx /var/www/html
RUN find /var/www/html -type d -exec chmod u+rwx,g+rx,o+rx {} +
RUN find /var/www/html -type f -exec chmod u+rw,g+rw,o+r {} +

CMD ["php-fpm"]

EXPOSE 9000 9001
