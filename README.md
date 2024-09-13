# Docker setup for generating Celestia blobstream and blob inclusion proofs to run in Mina

This repository provides scripts that use Docker to generate Celestia
blobstream and blob inclusion proofs. The scripts and Dockerfile produce a Docker image that
handles all the system requirements.

You'll need:

1. A SP1 prover network private key
2. The public URL of a Celestia light node, and its auth token (if any)
3. The public URL of a Celestia full node

You'll also need the following inputs to generate the proofs:

1. The trusted Celestia block number
2. The target Celestia block number
3. The Celestia namespace
4. The blob commitment

## Getting started

Clone this repository, then run:

```bash
export SP1_PRIVATE_KEY=<your SP1 private key starting with 0x>
export TENDERMINT_RPC_URL=<the URL of a Celestia RPC, which must not be a light node. e.g. https://rpc.lunaroasis.net/>
export LIGHT_NODE_URL=<the URL of a Celestia a light node. Must not be a full node URL.>
export LIGHT_NODE_AUTH_TOKEN=<the light node authentication token>
export TRUSTED_BLOCK=<the trusted block number, e.g. 1865870>
export TARGET_BLOCK=<the target block number, e.g. 1865890>
export COMMITMENT_BLOCK=<the target block number, e.g. 1865877>
export NAMESPACE=<the Celestia namespace, e.g. 240713>
export COMMITMENT=<the blob commitment, e.g. d374153c3e49fcaf0de6cc972da43d1b312bd3dbd5c9926c85c00758c2d2cf2d>
rm -rf private_repos && ./build.sh

# For some reason, this envvar is not passed to ./run.sh, so we need to specify it
COMMITMENT_BLOCK=<the target block number, e.g. 1865877>./run.sh
```

The compressed proofs will be in the `output/` directory. Note that the above
`TRUSTED_BLOCK`, `TARGET_BLOCK`, `COMMITMENT_BLOCK`, `NAMESPACE`, and
`COMMITMENT` will just work, and you only need your own `SP1_PRIVATE_KEY` and `LIGHT_NODE_URL`.
