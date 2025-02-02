// Copyright 2018 Drone.IO Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"fmt"
	"os"

	"github.com/laszlocph/woodpecker/version"

	_ "github.com/joho/godotenv/autoload"
	"github.com/urfave/cli"
)

func main() {
	app := cli.NewApp()
	app.Name = "drone-server"
	app.Version = version.Version.String()
	app.Usage = "drone server"
	app.Action = server
	app.Flags = flags
	app.Before = before

	if err := app.Run(os.Args); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
