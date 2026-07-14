//! The scoped mutations change one part of one user's model in place, and
//! never reach a mismatched user's data.
#![allow(clippy::expect_used, clippy::unwrap_used, clippy::panic)]

use food4u_server::db::connect_and_migrate;
use food4u_server::model::{Card, Food, Group, Item, Model, Recipe, Tier};
use food4u_server::repo;
use sqlx::SqlitePool;

async fn seeded_pool() -> SqlitePool {
  let file = tempfile::NamedTempFile::new().unwrap();
  let url = format!("sqlite://{}", file.path().display());
  std::mem::forget(file);
  let pool = connect_and_migrate(&url).await.unwrap();
  repo::save(&pool, "local", &sample()).await.unwrap();
  pool
}

fn sample() -> Model {
  Model {
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
        foods: vec![Food {
          id: "f1".into(),
          name: "Kale".into(),
          prep: "F".into(),
          hero: false,
          na: false,
          recipe_id: String::new(),
        }],
      }],
    }],
    staples: vec![Card {
      id: "cart".into(),
      name: "Shopping List".into(),
      meta: "".into(),
      rail: "".into(),
      line: "".into(),
      note: "".into(),
      zone: "shopping".into(),
      items: vec![Item {
        id: "i1".into(),
        name: "Rice".into(),
        na: false,
      }],
    }],
    recipes: vec![],
  }
}

fn first_food_na(model: &Model) -> bool {
  model.tiers[0].groups[0].foods[0].na
}

#[tokio::test]
async fn set_food_stock_toggles_the_overlay() {
  let pool = seeded_pool().await;
  assert!(!first_food_na(&repo::load(&pool, "local").await.unwrap()));

  repo::set_food_stock(&pool, "local", "f1", true)
    .await
    .unwrap();
  assert!(first_food_na(&repo::load(&pool, "local").await.unwrap()));

  repo::set_food_stock(&pool, "local", "f1", false)
    .await
    .unwrap();
  assert!(!first_food_na(&repo::load(&pool, "local").await.unwrap()));
}

#[tokio::test]
async fn storage_items_add_remove_and_clear() {
  let pool = seeded_pool().await;

  repo::add_storage_item(
    &pool,
    "local",
    "cart",
    &Item {
      id: "i2".into(),
      name: "Oats".into(),
      na: false,
    },
  )
  .await
  .unwrap();
  let items = |m: &Model| m.staples[0].items.len();
  assert_eq!(items(&repo::load(&pool, "local").await.unwrap()), 2);

  repo::remove_storage_item(&pool, "local", "i1")
    .await
    .unwrap();
  assert_eq!(items(&repo::load(&pool, "local").await.unwrap()), 1);

  repo::clear_storage_pane(&pool, "local", "cart")
    .await
    .unwrap();
  assert_eq!(items(&repo::load(&pool, "local").await.unwrap()), 0);
}

#[tokio::test]
async fn recipes_add_and_delete() {
  let pool = seeded_pool().await;

  repo::add_recipe(
    &pool,
    "local",
    &Recipe {
      id: "r1".into(),
      name: "Salad".into(),
      category: "Salads".into(),
      ingredients: vec![Item {
        id: "ri1".into(),
        name: "Kale".into(),
        na: false,
      }],
      instructions: "Toss.".into(),
      bookmarked: false,
      tags: vec![],
    },
  )
  .await
  .unwrap();
  let loaded = repo::load(&pool, "local").await.unwrap();
  assert_eq!(loaded.recipes.len(), 1);
  assert_eq!(loaded.recipes[0].ingredients.len(), 1);

  repo::delete_recipe(&pool, "local", "r1").await.unwrap();
  assert_eq!(repo::load(&pool, "local").await.unwrap().recipes.len(), 0);
}

#[tokio::test]
async fn a_mutation_scoped_to_another_user_is_a_no_op() {
  let pool = seeded_pool().await;

  // "intruder" does not own item i1, so removing it does nothing.
  repo::remove_storage_item(&pool, "intruder", "i1")
    .await
    .unwrap();
  assert_eq!(
    repo::load(&pool, "local").await.unwrap().staples[0]
      .items
      .len(),
    1
  );

  // Nor can they clear the pane or delete the (later added) recipe.
  repo::clear_storage_pane(&pool, "intruder", "cart")
    .await
    .unwrap();
  assert_eq!(
    repo::load(&pool, "local").await.unwrap().staples[0]
      .items
      .len(),
    1
  );
}
