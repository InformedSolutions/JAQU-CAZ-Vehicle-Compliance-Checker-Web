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
    sleep 10;
    echo "Waiting for build number ${build_id} to be returned by remote host...";
fi
done
