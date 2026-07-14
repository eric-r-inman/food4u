-- The Meal Planner grows and shrinks a day at a time, so the number of
-- days becomes per-user state.  Existing users keep the planner's original
-- week, which the column defaults to.

alter table users
    add column planner_days integer not null default 7;
