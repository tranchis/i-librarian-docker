FROM firespring/apache2-php:7.2-official

RUN mkdir /usr/share/man/man1/
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y php libapache2-mod-php php-sqlite3 php-gd php-curl \
      php-xml php-intl php-json php-mbstring php-zip poppler-utils ghostscript tesseract-ocr libreoffice
RUN apt-get install -y wget

RUN mkdir /var/www/librarian
RUN wget -c https://github.com/mkucej/i-librarian-free/releases/download/5.0.7/I-Librarian-5.0.7-Linux.tar.xz -O - | tar -Jxf - -C /var/www/librarian
RUN chown -R www-data:www-data /var/www/librarian

COPY librarian.conf /etc/apache2/sites-enabled/

ENTRYPOINT ["/usr/local/bin/apache2-foreground"]
