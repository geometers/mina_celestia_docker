#!/usr/bin/env bash

# Change to the directory that this script lives in
cd $(dirname "$0")

# Clone private repos

mkdir -p private_repos

cd private_repos
rm -rf blob-stream-inclusion
git clone git@github.com:geometers/blob-stream-inclusion.git
cd blob-stream-inclusion
rm -rf .git
cd ..
tar -czf blob-stream-inclusion.tar.gz blob-stream-inclusion

rm -rf o1js-pairing
git clone git@github.com:geometers/o1js-pairing.git
cd o1js-pairing
rm -rf .git
cd ..
tar -czf o1js-pairing.tar.gz o1js-pairing
cd ..

# Build the docker image
echo "Building docker image..."
docker build -t mina_celestia .
