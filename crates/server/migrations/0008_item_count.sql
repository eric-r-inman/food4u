-- A per-item count: how many of a food a badge stands for.  Applies to
-- stored kitchen and shopping-list items and to recipe ingredients; the
-- Longevity Foods pyramid is a catalog, not a tally, so its foods carry no
-- count.  Defaults to 1 so existing rows read as a single unit.

alter table storage_items add column count integer not null default 1;
alter table recipe_ingredients add column count integer not null default 1;
