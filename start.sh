#!/usr/bin/env bash

cd /
echo "SP1_PRIVATE_KEY=$SP1_PRIVATE_KEY" >> /blob-stream-inclusion/.env
echo "LIGHT_NODE_URL=$LIGHT_NODE_URL" >> /blob-stream-inclusion/.env
echo "TENDERMINT_RPC_URL=$TENDERMINT_RPC_URL" >> /blob-stream-inclusion/.env
echo "LIGHT_NODE_AUTH_TOKEN=$LIGHT_NODE_AUTH_TOKEN" >> /blob-stream-inclusion/.env

echo '[{"block_height": $TARGET_BLOCK, "commitment": $COMMITMENT, "namespace": "$NAMESPACE"}]' > /requests.json


echo "Blobstream"
echo
cd /blob-stream-inclusion/blobstream/script
cargo run --release -- \
    --trusted-block=$TRUSTED_BLOCK \
    --target-block=$TARGET_BLOCK

echo "Blob inclusion"
echo
cd /blob-stream-inclusion/blob_inclusion/script
cargo run --release -- \
    --start-height=$TRUSTED_BLOCK \
    --end-height=$TARGET_BLOCK \
    --num-requests=1 \
    --request-path=/requests.json

export MAX_THREADS=4
cd /o1js-pairing/scripts/blobstream_example/ && \
    bash ./e2e_blobstream_inclusion.sh

# TODO: copy the final proof(s) to /output
