//! New-user provisioning.
//!
//! A freshly authenticated account starts with no storage panes, which
//! leaves its Kitchen blank and with nowhere to drag foods.  This module
//! supplies the default set of empty panes such an account begins with — the
//! seeded local user's panes with their items stripped — so the store layer
//! can seed them on first access.

use crate::db::Db;
use crate::model::Card;
use crate::repo::RepoError;
use crate::LOCAL_USER;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum ProvisionError {
  #[error("could not access the store while provisioning a new user: {0}")]
  Store(#[from] RepoError),
}

/// The empty storage panes a new account starts with: the template user's
/// panes with their items dropped, so only the structure is seeded.  The
/// template is the seeded local user, so the panes stay in step with the
/// bundled defaults without a second source of truth.
pub async fn default_panes(db: &Db) -> Result<Vec<Card>, ProvisionError> {
  Ok(
    db.load(LOCAL_USER)
      .await?
      .staples
      .into_iter()
      .map(|card| Card {
        items: Vec::new(),
        ..card
      })
      .collect(),
  )
}
