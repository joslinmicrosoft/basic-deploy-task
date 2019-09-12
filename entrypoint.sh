#!/bin/sh -l
echo "Application Source Folder: $INPUT_APP_LOCATION"
echo "Azure Function Source Folder: $INPUT_AZURE_FUNCTION_LOCATION"

SHOULD_BUILD_FUNCTION=true
cd $GITHUB_WORKSPACE

if [ ! -d "$INPUT_APP_LOCATION" ]; then
    echo "\e[31mCould not find application source folder: $INPUT_APP_LOCATION\e[0m"
    exit 1
fi

if [ ! -d "$INPUT_AZURE_FUNCTION_LOCATION" ]; then
	SHOULD_BUILD_FUNCTION=false
    echo "\e[33mCould not find the azure function source folder: $INPUT_AZURE_FUNCTION_LOCATION (This is safe to ignore if you are not using Azure Functions)\e[0m"
    exit 1
fi

# Build App Folder
echo "Building app folder"
oryx build app -o /github/staticsitesoutput/app
echo "Successfully built app folder"

# Zip App Folder
echo "Zipping app folder"
cd /github/staticsitesoutput/app
zip -r -q /github/staticsitesoutput/app.zip .
echo "Done zipping app folder"

# Build and Zip Api Folder
if [ SHOULD_BUILD_FUNCTION ]; then
	cd $GITHUB_WORKSPACE
	echo "Building api folder"
	oryx build api -o /github/staticsitesoutput/api
	echo "Successfully built api folder"

	echo "Zipping api folder"
	cd /github/staticsitesoutput/api
	zip -r -q /github/staticsitesoutput/api.zip .
	echo "Done zipping api folder"
fi


cd /github/staticsitesoutput
echo $(ls)
echo "Uploading Zips"
curl -F "file=@app.zip" https://testuploadfile20190910120552.azurewebsites.net/api/values/zip