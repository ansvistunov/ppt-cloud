#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "Usage: file_with_users"
    exit 1
fi
while read line
do
    ./delete_user.sh $line
done < $1