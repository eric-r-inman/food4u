//! The seed's names are load-bearing: a recipe ingredient or an Auto
//! staple earns its tier tint, stock tracking, and shopping-list identity
//! only when its name matches a catalog food exactly, so a catalog rename
//! that leaves either behind breaks them silently.  These tests re-check
//! that contract against the bundled seed on every run, closing the gap
//! the Elm suite documents: the catalog lives server-side, out of an Elm
//! test's reach.  `dev/check-seed.sh` runs the same audit against a
//! seed-editing session before its dump is baked in.
#![allow(clippy::expect_used, clippy::unwrap_used, clippy::panic)]

use std::collections::BTreeSet;

use food4u_server::db::Db;
use food4u_server::model::Model;
use food4u_server::seed::seed_if_empty;
use food4u_server::LOCAL_USER;

/// The Auto staples data, read from the frontend source at compile time so
/// the two sides can never be tested against different revisions.
const STAPLES_ELM: &str = include_str!("../../../frontend/src/Staples.elm");

/// The bundled default model, seeded exactly as the server does it.
async fn seeded_model() -> Model {
  let file = tempfile::NamedTempFile::new().unwrap();
  let url = format!("sqlite://{}", file.path().display());
  std::mem::forget(file);
  let db = Db::connect(&url).await.unwrap();
  seed_if_empty(&db, LOCAL_USER).await.unwrap();
  db.load(LOCAL_USER).await.unwrap()
}

/// Every catalog food name, lowercased for the case-insensitive match the
/// frontend uses.
fn catalog(model: &Model) -> BTreeSet<String> {
  model
    .tiers
    .iter()
    .flat_map(|t| &t.groups)
    .flat_map(|g| &g.foods)
    .map(|f| f.name.to_lowercase())
    .collect()
}

/// Every staple name in `Staples.elm`: the quoted strings inside each
/// `staples = [ ... ]` list.  A bracket scan rather than a line match, so
/// a reformat that wraps the lists does not blind the test.
fn staples_from_elm() -> Vec<String> {
  STAPLES_ELM
    .split("staples =")
    .skip(1)
    .flat_map(|after| {
      let list_start = after.find('[').unwrap();
      let list_end = after[list_start..].find(']').unwrap() + list_start;
      after[list_start..list_end]
        .split('"')
        .skip(1)
        .step_by(2)
        .map(str::to_string)
        .collect::<Vec<_>>()
    })
    .collect()
}

#[tokio::test]
async fn every_recipe_ingredient_matches_a_catalog_food() {
  let model = seeded_model().await;
  let catalog = catalog(&model);

  let orphans: Vec<String> = model
    .recipes
    .iter()
    .flat_map(|r| r.ingredients.iter().map(move |i| (r, i)))
    .filter(|(_, i)| !catalog.contains(&i.name.to_lowercase()))
    .map(|(r, i)| format!("{:?} in {:?}", i.name, r.name))
    .collect();

  assert!(
    orphans.is_empty(),
    "recipe ingredients no longer matching any catalog food \
     (rename the chip or restore the food): {orphans:#?}"
  );
}

#[tokio::test]
async fn every_auto_staple_matches_a_catalog_food() {
  let model = seeded_model().await;
  let catalog = catalog(&model);
  let staples = staples_from_elm();

  assert!(
    staples.len() >= 100,
    "the Staples.elm parse found suspiciously few staples ({}); \
     did the file's shape change?",
    staples.len()
  );

  let orphans: Vec<&String> = staples
    .iter()
    .filter(|s| !catalog.contains(&s.to_lowercase()))
    .collect();

  assert!(
    orphans.is_empty(),
    "Auto staples no longer matching any catalog food \
     (update Staples.elm or restore the food): {orphans:#?}"
  );
}

#[tokio::test]
async fn no_auto_staple_is_a_leafy_green() {
  let model = seeded_model().await;
  let leafy: BTreeSet<String> = model
    .tiers
    .iter()
    .flat_map(|t| &t.groups)
    .filter(|g| g.label == "Leafy greens")
    .flat_map(|g| &g.foods)
    .map(|f| f.name.to_lowercase())
    .collect();

  assert!(
    !leafy.is_empty(),
    "the catalog's leafy-greens category was not found; \
     did its label change?"
  );

  let offenders: Vec<String> = staples_from_elm()
    .into_iter()
    .filter(|s| leafy.contains(&s.to_lowercase()))
    .collect();

  assert!(
    offenders.is_empty(),
    "staples are pantry stock, and leafy greens are weekly fresh \
     shopping (see docs/staples-auto-populate.org): {offenders:#?}"
  );
}
