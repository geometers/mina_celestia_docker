#!/usr/bin/env bash

cd /
echo "SP1_PRIVATE_KEY=$SP1_PRIVATE_KEY" >> /blob-stream-inclusion/.env
echo "LIGHT_NODE_URL=$LIGHT_NODE_URL" >> /blob-stream-inclusion/.env
echo "TENDERMINT_RPC_URL=$TENDERMINT_RPC_URL" >> /blob-stream-inclusion/.env
echo "LIGHT_NODE_AUTH_TOKEN=$LIGHT_NODE_AUTH_TOKEN" >> /blob-stream-inclusion/.env

echo [{\"block_height\": $COMMITMENT_BLOCK, \"commitment\": \"$COMMITMENT\", \"namespace\": \"$NAMESPACE\"}] > /requests.json

# Needed to print cycles
RUST_LOG=info

echo "Generating blob inclusion proof"
echo
cd /blob-stream-inclusion/blob_inclusion/script
rm requests.json

#cargo run --release --features native-gnark -- \
RUST_LOG=info ./target/release/prove \
    --start-height=$TRUSTED_BLOCK \
    --end-height=$TARGET_BLOCK \
    --num-requests=1 \
    --request-path=/requests.json

if [ ! -f /blob-stream-inclusion/blob_inclusion/script/proof-with-pis.json ]; then
    echo "Blob inclusion proof could not be generated"
    exit 1
fi

echo "Generating blobstream proof"
echo
cd /blob-stream-inclusion/blobstream/script
##cargo run --release --features native-gnark -- \
RUST_LOG=info ./target/release/prove \
    --trusted-block=$TRUSTED_BLOCK \
    --target-block=$TARGET_BLOCK

if [ ! -f /blob-stream-inclusion/blobstream/script/proof-with-pis.json ]; then
    echo "Blobstream proof could not be generated"
    exit 1
fi

echo "Deleting example proofs from o1js-blobstream/scripts/blobstream_example/"
echo
rm /o1js-blobstream/scripts/blobstream_example/blobstreamSP1Proof.json
rm /o1js-blobstream/scripts/blobstream_example/blobInclusionSP1Proof.json
cp /blob-stream-inclusion/blobstream/script/proof-with-pis.json /o1js-blobstream/scripts/blobstream_example/blobstreamSP1Proof.json
cp /blob-stream-inclusion/blob_inclusion/script/proof-with-pis.json /o1js-blobstream/scripts/blobstream_example/blobInclusionSP1Proof.json

echo "Copying the SP1 proofs to output"
echo
cp /blob-stream-inclusion/blobstream/script/proof-with-pis.json /output/blobstreamSP1Proof.json
cp /blob-stream-inclusion/blob_inclusion/script/proof-with-pis.json /output/blobInclusionSP1Proof.json

echo "Running e2e_blobstream_inclusion.sh"
echo
export MAX_THREADS=4
cd /o1js-blobstream/scripts/blobstream_example/ && \
    bash ./e2e_blobstream_inclusion.sh

# Copy the final proof(s) to /output
cp /o1js-blobstream/scripts/blobstream_example/run/blobInclusion/e2e_plonk/proofs/layer5/p0.json /output/blob_inclusion_proof.json
cp /o1js-blobstream/scripts/blobstream_example/run/blobstream/e2e_plonk/proofs/layer5/p0.json /output/blobstream_proof.json
cp /o1js-blobstream/scripts/blobstream_example/run/batcherProof.json /output/batcher_proof.json
