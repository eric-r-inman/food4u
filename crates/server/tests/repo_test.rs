//! The relational repository decomposes the model into tables and
//! assembles it back without loss.
#![allow(clippy::expect_used, clippy::unwrap_used, clippy::panic)]

use food4u_server::db::connect_and_migrate;
use food4u_server::model::{
  Card, Food, Group, Item, Model, PlannerEntry, Recipe, Tier,
};
use food4u_server::repo;

const SEED_SQL: &str = include_str!("../src/seed/seed.sql");

async fn fresh_pool() -> sqlx::SqlitePool {
  let file = tempfile::NamedTempFile::new().unwrap();
  let url = format!("sqlite://{}", file.path().display());
  // Keep the temp file alive for the pool's lifetime by leaking the handle;
  // the test process is short-lived so the file is cleaned up on exit.
  std::mem::forget(file);
  connect_and_migrate(&url).await.unwrap()
}

#[tokio::test]
async fn the_seed_loads_into_a_complete_model_and_round_trips() {
  let pool = fresh_pool().await;

  // The bundled seed loads into an empty database (foreign keys are on, so a
  // wrong insert order would fail here) and assembles into the full model.
  sqlx::raw_sql(SEED_SQL).execute(&pool).await.unwrap();
  let model = repo::load(&pool, "local").await.unwrap();

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
  assert!(!model.recipes.is_empty(), "expected the seeded recipes");

  // The seeded model round-trips through the repository unchanged.
  repo::save(&pool, "local", &model).await.unwrap();
  let again = repo::load(&pool, "local").await.unwrap();
  assert_eq!(model, again, "the reloaded model should equal the seeded one");
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
        count: 1,
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
        count: 1,
      }],
      instructions: "Toss it.".into(),
      bookmarked: false,
      tags: vec!["quick".into(), "vegetarian".into()],
    }],
    // The same recipe planned twice — the planner allows copies.
    planner: vec![
      PlannerEntry {
        id: "p1".into(),
        day: 0,
        meal: "Lunch".into(),
        recipe_id: "r1".into(),
      },
      PlannerEntry {
        id: "p2".into(),
        day: 3,
        meal: "Dinner".into(),
        recipe_id: "r1".into(),
      },
    ],
    // A non-default length, so the round-trip proves it persists.
    planner_days: 9,
    // A non-canonical arrangement, so the round-trip proves it persists.
    column_order: vec!["cart".into(), "pyramid".into(), "recipes".into()],
  };

  repo::save(&pool, "local", &model).await.unwrap();
  let loaded = repo::load(&pool, "local").await.unwrap();
  assert_eq!(model, loaded);

  // Saving again replaces rather than duplicates.
  repo::save(&pool, "local", &model).await.unwrap();
  let again = repo::load(&pool, "local").await.unwrap();
  assert_eq!(model, again);
}
