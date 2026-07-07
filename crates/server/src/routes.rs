//! Application HTTP routes for reading and persisting the food model.
//!
//! These are plain JSON routes, deliberately undocumented in the
//! OpenAPI spec.  Reads serve the stored document as-is; writes are
//! deserialized through the typed [`Model`], so axum rejects a malformed
//! document with a 4xx rather than letting the server persist something
//! it cannot later load.

use crate::model::Model;
use crate::store::StoreError;
use crate::web_base::AppState;
use aide::axum::ApiRouter;
use axum::extract::State;
use axum::http::StatusCode;
use axum::response::{IntoResponse, Response};
use axum::routing::get;
use axum::Json;
use serde_json::Value;
use tracing::error;

pub fn router() -> ApiRouter<AppState> {
  ApiRouter::new().route("/api/model", get(get_model).put(put_model))
}

async fn get_model(
  State(state): State<AppState>,
) -> Result<Json<Value>, StoreError> {
  state.store.load().await.map(Json)
}

async fn put_model(
  State(state): State<AppState>,
  Json(model): Json<Model>,
) -> Result<Json<Model>, StoreError> {
  state.store.save(&model).await?;
  Ok(Json(model))
}

impl IntoResponse for StoreError {
  fn into_response(self) -> Response {
    // Every store failure is a server-side I/O or serialization fault;
    // the client cannot do anything but retry.  Log the detail and
    // return an opaque 500 so paths are not leaked to the browser.
    error!(error = %self, "food model store operation failed");
    (StatusCode::INTERNAL_SERVER_ERROR, "failed to access the food model")
      .into_response()
  }
}
