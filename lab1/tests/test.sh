#!/usr/bin/env bash
url=$1
student=$3
grp=$2
file_name=lab1test.txt
curl --silent --output /dev/null --form file=@$file_name $(curl $url | sed -E -n 's/.*(http[^"]+).+/\1/p')
# Триггер может работать какое-то время..
sleep 2
result=$(curl $url/list.html | grep $file_name  | wc -w)
#echo $result
if [ "$result" != "0" ]
then
    echo $grp $student ' SUCCESS' $url
else
    echo $grp $student ' FAILED' $url
fi