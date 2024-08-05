#!/usr/bin/env bash

# Change to the directory that this script lives in
cd $(dirname "$0")

mkdir -p output

# Run the docker image
docker run \
    --env TENDERMINT_RPC_URL=$TENDERMINT_RPC_URL \
    --env LIGHT_NODE_URL=$LIGHT_NODE_URL \
    --env LIGHT_NODE_AUTH_TOKEN=$LIGHT_NODE_AUTH_TOKEN \
    --env SP1_PRIVATE_KEY=$SP1_PRIVATE_KEY \
    --env TRUSTED_BLOCK=$TRUSTED_BLOCK \
    --env TARGET_BLOCK=$TARGET_BLOCK \
    --env NAMESPACE=$NAMESPACE \
    --env COMMITMENT=$COMMITMENT \
      --mount type=bind,source="$(pwd)"/output,target=/output/ \
    mina_celestia 
