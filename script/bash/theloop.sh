#!/bin/bash

# to run this
#bash <filename> 
#bash theloop.sh
# need double quotes to fully expand thru string
for file in *.csv; do
    echo "$file has $(wc -l $file) lines"
done


# <filename '<' this is standard in, 
# the file name is not output, simply used to compute


