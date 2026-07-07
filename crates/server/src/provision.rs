//! New-user provisioning.
//!
//! A freshly authenticated account starts with no storage panes, which
//! leaves its Kitchen blank and with nowhere to drag foods.  This module
//! supplies the default set of empty panes such an account begins with —
//! the shipped seed's panes with their items stripped — so the store layer
//! can seed them on first access.

use crate::model::{Card, Model};
use crate::repo::RepoError;
use crate::store::{Store, StoreError};
use thiserror::Error;

#[derive(Debug, Error)]
pub enum ProvisionError {
  #[error("could not read the embedded default panes: {0}")]
  DefaultPanesRead(#[from] StoreError),
  #[error("the embedded default model is not a valid model: {0}")]
  DefaultPanesInvalid(#[from] serde_json::Error),
  #[error("could not access the store while provisioning a new user: {0}")]
  Store(#[from] RepoError),
}

/// The empty storage panes a new account starts with: the seed's panes with
/// their items dropped, so only the structure is seeded.
pub fn default_panes() -> Result<Vec<Card>, ProvisionError> {
  let seed: Model = serde_json::from_value(Store::default_model()?)?;
  Ok(
    seed
      .staples
      .into_iter()
      .map(|card| Card {
        items: Vec::new(),
        ..card
      })
      .collect(),
  )
}
