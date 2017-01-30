#!/bin/sh

rm -rf app-server

mkdir app-server

cp -r ../node-api/.dist/* ./app-server

rm -rf app-server/public
mkdir ./app-server/public

cp -r ../flashlightsforever/tacticalsales/*  ./app-server/public

