FROM rust:1.80-slim-bookworm

WORKDIR /

# Copy private repos which build.sh should have cloned and compressed
COPY ./private_repos/o1js-pairing.tar.gz /
COPY ./private_repos/blob-stream-inclusion.tar.gz /

# Copy the custom .env file (minus SP1_PRIVATE_KEY and LIGHT_NODE_URL)
COPY ./blob_stream_inclusion_env /blob-stream-inclusion/.env

# Copy the start script
COPY ./start.sh /start.sh

# Install system dependencies
RUN apt -y update
RUN apt install -y curl tar wget aria2 clang pkg-config libssl-dev jq \
                   build-essential git make ncdu cmake ninja-build \
                   protobuf-compiler && \
    apt-get -y autoclean

## Copy the Node installer
#COPY ./install_node.sh /install_node.sh

## Install Node and NPM using NVM
#RUN bash /install_node.sh

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

run tar xf /o1js-pairing.tar.gz && \
    rm /o1js-pairing.tar.gz

run cd /o1js-pairing/contracts && \
    npm install && \
    npm run build

# Install SP1
RUN git clone https://github.com/succinctlabs/sp1.git
RUN cd sp1 && \
    git checkout v1.0.1 && \
    cd cli && \
    cargo install --locked --path . && \
    cd / && \
    cargo prove install-toolchain

RUN tar xf /blob-stream-inclusion.tar.gz && \
    rm /blob-stream-inclusion.tar.gz

RUN cd /blob-stream-inclusion/blobstream/script && \
    cargo build --release --bin prove

RUN cd /blob-stream-inclusion/blob_inclusion/script && \
    cargo build --release --bin prove

CMD ["bash", "/start.sh"]
#CMD ["sleep", "infinity"]
