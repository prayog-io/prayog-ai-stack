"use strict";

// Enable proper async context propagation globally.
const { AsyncHooksContextManager } = require("@opentelemetry/context-async-hooks");
const { context } = require("@opentelemetry/api");
const { resourceFromAttributes } = require('@opentelemetry/resources');
const { OTLPTraceExporter } = require("@opentelemetry/exporter-trace-otlp-http");
const { OTLPLogExporter } = require("@opentelemetry/exporter-logs-otlp-http");
const { getNodeAutoInstrumentations } = require("@opentelemetry/auto-instrumentations-node");
const { registerInstrumentations } = require("@opentelemetry/instrumentation");
const { SemanticResourceAttributes } = require("@opentelemetry/semantic-conventions");
const opentelemetry = require("@opentelemetry/sdk-node");
const winston = require("winston");

const logger = winston.createLogger({
  level: "info",
  format: winston.format.json(),
  transports: [new winston.transports.Console()],
});

// Setup auto-instrumentations
const autoInstrumentations = getNodeAutoInstrumentations({
  "@opentelemetry/instrumentation-dns": { enabled: false },
  "@opentelemetry/instrumentation-net": { enabled: false },
  "@opentelemetry/instrumentation-tls": { enabled: false },
  "@opentelemetry/instrumentation-fs": { enabled: false },
  "@opentelemetry/instrumentation-pg": {
    enhancedDatabaseReporting: true,
  },
});

registerInstrumentations({
  instrumentations: [autoInstrumentations],
});

// Define and setup OpenTelemetry Resource
const resource = resourceFromAttributes({
  [SemanticResourceAttributes.SERVICE_NAME]: process.env.OTEL_SERVICE_NAME || 'n8n', // Service name
  'service.version': '1.0.0', // Service version
  'service.environment': 'production', // Environment attribute (can be dynamic based on your setup)
  'service.instance.id': 'container-id', // Optional: Use your actual container ID if available
});

// Create an OTLP exporter for tracing and logs
const traceExporter = new OTLPTraceExporter();
const logExporter = new OTLPLogExporter();

// Setup OpenTelemetry SDK with the trace and log exporters
const sdk = new opentelemetry.NodeSDK({
  traceExporter: traceExporter,
  logRecordProcessors: [new opentelemetry.logs.SimpleLogRecordProcessor(logExporter)],
  resource: resource, // Attach the resource to the SDK
});

// Uncaught exception handling
process.on("uncaughtException", async (err) => {
  logger.error("Uncaught Exception", { error: err });
  const span = opentelemetry.trace.getActiveSpan();
  if (span) {
    span.recordException(err);
    span.setStatus({ code: 2, message: err.message });
  }
  try {
    await sdk.forceFlush();
  } catch (flushErr) {
    logger.error("Error flushing telemetry data", { error: flushErr });
  }
  process.exit(1);
});

// Unhandled promise rejection handling
process.on("unhandledRejection", (reason, promise) => {
  logger.error("Unhandled Promise Rejection", { error: reason });
});

// Start the OpenTelemetry SDK
sdk.start();

logger.info('OpenTelemetry tracing and logging initialized.');
