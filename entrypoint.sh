#!/bin/sh -l
echo "Application Source Folder: $INPUT_APP_SOURCE_LOCATION"
echo "Azure Function Source Folder: $INPUT_AZURE_FUNCTION_LOCATION"
echo "Auzure Pages Build Output Location: $INPUT_APP_BUILD_OUTPUT_LOCATION"
echo "Auzure Pages Build Host: $INPUT_AZURE_PAGES_BUILDHOST"
UPLOAD_HOST="https://$INPUT_AZURE_PAGES_BUILDHOST/api/upload?apiToken=$INPUT_AZURE_PAGES_API_TOKEN&apiVersion=$INPUT_AZURE_PAGES_API_VERSION"

SHOULD_BUILD_FUNCTION=true
cd $GITHUB_WORKSPACE

if [ ! -d "$INPUT_APP_SOURCE_LOCATION" ]; then
    echo "\e[31mCould not find application source folder: $INPUT_APP_SOURCE_LOCATION\e[0m"
    exit 1
fi

if [ ! -d "$INPUT_AZURE_FUNCTION_LOCATION" ]; then
	SHOULD_BUILD_FUNCTION=false
    echo "\e[33mCould not find the azure function source folder: $INPUT_AZURE_FUNCTION_LOCATION (This is safe to ignore if you are not using Azure Functions)\e[0m"
    exit 1
fi

# Build App Folder
echo "Building app folder"
oryx build $INPUT_APP_SOURCE_LOCATION -o /github/staticsitesoutput/app

if [ 0 -eq $? ]; then
	echo "\e[32mSuccessfully built app folder\e[0m"
else
	echo "\e[31mFailed to build application\e[0m"
    exit 1
fi;

# Zip App Folder
echo "Zipping app folder: $INPUT_APP_BUILD_OUTPUT_LOCATION"

cd /github/staticsitesoutput/app/$INPUT_APP_BUILD_OUTPUT_LOCATION
zip -r -q /github/staticsitesoutput/app.zip .
echo "\e[32mDone zipping app folder\e[0m"

# Build and Zip Api Folder
if [ SHOULD_BUILD_FUNCTION ]; then
	cd $GITHUB_WORKSPACE
	echo "Building api folder"
	oryx build $INPUT_AZURE_FUNCTION_LOCATION -o /github/staticsitesoutput/api

	if [ 0 -eq $? ]; then
		echo "\e[32mSuccessfully built api folder\e[0m"
	else
		echo "\e[31mFailed to build Azure function\e[0m"
	    exit 1
	fi;

	echo "Zipping api folder"
	cd /github/staticsitesoutput/api
	zip -r -q /github/staticsitesoutput/api.zip .
	echo "\e[32mDone zipping api folder\e[0m"
fi


cd /github/staticsitesoutput
echo "Uploading Zips"

if [ SHOULD_BUILD_FUNCTION ]; then
	curl -F "app=@app.zip" -F "event=@$GITHUB_EVENT_PATH" -F "api=@api.zip" $UPLOAD_HOST
else
	curl -F "app=@app.zip" -F "event=@$GITHUB_EVENT_PATH" $UPLOAD_HOST
fi

if [ 0 -eq $? ]; then
	echo "\e[32mSuccessfully uploaded zips\e[0m"
else
	echo "\e[31mFailed to upload zips\e[0m"
    exit 1
fi;
