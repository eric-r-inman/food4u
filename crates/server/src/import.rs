//! One-time import of the legacy JSON model into the relational store.
//!
//! The server used to persist the model as a single JSON file.  On the
//! first run against an empty database this reads that file — or, when the
//! user never saved one, the embedded seed the old store served — and
//! writes it into the tables, so nothing is lost in the switchover.  The
//! legacy file is only read, never removed, so it remains as a backup.

use crate::config::Config;
use crate::db::Db;
use crate::model::Model;
use crate::repo::RepoError;
use crate::store::{Store, StoreError};
use thiserror::Error;
use tracing::info;

#[derive(Debug, Error)]
pub enum ImportError {
  #[error("could not check the relational store for existing data: {0}")]
  StoreRead(#[from] RepoError),
  #[error("could not read the legacy model file: {0}")]
  LegacyRead(#[from] StoreError),
  #[error("the legacy model file is not a valid model: {0}")]
  LegacyInvalid(#[from] serde_json::Error),
}

/// Import the legacy model for `user_id` when that user has no model in the
/// database yet.  A no-op once the store holds data.
pub async fn import_legacy_if_empty(
  db: &Db,
  config: &Config,
  user_id: &str,
) -> Result<(), ImportError> {
  if !db.load(user_id).await?.tiers.is_empty() {
    return Ok(());
  }

  let legacy = Store::new(config.data_file.clone()).load().await?;
  let model: Model = serde_json::from_value(legacy)?;
  db.save(user_id, &model).await?;
  info!("imported the existing model into the relational store");
  Ok(())
}
