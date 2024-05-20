/*
Copyright © 2024 NAME HERE <EMAIL ADDRESS>
*/
package main

import (
	"context"
	"log"

	"github.com/yevgen-grytsay/kbot/app"
	"github.com/yevgen-grytsay/kbot/cmd"
	"github.com/yevgen-grytsay/kbot/otel"
)

func main() {
	tp, mp := otel.InitTracer(app.AppVersion)
	defer func() {
		if err := tp.Shutdown(context.Background()); err != nil {
			log.Printf("Error shutting down tracer provider: %v", err)
		}
		if err := mp.Shutdown(context.Background()); err != nil {
			log.Printf("Error shutting down metric provider: %v", err)
		}
	}()

	cmd.Execute()
}
