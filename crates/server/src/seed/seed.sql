-- The bundled default foods and recipes, as portable INSERT statements the
-- server runs into an empty database on first start.  Generated from a
-- seed-editing database by dev/dump-seed.sh; edit the defaults visually with
-- `just seed-edit` and `just seed-save`, not by hand.
insert into users (id, email, display_name, created_at, planner_days) values ('local', '', '', '', 7);
insert into tiers (id, no, name, freq, width, rail, tint, line, position) values ('d166', '01', 'Foundation', 'EVERY MEAL', '100%', 'oklch(0.5 0.07 128)', 'oklch(0.965 0.018 122)', 'oklch(0.88 0.035 122)', 0);
insert into tiers (id, no, name, freq, width, rail, tint, line, position) values ('d241', '02', 'Daily', 'MOST DAYS', '82%', 'oklch(0.57 0.08 78)', 'oklch(0.965 0.022 84)', 'oklch(0.88 0.04 84)', 1);
insert into tiers (id, no, name, freq, width, rail, tint, line, position) values ('d260', '03', 'Weekly', '2–3× PER WEEK', '64%', 'oklch(0.49 0.06 232)', 'oklch(0.965 0.015 232)', 'oklch(0.87 0.03 232)', 2);
insert into tiers (id, no, name, freq, width, rail, tint, line, position) values ('d270', '04', 'Occasionally', 'A FEW ×/MONTH', '46%', 'oklch(0.52 0.1 42)', 'oklch(0.965 0.022 50)', 'oklch(0.88 0.045 50)', 3);
insert into food_groups (id, tier_id, label, position) values ('d6', 'd166', 'Plant-based Oils & Fats', 0);
insert into food_groups (id, tier_id, label, position) values ('d29', 'd166', 'Leafy greens', 1);
insert into food_groups (id, tier_id, label, position) values ('d94', 'd166', 'Vegetables', 2);
insert into food_groups (id, tier_id, label, position) values ('d109', 'd166', 'Whole grains', 3);
insert into food_groups (id, tier_id, label, position) values ('d138', 'd166', 'Fruit', 4);
insert into food_groups (id, tier_id, label, position) values ('d159', 'd166', 'Herbs & spices', 5);
insert into food_groups (id, tier_id, label, position) values ('d165', 'd166', 'Tea & botanicals', 6);
insert into food_groups (id, tier_id, label, position) values ('d183', 'd241', 'Condiments', 0);
insert into food_groups (id, tier_id, label, position) values ('d203', 'd241', 'Legumes & pulses', 1);
insert into food_groups (id, tier_id, label, position) values ('d222', 'd241', 'Nuts & seeds', 2);
insert into food_groups (id, tier_id, label, position) values ('d231', 'd241', 'Soy & fermented', 3);
insert into food_groups (id, tier_id, label, position) values ('d238', 'd241', 'Cultured dairy', 4);
insert into food_groups (id, tier_id, label, position) values ('d240', 'd241', 'Supplements', 5);
insert into food_groups (id, tier_id, label, position) values ('d255', 'd260', 'Oily & white fish', 0);
insert into food_groups (id, tier_id, label, position) values ('d259', 'd260', 'Eggs & poultry', 1);
insert into food_groups (id, tier_id, label, position) values ('d264', 'd270', 'Sweeteners & extras', 0);
insert into food_groups (id, tier_id, label, position) values ('d269', 'd270', 'Snacks', 1);
insert into foods (id, group_id, name, prep, hero, position, department) values ('d95', 'd109', 'Oats', 'P', true, 0, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d96', 'd109', 'Farro', 'P', false, 1, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d97', 'd109', 'Barley', 'P', false, 2, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d98', 'd109', 'Bulgur', 'P', false, 3, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d100', 'd109', 'Quinoa', 'P', false, 4, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d101', 'd109', 'Whole-grain bread', 'P', false, 5, 'Bakery');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d102', 'd109', 'Whole-wheat pasta', 'P', false, 6, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d103', 'd109', 'Buckwheat / soba', 'P', false, 7, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d104', 'd109', 'Millet', 'P', false, 8, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d105', 'd109', 'Rye', 'P', false, 9, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d106', 'd109', 'Freekeh', 'P', false, 10, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d108', 'd109', 'Sorghum', 'P', false, 11, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex46', 'd109', 'Amaranth', 'P', false, 12, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex47', 'd109', 'Teff', 'P', false, 13, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex49', 'd109', 'Spelt', 'P', false, 14, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex50', 'd109', 'Kamut', 'P', false, 15, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex51', 'd109', 'Fonio', 'P', false, 16, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex52', 'd109', 'Finger millet', 'P', false, 17, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex53', 'd109', 'Pearl millet', 'P', false, 18, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex54', 'd109', 'Job''s tears', 'P', false, 19, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex55', 'd109', 'Whole-grain corn tortillas', 'P', false, 20, 'Bakery');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex56', 'd109', 'Brown rice noodles', 'P', false, 21, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex57', 'd109', 'Whole-wheat couscous', 'P', false, 22, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u2', 'd109', 'Whole-wheat pita', 'F', false, 23, 'Bakery');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u709', 'd109', 'Rye flour', 'F', false, 24, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u710', 'd109', 'Whole-wheat flour', 'F', false, 25, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u711', 'd109', 'Buckwheat flour', 'F', false, 26, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u712', 'd109', 'Oat flour', 'F', false, 27, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u713', 'd109', 'Cornmeal', 'F', false, 28, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u714', 'd109', 'Oat milk', 'F', false, 29, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u726', 'd109', 'Brown rice flour', 'F', false, 30, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u999', 'd109', 'Rice, wild', 'F', false, 31, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1000', 'd109', 'Rice, red', 'F', false, 32, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1001', 'd109', 'Rice, brown', 'F', false, 33, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1002', 'd109', 'Rice, black', 'F', false, 34, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1003', 'd109', 'Sprouted-grain bread', 'F', false, 35, 'Bakery');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex250', 'd109', 'White flour', 'F', false, 36, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d110', 'd138', 'Berries', 'F', true, 0, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d111', 'd138', 'Pomegranate', 'F', false, 1, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d112', 'd138', 'Figs', 'F', false, 2, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d113', 'd138', 'Grapes', 'F', false, 3, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d114', 'd138', 'Oranges', 'F', false, 4, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d115', 'd138', 'Apples', 'F', false, 5, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d116', 'd138', 'Pears', 'F', false, 6, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d117', 'd138', 'Melon', 'F', false, 7, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d119', 'd138', 'Dates', 'P', false, 8, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d120', 'd138', 'Apricots', 'F', false, 9, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d121', 'd138', 'Peaches', 'F', false, 10, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d122', 'd138', 'Plums', 'F', false, 11, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d123', 'd138', 'Cherries', 'F', false, 12, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d124', 'd138', 'Grapefruit', 'F', false, 13, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d125', 'd138', 'Nectarines', 'F', false, 14, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d126', 'd138', 'Kiwi', 'F', false, 15, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d127', 'd138', 'Persimmon', 'F', false, 16, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d128', 'd138', 'Quince', 'F', false, 17, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d129', 'd138', 'Prunes', 'P', false, 18, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d130', 'd138', 'Raisins', 'P', false, 19, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d131', 'd138', 'Mandarins', 'F', false, 20, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d132', 'd138', 'Asian pear', 'F', false, 21, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d133', 'd138', 'Lingonberries', 'F', false, 22, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d134', 'd138', 'Bilberries', 'F', false, 23, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d135', 'd138', 'Black currants', 'F', false, 24, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d136', 'd138', 'Sea buckthorn', 'F', false, 25, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d137', 'd138', 'Yuzu', 'F', false, 26, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex59', 'd138', 'Mango', 'F', false, 27, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex60', 'd138', 'Papaya', 'F', false, 28, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex61', 'd138', 'Guava', 'F', false, 29, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex62', 'd138', 'Pineapple', 'F', false, 30, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex63', 'd138', 'Passion fruit', 'F', false, 31, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex64', 'd138', 'Dragon fruit', 'F', false, 32, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex65', 'd138', 'Lychee', 'F', false, 33, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex66', 'd138', 'Longan', 'F', false, 34, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex67', 'd138', 'Rambutan', 'F', false, 35, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex68', 'd138', 'Mangosteen', 'F', false, 36, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex69', 'd138', 'Jackfruit', 'F', false, 37, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex70', 'd138', 'Pomelo', 'F', false, 38, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex71', 'd138', 'Loquat', 'F', false, 39, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex72', 'd138', 'Cherimoya', 'F', false, 40, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex73', 'd138', 'Prickly pear', 'F', false, 41, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex74', 'd138', 'Tamarind', 'P', false, 42, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex75', 'd138', 'Indian gooseberry', 'F', false, 43, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex76', 'd138', 'Sapota', 'F', false, 44, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex77', 'd138', 'Jamun', 'F', false, 45, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex78', 'd138', 'Blackberries', 'F', false, 46, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex79', 'd138', 'Raspberries', 'F', false, 47, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex80', 'd138', 'Strawberries', 'F', false, 48, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex81', 'd138', 'Blueberries', 'F', false, 49, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex82', 'd138', 'Cranberries', 'F', false, 50, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex83', 'd138', 'Gooseberries', 'F', false, 51, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex84', 'd138', 'Mulberries', 'F', false, 52, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex85', 'd138', 'Elderberries', 'F', false, 53, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex86', 'd138', 'Aronia berries', 'F', false, 54, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex87', 'd138', 'Goji berries', 'P', false, 55, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex88', 'd138', 'Banana', 'F', false, 56, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex89', 'd138', 'Cantaloupe', 'F', false, 57, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex90', 'd138', 'Watermelon', 'F', false, 58, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex91', 'd138', 'Starfruit', 'F', false, 59, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai1', 'd138', 'Tart cherries', 'F', false, 60, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai2', 'd138', 'Açaí', 'F', false, 61, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai3', 'd138', 'Camu camu', 'P', false, 62, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1', 'd138', 'Limes', 'F', false, 63, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u717', 'd138', 'Figs, dried', 'F', false, 64, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u718', 'd138', 'Apricots, dried', 'F', false, 65, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u719', 'd138', 'Cranberries, dried', 'F', false, 66, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u720', 'd138', 'Applesauce', 'F', false, 67, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u978', 'd138', 'Plantain', 'F', false, 68, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex244', 'd138', 'Cranberry juice', 'F', false, 69, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d139', 'd159', 'Turmeric', 'P', true, 0, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d141', 'd159', 'Basil', 'F', false, 1, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d142', 'd159', 'Oregano', 'P', false, 2, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d143', 'd159', 'Rosemary', 'F', false, 3, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d145', 'd159', 'Mint', 'F', false, 4, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d146', 'd159', 'Thyme', 'P', false, 5, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d147', 'd159', 'Cinnamon', 'P', false, 6, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d148', 'd159', 'Black pepper', 'P', false, 7, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d149', 'd159', 'Sumac', 'P', false, 8, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d150', 'd159', 'Wasabi', 'P', false, 9, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d152', 'd159', 'Caraway', 'P', false, 10, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d153', 'd159', 'Star anise', 'P', false, 11, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d154', 'd159', 'Cardamom', 'P', false, 12, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d155', 'd159', 'Cloves', 'P', false, 13, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d156', 'd159', 'Sage', 'F', false, 14, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d157', 'd159', 'Cumin', 'P', false, 15, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex93', 'd159', 'Coriander seeds', 'P', false, 16, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex94', 'd159', 'Mustard seeds', 'P', false, 17, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex95', 'd159', 'Fenugreek seeds', 'P', false, 18, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex96', 'd159', 'Fennel seeds', 'P', false, 19, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex97', 'd159', 'Curry leaves', 'F', false, 20, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex98', 'd159', 'Garam masala', 'P', false, 21, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex99', 'd159', 'Asafoetida', 'P', false, 22, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex100', 'd159', 'Nigella seeds', 'P', false, 23, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex101', 'd159', 'Ajwain', 'P', false, 24, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex102', 'd159', 'Saffron', 'P', false, 25, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex103', 'd159', 'Bay leaves', 'P', false, 26, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex104', 'd159', 'Allspice', 'P', false, 27, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex105', 'd159', 'Mexican oregano', 'P', false, 28, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex106', 'd159', 'Epazote', 'P', false, 29, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex107', 'd159', 'Annatto', 'P', false, 30, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex108', 'd159', 'Sichuan peppercorns', 'P', false, 31, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex109', 'd159', 'Lemongrass', 'F', false, 32, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex110', 'd159', 'Galangal', 'F', false, 33, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex111', 'd159', 'Kaffir lime leaves', 'F', false, 34, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex112', 'd159', 'Thai basil', 'F', false, 35, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex114', 'd159', 'Tarragon', 'F', false, 36, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex115', 'd159', 'Marjoram', 'F', false, 37, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex116', 'd159', 'Za''atar', 'P', false, 38, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex117', 'd159', 'Gochugaru', 'P', false, 39, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex118', 'd159', 'Chinese five-spice', 'P', false, 40, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai4', 'd159', 'Cayenne', 'P', false, 41, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u721', 'd159', 'Ginger, ground', 'F', false, 42, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u722', 'd159', 'Garlic powder', 'F', false, 43, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u794', 'd159', 'Paprika', 'F', false, 44, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u795', 'd159', 'Paprika, smoked', 'F', false, 45, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u796', 'd159', 'Chives, dried', 'F', false, 46, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u798', 'd159', 'Chives', 'F', false, 47, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u799', 'd159', 'Parsley, dried', 'F', false, 48, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u969', 'd159', 'Dill', 'F', false, 49, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u970', 'd159', 'Ginger, fresh', 'F', false, 50, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u979', 'd159', 'Chili powder', 'F', false, 51, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u998', 'd159', 'Coriander', 'F', false, 52, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1007', 'd159', 'Onion powder', 'F', false, 53, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex248', 'd159', 'Salt', 'F', false, 54, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d118', 'd159', 'Lemon', 'F', false, 55, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex252', 'd159', 'Curry powder', 'P', false, 56, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d160', 'd165', 'Green tea', 'P', true, 0, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d161', 'd165', 'Matcha', 'P', false, 1, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d162', 'd165', 'Sencha', 'P', false, 2, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d163', 'd165', 'Hojicha', 'P', false, 3, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d164', 'd165', 'Hibiscus', 'P', false, 4, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex119', 'd165', 'Oolong tea', 'P', false, 5, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex120', 'd165', 'Pu-erh tea', 'P', false, 6, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex121', 'd165', 'White tea', 'P', false, 7, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex122', 'd165', 'Jasmine tea', 'P', false, 8, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex123', 'd165', 'Genmaicha', 'P', false, 9, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex124', 'd165', 'Gyokuro', 'P', false, 10, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex125', 'd165', 'Barley tea', 'P', false, 11, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex126', 'd165', 'Chrysanthemum tea', 'P', false, 12, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex127', 'd165', 'Rooibos', 'P', false, 13, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex128', 'd165', 'Yerba mate', 'P', false, 14, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex129', 'd165', 'Tulsi', 'P', false, 15, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex130', 'd165', 'Chamomile', 'P', false, 16, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex131', 'd165', 'Peppermint tea', 'P', false, 17, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex132', 'd165', 'Ginger tea', 'P', false, 18, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex133', 'd165', 'Kombucha', 'F', false, 19, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u809', 'd165', 'Wheatgrass', 'F', false, 20, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u810', 'd165', 'Coffee', 'F', false, 21, 'Coffee & Tea');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d167', 'd183', 'Balsamic vinegar', 'P', false, 0, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d168', 'd183', 'Red wine vinegar', 'P', false, 1, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d169', 'd183', 'Apple cider vinegar', 'P', false, 2, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d170', 'd183', 'Sherry vinegar', 'P', false, 3, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d171', 'd183', 'White wine vinegar', 'P', false, 4, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d172', 'd183', 'Rice vinegar', 'P', false, 5, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d175', 'd183', 'Tomato paste', 'P', false, 6, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d176', 'd183', 'Harissa', 'P', false, 7, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d177', 'd183', 'Pesto', 'F', false, 8, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d178', 'd183', 'Pomegranate molasses', 'P', false, 9, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d179', 'd183', 'Olive tapenade', 'P', false, 10, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d180', 'd183', 'Anchovy paste', 'P', false, 11, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d181', 'd183', 'Hot sauce', 'P', false, 12, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d182', 'd183', 'Lemon juice', 'F', false, 13, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex134', 'd183', 'Fish sauce', 'P', false, 14, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex135', 'd183', 'Oyster sauce', 'P', false, 15, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex136', 'd183', 'Gochujang', 'P', false, 16, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex137', 'd183', 'Doubanjiang', 'P', false, 17, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex138', 'd183', 'Ponzu', 'P', false, 18, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex139', 'd183', 'Black vinegar', 'P', false, 19, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex140', 'd183', 'Coconut aminos', 'P', false, 20, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex141', 'd183', 'Salsa', 'F', false, 21, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex142', 'd183', 'Salsa verde', 'F', false, 22, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex143', 'd183', 'Chipotle in adobo', 'P', false, 23, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex144', 'd183', 'Tamarind paste', 'P', false, 24, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex145', 'd183', 'Mango chutney', 'P', false, 25, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex146', 'd183', 'Sambal oelek', 'P', false, 26, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai5', 'd183', 'Bone broth', 'P', false, 27, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u6', 'd183', 'Vegetable broth', 'F', false, 28, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u963', 'd183', 'Mustard, Dijon', 'F', false, 29, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u964', 'd183', 'Mustard, brown', 'F', false, 30, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1021', 'd183', 'Chili paste', 'F', false, 31, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1022', 'd183', 'Salsa roja', 'F', false, 32, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1023', 'd183', 'Vegetable stock', 'F', false, 33, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1024', 'd183', 'Garlic paste', 'F', false, 34, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex242', 'd183', 'Chili sauce', 'F', false, 35, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex241', 'd183', 'Chicken broth', 'F', false, 36, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex251', 'd183', 'Curry paste, red', 'P', false, 37, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d184', 'd203', 'Lentils', 'P', true, 0, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d185', 'd203', 'Chickpeas', 'P', true, 1, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d186', 'd203', 'White beans', 'P', false, 2, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d187', 'd203', 'Fava beans', 'P', false, 3, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d188', 'd203', 'Black-eyed peas', 'P', false, 4, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d189', 'd203', 'Split peas', 'P', false, 5, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d190', 'd203', 'Kidney beans', 'P', false, 6, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d191', 'd203', 'Butter beans', 'P', false, 7, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d192', 'd203', 'Borlotti beans', 'P', false, 8, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d193', 'd203', 'Lupini beans', 'P', false, 9, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d194', 'd203', 'Green peas', 'F', false, 10, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d195', 'd203', 'Cannellini beans', 'P', false, 11, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d196', 'd203', 'Pinto beans', 'P', false, 12, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d197', 'd203', 'Edamame', 'F', false, 13, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d198', 'd203', 'Hummus', 'F', false, 14, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d199', 'd203', 'Adzuki beans', 'P', false, 15, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d200', 'd203', 'Mung beans', 'P', false, 16, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d201', 'd203', 'Soybeans', 'P', false, 17, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d202', 'd203', 'Red beans', 'P', false, 18, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex147', 'd203', 'Black beans', 'P', false, 19, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex148', 'd203', 'Pigeon peas', 'P', false, 20, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex149', 'd203', 'Black gram', 'P', false, 21, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex154', 'd203', 'Black chickpeas', 'P', false, 22, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex155', 'd203', 'Navy beans', 'P', false, 23, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex156', 'd203', 'Great northern beans', 'P', false, 24, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex157', 'd203', 'Cranberry beans', 'P', false, 25, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex158', 'd203', 'Peanuts', 'P', false, 26, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex159', 'd203', 'Moth beans', 'P', false, 27, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex160', 'd203', 'Horse gram', 'P', false, 28, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u705', 'd203', 'Black beans, canned', 'F', false, 29, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u706', 'd203', 'Cannellini beans, canned', 'F', false, 30, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u708', 'd203', 'Chickpea flour', 'F', false, 31, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u753', 'd203', 'Red beans, canned', 'F', false, 32, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u754', 'd203', 'Chickpeas, canned', 'F', false, 33, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u755', 'd203', 'Kidney beans, canned', 'F', false, 34, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u758', 'd203', 'Great northern beans, canned', 'F', false, 35, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u759', 'd203', 'White beans, canned', 'F', false, 36, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u972', 'd203', 'Navy beans, canned', 'F', false, 37, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u973', 'd203', 'Pinto beans, canned', 'F', false, 38, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u975', 'd203', 'Peas', 'F', false, 39, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u976', 'd203', 'Peas, canned/frozen', 'F', false, 40, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u992', 'd203', 'Lentils, red', 'F', false, 41, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u993', 'd203', 'Lentils, green', 'F', false, 42, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u996', 'd203', 'Lentils, brown', 'F', false, 43, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u997', 'd203', 'Lentils, black', 'F', false, 44, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d204', 'd222', 'Walnuts', 'P', true, 0, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d205', 'd222', 'Almonds', 'P', true, 1, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d206', 'd222', 'Pistachios', 'P', false, 2, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d207', 'd222', 'Hazelnuts', 'P', false, 3, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d208', 'd222', 'Pine nuts', 'P', false, 4, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d209', 'd222', 'Tahini', 'P', false, 5, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d211', 'd222', 'Sunflower seeds', 'P', false, 6, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d212', 'd222', 'Pumpkin seeds', 'P', false, 7, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d213', 'd222', 'Chia seeds', 'P', false, 8, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d214', 'd222', 'Cashews', 'P', false, 9, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d215', 'd222', 'Pecans', 'P', false, 10, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d216', 'd222', 'Sesame seeds', 'P', false, 11, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d217', 'd222', 'Brazil nuts', 'P', false, 12, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d218', 'd222', 'Macadamia nuts', 'P', false, 13, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d219', 'd222', 'Almond butter', 'P', false, 14, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d220', 'd222', 'Hemp seeds', 'P', false, 15, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d221', 'd222', 'Pepitas', 'P', false, 16, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex161', 'd222', 'Peanut butter', 'P', false, 17, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex162', 'd222', 'Cashew butter', 'P', false, 18, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex164', 'd222', 'Poppy seeds', 'P', false, 19, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex165', 'd222', 'Watermelon seeds', 'P', false, 20, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex167', 'd222', 'Lotus seeds', 'P', false, 21, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u5', 'd222', 'Coconut milk', 'F', false, 22, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u715', 'd222', 'Almond flour', 'F', false, 23, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u716', 'd222', 'Almond milk', 'F', false, 24, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u832', 'd222', 'Coconut, shredded', 'F', false, 25, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u833', 'd222', 'Coconut, baby', 'F', false, 26, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u951', 'd222', 'Almonds, slivered', 'F', false, 27, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u952', 'd222', 'Flaxseed, ground', 'F', false, 28, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u953', 'd222', 'Flaxseed, whole', 'F', false, 29, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d223', 'd231', 'Tofu', 'F', true, 0, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d224', 'd231', 'Natto', 'F', true, 1, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d225', 'd231', 'Miso', 'P', true, 2, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d226', 'd231', 'Tempeh', 'F', false, 3, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d227', 'd231', 'Tamari / soy sauce', 'P', false, 4, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d228', 'd231', 'Kimchi', 'F', false, 5, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d229', 'd231', 'Sauerkraut', 'F', false, 6, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d230', 'd231', 'Pickled vegetables', 'P', false, 7, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex168', 'd231', 'Doenjang', 'P', false, 8, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex169', 'd231', 'Fermented black beans', 'P', false, 9, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex170', 'd231', 'Fermented tofu', 'P', false, 10, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex171', 'd231', 'Soy milk', 'F', false, 11, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex172', 'd231', 'Nutritional yeast', 'P', false, 12, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d233', 'd238', 'Kefir', 'F', false, 0, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d234', 'd238', 'Skyr', 'F', false, 1, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d235', 'd238', 'Feta', 'F', false, 2, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d236', 'd238', 'Pecorino / Parmesan', 'F', false, 3, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d237', 'd238', 'Ricotta', 'F', false, 4, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex173', 'd238', 'Paneer', 'F', false, 5, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex174', 'd238', 'Buttermilk', 'F', false, 6, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex175', 'd238', 'Queso fresco', 'F', false, 7, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex176', 'd238', 'Cotija', 'F', false, 8, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex177', 'd238', 'Cottage cheese', 'F', false, 9, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex178', 'd238', 'Labneh', 'F', false, 10, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex180', 'd238', 'Manchego', 'F', false, 11, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex181', 'd238', 'Halloumi', 'F', false, 12, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex182', 'd238', 'Mozzarella', 'F', false, 13, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u814', 'd238', 'Cheese, goat', 'F', false, 14, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u815', 'd238', 'Yogurt, Greek', 'F', false, 15, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u816', 'd238', 'Yogurt, skyr', 'F', false, 16, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai6', 'd240', 'Omega-3 fish oil', 'P', false, 0, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai7', 'd240', 'Curcumin', 'P', false, 1, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai8', 'd240', 'Vitamin D', 'P', false, 2, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai9', 'd240', 'Ginger extract', 'P', false, 3, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai10', 'd240', 'Boswellia', 'P', false, 4, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai13', 'd240', 'Resveratrol', 'P', false, 5, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai14', 'd240', 'Probiotics', 'P', false, 6, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai15', 'd240', 'Spirulina', 'P', false, 7, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai16', 'd240', 'Chlorella', 'P', false, 8, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ai17', 'd240', 'Ashwagandha', 'P', false, 9, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex238', 'd240', 'Acai powder', 'F', false, 10, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex240', 'd240', 'Blueberry powder', 'F', false, 11, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex245', 'd240', 'Creatine powder', 'F', false, 12, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex249', 'd240', 'Theobromine powder', 'F', false, 13, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1037', 'd240', 'Beet powder', 'F', false, 14, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1038', 'd240', 'Multivitamin', 'F', false, 15, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1039', 'd240', 'Garlic extract', 'F', false, 16, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1040', 'd240', 'Vitamin B12', 'F', false, 17, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1041', 'd240', 'Cranberry powder', 'F', false, 18, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1042', 'd240', 'Green tea extract', 'F', false, 19, 'Health & Wellness');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d242', 'd255', 'Sardines', 'P', true, 0, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d243', 'd255', 'Salmon', 'F', true, 1, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d244', 'd255', 'Herring', 'F', false, 2, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d245', 'd255', 'Anchovies', 'P', false, 3, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d246', 'd255', 'Mackerel', 'F', false, 4, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d247', 'd255', 'Tuna', 'P', false, 5, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d248', 'd255', 'Cod', 'F', false, 6, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d249', 'd255', 'Trout', 'F', false, 7, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d250', 'd255', 'Sea bass', 'F', false, 8, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d251', 'd255', 'Pollock', 'F', false, 9, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d252', 'd255', 'Tuna, canned', 'P', false, 10, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d253', 'd255', 'Sardines, canned', 'P', false, 11, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d254', 'd255', 'Salmon, canned', 'P', false, 12, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex183', 'd255', 'Shrimp', 'F', false, 13, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex184', 'd255', 'Mussels', 'F', false, 14, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex185', 'd255', 'Clams', 'F', false, 15, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex186', 'd255', 'Oysters', 'F', false, 16, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex187', 'd255', 'Scallops', 'F', false, 17, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex188', 'd255', 'Squid', 'F', false, 18, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex189', 'd255', 'Octopus', 'F', false, 19, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex190', 'd255', 'Crab', 'F', false, 20, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex191', 'd255', 'Halibut', 'F', false, 21, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex192', 'd255', 'Haddock', 'F', false, 22, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex193', 'd255', 'Arctic char', 'F', false, 23, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex194', 'd255', 'Snapper', 'F', false, 24, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex195', 'd255', 'Tilapia', 'F', false, 25, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex196', 'd255', 'Barramundi', 'F', false, 26, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u7', 'd255', 'Rockfish', 'F', false, 27, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u723', 'd255', 'Mackerel, canned', 'F', false, 28, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u724', 'd255', 'Salmon, smoked', 'F', false, 29, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u725', 'd255', 'Mackerel, smoked', 'F', false, 30, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u834', 'd255', 'Lobster', 'F', false, 31, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u835', 'd255', 'Roe', 'F', false, 32, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1036', 'd255', 'Herring, canned', 'F', false, 33, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d256', 'd259', 'Eggs', 'F', true, 0, 'Dairy');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex197', 'd259', 'Duck', 'F', false, 1, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex198', 'd259', 'Quail', 'F', false, 2, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex199', 'd259', 'Duck eggs', 'F', false, 3, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex200', 'd259', 'Quail eggs', 'F', false, 4, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u773', 'd259', 'Chicken, breast', 'F', false, 5, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u774', 'd259', 'Chicken, thigh', 'F', false, 6, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u775', 'd259', 'Chicken, whole', 'F', false, 7, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u776', 'd259', 'Turkey, thigh', 'F', false, 8, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u777', 'd259', 'Turkey, breast', 'F', false, 9, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u778', 'd259', 'Turkey, leg', 'F', false, 10, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u779', 'd259', 'Chicken, leg', 'F', false, 11, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u780', 'd259', 'Chicken, wing', 'F', false, 12, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u971', 'd259', 'Turkey, ground', 'F', false, 13, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d261', 'd264', 'Honey', 'P', false, 0, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d263', 'd264', 'Red wine · optional', 'P', false, 1, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex201', 'd264', 'Maple syrup', 'P', false, 2, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex202', 'd264', 'Blackstrap molasses', 'P', false, 3, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex203', 'd264', 'Coconut sugar', 'P', false, 4, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex204', 'd264', 'Jaggery', 'P', false, 5, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex205', 'd264', 'Piloncillo', 'P', false, 6, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex206', 'd264', 'Date syrup', 'P', false, 7, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex207', 'd264', 'Agave nectar', 'P', false, 8, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex208', 'd264', 'Monk fruit', 'P', false, 9, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex209', 'd264', 'Stevia', 'P', false, 10, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex210', 'd264', 'Cacao nibs', 'P', false, 11, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u8', 'd264', 'Cacao powder', 'F', false, 12, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u9', 'd264', 'Vanilla extract', 'F', false, 13, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d265', 'd269', 'Red meat', 'F', false, 0, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d267', 'd269', 'Rich cheeses', 'F', false, 1, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d268', 'd269', 'Sweets & pastries', 'P', false, 2, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex211', 'd269', 'Dark chocolate', 'P', false, 3, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex212', 'd269', 'Roasted chickpeas', 'P', false, 4, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex213', 'd269', 'Roasted edamame', 'P', false, 5, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex214', 'd269', 'Seaweed snacks', 'P', false, 6, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex215', 'd269', 'Roasted makhana', 'P', false, 7, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex216', 'd269', 'Kale chips', 'P', false, 8, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex217', 'd269', 'Whole-grain crackers', 'P', false, 9, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex218', 'd269', 'Rye crisps', 'P', false, 10, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex219', 'd269', 'Air-popped popcorn', 'P', false, 11, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex220', 'd269', 'Plantain chips', 'P', false, 12, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex221', 'd269', 'Trail mix', 'P', false, 13, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex222', 'd269', 'Nut & seed bars', 'P', false, 14, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex223', 'd269', 'Dried mango', 'P', false, 15, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex224', 'd269', 'Turkey jerky', 'P', false, 16, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex225', 'd269', 'Beef jerky', 'P', false, 17, 'Meat & Seafood');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex226', 'd269', 'Whole-grain pretzels', 'P', false, 18, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex227', 'd269', 'Rice cakes', 'P', false, 19, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex228', 'd269', 'Oatcakes', 'P', false, 20, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex230', 'd269', 'Falafel', 'F', false, 21, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex231', 'd269', 'Roasted chana', 'P', false, 22, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex232', 'd269', 'Puffed rice', 'P', false, 23, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex233', 'd269', 'Banana chips', 'P', false, 24, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex234', 'd269', 'Coconut chips', 'P', false, 25, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex236', 'd269', 'Granola', 'P', false, 26, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex237', 'd269', 'Energy balls', 'P', false, 27, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u811', 'd269', 'Salami', 'F', false, 28, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d7', 'd29', 'Spinach', 'F', true, 0, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d8', 'd29', 'Kale', 'F', false, 1, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d9', 'd29', 'Swiss chard', 'F', false, 2, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d10', 'd29', 'Arugula', 'F', false, 3, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d11', 'd29', 'Romaine', 'F', false, 4, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d12', 'd29', 'Dandelion greens', 'F', false, 5, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d13', 'd29', 'Watercress', 'F', false, 6, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d14', 'd29', 'Collard greens', 'F', false, 7, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d15', 'd29', 'Beet greens', 'F', false, 8, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d16', 'd29', 'Endive', 'F', false, 9, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d17', 'd29', 'Radicchio', 'F', false, 10, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d18', 'd29', 'Escarole', 'F', false, 11, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d19', 'd29', 'Mustard greens', 'F', false, 12, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d20', 'd29', 'Bok choy', 'F', false, 13, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d21', 'd29', 'Turnip greens', 'F', false, 14, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d22', 'd29', 'Frisée', 'F', false, 15, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d23', 'd29', 'Purslane', 'F', false, 16, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d24', 'd29', 'Mizuna', 'F', false, 17, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d25', 'd29', 'Komatsuna', 'F', false, 18, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d26', 'd29', 'Chrysanthemum greens', 'F', false, 19, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d27', 'd29', 'Tatsoi', 'F', false, 20, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d28', 'd29', 'Shiso', 'F', false, 21, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex9', 'd29', 'Chinese broccoli', 'F', false, 22, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex10', 'd29', 'Choy sum', 'F', false, 23, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex11', 'd29', 'Water spinach', 'F', false, 24, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex13', 'd29', 'Amaranth greens', 'F', false, 25, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex14', 'd29', 'Fenugreek leaves', 'F', false, 26, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex15', 'd29', 'Moringa leaves', 'F', false, 27, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex16', 'd29', 'Pea shoots', 'F', false, 28, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex17', 'd29', 'Sorrel', 'F', false, 29, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex18', 'd29', 'Mâche', 'F', false, 30, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex19', 'd29', 'Nettles', 'F', false, 31, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u679', 'd29', 'Cilantro', 'F', false, 32, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u800', 'd29', 'Parsley', 'F', false, 33, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u801', 'd29', 'Radish greens', 'F', false, 34, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u802', 'd29', 'Carrot greens', 'F', false, 35, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u803', 'd29', 'Parsley, Italian', 'F', false, 36, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u804', 'd29', 'Parsley, curly', 'F', false, 37, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u805', 'd29', 'Pea greens', 'F', false, 38, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u806', 'd29', 'Sprouts, mustard', 'F', false, 39, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u807', 'd29', 'Sprouts, broccoli', 'F', false, 40, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u808', 'd29', 'Sprouts', 'F', false, 41, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1006', 'd29', 'Sprouts, bean', 'F', false, 42, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1019', 'd29', 'Spinach, Malabar', 'F', false, 43, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1020', 'd29', 'Sprouts, alfalfa', 'F', false, 44, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d1', 'd6', 'Extra-virgin olive oil', 'P', true, 0, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d2', 'd6', 'Olives', 'P', false, 1, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d4', 'd6', 'Avocado oil', 'P', false, 2, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex1', 'd6', 'Ghee', 'P', false, 3, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex3', 'd6', 'Coconut oil', 'P', false, 4, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex4', 'd6', 'Flaxseed oil', 'P', false, 5, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex5', 'd6', 'Walnut oil', 'P', false, 6, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex6', 'd6', 'Mustard oil', 'P', false, 7, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex7', 'd6', 'Almond oil', 'P', false, 8, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex8', 'd6', 'Perilla oil', 'P', false, 9, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u817', 'd6', 'Rapeseed oil', 'F', false, 10, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u818', 'd6', 'Avocado', 'F', false, 11, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u819', 'd6', 'Canola oil', 'F', false, 12, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u959', 'd6', 'Olives, Kalamata', 'F', false, 13, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u960', 'd6', 'Olives, black', 'F', false, 14, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u961', 'd6', 'Olives, green', 'F', false, 15, 'Condiments & Dressings');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u820', 'd6', 'Sesame oil', 'F', false, 16, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex253', 'd6', 'Olive oil', 'P', false, 17, 'Cooking & Baking');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d33', 'd94', 'Eggplant', 'F', false, 0, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d34', 'd94', 'Zucchini', 'F', false, 1, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d36', 'd94', 'Broccoli', 'F', false, 2, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d37', 'd94', 'Cauliflower', 'F', false, 3, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d39', 'd94', 'Fennel', 'F', false, 4, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d40', 'd94', 'Cucumber', 'F', false, 5, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d42', 'd94', 'Asparagus', 'F', false, 6, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d44', 'd94', 'Leeks', 'F', false, 7, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d45', 'd94', 'Celery', 'F', false, 8, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d46', 'd94', 'Beets', 'F', false, 9, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d47', 'd94', 'Cabbage', 'F', false, 10, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d48', 'd94', 'Brussels sprouts', 'F', false, 11, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d49', 'd94', 'Okra', 'F', false, 12, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d50', 'd94', 'Capers', 'P', false, 13, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d51', 'd94', 'Tomatoes, sun-dried', 'P', false, 14, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d52', 'd94', 'Sweet potato', 'F', false, 15, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d53', 'd94', 'Butternut squash', 'F', false, 16, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d54', 'd94', 'Green beans', 'F', false, 17, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d56', 'd94', 'Turnips', 'F', false, 18, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d57', 'd94', 'Kohlrabi', 'F', false, 19, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d58', 'd94', 'Chili peppers', 'F', false, 20, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d59', 'd94', 'Shiitake', 'F', false, 21, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d60', 'd94', 'Maitake', 'F', false, 22, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d61', 'd94', 'Enoki', 'F', false, 23, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d62', 'd94', 'Daikon', 'F', false, 24, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d63', 'd94', 'Burdock root', 'F', false, 25, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d64', 'd94', 'Lotus root', 'F', false, 26, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d65', 'd94', 'Bitter melon', 'F', false, 27, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d66', 'd94', 'Napa cabbage', 'F', false, 28, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d67', 'd94', 'Bamboo shoots', 'F', false, 29, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d68', 'd94', 'Parsnip', 'F', false, 30, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d69', 'd94', 'Rutabaga', 'F', false, 31, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d74', 'd94', 'Shallots', 'P', false, 32, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d75', 'd94', 'Romanesco', 'F', false, 33, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d76', 'd94', 'Broccolini', 'F', false, 34, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d77', 'd94', 'Broccoli rabe', 'F', false, 35, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d78', 'd94', 'Sunchokes', 'F', false, 36, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d79', 'd94', 'Celeriac', 'F', false, 37, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d80', 'd94', 'Kabocha squash', 'F', false, 38, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d81', 'd94', 'Delicata squash', 'F', false, 39, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d82', 'd94', 'Acorn squash', 'F', false, 40, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d83', 'd94', 'Spaghetti squash', 'F', false, 41, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d84', 'd94', 'Heirloom tomatoes', 'F', false, 42, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d85', 'd94', 'Watermelon radish', 'F', false, 43, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d86', 'd94', 'Snap peas', 'F', false, 44, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d87', 'd94', 'Snow peas', 'F', false, 45, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d88', 'd94', 'Broccoli sprouts', 'F', false, 46, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d89', 'd94', 'Alfalfa sprouts', 'F', false, 47, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d90', 'd94', 'Microgreens', 'F', false, 48, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d91', 'd94', 'Chayote', 'F', false, 49, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d92', 'd94', 'Water chestnuts', 'F', false, 50, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d93', 'd94', 'Horseradish', 'P', false, 51, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex20', 'd94', 'Tomatillos', 'F', false, 52, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex21', 'd94', 'Nopales', 'F', false, 53, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex22', 'd94', 'Jicama', 'F', false, 54, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex25', 'd94', 'Serrano peppers', 'F', false, 55, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex26', 'd94', 'Sweet corn', 'F', false, 56, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex27', 'd94', 'Taro', 'F', false, 57, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex28', 'd94', 'Yam', 'F', false, 58, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex29', 'd94', 'Winter melon', 'F', false, 59, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex30', 'd94', 'Long beans', 'F', false, 60, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex33', 'd94', 'Bottle gourd', 'F', false, 61, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex34', 'd94', 'Ridge gourd', 'F', false, 62, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex35', 'd94', 'Drumsticks', 'F', false, 63, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex36', 'd94', 'Cluster beans', 'F', false, 64, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex37', 'd94', 'Shishito peppers', 'F', false, 65, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex38', 'd94', 'Garlic scapes', 'F', false, 66, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex39', 'd94', 'Fiddleheads', 'F', false, 67, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex40', 'd94', 'Ramps', 'F', false, 68, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex41', 'd94', 'Chinese celery', 'F', false, 69, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex42', 'd94', 'Baby corn', 'F', false, 70, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex43', 'd94', 'Ivy gourd', 'F', false, 71, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex45', 'd94', 'Cassava', 'F', false, 72, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u3', 'd94', 'Wakame', 'F', false, 73, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u4', 'd94', 'Nori', 'F', false, 74, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u702', 'd94', 'Artichoke hearts', 'F', false, 75, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u703', 'd94', 'Shiitake, dried', 'F', false, 76, 'Bulk');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u756', 'd94', 'Tomatoes, canned, diced', 'F', false, 77, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u757', 'd94', 'Tomatoes, canned, crushed', 'F', false, 78, 'Canned & Dry Goods');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u760', 'd94', 'Tomato sauce, jar/can', 'F', false, 79, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u782', 'd94', 'Bell pepper, green', 'F', false, 80, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u783', 'd94', 'Bell pepper, red', 'F', false, 81, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u784', 'd94', 'Bell pepper, yellow', 'F', false, 82, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u785', 'd94', 'Artichoke', 'F', false, 83, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u786', 'd94', 'Onions, green', 'F', false, 84, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u787', 'd94', 'Onion, sweet', 'F', false, 85, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u788', 'd94', 'Onion, yellow', 'F', false, 86, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u789', 'd94', 'Onion, red', 'F', false, 87, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u790', 'd94', 'Onion, white', 'F', false, 88, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u791', 'd94', 'Potatoes, red', 'F', false, 89, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u792', 'd94', 'Potatoes, Russet', 'F', false, 90, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u793', 'd94', 'Potatoes, Yukon', 'F', false, 91, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u954', 'd94', 'Tomatoes, cherry', 'F', false, 92, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u955', 'd94', 'Tomatoes, roma', 'F', false, 93, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u956', 'd94', 'Tomatoes, heirloom', 'F', false, 94, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u958', 'd94', 'Tomato', 'F', false, 95, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u966', 'd94', 'Garlic clove', 'F', false, 96, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u977', 'd94', 'Carrot', 'F', false, 97, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u980', 'd94', 'Anaheim pepper', 'F', false, 98, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u981', 'd94', 'Poblano pepper', 'F', false, 99, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u982', 'd94', 'Roasted red peppers', 'F', false, 100, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u983', 'd94', 'Habanero peppers', 'F', false, 101, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u984', 'd94', 'Mushrooms, shiitake', 'F', false, 102, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u986', 'd94', 'Mushrooms, white', 'F', false, 103, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u987', 'd94', 'Mushroom, portobello', 'F', false, 104, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u988', 'd94', 'Mushrooms, cremini', 'F', false, 105, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u989', 'd94', 'Mushrooms, oyster', 'F', false, 106, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u990', 'd94', 'Mushrooms, trumpet', 'F', false, 107, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u991', 'd94', 'Mushrooms, enoki', 'F', false, 108, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1004', 'd94', 'Eggplant, Chinese', 'F', false, 109, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('u1005', 'd94', 'Eggplant, Indian', 'F', false, 110, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('ex24', 'd94', 'Jalapeno', 'F', false, 111, 'Produce');
insert into foods (id, group_id, name, prep, hero, position, department) values ('d55', 'd94', 'Radish', 'F', false, 112, 'Produce');
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd179', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd180', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd2', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd225', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd227', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd228', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd229', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd230', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd235', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd236', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd245', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd267', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd50', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'd51', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex134', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex135', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex136', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex137', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex138', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex146', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex168', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex169', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex170', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex176', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex180', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex181', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex224', true, NULL);
insert into user_food_state (user_id, food_id, in_stock, recipe_id) values ('local', 'ex225', true, NULL);
insert into storage_locations (id, user_id, name, meta, rail, line, note, zone, position) values ('d271', 'local', 'Shopping List', 'WHAT TO BUY · DRAG FOODS HERE', 'oklch(0.5 0.09 150)', 'oklch(0.85 0.045 150)', 'Drag foods here to build your shopping list.', 'kitchen', 0);
insert into storage_locations (id, user_id, name, meta, rail, line, note, zone, position) values ('d272', 'local', 'Pantry', 'ROOM TEMPERATURE · SHOP MONTHLY', 'oklch(0.55 0.08 74)', 'oklch(0.86 0.04 74)', 'Grains, legumes, nuts & seeds keep beautifully in mason jars. Choose no-salt-added canned goods where you can.', 'kitchen', 1);
insert into storage_locations (id, user_id, name, meta, rail, line, note, zone, position) values ('d273', 'local', 'Refrigerator', 'REFRIGERATOR · SHOP WEEKLY', 'oklch(0.49 0.06 232)', 'oklch(0.85 0.035 232)', 'Long-keeping produce and cultured staples that earn their shelf space — carrots and cabbage last for weeks and turn up in countless recipes.', 'kitchen', 2);
insert into storage_locations (id, user_id, name, meta, rail, line, note, zone, position) values ('d274', 'local', 'Freezer', 'FREEZER · SHOP MONTHLY', 'oklch(0.52 0.06 212)', 'oklch(0.85 0.035 212)', 'Flash-frozen at peak ripeness — just as nutritious as fresh and always on hand. Nuts keep longest in the freezer too.', 'kitchen', 3);
insert into storage_locations (id, user_id, name, meta, rail, line, note, zone, position) values ('d275', 'local', 'Counter', 'COOL · DARK · NOT REFRIGERATED', 'oklch(0.5 0.085 64)', 'oklch(0.85 0.04 64)', 'Roots, alliums, and winter squash that keep best in a cool, dark cupboard rather than the fridge.', 'kitchen', 4);
insert into storage_locations (id, user_id, name, meta, rail, line, note, zone, position) values ('d276', 'local', 'Spice Cupboard', 'DRIED SPICES & HERBS · COOL, DARK', 'oklch(0.5 0.11 45)', 'oklch(0.85 0.05 45)', 'Ground and whole dried spices — kept away from heat and light.', 'kitchen', 5);
insert into storage_locations (id, user_id, name, meta, rail, line, note, zone, position) values ('d277', 'local', 'Apothecary', 'SUPPLEMENTS · COOL, DARK, DRY', 'oklch(0.5 0.08 300)', 'oklch(0.85 0.04 300)', 'Capsules, powders, and tinctures — kept cool, dark, and dry.', 'kitchen', 6);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('d278', 'local', 'Cucumber Sandwich', 'Main Courses', 'Ingredients:
- 2 slices whole-grain bread
- 1/2 cucumber, thinly sliced
- 3 tbsp hummus
- 1 tsp extra-virgin olive oil
- 2 tbsp feta, crumbled
- 1 tbsp fresh dill, chopped
- 1 tsp lemon juice
- Black pepper, to taste

Instructions:
1. Spread the hummus evenly over both slices of bread.
2. Layer the cucumber over one slice; scatter the crumbled feta and dill on top.
3. Drizzle with olive oil and lemon juice, then season with black pepper.
4. Close the sandwich, slice in half on the diagonal, and serve.', false, 0);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('d287', 'local', 'Hummus', 'Sauces & Condiments', 'Ingredients:
- 1 can (15 oz) chickpeas, drained (reserve liquid)
- 1/4 cup tahini
- 3 tbsp extra-virgin olive oil, plus more to serve
- 2 tbsp lemon juice
- 1 clove garlic
- 1/2 tsp ground cumin
- Salt, to taste

Instructions:
1. Blend the tahini and lemon juice until creamy, about 1 minute.
2. Add the garlic, cumin, olive oil, and a pinch of salt; blend to combine.
3. Add the chickpeas and blend until smooth, thinning with the reserved
   chickpea liquid a tablespoon at a time until light and fluffy.
4. Spread in a bowl, drizzle with olive oil, and serve.', false, 1);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('d294', 'local', 'Tzatziki', 'Sauces & Condiments', 'Ingredients:
- 1 cup plain Greek yogurt
- 1/2 cucumber, grated and squeezed dry
- 1 clove garlic, minced
- 1 tbsp extra-virgin olive oil
- 1 tbsp fresh dill, chopped
- 1 tsp lemon juice
- Salt, to taste

Instructions:
1. Grate the cucumber, then squeeze out as much liquid as possible.
2. Stir the cucumber into the yogurt with the garlic, olive oil, dill,
   and lemon juice.
3. Season with salt, chill 30 minutes to let the flavors meld, and serve.', false, 2);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u10', 'local', 'Overnight Oats with Berries & Walnuts', 'Snacks', 'Ingredients:
- 1/2 cup rolled oats
- 1 tbsp chia seeds
- 1/2 cup soy milk (or milk of choice)
- 1/4 cup plain Greek yogurt
- 1/2 cup mixed berries
- 2 tbsp walnuts, chopped
- 1/4 tsp cinnamon
- 1 tsp honey (optional)

Instructions:
1. Stir the oats, chia seeds, soy milk, yogurt, and cinnamon together in a jar.
2. Cover and refrigerate overnight, or at least 4 hours.
3. In the morning, loosen with a splash of milk if thick.
4. Top with the berries and walnuts, and drizzle with honey.', false, 3);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u19', 'local', 'Shakshuka', 'Main Courses', 'Ingredients:
- 2 tbsp extra-virgin olive oil
- 1 onion, diced
- 1 red bell pepper, diced
- 3 cloves garlic, sliced
- 1 tsp smoked paprika
- 1 tsp ground cumin
- 1 can (28 oz) crushed tomatoes
- 4 eggs
- 1/4 cup crumbled feta
- Handful of parsley, chopped
- Whole-grain bread, to serve

Instructions:
1. Warm the oil in a wide skillet and soften the onion and pepper, about 8 minutes.
2. Stir in the garlic, paprika, and cumin for 1 minute, then pour in the tomatoes.
3. Simmer 10 minutes until slightly thickened; season with salt and pepper.
4. Make four wells and crack an egg into each. Cover and cook 6-8 minutes, until the whites are set but the yolks still jiggle.
5. Scatter with feta and parsley and serve from the pan with bread for dipping.', false, 4);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u31', 'local', 'Ikarian Greens & Herb Scramble', 'Main Courses', 'Ingredients:
- 2 tbsp extra-virgin olive oil
- 2 green onions, sliced
- 4 cups spinach and chard leaves, roughly chopped
- 4 eggs, beaten
- 2 tbsp fresh dill, chopped
- 1 tbsp fresh mint, chopped
- 2 tbsp crumbled feta

Instructions:
1. Warm the oil in a skillet and soften the green onions for 1 minute.
2. Add the greens with a pinch of salt and cook until just wilted.
3. Pour in the eggs and scramble gently over low heat until barely set.
4. Fold in the dill, mint, and feta, and serve straight away.', false, 5);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u40', 'local', 'Mango-Coconut Chia Pudding', 'Desserts', 'Ingredients:
- 1/4 cup chia seeds
- 3/4 cup soy milk
- 1/2 cup coconut milk
- 1 ripe mango, diced
- 2 tbsp toasted coconut flakes
- Squeeze of lime

Instructions:
1. Whisk the chia seeds with both milks and let stand 10 minutes; whisk again to break up clumps.
2. Refrigerate at least 3 hours or overnight, until thick and spoonable.
3. Top with the mango, a squeeze of lime, and the toasted coconut.', false, 6);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u47', 'local', 'Banana-Oat Blender Pancakes', 'Main Courses', 'Ingredients:
- 1 cup rolled oats
- 2 ripe bananas
- 2 eggs
- 1/2 tsp cinnamon
- Pinch of salt
- 1 tbsp olive oil, for the pan
- 1 cup blueberries
- Maple syrup, to serve

Instructions:
1. Blend the oats, bananas, eggs, cinnamon, and salt until smooth; rest 5 minutes to thicken.
2. Heat a little oil in a nonstick skillet over medium.
3. Pour small pancakes and cook about 2 minutes per side, flipping when bubbles form.
4. Serve stacked with blueberries and a light drizzle of maple syrup.', false, 7);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u55', 'local', 'Okinawan Breakfast Bowl with Natto', 'Main Courses', 'Ingredients:
- 1 cup cooked brown rice, warm
- 1 package natto
- 1 green onion, thinly sliced
- 1 tsp tamari
- 1 tsp sesame seeds
- 1 sheet nori, torn
- 2 tbsp kimchi (optional)

Instructions:
1. Stir the natto briskly with the tamari until it loosens and turns glossy.
2. Spoon the natto over the warm rice.
3. Top with green onion, sesame seeds, torn nori, and kimchi if you like.', false, 8);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u63', 'local', 'Mediterranean Chickpea Pita Pockets', 'Main Courses', 'Ingredients:
- 1 can (15 oz) chickpeas, drained and rinsed
- 1/2 cucumber, diced
- 1 tomato, diced
- 1/4 red onion, finely diced
- 1/4 cup parsley, chopped
- 2 tbsp lemon juice
- 2 tbsp extra-virgin olive oil
- 1/4 cup crumbled feta
- 2 whole-wheat pitas, halved

Instructions:
1. Lightly mash half the chickpeas with a fork, leaving the rest whole.
2. Toss with the cucumber, tomato, onion, parsley, lemon juice, and olive oil; season with salt and pepper.
3. Fold in the feta.
4. Pile into the pita halves and serve.', false, 9);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u73', 'local', 'Salade Niçoise', 'Salads', 'Ingredients:
- 2 eggs
- 8 oz small potatoes
- 4 oz green beans, trimmed
- 1 can (5 oz) tuna in olive oil, drained
- 1 cup cherry tomatoes, halved
- 1/3 cup olives
- 1 tbsp capers
- 2 cups romaine leaves
- 1 tsp Dijon mustard
- 1 tbsp red wine vinegar
- 3 tbsp extra-virgin olive oil

Instructions:
1. Boil the potatoes until tender, adding the green beans for the last 3 minutes; drain and cool.
2. Boil the eggs 8 minutes, cool in ice water, peel, and quarter.
3. Whisk the mustard, vinegar, and olive oil into a dressing; season well.
4. Arrange the romaine, potatoes, beans, tomatoes, tuna, eggs, olives, and capers on a platter.
5. Spoon the dressing over everything and serve.', false, 10);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u85', 'local', 'Tofu & Wakame Miso Bowl with Soba', 'Soups & Stews', 'Ingredients:
- 4 oz soba noodles
- 4 cups water
- 4 shiitake mushrooms, sliced
- 1 tsp grated ginger
- 2 tbsp dried wakame
- 6 oz soft tofu, cubed
- 3 tbsp miso paste
- 2 green onions, sliced

Instructions:
1. Cook the soba per the package, rinse under cool water, and divide between bowls.
2. Simmer the shiitake and ginger in the water for 5 minutes; add the wakame and tofu for 2 minutes more.
3. Remove from the heat and whisk the miso into a ladleful of broth, then stir it back in (do not boil).
4. Pour over the soba and finish with green onions.', false, 11);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u93', 'local', 'White Bean & Avocado Smash Toast', 'Snacks', 'Ingredients:
- 2 thick slices whole-grain bread
- 1 ripe avocado
- 1/2 cup cannellini beans, drained and rinsed
- 2 tsp lemon juice
- Pinch of cayenne
- Handful of arugula
- 1 tbsp extra-virgin olive oil

Instructions:
1. Toast the bread until golden.
2. Mash the avocado and beans together with the lemon juice, cayenne, and a pinch of salt.
3. Spread thickly on the toast.
4. Top with arugula, drizzle with olive oil, and finish with black pepper.', false, 12);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u101', 'local', 'Farro Bowl with Roasted Vegetables & Pesto', 'Main Courses', 'Ingredients:
- 1 cup farro
- 1 zucchini, cut into half-moons
- 1 bell pepper, cut into strips
- 1 cup cherry tomatoes
- 2 tbsp extra-virgin olive oil
- 3 tbsp pesto
- 2 cups arugula
- 2 tbsp pine nuts, toasted
- 1 tbsp balsamic vinegar

Instructions:
1. Heat the oven to 425°F. Simmer the farro in salted water until chewy-tender, about 25 minutes; drain.
2. Toss the zucchini, pepper, and tomatoes with the oil and roast 20 minutes, until browned at the edges.
3. Stir the pesto through the warm farro.
4. Fold in the roasted vegetables and arugula, splash with balsamic, and top with pine nuts.', false, 13);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u111', 'local', 'Turkey & Hummus Crunch Pita', 'Main Courses', 'Ingredients:
- 2 whole-wheat pitas, halved
- 4 tbsp hummus
- 6 oz cooked turkey breast, sliced
- 1/2 cucumber, cut into ribbons
- 1 carrot, coarsely grated
- 2 romaine leaves, shredded
- A few thin slices red onion

Instructions:
1. Spread the inside of each pita half generously with hummus.
2. Layer in the turkey, cucumber, carrot, romaine, and onion.
3. Season with black pepper and serve.', false, 14);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u119', 'local', 'Sheet-Pan Salmon with Broccoli & Sweet Potato', 'Main Courses', 'Ingredients:
- 2 salmon fillets (6 oz each)
- 1 large sweet potato, cut into 3/4-inch cubes
- 1 head broccoli, cut into florets
- 3 tbsp extra-virgin olive oil
- 2 cloves garlic, minced
- 1 tsp smoked paprika
- 1 lemon, half juiced and half in wedges

Instructions:
1. Heat the oven to 425°F. Toss the sweet potato with half the oil and roast 15 minutes on a sheet pan.
2. Push to one side; add the broccoli tossed with the remaining oil, garlic, and paprika.
3. Nestle the salmon on the pan, season, and squeeze the lemon half over the fish.
4. Roast 12-14 minutes, until the salmon flakes easily.
5. Serve with lemon wedges.', false, 15);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u127', 'local', 'Chickpea & Spinach Coconut Curry', 'Main Courses', 'Ingredients:
- 1 tbsp coconut or olive oil
- 1 onion, diced
- 3 cloves garlic, minced
- 1 tbsp grated ginger
- 1 tsp turmeric
- 2 tsp garam masala
- 1 can (14 oz) diced tomatoes
- 1 can (14 oz) coconut milk
- 2 cans (15 oz each) chickpeas, drained
- 4 cups spinach
- Cooked brown rice and cilantro, to serve

Instructions:
1. Soften the onion in the oil, then stir in the garlic, ginger, turmeric, and garam masala for 1 minute.
2. Add the tomatoes, coconut milk, and chickpeas; simmer 15 minutes, until slightly thickened.
3. Stir in the spinach until wilted; season with salt.
4. Serve over brown rice, showered with cilantro.', false, 16);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u139', 'local', 'Lemon Chicken with Artichokes & Olives', 'Main Courses', 'Ingredients:
- 4 bone-in chicken thighs, skin removed
- 1 jar (12 oz) artichoke hearts, drained and halved
- 1/3 cup olives
- 1 lemon, sliced
- 4 cloves garlic, smashed
- 1 tbsp dried oregano
- 2 tbsp extra-virgin olive oil
- Handful of parsley, chopped

Instructions:
1. Heat the oven to 400°F. Season the chicken with salt, pepper, and oregano.
2. Brown the chicken in the oil in an ovenproof skillet, 4 minutes per side.
3. Scatter the artichokes, olives, garlic, and lemon slices around the chicken.
4. Roast 25 minutes, until the chicken is cooked through and the lemons are jammy.
5. Rest 5 minutes and shower with parsley.', false, 17);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u148', 'local', 'Whole-Wheat Pasta with Walnut-Lentil Bolognese', 'Main Courses', 'Ingredients:
- 2 tbsp extra-virgin olive oil
- 1 onion, 1 carrot, and 1 celery stalk, finely diced
- 3 cloves garlic, minced
- 2 tbsp tomato paste
- 1/2 cup red wine (optional)
- 1 can (28 oz) crushed tomatoes
- 1 cup cooked green or brown lentils
- 1/2 cup walnuts, finely chopped
- 12 oz whole-wheat pasta
- Grated Pecorino or Parmesan, to serve

Instructions:
1. Soften the onion, carrot, and celery in the oil, about 8 minutes.
2. Stir in the garlic and tomato paste for 1 minute; splash in the wine and let it bubble away.
3. Add the tomatoes, lentils, and walnuts; simmer 20 minutes, until rich and thick.
4. Cook the pasta until al dente, reserving a cup of pasta water.
5. Toss the pasta with the sauce, loosening with pasta water as needed, and top with cheese.', false, 18);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u161', 'local', 'Miso-Glazed Cod with Bok Choy & Black Rice', 'Main Courses', 'Ingredients:
- 2 cod fillets (6 oz each)
- 2 tbsp miso paste
- 1 tbsp honey
- 1 tbsp tamari
- 1 tsp grated ginger
- 2 heads baby bok choy, halved
- 1 tsp toasted sesame oil
- 1 cup cooked black rice
- 1 tsp sesame seeds

Instructions:
1. Whisk the miso, honey, tamari, and ginger; brush thickly over the cod.
2. Broil the cod 8-10 minutes, until lacquered and flaking.
3. Meanwhile, steam the bok choy 3 minutes and toss with the sesame oil.
4. Serve the cod over black rice with the bok choy, scattered with sesame seeds.', false, 19);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u171', 'local', 'Quinoa & Black Bean Stuffed Peppers', 'Main Courses', 'Ingredients:
- 4 bell peppers, halved and seeded
- 1 cup cooked quinoa
- 1 can (15 oz) black beans, drained
- 1/2 cup sweet corn
- 1 cup diced tomatoes
- 1 tsp ground cumin
- 1/4 cup crumbled queso fresco
- 1 avocado, sliced
- Cilantro, to serve

Instructions:
1. Heat the oven to 400°F. Arrange the pepper halves cut-side up in a baking dish.
2. Mix the quinoa, beans, corn, tomatoes, and cumin; season with salt and pepper.
3. Fill the peppers, cover with foil, and bake 25 minutes.
4. Uncover, top with queso fresco, and bake 10 minutes more.
5. Serve with avocado and cilantro.', false, 20);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u181', 'local', 'Muhammara', 'Appetizers', 'Ingredients:
- 2 roasted red bell peppers, peeled
- 1 cup walnuts, toasted
- 1 tbsp pomegranate molasses
- 1 tbsp lemon juice
- 1/2 tsp ground cumin
- 1/2 tsp smoked paprika
- 3 tbsp extra-virgin olive oil

Instructions:
1. Pulse the walnuts in a food processor until finely ground.
2. Add the peppers, pomegranate molasses, lemon juice, cumin, and paprika; blend to a coarse paste.
3. Stream in the olive oil and season with salt.
4. Serve with a drizzle of oil and warm pita or vegetables for dipping.', false, 21);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u189', 'local', 'White Bean & Rosemary Dip', 'Appetizers', 'Ingredients:
- 1 can (15 oz) cannellini beans, drained (reserve liquid)
- 1 small clove garlic
- 1 tsp fresh rosemary leaves, minced
- 1 tbsp lemon juice
- 3 tbsp extra-virgin olive oil

Instructions:
1. Blend the beans, garlic, rosemary, and lemon juice until smooth, thinning with bean liquid as needed.
2. Stream in the olive oil and season with salt and pepper.
3. Serve drizzled with oil and a few rosemary leaves.', false, 22);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u195', 'local', 'Chili-Sesame Edamame', 'Appetizers', 'Ingredients:
- 3 cups edamame in pods
- 1 tsp toasted sesame oil
- 1 tsp tamari
- 1/2 tsp gochugaru (Korean chili flakes)
- 1 tsp sesame seeds
- Flaky salt

Instructions:
1. Boil the edamame in well-salted water for 4 minutes; drain well.
2. Toss hot with the sesame oil, tamari, gochugaru, and sesame seeds.
3. Finish with flaky salt and eat straight from the pods.', false, 23);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u201', 'local', 'Smoked Trout & Labneh Endive Cups', 'Appetizers', 'Ingredients:
- 2 heads endive, leaves separated
- 4 oz smoked trout, flaked
- 1/2 cup labneh
- 1 tbsp fresh dill, chopped
- 1 tsp lemon juice
- 1 tbsp chives, snipped

Instructions:
1. Stir the labneh with the lemon juice, half the dill, and a pinch of salt.
2. Spoon a little labneh into each endive leaf.
3. Top with flaked trout, the remaining dill, and chives.
4. Grind over black pepper and serve cold.', false, 24);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u208', 'local', 'Grilled Halloumi with Watermelon & Mint', 'Appetizers', 'Ingredients:
- 8 oz halloumi, sliced 1/2 inch thick
- 2 cups watermelon, cut into chunks
- Handful of mint leaves, torn
- 1 tbsp extra-virgin olive oil
- 1 tsp balsamic vinegar

Instructions:
1. Sear the halloumi in a dry, hot skillet 1-2 minutes per side, until golden.
2. Arrange the watermelon on a platter and lay the warm halloumi over it.
3. Drizzle with the oil and balsamic, scatter with mint, and add black pepper.', false, 25);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u214', 'local', 'Sardine & Tomato Crostini', 'Appetizers', 'Ingredients:
- 1 can sardines in olive oil, drained
- 8 thin slices whole-grain baguette or bread, toasted
- 1 ripe tomato, halved
- 1 clove garlic, halved
- 1 tbsp parsley, chopped
- 1 tsp lemon juice
- Extra-virgin olive oil, to finish

Instructions:
1. Rub the hot toasts with the cut garlic, then with the cut tomato so the flesh catches on the bread.
2. Lay a piece of sardine on each toast.
3. Sprinkle with parsley, lemon juice, a thread of olive oil, and black pepper.', false, 26);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u222', 'local', 'Garlicky Horta-Style Greens', 'Side Dishes', 'Ingredients:
- 2 bunches mixed greens (kale, chard, dandelion), stemmed
- 3 tbsp extra-virgin olive oil
- 3 cloves garlic, sliced
- 2 tbsp lemon juice

Instructions:
1. Blanch the greens in salted boiling water 2-3 minutes; drain and press out the water.
2. Warm the oil with the garlic until fragrant and just golden.
3. Add the greens and toss to coat and heat through.
4. Season with salt, dress with the lemon juice, and serve warm or at room temperature.', false, 27);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u229', 'local', 'Za''atar Roasted Carrots with Labneh', 'Side Dishes', 'Ingredients:
- 1 lb carrots, halved lengthwise
- 2 tbsp extra-virgin olive oil
- 1 tbsp za''atar
- 1/2 cup labneh
- 2 tbsp pistachios, chopped
- Mint leaves and a drizzle of honey, to finish

Instructions:
1. Heat the oven to 425°F. Toss the carrots with the oil, za''atar, and salt.
2. Roast 25 minutes, until tender and caramelized at the edges.
3. Swoosh the labneh over a platter and pile the carrots on top.
4. Finish with pistachios, mint, and the lightest drizzle of honey.', false, 28);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u237', 'local', 'Turmeric-Ginger Roasted Cauliflower', 'Side Dishes', 'Ingredients:
- 1 head cauliflower, cut into florets
- 3 tbsp extra-virgin olive oil
- 1 tsp turmeric
- 1 tsp grated ginger
- 1 tsp ground cumin
- 2 tbsp cilantro, chopped
- 1 tbsp lemon juice

Instructions:
1. Heat the oven to 450°F. Whisk the oil with the turmeric, ginger, cumin, and salt.
2. Toss the cauliflower in the spiced oil and spread on a sheet pan.
3. Roast 20-25 minutes, until deeply browned in spots.
4. Squeeze over the lemon and shower with cilantro.', false, 29);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u245', 'local', 'Kimchi Fried Brown Rice', 'Side Dishes', 'Ingredients:
- 2 cups cooked brown rice, chilled
- 1 cup kimchi, chopped (plus 2 tbsp of its juice)
- 2 green onions, sliced
- 2 tsp toasted sesame oil
- 1 tsp tamari
- 1 tsp sesame seeds

Instructions:
1. Heat half the sesame oil in a hot skillet and fry the kimchi 2 minutes.
2. Add the rice, pressing it into the pan to crisp, 3-4 minutes.
3. Stir in the kimchi juice, tamari, and remaining sesame oil.
4. Top with green onions and sesame seeds.', false, 30);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u252', 'local', 'Tuscan Braised White Beans with Sage', 'Side Dishes', 'Ingredients:
- 2 cans (15 oz each) cannellini beans, drained
- 1 cup crushed tomatoes
- 3 cloves garlic, sliced
- 6 fresh sage leaves
- 3 tbsp extra-virgin olive oil

Instructions:
1. Warm the oil with the garlic and sage until fragrant and the garlic is pale gold.
2. Add the tomatoes and simmer 5 minutes.
3. Stir in the beans and simmer gently 10 minutes, until creamy.
4. Season with salt and pepper and finish with good olive oil.', false, 31);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u258', 'local', 'Lemon-Herb Quinoa Pilaf', 'Side Dishes', 'Ingredients:
- 1 cup quinoa, rinsed
- 1 3/4 cups water
- Zest and juice of 1 lemon
- 1/4 cup parsley, chopped
- 2 tbsp dill, chopped
- 2 green onions, sliced
- 2 tbsp extra-virgin olive oil
- 1/4 cup almonds, toasted and chopped

Instructions:
1. Simmer the quinoa in the water, covered, 15 minutes; rest 5 minutes and fluff.
2. Fold in the lemon zest and juice, herbs, green onions, and olive oil.
3. Season and top with the toasted almonds.', false, 32);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u266', 'local', 'Sardinian Longevity Minestrone', 'Soups & Stews', 'Ingredients:
- 3 tbsp extra-virgin olive oil
- 1 onion, 2 carrots, and 2 celery stalks, diced
- 1 fennel bulb, diced
- 3 cloves garlic, minced
- 1 can (14 oz) diced tomatoes
- 1 can borlotti beans and 1 can chickpeas, drained
- 1/2 cup farro
- 6 cups water or broth
- 2 cups kale, chopped
- Grated Pecorino, to serve

Instructions:
1. Soften the onion, carrot, celery, and fennel in the oil, about 10 minutes.
2. Add the garlic for 1 minute, then the tomatoes, beans, farro, and water.
3. Simmer 30 minutes, until the farro is tender.
4. Stir in the kale for the last 5 minutes; season well.
5. Serve with Pecorino and a thread of olive oil.', false, 33);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u279', 'local', 'Ikarian Black-Eyed Pea & Fennel Stew', 'Soups & Stews', 'Ingredients:
- 1/4 cup extra-virgin olive oil
- 1 onion, diced
- 1 fennel bulb, diced
- 3 cloves garlic, sliced
- 1 can (14 oz) diced tomatoes
- 2 cans black-eyed peas, drained (or 1 1/2 cups cooked)
- 2 bay leaves
- 4 cups water
- 2 cups chard, chopped
- 2 tbsp dill, chopped

Instructions:
1. Soften the onion and fennel in the oil, about 8 minutes.
2. Add the garlic, then the tomatoes, black-eyed peas, bay leaves, and water.
3. Simmer 25 minutes, until the broth tastes sweet and mellow.
4. Wilt in the chard, season, and finish with dill and a generous pour of olive oil.', false, 34);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u289', 'local', 'Turkish Red Lentil Soup', 'Soups & Stews', 'Ingredients:
- 2 tbsp extra-virgin olive oil
- 1 onion, diced
- 1 carrot, diced
- 2 tbsp tomato paste
- 1 tsp ground cumin
- 1 tsp smoked paprika
- 1 cup red lentils, rinsed
- 5 cups water
- 2 tbsp lemon juice
- Dried mint, to finish

Instructions:
1. Soften the onion and carrot in the oil, then stir in the tomato paste, cumin, and paprika for 1 minute.
2. Add the lentils and water; simmer 20 minutes, until the lentils fall apart.
3. Blend until smooth (or leave rustic) and season with salt.
4. Brighten with lemon juice and finish each bowl with mint and a drizzle of oil.', false, 35);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u299', 'local', 'Golden Turmeric Chicken & Rice Soup', 'Soups & Stews', 'Ingredients:
- 1 tbsp olive oil
- 1 onion, 2 carrots, and 2 celery stalks, diced
- 3 cloves garlic, minced
- 1 tbsp grated ginger
- 1 1/2 tsp turmeric
- 8 cups chicken bone broth
- 1 lb boneless chicken thighs
- 3/4 cup brown rice
- Juice of 1/2 lemon
- Parsley, to serve

Instructions:
1. Soften the vegetables in the oil; stir in the garlic, ginger, and turmeric for 1 minute.
2. Add the broth, chicken, and rice; simmer gently 30 minutes.
3. Lift out the chicken, shred it, and return it to the pot.
4. Season, brighten with lemon, and finish with parsley.', false, 36);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u310', 'local', 'Moroccan Chickpea & Squash Stew', 'Soups & Stews', 'Ingredients:
- 2 tbsp olive oil
- 1 onion, diced
- 3 cloves garlic, minced
- 1 tbsp harissa
- 1 tsp ground cumin
- 1/2 tsp cinnamon
- 1 small butternut squash, cubed
- 1 can (14 oz) diced tomatoes
- 2 cans chickpeas, drained
- 3 cups water
- 2 cups spinach
- Lemon juice and cilantro, to finish
- Whole-wheat couscous, to serve

Instructions:
1. Soften the onion in the oil; stir in the garlic, harissa, cumin, and cinnamon for 1 minute.
2. Add the squash, tomatoes, chickpeas, and water; simmer 25 minutes, until the squash is tender.
3. Wilt in the spinach and season with salt and lemon juice.
4. Serve over couscous, topped with cilantro.', false, 37);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u323', 'local', 'Provençal Fish Stew', 'Soups & Stews', 'Ingredients:
- 3 tbsp extra-virgin olive oil
- 1 leek and 1 fennel bulb, thinly sliced
- 4 cloves garlic, sliced
- 1 can (28 oz) crushed tomatoes
- 4 cups water or fish broth
- Pinch of saffron
- 1 strip orange zest
- 2 sprigs thyme
- 1 lb cod, cut into chunks
- 1/2 lb shrimp, peeled
- 1/2 lb mussels, scrubbed

Instructions:
1. Soften the leek and fennel in the oil, about 8 minutes; add the garlic for 1 minute.
2. Add the tomatoes, water, saffron, orange zest, and thyme; simmer 15 minutes.
3. Slide in the cod and mussels; after 4 minutes add the shrimp.
4. Cook until the mussels open and the fish flakes, about 4 minutes more.
5. Season and serve with a drizzle of olive oil.', false, 38);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u335', 'local', 'Greek Village Salad (Horiatiki)', 'Salads', 'Ingredients:
- 3 ripe tomatoes, cut into wedges
- 1 cucumber, thickly sliced
- 1/2 red onion, thinly sliced
- 1 green bell pepper, in rings
- 1/2 cup olives
- 4 oz feta, in one slab
- 1 tsp dried oregano
- 3 tbsp extra-virgin olive oil
- 1 tbsp red wine vinegar

Instructions:
1. Layer the tomatoes, cucumber, onion, pepper, and olives in a wide bowl; season with salt.
2. Lay the slab of feta on top and dust everything with oregano.
3. Pour over the oil and vinegar and serve with bread for the juices — no lettuce, no fuss.', false, 39);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u345', 'local', 'Tabbouleh', 'Salads', 'Ingredients:
- 1/4 cup fine bulgur
- 2 large bunches parsley, finely chopped
- 1/4 cup mint, finely chopped
- 2 ripe tomatoes, finely diced
- 2 green onions, thinly sliced
- 3 tbsp lemon juice
- 3 tbsp extra-virgin olive oil

Instructions:
1. Soak the bulgur in 1/4 cup hot water until tender, about 15 minutes.
2. Toss the parsley, mint, tomatoes, and green onions together.
3. Fold in the bulgur, lemon juice, and olive oil; season with salt.
4. Rest 10 minutes so the bulgur drinks the juices — this salad is mostly herbs, by design.', false, 40);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u353', 'local', 'Kale & Farro Salad with Pomegranate', 'Salads', 'Ingredients:
- 1 bunch kale, stemmed and thinly sliced
- 1 cup cooked farro, cooled
- Seeds of 1/2 pomegranate
- 2 oz goat cheese, crumbled
- 1/3 cup walnuts, toasted
- 1 tbsp balsamic vinegar
- 3 tbsp extra-virgin olive oil

Instructions:
1. Massage the kale with a pinch of salt and half the oil until it softens and darkens.
2. Toss with the farro, the remaining oil, and the balsamic.
3. Top with pomegranate seeds, walnuts, and goat cheese.', false, 41);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u361', 'local', 'Cucumber-Wakame Sunomono', 'Salads', 'Ingredients:
- 2 cucumbers, very thinly sliced
- 2 tbsp dried wakame
- 3 tbsp rice vinegar
- 1 tsp honey
- 1 tsp tamari
- 1/2 tsp grated ginger
- 1 tsp sesame seeds

Instructions:
1. Salt the cucumber slices lightly, rest 10 minutes, then squeeze out the water.
2. Soak the wakame in warm water 5 minutes; drain and squeeze.
3. Whisk the vinegar, honey, tamari, and ginger.
4. Toss the cucumber and wakame in the dressing and scatter with sesame seeds.', false, 42);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u369', 'local', 'Roasted Beet, Orange & Arugula Salad', 'Salads', 'Ingredients:
- 4 beets
- 2 oranges, peeled and sliced into rounds
- 3 cups arugula
- 2 oz feta, crumbled
- 3 tbsp pistachios, chopped
- 1 tbsp white wine vinegar
- 3 tbsp extra-virgin olive oil

Instructions:
1. Wrap the beets in foil and roast at 400°F until tender, about 1 hour; cool, peel, and cut into wedges.
2. Whisk the vinegar and oil with a pinch of salt.
3. Arrange the arugula, beets, and orange rounds on a platter.
4. Dress, then finish with feta and pistachios.', false, 43);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u377', 'local', 'Rainbow Slaw with Tahini-Lemon Dressing', 'Salads', 'Ingredients:
- 4 cups shredded cabbage (red and green)
- 2 carrots, coarsely grated
- 1 bell pepper, in thin strips
- 2 green onions, sliced
- 3 tbsp tahini
- 3 tbsp lemon juice
- 1 small clove garlic, grated
- 2-4 tbsp water, to thin
- 1 tsp sesame seeds

Instructions:
1. Whisk the tahini, lemon juice, garlic, and a pinch of salt, thinning with water to a pourable dressing.
2. Toss the cabbage, carrots, pepper, and green onions with the dressing.
3. Rest 10 minutes to soften slightly, then top with sesame seeds.', false, 44);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u386', 'local', 'Grilled Sardines with Lemon & Oregano', 'Main Courses', 'Ingredients:
- 8 fresh sardines, cleaned
- 2 tbsp extra-virgin olive oil, plus more to finish
- 1 tsp dried oregano
- 1 clove garlic, minced
- 1 lemon, half juiced and half in wedges
- 2 tbsp parsley, chopped

Instructions:
1. Pat the sardines dry and rub with the oil, oregano, garlic, and salt.
2. Grill or broil over high heat 2-3 minutes per side, until blistered and cooked through.
3. Dress with lemon juice, parsley, and a thread of olive oil; serve with the wedges.', false, 45);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u393', 'local', 'Turkey Polpette in Tomato-Basil Sauce', 'Main Courses', 'Ingredients:
- 1 lb ground turkey
- 1 slice whole-grain bread, soaked in water and squeezed
- 1 egg
- 2 tbsp grated Pecorino, plus more to serve
- 2 cloves garlic, minced (divided)
- 1/4 cup parsley, chopped
- 2 tbsp extra-virgin olive oil
- 1 tbsp tomato paste
- 1 can (28 oz) crushed tomatoes
- Handful of basil leaves

Instructions:
1. Mix the turkey, soaked bread, egg, cheese, half the garlic, parsley, and salt; roll into 16 small meatballs.
2. Brown the meatballs in the oil and set aside.
3. In the same pan, cook the remaining garlic and tomato paste 1 minute; add the tomatoes and simmer 10 minutes.
4. Return the meatballs and simmer gently 15 minutes, until cooked through.
5. Tear in the basil and serve with more Pecorino.', false, 46);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u404', 'local', 'Mushroom & Barley Orzotto', 'Main Courses', 'Ingredients:
- 3 tbsp extra-virgin olive oil
- 1 leek, thinly sliced
- 1 lb mixed mushrooms (cremini, shiitake), sliced
- 3 cloves garlic, minced
- 1 cup pearled barley
- 5 cups vegetable broth, warm
- 2 sprigs thyme
- 1/3 cup grated Pecorino or Parmesan

Instructions:
1. Brown the mushrooms in half the oil in batches; set aside.
2. Soften the leek in the remaining oil, add the garlic and barley, and stir 1 minute.
3. Add the broth and thyme; simmer 35-40 minutes, stirring now and then, until the barley is creamy but chewy.
4. Stir in the mushrooms and cheese, season, and rest 5 minutes before serving.', false, 47);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u414', 'local', 'Tempeh & Broccoli Stir-Fry', 'Main Courses', 'Ingredients:
- 8 oz tempeh, cut into strips
- 1 head broccoli, cut into florets
- 2 tbsp avocado or olive oil
- 1 tbsp grated ginger
- 3 cloves garlic, minced
- 3 tbsp tamari
- 1 tbsp rice vinegar
- 1 tsp toasted sesame oil
- Cooked brown rice, to serve
- Green onions and sesame seeds, to finish

Instructions:
1. Sear the tempeh in half the oil until golden on both sides; set aside.
2. Stir-fry the broccoli in the remaining oil 3 minutes; add a splash of water and cover 2 minutes.
3. Add the ginger and garlic, then return the tempeh with the tamari, vinegar, and sesame oil.
4. Toss to glaze and serve over brown rice with green onions and sesame seeds.', false, 48);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u425', 'local', 'Baked Rockfish Veracruz', 'Main Courses', 'Ingredients:
- 4 rockfish fillets (5 oz each)
- 2 tbsp extra-virgin olive oil
- 1 onion, sliced
- 3 cloves garlic, sliced
- 3 cups diced tomatoes
- 1/3 cup olives, sliced
- 1 tbsp capers
- 1 jalapeño, sliced
- 1 tsp Mexican oregano
- 1 lime, half juiced and half in wedges
- Cilantro, to serve

Instructions:
1. Heat the oven to 400°F. Soften the onion and garlic in the oil.
2. Add the tomatoes, olives, capers, jalapeño, and oregano; simmer 10 minutes.
3. Season the fish, nestle it into the sauce, and spoon some over the top.
4. Bake 12-15 minutes, until the fish flakes.
5. Finish with lime juice and cilantro; serve with the wedges.', false, 49);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u437', 'local', 'Chicken Souvlaki with Tzatziki', 'Main Courses', 'Ingredients:
- 1 lb chicken breast, cut into chunks
- 3 tbsp extra-virgin olive oil
- 3 tbsp lemon juice
- 2 tsp dried oregano
- 3 cloves garlic, minced
- 4 whole-wheat pitas, warmed
- 1 tomato, sliced, and 1/4 red onion, thinly sliced
- Tzatziki (see Sauces & Condiments), to serve

Instructions:
1. Marinate the chicken in the oil, lemon juice, oregano, garlic, salt, and pepper for 30 minutes.
2. Thread onto skewers and grill over high heat, turning, 10-12 minutes, until charred and cooked through.
3. Serve in the warm pitas with tomato, onion, and a generous spoonful of tzatziki.', false, 50);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u448', 'local', 'Smoky Spiced Roasted Chickpeas', 'Snacks', 'Ingredients:
- 1 can (15 oz) chickpeas, drained and patted very dry
- 1 tbsp extra-virgin olive oil
- 1 tsp smoked paprika
- 1/2 tsp ground cumin
- Pinch of cayenne
- Salt

Instructions:
1. Heat the oven to 425°F. Toss the chickpeas with the oil and spread on a sheet pan.
2. Roast 25-30 minutes, shaking once, until deeply golden and crisp.
3. Toss immediately with the paprika, cumin, cayenne, and salt.
4. Cool 5 minutes — they crisp further as they sit.', false, 51);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u454', 'local', 'Date-Walnut Energy Balls', 'Snacks', 'Ingredients:
- 1 cup pitted dates
- 3/4 cup walnuts
- 1/2 cup rolled oats
- 2 tbsp almond butter
- 2 tbsp cacao nibs
- 1/2 tsp cinnamon
- Pinch of salt

Instructions:
1. Pulse the dates and walnuts in a food processor until finely chopped.
2. Add the oats, almond butter, cacao nibs, cinnamon, and salt; pulse until the mixture holds together when pinched.
3. Roll into 12 balls and chill 30 minutes.
4. Keep refrigerated for up to a week.', false, 52);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u461', 'local', 'Turmeric-Maple Spiced Nuts', 'Snacks', 'Ingredients:
- 1 cup almonds
- 1 cup cashews
- 1/2 cup pumpkin seeds
- 2 tbsp maple syrup
- 1 tsp turmeric
- 1/2 tsp cinnamon
- Pinch of cayenne
- 1/2 tsp salt

Instructions:
1. Heat the oven to 325°F. Toss everything together until evenly coated.
2. Spread on a lined sheet pan and roast 15-18 minutes, stirring once, until fragrant and glazed.
3. Cool completely on the pan — they crisp as they cool — then break apart.', false, 53);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u469', 'local', 'Frozen Yogurt Bark with Berries & Pistachios', 'Snacks', 'Ingredients:
- 2 cups plain Greek yogurt
- 2 tbsp honey
- 1 cup mixed berries
- 3 tbsp pistachios, chopped

Instructions:
1. Stir the yogurt with the honey and spread 1/2 inch thick on a lined sheet pan.
2. Press in the berries and scatter with pistachios.
3. Freeze until solid, about 3 hours, then snap into shards.
4. Keep frozen; eat within 2 weeks.', false, 54);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u474', 'local', 'Guacamole with Jicama Dippers', 'Snacks', 'Ingredients:
- 2 ripe avocados
- Juice of 1 lime
- 2 tbsp red onion, finely diced
- 1/2 jalapeño, minced
- 2 tbsp cilantro, chopped
- 1/2 jicama, cut into sticks
- 1 carrot and 1/2 cucumber, cut into sticks

Instructions:
1. Mash the avocados coarsely with the lime juice and a good pinch of salt.
2. Fold in the onion, jalapeño, and cilantro.
3. Serve with the jicama, carrot, and cucumber sticks for scooping.', false, 55);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u483', 'local', 'Sesame Brown Rice Onigiri', 'Snacks', 'Ingredients:
- 2 cups cooked short-grain brown rice, warm
- 2 tbsp pickled vegetables, finely chopped
- 1 tbsp sesame seeds
- 1 tsp tamari
- 2 sheets nori, cut into strips

Instructions:
1. Season the warm rice with the tamari and fold in the pickles and sesame seeds.
2. With wet, lightly salted hands, press the rice into 6 firm triangles.
3. Wrap each with a strip of nori.
4. Eat at room temperature — ideal for lunchboxes and hikes.', false, 56);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u489', 'local', 'Baked Apples with Walnuts & Dates', 'Desserts', 'Ingredients:
- 4 apples, cored but left whole
- 1/3 cup walnuts, chopped
- 4 dates, pitted and chopped
- 2 tbsp rolled oats
- 1 tsp cinnamon
- 1 tbsp honey
- 1/2 cup water

Instructions:
1. Heat the oven to 375°F. Mix the walnuts, dates, oats, cinnamon, and honey.
2. Stand the apples in a baking dish and pack the filling into their centers.
3. Pour the water around them and bake 35-40 minutes, until tender.
4. Serve warm, spooning the pan juices over the top.', false, 57);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u496', 'local', 'Fresh Figs with Ricotta, Honey & Pistachios', 'Desserts', 'Ingredients:
- 8 ripe figs, halved
- 3/4 cup ricotta
- 1 tbsp honey
- 2 tbsp pistachios, chopped

Instructions:
1. Spoon the ricotta onto a platter and arrange the fig halves over it.
2. Drizzle with the honey.
3. Scatter with pistachios and a tiny pinch of flaky salt.', false, 58);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u501', 'local', 'Avocado-Cacao Mousse', 'Desserts', 'Ingredients:
- 2 ripe avocados
- 1/3 cup cacao powder
- 1/4 cup maple syrup
- 1/2 tsp vanilla extract
- 1/4 cup soy milk, plus more to loosen
- Pinch of salt
- Berries, to serve

Instructions:
1. Blend the avocados, cacao, maple syrup, vanilla, soy milk, and salt until completely silky, scraping down as needed.
2. Chill 30 minutes to set.
3. Serve in small cups, topped with berries.', false, 59);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u508', 'local', 'Red Wine-Poached Pears with Star Anise', 'Desserts', 'Ingredients:
- 4 firm pears, peeled with stems left on
- 2 cups red wine
- 2 tbsp honey
- 1 cinnamon stick
- 2 star anise
- 2 strips orange zest

Instructions:
1. Bring the wine, honey, cinnamon, star anise, and orange zest to a simmer in a snug pot.
2. Add the pears and simmer gently 20-25 minutes, turning now and then, until tender.
3. Lift out the pears and boil the liquid down to a light syrup.
4. Serve the pears warm or chilled, glossed with syrup.', false, 60);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u515', 'local', 'Roasted Peaches with Yogurt & Honeyed Almonds', 'Desserts', 'Ingredients:
- 4 ripe peaches, halved and pitted
- 1 tbsp honey, plus more to serve
- 1/4 tsp cinnamon
- 1 cup plain Greek yogurt
- 1/4 cup almonds, toasted and chopped

Instructions:
1. Heat the oven to 425°F. Set the peaches cut-side up, drizzle with honey, and dust with cinnamon.
2. Roast 15-18 minutes, until soft and caramelized at the edges.
3. Serve warm over yogurt, scattered with almonds and a final thread of honey.', false, 61);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u521', 'local', 'Black Rice Pudding with Coconut & Mango', 'Desserts', 'Ingredients:
- 3/4 cup black rice
- 2 1/2 cups water
- 1 can (14 oz) coconut milk (reserve 2 tbsp)
- 2 tbsp date syrup
- Pinch of salt
- 1 mango, sliced
- 2 tbsp toasted coconut flakes

Instructions:
1. Simmer the rice in the water, covered, 35 minutes, until nearly tender.
2. Stir in the coconut milk, date syrup, and salt; simmer 10 minutes more, until creamy.
3. Serve warm or chilled, topped with mango, the reserved coconut milk, and toasted coconut.', false, 62);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u527', 'local', 'Golden Turmeric Latte', 'Beverages', 'Ingredients:
- 2 cups soy milk
- 1 tsp turmeric
- 1/2 tsp grated ginger
- 1/4 tsp cinnamon
- Grind of black pepper
- 1 tsp honey

Instructions:
1. Warm the soy milk with the turmeric, ginger, cinnamon, and pepper, whisking, until steaming.
2. Sweeten with honey.
3. Blend or whisk hard until frothy and pour into mugs — the pepper helps the turmeric absorb.', false, 63);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u534', 'local', 'Whisked Matcha', 'Beverages', 'Ingredients:
- 1 tsp matcha
- 2 oz hot water (170°F, not boiling)
- 6 oz more hot water or steamed milk

Instructions:
1. Sift the matcha into a bowl to break up clumps.
2. Add the 2 oz of water and whisk briskly in a zigzag until smooth and foamy.
3. Top up with hot water for straight matcha, or steamed milk for a latte.', false, 64);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u536', 'local', 'Hibiscus-Ginger Cooler', 'Beverages', 'Ingredients:
- 1/3 cup dried hibiscus flowers
- 4 cups water
- 1-inch piece ginger, sliced
- 2 tbsp honey
- 1 lime, juiced
- Ice, to serve

Instructions:
1. Simmer the hibiscus and ginger in the water for 10 minutes.
2. Strain, stir in the honey, and cool.
3. Add the lime juice and pour over ice — tart, floral, and deep red.', false, 65);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u541', 'local', 'Berry-Kefir Smoothie with Flax', 'Beverages', 'Ingredients:
- 1 1/2 cups kefir
- 1 cup mixed berries (fresh or frozen)
- 1/2 banana
- 1 tbsp ground flaxseed
- 1 tsp honey (optional)

Instructions:
1. Blend the kefir, berries, banana, and flaxseed until smooth.
2. Taste and sweeten with honey only if the berries need it.
3. Pour and drink cold.', false, 66);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u547', 'local', 'Moroccan Mint Green Tea', 'Beverages', 'Ingredients:
- 1 tbsp green tea leaves
- 1 large handful fresh mint sprigs
- 4 cups hot water (175°F)
- 2 tsp honey
- Lemon slices, to serve

Instructions:
1. Rinse the tea leaves with a splash of the hot water and discard the rinse.
2. Steep the tea and mint in the hot water for 3 minutes.
3. Sweeten lightly with honey and serve with lemon, pouring from a height for froth if you like.', false, 67);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u552', 'local', 'Mango-Cardamom Lassi', 'Beverages', 'Ingredients:
- 1 cup plain Greek yogurt
- 1 ripe mango, chopped (or 1 cup frozen)
- 1/2 cup cold water
- 1/4 tsp ground cardamom
- 1 tsp honey

Instructions:
1. Blend the yogurt, mango, water, cardamom, and honey until smooth and frothy.
2. Thin with more water to your liking.
3. Serve cold, dusted with a little extra cardamom.', false, 68);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u557', 'local', 'Classic Basil Pesto', 'Sauces & Condiments', 'Ingredients:
- 2 cups basil leaves, packed
- 1/4 cup pine nuts, lightly toasted
- 1 clove garlic
- 1/3 cup grated Pecorino or Parmesan
- 1/2 cup extra-virgin olive oil
- 1 tsp lemon juice

Instructions:
1. Pulse the basil, pine nuts, and garlic to a coarse paste.
2. Add the cheese, then stream in the oil while pulsing to a loose, flecked sauce.
3. Brighten with lemon juice and season with salt.
4. Keep covered with a film of oil in the fridge for up to a week.', false, 69);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u564', 'local', 'Chimichurri', 'Sauces & Condiments', 'Ingredients:
- 1 cup parsley, finely chopped
- 1 tbsp fresh oregano, chopped (or 1 tsp dried)
- 2 cloves garlic, minced
- 1 small red chili, minced
- 2 tbsp red wine vinegar
- 1/2 cup extra-virgin olive oil
- 1/2 tsp salt

Instructions:
1. Stir everything together in a bowl — chopped, not blended, is the point.
2. Rest 15 minutes so the flavors marry.
3. Spoon over grilled fish, chicken, beans, or roasted vegetables.', false, 70);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u571', 'local', 'Romesco', 'Sauces & Condiments', 'Ingredients:
- 2 roasted red bell peppers, peeled
- 1/2 cup almonds, toasted
- 1 ripe tomato, halved and roasted or seared
- 1 clove garlic
- 1 tbsp sherry vinegar
- 1 tsp smoked paprika
- 1/3 cup extra-virgin olive oil

Instructions:
1. Blend the almonds and garlic until finely ground.
2. Add the peppers, tomato, vinegar, and paprika; blend to a nubby purée.
3. Stream in the oil and season with salt.
4. Serve with grilled vegetables, fish, or spooned over grain bowls.', false, 71);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u579', 'local', 'Miso-Tahini Dressing', 'Sauces & Condiments', 'Ingredients:
- 2 tbsp miso paste
- 3 tbsp tahini
- 2 tbsp rice vinegar
- 1 tsp grated ginger
- 1 tsp honey
- 1/2 tsp toasted sesame oil
- 3-5 tbsp warm water

Instructions:
1. Whisk the miso, tahini, vinegar, ginger, honey, and sesame oil to a thick paste.
2. Thin with warm water, a spoonful at a time, to a pourable dressing.
3. Use on grain bowls, roasted vegetables, or sturdy greens; keeps a week refrigerated.', false, 72);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u586', 'local', 'Quick-Pickled Red Onions', 'Sauces & Condiments', 'Ingredients:
- 1 red onion, very thinly sliced
- 3/4 cup apple cider vinegar
- 3/4 cup water
- 1 tbsp honey
- 1 tsp salt
- 1 bay leaf
- A few black peppercorns

Instructions:
1. Pack the onion into a clean jar with the bay leaf and peppercorns.
2. Warm the vinegar, water, honey, and salt until dissolved; pour over the onions.
3. Cool, then refrigerate — bright pink and ready in an hour, better the next day.
4. Keeps 2-3 weeks refrigerated.', false, 73);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u592', 'local', 'Zhoug', 'Sauces & Condiments', 'Ingredients:
- 2 cups cilantro, packed
- 2 jalapeños, seeded for less heat
- 2 cloves garlic
- 1/2 tsp ground cardamom
- 1/2 tsp ground cumin
- 2 tbsp lemon juice
- 1/3 cup extra-virgin olive oil
- 1/2 tsp salt

Instructions:
1. Pulse the cilantro, jalapeños, and garlic until finely chopped.
2. Add the cardamom, cumin, lemon juice, and salt; pulse to combine.
3. Stream in the oil to a loose, spoonable salsa.
4. Brilliant with eggs, roasted vegetables, fish, and grain bowls.', false, 74);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u600', 'local', 'Instant Pot Lentil & Sweet Potato Curry', 'Main Courses', 'Ingredients:
- 1 cup red lentils, rinsed
- 1 large sweet potato, cubed
- 1 onion, diced
- 3 cloves garlic, minced
- 1 tbsp grated ginger
- 1 tsp turmeric
- 2 tsp garam masala
- 1 can (14 oz) diced tomatoes
- 1 can (14 oz) coconut milk
- 1 cup water
- 3 cups spinach
- Cooked brown rice and cilantro, to serve

Instructions:
1. On sauté, soften the onion; stir in the garlic, ginger, turmeric, and garam masala for 1 minute.
2. Add the lentils, sweet potato, tomatoes, and water. Seal and pressure-cook on high 8 minutes.
3. Quick-release, stir in the coconut milk and spinach until wilted, and season with salt.
4. Serve over brown rice, topped with cilantro.', false, 75);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u613', 'local', 'Instant Pot Chicken & White Bean Chili', 'Soups & Stews', 'Ingredients:
- 1 lb boneless chicken thighs
- 2 cans (15 oz each) cannellini beans, drained
- 1 cup sweet corn
- 1 onion, diced
- 3 cloves garlic, minced
- 2 tsp ground cumin
- 1 jalapeño, minced
- 1 tsp chopped chipotle in adobo
- 3 cups water or broth
- Lime wedges, cilantro, and Greek yogurt, to serve

Instructions:
1. On sauté, soften the onion; add the garlic, cumin, jalapeño, and chipotle for 1 minute.
2. Add the chicken, beans, and water. Seal and pressure-cook on high 10 minutes; natural-release 5 minutes.
3. Shred the chicken in the pot and stir in the corn to warm through.
4. Season, then serve with lime, cilantro, and a spoonful of yogurt.', false, 76);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u625', 'local', 'Instant Pot Mushroom Farro Risotto', 'Main Courses', 'Ingredients:
- 1 1/2 cups pearled farro
- 1 lb mixed mushrooms (cremini, shiitake), sliced
- 1 leek, thinly sliced
- 3 cloves garlic, minced
- 2 sprigs thyme
- 3 1/2 cups vegetable broth
- 2 tbsp extra-virgin olive oil
- 1/3 cup grated Pecorino or Parmesan

Instructions:
1. On sauté, brown the mushrooms in the oil; set a third aside for the top.
2. Add the leek, garlic, and thyme; stir 2 minutes, then add the farro and broth.
3. Seal and pressure-cook on high 10 minutes; quick-release.
4. Stir in the cheese until creamy, season, and top with the reserved mushrooms.', false, 77);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u635', 'local', 'Slow Cooker Tuscan White Bean Soup', 'Soups & Stews', 'Ingredients:
- 1 lb dried cannellini beans, soaked overnight
- 1 onion, 2 carrots, and 2 celery stalks, diced
- 4 cloves garlic, sliced
- 1 sprig rosemary and 2 bay leaves
- 1 can (14 oz) diced tomatoes
- 6 cups vegetable broth
- 3 cups kale, chopped
- Extra-virgin olive oil, to finish

Instructions:
1. Drain the soaked beans into the slow cooker with the vegetables, garlic, herbs, tomatoes, and broth.
2. Cook on low 7-8 hours, until the beans are completely tender.
3. Stir in the kale for the last 20 minutes and season well.
4. Ladle into bowls and finish each with a generous pour of olive oil.', false, 78);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u647', 'local', 'Slow Cooker Chicken Cacciatore', 'Main Courses', 'Ingredients:
- 6 bone-in chicken thighs, skin removed
- 1 can (28 oz) crushed tomatoes
- 1 bell pepper, sliced
- 8 oz mushrooms, quartered
- 1 onion, sliced
- 4 cloves garlic, sliced
- 1 tbsp dried oregano
- 1/2 cup red wine (optional)
- 1/3 cup olives
- Parsley, to serve

Instructions:
1. Season the chicken and set it into the slow cooker with the vegetables, garlic, and oregano.
2. Pour over the tomatoes and wine.
3. Cook on low 6 hours, until the chicken is falling from the bone.
4. Stir in the olives, season, and shower with parsley. Good over whole-wheat pasta or farro.', false, 79);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u658', 'local', 'Slow Cooker Steel-Cut Oats with Apples', 'Snacks', 'Ingredients:
- 1 cup steel-cut oats
- 2 apples, diced
- 4 dates, pitted and chopped
- 1 tsp cinnamon
- Pinch of salt
- 2 cups soy milk plus 2 cups water
- Walnuts and maple syrup, to serve

Instructions:
1. Stir the oats, apples, dates, cinnamon, salt, soy milk, and water together in the slow cooker.
2. Cook on low 7 hours (overnight), until thick and creamy.
3. Stir well, loosen with a splash of milk if needed.
4. Serve topped with walnuts and a thread of maple syrup.', false, 80);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u900', 'local', 'Walnut-Crusted Chicken Breast', 'Main Courses', 'Ingredients:
- 2 boneless, skinless chicken breasts
- 3/4 cup walnuts, finely chopped
- 1/2 cup whole-grain breadcrumbs (about 1 slice, toasted and crumbled)
- 2 tbsp Dijon mustard
- 1 tbsp honey
- 1 tbsp extra-virgin olive oil
- 1 tsp dried thyme
- 1/2 tsp garlic powder
- Lemon wedges, to serve

Instructions:
1. Heat the oven to 400°F / 200°C and line a baking sheet.
2. Toss the chopped walnuts with the breadcrumbs, thyme, garlic powder, and a pinch of salt and pepper.
3. Stir the mustard, honey, and olive oil together and brush over both sides of the chicken.
4. Press the walnut mixture onto the tops, transfer to the sheet, and bake 18-22 minutes, until cooked through and the crust is toasted.
5. Rest 5 minutes and serve with lemon wedges and a leafy salad.', false, 81);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u910', 'local', 'Mujadara (Lentils & Rice with Crispy Onions)', 'Main Courses', 'Ingredients:
- 1 cup brown lentils, rinsed
- 3/4 cup brown rice
- 3 large onions, thinly sliced
- 1/4 cup extra-virgin olive oil
- 1 1/2 tsp ground cumin
- 2 bay leaves
- Salt and black pepper
- Greek yogurt, to serve

Instructions:
1. Warm the oil in a wide pot and cook the onions with a pinch of salt over medium heat, stirring now and then, 25-30 minutes, until deeply browned and starting to crisp. Lift out half for the topping.
2. Stir the cumin into the onions left in the pot, then add the lentils, bay leaves, and 4 cups water. Simmer 10 minutes.
3. Add the rice, cover, and cook gently 25-30 minutes more, until the rice and lentils are tender and the water is absorbed.
4. Rest off the heat 10 minutes, discard the bay leaves, and season.
5. Serve topped with the reserved crispy onions and a spoonful of yogurt.', false, 82);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u920', 'local', 'Strawberry-Spinach Salad with Walnuts', 'Salads', 'Ingredients:
- 5 oz baby spinach
- 2 cups strawberries, hulled and sliced
- 1/2 cup walnuts, toasted
- 1/4 cup crumbled feta
- 1/4 small red onion, very thinly sliced
- 2 tbsp balsamic vinegar
- 3 tbsp extra-virgin olive oil
- 1 tsp honey
- Salt and black pepper

Instructions:
1. Whisk the vinegar, honey, a pinch of salt, and a few grinds of pepper; stream in the oil.
2. Toss the spinach, strawberries, and onion with most of the dressing.
3. Top with the walnuts and feta, drizzle with the rest, and serve at once.', false, 83);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u930', 'local', 'Blueberry-Walnut Oat Muffins', 'Snacks', 'Ingredients:
- 1 cup rolled oats
- 1 cup whole-wheat flour
- 2 tsp baking powder
- 1 tsp cinnamon
- 1/4 tsp salt
- 2 eggs
- 1/3 cup maple syrup
- 3/4 cup soy milk (or milk of choice)
- 1/4 cup extra-virgin olive oil
- 1 cup blueberries (fresh or frozen)
- 1/2 cup walnuts, chopped

Instructions:
1. Heat the oven to 375°F / 190°C and line a 10-cup muffin tin.
2. Stir the oats, flour, baking powder, cinnamon, and salt together.
3. Whisk the eggs, maple syrup, milk, and oil in a second bowl, then fold into the dry mix until just combined.
4. Fold in the blueberries and walnuts and divide among the cups.
5. Bake 20-24 minutes, until a toothpick comes out clean. Cool in the tin 10 minutes.', false, 84);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1043', 'local', 'Baked Cod with Jammy Cherry Tomatoes & Fennel', 'Main Courses', 'Ingredients:
- 1 pint cherry tomatoes, halved
- 1 small fennel bulb, thinly sliced
- 3 cloves garlic, thinly sliced
- 1 tbsp capers
- 5 tbsp extra-virgin olive oil, divided
- 1 tbsp red wine vinegar
- 1 tsp honey
- 4 cod fillets (about 1 1/4 lb)
- 4 thin lemon slices
- Fresh basil, to serve
- Salt and black pepper

Instructions:
1. Heat the oven to 400°F. Toss the tomatoes, fennel, garlic, and capers with 3 tbsp of the oil, the vinegar, honey, and a pinch of salt in a baking dish.
2. Roast 20-25 minutes, until the tomatoes collapse and turn jammy.
3. Brush the cod with the remaining oil and season with salt and pepper.
4. Nestle the fillets into the hot vegetables and top each with a lemon slice.
5. Bake 10-15 minutes more, until the fish flakes. Scatter with basil and spoon the pan juices over.', false, 85);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1054', 'local', 'One-Pot Rosemary Chicken with Quinoa, Mushrooms & Spinach', 'Main Courses', 'Ingredients:
- 6 boneless, skinless chicken thighs
- 3/4 tsp dried rosemary, crushed
- 1/2 tsp smoked paprika
- 2 tsp extra-virgin olive oil, divided
- 1/2 yellow onion, chopped
- 8 oz cremini mushrooms, sliced
- 3 cloves garlic, minced
- 1 cup quinoa
- 2 cups chicken broth
- 1 1/2 cups spinach, sliced
- Salt and black pepper

Instructions:
1. Rub the chicken with rosemary, paprika, salt, and pepper, then brown it in half the oil in a deep skillet; set aside.
2. Cook the onion and mushrooms in the remaining oil until their liquid cooks off, then stir in the garlic for a minute.
3. Add the quinoa and broth, scraping up the browned bits, and bring to a boil.
4. Return the chicken, cover, and simmer about 20 minutes, until the quinoa is fluffy and the chicken cooked through.
5. Stir the spinach through the hot quinoa until it wilts, season, and serve.', false, 86);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1065', 'local', 'Whole-Grain Penne with Sardines, Garlic & Kale', 'Main Courses', 'Ingredients:
- 8 oz whole-wheat pasta (penne)
- 8 kale leaves, stemmed and torn
- 1 1/2 tsp extra-virgin olive oil
- 4 cloves garlic, minced
- 1/4 tsp red pepper flakes
- 2 cans sardines in tomato sauce
- 4 tbsp grated Parmesan
- Salt and black pepper

Instructions:
1. Cook the penne in salted boiling water until al dente; drain.
2. Steam the kale in a shallow layer of water until just tender and drain it well.
3. Warm the oil in a large skillet, bloom the garlic and pepper flakes briefly, then toss in the kale.
4. Add the pasta and toss everything together over the heat, seasoning to taste.
5. Top each plate with sardines and their tomato sauce and a dusting of Parmesan.', false, 87);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1072', 'local', 'Strawberry-Spinach Salad with Toasted Walnuts', 'Salads', 'Ingredients:
- 5 oz baby spinach
- 8 oz strawberries, quartered, plus 1 cup for the dressing
- 2 oz walnuts, toasted and chopped
- 3 oz feta, crumbled
- 1/4 cup red wine vinegar
- 1 small shallot, chopped
- 1 tbsp honey
- 1/3 cup extra-virgin olive oil
- Salt and black pepper

Instructions:
1. Blend the vinegar, shallot, 1 cup of strawberries, and the honey until smooth.
2. Stream in the olive oil with the blender running until the dressing emulsifies; season it.
3. Toss the spinach with just enough dressing to coat the leaves.
4. Top with the quartered strawberries, walnuts, and feta, drizzle with a little more dressing, and serve at once.', false, 88);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1081', 'local', 'Blueberry-Banana Walnut Overnight Oats', 'Snacks', 'Ingredients:
- 1/2 cup frozen blueberries
- 1/2 banana
- 1/3 cup Greek yogurt
- 1/3 cup soy milk
- 1/4 cup walnuts, chopped, divided
- 1 tsp honey
- 1/8 tsp vanilla extract
- 1/3 cup oats
- 1 tbsp chia seeds

Instructions:
1. Blend the blueberries, banana, yogurt, milk, most of the walnuts, the honey, and vanilla until smooth.
2. Stir the mixture into the oats and chia seeds until evenly combined.
3. Spoon into a jar and scatter the remaining walnuts on top.
4. Refrigerate at least 4 hours or overnight, and eat it cold.', false, 89);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1091', 'local', 'Crispy Olive Oil Roasted Chickpeas', 'Snacks', 'Ingredients:
- 1 1/2 cups cooked chickpeas, drained
- Extra-virgin olive oil, for drizzling
- Sea salt
- Paprika, smoked or sweet, to taste

Instructions:
1. Heat the oven to 425°F and line a baking sheet with parchment.
2. Pat the chickpeas completely dry on a kitchen towel, discarding loose skins — damp chickpeas never crisp.
3. Spread them on the sheet, drizzle with oil, sprinkle with salt, and roast 20-30 minutes until golden and crunchy.
4. Toss with paprika while still warm and eat within two days.', false, 90);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1096', 'local', 'Blueberry-Kale Smoothie with Walnuts', 'Beverages', 'Ingredients:
- 1 cup frozen blueberries
- 1 large handful kale, stemmed
- 1/2 banana
- 2 tbsp walnuts
- 1 tbsp ground flaxseed
- 1 cup soy milk
- 1 tsp honey, optional

Instructions:
1. Put everything in a blender, kale at the bottom so it pulls down first.
2. Blend on high until completely smooth, about a minute.
3. Thin with a splash more milk if you like, taste for sweetness, and pour.', false, 91);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1104', 'local', 'Walnut-Lentil Stuffed Portobellos', 'Main Courses', 'Ingredients:
- 4 portobello mushrooms, stemmed
- 1 cup cooked green lentils
- 1/2 cup walnuts, finely chopped
- 1 small yellow onion, diced
- 2 cloves garlic, minced
- 2 tbsp extra-virgin olive oil, divided
- 1 tsp thyme
- 2 tbsp tomato paste
- 2 slices whole-grain bread, blitzed to crumbs
- Salt and black pepper

Instructions:
1. Heat the oven to 400°F. Brush the portobellos with half the oil and roast, gill side up, 10 minutes.
2. Soften the onion in the remaining oil, then stir in the garlic, thyme, and tomato paste for a minute.
3. Fold in the lentils, walnuts, and half the crumbs; season well.
4. Mound the filling into the caps, top with the remaining crumbs, and bake 15 minutes until browned.', false, 92);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1114', 'local', 'Lemon-Blueberry Overnight Oats', 'Snacks', 'Ingredients:
- 1 3/4 cups blueberries
- 1 tbsp grated lemon zest
- 2 1/4 cups oats
- 1 cup Greek yogurt
- 2 cups almond milk
- 2 1/2 tbsp maple syrup
- 1 tbsp lemon juice

Instructions:
1. Toss the blueberries with the lemon zest, lightly crushing a few.
2. Stir the oats, yogurt, almond milk, maple syrup, and lemon juice together.
3. Layer the oat mixture and berries in jars, finishing with berries.
4. Refrigerate overnight and eat cold, stirred once.', false, 93);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1122', 'local', 'Herby Lemon-Crusted Baked Cod', 'Main Courses', 'Ingredients:
- 2 thick cod fillets (5 oz each)
- 2 slices whole-grain bread, blitzed to crumbs and toasted
- 1 small clove garlic, crushed
- 1 tsp grated lemon zest
- 1 tsp dried oregano
- 2 tsp lemon juice
- 2 tsp extra-virgin olive oil
- Black pepper

Instructions:
1. Heat the oven to 425°F and lightly oil a shallow baking dish.
2. Moisten the crumbs with the garlic, lemon zest, oregano, lemon juice, oil, and plenty of pepper.
3. Pack the crumb mixture over the cod fillets in the dish.
4. Bake 12-15 minutes until the crust is golden and the fish flakes; season at the table with lemon, not salt.', false, 94);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1131', 'local', 'Grilled Lemon-Garlic Chicken with Charred Okra', 'Main Courses', 'Ingredients:
- 1 1/2 lb chicken breast, thinly sliced
- 1/2 cup lemon juice (from 3-4 lemons)
- 6 cloves garlic, minced
- 2 tbsp fresh rosemary, minced
- 2 tbsp extra-virgin olive oil, divided
- 3 lb okra
- Salt and black pepper

Instructions:
1. Whisk the lemon juice, garlic, rosemary, and half the oil; marinate the chicken in it, refrigerated, 2-12 hours.
2. Heat a grill to high. Drain the chicken, pat dry, and season lightly.
3. Grill the chicken 7-10 minutes until cooked through and no longer pink.
4. Toss the okra with the remaining oil and grill alongside until blistered and tender, then serve together.', false, 95);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1138', 'local', 'Quinoa & Black Bean Stuffed Bell Peppers', 'Main Courses', 'Ingredients:
- 1/2 cup quinoa
- 4 bell peppers, halved and cored
- 2 cloves garlic, minced
- 1 can (15 oz) no-salt-added diced tomatoes
- 1 can (15 oz) no-salt-added black beans, rinsed
- 1 cup sweet corn kernels
- 2 tsp ground cumin
- 1 tsp onion powder
- 1 tsp paprika
- 1 cup shredded mozzarella

Instructions:
1. Simmer the quinoa in 3/4 cup water, covered, about 15 minutes; fluff.
2. Heat the oven to 375°F and set the pepper halves cut side up in a baking dish.
3. Stir the garlic, tomatoes, beans, corn, cumin, onion powder, and paprika into the quinoa and warm through.
4. Fill the peppers, top with mozzarella, and bake uncovered 30-35 minutes until tender and browned.', false, 96);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1149', 'local', 'Thai Red Curry with Rainbow Vegetables & Brown Rice', 'Main Courses', 'Ingredients:
- 1 1/4 cups brown rice, rinsed
- 1 tbsp extra-virgin olive oil
- 1 small white onion, chopped
- 1 tbsp fresh ginger, grated
- 2 cloves garlic, minced
- 1 red bell pepper, sliced thin
- 1 yellow bell pepper, sliced thin
- 3 carrots, sliced on the diagonal
- 2 tbsp red curry paste
- 1 can (14 oz) coconut milk
- 1 1/2 cups kale, thinly sliced
- 1 tbsp tamari
- 2 tsp rice vinegar
- Fresh basil or cilantro, to serve

Instructions:
1. Boil the rice in plenty of water about 30 minutes, drain, and let it steam off the heat, covered.
2. Soften the onion in the oil, then stir in the ginger and garlic for 30 seconds.
3. Add the bell peppers and carrots for a few minutes, then the curry paste for two more.
4. Pour in the coconut milk and 1/2 cup water, add the kale, and simmer gently until the vegetables are tender.
5. Season off the heat with tamari and vinegar, and serve over the rice with fresh herbs.', false, 97);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1164', 'local', 'Pantry Three-Bean Chili with Yogurt', 'Soups & Stews', 'Ingredients:
- 1 can (28 oz) no-salt-added diced tomatoes, undrained
- 1 can (15 oz) no-salt-added kidney beans, rinsed
- 1 can (15 oz) no-salt-added pinto beans, rinsed
- 1 can (15 oz) no-salt-added chickpeas, rinsed
- 1 1/2 cups vegetable broth
- 2 tbsp chili powder
- 2 tsp ground cumin
- 1/2 cup plain yogurt, to top
- Fresh cilantro, to top

Instructions:
1. Combine the tomatoes with their juice, all three beans, the broth, chili powder, and cumin in a large saucepan.
2. Bring to a boil, then simmer 10-15 minutes until it thickens to your liking.
3. Ladle into bowls and top each with a spoonful of yogurt and a scatter of cilantro.', false, 98);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1174', 'local', 'Cucumber-Dill Tzatziki', 'Sauces & Condiments', 'Ingredients:
- 1 cucumber, peeled and grated
- 1 1/2 cups Greek yogurt
- 2 tbsp fresh dill, chopped
- 2 cloves garlic, minced
- 2 tbsp extra-virgin olive oil
- 1 tbsp lemon juice

Instructions:
1. Squeeze the grated cucumber in a sieve or towel until it stops dripping.
2. Stir it with the yogurt, dill, garlic, oil, and lemon juice until creamy.
3. Rest a few minutes so the flavors knit, then serve chilled with vegetables or warm pita.', false, 99);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1181', 'local', 'White Bean, Cucumber & Tomato Salad with Dill', 'Salads', 'Ingredients:
- 1 can (15 oz) no-salt-added white beans, rinsed
- 1 cucumber, diced
- 2 tomatoes, diced
- 1/4 red onion, thinly sliced
- 2 tbsp fresh dill, chopped
- 2 tbsp extra-virgin olive oil
- 1 tbsp lemon juice
- Black pepper

Instructions:
1. Toss the beans, cucumber, tomatoes, and onion together in a bowl.
2. Whisk the oil and lemon juice, pour over, and fold in the dill.
3. Season with plenty of black pepper and let it sit ten minutes before serving.', false, 100);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1190', 'local', 'Walnut-Rosemary Crusted Salmon', 'Main Courses', 'Ingredients:
- 1 lb skinless salmon fillet
- 2 tsp Dijon mustard
- 1 clove garlic, minced
- 1 tsp lemon juice, plus zest
- 1 tsp fresh rosemary, chopped
- 1/2 tsp honey
- 1 slice whole-grain bread, blitzed to crumbs
- 3 tbsp walnuts, finely chopped
- 1 tsp extra-virgin olive oil
- Salt and black pepper

Instructions:
1. Heat the oven to 425°F and line a rimmed baking sheet.
2. Stir the mustard, garlic, lemon juice and zest, rosemary, honey, and a pinch of salt together.
3. Toss the crumbs and walnuts with the oil.
4. Brush the mustard mixture over the salmon, press the walnut crumbs on top, and bake 8-12 minutes until the fish flakes.', false, 101);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1200', 'local', 'Quick Chickpea Chana Masala', 'Main Courses', 'Ingredients:
- 2 tbsp extra-virgin olive oil
- 1 yellow onion, chopped
- 1 jalapeno, minced
- 5 cloves garlic, minced
- 1 tbsp fresh ginger, minced
- 1 1/2 tsp garam masala
- 1 1/2 tsp ground coriander
- 3/4 tsp ground cumin
- 1/2 tsp turmeric
- 1 can (28 oz) crushed tomatoes
- 2 cans (15 oz each) chickpeas, rinsed
- Brown rice, to serve
- Lemon wedges and cilantro, to serve

Instructions:
1. Soften the onion and jalapeno in the oil with a pinch of salt, about 5 minutes.
2. Stir in the garlic and ginger until fragrant, then toast the garam masala, coriander, cumin, and turmeric for a minute.
3. Add the tomatoes and chickpeas, bring to a simmer, and bubble gently at least 10 minutes.
4. Serve over brown rice with lemon and cilantro.', false, 102);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1214', 'local', 'Ginger Tofu Stir-Fry with Cauliflower Rice', 'Main Courses', 'Ingredients:
- 1 block extra-firm tofu, pressed and cubed
- 4 tsp sesame oil, divided
- 2 tbsp peanut butter
- 3 tbsp tamari, divided
- 1 tbsp maple syrup
- 1 tbsp lime juice
- 1 tsp chili sauce, or to taste
- 1 cup shiitake mushrooms, chopped
- 1 cup cabbage, thinly sliced
- 1 red bell pepper, thinly sliced
- 2 cloves garlic, minced
- 1 tbsp fresh ginger, minced
- 2 green onions, sliced
- 3 cups riced cauliflower

Instructions:
1. Toss the tofu with a third of the tamari and let it sit while you whisk the peanut butter, remaining tamari, maple syrup, lime juice, and chili sauce into a sauce.
2. Brown the tofu in half the sesame oil in a hot skillet; set aside.
3. Stir-fry the shiitakes, cabbage, and bell pepper in the rest of the oil with the garlic, ginger, and green onions until crisp-tender.
4. Add the cauliflower rice for a few minutes, return the tofu, pour in the sauce, and toss until hot.', false, 103);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1229', 'local', 'Turmeric Quinoa & Black Bean Burgers', 'Main Courses', 'Ingredients:
- 1 can (15 oz) black beans, rinsed
- 1/4 cup quinoa
- 1/2 cup vegetable broth
- 1/4 cup bell pepper, chopped
- 2 slices whole-grain bread, blitzed to crumbs
- 2 tbsp onion, chopped
- 1 large clove garlic, minced
- 1 1/2 tsp ground cumin
- 1 1/2 tsp turmeric
- 1 egg, beaten

Instructions:
1. Simmer the quinoa in the broth until absorbed and tender.
2. Mash the beans, leaving some texture, and mix in the quinoa, bell pepper, crumbs, onion, garlic, cumin, turmeric, and egg.
3. Shape into 5 patties.
4. Cook in a hot nonstick skillet 3-4 minutes per side until browned and heated through; serve on greens or whole-grain buns.', false, 104);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1240', 'local', 'Lemony Lentil Soup with Wilted Greens', 'Soups & Stews', 'Ingredients:
- 1/4 cup extra-virgin olive oil
- 1 yellow onion, chopped
- 2 carrots, chopped
- 4 cloves garlic, minced
- 2 tsp ground cumin
- 1 tsp curry powder
- 1/2 tsp dried thyme
- 1 can (28 oz) diced tomatoes, drained
- 1 cup brown lentils, rinsed
- 4 cups vegetable broth
- 1 cup collard greens or kale, chopped
- 1-2 tbsp lemon juice
- Salt and black pepper

Instructions:
1. Soften the onion and carrots in the oil, then stir in the garlic, cumin, curry powder, and thyme until fragrant.
2. Add the tomatoes for a few minutes, then the lentils, broth, and 2 cups water; simmer 25-30 minutes until tender.
3. Blend about 2 cups of the soup and stir it back in for a creamy body.
4. Wilt the greens in for the last 5 minutes and finish with lemon juice, salt, and pepper.', false, 105);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1253', 'local', 'Massaged Kale Salad with Apple, Cherries & Pecans', 'Salads', 'Ingredients:
- 1/2 cup pecans, toasted and chopped
- 8 oz kale, stemmed and chopped
- 4 radishes, thinly sliced
- 1/2 cup dried tart cherries
- 1 apple, chopped
- 2 oz goat cheese, crumbled
- 3 tbsp extra-virgin olive oil
- 1 1/2 tbsp apple cider vinegar
- 1 tbsp Dijon mustard
- 1 1/2 tsp honey
- Salt and black pepper

Instructions:
1. Sprinkle the kale with a little salt and massage handfuls until the leaves darken and soften.
2. Add the radishes, cherries, apple, pecans, and goat cheese.
3. Whisk the oil, vinegar, mustard, and honey into a dressing and toss the salad with it.
4. Rest 10 minutes before serving so the flavors mingle.', false, 106);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1264', 'local', 'Strawberries-and-Cream Chia Pudding', 'Desserts', 'Ingredients:
- 1 can (14 oz) coconut milk
- 1 cup strawberries, chopped, plus more to top
- 1/2 tsp vanilla extract
- 1-3 tbsp maple syrup, to taste
- 1/3 cup chia seeds

Instructions:
1. Blend the coconut milk, strawberries, vanilla, and maple syrup until smooth.
2. Pulse in the chia seeds just enough to combine.
3. Refrigerate at least 4 hours or overnight, stirring once early on.
4. Serve topped with fresh berries.', false, 107);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1270', 'local', 'Golden Turmeric Milk', 'Beverages', 'Ingredients:
- 1 1/2 cups coconut milk
- 1 1/2 cups almond milk
- 1 1/2 tsp turmeric
- 1/4 tsp ground ginger
- 1 cinnamon stick
- 1 pinch black pepper
- Maple syrup, to taste

Instructions:
1. Whisk everything together in a small saucepan.
2. Warm over medium heat about 4 minutes — hot but never boiling.
3. Fish out the cinnamon stick, adjust sweetness, and pour into mugs.', false, 108);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1278', 'local', 'Greek Shrimp Baked in Tomato-Feta Sauce', 'Main Courses', 'Ingredients:
- 1 1/2 lb shrimp, peeled and deveined
- 1 1/2 tsp dried oregano, divided
- 1 1/2 tsp dried dill, divided
- 6 cloves garlic, minced, divided
- Extra-virgin olive oil
- 1 red onion, chopped
- 1 can (28 oz) diced tomatoes
- Juice of 1/2 lemon
- Handful fresh mint, chopped
- Handful fresh parsley, chopped
- 2 oz feta, crumbled
- 6 Kalamata olives, pitted

Instructions:
1. Toss the shrimp with half the oregano, dill, and garlic, a drizzle of oil, and a pinch of salt; set aside.
2. Soften the red onion with the remaining garlic in olive oil.
3. Add the tomatoes, lemon juice, and remaining herbs and simmer about 15 minutes to thicken.
4. Nestle in the shrimp and cook 5-7 minutes until pink and opaque.
5. Fold in the mint and parsley, scatter feta and olives over, and serve from the pan.', false, 109);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1291', 'local', 'Steamed Mussels in Tomato-Fennel Broth', 'Main Courses', 'Ingredients:
- 2 lb mussels, scrubbed and debearded
- 2 tbsp extra-virgin olive oil
- 1 fennel bulb, thinly sliced
- 4 cloves garlic, sliced
- 1 can (15 oz) white beans, rinsed
- 1 can (14 oz) diced tomatoes
- 1/2 cup vegetable broth
- Pinch of red pepper flakes
- Handful fresh parsley, chopped
- Whole-grain bread, to serve

Instructions:
1. Soften the fennel in the oil, then add the garlic and a pinch of pepper flakes for a minute.
2. Add the tomatoes, beans, and broth and simmer 5 minutes.
3. Tip in the mussels, cover, and steam 5-7 minutes until they open; discard any that stay shut.
4. Shower with parsley and serve straight from the pot with bread for the broth.', false, 110);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1301', 'local', 'One-Tray Greek Chicken with Potatoes, Olives & Feta', 'Main Courses', 'Ingredients:
- 8 chicken thighs, skin-on, bone-in
- 1 lb red potatoes, halved
- 8 cloves garlic, bashed, skin on
- 1 red onion, cut into wedges
- 1 yellow bell pepper, thick strips
- 2 tbsp extra-virgin olive oil
- 2 tbsp dried oregano
- 1 lemon, cut into 8 wedges
- 1 cup cherry tomatoes
- 20 black olives
- 3 oz feta, crumbled
- Salt and black pepper

Instructions:
1. Heat the oven to 400°F. Tumble the potatoes, garlic, onion, and bell pepper into a roasting tin and sit the chicken on top, skin up.
2. Season with oregano, salt, and pepper, drizzle with the oil, and squeeze the lemon wedges over, tucking them in.
3. Roast 30 minutes until the skin starts to brown.
4. Scatter the cherry tomatoes, olives, and feta around and roast 20 minutes more, until the chicken is cooked through.', false, 111);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1313', 'local', 'Spanakorizo — Greek Spinach & Rice', 'Main Courses', 'Ingredients:
- 1 lb spinach, rinsed
- Juice of 1/2 lemon
- 1 yellow onion, chopped
- 2 1/2 tbsp extra-virgin olive oil
- 1 tsp dried mint
- 2 tbsp fresh dill, chopped
- 1/3 cup brown rice
- 1 tbsp tomato paste
- Feta, to serve
- Salt and black pepper

Instructions:
1. Wilt the spinach with the lemon juice in a splash of the oil; set aside to drain.
2. Soften the onion in the remaining oil, then return the spinach with the mint, dill, tomato paste, and a cup of warm water.
3. Stir in the rice, season, cover, and simmer until tender, adding water if it dries out.
4. Serve warm with feta, more lemon, and a drizzle of oil.', false, 112);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1323', 'local', 'Fakes — Greek Brown Lentil Soup', 'Soups & Stews', 'Ingredients:
- 1 lb brown lentils, rinsed
- 1 small red onion, chopped
- 2 cloves garlic, chopped
- 2 bay leaves
- 1/2 cup extra-virgin olive oil
- 1 tbsp tomato paste
- 1 tbsp red wine vinegar
- Feta, to serve
- Salt and black pepper

Instructions:
1. Simmer the lentils in 5 cups water with the onion, garlic, and bay leaves, covered, about 25 minutes.
2. Stir in the oil, tomato paste, and vinegar; season with salt and pepper.
3. Simmer 15 minutes more until the soup thickens.
4. Serve with an extra splash of vinegar, a drizzle of oil, and crumbled feta.', false, 113);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1332', 'local', 'Lebanese Tabbouleh with Fine Bulgur', 'Salads', 'Ingredients:
- 1/4 cup fine bulgur
- 1/3 cup extra-virgin olive oil
- 3 tbsp lemon juice
- 3 bunches curly parsley, finely chopped
- 2 firm tomatoes, finely chopped
- 2 green onions, finely chopped
- 1/4 cup fresh mint, finely chopped
- Salt and black pepper

Instructions:
1. Whisk the oil, lemon juice, salt, and pepper in a large bowl and soak the dry bulgur in it 20-30 minutes.
2. Finely chop the parsley, tomatoes, green onions, and mint.
3. Pile the herbs and vegetables over the soaked bulgur.
4. Toss just before serving and adjust lemon and seasoning.', false, 114);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1340', 'local', 'Smoky Charred-Eggplant Baba Ganoush', 'Appetizers', 'Ingredients:
- 2 eggplants (about 2 lb)
- 3 tbsp tahini
- 2 tbsp extra-virgin olive oil
- 1 1/2 tbsp lemon juice
- 1 clove garlic, minced
- Fresh parsley, to garnish
- Salt

Instructions:
1. Char the whole eggplants over medium-high heat, turning, about 15 minutes until blackened and collapsed.
2. Steam them in a covered bowl 15 minutes, then scoop, drain, and chop the flesh.
3. Mash with the tahini, lemon juice, oil, garlic, and salt, keeping it slightly chunky.
4. Top with parsley and a drizzle of oil; serve with vegetables or warm bread.', false, 115);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1348', 'local', 'Greek Yogurt with Honey & Toasted Walnuts', 'Desserts', 'Ingredients:
- 7 oz Greek yogurt
- 4 tbsp walnuts, toasted
- 2 tbsp honey
- Pinch of cinnamon

Instructions:
1. Toast the walnuts in a dry pan until fragrant and let them cool.
2. Spoon the yogurt into a bowl and press hollows into the surface.
3. Scatter the walnuts over, drizzle the honey so it pools, and finish with cinnamon.', false, 116);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1353', 'local', 'Miso Broth with Tofu, Chard & Nori', 'Soups & Stews', 'Ingredients:
- 4 cups vegetable broth
- 1 sheet nori, cut into rectangles
- 3 tbsp miso paste
- 1/2 cup Swiss chard, chopped
- 2 green onions, chopped
- 1/4 cup firm tofu, cubed

Instructions:
1. Bring the broth to a gentle simmer.
2. Whisk the miso smooth with a splash of the hot broth.
3. Simmer the chard, green onions, and tofu about 5 minutes, then slide in the nori.
4. Off the heat, stir in the thinned miso — never boil it — and serve hot.', false, 117);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1360', 'local', 'Sheet-Pan Crispy Tofu & Brussels Sprouts Bowls', 'Main Courses', 'Ingredients:
- 1 1/4 cups brown rice
- 1 1/2 lb Brussels sprouts, halved
- 2 1/2 tbsp extra-virgin olive oil, divided
- 1 block (15 oz) extra-firm tofu, pressed and cubed
- 1/4 cup plus 1 tbsp tamari, divided
- 1 tbsp cornmeal
- 3 tbsp honey
- 2 tbsp rice vinegar
- 2 tsp sesame oil
- 1 tsp chili sauce, or to taste
- 2 tbsp sesame seeds
- Fresh cilantro, to serve

Instructions:
1. Boil the rice about 30 minutes, drain, and let it steam covered off the heat.
2. Toss the tofu with 1 tbsp tamari, 1 tbsp oil, and the cornmeal; toss the sprouts with the remaining oil.
3. Roast both on separate sheets at 400°F until the tofu is crisp-edged and the sprouts browned, tossing once.
4. Simmer the remaining tamari, honey, vinegar, sesame oil, and chili sauce until reduced by half.
5. Build bowls of rice, sprouts, and tofu; glaze generously and finish with sesame seeds and cilantro.', false, 118);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1373', 'local', 'Chilled Tofu & Avocado Salad with Ginger-Soy Dressing', 'Salads', 'Ingredients:
- 7 oz soft tofu, chilled
- 1 ripe avocado
- 2 cloves garlic, grated
- 1 tsp fresh ginger, grated
- 2 tbsp tamari
- 1 tsp sesame oil
- 1/2 tsp rice vinegar
- 1 green onion, finely chopped

Instructions:
1. Slice the chilled tofu and avocado thin and fan them, alternating, across a platter.
2. Stir the garlic, ginger, tamari, sesame oil, vinegar, and 2 tsp water together.
3. Spoon the dressing over, scatter the green onion, and serve right away, cool and fresh.', false, 119);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1382', 'local', 'Golden Tofu in Green Spinach Curry', 'Main Courses', 'Ingredients:
- 10 oz firm tofu, cut into triangles
- 2 tbsp extra-virgin olive oil
- 2 tsp coriander seeds
- 2 tsp cumin seeds
- 2 cardamom pods, seeds bashed
- 1 knob fresh ginger, chopped
- 1 yellow onion, finely chopped
- 2 cloves garlic, chopped
- 14 oz spinach
- Handful cilantro, plus more to serve
- Brown rice, to serve

Instructions:
1. Pan-fry the tofu triangles in a little of the oil until golden; set aside.
2. Toast the coriander, cumin, and cardamom in the remaining oil until they crackle.
3. Soften the ginger, onion, and garlic, then wilt in the spinach.
4. Blend the spinach mixture with the cilantro and a splash of water into a smooth green sauce.
5. Return the sauce and tofu to the pan, warm through, and serve over brown rice with cilantro.', false, 120);
insert into recipes (id, user_id, name, category, instructions, bookmarked, position) values ('u1394', 'local', 'Savory Turmeric Tofu Scramble', 'Main Courses', 'Ingredients:
- 1 tbsp extra-virgin olive oil
- 1 block (14 oz) firm tofu
- 2 tbsp nutritional yeast
- 1/2 tsp salt
- 1/4 tsp turmeric
- 1/4 tsp garlic powder
- 2 tbsp soy milk
- Avocado or whole-grain toast, to serve

Instructions:
1. Warm the oil in a skillet and crumble the tofu straight into it.
2. Cook a few minutes so the excess water steams off.
3. Sprinkle in the nutritional yeast, salt, turmeric, and garlic powder and cook 5 minutes more, leaving it undisturbed at the end for golden spots.
4. Stir in the soy milk to bring it together soft and serve with avocado or toast.', false, 121);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d279', 'd278', 'Whole-grain bread', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d280', 'd278', 'Cucumber', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d281', 'd278', 'Hummus', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d282', 'd278', 'Extra-virgin olive oil', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d283', 'd278', 'Feta', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d284', 'd278', 'Dill', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d285', 'd278', 'Lemon juice', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d286', 'd278', 'Black pepper', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d288', 'd287', 'Chickpeas', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d289', 'd287', 'Tahini', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d290', 'd287', 'Extra-virgin olive oil', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d291', 'd287', 'Lemon juice', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d292', 'd287', 'Garlic clove', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d293', 'd287', 'Cumin', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d295', 'd294', 'Yogurt, Greek', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d296', 'd294', 'Cucumber', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d297', 'd294', 'Garlic clove', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d298', 'd294', 'Extra-virgin olive oil', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d299', 'd294', 'Dill', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('d300', 'd294', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u11', 'u10', 'Oats', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u12', 'u10', 'Berries', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u13', 'u10', 'Walnuts', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u14', 'u10', 'Chia seeds', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u15', 'u10', 'Yogurt, Greek', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u16', 'u10', 'Soy milk', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u17', 'u10', 'Cinnamon', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u18', 'u10', 'Honey', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u102', 'u101', 'Farro', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u103', 'u101', 'Zucchini', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u104', 'u101', 'Bell pepper, red', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u105', 'u101', 'Tomato', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u106', 'u101', 'Pesto', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u107', 'u101', 'Arugula', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u108', 'u101', 'Pine nuts', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u109', 'u101', 'Balsamic vinegar', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u110', 'u101', 'Extra-virgin olive oil', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1044', 'u1043', 'Tomatoes, cherry', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1045', 'u1043', 'Fennel', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1046', 'u1043', 'Garlic clove', false, 3, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1047', 'u1043', 'Capers', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1048', 'u1043', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1049', 'u1043', 'Red wine vinegar', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1050', 'u1043', 'Honey', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1051', 'u1043', 'Cod', false, 4, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1052', 'u1043', 'Lemon', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1053', 'u1043', 'Basil', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1055', 'u1054', 'Chicken, thigh', false, 6, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1056', 'u1054', 'Rosemary', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1057', 'u1054', 'Paprika, smoked', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1058', 'u1054', 'Extra-virgin olive oil', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1059', 'u1054', 'Onion, yellow', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1060', 'u1054', 'Mushrooms, cremini', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1061', 'u1054', 'Garlic clove', false, 3, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1062', 'u1054', 'Quinoa', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1063', 'u1054', 'Chicken broth', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1064', 'u1054', 'Spinach', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1066', 'u1065', 'Whole-wheat pasta', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1067', 'u1065', 'Kale', false, 8, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1068', 'u1065', 'Extra-virgin olive oil', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1069', 'u1065', 'Garlic clove', false, 4, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1070', 'u1065', 'Sardines, canned', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1071', 'u1065', 'Pecorino / Parmesan', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1073', 'u1072', 'Spinach', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1074', 'u1072', 'Strawberries', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1075', 'u1072', 'Walnuts', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1076', 'u1072', 'Feta', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1077', 'u1072', 'Red wine vinegar', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1078', 'u1072', 'Shallots', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1079', 'u1072', 'Honey', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1080', 'u1072', 'Extra-virgin olive oil', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1082', 'u1081', 'Blueberries', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1083', 'u1081', 'Banana', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1084', 'u1081', 'Yogurt, Greek', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1085', 'u1081', 'Soy milk', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1086', 'u1081', 'Walnuts', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1087', 'u1081', 'Honey', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1088', 'u1081', 'Vanilla extract', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1089', 'u1081', 'Oats', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1090', 'u1081', 'Chia seeds', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1092', 'u1091', 'Chickpeas', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1093', 'u1091', 'Extra-virgin olive oil', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1094', 'u1091', 'Salt', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1095', 'u1091', 'Paprika, smoked', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1097', 'u1096', 'Blueberries', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1098', 'u1096', 'Kale', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1099', 'u1096', 'Banana', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1100', 'u1096', 'Walnuts', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1101', 'u1096', 'Flaxseed, ground', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1102', 'u1096', 'Soy milk', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1103', 'u1096', 'Honey', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1105', 'u1104', 'Mushroom, portobello', false, 4, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1106', 'u1104', 'Lentils, green', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1107', 'u1104', 'Walnuts', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1108', 'u1104', 'Onion, yellow', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1109', 'u1104', 'Garlic clove', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1110', 'u1104', 'Extra-virgin olive oil', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1111', 'u1104', 'Thyme', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1112', 'u1104', 'Tomato paste', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1113', 'u1104', 'Whole-grain bread', false, 2, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u112', 'u111', 'Whole-wheat pita', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u113', 'u111', 'Turkey, breast', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u114', 'u111', 'Hummus', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u115', 'u111', 'Cucumber', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u116', 'u111', 'Carrot', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u117', 'u111', 'Romaine', false, 2, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u118', 'u111', 'Onion, red', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1115', 'u1114', 'Blueberries', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1116', 'u1114', 'Lemon', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1117', 'u1114', 'Oats', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1118', 'u1114', 'Yogurt, Greek', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1119', 'u1114', 'Almond milk', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1120', 'u1114', 'Maple syrup', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1121', 'u1114', 'Lemon juice', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1123', 'u1122', 'Cod', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1124', 'u1122', 'Whole-grain bread', false, 2, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1125', 'u1122', 'Garlic clove', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1126', 'u1122', 'Lemon', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1127', 'u1122', 'Oregano', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1128', 'u1122', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1129', 'u1122', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1130', 'u1122', 'Black pepper', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1132', 'u1131', 'Chicken, breast', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1133', 'u1131', 'Lemon', false, 4, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1134', 'u1131', 'Garlic clove', false, 6, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1135', 'u1131', 'Rosemary', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1136', 'u1131', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1137', 'u1131', 'Okra', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1139', 'u1138', 'Quinoa', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1140', 'u1138', 'Bell pepper, red', false, 4, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1141', 'u1138', 'Garlic clove', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1142', 'u1138', 'Tomatoes, canned, diced', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1143', 'u1138', 'Black beans, canned', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1144', 'u1138', 'Sweet corn', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1145', 'u1138', 'Cumin', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1146', 'u1138', 'Onion powder', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1147', 'u1138', 'Paprika, smoked', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1148', 'u1138', 'Mozzarella', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1150', 'u1149', 'Rice, brown', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1151', 'u1149', 'Extra-virgin olive oil', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1152', 'u1149', 'Onion, white', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1153', 'u1149', 'Ginger, fresh', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1154', 'u1149', 'Garlic clove', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1155', 'u1149', 'Bell pepper, red', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1156', 'u1149', 'Bell pepper, yellow', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1157', 'u1149', 'Carrot', false, 3, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1158', 'u1149', 'Curry paste, red', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1159', 'u1149', 'Coconut milk', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1160', 'u1149', 'Kale', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1161', 'u1149', 'Tamari / soy sauce', false, 1, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1162', 'u1149', 'Rice vinegar', false, 1, 12);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1163', 'u1149', 'Cilantro', false, 1, 13);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1165', 'u1164', 'Tomatoes, canned, diced', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1166', 'u1164', 'Kidney beans, canned', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1167', 'u1164', 'Pinto beans, canned', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1168', 'u1164', 'Chickpeas, canned', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1169', 'u1164', 'Vegetable broth', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1170', 'u1164', 'Chili powder', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1171', 'u1164', 'Cumin', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1172', 'u1164', 'Yogurt, Greek', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1173', 'u1164', 'Cilantro', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1175', 'u1174', 'Cucumber', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1176', 'u1174', 'Yogurt, Greek', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1177', 'u1174', 'Dill', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1178', 'u1174', 'Garlic clove', false, 2, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1179', 'u1174', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1180', 'u1174', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1182', 'u1181', 'White beans, canned', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1183', 'u1181', 'Cucumber', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1184', 'u1181', 'Tomato', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1185', 'u1181', 'Onion, red', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1186', 'u1181', 'Dill', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1187', 'u1181', 'Extra-virgin olive oil', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1188', 'u1181', 'Lemon juice', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1189', 'u1181', 'Black pepper', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u120', 'u119', 'Salmon', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u121', 'u119', 'Broccoli', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u122', 'u119', 'Sweet potato', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u123', 'u119', 'Extra-virgin olive oil', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u124', 'u119', 'Garlic clove', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u125', 'u119', 'Paprika, smoked', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u126', 'u119', 'Lemon', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1191', 'u1190', 'Salmon', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1192', 'u1190', 'Mustard, Dijon', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1193', 'u1190', 'Garlic clove', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1194', 'u1190', 'Lemon juice', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1195', 'u1190', 'Rosemary', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1196', 'u1190', 'Honey', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1197', 'u1190', 'Whole-grain bread', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1198', 'u1190', 'Walnuts', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1199', 'u1190', 'Extra-virgin olive oil', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1201', 'u1200', 'Extra-virgin olive oil', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1202', 'u1200', 'Onion, yellow', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1203', 'u1200', 'Jalapeno', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1204', 'u1200', 'Garlic clove', false, 5, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1205', 'u1200', 'Ginger, fresh', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1206', 'u1200', 'Garam masala', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1207', 'u1200', 'Coriander', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1208', 'u1200', 'Cumin', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1209', 'u1200', 'Turmeric', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1210', 'u1200', 'Tomatoes, canned, crushed', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1211', 'u1200', 'Chickpeas, canned', false, 2, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1212', 'u1200', 'Rice, brown', false, 1, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1213', 'u1200', 'Cilantro', false, 1, 12);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1215', 'u1214', 'Tofu', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1216', 'u1214', 'Sesame oil', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1217', 'u1214', 'Peanut butter', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1218', 'u1214', 'Tamari / soy sauce', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1219', 'u1214', 'Maple syrup', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1220', 'u1214', 'Limes', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1221', 'u1214', 'Chili sauce', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1222', 'u1214', 'Mushrooms, shiitake', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1223', 'u1214', 'Cabbage', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1224', 'u1214', 'Bell pepper, red', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1225', 'u1214', 'Garlic clove', false, 2, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1226', 'u1214', 'Ginger, fresh', false, 1, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1227', 'u1214', 'Onions, green', false, 2, 12);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1228', 'u1214', 'Cauliflower', false, 1, 13);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1230', 'u1229', 'Black beans, canned', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1231', 'u1229', 'Quinoa', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1232', 'u1229', 'Vegetable broth', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1233', 'u1229', 'Bell pepper, green', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1234', 'u1229', 'Whole-grain bread', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1235', 'u1229', 'Onion, yellow', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1236', 'u1229', 'Garlic clove', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1237', 'u1229', 'Cumin', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1238', 'u1229', 'Turmeric', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1239', 'u1229', 'Eggs', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1241', 'u1240', 'Extra-virgin olive oil', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1242', 'u1240', 'Onion, yellow', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1243', 'u1240', 'Carrot', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1244', 'u1240', 'Garlic clove', false, 4, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1245', 'u1240', 'Cumin', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1246', 'u1240', 'Curry powder', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1247', 'u1240', 'Thyme', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1248', 'u1240', 'Tomatoes, canned, diced', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1249', 'u1240', 'Lentils, brown', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1250', 'u1240', 'Vegetable broth', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1251', 'u1240', 'Collard greens', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1252', 'u1240', 'Lemon juice', false, 1, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1254', 'u1253', 'Pecans', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1255', 'u1253', 'Kale', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1256', 'u1253', 'Radish', false, 4, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1257', 'u1253', 'Tart cherries', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1258', 'u1253', 'Apples', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1259', 'u1253', 'Cheese, goat', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1260', 'u1253', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1261', 'u1253', 'Apple cider vinegar', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1262', 'u1253', 'Mustard, Dijon', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1263', 'u1253', 'Honey', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1265', 'u1264', 'Coconut milk', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1266', 'u1264', 'Strawberries', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1267', 'u1264', 'Vanilla extract', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1268', 'u1264', 'Maple syrup', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1269', 'u1264', 'Chia seeds', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u128', 'u127', 'Chickpeas', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u129', 'u127', 'Spinach', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u130', 'u127', 'Tomato', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u131', 'u127', 'Onion, yellow', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u132', 'u127', 'Garlic clove', false, 3, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u133', 'u127', 'Ginger, fresh', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u134', 'u127', 'Turmeric', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u135', 'u127', 'Garam masala', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u136', 'u127', 'Coconut milk', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u137', 'u127', 'Rice, brown', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u138', 'u127', 'Cilantro', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1271', 'u1270', 'Coconut milk', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1272', 'u1270', 'Almond milk', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1273', 'u1270', 'Turmeric', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1274', 'u1270', 'Ginger, ground', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1275', 'u1270', 'Cinnamon', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1276', 'u1270', 'Black pepper', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1277', 'u1270', 'Maple syrup', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1279', 'u1278', 'Shrimp', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1280', 'u1278', 'Oregano', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1281', 'u1278', 'Dill', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1282', 'u1278', 'Garlic clove', false, 6, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1283', 'u1278', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1284', 'u1278', 'Onion, red', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1285', 'u1278', 'Tomatoes, canned, diced', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1286', 'u1278', 'Lemon juice', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1287', 'u1278', 'Mint', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1288', 'u1278', 'Parsley', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1289', 'u1278', 'Feta', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1290', 'u1278', 'Olives, Kalamata', false, 6, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1292', 'u1291', 'Mussels', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1293', 'u1291', 'Extra-virgin olive oil', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1294', 'u1291', 'Fennel', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1295', 'u1291', 'Garlic clove', false, 4, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1296', 'u1291', 'White beans, canned', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1297', 'u1291', 'Tomatoes, canned, diced', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1298', 'u1291', 'Vegetable broth', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1299', 'u1291', 'Parsley', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1300', 'u1291', 'Whole-grain bread', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1302', 'u1301', 'Chicken, thigh', false, 8, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1303', 'u1301', 'Potatoes, red', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1304', 'u1301', 'Garlic clove', false, 8, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1305', 'u1301', 'Onion, red', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1306', 'u1301', 'Bell pepper, yellow', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1307', 'u1301', 'Extra-virgin olive oil', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1308', 'u1301', 'Oregano', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1309', 'u1301', 'Lemon', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1310', 'u1301', 'Tomatoes, cherry', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1311', 'u1301', 'Olives, black', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1312', 'u1301', 'Feta', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1314', 'u1313', 'Spinach', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1315', 'u1313', 'Lemon juice', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1316', 'u1313', 'Onion, yellow', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1317', 'u1313', 'Extra-virgin olive oil', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1318', 'u1313', 'Mint', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1319', 'u1313', 'Dill', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1320', 'u1313', 'Rice, brown', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1321', 'u1313', 'Tomato paste', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1322', 'u1313', 'Feta', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1324', 'u1323', 'Lentils, brown', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1325', 'u1323', 'Onion, red', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1326', 'u1323', 'Garlic clove', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1327', 'u1323', 'Bay leaves', false, 2, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1328', 'u1323', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1329', 'u1323', 'Tomato paste', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1330', 'u1323', 'Red wine vinegar', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1331', 'u1323', 'Feta', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1333', 'u1332', 'Bulgur', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1334', 'u1332', 'Extra-virgin olive oil', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1335', 'u1332', 'Lemon juice', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1336', 'u1332', 'Parsley, curly', false, 3, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1337', 'u1332', 'Tomato', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1338', 'u1332', 'Onions, green', false, 2, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1339', 'u1332', 'Mint', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1341', 'u1340', 'Eggplant', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1342', 'u1340', 'Tahini', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1343', 'u1340', 'Extra-virgin olive oil', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1344', 'u1340', 'Lemon juice', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1345', 'u1340', 'Garlic clove', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1346', 'u1340', 'Parsley', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1347', 'u1340', 'Salt', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1349', 'u1348', 'Yogurt, Greek', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1350', 'u1348', 'Walnuts', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1351', 'u1348', 'Honey', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1352', 'u1348', 'Cinnamon', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1354', 'u1353', 'Vegetable broth', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1355', 'u1353', 'Nori', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1356', 'u1353', 'Miso', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1357', 'u1353', 'Swiss chard', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1358', 'u1353', 'Onions, green', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1359', 'u1353', 'Tofu', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1361', 'u1360', 'Rice, brown', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1362', 'u1360', 'Brussels sprouts', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1363', 'u1360', 'Extra-virgin olive oil', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1364', 'u1360', 'Tofu', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1365', 'u1360', 'Tamari / soy sauce', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1366', 'u1360', 'Cornmeal', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1367', 'u1360', 'Honey', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1368', 'u1360', 'Rice vinegar', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1369', 'u1360', 'Sesame oil', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1370', 'u1360', 'Chili sauce', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1371', 'u1360', 'Sesame seeds', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1372', 'u1360', 'Cilantro', false, 1, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1374', 'u1373', 'Tofu', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1375', 'u1373', 'Avocado', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1376', 'u1373', 'Garlic clove', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1377', 'u1373', 'Ginger, fresh', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1378', 'u1373', 'Tamari / soy sauce', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1379', 'u1373', 'Sesame oil', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1380', 'u1373', 'Rice vinegar', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1381', 'u1373', 'Onions, green', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1383', 'u1382', 'Tofu', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1384', 'u1382', 'Extra-virgin olive oil', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1385', 'u1382', 'Coriander', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1386', 'u1382', 'Cumin', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1387', 'u1382', 'Cardamom', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1388', 'u1382', 'Ginger, fresh', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1389', 'u1382', 'Onion, yellow', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1390', 'u1382', 'Garlic clove', false, 2, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1391', 'u1382', 'Spinach', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1392', 'u1382', 'Cilantro', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1393', 'u1382', 'Rice, brown', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u140', 'u139', 'Chicken, thigh', false, 4, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u141', 'u139', 'Artichoke', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u142', 'u139', 'Lemon', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u143', 'u139', 'Garlic clove', false, 4, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u144', 'u139', 'Oregano', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u145', 'u139', 'Extra-virgin olive oil', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u146', 'u139', 'Olives', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u147', 'u139', 'Parsley', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1395', 'u1394', 'Extra-virgin olive oil', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1396', 'u1394', 'Tofu', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1397', 'u1394', 'Nutritional yeast', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1398', 'u1394', 'Salt', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1399', 'u1394', 'Turmeric', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1400', 'u1394', 'Garlic powder', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1401', 'u1394', 'Soy milk', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u1402', 'u1394', 'Avocado', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u149', 'u148', 'Whole-wheat pasta', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u150', 'u148', 'Lentils', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u151', 'u148', 'Walnuts', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u152', 'u148', 'Tomato', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u153', 'u148', 'Tomato paste', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u154', 'u148', 'Carrot', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u155', 'u148', 'Celery', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u156', 'u148', 'Onion, yellow', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u157', 'u148', 'Garlic clove', false, 3, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u158', 'u148', 'Red wine · optional', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u159', 'u148', 'Pecorino / Parmesan', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u160', 'u148', 'Extra-virgin olive oil', false, 1, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u162', 'u161', 'Cod', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u163', 'u161', 'Miso', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u164', 'u161', 'Honey', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u165', 'u161', 'Tamari / soy sauce', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u166', 'u161', 'Bok choy', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u167', 'u161', 'Rice, black', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u168', 'u161', 'Ginger, fresh', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u169', 'u161', 'Sesame seeds', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u170', 'u161', 'Sesame oil', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u172', 'u171', 'Bell pepper, red', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u173', 'u171', 'Quinoa', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u174', 'u171', 'Black beans', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u175', 'u171', 'Sweet corn', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u176', 'u171', 'Tomato', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u177', 'u171', 'Cumin', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u178', 'u171', 'Cilantro', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u179', 'u171', 'Queso fresco', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u180', 'u171', 'Avocado', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u182', 'u181', 'Roasted red peppers', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u183', 'u181', 'Walnuts', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u184', 'u181', 'Pomegranate molasses', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u185', 'u181', 'Lemon juice', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u186', 'u181', 'Cumin', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u187', 'u181', 'Extra-virgin olive oil', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u188', 'u181', 'Paprika, smoked', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u190', 'u189', 'Cannellini beans', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u191', 'u189', 'Garlic clove', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u192', 'u189', 'Rosemary', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u193', 'u189', 'Lemon juice', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u194', 'u189', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u20', 'u19', 'Eggs', false, 4, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u21', 'u19', 'Tomato', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u22', 'u19', 'Bell pepper, red', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u23', 'u19', 'Onion, yellow', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u24', 'u19', 'Garlic clove', false, 3, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u25', 'u19', 'Paprika, smoked', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u26', 'u19', 'Cumin', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u27', 'u19', 'Extra-virgin olive oil', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u28', 'u19', 'Parsley', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u29', 'u19', 'Feta', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u30', 'u19', 'Whole-grain bread', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u196', 'u195', 'Edamame', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u197', 'u195', 'Gochugaru', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u198', 'u195', 'Sesame oil', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u199', 'u195', 'Sesame seeds', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u200', 'u195', 'Tamari / soy sauce', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u202', 'u201', 'Endive', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u203', 'u201', 'Trout', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u204', 'u201', 'Labneh', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u205', 'u201', 'Dill', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u206', 'u201', 'Lemon juice', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u207', 'u201', 'Chives', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u209', 'u208', 'Halloumi', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u210', 'u208', 'Watermelon', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u211', 'u208', 'Mint', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u212', 'u208', 'Extra-virgin olive oil', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u213', 'u208', 'Balsamic vinegar', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u215', 'u214', 'Sardines, canned', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u216', 'u214', 'Whole-grain bread', false, 8, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u217', 'u214', 'Tomato', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u218', 'u214', 'Garlic clove', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u219', 'u214', 'Parsley', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u220', 'u214', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u221', 'u214', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u223', 'u222', 'Kale', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u224', 'u222', 'Swiss chard', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u225', 'u222', 'Dandelion greens', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u226', 'u222', 'Garlic clove', false, 3, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u227', 'u222', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u228', 'u222', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u230', 'u229', 'Carrot', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u231', 'u229', 'Za''atar', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u232', 'u229', 'Labneh', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u233', 'u229', 'Extra-virgin olive oil', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u234', 'u229', 'Mint', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u235', 'u229', 'Pistachios', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u236', 'u229', 'Honey', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u238', 'u237', 'Cauliflower', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u239', 'u237', 'Turmeric', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u240', 'u237', 'Ginger, fresh', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u241', 'u237', 'Cumin', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u242', 'u237', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u243', 'u237', 'Cilantro', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u244', 'u237', 'Lemon juice', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u246', 'u245', 'Rice, brown', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u247', 'u245', 'Kimchi', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u248', 'u245', 'Onions, green', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u249', 'u245', 'Sesame seeds', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u250', 'u245', 'Sesame oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u251', 'u245', 'Tamari / soy sauce', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u253', 'u252', 'Cannellini beans', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u254', 'u252', 'Tomato', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u255', 'u252', 'Garlic clove', false, 3, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u256', 'u252', 'Sage', false, 6, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u257', 'u252', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u259', 'u258', 'Quinoa', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u260', 'u258', 'Lemon', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u261', 'u258', 'Parsley', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u262', 'u258', 'Dill', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u263', 'u258', 'Onions, green', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u264', 'u258', 'Extra-virgin olive oil', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u265', 'u258', 'Almonds', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u267', 'u266', 'Borlotti beans', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u268', 'u266', 'Chickpeas', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u269', 'u266', 'Fennel', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u270', 'u266', 'Carrot', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u271', 'u266', 'Celery', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u272', 'u266', 'Onion, yellow', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u273', 'u266', 'Tomato', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u274', 'u266', 'Kale', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u275', 'u266', 'Farro', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u276', 'u266', 'Extra-virgin olive oil', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u277', 'u266', 'Pecorino / Parmesan', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u278', 'u266', 'Garlic clove', false, 3, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u280', 'u279', 'Black-eyed peas', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u281', 'u279', 'Fennel', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u282', 'u279', 'Tomato', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u283', 'u279', 'Onion, yellow', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u284', 'u279', 'Garlic clove', false, 3, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u285', 'u279', 'Bay leaves', false, 2, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u286', 'u279', 'Swiss chard', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u287', 'u279', 'Dill', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u288', 'u279', 'Extra-virgin olive oil', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u290', 'u289', 'Lentils, red', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u291', 'u289', 'Carrot', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u292', 'u289', 'Onion, yellow', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u293', 'u289', 'Tomato paste', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u294', 'u289', 'Cumin', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u295', 'u289', 'Paprika, smoked', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u296', 'u289', 'Lemon juice', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u297', 'u289', 'Mint', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u298', 'u289', 'Extra-virgin olive oil', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u300', 'u299', 'Chicken, thigh', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u301', 'u299', 'Rice, brown', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u302', 'u299', 'Turmeric', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u303', 'u299', 'Ginger, fresh', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u304', 'u299', 'Garlic clove', false, 3, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u305', 'u299', 'Carrot', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u306', 'u299', 'Celery', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u307', 'u299', 'Lemon', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u308', 'u299', 'Parsley', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u309', 'u299', 'Bone broth', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u32', 'u31', 'Eggs', false, 4, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u33', 'u31', 'Spinach', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u34', 'u31', 'Swiss chard', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u35', 'u31', 'Onions, green', false, 2, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u36', 'u31', 'Dill', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u37', 'u31', 'Mint', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u38', 'u31', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u39', 'u31', 'Feta', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u311', 'u310', 'Chickpeas', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u312', 'u310', 'Harissa', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u313', 'u310', 'Tomato', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u314', 'u310', 'Butternut squash', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u315', 'u310', 'Onion, yellow', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u316', 'u310', 'Garlic clove', false, 3, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u317', 'u310', 'Cinnamon', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u318', 'u310', 'Cumin', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u319', 'u310', 'Spinach', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u320', 'u310', 'Lemon juice', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u321', 'u310', 'Cilantro', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u322', 'u310', 'Whole-wheat couscous', false, 1, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u324', 'u323', 'Cod', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u325', 'u323', 'Shrimp', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u326', 'u323', 'Mussels', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u327', 'u323', 'Fennel', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u328', 'u323', 'Tomato', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u329', 'u323', 'Leeks', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u330', 'u323', 'Garlic clove', false, 4, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u331', 'u323', 'Saffron', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u332', 'u323', 'Oranges', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u333', 'u323', 'Thyme', false, 2, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u334', 'u323', 'Extra-virgin olive oil', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u336', 'u335', 'Tomato', false, 3, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u337', 'u335', 'Cucumber', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u338', 'u335', 'Onion, red', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u339', 'u335', 'Bell pepper, green', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u340', 'u335', 'Olives', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u341', 'u335', 'Feta', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u342', 'u335', 'Oregano', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u343', 'u335', 'Extra-virgin olive oil', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u344', 'u335', 'Red wine vinegar', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u346', 'u345', 'Bulgur', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u347', 'u345', 'Parsley', false, 2, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u348', 'u345', 'Mint', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u349', 'u345', 'Tomato', false, 2, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u350', 'u345', 'Onions, green', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u351', 'u345', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u352', 'u345', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u354', 'u353', 'Kale', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u355', 'u353', 'Farro', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u356', 'u353', 'Pomegranate', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u357', 'u353', 'Cheese, goat', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u358', 'u353', 'Walnuts', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u359', 'u353', 'Balsamic vinegar', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u360', 'u353', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u362', 'u361', 'Cucumber', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u363', 'u361', 'Wakame', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u364', 'u361', 'Rice vinegar', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u365', 'u361', 'Sesame seeds', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u366', 'u361', 'Ginger, fresh', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u367', 'u361', 'Tamari / soy sauce', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u368', 'u361', 'Honey', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u370', 'u369', 'Beets', false, 4, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u371', 'u369', 'Oranges', false, 2, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u372', 'u369', 'Arugula', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u373', 'u369', 'Feta', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u374', 'u369', 'Pistachios', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u375', 'u369', 'White wine vinegar', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u376', 'u369', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u378', 'u377', 'Cabbage', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u379', 'u377', 'Carrot', false, 2, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u380', 'u377', 'Bell pepper, red', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u381', 'u377', 'Onions, green', false, 2, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u382', 'u377', 'Tahini', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u383', 'u377', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u384', 'u377', 'Garlic clove', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u385', 'u377', 'Sesame seeds', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u387', 'u386', 'Sardines', false, 8, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u388', 'u386', 'Lemon', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u389', 'u386', 'Oregano', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u390', 'u386', 'Extra-virgin olive oil', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u391', 'u386', 'Parsley', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u392', 'u386', 'Garlic clove', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u394', 'u393', 'Turkey, ground', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u395', 'u393', 'Whole-grain bread', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u396', 'u393', 'Eggs', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u397', 'u393', 'Garlic clove', false, 2, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u398', 'u393', 'Parsley', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u399', 'u393', 'Tomato', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u400', 'u393', 'Tomato paste', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u401', 'u393', 'Basil', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u402', 'u393', 'Extra-virgin olive oil', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u403', 'u393', 'Pecorino / Parmesan', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u41', 'u40', 'Chia seeds', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u42', 'u40', 'Soy milk', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u43', 'u40', 'Coconut milk', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u44', 'u40', 'Mango', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u45', 'u40', 'Coconut, shredded', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u46', 'u40', 'Limes', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u405', 'u404', 'Barley', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u406', 'u404', 'Mushrooms, cremini', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u407', 'u404', 'Shiitake', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u408', 'u404', 'Leeks', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u409', 'u404', 'Garlic clove', false, 3, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u410', 'u404', 'Thyme', false, 2, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u411', 'u404', 'Pecorino / Parmesan', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u412', 'u404', 'Extra-virgin olive oil', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u413', 'u404', 'Vegetable broth', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u415', 'u414', 'Tempeh', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u416', 'u414', 'Broccoli', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u417', 'u414', 'Ginger, fresh', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u418', 'u414', 'Garlic clove', false, 3, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u419', 'u414', 'Tamari / soy sauce', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u420', 'u414', 'Rice vinegar', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u421', 'u414', 'Sesame oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u422', 'u414', 'Rice, brown', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u423', 'u414', 'Onions, green', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u424', 'u414', 'Sesame seeds', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u426', 'u425', 'Rockfish', false, 4, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u427', 'u425', 'Tomato', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u428', 'u425', 'Olives', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u429', 'u425', 'Capers', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u430', 'u425', 'Jalapeno', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u431', 'u425', 'Onion, yellow', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u432', 'u425', 'Garlic clove', false, 3, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u433', 'u425', 'Mexican oregano', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u434', 'u425', 'Limes', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u435', 'u425', 'Cilantro', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u436', 'u425', 'Extra-virgin olive oil', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u438', 'u437', 'Chicken, breast', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u439', 'u437', 'Lemon juice', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u440', 'u437', 'Oregano', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u441', 'u437', 'Garlic clove', false, 3, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u442', 'u437', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u443', 'u437', 'Whole-wheat pita', false, 4, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u444', 'u437', 'Onion, red', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u445', 'u437', 'Tomato', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u446', 'u437', 'Yogurt, Greek', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u447', 'u437', 'Cucumber', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u449', 'u448', 'Chickpeas', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u450', 'u448', 'Paprika, smoked', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u451', 'u448', 'Cumin', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u452', 'u448', 'Cayenne', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u453', 'u448', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u455', 'u454', 'Dates', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u456', 'u454', 'Walnuts', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u457', 'u454', 'Oats', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u458', 'u454', 'Cacao nibs', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u459', 'u454', 'Cinnamon', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u460', 'u454', 'Almond butter', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u462', 'u461', 'Almonds', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u463', 'u461', 'Cashews', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u464', 'u461', 'Pumpkin seeds', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u465', 'u461', 'Turmeric', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u466', 'u461', 'Cinnamon', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u467', 'u461', 'Cayenne', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u468', 'u461', 'Maple syrup', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u470', 'u469', 'Yogurt, Greek', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u471', 'u469', 'Berries', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u472', 'u469', 'Pistachios', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u473', 'u469', 'Honey', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u48', 'u47', 'Oats', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u49', 'u47', 'Banana', false, 2, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u50', 'u47', 'Eggs', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u51', 'u47', 'Cinnamon', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u52', 'u47', 'Blueberries', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u53', 'u47', 'Maple syrup', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u54', 'u47', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u475', 'u474', 'Avocado', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u476', 'u474', 'Limes', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u477', 'u474', 'Cilantro', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u478', 'u474', 'Onion, red', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u479', 'u474', 'Jalapeno', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u480', 'u474', 'Jicama', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u481', 'u474', 'Carrot', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u482', 'u474', 'Cucumber', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u484', 'u483', 'Rice, brown', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u485', 'u483', 'Nori', false, 2, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u486', 'u483', 'Sesame seeds', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u487', 'u483', 'Pickled vegetables', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u488', 'u483', 'Tamari / soy sauce', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u490', 'u489', 'Apples', false, 4, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u491', 'u489', 'Walnuts', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u492', 'u489', 'Dates', false, 4, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u493', 'u489', 'Cinnamon', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u494', 'u489', 'Honey', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u495', 'u489', 'Oats', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u497', 'u496', 'Figs', false, 8, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u498', 'u496', 'Ricotta', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u499', 'u496', 'Honey', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u500', 'u496', 'Pistachios', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u502', 'u501', 'Avocado', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u503', 'u501', 'Cacao powder', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u504', 'u501', 'Maple syrup', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u505', 'u501', 'Vanilla extract', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u506', 'u501', 'Soy milk', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u507', 'u501', 'Berries', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u509', 'u508', 'Pears', false, 4, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u510', 'u508', 'Red wine · optional', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u511', 'u508', 'Cinnamon', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u512', 'u508', 'Star anise', false, 2, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u513', 'u508', 'Honey', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u514', 'u508', 'Oranges', false, 2, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u516', 'u515', 'Peaches', false, 4, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u517', 'u515', 'Yogurt, Greek', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u518', 'u515', 'Honey', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u519', 'u515', 'Almonds', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u520', 'u515', 'Cinnamon', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u522', 'u521', 'Rice, black', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u523', 'u521', 'Coconut milk', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u524', 'u521', 'Mango', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u525', 'u521', 'Coconut, shredded', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u526', 'u521', 'Date syrup', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u528', 'u527', 'Turmeric', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u529', 'u527', 'Ginger, fresh', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u530', 'u527', 'Cinnamon', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u531', 'u527', 'Black pepper', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u532', 'u527', 'Soy milk', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u533', 'u527', 'Honey', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u535', 'u534', 'Matcha', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u537', 'u536', 'Hibiscus', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u538', 'u536', 'Ginger, fresh', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u539', 'u536', 'Limes', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u540', 'u536', 'Honey', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u542', 'u541', 'Kefir', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u543', 'u541', 'Berries', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u544', 'u541', 'Banana', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u545', 'u541', 'Flaxseed, ground', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u546', 'u541', 'Honey', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u548', 'u547', 'Green tea', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u549', 'u547', 'Mint', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u550', 'u547', 'Lemon', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u551', 'u547', 'Honey', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u56', 'u55', 'Rice, brown', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u57', 'u55', 'Natto', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u58', 'u55', 'Onions, green', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u59', 'u55', 'Sesame seeds', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u60', 'u55', 'Nori', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u61', 'u55', 'Tamari / soy sauce', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u62', 'u55', 'Kimchi', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u553', 'u552', 'Yogurt, Greek', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u554', 'u552', 'Mango', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u555', 'u552', 'Cardamom', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u556', 'u552', 'Honey', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u558', 'u557', 'Basil', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u559', 'u557', 'Pine nuts', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u560', 'u557', 'Garlic clove', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u561', 'u557', 'Pecorino / Parmesan', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u562', 'u557', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u563', 'u557', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u565', 'u564', 'Parsley', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u566', 'u564', 'Oregano', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u567', 'u564', 'Garlic clove', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u568', 'u564', 'Red wine vinegar', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u569', 'u564', 'Extra-virgin olive oil', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u570', 'u564', 'Chili peppers', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u572', 'u571', 'Roasted red peppers', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u573', 'u571', 'Almonds', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u574', 'u571', 'Tomato', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u575', 'u571', 'Garlic clove', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u576', 'u571', 'Sherry vinegar', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u577', 'u571', 'Paprika, smoked', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u578', 'u571', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u580', 'u579', 'Miso', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u581', 'u579', 'Tahini', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u582', 'u579', 'Rice vinegar', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u583', 'u579', 'Ginger, fresh', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u584', 'u579', 'Honey', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u585', 'u579', 'Sesame oil', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u587', 'u586', 'Onion, red', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u588', 'u586', 'Apple cider vinegar', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u589', 'u586', 'Honey', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u590', 'u586', 'Black pepper', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u591', 'u586', 'Bay leaves', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u593', 'u592', 'Cilantro', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u594', 'u592', 'Jalapeno', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u595', 'u592', 'Garlic clove', false, 2, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u596', 'u592', 'Cardamom', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u597', 'u592', 'Cumin', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u598', 'u592', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u599', 'u592', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u601', 'u600', 'Lentils, red', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u602', 'u600', 'Sweet potato', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u603', 'u600', 'Coconut milk', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u604', 'u600', 'Tomato', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u605', 'u600', 'Onion, yellow', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u606', 'u600', 'Garlic clove', false, 3, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u607', 'u600', 'Ginger, fresh', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u608', 'u600', 'Turmeric', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u609', 'u600', 'Garam masala', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u610', 'u600', 'Spinach', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u611', 'u600', 'Rice, brown', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u612', 'u600', 'Cilantro', false, 1, 11);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u614', 'u613', 'Chicken, thigh', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u615', 'u613', 'Cannellini beans', false, 2, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u616', 'u613', 'Sweet corn', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u617', 'u613', 'Onion, yellow', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u618', 'u613', 'Garlic clove', false, 3, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u619', 'u613', 'Cumin', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u620', 'u613', 'Jalapeno', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u621', 'u613', 'Chipotle in adobo', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u622', 'u613', 'Cilantro', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u623', 'u613', 'Limes', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u624', 'u613', 'Yogurt, Greek', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u626', 'u625', 'Farro', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u627', 'u625', 'Mushrooms, cremini', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u628', 'u625', 'Shiitake', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u629', 'u625', 'Leeks', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u630', 'u625', 'Garlic clove', false, 3, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u631', 'u625', 'Thyme', false, 2, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u632', 'u625', 'Vegetable broth', false, 3, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u633', 'u625', 'Pecorino / Parmesan', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u634', 'u625', 'Extra-virgin olive oil', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u64', 'u63', 'Chickpeas', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u65', 'u63', 'Cucumber', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u66', 'u63', 'Tomato', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u67', 'u63', 'Onion, red', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u68', 'u63', 'Parsley', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u69', 'u63', 'Lemon juice', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u70', 'u63', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u71', 'u63', 'Whole-wheat pita', false, 2, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u72', 'u63', 'Feta', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u636', 'u635', 'Cannellini beans', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u637', 'u635', 'Carrot', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u638', 'u635', 'Celery', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u639', 'u635', 'Onion, yellow', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u640', 'u635', 'Garlic clove', false, 4, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u641', 'u635', 'Rosemary', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u642', 'u635', 'Bay leaves', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u643', 'u635', 'Kale', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u644', 'u635', 'Tomato', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u645', 'u635', 'Vegetable broth', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u646', 'u635', 'Extra-virgin olive oil', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u648', 'u647', 'Chicken, thigh', false, 6, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u649', 'u647', 'Tomato', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u650', 'u647', 'Bell pepper, red', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u651', 'u647', 'Mushrooms, cremini', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u652', 'u647', 'Onion, yellow', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u653', 'u647', 'Garlic clove', false, 4, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u654', 'u647', 'Oregano', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u655', 'u647', 'Red wine · optional', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u656', 'u647', 'Olives', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u657', 'u647', 'Parsley', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u659', 'u658', 'Oats', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u660', 'u658', 'Apples', false, 2, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u661', 'u658', 'Cinnamon', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u662', 'u658', 'Dates', false, 4, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u663', 'u658', 'Walnuts', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u664', 'u658', 'Soy milk', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u665', 'u658', 'Maple syrup', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u74', 'u73', 'Tuna, canned', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u75', 'u73', 'Eggs', false, 2, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u76', 'u73', 'Green beans', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u77', 'u73', 'Potatoes, red', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u78', 'u73', 'Olives', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u79', 'u73', 'Capers', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u80', 'u73', 'Tomato', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u81', 'u73', 'Mustard, Dijon', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u82', 'u73', 'Red wine vinegar', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u83', 'u73', 'Extra-virgin olive oil', false, 1, 9);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u84', 'u73', 'Romaine', false, 1, 10);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u86', 'u85', 'Miso', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u87', 'u85', 'Tofu', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u88', 'u85', 'Wakame', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u89', 'u85', 'Onions, green', false, 2, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u90', 'u85', 'Buckwheat / soba', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u91', 'u85', 'Shiitake', false, 4, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u92', 'u85', 'Ginger, fresh', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u901', 'u900', 'Chicken, breast', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u902', 'u900', 'Walnuts', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u903', 'u900', 'Whole-grain bread', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u904', 'u900', 'Mustard, Dijon', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u905', 'u900', 'Honey', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u906', 'u900', 'Extra-virgin olive oil', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u907', 'u900', 'Thyme', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u908', 'u900', 'Garlic powder', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u909', 'u900', 'Lemon', false, 1, 8);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u911', 'u910', 'Lentils', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u912', 'u910', 'Rice, brown', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u913', 'u910', 'Onion, yellow', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u914', 'u910', 'Extra-virgin olive oil', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u915', 'u910', 'Cumin', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u916', 'u910', 'Bay leaves', false, 2, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u917', 'u910', 'Yogurt, Greek', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u921', 'u920', 'Spinach', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u922', 'u920', 'Strawberries', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u923', 'u920', 'Walnuts', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u924', 'u920', 'Feta', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u925', 'u920', 'Onion, red', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u926', 'u920', 'Balsamic vinegar', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u927', 'u920', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u928', 'u920', 'Honey', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u94', 'u93', 'Whole-grain bread', false, 2, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u95', 'u93', 'Avocado', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u96', 'u93', 'Cannellini beans', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u97', 'u93', 'Lemon juice', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u98', 'u93', 'Cayenne', false, 1, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u99', 'u93', 'Arugula', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u100', 'u93', 'Extra-virgin olive oil', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u931', 'u930', 'Oats', false, 1, 0);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u932', 'u930', 'Whole-wheat flour', false, 1, 1);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u933', 'u930', 'Blueberries', false, 1, 2);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u934', 'u930', 'Walnuts', false, 1, 3);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u935', 'u930', 'Eggs', false, 2, 4);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u936', 'u930', 'Maple syrup', false, 1, 5);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u937', 'u930', 'Soy milk', false, 1, 6);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u938', 'u930', 'Cinnamon', false, 1, 7);
insert into recipe_ingredients (id, recipe_id, name, needs, count, position) values ('u939', 'u930', 'Extra-virgin olive oil', false, 1, 8);
insert into recipe_tags (recipe_id, tag, position) values ('d278', 'Lunch', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u10', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u10', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u10', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u10', 'Breakfast', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u101', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u101', 'Lunch', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1043', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1043', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1043', 'Cod', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1043', 'One-Pot', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1054', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1054', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1054', 'Chicken', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1054', 'One-Pot', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1065', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1065', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1065', 'Sardines', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1065', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1072', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1072', 'Lunch', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1072', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1072', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1081', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1081', 'Breakfast', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1081', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1091', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1091', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1096', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1096', 'Breakfast', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1096', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1096', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1104', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1104', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u111', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u111', 'Turkey', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u111', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u111', 'Lunch', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1114', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1114', 'Breakfast', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1114', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1122', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1122', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1122', 'Cod', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1122', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1131', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1131', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1131', 'Chicken', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1138', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1138', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1149', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1149', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1149', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1164', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1164', 'Lunch', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1164', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1164', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1174', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1174', 'No-Cook', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1174', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1181', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1181', 'Lunch', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1181', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1181', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u119', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u119', 'Salmon', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u119', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u119', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1190', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1190', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1190', 'Salmon', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1190', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1200', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1200', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1200', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1200', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1214', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1214', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1214', 'Tofu', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1214', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1229', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1229', 'Lunch', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1240', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1240', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1240', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1253', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1253', 'Lunch', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1253', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1264', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1264', 'Breakfast', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1264', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u127', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u127', 'One-Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u127', 'Dinner', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1270', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1270', 'No-Cook', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1270', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1278', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1278', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1278', 'Shrimp', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1278', 'One-Pot', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1291', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1291', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1291', 'Mussels', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1291', 'One-Pot', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1301', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1301', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1301', 'Chicken', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1301', 'One-Pot', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1313', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1313', 'Lunch', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1313', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1323', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1323', 'Lunch', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1323', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1332', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1332', 'Lunch', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1332', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1340', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1340', 'No-Cook', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1348', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1348', 'Breakfast', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1348', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1348', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1353', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1353', 'Tofu', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1353', 'Lunch', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1353', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1353', 'One-Pot', 4);
insert into recipe_tags (recipe_id, tag, position) values ('u1360', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1360', 'Tofu', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1360', 'Dinner', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1373', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1373', 'Tofu', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1373', 'Lunch', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1373', 'No-Cook', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1373', 'Quick', 4);
insert into recipe_tags (recipe_id, tag, position) values ('u1382', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1382', 'Tofu', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1382', 'Dinner', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u139', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u139', 'Chicken', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u139', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u139', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u1394', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u1394', 'Tofu', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u1394', 'Breakfast', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u1394', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u148', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u148', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u161', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u161', 'Cod', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u161', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u161', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u171', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u171', 'Dinner', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u181', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u181', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u189', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u189', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u189', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u19', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u19', 'Eggs', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u19', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u19', 'Breakfast', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u195', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u195', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u201', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u201', 'Trout', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u201', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u201', 'Quick', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u208', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u208', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u214', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u214', 'Sardines', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u214', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u222', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u222', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u229', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u237', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u237', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u245', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u245', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u245', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u252', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u252', 'One-Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u258', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u258', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u266', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u266', 'One-Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u279', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u279', 'One-Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u289', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u289', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u289', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u299', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u299', 'Chicken', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u299', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u31', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u31', 'Eggs', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u31', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u31', 'Breakfast', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u310', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u310', 'One-Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u323', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u323', 'Cod', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u323', 'Shrimp', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u323', 'Mussels', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u323', 'One-Pot', 4);
insert into recipe_tags (recipe_id, tag, position) values ('u323', 'Dinner', 5);
insert into recipe_tags (recipe_id, tag, position) values ('u335', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u335', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u335', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u345', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u345', 'No-Cook', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u353', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u361', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u361', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u361', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u369', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u377', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u377', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u377', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u386', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u386', 'Sardines', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u386', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u386', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u393', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u393', 'Turkey', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u393', 'Dinner', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u40', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u40', 'No-Cook', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u40', 'Breakfast', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u404', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u404', 'One-Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u404', 'Dinner', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u414', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u414', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u414', 'Dinner', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u425', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u425', 'Rockfish', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u425', 'Dinner', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u437', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u437', 'Chicken', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u437', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u437', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u448', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u448', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u454', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u454', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u454', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u461', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u461', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u469', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u469', 'No-Cook', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u47', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u47', 'Eggs', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u47', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u47', 'Breakfast', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u474', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u474', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u474', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u483', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u489', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u496', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u496', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u496', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u501', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u501', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u501', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u508', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u515', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u515', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u521', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u521', 'One-Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u527', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u527', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u534', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u534', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u536', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u536', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u541', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u541', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u541', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u541', 'Breakfast', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u547', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u547', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u55', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u55', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u55', 'Breakfast', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u552', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u552', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u552', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u557', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u557', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u557', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u564', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u564', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u564', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u571', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u571', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u579', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u579', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u579', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u586', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u586', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u592', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u592', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u592', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u600', 'Anti-Inflammatory', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u600', 'Instant Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u600', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u600', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u613', 'DASH', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u613', 'Instant Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u613', 'Chicken', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u613', 'One-Pot', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u613', 'Dinner', 4);
insert into recipe_tags (recipe_id, tag, position) values ('u625', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u625', 'Instant Pot', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u625', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u625', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u63', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u63', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u63', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u63', 'Lunch', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u635', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u635', 'Slow Cooker', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u635', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u647', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u647', 'Slow Cooker', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u647', 'Chicken', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u647', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u658', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u658', 'Slow Cooker', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u658', 'Breakfast', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u73', 'Mediterranean', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u73', 'Eggs', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u73', 'Tuna', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u73', 'Lunch', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u85', 'Blue Zone', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u85', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u85', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u85', 'Lunch', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u900', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u900', 'Chicken', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u900', 'Quick', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u900', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u910', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u910', 'Mediterranean', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u910', 'One-Pot', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u910', 'Dinner', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u920', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u920', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u920', 'No-Cook', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u920', 'Lunch', 3);
insert into recipe_tags (recipe_id, tag, position) values ('u93', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u93', 'Quick', 1);
insert into recipe_tags (recipe_id, tag, position) values ('u93', 'Lunch', 2);
insert into recipe_tags (recipe_id, tag, position) values ('u930', 'MIND', 0);
insert into recipe_tags (recipe_id, tag, position) values ('u930', 'Breakfast', 1);
