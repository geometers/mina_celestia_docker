<!--
# Getting started

This repository is a sample application for users following the getting started guide at https://docs.docker.com/get-started/.

The application is based on the application from the getting started tutorial at https://github.com/docker/getting-started
-->

# Mina-Celestia DA (WIP: change title)

## Getting started

Clone this repository, then run:

```bash
export SP1_PRIVATE_KEY=<your SP1 private key starting with 0x>
export LIGHT_NODE_URL=<the URL of a Celestia RPC, such as a light node, e.g. https://rpc.lunaroasis.net/>
export TENDERMINT_RPC_URL=<the URL of a Celestia RPC, such as a light node, e.g. https://rpc.lunaroasis.net/>
export TRUSTED_BLOCK=<the trusted block number, e.g. 1916121>
export TARGET_BLOCK=<the target block number, e.g. 1916122>
export NAMESPACE=<the Celestia namespace, e.g. 1935200000>
export COMMITMENT=<the blob commitment, e.g. 9f2d95f144e4f7e6beb24197eceb69c78c101ae6827e0e4ec8037612e405319d>
./build.sh
./run.sh
```
