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
    git clone git@github.com:geometers/blob-stream-inclusion.git
    cd blob-stream-inclusion
    rm -rf .git
    cd ..
    tar -czf $b_src blob-stream-inclusion
    rm -rf blob-stream-inclusion
fi

o_src="o1js-blobstream.tar.gz"
if [ ! -f $o_src ]
then
    rm -rf o1js-blobstream
    git clone git@github.com:geometers/o1js-blobstream.git
    cd o1js-blobstream
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
