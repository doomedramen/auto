package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
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
	if fileExists("yarn.lock") {
		return "yarn"
	} else if fileExists("package-lock.json") {
		return "npm"
	} else if fileExists("pnpm-lock.yaml") {
		return "pnpm"
	} else if fileExists("bun.lockb") {
		return "bun"
	}
	return ""
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
