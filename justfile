# Run every recipe inside the Nix dev shell so the Rust, Elm, and
# formatter toolchains are always on PATH — `just dev` then works from a
# bare shell with no `nix develop` or direnv step.  (With direnv
# installed, `direnv allow` loads the same environment automatically and
# this still works unchanged.)
set shell := ["nix", "develop", "--command", "bash", "-c"]

# Local development address for the server and the browser tab.
dev_url := "http://127.0.0.1:3000"

# Build the frontend, start the server, and open the app in a browser.
#
# The browser open is backgrounded (after a short delay so the listener
# is ready) on the same line as the server, so it shares the server's
# shell and survives until the foreground server is running.
dev: build-elm
    ( sleep 1.5 && open "{{dev_url}}" ) & cargo run --package food4u-server -- --base-url "{{dev_url}}"

# Build both Rust and Elm.
build: build-elm build-rust

# Build the Elm frontend.
build-elm:
    cd frontend && elm make src/Main.elm --output public/elm.js

# Build all Rust workspace crates.
build-rust:
    cargo build --workspace

# Run all tests (Elm compile check + Rust test suite).
test: build-elm test-rust

# Run the Rust test suite.
test-rust:
    cargo test --workspace

# Build Elm then run via cargo, forwarding all arguments.
run *args: build-elm
    cargo run {{args}}
