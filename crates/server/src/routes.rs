//! Application HTTP routes for reading and persisting the food model.
//!
//! These are plain JSON routes, deliberately undocumented in the OpenAPI
//! spec.  A read assembles the current user's model from the relational
//! store; a write is deserialized through the typed [`Model`] (so axum
//! rejects malformed input with a 4xx), size-checked against the per-user
//! limits, and then decomposed back into the tables.

use crate::limits::{self, QuotaExceeded};
use crate::model::Model;
use crate::repo::RepoError;
use crate::web_base::AppState;
use aide::axum::ApiRouter;
use axum::extract::{DefaultBodyLimit, State};
use axum::http::StatusCode;
use axum::response::{IntoResponse, Response};
use axum::routing::get;
use axum::Json;
use tracing::error;

/// The largest model document a write may carry.  Far above the shipped
/// catalog, which serializes to a few hundred kilobytes.
const MAX_BODY_BYTES: usize = 4 * 1024 * 1024;

pub fn router() -> ApiRouter<AppState> {
  ApiRouter::new()
    .route("/api/model", get(get_model).put(put_model))
    .layer(DefaultBodyLimit::max(MAX_BODY_BYTES))
}

async fn get_model(
  State(state): State<AppState>,
) -> Result<Json<Model>, ApiError> {
  Ok(Json(state.db.load(&state.user_id).await?))
}

async fn put_model(
  State(state): State<AppState>,
  Json(model): Json<Model>,
) -> Result<Json<Model>, ApiError> {
  limits::check(&model)?;
  state.db.save(&state.user_id, &model).await?;
  Ok(Json(model))
}

/// The failure modes a model route can return to the client.
enum ApiError {
  Store(RepoError),
  Quota(QuotaExceeded),
}

impl From<RepoError> for ApiError {
  fn from(source: RepoError) -> Self {
    ApiError::Store(source)
  }
}

impl From<QuotaExceeded> for ApiError {
  fn from(source: QuotaExceeded) -> Self {
    ApiError::Quota(source)
  }
}

impl IntoResponse for ApiError {
  fn into_response(self) -> Response {
    match self {
      // A store fault is a server-side database problem; log the detail and
      // return an opaque 500 so nothing about the storage layer leaks.
      ApiError::Store(source) => {
        error!(error = %source, "food model store operation failed");
        (StatusCode::INTERNAL_SERVER_ERROR, "failed to access the food model")
          .into_response()
      }
      // A quota breach is the client's fault and safe to describe.
      ApiError::Quota(source) => {
        (StatusCode::PAYLOAD_TOO_LARGE, source.to_string()).into_response()
      }
    }
  }
}
