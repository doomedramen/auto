package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

func main() {
	start := time.Now()

	if len(os.Args) < 2 {
		fmt.Println("Usage: auto <command> [args...]")
		os.Exit(1)
	}

	command := os.Args[1]
	args := os.Args[2:]

	packageManager := detectPackageManager()
	if packageManager == "" {
		fmt.Println("No supported package manager detected.")
		os.Exit(1)
	}

	duration := time.Since(start)
	fmt.Printf("Package manager detected: %s (took %v)\n", packageManager, duration)

	switch command {
	case "build":
		runCommand(packageManager, "run", append([]string{"build"}, args...))
	case "x":
		runCommand(packageManager+"x", "", args)
	case "create":
		runCommand(packageManager, "create", args)
	default:
		runCommand(packageManager, command, args)
	}
}

func detectPackageManager() string {
	projectRoot := findProjectRoot()
	if projectRoot == "" {
		return ""
	}

	if fileExists(filepath.Join(projectRoot, "yarn.lock")) {
		return "yarn"
	} else if fileExists(filepath.Join(projectRoot, "package-lock.json")) {
		return "npm"
	} else if fileExists(filepath.Join(projectRoot, "pnpm-lock.yaml")) {
		return "pnpm"
	} else if fileExists(filepath.Join(projectRoot, "bun.lockb")) || fileExists(filepath.Join(projectRoot, "bun.lock")) {
		return "bun"
	} else if fileExists(filepath.Join(projectRoot, "deno.json")) || fileExists(filepath.Join(projectRoot, "deno.jsonc")) {
		return "deno"
	} else if fileExists(filepath.Join(projectRoot, "jspm.config.js")) {
		return "jspm"
	} else if fileExists(filepath.Join(projectRoot, "rome.json")) {
		return "rome"
	} else if fileExists(filepath.Join(projectRoot, "package.json")) {
		if pm := getPackageManagerFromPackageJSON(filepath.Join(projectRoot, "package.json")); pm != "" {
			return pm
		}
	}
	return ""
}

func findProjectRoot() string {
	currentDir, err := os.Getwd()
	if err != nil {
		fmt.Println("Error: Unable to get current working directory.")
		return ""
	}

	maxDepth := 20
	for depth := 0; depth < maxDepth; depth++ {
		// Check for common project root indicators
		if fileExists(filepath.Join(currentDir, "package.json")) ||
			fileExists(filepath.Join(currentDir, "yarn.lock")) ||
			fileExists(filepath.Join(currentDir, "pnpm-lock.yaml")) ||
			fileExists(filepath.Join(currentDir, "bun.lockb")) ||
			fileExists(filepath.Join(currentDir, "bun.lock")) {
			return currentDir
		}

		parentDir := filepath.Dir(currentDir)
		if parentDir == currentDir {
			// Reached the root of the filesystem
			fmt.Println("Error: No project root found. Ensure you are in a valid project directory.")
			return ""
		}
		currentDir = parentDir
	}

	fmt.Println("Error: Reached maximum directory traversal limit (20). Ensure you are in a valid project directory.")
	return ""
}

func getPackageManagerFromPackageJSON(packageJSONPath string) string {
	file, err := os.Open(packageJSONPath)
	if err != nil {
		return ""
	}
	defer file.Close()

	data, err := io.ReadAll(file)
	if err != nil {
		return ""
	}

	var packageJSON struct {
		PackageManager string `json:"packageManager"`
	}

	if err := json.Unmarshal(data, &packageJSON); err != nil {
		return ""
	}

	if packageJSON.PackageManager != "" {
		if pm := parsePackageManagerField(packageJSON.PackageManager); pm != "" {
			return pm
		}
	}

	return ""
}

func parsePackageManagerField(field string) string {
	if len(field) == 0 {
		return ""
	}

	switch {
	case field[:3] == "npm":
		return "npm"
	case field[:4] == "yarn":
		return "yarn"
	case field[:4] == "pnpm":
		return "pnpm"
	case field[:3] == "bun":
		return "bun"
	default:
		return ""
	}
}

func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

func runCommand(command string, subcommand string, args []string) {
	cmdArgs := []string{}
	if subcommand != "" {
		cmdArgs = append(cmdArgs, subcommand)
	}
	cmdArgs = append(cmdArgs, args...)

	cmd := exec.Command(command, cmdArgs...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	if err := cmd.Run(); err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
}
