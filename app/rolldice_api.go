package app

import (
	"context"
	"flag"
	"fmt"
	"io"
	"net/http"

	"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/baggage"
	semconv "go.opentelemetry.io/otel/semconv/v1.24.0"
	"go.opentelemetry.io/otel/trace"
)

const (
	SERVER_URL = "http://otel-dice-server:8080/rolldice"
)

func RollDice(username string) string {
	bag, _ := baggage.Parse(fmt.Sprintf("username=%s", username))

	return rollDice(bag)
}

func rollDice(bag baggage.Baggage) string {
	url := flag.String("server", SERVER_URL, "server url")
	flag.Parse()

	client := http.Client{Transport: otelhttp.NewTransport(http.DefaultTransport)}

	ctx := baggage.ContextWithBaggage(context.Background(), bag)

	var body []byte

	tr := otel.Tracer("example/client")
	err := func(ctx context.Context) error {
		ctx, span := tr.Start(ctx, "roll dice", trace.WithAttributes(semconv.PeerService("RollDiceService")))
		defer span.End()
		req, _ := http.NewRequestWithContext(ctx, "GET", *url, nil)

		fmt.Printf("Sending request...\n")
		res, err := client.Do(req)
		if err != nil {
			panic(err)
		}
		body, err = io.ReadAll(res.Body)
		_ = res.Body.Close()

		return err
	}(ctx)
	if err != nil {
		return fmt.Sprintf("Error: %s", err.Error())
		// log.Println(err)
	}

	return string(body)
}
