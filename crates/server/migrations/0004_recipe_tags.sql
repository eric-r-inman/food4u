-- Recipes gain free-form tags: user-entered labels the Recipes column
-- filters on.  Like a recipe's ingredients, the tags are an ordered child
-- list rather than a column, so they live in their own table keyed by the
-- owning recipe.  Existing recipes have no tags, so nothing is backfilled.

create table recipe_tags (
    recipe_id text not null references recipes (id) on delete cascade,
    tag       text not null,
    position  integer not null,
    primary key (recipe_id, position)
);

create index idx_recipe_tags_recipe on recipe_tags (recipe_id);
