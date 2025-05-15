# Makefile for auto package manager helper

# Variables
BINARY_NAME=auto
VERSION=$(shell cat VERSION)
BUILD_DIR=./build
RELEASE_DIR=./release
INSTALL_DIR=/usr/local/bin
LDFLAGS=-ldflags "-X main.version=$(VERSION)"

# Go related variables
GOBASE=$(shell pwd)
GOFILES=$(wildcard *.go)

# Determine the OS and architecture
GOOS=$(shell go env GOOS)
GOARCH=$(shell go env GOARCH)

# Build the project
.PHONY: build
build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) .

# Run the binary
.PHONY: run
run: build
	./$(BUILD_DIR)/$(BINARY_NAME)

# Clean build files
.PHONY: clean
clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)
	@rm -f $(BINARY_NAME)
	@go clean

# Install the binary to /usr/local/bin
.PHONY: install
install: build
	@echo "Installing $(BINARY_NAME) to $(INSTALL_DIR)..."
	@install -m 755 $(BUILD_DIR)/$(BINARY_NAME) $(INSTALL_DIR)/$(BINARY_NAME)
	@echo "Installation complete! You can now use '$(BINARY_NAME)' command."

# Uninstall the binary
.PHONY: uninstall
uninstall:
	@echo "Uninstalling $(BINARY_NAME) from $(INSTALL_DIR)..."
	@rm -f $(INSTALL_DIR)/$(BINARY_NAME)
	@echo "Uninstall complete."

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	go test -v ./...

# Format the code
.PHONY: fmt
fmt:
	@echo "Formatting code..."
	go fmt ./...

# Build for all platforms
.PHONY: release
release: clean
	@echo "Building release packages..."
	@mkdir -p $(RELEASE_DIR)
	
	# Build for macOS (AMD64 and ARM64)
	GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BINARY_NAME) .
	zip -q $(RELEASE_DIR)/darwin-amd64.zip $(BINARY_NAME)
	rm $(BINARY_NAME)
	
	GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BINARY_NAME) .
	zip -q $(RELEASE_DIR)/darwin-arm64.zip $(BINARY_NAME)
	rm $(BINARY_NAME)
	
	# Build for Linux (AMD64 and ARM64)
	GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BINARY_NAME) .
	zip -q $(RELEASE_DIR)/linux-amd64.zip $(BINARY_NAME)
	rm $(BINARY_NAME)
	
	GOOS=linux GOARCH=arm64 go build $(LDFLAGS) -o $(BINARY_NAME) .
	zip -q $(RELEASE_DIR)/linux-arm64.zip $(BINARY_NAME)
	rm $(BINARY_NAME)
	
	# Build for Windows (AMD64 and ARM64)
	GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BINARY_NAME).exe .
	zip -q $(RELEASE_DIR)/windows-amd64.zip $(BINARY_NAME).exe
	rm $(BINARY_NAME).exe
	
	GOOS=windows GOARCH=arm64 go build $(LDFLAGS) -o $(BINARY_NAME).exe .
	zip -q $(RELEASE_DIR)/windows-arm64.zip $(BINARY_NAME).exe
	rm $(BINARY_NAME).exe
	
	@echo "Release builds complete!"

# Default target
.PHONY: default
default: build

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build      - Build the binary"
	@echo "  run        - Build and run the binary"
	@echo "  clean      - Clean build files"
	@echo "  install    - Install the binary to $(INSTALL_DIR)"
	@echo "  uninstall  - Uninstall the binary from $(INSTALL_DIR)"
	@echo "  test       - Run tests"
	@echo "  fmt        - Format the code"
	@echo "  release    - Build release packages for all platforms"
	@echo "  help       - Show this help message"
