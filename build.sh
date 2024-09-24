#!/usr/bin/env bash

# Change to the directory that this script lives in
cd $(dirname "$0")

# Clone private repos

mkdir -p private_repos

cd private_repos

b_src="blob-stream-inclusion.tar.gz"
if [ ! -f $b_src ]
then
    rm -rf blob-stream-inclusion
    git clone https://github.com/geometers/blob-stream-inclusion.git
    cd blob-stream-inclusion
    git checkout 109720c08a9426dc62eb6c76ff757b7655d2feba
    rm -rf .git
    cd ..
    tar -czf $b_src blob-stream-inclusion
    rm -rf blob-stream-inclusion
fi

o_src="o1js-blobstream.tar.gz"
if [ ! -f $o_src ]
then
    rm -rf o1js-blobstream
    git clone https://github.com/geometers/o1js-blobstream.git
    cd o1js-blobstream
    git checkout 905821de40a44aed1635482aac13e884d43d09e1
    rm -rf .git
    cd ..
    tar -czf $o_src o1js-blobstream
    rm -rf o1js-blobstream
fi

cd ..

mkdir -p output

# Build the docker image
echo "Building docker image..."
docker build -t mina_celestia .
