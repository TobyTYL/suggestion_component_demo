# Use the official Golang image to create a build artifact.
FROM golang:1.19-alpine AS builder

# Install Git.
RUN apk add --no-cache git

# Create and change to the app directory.
WORKDIR /app

# Copy go mod and sum files.
COPY backend/go.mod backend/go.sum ./

# Download dependencies.
RUN go mod download

# Copy the source code.
COPY backend/ .

# Build the application.
RUN go build -o main .

# Use a smaller base image for the final build.
FROM alpine:3.15

# Install ca-certificates.
RUN apk add --no-cache ca-certificates

# Copy the binary from the builder stage.
COPY --from=builder /app/main /main

# Expose port 8080.
EXPOSE 8080

# Command to run the executable.
CMD ["/main"]
