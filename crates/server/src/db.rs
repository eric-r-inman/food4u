//! Relational database access: connection pooling and schema migrations.
//!
//! This module owns the connection pool and brings the schema up to date
//! on startup, and dispatches reads and writes to the backend the
//! configuration selected.  SQLite is the verified local backend;
//! PostgreSQL is scaffolded but unverified (see [`crate::repo_pg`]).

use crate::model::Model;
use crate::repo::RepoError;
use crate::{repo, repo_pg};
use sqlx::postgres::{PgPool, PgPoolOptions};
use sqlx::sqlite::{SqliteConnectOptions, SqlitePool, SqlitePoolOptions};
use std::str::FromStr;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum DbError {
  // A SQLite url is a bare file path, safe to show as is; a PostgreSQL url
  // carries `user:password@host`, so `connect_postgres` redacts it before
  // it reaches these messages.
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

/// Open a pooled connection to PostgreSQL and bring its schema up to date.
///
/// UNVERIFIED — see [`crate::repo_pg`].  The url is redacted before it can
/// reach an error message, since a PostgreSQL url carries credentials.
async fn connect_postgres(url: &str) -> Result<PgPool, DbError> {
  let pool = PgPoolOptions::new().connect(url).await.map_err(|source| {
    DbError::DatabaseConnect {
      url: redact(url),
      source,
    }
  })?;
  sqlx::migrate!("./migrations")
    .run(&pool)
    .await
    .map_err(|source| DbError::MigrationFailed { source })?;
  Ok(pool)
}

/// Strip any `user:password@` from a database url so it is safe to log.
fn redact(url: &str) -> String {
  match (url.find("://"), url.find('@')) {
    (Some(scheme_end), Some(at)) if at > scheme_end => {
      format!("{}://***@{}", &url[..scheme_end], &url[at + 1..])
    }
    _ => url.to_string(),
  }
}

/// A connection pool for whichever backend the configuration selected.
#[derive(Clone)]
pub enum Db {
  Sqlite(SqlitePool),
  Postgres(PgPool),
}

impl Db {
  /// Open the backend named by the url scheme and migrate it.  A
  /// `postgres:`/`postgresql:` url selects PostgreSQL; anything else is
  /// treated as SQLite.
  pub async fn connect(url: &str) -> Result<Db, DbError> {
    if url.starts_with("postgres:") || url.starts_with("postgresql:") {
      Ok(Db::Postgres(connect_postgres(url).await?))
    } else {
      Ok(Db::Sqlite(connect_and_migrate(url).await?))
    }
  }

  /// Assemble the model for one user.
  pub async fn load(&self, user_id: &str) -> Result<Model, RepoError> {
    match self {
      Db::Sqlite(pool) => repo::load(pool, user_id).await,
      Db::Postgres(pool) => repo_pg::load(pool, user_id).await,
    }
  }

  /// Persist the whole model for one user, replacing what was there.
  pub async fn save(
    &self,
    user_id: &str,
    model: &Model,
  ) -> Result<(), RepoError> {
    match self {
      Db::Sqlite(pool) => repo::save(pool, user_id, model).await,
      Db::Postgres(pool) => repo_pg::save(pool, user_id, model).await,
    }
  }
}
