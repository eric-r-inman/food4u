//! Legacy JSON model loader.
//!
//! The model used to be persisted as this single JSON document; the
//! relational store has since taken over as the store of record.  What
//! remains is the read path, used once at startup to import an existing
//! file — or the embedded seed the server used to serve — into the
//! database.

use serde_json::Value;
use std::path::PathBuf;
use thiserror::Error;
use tokio::fs;

/// The default model shipped with the binary, generated from the
/// original Claude Design mock-up.  Imported into the database on first
/// run when no legacy file exists.
const DEFAULT_MODEL_JSON: &str = include_str!("seed/default_model.json");

#[derive(Debug, Error)]
pub enum StoreError {
  #[error("could not read food model file at {path}: {source}")]
  ModelFileRead {
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
}
