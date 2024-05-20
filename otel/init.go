package otel

import (
	"context"
	"log"

	"time"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/otlp/otlpmetric/otlpmetrichttp"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp"
	"go.opentelemetry.io/otel/propagation"
	semconv "go.opentelemetry.io/otel/semconv/v1.24.0"

	sdkmetric "go.opentelemetry.io/otel/sdk/metric"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
)

const (
	OTEL_SERVICE_NAME         = "KbotService"
	METRICS_EXPORT_INTERVAL   = 60 * time.Second
	TRACS_EXPORT_INTERVAL     = 60 * time.Second
	OTLP_METRIC_HTTP_ENDPOINT = "http://collector:3030"
	OTLP_TRACE_HTTP_ENDPOINT  = "http://collector:3030"
)

func InitTracer(appVersion string) (*sdktrace.TracerProvider, *sdkmetric.MeterProvider) {
	ctx := context.Background()

	resource, err := resource.Merge(
		resource.Default(),
		resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceName(OTEL_SERVICE_NAME),
			semconv.ServiceVersion(appVersion),
		),
	)
	if err != nil {
		log.Fatal(err)
	}

	// metricsExporter, err := stdoutmetric.New(stdoutmetric.WithPrettyPrint())
	metricsExporter, err := otlpmetrichttp.New(ctx, otlpmetrichttp.WithEndpointURL(OTLP_METRIC_HTTP_ENDPOINT))
	if err != nil {
		log.Fatal(err)
	}

	meterProvider := sdkmetric.NewMeterProvider(
		sdkmetric.WithReader(sdkmetric.NewPeriodicReader(metricsExporter, sdkmetric.WithInterval(METRICS_EXPORT_INTERVAL))),
		sdkmetric.WithResource(resource),
	)

	// traceExporter, err := stdouttrace.New(stdouttrace.WithPrettyPrint())
	traceExporter, err := otlptracehttp.New(ctx, otlptracehttp.WithEndpointURL(OTLP_TRACE_HTTP_ENDPOINT))
	if err != nil {
		log.Fatal(err)
	}

	traceProvider := sdktrace.NewTracerProvider(
		sdktrace.WithBatcher(traceExporter, sdktrace.WithBatchTimeout(TRACS_EXPORT_INTERVAL)),
		sdktrace.WithSampler(sdktrace.AlwaysSample()), // TODO: remove for production
		sdktrace.WithResource(resource),
	)

	otel.SetMeterProvider(meterProvider)
	otel.SetTracerProvider(traceProvider)
	otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(propagation.TraceContext{}, propagation.Baggage{}))

	return traceProvider, meterProvider
}
