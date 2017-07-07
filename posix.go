// +build !windows

package main

import (
	"syscall"

	"golang.org/x/crypto/ssh/terminal"
)

var writeFailedLog = !terminal.IsTerminal(syscall.Stderr)
