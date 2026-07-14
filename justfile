# Run every recipe inside the Nix dev shell so the Rust, Elm, and
# formatter toolchains are always on PATH — `just dev` then works from a
# bare shell with no `nix develop` or direnv step.  (With direnv
# installed, `direnv allow` loads the same environment automatically and
# this still works unchanged.)
set shell := ["nix", "develop", "--command", "bash", "-c"]

# Local development address for the server and the browser tab.
dev_url := "http://127.0.0.1:3000"

# Seed-editing runs on its own port and throwaway database so it never
# touches your normal `just dev` kitchen.  `seed_file` is the checked-in
# source of truth for the bundled default foods and recipes.
seed_listen := "127.0.0.1:3001"
seed_url := "http://" + seed_listen
seed_db := ".seed-edit.db"
seed_file := "crates/server/src/seed/default_model.json"

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

# Visually edit the bundled default foods and recipes.  Loads the checked-in
# seed fresh into a throwaway database, then opens the app so you can add,
# edit, and delete foods and recipes with the normal UI — drag-and-drop and
# all.  Your own `just dev` kitchen (food4u.db) is left untouched.  Edit in
# the browser, then, in a second terminal, run `just seed-save` to bake the
# changes back into the seed.  Restarting reloads the checked-in seed, so
# save before you stop the server or unsaved edits are discarded.
seed-edit: build-elm
    rm -f {{seed_db}} {{seed_db}}-wal {{seed_db}}-shm
    ( sleep 1.5 && open "{{seed_url}}" ) & cargo run --package food4u-server -- --base-url "{{seed_url}}" --listen "{{seed_listen}}" --database-url "sqlite:{{seed_db}}" --data-file "{{seed_file}}"

# Bake the model of a running `just seed-edit` session back into the bundled
# seed file, pretty-printed to match.  Writes only on success, so a failed
# fetch (server not up) leaves the seed untouched.
seed-save:
    tmp=$(mktemp) && curl -sf "{{seed_url}}/api/model" | jq --indent 2 . > "$tmp" && test -s "$tmp" && mv "$tmp" "{{seed_file}}" && echo "Saved the current model to {{seed_file}}" || { rm -f "$tmp"; echo "seed-save failed — is 'just seed-edit' running on {{seed_url}} ?" >&2; exit 1; }

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
