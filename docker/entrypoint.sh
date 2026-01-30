#!/bin/bash
set -e

# Define o diretório de imagens e o backup
DIR_IMG="/var/www/html/img"
DIR_BACKUP="/var/www/img_backup"

# Verifica se a pasta img está vazia (que acontece ao montar volume local vazio)
if [ -z "$(ls -A $DIR_IMG)" ]; then
    echo ">> Pasta img vazia detectada. Copiando imagens padrão..."
    
    # Copia do backup para a pasta montada
    cp -r $DIR_BACKUP/. $DIR_IMG/
    
    # Ajusta permissões para o Apache conseguir ler/escrever
    chown -R www-data:www-data $DIR_IMG
    echo ">> Imagens padrão restauradas."
else
    echo ">> Pasta img já contém arquivos. Nenhuma ação necessária."
fi

# Executa o comando principal do container (inicia o Apache)
exec "$@"