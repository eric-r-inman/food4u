-- The Meal Planner: recipes planned into a week, one row per planned slot.
-- Each entry references its recipe rather than copying it, so the planner
-- follows recipe edits, and a recipe's deletion cascades its plans away.
-- `day` counts from Sunday as zero; `position` orders entries within one
-- (day, meal) slot.  A recipe may appear in any number of entries.

create table meal_plan_entries (
    id        text primary key,
    user_id   text not null references users (id) on delete cascade,
    day       integer not null,
    meal      text not null,
    recipe_id text not null references recipes (id) on delete cascade,
    position  integer not null
);

create index idx_meal_plan_entries_user on meal_plan_entries (user_id);
