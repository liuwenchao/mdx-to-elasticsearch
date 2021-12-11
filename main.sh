#!/bin/bash

if [[ $# < 1 ]]; then
    echo "Usage: ./main.sh your_mdx_file_name";
    echo "i.e. ./main.sh test.mdx";
    exit 0
fi


# 1. mdx to html
echo "extracting from $1"
mdict -x $1

# 2. html to txt
echo "removing HTML tags from $1.txt"
sed 's/<[^<>]*>//g' $1.txt > $1.pure.txt

# 3. txt to ES json
echo "writing ES bulk json to $1.json"
TOTAL=$(wc -l $1.pure.txt)
LNO=0 #Line Number
TYPE=`cut -d . -f 1 <<< $1`
echo '' > $1.json
k=""

while read line; do
#   printf  '%s: %s \n' "$LNO" "$line"
  case $((LNO%3)) in
    0)
        k=${line//[$'\r\n']}
        echo "{\"index\": {\"_index\": \"dict\", \"_type\": \"dict\"}" >> $1.json ;;
    1)
        v=${line//[$'\r\n']}
        echo "{\"k\":\"$k\", \"v\":\"$v\"}" >> $1.json ;;
    2)
        echo -ne "$LNO/$TOTAL \033[0K\r"
        sleep .0001;;
  esac
  let LNO++
done < $1.pure.txt
echo "$TOTAL"
echo "$1.json is ready!"

# 4. json to ES index
echo "bulk uploading to ES"
curl -H "Content-Type: application/json" -XPOST "localhost:9200/$TYPE/_bulk?pretty&refresh" --data-binary "@$1.json" > result.log
echo "check result.log for result"
echo "Finished!"