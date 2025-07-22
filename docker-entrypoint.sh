#!/bin/sh

export OTEL_SERVICE_NAME="${OTEL_SERVICE_NAME:-n8n}"
export OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf"
export OTEL_EXPORTER_OTLP_ENDPOINT="http://insights.delcaper.com:4318"
export OTEL_LOG_LEVEL="info"

# Inject tracing at runtime
export NODE_OPTIONS="--require /opt/n8n-tracing/tracing.js"

echo "Starting n8n with OpenTelemetry instrumentation..."

exec /docker-entrypoint-original.sh "$@"
