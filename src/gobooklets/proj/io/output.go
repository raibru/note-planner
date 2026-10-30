package io

import (
	"errors"
	"io/fs"
	"os"
)

func ExistsOutputDir(outDir string) bool {
	if outDir == "" {
		return false
	}

	_, err := os.Stat(outDir)
	if err != nil {
		return false
	}

	return true
}

func CreateOutputDir(outDir string) error {
	if err := os.Mkdir(outDir, 0755); errors.Is(err, fs.ErrExist) {
		return err
	}
	return nil
}
