#!/bin/bash
# curl -XDELETE "http://localhost:4080/api/index/Dictionary" -u admin:Complexpass#123
echo ''

curl -XPOST "http://localhost:4080/api/index" -u admin:Complexpass#123 -d '{
    "name": "Dictionary",
    "storage_type": "disk",
    "shard_num": 1,
    "mappings": {
        "properties": {
            "1词语": {
                "type": "text",
                "index": true,
                "store": true,
                "highlightable": true
            },
            "2释义": {
                "type": "text",
                "index": true,
                "store": true,
                "highlightable": true
            },
            "来源": {
                "type": "keyword",
                "index": true,
                "sortable": true,
                "aggregatable": true
            }
        }
    }
}'
echo ''

for file in `find good -name '*.json'`
do
    echo $file
    # echo `curl -XPOST "http://localhost:4080/api/_bulkv2" -H "Content-Type: application/json" -u admin:Complexpass#123 --data @$file`
    # curl -XPOST "http://localhost:4080/api/_bulkv2" -H "Content-Type: application/json" -u admin:Complexpass#123 --data @$file
    echo ''
done

