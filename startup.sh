#!/usr/bin/env bash

git clone https://github.com/n3phtys/ng-cervisia --depth 1
cd ng-cervisia
npm install --silent
ng build
cd ../
rm -rf /usr/cervisia/frontend
mkdir /usr/cervisia/frontend
ls -la /usr/cervisia/ng-cervisia
cp -a /usr/cervisia/ng-cervisia/dist/. /usr/cervisia/frontend/
rm -rf ng-cervisia

git clone https://github.com/n3phtys/cervisia-server --depth 1
cd cervisia-server 
cargo build
cd ../
rm -rf /usr/cervisia/backend
mkdir /usr/cervisia/backend
ls -la /usr/cervisia/cervisia-server/target/debug
cp -a /usr/cervisia/cervisia-server/target/debug/cervisia-server /usr/cervisia/backend/
rm -rf cervisia-server
/usr/cervisia/backend/cervisia-server