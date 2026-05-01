#!/bin/bash
# Usage: sh count_lined.sh /path/to/

csv_dir=$1

for file in $csv_dir/*.csv; do
    echo "$file has $(wc -l < $file) lines"
done