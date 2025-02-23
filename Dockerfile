# Stage 1: Build the Go binary
FROM ubuntu:jammy AS builder

# Install dependencies needed for building Go
RUN apt-get update && apt-get install -y curl make gcc

# Install Go (adjust version as needed)
ENV GOLANG_VERSION=1.23.0
RUN curl --output go.tar.gz https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

# Set working directory for build
WORKDIR /app

# Copy go.mod and go.sum for dependency caching
COPY backend/go.mod backend/go.sum ./
RUN go mod download

# Copy the rest of the backend code
COPY backend/ .

# Build the backend binary
RUN go build -o main .

# Stage 2: Build the final runtime image
FROM ubuntu:jammy

# Install runtime dependencies (e.g., certificates)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Copy the pre-built React static files (adjust the source path if necessary)
COPY frontend/build/ ./static

# Expose the port your backend listens on
EXPOSE 8080

# Start the application
CMD ["./main"]

