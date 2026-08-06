-- The Shopping List's "Baking & Spices" department becomes "Cooking &
-- Baking", and "Condiments & Sauces" becomes "Condiments & Dressings".
-- Auto-sort matches a food's department to a category pane by name, so
-- the rename must reach every place a department name is stored: the
-- catalog defaults on foods, the per-user overrides in
-- user_sort_targets, and the users' own Shopping List panes, which were
-- minted from the old default names.  A fresh database gets the new
-- names from the seed and the client's defaults directly.

update foods
set department = 'Cooking & Baking'
where department = 'Baking & Spices';

update foods
set department = 'Condiments & Dressings'
where department = 'Condiments & Sauces';

update user_sort_targets
set department = 'Cooking & Baking'
where department = 'Baking & Spices';

update user_sort_targets
set department = 'Condiments & Dressings'
where department = 'Condiments & Sauces';

update storage_locations
set name = 'Cooking & Baking'
where zone = 'shopping' and name = 'Baking & Spices';

update storage_locations
set name = 'Condiments & Dressings'
where zone = 'shopping' and name = 'Condiments & Sauces';

-- With the rename in place, re-file the foods the old grouping shelved
-- oddly.  Cooking media — oils, vinegars, ghee, and cooking wine — are
-- cooking essentials and belong with the cooking aisle rather than with
-- ready-to-use condiments; a store shelves oil and vinegar together.
-- Keyed by name so the corrections work on any catalog derived from the
-- bundled one.

update foods set department = 'Cooking & Baking' where name = 'Olive oil';
update foods set department = 'Cooking & Baking' where name = 'Extra-virgin olive oil';
update foods set department = 'Cooking & Baking' where name = 'Avocado oil';
update foods set department = 'Cooking & Baking' where name = 'Almond oil';
update foods set department = 'Cooking & Baking' where name = 'Canola oil';
update foods set department = 'Cooking & Baking' where name = 'Coconut oil';
update foods set department = 'Cooking & Baking' where name = 'Flaxseed oil';
update foods set department = 'Cooking & Baking' where name = 'Mustard oil';
update foods set department = 'Cooking & Baking' where name = 'Perilla oil';
update foods set department = 'Cooking & Baking' where name = 'Rapeseed oil';
update foods set department = 'Cooking & Baking' where name = 'Sesame oil';
update foods set department = 'Cooking & Baking' where name = 'Walnut oil';
update foods set department = 'Cooking & Baking' where name = 'Ghee';
update foods set department = 'Cooking & Baking' where name = 'Apple cider vinegar';
update foods set department = 'Cooking & Baking' where name = 'Balsamic vinegar';
update foods set department = 'Cooking & Baking' where name = 'Black vinegar';
update foods set department = 'Cooking & Baking' where name = 'Red wine vinegar';
update foods set department = 'Cooking & Baking' where name = 'Rice vinegar';
update foods set department = 'Cooking & Baking' where name = 'Sherry vinegar';
update foods set department = 'Cooking & Baking' where name = 'White wine vinegar';
update foods set department = 'Cooking & Baking' where name = 'Red wine · optional';

-- Fresh produce that had been swept into the condiment and spice
-- departments by its pyramid category sorts with the produce it is.

update foods set department = 'Produce' where name = 'Avocado';
update foods set department = 'Produce' where name = 'Lemon';

-- Canned goods shelved with the condiments move to the canned aisle.

update foods set department = 'Canned & Dry Goods' where name = 'Tomato paste';
update foods set department = 'Canned & Dry Goods' where name = 'Chipotle in adobo';
