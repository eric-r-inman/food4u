//! Application HTTP routes for reading and persisting the food model.
//!
//! These are plain JSON routes, deliberately undocumented in the OpenAPI
//! spec.  Each request resolves its user from the OIDC session (falling
//! back to the configured local user when unauthenticated).  A read
//! assembles that user's model from the relational store; a write is
//! deserialized through the typed [`Model`] (so axum rejects malformed
//! input with a 4xx), size-checked against the per-user limits, and then
//! decomposed back into the tables.

use crate::limits::{self, QuotaExceeded};
use crate::model::Model;
use crate::provision::ProvisionError;
use crate::repo::RepoError;
use crate::web_base::AppState;
use aide::axum::ApiRouter;
use axum::extract::{DefaultBodyLimit, State};
use axum::http::StatusCode;
use axum::response::{IntoResponse, Response};
use axum::routing::get;
use axum::Json;
use rust_template_foundation::auth::current_user;
use tower_sessions::Session;
use tracing::error;

/// The largest model document a write may carry.  Far above the shipped
/// catalog, which serializes to a few hundred kilobytes.
const MAX_BODY_BYTES: usize = 4 * 1024 * 1024;

pub fn router() -> ApiRouter<AppState> {
  ApiRouter::new()
    .route("/api/model", get(get_model).put(put_model))
    .layer(DefaultBodyLimit::max(MAX_BODY_BYTES))
}

/// The account whose model this request reads or writes: the signed-in
/// user's email when authenticated, otherwise the configured local user.
async fn request_user(session: &Session, fallback: &str) -> String {
  current_user(session)
    .await
    .map_or_else(|| fallback.to_string(), |user| user.email)
}

async fn get_model(
  State(state): State<AppState>,
  session: Session,
) -> Result<Json<Model>, ApiError> {
  let user = request_user(&session, &state.user_id).await;
  state.db.ensure_provisioned(&user).await?;
  Ok(Json(state.db.load(&user).await?))
}

async fn put_model(
  State(state): State<AppState>,
  session: Session,
  Json(model): Json<Model>,
) -> Result<Json<Model>, ApiError> {
  limits::check(&model)?;
  state
    .db
    .save(&request_user(&session, &state.user_id).await, &model)
    .await?;
  Ok(Json(model))
}

/// The failure modes a model route can return to the client.
enum ApiError {
  Store(RepoError),
  Provision(ProvisionError),
  Quota(QuotaExceeded),
}

impl From<RepoError> for ApiError {
  fn from(source: RepoError) -> Self {
    ApiError::Store(source)
  }
}

impl From<ProvisionError> for ApiError {
  fn from(source: ProvisionError) -> Self {
    ApiError::Provision(source)
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
      // Provisioning a new user's default panes failed server-side; log the
      // detail and return an opaque 500 like any other store fault.
      ApiError::Provision(source) => {
        error!(error = %source, "new-user provisioning failed");
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
