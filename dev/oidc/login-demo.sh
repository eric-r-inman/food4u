#!/usr/bin/env bash
# Local OIDC login demo.
#
# Stands up Dex as the identity provider and runs food4u wired to it, so
# the sign-in flow and per-account persistence can be exercised entirely on
# one machine.  Dex is stopped again when this script exits.
#
# Strictly a development aid: the Dex connector is passwordless and the
# client secret is committed.  Run it through `just login-demo`, which puts
# the Rust and Elm toolchains on PATH first.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# The client secret is passed to the server through a file so it never sits
# on a command line; it must match the secret in dex.yaml.
secret_file="$(mktemp)"
printf food4u-dev-secret > "$secret_file"

cleanup() {
  if [[ -n "${dex_pid:-}" ]]; then
    kill "$dex_pid" 2>/dev/null || true
  fi
  rm -f "$secret_file"
}
trap cleanup EXIT

echo "Starting the Dex identity provider…"
nix run nixpkgs#dex-oidc -- serve "$root/dev/oidc/dex.yaml" &
dex_pid=$!

echo "Waiting for Dex to become ready…"
for _ in $(seq 1 60); do
  if curl -sf \
    http://127.0.0.1:5556/dex/.well-known/openid-configuration >/dev/null 2>&1
  then
    ready=1
    break
  fi
  sleep 0.5
done
if [[ -z "${ready:-}" ]]; then
  echo "Dex did not become ready in time." >&2
  exit 1
fi

# Open the browser once the server is up, mirroring `just dev`.
( sleep 2 && open http://127.0.0.1:3000 ) &

echo "Starting food4u with authentication enabled on http://127.0.0.1:3000"
echo "(Ctrl-C to stop; Dex stops with it.  Accounts persist in login-demo.db.)"
food4u_listen=127.0.0.1:3000 \
food4u_base_url=http://127.0.0.1:3000 \
food4u_database_url="sqlite:$root/login-demo.db" \
food4u_oidc_issuer=http://127.0.0.1:5556/dex \
food4u_oidc_client_id=food4u \
food4u_oidc_client_secret_file="$secret_file" \
  cargo run --package food4u-server -- --base-url http://127.0.0.1:3000
