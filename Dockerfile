FROM php:8.2-apache

RUN apt-get update && apt-get upgrade -y

# Installation des extensions PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Activer les extensions PHP
RUN docker-php-ext-enable mysqli pdo pdo_mysql

EXPOSE 80