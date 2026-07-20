{
  description = "Kitchen staples, shopping, and recipe manager for personal use";
  inputs = {
    # LLM: Do NOT change this URL unless explicitly directed. This is the
    # correct format for nixpkgs stable (25.11 is correct, not nixos-25.11).
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
    crane.url = "github:ipetkov/crane";
    changelog-roller.url = "github:LoganBarnett/changelog-roller";
    foundation.url = "github:LoganBarnett/rust-template";
    foundation.inputs.nixpkgs.follows = "nixpkgs";
    org-fmt.url = "github:LoganBarnett/org-fmt";
    org-fmt.inputs.nixpkgs.follows = "nixpkgs";
    org-fmt.inputs.rust-overlay.follows = "rust-overlay";
    org-fmt.inputs.crane.follows = "crane";
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    crane,
    changelog-roller,
    foundation,
    org-fmt,
  } @ inputs: let
    forAllSystems =
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    perSystem = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [(import rust-overlay)];
      };
      craneLib =
        (crane.mkLib pkgs).overrideToolchain
        (p: p.rust-bin.stable.latest.default);
      rust = pkgs.rust-bin.stable.latest.default.override {
        extensions = [
          # For rust-analyzer and others.  See
          # https://nixos.wiki/wiki/Rust#Shell.nix_example for details.
          "rust-src"
          "rust-analyzer"
          "rustfmt"
        ];
      };
      crates = {
        # CRATE:server:begin
        server = {
          name = "food4u-server";
          binary = "food4u-server";
          description = "Server process";
        };
        # CRATE:server:end
        # CRATE_ENTRIES

        # Note: The 'lib' crate is not included here as it doesn't
        # produce a binary.
      };
      commonArgs = {
        # The default cargo source filter keeps only Rust-relevant files,
        # which would drop the SQL the binary embeds at compile time: the
        # sqlx migrations and the bundled default-model seed.  Widen the
        # filter to keep .sql sources too.
        src = nixpkgs.lib.cleanSourceWith {
          src = self;
          filter = path: type:
            nixpkgs.lib.hasSuffix ".sql" path
            || craneLib.filterCargoSources path type;
          name = "source";
        };
        # Run only unit tests (--lib --bins), skip integration tests in
        # tests/ directories.  Integration tests may require external
        # services not available in the Nix sandbox.
        cargoTestExtraArgs = "--lib --bins";
      };
      rustPackages = foundation.lib.mkRustPackages {
        inherit self pkgs craneLib crates commonArgs;
      };
      # On Linux each binary also gets a statically-linked `<name>-musl`
      # variant; on other systems mkMuslPackages returns an empty set.  It
      # threads the same commonArgs, so a project's native dependencies reach
      # the musl build as they do the native one.
      muslPackages = foundation.lib.mkMuslPackages {
        inherit self pkgs system crates crane commonArgs;
      };
      # On Linux each binary also gets a portable `<name>-gnu` variant: a
      # dynamic glibc build that runs off the Nix store (FHS interpreter,
      # glibc 2.17 floor) and links the host's shared libraries.  Empty on
      # other systems.
      gnuPortablePackages = foundation.lib.mkGnuPortablePackages {
        inherit self pkgs system crates crane commonArgs;
      };
      # The x86_64-linux build cross-compiles macOS `<key>-<arch>-darwin`
      # variants via zig so a release needs no macOS runner; empty on other
      # systems.  The server links no Apple frameworks, so no `appleSdk` is
      # passed.
      darwinCrossPackages = foundation.lib.mkDarwinCrossPackages {
        inherit self pkgs system crates crane commonArgs;
      };
      # Native Windows PE variants (`<key>-{x86_64,aarch64}-windows`),
      # cross-compiled via llvm-mingw for the gnullvm targets — no Microsoft
      # SDK, no Cygwin/MSYS2 runtime.  Unlike the darwin cross build this is
      # host-agnostic (llvm-mingw ships a per-host toolchain), so it builds on
      # the Linux CI runners and on a contributor's Mac alike.
      windowsCrossPackages = foundation.lib.mkWindowsCrossPackages {
        inherit self pkgs system crates crane commonArgs;
      };
      # The opt-in MSVC-ABI Windows variant, for a dependency that requires
      # the MSVC ABI rather than the default gnullvm path above.  Off unless
      # `"windows-msvc": true` is set in rust-template.json; absent here, so it
      # stays disabled and the helper is handed no SDK.
      windowsMsvcEnabled =
        (builtins.fromJSON (builtins.readFile ./rust-template.json)).windows-msvc
        or false;
      windowsMsvcCrossPackages = foundation.lib.mkWindowsMsvcCrossPackages {
        inherit self pkgs system crates crane commonArgs;
        xwinSdk =
          if windowsMsvcEnabled
          then foundation.lib.xwinSdk {inherit pkgs;}
          else null;
      };
      packages =
        rustPackages.packages
        // muslPackages
        // gnuPortablePackages
        // darwinCrossPackages
        // windowsCrossPackages
        // windowsMsvcCrossPackages
        // {
          default =
            craneLib.buildPackage (commonArgs // {pname = "food4u";});
        };
      # The arm64 subset of the darwin cross outputs — the only ones
      # re-signed, and so the only ones the signature guard below verifies.
      # Empty except on x86_64-linux.
      aarch64DarwinPackages =
        nixpkgs.lib.filterAttrs
        (name: _: nixpkgs.lib.hasSuffix "-aarch64-darwin" name)
        darwinCrossPackages;
      # The x86_64 subset of the Windows cross outputs, smoke-tested under
      # wine.  The wine check below is gated on `system == "x86_64-linux"`
      # rather than on emptiness: wine runs a win64 PE reliably only there.
      windowsX86Packages =
        nixpkgs.lib.filterAttrs
        (name: _: nixpkgs.lib.hasSuffix "-x86_64-windows" name)
        windowsCrossPackages;
    in {
      inherit packages;
      inherit (rustPackages) apps;
      # The darwin ad-hoc signature guard, added to the workspace's checks on
      # x86_64-linux where the zig-cross darwin binaries are produced.  Empty
      # (and so absent) on every other system.
      checks =
        rustPackages.checks
        // nixpkgs.lib.optionalAttrs (aarch64DarwinPackages != {}) {
          darwinSignatures = foundation.lib.mkDarwinSignatureCheck {
            inherit pkgs;
            darwinPackages = aarch64DarwinPackages;
          };
        }
        # Run the x86_64 Windows cross binaries under wine to prove they
        # execute, not merely link.  Gated to x86_64-linux: wine cannot exec an
        # aarch64 PE and is unreliable on Apple Silicon, so aarch64 Windows is
        # build-verified only.  Passes trivially when no Windows binaries ship.
        // nixpkgs.lib.optionalAttrs (system == "x86_64-linux") {
          windowsSmoke = foundation.lib.mkWindowsSmokeCheck {
            inherit pkgs;
            windowsPackages = windowsX86Packages;
          };
        };
      devShells = {
        default = pkgs.mkShell {
          buildInputs = [
            # Rust toolchain (compiler, cargo, rustfmt, rust-analyzer).
            rust
            # Prunes stale per-profile artifacts from target/ to reclaim disk.
            pkgs.cargo-sweep
            # JSON parsing for the shellHook's cargo-package listing and ad-hoc
            # scripting in the dev shell.
            pkgs.jq
            # The sqlite3 CLI, which `just seed-save` uses to dump the
            # seed-editing database back to the checked-in SQL seed.
            pkgs.sqlite
            # Elm toolchain for the frontend/ app: compiler, formatter, and the
            # elm2nix bridge that pins Elm deps for reproducible builds.
            pkgs.elmPackages.elm
            pkgs.elmPackages.elm-format
            # Runs the frontend's unit tests (the recipe parser suite);
            # `just test` invokes it alongside the Rust suites.
            pkgs.elmPackages.elm-test
            pkgs.elm2nix
            # Minifies the --optimize'd Elm output for the production build
            # (`just build-prod`); the same tool is used by the Nix package
            # build so local and packaged frontends are byte-for-byte alike.
            pkgs.nodePackages.terser
            # Unified formatter and the per-language binaries it invokes.
            pkgs.treefmt
            pkgs.alejandra
            pkgs.prettier
            # Command runner for the project's justfile recipes.
            pkgs.just
            # Rolls the CHANGELOG on release; used by the reusable CI workflow's
            # `changelog` job and runnable locally for the same flow.
            changelog-roller.packages.${system}.default
            # Formats org-mode documents (treefmt delegates .org files to it).
            org-fmt.packages.${system}.default
            # ABI baseline check used by the reusable CI workflow's `abi`
            # job.  Compares the workspace's current public API against the
            # previous version on crates.io and reports breaking changes;
            # the job then gates on an Upcoming → Breaking changelog entry
            # when a break is detected.  Provided here so contributors can
            # run `nix develop --command cargo semver-checks ...` locally
            # before opening a PR.
            #
            # `doCheck = false` skips upstream's `target_feature_*`
            # snapshot tests, which assert against snapshots recorded on
            # x86_64 and therefore fail when building on aarch64-darwin.
            # We only ship the binary, not its test suite, so disabling
            # the check phase does not affect what the workflow runs.
            (pkgs.cargo-semver-checks.overrideAttrs (_: {doCheck = false;}))
          ];
          shellHook = ''
            ${foundation.lib.cargoHuskyHookSnippet pkgs}
            echo "Rust Template development environment"
            echo ""
            echo "Available Cargo packages (use 'cargo build -p <name>'):"
            cargo metadata --no-deps --format-version 1 2>/dev/null | \
              jq --raw-output '.packages[].name' | \
              sort | \
              sed 's/^/  • /' || echo "  Run 'cargo init' to get started"

            echo ""
            echo "Elm frontend (frontend/):"
            echo "  Build:   cd frontend && elm make src/Main.elm --output public/elm.js"
            echo "  Format:  treefmt"
            echo "  After changing elm.json dependency versions, regenerate Nix files:"
            echo "    cd frontend"
            echo "    elm2nix convert 2>/dev/null > elm-srcs.nix"
            echo "    elm2nix snapshot"
            echo "    git add elm-srcs.nix registry.dat && git commit"
          '';
          # A runtime marker identifying this as rust-template's default dev
          # shell.  A compliance check reads it back with `nix eval` to
          # confirm this shell evaluates and carries the marker; the `ci`
          # shell carries the same marker with the value "ci".
          RUST_TEMPLATE_SHELL = "default";
        };
        # Minimal shell for the reusable CI workflow: the Rust toolchain plus
        # the release CLIs the `nix develop .#ci` jobs invoke (changelog-roller,
        # cargo-semver-checks).  It omits the interactive dev shell's extras
        # (the Elm toolchain, the treefmt stack, just), so it is cheaper to
        # realize; the Elm frontend is a package-build input under `nix build`,
        # not something a devShell provides.  Its baseline comes from
        # foundation's mkCiShell, using the same `rust` toolchain the dev shell
        # uses so CI compiles and lints with the project's pinned toolchain.
        ci = foundation.lib.mkCiShell {
          inherit pkgs system;
          toolchain = rust;
        };
      };
    });
  in {
    devShells =
      nixpkgs.lib.mapAttrs (_: p: p.devShells) perSystem;
    packages = nixpkgs.lib.mapAttrs (_: p: p.packages) perSystem;
    apps = nixpkgs.lib.mapAttrs (_: p: p.apps) perSystem;
    checks = nixpkgs.lib.mapAttrs (_: p: p.checks) perSystem;

    # ================================================================
    # NIXOS MODULES
    # ================================================================
    nixosModules = {
      server = import ./nix/modules/nixos-server.nix {
        inherit self foundation;
      };
      default = self.nixosModules.server;
    };

    # ================================================================
    # DARWIN MODULES
    # ================================================================
    darwinModules = {
      server = import ./nix/modules/darwin-server.nix {
        inherit self foundation;
      };
      default = self.darwinModules.server;
    };
  };
}
