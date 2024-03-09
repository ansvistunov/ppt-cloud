#!/usr/bin/env bash

USER=$1 # базовая часть имени пользователя

userdel $USER -r
usermod -aG docker ${USER}
echo "User ${USER} deleted!"