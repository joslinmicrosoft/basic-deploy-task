#!/bin/sh -l

echo "Cloning repository"
curl "https://github.com/miwebst/ReactSite/archive/a2226e70d6ce57295d336431ab41a6c91b48f00c.zip" -L -o source.zip
echo "Cloned repository"
unzip -qq source.zip
echo "Successfully unzipped repository"
cd ReactSite-a2226e70d6ce57295d336431ab41a6c91b48f00c

# Build App Folder
echo "Building app folder"
oryx build app -o /github/workspace/staticsitesoutput/app
echo "Successfully built app folder"

# Build Api Folder
echo "Building api folder"
oryx build api -o /github/workspace/staticsitesoutput/api
echo "Successfully built api folder"

# Zip Artifacts
echo "Zipping artifacts"
cd /github/workspace/staticsitesoutput/app/build
zip -r /github/workspace/staticsitesoutput/app.zip .
cd /github/workspace/staticsitesoutput/api/build
zip -r /github/workspace/staticsitesoutput/api.zip .
echo "Done zipping artifacts"
cd /github/workspace/staticsitesoutput
echo $(ls)