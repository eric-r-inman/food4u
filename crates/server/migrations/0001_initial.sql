-- Initial relational schema for the food model.
--
-- This separates the three concerns the JSON document conflates: the
-- shared catalog (the pyramid and its seeded foods), the per-user overlay
-- (stock status, food-to-recipe links, kitchen storage, shopping list),
-- and per-user recipes. Ids are text (application-generated) so the same
-- schema serves the local SQLite backend and, later, PostgreSQL. Booleans
-- are stored as integers, the SQLite convention. Foreign keys cascade on
-- delete so removing an account or a parent row takes its children with
-- it; SQLite enforces them only when `PRAGMA foreign_keys` is on, which
-- the connection layer sets per connection.

-- Shared catalog: the longevity pyramid, read-mostly and seeded once.

create table tiers (
    id       text primary key,
    no       text not null,
    name     text not null,
    freq     text not null,
    width    text not null,
    rail     text not null,
    tint     text not null,
    line     text not null,
    position integer not null
);

create table food_groups (
    id       text primary key,
    tier_id  text not null references tiers (id) on delete cascade,
    label    text not null,
    position integer not null
);

create table foods (
    id       text primary key,
    group_id text not null references food_groups (id) on delete cascade,
    name     text not null,
    prep     text not null,
    hero     integer not null default 0,
    position integer not null
);

-- Accounts. Keyed on the OIDC subject where available; email is a
-- display and contact attribute, not an identity key.

create table users (
    id           text primary key,
    issuer       text,
    subject      text,
    email        text not null,
    display_name text not null,
    created_at   text not null,
    unique (issuer, subject)
);

-- Per-user overlay of catalog foods: whether the user has it in stock and
-- which of their recipes, if any, it is linked to.

create table user_food_state (
    user_id   text not null references users (id) on delete cascade,
    food_id   text not null references foods (id) on delete cascade,
    in_stock  integer not null default 0,
    recipe_id text,
    primary key (user_id, food_id)
);

-- Foods a user added that are not in the shared catalog.

create table user_custom_foods (
    id       text primary key,
    user_id  text not null references users (id) on delete cascade,
    group_id text references food_groups (id),
    name     text not null,
    prep     text not null,
    in_stock integer not null default 0
);

-- Kitchen storage panes and the Shopping List (a storage pane whose items
-- are a to-buy list rather than on-hand stock).

create table storage_locations (
    id       text primary key,
    user_id  text not null references users (id) on delete cascade,
    name     text not null,
    meta     text not null default '',
    rail     text not null default '',
    line     text not null default '',
    note     text not null default '',
    position integer not null
);

create table storage_items (
    id          text primary key,
    location_id text not null references storage_locations (id) on delete cascade,
    name        text not null,
    needs       integer not null default 0,
    position    integer not null
);

-- Per-user recipes. Instructions are kept as a single block, matching the
-- current model; ingredients are ordered rows.

create table recipes (
    id           text primary key,
    user_id      text not null references users (id) on delete cascade,
    name         text not null,
    category     text not null,
    instructions text not null default '',
    position     integer not null
);

create table recipe_ingredients (
    id        text primary key,
    recipe_id text not null references recipes (id) on delete cascade,
    name      text not null,
    needs     integer not null default 0,
    position  integer not null
);

create index idx_food_groups_tier on food_groups (tier_id);
create index idx_foods_group on foods (group_id);
create index idx_user_food_state_user on user_food_state (user_id);
create index idx_user_custom_foods_user on user_custom_foods (user_id);
create index idx_storage_locations_user on storage_locations (user_id);
create index idx_storage_items_location on storage_items (location_id);
create index idx_recipes_user on recipes (user_id);
create index idx_recipe_ingredients_recipe on recipe_ingredients (recipe_id);
