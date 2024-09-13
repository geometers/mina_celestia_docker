FROM rust:1.80-slim-bookworm

WORKDIR /

RUN mkdir /output

# Install system dependencies
RUN apt-get -y -qq update
RUN apt-get install -y -qq curl tar wget aria2 clang pkg-config libssl-dev jq \
                   build-essential git make ncdu cmake ninja-build \
                   protobuf-compiler && \
    apt -y -qq autoclean

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
    git checkout v1.1.1 && \
    cd cli && \
    cargo install --locked --path . && \
    cd / && \
    cargo prove install-toolchain

# Copy private repos which build.sh should have cloned and compressed
COPY ./private_repos/o1js-pairing.tar.gz /
COPY ./private_repos/blob-stream-inclusion.tar.gz /

# Copy the custom (stripped-down) .env file
COPY ./blob_stream_inclusion_env /blob-stream-inclusion/.env

# Unpack the o1js-pairing and build
run tar xf /o1js-pairing.tar.gz && \
    rm /o1js-pairing.tar.gz

run cd /o1js-pairing/contracts && \
    npm install && \
    npm run build

# Install go
RUN wget -q "https://golang.org/dl/go1.22.0.linux-amd64.tar.gz"
RUN rm -rf /go && \
    tar -C / -xzf "go1.22.0.linux-amd64.tar.gz"

ENV GOROOT /go
ENV GOPATH /go/bin
ENV PATH /go/bin:$PATH

# Unpack blob-stream-inclusion and build
RUN tar xf /blob-stream-inclusion.tar.gz && \
    rm /blob-stream-inclusion.tar.gz

# Build the proving scripts
RUN cd /blob-stream-inclusion/blobstream/script && \
    cargo build --release --features native-gnark --bin prove

RUN cd /blob-stream-inclusion/blob_inclusion/script && \
    cargo build --release --features native-gnark --bin prove

# For testing only
#COPY ./bs_sample_proof.json /o1js-pairing/scripts/blobstream_example/blobstreamSP1Proof.json
#COPY ./bsi_sample_proof.json /o1js-pairing/scripts/blobstream_example/blobInclusionSP1Proof.json

# Copy the start script
COPY ./start.sh /start.sh

CMD ["bash", "/start.sh"]
#CMD ["sleep", "infinity"]
