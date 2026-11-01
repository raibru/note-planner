package main

import (
	"os"

	"github.com/raibru/gobooklet/cmd"
)

func main() {
	defer os.Exit(0)
	cmd.Execute()
}
