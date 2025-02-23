# Stage 1: Build the Go application using UBI8 go-toolset
FROM registry.access.redhat.com/ubi8/go-toolset:1.18 AS builder

WORKDIR /opt/app-root/src

# Copy the entire source code (Go code and static files)
COPY . .

# Build the Go application
RUN go mod download
RUN go build -o main .

# Stage 2: Create the final runtime image using UBI minimal
FROM registry.access.redhat.com/ubi8/ubi-minimal

WORKDIR /opt/app-root/src

# Copy the built application and static files from the builder stage
COPY --from=builder /opt/app-root/src/main .
COPY --from=builder /opt/app-root/src/static ./static

EXPOSE 8080

CMD ["./main"]
