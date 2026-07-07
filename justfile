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

# Build the frontend and run the app with the local OIDC login demo: Dex
# as the identity provider plus food4u wired to it.  Sign-in works and each
# account keeps its own kitchen (persisted in login-demo.db).  Dex stops
# when the server does.  See dev/oidc/login-demo.org.
login-demo: build-elm
    dev/oidc/login-demo.sh

# Build both Rust and Elm.
build: build-elm build-rust

# Build the Elm frontend.  Unoptimized for a fast edit loop and readable
# runtime errors; `just dev` uses this.
build-elm:
    cd frontend && elm make src/Main.elm --output public/elm.js

# Build the Elm frontend optimized and minified, mirroring the Nix package
# build so the local and packaged bundles match.  Slower than build-elm
# (terser runs twice); use it for release builds and bundle-size checks,
# not the edit loop.
build-elm-prod:
    cd frontend && elm make src/Main.elm --optimize --output public/elm.unminified.js && terser public/elm.unminified.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | terser --mangle --output public/elm.js && rm -f public/elm.unminified.js

# Build the optimized frontend and the release binary together.
build-prod: build-elm-prod
    cargo build --workspace --release

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
