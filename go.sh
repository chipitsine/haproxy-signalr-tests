#!/bin/bash


git clone https://github.com/haproxy/haproxy
cd haproxy
make -j3 CC=gcc TARGET=linux-glibc USE_OPENSSL=1
cp ../ws.config .
./haproxy -f ws.config -D
cd ..
git clone --recursive https://github.com/dotnet/aspnetcore
cd aspnetcore
patch -p1 < ../test.patch
eng/build.sh
source activate.sh
cd src/SignalR/clients/ts/FunctionalTests
dotnet build SignalR.Npm.FunctionalTests.npmproj
npm run test:inner || cat /root/.npm/_logs/*-debug.log
