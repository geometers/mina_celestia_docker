FROM rust:1.80-slim-bookworm

WORKDIR /

RUN mkdir /output

# Install system dependencies
RUN apt-get -y -qq update
RUN apt-get install -y -qq curl tar wget aria2 clang pkg-config libssl-dev jq \
                   build-essential git make ncdu cmake ninja-build \
                   protobuf-compiler && \
    apt -y -qq autoclean

COPY --from=golang:1.22.7-bookworm /usr/local/go/ /usr/local/go/
 
ENV PATH /usr/local/go/bin:$PATH

ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 22.5.1
RUN wget --quiet https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh && \
    bash install.sh && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install SP1
RUN git clone https://github.com/succinctlabs/sp1.git
RUN cd sp1 && \
    git checkout v2.0.0 && \
    cd crates/cli && \
    cargo install --locked --path . && \
    rm -rf target/release/build && \
    rm -rf target/release/examples && \
    rm -rf target/release/deps && \
    rm -rf target/release/incremental && \
    cd / && \
    cargo prove install-toolchain && \
    rm -rf /.sp1/rust-toolchain-x86_64-unknown-linux-gnu.tar.gz

# Copy private repos which build.sh should have cloned and compressed
COPY ./private_repos/o1js-blobstream.tar.gz /
COPY ./private_repos/blob-stream-inclusion.tar.gz /

# Copy the custom (stripped-down) .env file
COPY ./blob_stream_inclusion_env /blob-stream-inclusion/.env

# Unpack the o1js-blobstream and build
run tar xf /o1js-blobstream.tar.gz && \
    rm /o1js-blobstream.tar.gz

run cd /o1js-blobstream/contracts && \
    npm install && \
    npm run build

# Unpack blob-stream-inclusion and build
RUN tar xf /blob-stream-inclusion.tar.gz && \
    rm /blob-stream-inclusion.tar.gz

# Build the proving scripts
RUN cd /blob-stream-inclusion/blobstream/script && \
    cargo build --release --features native-gnark --bin prove && \
    rm -rf target/release/build && \
    rm -rf target/release/examples && \
    rm -rf target/release/deps && \
    rm -rf target/release/incremental

RUN cd /blob-stream-inclusion/blob_inclusion/script && \
    cargo build --release --features native-gnark --bin prove && \
    rm -rf target/release/build && \
    rm -rf target/release/examples && \
    rm -rf target/release/deps && \
    rm -rf target/release/incremental

# Download SP1 plonk bn256 artifacts
RUN mkdir -p /root/.sp1/circuits/v2.0.0 && \
    cd /root/.sp1/circuits/v2.0.0 && \
    wget -q https://sp1-circuits.s3-us-east-2.amazonaws.com/v2.0.0.tar.gz && \
    tar xf v2.0.0.tar.gz && \
    rm v2.0.0.tar.gz && \
    rm /root/.sp1/circuits/v2.0.0/groth16_pk.bin && \
    rm /root/.sp1/circuits/v2.0.0/plonk_pk.bin

# For testing only
#COPY ./bs_sample_proof.json /o1js-blobstream/scripts/blobstream_example/blobstreamSP1Proof.json
#COPY ./bsi_sample_proof.json /o1js-blobstream/scripts/blobstream_example/blobInclusionSP1Proof.json

# Copy the start script
COPY ./start.sh /start.sh

CMD ["bash", "/start.sh"]
#CMD ["sleep", "infinity"]
