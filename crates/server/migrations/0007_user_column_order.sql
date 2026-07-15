-- The app's columns become reorderable by drag, so each user's
-- left-to-right arrangement is state: one row per column, ordered by
-- position.  A user with no rows sees the frontend's canonical order.

create table user_column_order (
    user_id     text not null references users (id) on delete cascade,
    column_name text not null,
    position    integer not null,
    primary key (user_id, position)
);
