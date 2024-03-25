#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "Usage: file_with_users"
    exit 1
fi
while read line
do
    ./create_user.sh "$line" "$2"
done < $1