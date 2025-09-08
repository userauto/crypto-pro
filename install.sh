#!/bin/bash

#Разрешить контейнеру доступ к серверу X11
#xhost +local:

# Сборка и запуск Криптопро
docker compose up -d --build && sleep 2 

# Подключение к контейнеру после запуска, для доступа к cli Крипто-Про
docker exec -it cryptopro /bin/bash
