#!/bin/sh
set -eu

# ---------------------------------------------------------------------------
# Quack server configuration — override via environment variables.
# ---------------------------------------------------------------------------
QUACK_HOST="${QUACK_HOST:-0.0.0.0}"
QUACK_PORT="${QUACK_PORT:-9494}"
QUACK_DB="${QUACK_DB:-/data/server.duckdb}"

# WARNING: This image binds on all interfaces (0.0.0.0) so that it is
# reachable inside a cluster.  Do NOT expose port 9494 directly to the
# public internet.  Front the service with a TLS-terminating reverse proxy
# (e.g. nginx + Let's Encrypt) for any external exposure.

mkdir -p "$(dirname "${QUACK_DB}")"

# If QUACK_TOKEN is set, pass it explicitly to quack_serve.
# Otherwise DuckDB generates a random token and prints it to stdout on startup —
# check the container logs to retrieve it.
if [ -n "${QUACK_TOKEN:-}" ]; then
    SERVE_CALL="CALL quack_serve('quack:${QUACK_HOST}:${QUACK_PORT}', allow_other_hostname => true, token = '${QUACK_TOKEN}');"
else
    SERVE_CALL="CALL quack_serve('quack:${QUACK_HOST}:${QUACK_PORT}', allow_other_hostname => true);"
fi

# quack_serve is non-blocking; the DuckDB session must stay alive for the
# server to keep running.  We achieve this by keeping stdin open with
# `tail -f /dev/null` after sending the initialisation SQL.
{
    printf 'LOAD quack;\n%s\n' "${SERVE_CALL}"
    tail -f /dev/null
} | duckdb "${QUACK_DB}"
