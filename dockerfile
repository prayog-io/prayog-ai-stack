FROM n8nio/n8n:latest

USER root

# Create tracing working dir
WORKDIR /opt/n8n-tracing

# Copy tracing scripts
COPY tracing.js .
COPY n8n-otel-instrumentation.js .

# Backup original entrypoint
RUN mv /docker-entrypoint.sh /docker-entrypoint-original.sh

# Copy your custom entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Install tracing dependencies
RUN echo '{}' > package.json && \
    npm install \
        n8n-core \
        flat@5 \
        @opentelemetry/api \
        @opentelemetry/sdk-node \
        @opentelemetry/resources \
        @opentelemetry/auto-instrumentations-node \
        @opentelemetry/instrumentation \
        @opentelemetry/semantic-conventions \
        @opentelemetry/context-async-hooks \
        @opentelemetry/exporter-trace-otlp-http \
        @opentelemetry/exporter-logs-otlp-http \
        winston

USER node
