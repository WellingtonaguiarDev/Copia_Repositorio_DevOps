FROM php:8.1-apache

RUN a2enmod rewrite headers

COPY ./apache/ /etc/apache2/sites-enabled/

WORKDIR /var/www/html/

COPY . .

EXPOSE 80

