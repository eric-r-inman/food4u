//! The initial schema migration applies cleanly to a fresh database.
#![allow(clippy::expect_used, clippy::unwrap_used, clippy::panic)]

use food4u_server::db::connect_and_migrate;

#[tokio::test]
async fn migrations_apply_and_catalog_tables_exist() {
  let file = tempfile::NamedTempFile::new().unwrap();
  let url = format!("sqlite://{}", file.path().display());
  let pool = connect_and_migrate(&url).await.unwrap();

  // The catalog tables exist and start empty.
  let foods: i64 = sqlx::query_scalar("select count(*) from foods")
    .fetch_one(&pool)
    .await
    .unwrap();
  assert_eq!(foods, 0);

  // The per-user tables exist too.
  let recipes: i64 = sqlx::query_scalar("select count(*) from recipes")
    .fetch_one(&pool)
    .await
    .unwrap();
  assert_eq!(recipes, 0);

  // Foreign keys are enforced on pooled connections.
  let foreign_keys: i64 = sqlx::query_scalar("pragma foreign_keys")
    .fetch_one(&pool)
    .await
    .unwrap();
  assert_eq!(foreign_keys, 1);
}
