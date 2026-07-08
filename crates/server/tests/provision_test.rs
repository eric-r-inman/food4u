//! A new account is seeded with the default storage panes on first access,
//! and the seeding is idempotent.
#![allow(clippy::expect_used, clippy::unwrap_used, clippy::panic)]

use food4u_server::db::Db;

async fn empty_db() -> Db {
  let file = tempfile::NamedTempFile::new().unwrap();
  let url = format!("sqlite://{}", file.path().display());
  std::mem::forget(file);
  Db::connect(&url).await.unwrap()
}

#[tokio::test]
async fn a_new_user_is_provisioned_with_empty_default_panes() {
  let db = empty_db().await;

  db.ensure_provisioned("alice@example.com").await.unwrap();
  let model = db.load("alice@example.com").await.unwrap();

  let names: Vec<&str> =
    model.staples.iter().map(|c| c.name.as_str()).collect();
  assert_eq!(
    names,
    [
      "Shopping List",
      "Pantry",
      "Refrigerator",
      "Freezer",
      "Counter",
      "Spice Cupboard",
      "Apothecary",
    ],
    "a fresh account gets the default panes"
  );
  assert!(
    model.staples.iter().all(|c| c.items.is_empty()),
    "the seeded panes carry no items"
  );
}

#[tokio::test]
async fn provisioning_is_idempotent_and_leaves_an_established_user_alone() {
  let db = empty_db().await;

  db.ensure_provisioned("bob@example.com").await.unwrap();
  db.ensure_provisioned("bob@example.com").await.unwrap();

  let panes = db.load("bob@example.com").await.unwrap().staples;
  assert_eq!(panes.len(), 7, "the second call adds nothing");
}

#[tokio::test]
async fn provisioning_keeps_two_users_separate() {
  let db = empty_db().await;

  db.ensure_provisioned("alice@example.com").await.unwrap();
  db.ensure_provisioned("bob@example.com").await.unwrap();

  // The shared primary key on storage_locations forces per-user-unique pane
  // ids; both users nonetheless end up with the full default set.
  assert_eq!(db.load("alice@example.com").await.unwrap().staples.len(), 7);
  assert_eq!(db.load("bob@example.com").await.unwrap().staples.len(), 7);
}
