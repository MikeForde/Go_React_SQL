# .devcontainer/Dockerfile
FROM --platform=$BUILDPLATFORM ubuntu:jammy

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ENV TINY_GO_VERSION=0.33.0
ENV GOLANG_VERSION=1.23.0

# Install core dependencies, including curl, make, and gnupg (needed for Node setup)
RUN apt-get update && apt-get install -yy -q curl make gnupg

# Install Node.js (using NodeSource for Node 18.x)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Git
RUN apt-get install -y git

# Install TinyGo and Go using the provided scripts
RUN archi=$(echo $TARGETPLATFORM | cut -d / -f2) && \
    curl -L https://github.com/tinygo-org/tinygo/releases/download/v${TINY_GO_VERSION}/tinygo_${TINY_GO_VERSION}_$archi.deb --output tinygo_${TINY_GO_VERSION}_$archi.deb && \
    dpkg -i tinygo_${TINY_GO_VERSION}_$archi.deb && \
    rm tinygo_${TINY_GO_VERSION}_$archi.deb && \
    curl -L --output go${GOLANG_VERSION}.linux-$archi.tar.gz https://go.dev/dl/go${GOLANG_VERSION}.linux-$archi.tar.gz && \
    tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-$archi.tar.gz && \
    rm go${GOLANG_VERSION}.linux-$archi.tar.gz

# Create the symlink needed for Go
RUN mkdir -p /lib64 && ln -s /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

# Set environment variables for Go
ENV GOROOT=/usr/local/go
ENV PATH=${PATH}:/usr/local/go/bin
