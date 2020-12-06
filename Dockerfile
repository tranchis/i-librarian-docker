FROM ubuntu:18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 php libapache2-mod-php php-sqlite3 php-gd php-curl \
      php-xml php-intl php-json php-mbstring php-zip poppler-utils ghostscript tesseract-ocr libreoffice
RUN apt-get install -y wget

RUN mkdir /var/www/librarian
RUN wget -c https://github.com/mkucej/i-librarian-free/releases/download/5.6.1/I-Librarian-5.6.1-Linux.tar.xz -O - | tar -Jxf - -C /var/www/librarian
RUN chown -R www-data:www-data /var/www/librarian

COPY librarian.conf /etc/apache2/sites-enabled/000-default.conf
COPY php.ini /etc/php/7.2/apache2/
COPY php.ini /etc/php/7.2/cli/
COPY ports.conf /etc/apache2/ports.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2$SUFFIX.pid
ENV APACHE_RUN_DIR /var/run/apache2$SUFFIX
ENV APACHE_LOCK_DIR /var/lock/apache2$SUFFIX
# Only /var/log/apache2 is handled by /etc/logrotate.d/apache2.
ENV APACHE_LOG_DIR /var/log/apache2$SUFFIX

ENTRYPOINT ["apache2", "-DFOREGROUND"]
