# Auto

`auto` is a CLI tool that wraps npm, yarn, pnpm, bun, and other package managers to automatically detect the package manager and forward commands. It simplifies working with multiple JavaScript and TypeScript package managers by detecting the appropriate one based on the project files.

## Features

- Automatically detects the package manager based on lock or configuration files.
- Forwards commands and arguments to the detected package manager.
- Supports npm, yarn, pnpm, bun, Deno, jspm, and Rome.

## Installation

### Build from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/doomedramen/auto
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
- `bun.lockb` or `bun.lock` → bun
- `deno.json` or `deno.jsonc` → Deno
- `jspm.config.js` → jspm
- `rome.json` → Rome

It then forwards the command and arguments to the detected package manager. For commands like `x`, it automatically appends the appropriate prefix (`npx`, `pnpx`, or `bunx`) based on the detected package manager.

### Supported Commands

- **Standard Commands**: Any command supported by the detected package manager (e.g., `install`, `add`, `run`).
- **Binary Execution**: Use `auto x <binary>` to execute binaries (e.g., `auto x create-react-app`). This works with `npx`, `pnpx`, and `bunx` depending on the package manager.

## License

This project is licensed under the MIT License.
