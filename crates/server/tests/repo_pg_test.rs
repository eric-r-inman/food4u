//! PostgreSQL round-trip, run against a real server.
//!
//! Gated on `POSTGRES_TEST_URL`: set it to a throwaway PostgreSQL database
//! and the test saves the seed model, reads it back, and asserts they
//! match — exercising the PostgreSQL repository end to end.  Without the
//! variable the test skips, so the default suite needs no database.  The
//! save clears the shared catalog, so point it at a dedicated database.

use food4u_server::db::Db;
use food4u_server::model::Model;

const SEED: &str = include_str!("../src/seed/default_model.json");

#[tokio::test]
async fn seed_round_trips_through_postgres() {
  let Ok(url) = std::env::var("POSTGRES_TEST_URL") else {
    eprintln!("POSTGRES_TEST_URL not set; skipping the PostgreSQL round-trip");
    return;
  };

  let db = Db::connect(&url).await.unwrap();
  let model: Model = serde_json::from_str(SEED).unwrap();

  db.save("test-user", &model).await.unwrap();
  let loaded = db.load("test-user").await.unwrap();

  assert_eq!(
    model, loaded,
    "the model loaded from PostgreSQL should equal the saved one"
  );
}
