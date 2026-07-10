-- Recipes gain a bookmark flag, a per-recipe marker the user sets to
-- remember a recipe — for instance, one whose ingredients they have just
-- sent to the Shopping List.  Existing recipes are unbookmarked, so the
-- column defaults to false and no backfill is needed.

alter table recipes
    add column bookmarked boolean not null default false;
