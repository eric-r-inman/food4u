//! PostgreSQL round-trip, run against a real server.
//!
//! Gated on `POSTGRES_TEST_URL`: set it to a throwaway PostgreSQL database
//! and the test saves the seed model, reads it back, and asserts they
//! match — exercising the PostgreSQL repository end to end.  Without the
//! variable the test skips, so the default suite needs no database.  The
//! save clears the shared catalog, so point it at a dedicated database.
#![allow(clippy::expect_used, clippy::unwrap_used, clippy::panic)]

use food4u_server::db::Db;

const SEED_SQL: &str = include_str!("../src/seed/seed.sql");

#[tokio::test]
async fn seed_round_trips_through_postgres() {
  let Ok(url) = std::env::var("POSTGRES_TEST_URL") else {
    eprintln!("POSTGRES_TEST_URL not set; skipping the PostgreSQL round-trip");
    return;
  };

  let db = Db::connect(&url).await.unwrap();

  // Start from an empty catalog so a re-run against the same database is
  // clean; the deletes cascade to every seeded child table.
  db.execute_script("delete from tiers; delete from users;")
    .await
    .unwrap();

  // The same portable seed the server runs on first start loads on Postgres.
  db.execute_script(SEED_SQL).await.unwrap();
  let model = db.load("local").await.unwrap();

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

  // The seeded model round-trips through the PostgreSQL repository unchanged.
  db.save("local", &model).await.unwrap();
  let again = db.load("local").await.unwrap();
  assert_eq!(
    model, again,
    "the model reloaded from PostgreSQL should equal the seeded one"
  );
}
