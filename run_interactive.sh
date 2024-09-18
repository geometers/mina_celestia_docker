#!/usr/bin/env bash

## To run in interactive mode, it's recommended to disable the final command in the build script (CMD ["bash", "/start.sh"])

# Change to the directory that this script lives in
cd $(dirname "$0")

mkdir -p output

# Run the docker image
container_id=$(docker run \
    -itd \
    --env TENDERMINT_RPC_URL=$TENDERMINT_RPC_URL \
    --env LIGHT_NODE_URL=$LIGHT_NODE_URL \
    --env LIGHT_NODE_AUTH_TOKEN=$LIGHT_NODE_AUTH_TOKEN \
    --env SP1_PRIVATE_KEY=$SP1_PRIVATE_KEY \
    --env TRUSTED_BLOCK=$TRUSTED_BLOCK \
    --env TARGET_BLOCK=$TARGET_BLOCK \
    --env NAMESPACE=$NAMESPACE \
    --env COMMITMENT=$COMMITMENT \
    --env COMMITMENT_BLOCK=$COMMITMENT_BLOCK \
    --mount type=bind,source="$(pwd)"/output,target=/output/ \
    mina_celestia)

echo "Container ID: $container_id"

# run the interactive shell
docker exec -it $container_id /bin/bash
