#!/usr/bin/env bash
url=$1
student=$4
grp=$3
file_name=$2
curl --silent --output /dev/null --form file=@$file_name $(curl $url | sed -E -n 's/.*(http[^"]+).+/\1/p')
sleep 2
result=$(curl $url/list.html | grep $file_name  | wc -w)
#echo $result
if [ "$result" != "0" ]
then
    echo $grp $student ' SUCCESS' $url
else
    echo $grp $student ' FAILED' $url
fi