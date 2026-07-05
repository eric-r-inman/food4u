//! Persistence for the food model.
//!
//! The model is a single JSON document — the longevity pyramid and the
//! kitchen-staple cards — owned and shaped by the Elm frontend.  The
//! server treats it as an opaque blob: it serves it, persists it, and
//! seeds a default the first time around.  Keeping the schema in one
//! place (Elm) avoids maintaining a parallel set of Rust types that
//! would have to move in lockstep with the frontend for a single-user
//! local app.

use serde_json::Value;
use std::path::PathBuf;
use thiserror::Error;
use tokio::fs;

/// The default model shipped with the binary, generated from the
/// original Claude Design mock-up.  Served whenever no user data file
/// exists yet and restored on reset.
const DEFAULT_MODEL_JSON: &str = include_str!("seed/default_model.json");

#[derive(Debug, Error)]
pub enum StoreError {
  #[error("could not read food model file at {path}: {source}")]
  ModelFileRead {
    path: PathBuf,
    source: std::io::Error,
  },
  #[error("could not write food model file at {path}: {source}")]
  ModelFileWrite {
    path: PathBuf,
    source: std::io::Error,
  },
  #[error("could not create food model directory at {path}: {source}")]
  ModelDirCreate {
    path: PathBuf,
    source: std::io::Error,
  },
  #[error("stored food model is not valid JSON at {path}: {source}")]
  ModelFileParse {
    path: PathBuf,
    source: serde_json::Error,
  },
  #[error("embedded default food model is not valid JSON: {source}")]
  DefaultModelParse { source: serde_json::Error },
  #[error("could not serialize food model: {source}")]
  ModelSerialize { source: serde_json::Error },
}

/// File-backed store for the single food model document.
#[derive(Clone)]
pub struct Store {
  data_file: PathBuf,
}

impl Store {
  pub fn new(data_file: PathBuf) -> Self {
    Self { data_file }
  }

  /// The embedded default model, parsed fresh each call.
  pub fn default_model() -> Result<Value, StoreError> {
    serde_json::from_str(DEFAULT_MODEL_JSON)
      .map_err(|source| StoreError::DefaultModelParse { source })
  }

  /// Load the current model, falling back to the default when no user
  /// data file has been written yet.
  pub async fn load(&self) -> Result<Value, StoreError> {
    match fs::read(&self.data_file).await {
      Ok(bytes) => serde_json::from_slice(&bytes).map_err(|source| {
        StoreError::ModelFileParse {
          path: self.data_file.clone(),
          source,
        }
      }),
      Err(source) if source.kind() == std::io::ErrorKind::NotFound => {
        Self::default_model()
      }
      Err(source) => Err(StoreError::ModelFileRead {
        path: self.data_file.clone(),
        source,
      }),
    }
  }

  /// Persist the given model, creating the parent directory as needed.
  pub async fn save(&self, model: &Value) -> Result<(), StoreError> {
    if let Some(parent) = self.data_file.parent() {
      if !parent.as_os_str().is_empty() {
        fs::create_dir_all(parent).await.map_err(|source| {
          StoreError::ModelDirCreate {
            path: parent.to_path_buf(),
            source,
          }
        })?;
      }
    }
    let bytes = serde_json::to_vec_pretty(model)
      .map_err(|source| StoreError::ModelSerialize { source })?;
    fs::write(&self.data_file, bytes).await.map_err(|source| {
      StoreError::ModelFileWrite {
        path: self.data_file.clone(),
        source,
      }
    })
  }
}
