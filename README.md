# Auto

`auto` is a CLI tool that wraps npm, yarn, pnpm, and bun to automatically detect the package manager and forward commands. It simplifies working with multiple JavaScript package managers by detecting the appropriate one based on the project files.

## Features
- Automatically detects the package manager based on lock files.
- Forwards commands and arguments to the detected package manager.
- Supports npm, yarn, pnpm, and bun.

## Installation

### Build from Source
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd auto
   ```
2. Build the binary:
   ```bash
   go build -o auto
   ```
3. Add the binary to your PATH:
   ```bash
   export PATH="$PATH:$(pwd)"
   ```

### Usage
Run `auto` followed by the desired command. For example:
```bash
auto install
auto add lodash
auto run build
```

## How It Works
`auto` detects the package manager by checking for the following files in the current directory:
- `yarn.lock` → yarn
- `package-lock.json` → npm
- `pnpm-lock.yaml` → pnpm
- `bun.lockb` → bun

It then forwards the command and arguments to the detected package manager.

## License
This project is licensed under the MIT License.
