#!/bin/sh -l

echo "Describing setup: "
echo "Application Source Folder: $1"
echo "Azure Function Source Folder: $2"
echo "Repository: $GITHUB_REPOSITORY"

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
zip -r -q /github/workspace/staticsitesoutput/app.zip .
cd /github/workspace/staticsitesoutput/api
zip -r -q /github/workspace/staticsitesoutput/api.zip .
echo "Done zipping artifacts"
cd /github/workspace/staticsitesoutput
echo $(ls)
echo "Uploading Zips"
