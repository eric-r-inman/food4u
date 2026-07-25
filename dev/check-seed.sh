#!/usr/bin/env bash
# Audit the seed's load-bearing names: every recipe ingredient and every
# Auto staple must match a catalog food exactly (a mismatch silently costs
# the chip its tier tint, stock tracking, and shopping-list identity), and
# no staple may sit in the leafy-greens category (staples are pantry
# stock; leafy greens are weekly fresh shopping).  Runs against the given
# seed-editing database, or, with no argument, against a scratch database
# built from the committed migrations and seed.  Exits non-zero when any
# name is out of line, listing each one.  The same contract is enforced at
# test time by the server's seed-integrity tests; this script exists to
# say so at editing time, before a dump is baked in.
set -euo pipefail
cd "$(dirname "$0")/.."

db="${1:-}"
scratch=""
if [ -z "$db" ]; then
  scratch="$(mktemp -d)"
  db="$scratch/seed-check.db"
  for migration in crates/server/migrations/*.sql; do
    sqlite3 "$db" < "$migration"
  done
  sqlite3 "$db" < crates/server/src/seed/seed.sql
fi
cleanup() { [ -n "$scratch" ] && rm -rf "$scratch"; }
trap cleanup EXIT

work="$(mktemp -d)"
trap 'cleanup; rm -rf "$work"' EXIT

sqlite3 -batch -noheader "$db" 'select lower(name) from foods;' \
  | sort -u > "$work/foods"

# The staple lists in Staples.elm: the quoted strings on the line after
# each `staples =`.
grep -A1 'staples =' frontend/src/Staples.elm \
  | grep -oE '"[^"]+"' | tr -d '"' | sort -u > "$work/staples"

sqlite3 -batch -noheader "$db" \
  "select lower(f.name) from foods f
   join food_groups g on g.id = f.group_id
   where g.label = 'Leafy greens';" | sort -u > "$work/leafy"

fail=0

sqlite3 -batch -noheader "$db" \
  "select '  ' || ri.name || '  (in ' || r.name || ')'
   from recipe_ingredients ri join recipes r on r.id = ri.recipe_id
   where not exists
     (select 1 from foods f where lower(f.name) = lower(ri.name))
   order by ri.name;" > "$work/orphan-chips"
if [ -s "$work/orphan-chips" ]; then
  echo "Recipe ingredients that no longer match any catalog food:"
  cat "$work/orphan-chips"
  fail=1
fi

awk 'NR==FNR { catalog[$0] = 1; next } !(tolower($0) in catalog)' \
  "$work/foods" "$work/staples" > "$work/orphan-staples"
if [ -s "$work/orphan-staples" ]; then
  echo "Auto staples (Staples.elm) that no longer match any catalog food:"
  sed 's/^/  /' "$work/orphan-staples"
  fail=1
fi

awk 'NR==FNR { leafy[$0] = 1; next } (tolower($0) in leafy)' \
  "$work/leafy" "$work/staples" > "$work/leafy-staples"
if [ -s "$work/leafy-staples" ]; then
  echo "Auto staples filed under leafy greens (staples are pantry stock):"
  sed 's/^/  /' "$work/leafy-staples"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "seed-check: every recipe ingredient and staple matches the catalog."
fi
exit "$fail"
