//! Seeding a fresh database with the bundled default foods and recipes.
//!
//! The defaults are a relational fixture — portable `INSERT` statements that
//! load on both SQLite and Postgres — run into an empty database on first
//! start.  This is the store of record's own format, replacing the retired
//! JSON model file and its import step.  The fixture is edited visually
//! through the app (see `just seed-edit` / `just seed-save`), not by hand.

use crate::db::{Db, DbError};
use crate::repo::RepoError;
use thiserror::Error;
use tracing::info;

/// The bundled default model, as portable SQL executed into an empty
/// database.  Regenerated from a seed-editing database by `dev/dump-seed.sh`.
const SEED_SQL: &str = include_str!("seed/seed.sql");

#[derive(Debug, Error)]
pub enum SeedError {
  #[error("could not check whether the database needs seeding: {0}")]
  SeedCheckRead(#[from] RepoError),
  #[error("could not seed the database with the default model: {source}")]
  SeedApplyWrite { source: DbError },
}

/// Seed the database with the bundled defaults when it is empty, so a fresh
/// install opens onto the default kitchen rather than nothing.  Emptiness is
/// judged by the shared catalog: no tiers means nothing has been seeded yet.
/// A no-op once the catalog is present, so it runs only on first start.
pub async fn seed_if_empty(db: &Db, user_id: &str) -> Result<(), SeedError> {
  if !db.load(user_id).await?.tiers.is_empty() {
    return Ok(());
  }

  db.execute_script(SEED_SQL)
    .await
    .map_err(|source| SeedError::SeedApplyWrite { source })?;
  info!("seeded the database with the default model");
  Ok(())
}
