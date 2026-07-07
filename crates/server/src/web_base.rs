use crate::db::Db;
use rust_template_foundation::{
  impl_server_state, server::runner::BaseServerState,
};

#[derive(Clone)]
pub struct AppState {
  pub base: BaseServerState,
  pub db: Db,

  // The account whose model the routes read and write.  Unauthenticated
  // local runs serve a single fixed user; the hosted path will resolve
  // this from the session per request.
  pub user_id: String,
}

impl_server_state!(AppState, base);
