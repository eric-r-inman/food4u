//! food4u-server — entry point.
//!
//! The `#[foundation_main]` macro handles CLI parsing, config
//! resolution, logging init, OIDC discovery, listener binding,
//! systemd integration, and graceful shutdown.  This file only
//! contains the application-specific setup.

use food4u_server::config::Config;
use food4u_server::db::Db;
use food4u_server::routes;
use food4u_server::seed::seed_if_empty;
use food4u_server::web_base::AppState;
use food4u_server::LOCAL_USER;
use rust_template_foundation::main as foundation_main;
use rust_template_foundation::Server;
use std::process::ExitCode;
use tracing::error;

#[foundation_main]
pub async fn main(
  config: Config,
  server: Server,
) -> Result<ExitCode, rust_template_foundation::ServerError> {
  let db = match Db::connect(&config.database_url).await {
    Ok(db) => db,
    Err(source) => {
      error!(error = %source, "could not open the database");
      return Ok(ExitCode::FAILURE);
    }
  };

  if let Err(source) = seed_if_empty(&db, LOCAL_USER).await {
    error!(error = %source, "could not seed the database with the default model");
    return Ok(ExitCode::FAILURE);
  }

  let server = server
    .with_state(move |base| AppState {
      base,
      db: db.clone(),
      user_id: LOCAL_USER.to_string(),
    })
    .merge(routes::router());
  server.listen().await?;
  Ok(ExitCode::SUCCESS)
}
