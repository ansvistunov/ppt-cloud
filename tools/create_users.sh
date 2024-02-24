#!/usr/bin/env bash

USER=$1 # базовая часть имени пользователя
PASS=$2 # базовая часть пароля
N=$3    # количество пользователей
for (( i = 1; i <= $N; i++ )); do
    useradd "${USER}-$i" -m -s /bin/bash && $(echo "${USER}-$i:${PASS}_$i" |chpasswd)
    usermod -aG docker ${USER}-$i
    echo "User ${USER}-$i added!"
done