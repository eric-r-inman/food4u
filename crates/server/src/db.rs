//! Relational database access: connection pooling and schema migrations.
//!
//! The food model is moving from a single JSON document to relational
//! storage.  This module owns the connection pool and brings the schema up
//! to date on startup.  SQLite is the local backend; the same migrations
//! are intended to serve PostgreSQL once the hosted path lands.

use sqlx::sqlite::{SqliteConnectOptions, SqlitePool, SqlitePoolOptions};
use std::str::FromStr;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum DbError {
  // The url is safe to show while SQLite is the only backend — it is a
  // bare file path.  When the PostgreSQL backend lands its url carries
  // `user:password@host`, so these messages must render a redacted form
  // (path or host only) before that url can reach them.
  #[error("database url is not valid ({url}): {source}")]
  DatabaseUrlInvalid { url: String, source: sqlx::Error },
  #[error("could not open the database at {url}: {source}")]
  DatabaseConnect { url: String, source: sqlx::Error },
  #[error("could not apply the database migrations: {source}")]
  MigrationFailed { source: sqlx::migrate::MigrateError },
}

/// Open a pooled connection to the SQLite database and bring its schema up
/// to date.  Foreign keys are enabled per connection because SQLite leaves
/// them off by default, and the file is created when absent so a fresh
/// install starts from an empty database.
pub async fn connect_and_migrate(url: &str) -> Result<SqlitePool, DbError> {
  let options = SqliteConnectOptions::from_str(url)
    .map_err(|source| DbError::DatabaseUrlInvalid {
      url: url.to_string(),
      source,
    })?
    .foreign_keys(true)
    .create_if_missing(true);
  let pool = SqlitePoolOptions::new()
    .connect_with(options)
    .await
    .map_err(|source| DbError::DatabaseConnect {
      url: url.to_string(),
      source,
    })?;
  sqlx::migrate!("./migrations")
    .run(&pool)
    .await
    .map_err(|source| DbError::MigrationFailed { source })?;
  Ok(pool)
}
