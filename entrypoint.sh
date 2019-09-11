#!/bin/sh -l

echo "Cloning repository"
curl "https://github.com/miwebst/ReactSite/archive/a2226e70d6ce57295d336431ab41a6c91b48f00c.zip" --output source.zip
echo "Cloned repository"
echo $(ls)
unzip source.zip
echo $(ls)

echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time
