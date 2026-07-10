//! The PostgreSQL implementation of the repository's read and write paths.
//!
//! UNVERIFIED.  This mirrors the SQLite repository against the same schema
//! in PostgreSQL dialect — numbered placeholders (`$1`), `boolean`
//! literals, and `on conflict do nothing` — but it has never been run
//! against a live PostgreSQL server.  It exists so the hosted backend is
//! ready to exercise the moment a database is reachable; until then treat
//! it as scaffolding, not tested code.  See tasks.org.
//!
//! Only `load` and `save` are implemented here, the paths the routes use.
//! The scoped mutations remain SQLite-only until they are wired to HTTP.

use crate::model::Model;
use crate::repo::{
  self, CardRow, FoodRow, GroupRow, IngredientRow, RecipeRow, RepoError,
  StorageItemRow, TierRow,
};
use sqlx::PgPool;

/// Assemble the whole model for one user from PostgreSQL.
pub async fn load(pool: &PgPool, user_id: &str) -> Result<Model, RepoError> {
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
     coalesce(s.in_stock, false) as na, coalesce(s.recipe_id, '') as recipe_id \
     from foods f \
     left join user_food_state s on s.food_id = f.id and s.user_id = $1 \
     order by f.group_id, f.position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let locations = sqlx::query_as::<_, CardRow>(
    "select id, name, meta, rail, line, note, zone from storage_locations \
     where user_id = $1 order by position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let items = sqlx::query_as::<_, StorageItemRow>(
    "select i.location_id, i.id, i.name, i.needs as na from storage_items i \
     join storage_locations l on l.id = i.location_id \
     where l.user_id = $1 order by i.location_id, i.position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let recipes = sqlx::query_as::<_, RecipeRow>(
    "select id, name, category, instructions, bookmarked from recipes \
     where user_id = $1 order by position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  let ingredients = sqlx::query_as::<_, IngredientRow>(
    "select g.recipe_id, g.id, g.name, g.needs as na from recipe_ingredients g \
     join recipes r on r.id = g.recipe_id \
     where r.user_id = $1 order by g.recipe_id, g.position",
  )
  .bind(user_id)
  .fetch_all(pool)
  .await
  .map_err(read)?;

  Ok(repo::assemble(
    tiers,
    groups,
    foods,
    locations,
    items,
    recipes,
    ingredients,
  ))
}

/// Decompose and persist the whole model for one user, replacing whatever
/// was there, in a single transaction.
pub async fn save(
  pool: &PgPool,
  user_id: &str,
  model: &Model,
) -> Result<(), RepoError> {
  let write = |source| RepoError::ModelWrite { source };
  let mut tx = pool.begin().await.map_err(write)?;

  sqlx::query(
    "insert into users (id, email, display_name, created_at) \
     values ($1, '', '', '') on conflict do nothing",
  )
  .bind(user_id)
  .execute(&mut *tx)
  .await
  .map_err(write)?;

  sqlx::query("delete from tiers")
    .execute(&mut *tx)
    .await
    .map_err(write)?;
  sqlx::query("delete from storage_locations where user_id = $1")
    .bind(user_id)
    .execute(&mut *tx)
    .await
    .map_err(write)?;
  sqlx::query("delete from recipes where user_id = $1")
    .bind(user_id)
    .execute(&mut *tx)
    .await
    .map_err(write)?;

  for (tier_pos, tier) in model.tiers.iter().enumerate() {
    sqlx::query(
      "insert into tiers (id, no, name, freq, width, rail, tint, line, position) \
       values ($1, $2, $3, $4, $5, $6, $7, $8, $9)",
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
        "insert into food_groups (id, tier_id, label, position) \
         values ($1, $2, $3, $4)",
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
           values ($1, $2, $3, $4, $5, $6)",
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

        if food.na || !food.recipe_id.is_empty() {
          let recipe_id: Option<&str> = if food.recipe_id.is_empty() {
            None
          } else {
            Some(&food.recipe_id)
          };
          sqlx::query(
            "insert into user_food_state (user_id, food_id, in_stock, recipe_id) \
             values ($1, $2, $3, $4)",
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
       values ($1, $2, $3, $4, $5, $6, $7, $8, $9)",
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
         values ($1, $2, $3, $4, $5)",
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
      "insert into recipes (id, user_id, name, category, instructions, bookmarked, position) \
       values ($1, $2, $3, $4, $5, $6, $7)",
    )
    .bind(&recipe.id)
    .bind(user_id)
    .bind(&recipe.name)
    .bind(&recipe.category)
    .bind(&recipe.instructions)
    .bind(recipe.bookmarked)
    .bind(recipe_pos as i64)
    .execute(&mut *tx)
    .await
    .map_err(write)?;

    for (ing_pos, ingredient) in recipe.ingredients.iter().enumerate() {
      sqlx::query(
        "insert into recipe_ingredients (id, recipe_id, name, needs, position) \
         values ($1, $2, $3, $4, $5)",
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

/// How many storage panes a user has — the PostgreSQL counterpart of
/// [`repo::pane_count`].  UNVERIFIED, like the rest of this module.
pub async fn pane_count(
  pool: &PgPool,
  user_id: &str,
) -> Result<i64, RepoError> {
  sqlx::query_scalar(
    "select count(*) from storage_locations where user_id = $1",
  )
  .bind(user_id)
  .fetch_one(pool)
  .await
  .map_err(|source| RepoError::PaneProvision { source })
}

/// Seed a user's default storage panes — the PostgreSQL counterpart of
/// [`repo::provision_default_panes`], with the same id-derivation and
/// idempotency.  UNVERIFIED, like the rest of this module.
pub async fn provision_default_panes(
  pool: &PgPool,
  user_id: &str,
  panes: &[crate::model::Card],
) -> Result<(), RepoError> {
  let fail = |source| RepoError::PaneProvision { source };
  let mut tx = pool.begin().await.map_err(fail)?;
  sqlx::query(
    "insert into users (id, email, display_name, created_at) \
     values ($1, '', '', '') on conflict do nothing",
  )
  .bind(user_id)
  .execute(&mut *tx)
  .await
  .map_err(fail)?;

  for (position, pane) in panes.iter().enumerate() {
    sqlx::query(
      "insert into storage_locations \
       (id, user_id, name, meta, rail, line, note, zone, position) \
       values ($1, $2, $3, $4, $5, $6, $7, $8, $9) on conflict do nothing",
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
