//! The typed model faithfully represents the shipped seed document and
//! survives a round trip through JSON.
#![allow(clippy::expect_used, clippy::unwrap_used, clippy::panic)]

use food4u_server::model::Model;

const SEED: &str = include_str!("../src/seed/default_model.json");

#[test]
fn seed_deserializes_into_the_typed_model() {
  let model: Model = serde_json::from_str(SEED)
    .expect("the seed should deserialize into the typed model");

  let food_count: usize = model
    .tiers
    .iter()
    .flat_map(|tier| &tier.groups)
    .map(|group| group.foods.len())
    .sum();

  assert!(
    food_count > 400,
    "expected the full seeded catalog, got {food_count} foods"
  );
  assert!(!model.staples.is_empty(), "expected the storage panes");
}

#[test]
fn the_typed_model_round_trips_through_json() {
  let model: Model = serde_json::from_str(SEED).unwrap();
  let reserialized = serde_json::to_string(&model).unwrap();
  let again: Model = serde_json::from_str(&reserialized).unwrap();

  assert_eq!(
    model, again,
    "re-parsing the serialized model should reproduce it exactly"
  );
}
