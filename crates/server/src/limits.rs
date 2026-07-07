//! Per-user size limits on a stored model.
//!
//! A write replaces the whole model, so without a ceiling one account
//! could exhaust storage with a single request.  These bounds are far
//! above any real longevity kitchen — the shipped catalog is ~500 foods —
//! so they never constrain honest use, only abuse.

use crate::model::Model;
use thiserror::Error;

const MAX_FOODS: usize = 5_000;
const MAX_STORAGE_PANES: usize = 50;
const MAX_STORAGE_ITEMS: usize = 10_000;
const MAX_RECIPES: usize = 1_000;
const MAX_INGREDIENTS: usize = 20_000;

/// A model that exceeds one of the size limits.  Carries a human-readable
/// description of which limit and by how much.
#[derive(Debug, Error)]
#[error("the model is too large: {0}")]
pub struct QuotaExceeded(pub String);

/// Reject a model whose size exceeds any per-user limit.
pub fn check(model: &Model) -> Result<(), QuotaExceeded> {
  ceiling(
    "foods",
    model
      .tiers
      .iter()
      .flat_map(|tier| &tier.groups)
      .map(|group| group.foods.len())
      .sum::<usize>(),
    MAX_FOODS,
  )?;
  ceiling("storage panes", model.staples.len(), MAX_STORAGE_PANES)?;
  ceiling(
    "storage items",
    model
      .staples
      .iter()
      .map(|card| card.items.len())
      .sum::<usize>(),
    MAX_STORAGE_ITEMS,
  )?;
  ceiling("recipes", model.recipes.len(), MAX_RECIPES)?;
  ceiling(
    "recipe ingredients",
    model
      .recipes
      .iter()
      .map(|recipe| recipe.ingredients.len())
      .sum::<usize>(),
    MAX_INGREDIENTS,
  )?;
  Ok(())
}

fn ceiling(what: &str, count: usize, max: usize) -> Result<(), QuotaExceeded> {
  if count > max {
    return Err(QuotaExceeded(format!(
      "{count} {what} exceeds the limit of {max}"
    )));
  }
  Ok(())
}
