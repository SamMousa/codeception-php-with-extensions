FROM codeception/codeception

MAINTAINER Sam Mousa <sam@mousa.nl>

RUN docker-php-ext-install pdo pdo_mysql sockets pcntl

# Install php-intl
RUN apt-get update && \
    apt-get -y install --no-install-recommends libicu-dev && \
    docker-php-ext-install intl && \
    apt-get -y purge libicu-dev && \
    rm -rf /var/lib/apt/lists/*

# Install php-gd
RUN apt-get update && \
    apt-get -y install --no-install-recommends libjpeg-dev libpng-dev libfreetype6-dev && \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr && \
    docker-php-ext-install gd && \
    apt-get -y purge libpng-dev libfreetype6-dev && \
    rm -rf /var/lib/apt/lists/*

# Install sassc
RUN cd /tmp && \
    git clone https://github.com/sass/libsass.git && \
    export SASS_LIBSASS_PATH=/tmp/libsass && \
    git clone https://github.com/sass/sass-spec.git && \
    export SASS_SPEC_PATH=/tmp/sass-spec && \
    git clone https://github.com/sass/sassc.git && \
    cd libsass && \
    make && \
    cd .. && \
    cd sassc && \
    script/bootstrap && \
    make && \
    mv bin/sassc /bin/sassc && \
    rm -rf /tmp/*

# Install composer & fxp/composer-asset-plugin
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer && \
    composer -n global require fxp/composer-asset-plugin && \
    composer clear-cache

# Install wait-for-it
RUN cd /tmp && \
    git clone https://github.com/jlordiales/wait-for-it.git && \
    cp wait-for-it/wait-for-it.sh /bin && \
    rm -rf /tmp/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-client && \
    rm -rf /var/lib/apt/lists/*


# Install php wait-for-it
RUN cd /tmp && \
    git clone  --branch v0.5.1 https://github.com/SAM-IT/wait-for-it-php.git && \
    cd wait-for-it-php && \
    composer install && \
    php -d phar.readonly=0 build.php && \
    cp wait-for-it.phar /bin/wait-for-it && \
    rm -rf /tmp/*

ENTRYPOINT []