FROM php:8.1-apache

# 1. Instalações
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mysqli zip gd mbstring

# 2. Apache config
RUN a2enmod rewrite

# 3. Define workdir
WORKDIR /var/www/html

# 4. Copia a aplicação
COPY src/ .

# 4.1 Cria uma pasta de backup e copia as imagens originais para lá
RUN mkdir -p /var/www/img_backup && cp -r /var/www/html/img/. /var/www/img_backup/

# 4.2 Copia o script de entrypoint para o container
COPY docker/entrypoint.sh /usr/local/bin/

# 4.3 Torna o script executável (garantia para Linux/Mac)
RUN chmod +x /usr/local/bin/entrypoint.sh

# 5. Ajustar permissões gerais
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 /var/www/html/img

# 6. Define o Entrypoint
ENTRYPOINT ["entrypoint.sh"]

# 7. Comando padrão (iniciar o apache)
CMD ["apache2-foreground"]