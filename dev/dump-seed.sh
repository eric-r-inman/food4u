#!/usr/bin/env bash
# Dump the bundled default foods and recipes from a SQLite database as
# portable INSERT statements.  Used by `just seed-save` and to regenerate
# the checked-in seed.  The output loads on both SQLite and Postgres:
# strings go through SQLite's quote() (standard '' escaping), booleans as
# true/false literals, one INSERT per row in foreign-key dependency order so
# a fresh, empty database accepts it top to bottom.
set -euo pipefail
db="${1:?usage: dump-seed.sh <sqlite-db>}"

emit() { sqlite3 -batch -noheader "$db" "$1"; }

# Refuse to dump an empty or missing database, so a stray run cannot blank
# the checked-in seed.  A seeded database always has the catalog tiers.
tier_count="$(sqlite3 -batch -noheader "$db" 'select count(*) from tiers' 2>/dev/null || echo 0)"
if [ "${tier_count:-0}" -lt 1 ]; then
  echo "dump-seed: '$db' has no seeded catalog; refusing to dump" >&2
  exit 1
fi

cat <<'HEADER'
-- The bundled default foods and recipes, as portable INSERT statements the
-- server runs into an empty database on first start.  Generated from a
-- seed-editing database by dev/dump-seed.sh; edit the defaults visually with
-- `just seed-edit` and `just seed-save`, not by hand.
HEADER

emit "select 'insert into users (id, email, display_name, created_at, planner_days) values ('||quote(id)||', '||quote(email)||', '||quote(display_name)||', '||quote(created_at)||', '||planner_days||');' from users order by id;"
emit "select 'insert into tiers (id, no, name, freq, width, rail, tint, line, position) values ('||quote(id)||', '||quote(no)||', '||quote(name)||', '||quote(freq)||', '||quote(width)||', '||quote(rail)||', '||quote(tint)||', '||quote(line)||', '||position||');' from tiers order by position;"
emit "select 'insert into food_groups (id, tier_id, label, position) values ('||quote(id)||', '||quote(tier_id)||', '||quote(label)||', '||position||');' from food_groups order by tier_id, position;"
emit "select 'insert into foods (id, group_id, name, prep, hero, position) values ('||quote(id)||', '||quote(group_id)||', '||quote(name)||', '||quote(prep)||', '||(case when hero then 'true' else 'false' end)||', '||position||');' from foods order by group_id, position;"
emit "select 'insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('||quote(user_id)||', '||quote(food_id)||', '||(case when in_stock then 'true' else 'false' end)||', '||quote(recipe_id)||');' from user_food_state order by user_id, food_id;"
# The Staples Tracker and the Shopping List's default categories are
# minted client-side for every account, so the seed-editing session always
# contains them; baking them into the seed would provision them twice and
# freeze what the frontend intends to own.  The dump leaves them (and any
# items inside them) out.
minted="(name = 'Staples Tracker' or zone = 'shopping')"
emit "select 'insert into storage_locations (id, user_id, name, meta, rail, line, note, zone, position) values ('||quote(id)||', '||quote(user_id)||', '||quote(name)||', '||quote(meta)||', '||quote(rail)||', '||quote(line)||', '||quote(note)||', '||quote(zone)||', '||position||');' from storage_locations where not $minted order by user_id, position;"
emit "select 'insert into storage_items (id, location_id, name, needs, position) values ('||quote(id)||', '||quote(location_id)||', '||quote(name)||', '||(case when needs then 'true' else 'false' end)||', '||position||');' from storage_items where location_id not in (select id from storage_locations where $minted) order by location_id, position;"
emit "select 'insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('||quote(id)||', '||quote(user_id)||', '||quote(name)||', '||quote(category)||', '||quote(instructions)||', '||(case when bookmarked then 'true' else 'false' end)||', '||position||');' from recipes order by user_id, position;"
emit "select 'insert into recipe_ingredients (id, recipe_id, name, needs, position) values ('||quote(id)||', '||quote(recipe_id)||', '||quote(name)||', '||(case when needs then 'true' else 'false' end)||', '||position||');' from recipe_ingredients order by recipe_id, position;"
emit "select 'insert into recipe_tags (recipe_id, tag, position) values ('||quote(recipe_id)||', '||quote(tag)||', '||position||');' from recipe_tags order by recipe_id, position;"
emit "select 'insert into meal_plan_entries (id, user_id, day, meal, recipe_id, position) values ('||quote(id)||', '||quote(user_id)||', '||day||', '||quote(meal)||', '||quote(recipe_id)||', '||position||');' from meal_plan_entries order by user_id, day, meal, position;"
