#!/usr/bin/env bash

USER=$1 # базовая часть имени пользователя
PASS=$2 # базовая часть пароля

useradd "${USER}" -m -s /bin/bash && $(echo "${USER}:${PASS}_" |chpasswd)
usermod -aG docker ${USER}
echo "User ${USER} added!"