# Stage 1: Build the Go application using Red Hat's UBI8 go-toolset
FROM registry.access.redhat.com/ubi8/go-toolset:1.18 AS builder

WORKDIR /opt/app-root/src

# Copy your backend source code.
# If your backend is in a subfolder, adjust accordingly.
# For example, if your backend code is in the "backend" folder:
COPY backend/ ./backend

# Copy the pre-built React static files.
# This assumes you have copied your frontend/build output to a folder called "static".
COPY static/ ./static

# Change into the backend directory
WORKDIR /opt/app-root/src/backend

# Download module dependencies
RUN go mod download

# Build the Go binary
RUN go build -o main .

# Stage 2: Create the final runtime image using a minimal UBI image
FROM registry.access.redhat.com/ubi8/ubi-minimal

WORKDIR /opt/app-root/src

# Copy the built Go binary from the builder stage
COPY --from=builder /opt/app-root/src/backend/main .

# Copy the static files from the builder stage
COPY --from=builder /opt/app-root/src/static ./static

# Expose the port your Go server listens on (adjust if needed)
EXPOSE 8080

# Start the application
CMD ["./main"]
