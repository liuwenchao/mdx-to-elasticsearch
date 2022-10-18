#!/bin/bash
# curl -XDELETE "http://localhost:4080/api/index/Dictionary" -u admin:Complexpass#123

for file in `find test -name '*.json'`
do
    echo $file
    # echo `curl -XPOST "http://localhost:4080/api/_bulkv2" -H "Content-Type: application/json" -u admin:Complexpass#123 --data @$file`
    curl -XPOST "http://localhost:4080/api/_bulkv2" -H "Content-Type: application/json" -u admin:Complexpass#123 --data @$file
    echo ''
done

