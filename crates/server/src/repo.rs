//! The relational repository: decompose the model into the schema's tables
//! and assemble it back.
//!
//! This maps the typed [`Model`] to and from the relational schema for a
//! single user.  A write clears the user's rows and re-inserts the whole
//! model in one transaction, matching the current full-document PUT; the
//! finer-grained per-mutation writes come with the scoped API.  A read
//! reconstructs the model with a handful of ordered queries, joining each
//! catalog food to the user's stock and recipe-link overlay.

use crate::model::{Card, Food, Group, Item, Model, Recipe, Tier};
use sqlx::SqlitePool;
use std::collections::HashMap;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum RepoError {
  #[error("could not read the food model from the database: {source}")]
  ModelRead { source: sqlx::Error },
  #[error("could not write the food model to the database: {source}")]
  ModelWrite { source: sqlx::Error },
  #[error("could not set the stock state of food {food_id}: {source}")]
  FoodStockWrite {
    food_id: String,
    source: sqlx::Error,
  },
  #[error("could not add a storage item: {source}")]
  StorageItemAdd { source: sqlx::Error },
  #[error("could not remove a storage item: {source}")]
  StorageItemRemove { source: sqlx::Error },
  #[error("could not clear a storage pane: {source}")]
  StoragePaneClear { source: sqlx::Error },
  #[error("could not provision a new user's default panes: {source}")]
  PaneProvision { source: sqlx::Error },
  #[error("could not add a recipe: {source}")]
  RecipeAdd { source: sqlx::Error },
  #[error("could not delete a recipe: {source}")]
  RecipeDelete { source: sqlx::Error },
}

#[derive(sqlx::FromRow)]
pub(crate) struct TierRow {
  id: String,
  no: String,
  name: String,
  freq: String,
  width: String,
  rail: String,
  tint: String,
  line: String,
}

#[derive(sqlx::FromRow)]
pub(crate) struct GroupRow {
  id: String,
  tier_id: String,
  label: String,
}

#[derive(sqlx::FromRow)]
pub(crate) struct FoodRow {
  id: String,
  group_id: String,
  name: String,
  prep: String,
  hero: bool,
  na: bool,
  recipe_id: String,
}

#[derive(sqlx::FromRow)]
pub(crate) struct CardRow {
  id: String,
  name: String,
  meta: String,
  rail: String,
  line: String,
  note: String,
  zone: String,
}

#[derive(sqlx::FromRow)]
pub(crate) struct StorageItemRow {
  location_id: String,
  id: String,
  name: String,
  na: bool,
}

#[derive(sqlx::FromRow)]
pub(crate) struct RecipeRow {
  id: String,
  name: String,
  category: String,
  instructions: String,
}

#[derive(sqlx::FromRow)]
pub(crate) struct IngredientRow {
  recipe_id: String,
  id: String,
  name: String,
  na: bool,
}

