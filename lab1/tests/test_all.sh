#!/bin/bash
while read line
do
    IFS=';' read -ra args_array <<< "$line"
    ./test.sh ${args_array[2]} ${args_array[0]} "${args_array[1]}" 
done < data.txt