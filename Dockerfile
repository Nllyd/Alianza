# Usa la imagen oficial de PHP con Apache como servidor web
FROM php:8.0-apache

# Instala las extensiones PHP necesarias para Laravel
RUN docker-php-ext-install pdo pdo_mysql

# Configura Apache para que sirva el sitio web de Laravel
COPY docker/apache-config.conf /etc/apache2/sites-available/000-default.conf

# Copia los archivos de tu proyecto Laravel al contenedor
COPY . /var/www/html

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Instala las dependencias de PHP utilizando Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader

# Cambia los permisos de los archivos y carpetas necesarios
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expone el puerto 80 para que Apache pueda servir la aplicación
EXPOSE 80

# Comando para iniciar Apache en el contenedor
CMD ["apache2-foreground"]
