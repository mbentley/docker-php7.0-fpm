FROM alpine:3.9
MAINTAINER Matt Bentley <mbentley@mbentley.net>

# install typical php packages and then additional packages
RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories &&\
  apk add --no-cache bind-tools imagemagick@edge php7 php7-bz2 php7-ctype php7-curl php7-exif php7-fileinfo php7-gd php7-fpm php7-gettext php7-gmp php7-iconv php7-imagick php7-intl php7-imap php7-json php7-ldap php7-mbstring php7-mcrypt php7-memcached php7-mysqli php7-pecl-apcu php7-pecl-igbinary php7-pecl-imagick php7-pecl-redis php7-pdo php7-pdo_mysql php7-posix php7-simplexml php7-xml php7-xmlreader php7-xmlwriter php7-zip ssmtp wget whois &&\
  sed -i "s#listen = 127.0.0.1:9000#listen = /var/run/php/php-fpm7.sock#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^user = nobody#user = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^group = nobody#group = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.owner = nobody#listen.owner = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.group = nobody#listen.group = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.mode = 0660#listen.mode = 0660#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^;env#env#g" /etc/php7/php-fpm.d/www.conf &&\
  deluser xfs &&\
  mkdir /var/www &&\
  addgroup -g 33 www-data &&\
  adduser -D -u 33 -G www-data -s /sbin/nologin -H -h /var/www www-data &&\
  chown -R www-data:www-data /var/www

# add entrypoint script
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/php-fpm7","-F","--fpm-config","/etc/php7/php-fpm.conf"]
