#!/bin/bash

Создаём каталог /opt и переходим в него
sudo mkdir -p /opt
cd /opt

# Клонируем репозиторий
echo "Клонируем репозиторий..."
sudo git clone https://github.com/koshnv/shvirtd-example-python.git
cd shvirtd-example-python
pwd

# Устанавливаем права на каталог
sudo chown -R $USER:$USER /opt/shvirtd-example-python

# Запускаем проект через Docker Compose
echo "Запускаем проект..."
docker compose up -d

# Выводим информацию о запущенных контейнерах
echo "Проект запущен. Список контейнеров:"
docker compose ps -a
