//! The relational repository decomposes the model into tables and
//! assembles it back without loss.
#![allow(clippy::expect_used, clippy::unwrap_used, clippy::panic)]

use food4u_server::db::connect_and_migrate;
use food4u_server::model::{Card, Food, Group, Item, Model, Recipe, Tier};
use food4u_server::repo;

const SEED: &str = include_str!("../src/seed/default_model.json");

async fn fresh_pool() -> sqlx::SqlitePool {
  let file = tempfile::NamedTempFile::new().unwrap();
  let url = format!("sqlite://{}", file.path().display());
  // Keep the temp file alive for the pool's lifetime by leaking the handle;
  // the test process is short-lived so the file is cleaned up on exit.
  std::mem::forget(file);
  connect_and_migrate(&url).await.unwrap()
}

#[tokio::test]
async fn the_seed_model_round_trips_through_the_store() {
  let pool = fresh_pool().await;
  let model: Model = serde_json::from_str(SEED).unwrap();

  repo::save(&pool, "local", &model).await.unwrap();
  let loaded = repo::load(&pool, "local").await.unwrap();

  assert_eq!(model, loaded, "the loaded model should equal the saved one");
}

#[tokio::test]
async fn per_user_overlay_and_ordering_are_preserved() {
  let pool = fresh_pool().await;

  // A small model exercising stock flags, a recipe link, storage items,
  // and a recipe with ingredients — the parts the overlay and the child
  // tables carry.
  let model = Model {
    tiers: vec![Tier {
      id: "t1".into(),
      no: "01".into(),
      name: "Foundation".into(),
      freq: "daily".into(),
      width: "wide".into(),
      rail: "#111".into(),
      tint: "#eee".into(),
      line: "#ccc".into(),
      groups: vec![Group {
        id: "g1".into(),
        label: "Greens".into(),
        foods: vec![
          Food {
            id: "f1".into(),
            name: "Kale".into(),
            prep: "F".into(),
            hero: true,
            na: true,
            recipe_id: "r1".into(),
          },
          Food {
            id: "f2".into(),
            name: "Spinach".into(),
            prep: "F".into(),
            hero: false,
            na: false,
            recipe_id: String::new(),
          },
        ],
      }],
    }],
    staples: vec![Card {
      id: "c1".into(),
      name: "Pantry".into(),
      meta: "dry goods".into(),
      rail: "#222".into(),
      line: "#333".into(),
      note: "".into(),
      zone: "kitchen".into(),
      items: vec![Item {
        id: "i1".into(),
        name: "Rice".into(),
        na: true,
      }],
    }],
    recipes: vec![Recipe {
      id: "r1".into(),
      name: "Salad".into(),
      category: "Salads".into(),
      ingredients: vec![Item {
        id: "in1".into(),
        name: "Kale".into(),
        na: false,
      }],
      instructions: "Toss it.".into(),
      bookmarked: false,
    }],
  };

  repo::save(&pool, "local", &model).await.unwrap();
  let loaded = repo::load(&pool, "local").await.unwrap();
  assert_eq!(model, loaded);

  // Saving again replaces rather than duplicates.
  repo::save(&pool, "local", &model).await.unwrap();
  let again = repo::load(&pool, "local").await.unwrap();
  assert_eq!(model, again);
}
