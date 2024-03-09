#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "Usage: test_all file_name_to_upload_to_bucket"
    exit 1
fi
while read line
do
    IFS=';' read -ra args_array <<< "$line"
    ./test.sh ${args_array[2]} "$1" "${args_array[0]}"  "${args_array[1]}"  
done < data.txt