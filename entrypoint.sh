#!/bin/sh -l

echo "Cloning repository"
curl "https://github.com/miwebst/ReactSite/archive/a2226e70d6ce57295d336431ab41a6c91b48f00c.zip" -L -o source.zip
echo "Cloned repository"
echo $(ls)
unzip -qq source.zip
echo "Successfully unzipped repository"
echo $(ls)
cd ReactSite-a2226e70d6ce57295d336431ab41a6c91b48f00c
echo $(ls)
echo "Building app folder"
oryx build app -o ../staticsitesoutput/app.zip
echo "Successfully built app folder"

echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time
