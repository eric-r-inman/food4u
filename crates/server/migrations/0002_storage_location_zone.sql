-- Storage locations gain a zone so the Shopping List column can hold its
-- own user-created categories.
--
-- A category the user drags to-buy items into is, structurally, just
-- another storage location; the zone is what tells the Kitchen column and
-- the Shopping List column which locations are theirs.  Existing rows are
-- kitchen panes (the reserved Shopping List card is still found by its
-- name), so the column defaults to 'kitchen' and no backfill is needed.

alter table storage_locations
    add column zone text not null default 'kitchen';
