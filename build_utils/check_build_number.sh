#!/bin/bash
check="false"

echo "Remote url $build_id_url"
echo "Checking build number on remote host"

until [ $check = "true" ]
do

if curl -s "$build_id_url" | grep "$build_id";
then
    echo "Build id found"
    exit
else
    sleep 5;
    echo "Waiting for build number ${build_id} to appear in remote response...";
fi
done
