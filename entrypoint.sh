#!/bin/sh -l

echo "Starting to deploy something"
echo $(ls)
echo "Done listing"

echo "Hello $1"
time=$(date)
echo ::set-output name=time::$time
