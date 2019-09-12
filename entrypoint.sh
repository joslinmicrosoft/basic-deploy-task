#!/bin/sh -l

echo "Cloning repository"
curl "https://github.com/miwebst/ReactSite/archive/a2226e70d6ce57295d336431ab41a6c91b48f00c.zip" -L -o source.zip
echo "Cloned repository"
unzip -qq source.zip
echo "Successfully unzipped repository"
cd ReactSite-a2226e70d6ce57295d336431ab41a6c91b48f00c

# Build App Folder
echo "Building app folder"
oryx build app -o ../staticsitesoutput/app
echo "Successfully built app folder"

# Build Api Folder
echo "Building api folder"
oryx build api -o ../staticsitesoutput/api
echo "Successfully built api folder"

# Zip Artifacts
echo "Zipping artifacts"
cd ../staticsitesoutput/app/build
zip -r ../../app.zip .
cd ../api/build
zip -r ../../api.zip .
echo "Done zipping artifacts"
cd ../../
echo $(ls)