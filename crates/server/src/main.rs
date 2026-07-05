//! food4u-server — entry point.
//!
//! The `#[foundation_main]` macro handles CLI parsing, config
//! resolution, logging init, OIDC discovery, listener binding,
//! systemd integration, and graceful shutdown.  This file only
//! contains the application-specific setup.

use food4u_server::config::Config;
use food4u_server::routes;
use food4u_server::store::Store;
use food4u_server::web_base::AppState;
use rust_template_foundation::main as foundation_main;
use rust_template_foundation::Server;
use std::process::ExitCode;

#[foundation_main]
pub async fn main(
  config: Config,
  server: Server,
) -> Result<ExitCode, rust_template_foundation::ServerError> {
  let store = Store::new(config.data_file.clone());
  let server = server
    .with_state(move |base| AppState {
      base,
      store: store.clone(),
    })
    .merge(routes::router());
  server.listen().await?;
  Ok(ExitCode::SUCCESS)
}
