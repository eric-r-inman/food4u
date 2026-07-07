//! Application HTTP routes for reading and persisting the food model.
//!
//! These are plain JSON routes, deliberately undocumented in the OpenAPI
//! spec.  A read assembles the current user's model from the relational
//! store; a write is deserialized through the typed [`Model`], so axum
//! rejects a malformed document with a 4xx before it is decomposed back
//! into the tables.

use crate::model::Model;
use crate::repo::{self, RepoError};
use crate::web_base::AppState;
use aide::axum::ApiRouter;
use axum::extract::State;
use axum::http::StatusCode;
use axum::response::{IntoResponse, Response};
use axum::routing::get;
use axum::Json;
use tracing::error;

pub fn router() -> ApiRouter<AppState> {
  ApiRouter::new().route("/api/model", get(get_model).put(put_model))
}

async fn get_model(
  State(state): State<AppState>,
) -> Result<Json<Model>, RepoError> {
  repo::load(&state.pool, &state.user_id).await.map(Json)
}

async fn put_model(
  State(state): State<AppState>,
  Json(model): Json<Model>,
) -> Result<Json<Model>, RepoError> {
  repo::save(&state.pool, &state.user_id, &model).await?;
  Ok(Json(model))
}

impl IntoResponse for RepoError {
  fn into_response(self) -> Response {
    // Every repository failure is a server-side database fault; the client
    // cannot do anything but retry.  Log the detail and return an opaque
    // 500 so nothing about the storage layer is leaked to the browser.
    error!(error = %self, "food model store operation failed");
    (StatusCode::INTERNAL_SERVER_ERROR, "failed to access the food model")
      .into_response()
  }
}
