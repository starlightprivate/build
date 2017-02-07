# build
Follow these steps to create and combined build for front and back end,  docker containers.

- git clone node-api repo
- git clone flashlighsforver repo
- git clone this (build) repo
- Move to node-api folder
- npm install
- npm build  
- Move to flashlightfover folder
- npm install
- gulp build
- Move to build folder
- ./build.sh
- docker-compose build
- dockcer-compose up

....
