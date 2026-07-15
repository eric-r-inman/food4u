pub mod config;
pub mod db;
pub mod frontend;
pub mod limits;
pub mod model;
pub mod provision;
pub mod repo;
pub mod repo_pg;
pub mod routes;
pub mod seed;
pub mod web_base;

/// The user a single-tenant local run reads and writes, and the template a
/// fresh multi-user database seeds and provisions new accounts from.
pub const LOCAL_USER: &str = "local";
