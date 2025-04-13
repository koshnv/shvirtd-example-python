#!/bin/bash

# flock для предотвращения одновременного запуска
exec 200>/var/lock/backup_mysql.lock
flock -n 200 || { echo "Скрипт уже выполняется, пропускаем запуск"; exit 1; }

BACKUP_DIR="/opt/backup"

DB_NAME="virtd"

DB_HOST="db"

# Не палим пароль, буру из файла .env
if [ -f "/opt/shvirtd-example-python/.env" ]; then
    source /opt/shvirtd-example-python/.env
else
    echo "Ошибка: файл .env не найден в /opt/shvirtd-example-python/"
    exit 1
fi

# Проверка переменных
if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "Ошибка: переменные MYSQL_USER и/или MYSQL_PASSWORD не установлены"
    exit 1
fi

# Имя файла для резервной копии
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql"

# Стартую контейнер
docker run --rm \
    --network shvirtd-example-python_backend \
    --env MYSQL_PWD="$MYSQL_PASSWORD" \
    mysql:8 \
    mysqldump -h "$DB_HOST" -u "$MYSQL_USER" --no-tablespaces "$DB_NAME" > "$BACKUP_FILE"

# Проверка создания копии
if [ $? -eq 0 ]; then
    echo "Резервная копия создана: $BACKUP_FILE"
else
    echo "Ошибка при создании резервной копии"
    exit 1
fi