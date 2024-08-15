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
export TRUSTED_BLOCK=<the trusted block number, e.g. 1916121>
export TARGET_BLOCK=<the target block number, e.g. 1916122>
export NAMESPACE=<the Celestia namespace, e.g. 1935200000>
export COMMITMENT=<the blob commitment, e.g. 9f2d95f144e4f7e6beb24197eceb69c78c101ae6827e0e4ec8037612e405319d>
./build.sh
./run.sh
```

The compressed proofs will be in the `output/` directory. Note that the above
`TRUSTED_BLOCK` and `TARGET_BLOCK` numbers, along as the `NAMESPACE` and
`COMMITMENT` will just work, and you only need your own `SP1_PRIVATE_KEY`.
