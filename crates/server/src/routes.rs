//! Application HTTP routes for reading and persisting the food model.
//!
//! These are plain JSON routes, deliberately undocumented in the
//! OpenAPI spec — the model is an opaque document owned by the Elm
//! frontend, so there is no stable Rust schema to advertise.

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
  Json(model): Json<Value>,
) -> Result<Json<Value>, StoreError> {
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
