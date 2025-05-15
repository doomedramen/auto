package main

import (
	"encoding/json"
	"io"
	"os"
	"path/filepath"
)

// getPackageJSONScripts reads the package.json file and returns a map of script names
func getPackageJSONScripts(projectRoot string) map[string]bool {
	scripts := make(map[string]bool)
	packageJSONPath := filepath.Join(projectRoot, "package.json")

	if !fileExists(packageJSONPath) {
		return scripts
	}

	file, err := os.Open(packageJSONPath)
	if err != nil {
		return scripts
	}
	defer file.Close()

	data, err := io.ReadAll(file)
	if err != nil {
		return scripts
	}

	var packageJSON struct {
		Scripts map[string]string `json:"scripts"`
	}

	if err := json.Unmarshal(data, &packageJSON); err != nil {
		return scripts
	}

	// Convert scripts to a map of bool for easier lookup
	for script := range packageJSON.Scripts {
		scripts[script] = true
	}

	return scripts
}
