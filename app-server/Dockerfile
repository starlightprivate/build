FROM node:6.9.4
RUN mkdir -p /src
ADD ./node-api  /src/node-api
ADD ./flashlightsforever  /src/flashlightsforever

RUN npm install -g babel-cli
RUN npm install -g gulp
WORKDIR /src/node-api
RUN npm install --only=dev
RUN npm run build

WORKDIR /src/flashlightsforever
RUN npm install
RUN gulp build

WORKDIR /src
RUN rm -rf app-server
RUN mkdir app-server
RUN cp -r ./node-api/.dist/* ./app-server
RUN rm -rf app-server/public
RUN mkdir ./app-server/public
RUN cp -r ./flashlightsforever/tacticalsales/*  ./app-server/public
WORKDIR ./app-server
RUN npm install
EXPOSE 8000
CMD ["npm","start"]