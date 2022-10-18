#!/bin/bash

for file in `find good -name '*.json'`
do
    echo $file
    curl -XPOST "http://localhost:4080/api/_bulkv2" -H "Content-Type: application/json" -u admin:Complexpass#123 --data @$file
    echo ''
done