/// Assemble the whole model for one user.
pub async fn load(
  pool: &SqlitePool,
  user_id: &str,
) -> Result<Model, RepoError> {
  let read = |source| RepoError::ModelRead { source };

  let tiers = sqlx::query_as::<_, TierRow>(
    "select id, no, name, freq, width, rail, tint, line from tiers order by position",
  )
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let groups = sqlx::query_as::<_, GroupRow>(
    "select id, tier_id, label from food_groups order by tier_id, position",
  )
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let foods = sqlx::query_as::<_, FoodRow>(
    "select f.id, f.group_id, f.name, f.prep, f.hero, \
     coalesce(s.in_stock, 0) as na, coalesce(s.recipe_id, '') as recipe_id \
     from foods f \
     left join user_food_state s on s.food_id = f.id and s.user_id = ? \
     order by f.group_id, f.position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let locations = sqlx::query_as::<_, CardRow>(
    "select id, name, meta, rail, line, note, zone from storage_locations \
     where user_id = ? order by position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let items = sqlx::query_as::<_, StorageItemRow>(
    "select i.location_id, i.id, i.name, i.needs as na from storage_items i \
     join storage_locations l on l.id = i.location_id \
     where l.user_id = ? order by i.location_id, i.position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let recipes = sqlx::query_as::<_, RecipeRow>(
    "select id, name, category, instructions from recipes \
     where user_id = ? order by position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let ingredients = sqlx::query_as::<_, IngredientRow>(
    "select g.recipe_id, g.id, g.name, g.needs as na from recipe_ingredients g \
     join recipes r on r.id = g.recipe_id \
     where r.user_id = ? order by g.recipe_id, g.position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  Ok(assemble(tiers, groups, foods, locations, items, recipes, ingredients))
}

/// Build the model from the ordered row sets: bucket each child by its
/// parent id, then assemble the parents in order.  Shared by the SQLite
/// and PostgreSQL read paths, which differ only in how they fetch.
pub(crate) fn assemble(
  tiers: Vec<TierRow>,
  groups: Vec<GroupRow>,
  foods: Vec<FoodRow>,
  locations: Vec<CardRow>,
  items: Vec<StorageItemRow>,
  recipes: Vec<RecipeRow>,
  ingredients: Vec<IngredientRow>,
) -> Model {
  let mut foods_by_group: HashMap<String, Vec<Food>> = HashMap::new();
  for row in foods {
    foods_by_group.entry(row.group_id).or_default().push(Food {
      id: row.id,
      name: row.name,
      prep: row.prep,
      hero: row.hero,
      na: row.na,
      recipe_id: row.recipe_id,
    });
  }

  let mut groups_by_tier: HashMap<String, Vec<Group>> = HashMap::new();
  for row in groups {
    let foods = foods_by_group.remove(&row.id).unwrap_or_default();
    groups_by_tier.entry(row.tier_id).or_default().push(Group {
      id: row.id,
      label: row.label,
      foods,
    });
  }

  let mut items_by_location: HashMap<String, Vec<Item>> = HashMap::new();
  for row in items {
    items_by_location
      .entry(row.location_id)
      .or_default()
      .push(Item {
        id: row.id,
        name: row.name,
        na: row.na,
      });
  }

  let mut ingredients_by_recipe: HashMap<String, Vec<Item>> = HashMap::new();
  for row in ingredients {
    ingredients_by_recipe
      .entry(row.recipe_id)
      .or_default()
      .push(Item {
        id: row.id,
        name: row.name,
        na: row.na,
      });
  }

  Model {
    tiers: tiers
      .into_iter()
      .map(|row| Tier {
        groups: groups_by_tier.remove(&row.id).unwrap_or_default(),
        id: row.id,
        no: row.no,
        name: row.name,
        freq: row.freq,
        width: row.width,
        rail: row.rail,
        tint: row.tint,
        line: row.line,
      })
      .collect(),
    staples: locations
      .into_iter()
      .map(|row| Card {
        items: items_by_location.remove(&row.id).unwrap_or_default(),
        id: row.id,
        name: row.name,
        meta: row.meta,
        rail: row.rail,
        line: row.line,
        note: row.note,
        zone: row.zone,
      })
      .collect(),
    recipes: recipes
      .into_iter()
      .map(|row| Recipe {
        ingredients: ingredients_by_recipe.remove(&row.id).unwrap_or_default(),
        id: row.id,
        name: row.name,
        category: row.category,
        instructions: row.instructions,
      })
      .collect(),
  }
}

/// Decompose and persist the whole model for one user, replacing whatever
/// was there.  Runs in a single transaction so a failure leaves the prior
/// model intact.
pub async fn save(
  pool: &SqlitePool,
  user_id: &str,
  model: &Model,
) -> Result<(), RepoError> {
  let write = |source| RepoError::ModelWrite { source };
  let mut tx = pool.begin().await.map_err(write)?;

  sqlx::query(
    "insert or ignore into users (id, email, display_name, created_at) \
     values (?, '', '', '')",
  )
  .bind(user_id)
  .execute(&mut *tx)
  .await
  .map_err(write)?;

  // Clear the prior model.  Deleting the tiers cascades to groups, foods,
  // and the food-state overlay; the user's storage and recipes go by user.
  sqlx::query("delete from tiers")
    .execute(&mut *tx)
    .await
    .map_err(write)?;
  sqlx::query("delete from storage_locations where user_id = ?")
    .bind(user_id)
    .execute(&mut *tx)
    .await
    .map_err(write)?;
  sqlx::query("delete from recipes where user_id = ?")
    .bind(user_id)
    .execute(&mut *tx)
    .await
    .map_err(write)?;

  for (tier_pos, tier) in model.tiers.iter().enumerate() {
    sqlx::query(
      "insert into tiers (id, no, name, freq, width, rail, tint, line, position) \
       values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
    )
    .bind(&tier.id)
    .bind(&tier.no)
    .bind(&tier.name)
    .bind(&tier.freq)
    .bind(&tier.width)
    .bind(&tier.rail)
    .bind(&tier.tint)
    .bind(&tier.line)
    .bind(tier_pos as i64)
    .execute(&mut *tx)
    .await
    .map_err(write)?;

    for (group_pos, group) in tier.groups.iter().enumerate() {
      sqlx::query(
        "insert into food_groups (id, tier_id, label, position) values (?, ?, ?, ?)",
      )
      .bind(&group.id)
      .bind(&tier.id)
      .bind(&group.label)
      .bind(group_pos as i64)
      .execute(&mut *tx)
      .await
      .map_err(write)?;

      for (food_pos, food) in group.foods.iter().enumerate() {
        sqlx::query(
          "insert into foods (id, group_id, name, prep, hero, position) \
           values (?, ?, ?, ?, ?, ?)",
        )
        .bind(&food.id)
        .bind(&group.id)
        .bind(&food.name)
        .bind(&food.prep)
        .bind(food.hero)
        .bind(food_pos as i64)
        .execute(&mut *tx)
        .await
        .map_err(write)?;

        // Only foods the user has stocked or linked need an overlay row.
        if food.na || !food.recipe_id.is_empty() {
          let recipe_id: Option<&str> = if food.recipe_id.is_empty() {
            None
          } else {
            Some(&food.recipe_id)
          };
          sqlx::query(
            "insert into user_food_state (user_id, food_id, in_stock, recipe_id) \
             values (?, ?, ?, ?)",
          )
          .bind(user_id)
          .bind(&food.id)
          .bind(food.na)
          .bind(recipe_id)
          .execute(&mut *tx)
          .await
          .map_err(write)?;
        }
      }
    }
  }

  for (loc_pos, card) in model.staples.iter().enumerate() {
    sqlx::query(
      "insert into storage_locations \
       (id, user_id, name, meta, rail, line, note, zone, position) \
       values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
    )
    .bind(&card.id)
    .bind(user_id)
    .bind(&card.name)
    .bind(&card.meta)
    .bind(&card.rail)
    .bind(&card.line)
    .bind(&card.note)
    .bind(&card.zone)
    .bind(loc_pos as i64)
    .execute(&mut *tx)
    .await
    .map_err(write)?;

    for (item_pos, item) in card.items.iter().enumerate() {
      sqlx::query(
        "insert into storage_items (id, location_id, name, needs, position) \
         values (?, ?, ?, ?, ?)",
      )
      .bind(&item.id)
      .bind(&card.id)
      .bind(&item.name)
      .bind(item.na)
      .bind(item_pos as i64)
      .execute(&mut *tx)
      .await
      .map_err(write)?;
    }
  }

  for (recipe_pos, recipe) in model.recipes.iter().enumerate() {
    sqlx::query(
      "insert into recipes (id, user_id, name, category, instructions, position) \
       values (?, ?, ?, ?, ?, ?)",
    )
    .bind(&recipe.id)
    .bind(user_id)
    .bind(&recipe.name)
    .bind(&recipe.category)
    .bind(&recipe.instructions)
    .bind(recipe_pos as i64)
    .execute(&mut *tx)
    .await
    .map_err(write)?;

    for (ing_pos, ingredient) in recipe.ingredients.iter().enumerate() {
      sqlx::query(
        "insert into recipe_ingredients (id, recipe_id, name, needs, position) \
         values (?, ?, ?, ?, ?)",
      )
      .bind(&ingredient.id)
      .bind(&recipe.id)
      .bind(&ingredient.name)
      .bind(ingredient.na)
      .bind(ing_pos as i64)
      .execute(&mut *tx)
      .await
      .map_err(write)?;
    }
  }

  tx.commit().await.map_err(write)?;
  Ok(())
}

// Scoped mutations.  Each changes one part of one user's model in place,
// so a UI action is a small write rather than a rewrite of the whole
// document.  Every statement is constrained to the user's own rows, so a
// mutation can never reach another account's data even if handed a
// mismatched id — it simply affects nothing.

/// Set whether a catalog food is stocked for this user.
pub async fn set_food_stock(
  pool: &SqlitePool,
  user_id: &str,
  food_id: &str,
  in_stock: bool,
) -> Result<(), RepoError> {
  sqlx::query(
    "insert into user_food_state (user_id, food_id, in_stock) values (?, ?, ?) \
     on conflict (user_id, food_id) do update set in_stock = excluded.in_stock",
  )
  .bind(user_id)
  .bind(food_id)
  .bind(in_stock)
  .execute(pool)
  .await
  .map_err(|source| RepoError::FoodStockWrite {
    food_id: food_id.to_string(),
    source,
  })?;
  Ok(())
}

/// Append an item to one of the user's storage panes, at the end.  A no-op
/// when the pane is not the user's.
pub async fn add_storage_item(
  pool: &SqlitePool,
  user_id: &str,
  location_id: &str,
  item: &Item,
) -> Result<(), RepoError> {
  sqlx::query(
    "insert into storage_items (id, location_id, name, needs, position) \
     select ?, l.id, ?, ?, \
       coalesce((select max(position) from storage_items where location_id = l.id), -1) + 1 \
     from storage_locations l where l.id = ? and l.user_id = ?",
  )
  .bind(&item.id)
  .bind(&item.name)
  .bind(item.na)
  .bind(location_id)
  .bind(user_id)
  .execute(pool)
  .await
  .map_err(|source| RepoError::StorageItemAdd { source })?;
  Ok(())
}

/// Remove a storage item, only if it belongs to one of the user's panes.
pub async fn remove_storage_item(
  pool: &SqlitePool,
  user_id: &str,
  item_id: &str,
) -> Result<(), RepoError> {
  sqlx::query(
    "delete from storage_items where id = ? and location_id in \
     (select id from storage_locations where user_id = ?)",
  )
  .bind(item_id)
  .bind(user_id)
  .execute(pool)
  .await
  .map_err(|source| RepoError::StorageItemRemove { source })?;
  Ok(())
}

/// Empty a storage pane (used for the Shopping List's clear-all), only if
/// it belongs to the user.
pub async fn clear_storage_pane(
  pool: &SqlitePool,
  user_id: &str,
  location_id: &str,
) -> Result<(), RepoError> {
  sqlx::query(
    "delete from storage_items where location_id = ? and location_id in \
     (select id from storage_locations where user_id = ?)",
  )
  .bind(location_id)
  .bind(user_id)
  .execute(pool)
  .await
  .map_err(|source| RepoError::StoragePaneClear { source })?;
  Ok(())
}

/// Add a recipe for the user, at the end of their list, with its
/// ingredients.
pub async fn add_recipe(
  pool: &SqlitePool,
  user_id: &str,
  recipe: &Recipe,
) -> Result<(), RepoError> {
  let add = |source| RepoError::RecipeAdd { source };
  let mut tx = pool.begin().await.map_err(add)?;
  sqlx::query(
    "insert into recipes (id, user_id, name, category, instructions, position) \
     values (?, ?, ?, ?, ?, \
       (select coalesce(max(position), -1) + 1 from recipes where user_id = ?))",
  )
  .bind(&recipe.id)
  .bind(user_id)
  .bind(&recipe.name)
  .bind(&recipe.category)
  .bind(&recipe.instructions)
  .bind(user_id)
  .execute(&mut *tx)
  .await
  .map_err(add)?;

  for (position, ingredient) in recipe.ingredients.iter().enumerate() {
    sqlx::query(
      "insert into recipe_ingredients (id, recipe_id, name, needs, position) \
       values (?, ?, ?, ?, ?)",
    )
    .bind(&ingredient.id)
    .bind(&recipe.id)
    .bind(&ingredient.name)
    .bind(ingredient.na)
    .bind(position as i64)
    .execute(&mut *tx)
    .await
    .map_err(add)?;
  }
  tx.commit().await.map_err(add)?;
  Ok(())
}

/// Delete one of the user's recipes and its ingredients.
pub async fn delete_recipe(
  pool: &SqlitePool,
  user_id: &str,
  recipe_id: &str,
) -> Result<(), RepoError> {
  sqlx::query("delete from recipes where id = ? and user_id = ?")
    .bind(recipe_id)
    .bind(user_id)
    .execute(pool)
    .await
    .map_err(|source| RepoError::RecipeDelete { source })?;
  Ok(())
}

/// How many storage panes a user has.  The provisioning gate reads this to
/// decide whether a fresh account needs its default panes seeded.
pub async fn pane_count(
  pool: &SqlitePool,
  user_id: &str,
) -> Result<i64, RepoError> {
  sqlx::query_scalar("select count(*) from storage_locations where user_id = ?")
    .bind(user_id)
    .fetch_one(pool)
    .await
    .map_err(|source| RepoError::PaneProvision { source })
}

/// Seed a user's default storage panes, so a new account does not land in a
/// blank, unusable Kitchen.  The pane ids are derived from the user id so
/// they stay unique across accounts, which the shared primary key requires,
/// and `insert or ignore` keeps a concurrent first access harmless.
pub async fn provision_default_panes(
  pool: &SqlitePool,
  user_id: &str,
  panes: &[Card],
) -> Result<(), RepoError> {
  let fail = |source| RepoError::PaneProvision { source };
  let mut tx = pool.begin().await.map_err(fail)?;
  sqlx::query(
    "insert or ignore into users (id, email, display_name, created_at) \
     values (?, '', '', '')",
  )
  .bind(user_id)
  .execute(&mut *tx)
  .await
  .map_err(fail)?;

  for (position, pane) in panes.iter().enumerate() {
    sqlx::query(
      "insert or ignore into storage_locations \
       (id, user_id, name, meta, rail, line, note, zone, position) \
       values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
    )
    .bind(format!("{user_id}-{}", pane.id))
    .bind(user_id)
    .bind(&pane.name)
    .bind(&pane.meta)
    .bind(&pane.rail)
    .bind(&pane.line)
    .bind(&pane.note)
    .bind(&pane.zone)
    .bind(position as i64)
    .execute(&mut *tx)
    .await
    .map_err(fail)?;
  }
  tx.commit().await.map_err(fail)?;
  Ok(())
}
