#!/usr/bin/bashio
CONFIG_PATH=/data/options.json
for s in $(cat $CONFIG_PATH | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
    export $s
done

node /usr/src/app/dist/index.js