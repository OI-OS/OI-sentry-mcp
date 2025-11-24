#!/bin/bash
# Wrapper script for Sentry MCP server
# Reads SENTRY_ACCESS_TOKEN from .env file or environment

# Get the project root (two levels up from this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"

# Load .env file if it exists
if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | grep SENTRY_ACCESS_TOKEN | xargs)
fi

if [ -z "$SENTRY_ACCESS_TOKEN" ]; then
  echo "Error: SENTRY_ACCESS_TOKEN not found in .env file or environment" >&2
  exit 1
fi

# Use npx to run the published package
exec npx --yes @sentry/mcp-server@latest --access-token="$SENTRY_ACCESS_TOKEN" "$@"

