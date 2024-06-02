# Utiliser l'image officielle PHP avec Apache
FROM php:8.2-apache

# Mettre à jour les packages et installer les extensions nécessaires
RUN apt-get update && apt-get upgrade -y

# Installer les extensions PHP nécessaires pour MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copier les fichiers de l'application dans le répertoire du serveur web
COPY . /var/www/html/

# Donner les permissions appropriées aux fichiers copiés
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exposer le port 80
EXPOSE 80

# Commande pour démarrer Apache (automatique avec l'image de base)
CMD ["apache2-foreground"]
