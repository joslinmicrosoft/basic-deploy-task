#!/bin/sh -l

echo "Describing setup: "
echo "Application Source Folder: $INPUT_APP-LOCATION"
echo "Azure Function Source Folder: $INPUT_AZURE-FUNCTION-LOCATION"
echo "Repository: $GITHUB_REPOSITORY"
echo "Ref: $GITHUB_REF"
echo "sha: $GITHUB_SHA"
echo "actor: $GITHUB_ACTOR"
echo "actor: $GITHUB_WORKSPACE"
echo "workflow: $GITHUB_WORKFLOW"
echo "head: $GITHUB_HEAD_REF"
echo "base: $GITHUB_BASE_REF"
echo "event: $GITHUB_EVENT_NAME"

cd $GITHUB_WORKSPACE
echo $(pwd)
echo $(ls)

cd /github/workspace/

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
