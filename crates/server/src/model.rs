//! Typed representation of the food model.
//!
//! The frontend owns the model's shape and the server has so far treated
//! it as an opaque JSON blob.  As the model moves to relational storage
//! the server needs to understand it: these types mirror the Elm schema
//! exactly, so a document that deserializes here is one the frontend
//! produced, and one that does not can be rejected at the edge rather than
//! persisted.  Fields absent in older saved documents default the same way
//! the Elm decoders default them.

use serde::{Deserialize, Serialize};

/// The whole model: the longevity pyramid, the kitchen storage panes, and
/// the recipes.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Model {
  pub tiers: Vec<Tier>,
  pub staples: Vec<Card>,
  #[serde(default)]
  pub recipes: Vec<Recipe>,
}

/// One band of the pyramid (Foundation, Daily, and so on) and its
/// category groups.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Tier {
  pub id: String,
  pub no: String,
  pub name: String,
  pub freq: String,
  pub width: String,
  pub rail: String,
  pub tint: String,
  pub line: String,
  pub groups: Vec<Group>,
}

/// A category within a tier and the foods filed under it.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Group {
  pub id: String,
  pub label: String,
  pub foods: Vec<Food>,
}

/// A single food in the pyramid.  `na` marks it as stocked; `recipe_id`
/// links it to a recipe when non-empty.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Food {
  pub id: String,
  pub name: String,
  pub prep: String,
  pub hero: bool,
  pub na: bool,
  #[serde(default, rename = "recipeId")]
  pub recipe_id: String,
}

/// A storage pane — a kitchen location, the Shopping List, or one of the
/// Shopping List's user-created categories — and its items.  `zone`
/// separates the Kitchen column's panes from the Shopping List column's
/// categories; it defaults to `kitchen` so documents written before the
/// zone existed decode as ordinary kitchen panes.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Card {
  pub id: String,
  pub name: String,
  pub meta: String,
  pub rail: String,
  pub line: String,
  pub note: String,
  #[serde(default = "kitchen_zone")]
  pub zone: String,
  pub items: Vec<Item>,
}

/// The default zone for a storage location: the Kitchen column.
fn kitchen_zone() -> String {
  "kitchen".to_string()
}

/// A single stored item within a storage pane or a recipe's ingredient.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Item {
  pub id: String,
  pub name: String,
  pub na: bool,
}

/// A recipe: its meal category, ingredient chips, and free-text
/// instructions.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Recipe {
  pub id: String,
  pub name: String,
  pub category: String,
  pub ingredients: Vec<Item>,
  #[serde(default)]
  pub instructions: String,
}
