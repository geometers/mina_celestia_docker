#!/usr/bin/env bash

# Change to the directory that this script lives in
cd $(dirname "$0")

# Run the docker image
docker run \
    --env LIGHT_NODE_URL=https://rpc.lunaroasis.net/ \
    --env SP1_PRIVATE_KEY=$SP1_PRIVATE_KEY \
    --env TRUSTED_BLOCK=$TRUSTED_BLOCK \
    --env TARGET_BLOCK=$TARGET_BLOCK \
    --env NAMESPACE=$NAMESPACE \
    --env COMMITMENT=$COMMITMENT \
    mina_celestia 
