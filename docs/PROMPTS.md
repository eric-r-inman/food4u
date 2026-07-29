Great start.

The browser page should have 2 panes. The left pane, top to bottom column, takes up 2/3 of the page, and the right column takes up 1/3. Responsive. The left pane should be the food pyramid separated into categories ("Oils & Healthy Fats" etc.). The right column should be divided into 4 panes (vertical): Pantry, Refrigerator, Freezer, Counter. All food items should be draggable to another pane. When dragging from the pyramid, the food item is copied. When dragging from and amongst the right panes, the food item moves to the destination pane. Cannot drag from right panes to left pane. Add buttons to add food items to the food pyramid under each category.

---

Remove the following from the top of the food pyramid pane:

"Mediterranean · Okinawan · Nordic · Blue Zones"

and

"Eat freely from the wide base, sparingly from the narrow top. Drag any food into a storage pane on the right to plan what to keep on hand.

211
FOODS
91
PANTRY
120
FRESH
21
TOP ★
13
Na LIMIT"

Then remove all the tags from the food item badges (P Pantry · shelf-stable F Fresh · buy close to use ★ Top-priority staple Na High Sodium)

Then make each category collapsable (for example, Oils & healthy fats), and also remove the 2-column item organization within the pyramid, and make it a 1-column organization.

---

Remove the Sea Vegetables category. Yuck.

There are some item badges that have a reddish backgorund; they shouldn't. 

Color code the badge backgrounds of the items by category, in very light shades. 
Oils & Healthy Fats: Yellow
Leafy Greens: Dark Green
Vegetables: Light Green
Whole Grains: Tan
Fruit: Purple
Tea & Botanicals: Grey
Legumes & Pulses: Red/brown
Nuts & Seeds: Brown
Soy & Fermented: Yellowish
Cultured Dairy: White
Oily & White Fish: Blue
Eggs & Poultry: Different blue
Sweeteners & Extra: Orange
Limit: Orange

When an item is in one of the right panes, add a darkened black borde to the item in the pyramid, so that it's obvious which items are in stock in the kitchen.

---

Make the color coding of the items in the right panes match the color coding of the items in the pyramid.

---

Implement: 
- Alphabetize the items within their categories in the pyramid.

- Within the right panes, the items should be sorted in the same category order as they appear in the pyramid, and then alphabetized within categories.

---

1. Add a category "Condiments" to the food pyramid, in whatever you think the most appropriate section. To that, ad vinegars etc., that are mediterranean and longevity diet compatible. 

2. Remove food badges in the right panes that are not in the pyramid. Add canned tuns, sardines, and salmon to the pyramid.

---

In the right panes, remove the bottom text in each pane, for example "Grains, legumes, nuts & seeds keep beautifully in mason jars. Choose no-salt-added canned goods where you can."

In the Occasionally list, remove the text "Save for feats" so that the category is "Limit"

---

In the right panes, at the bottom of each pane, make a collapseable second row with heading "Buy". Items can be dragged into here. This is how the user can know what foods to buy. It's OK if an item appears in both this sub-panel, and the main panel.

---

Make the right column separately scrollable from the left column. Make scrollbars for both the left and right columns.

---

Remove the "reset to defaults" button.

The default should have no items at all in the right panels.

When I add/remove items to the right panels, those items should persist between builds, so that I can contnue developing the app while also using it.

---

Change the text "The Longevity Food Pyramid" to "Longevity Staples".

Then, in the food pyramid, remove the leftmost columns (for example, Foundation) and make them the top row of the groupings instead. This will free up some width.

Then, make the pyramid pane 2 separately scrollable panes. The second pane is Recipes. The Recipes pane is hideable and openable... default is hidden. The categories in the Recipes pane should be:
Breakfast
Lunch
Dinner
Appetizers
Side Dishes
Soups & Stews
Salads
Main Courses
Snacks
Desserts
Beverages
Sauces & Condiments

You should be able to add a new recipe, and drag ingredients over into that recipe's field.

---

Implement: The default (on browser load) for all collapsable cateogries is collapsed rather than non-collapsed.

Move the "Condiments" category out of the "Foundation" section, and into the "Daily" section.

Change the text "Longevity Staples" to "Longevity Foods".

Add a search function: Underneath "Longevity Foods", add a search field. When an item is entered, the category will expand and the item will be highlighted. If no item, the search field will be colored red.

When the "Add" button is clicked, make the cursor in the input field immediately active; currently, the user must also click in the field after clicking "add", but that's two clicks when it could be done with one.

Make individual recipes collapsable. Add an "x" to the recipe badge to delete the recipe. When an item is dragged from the recipe to a panel in the right pane, copy the item rather than moving the item. 

If a recipe item is not in one of the rightmost panels, highlight that reicipe item in red in the recipe. 

---

Implement: Individual recipes are default collapsed.

Remove the Buy list under each of the right panes. To the top of the right panes add a new pane: Shopping Cart. For now, this functions the same way as the other panes (for example, Refrigerator).

---

In the search field, add an "x" that when clicked clears the esearch text.

In the item badges, there is too much padding to the right of the text.

In the recipes, for each recipe, add a shopping cart to the left of the "x". When clicked, the shopping cart will add to the shopping cart all that recipe's items that are not already in a panel on the right.

---

Implement: default of right panes is collapsed, except for Shopping Cart, which is default expanded.

For each individual recipe, under the item badges for that recipe, add the recipe instructions. Use standard recipe format. Ingredients first and amounts, then instructions. Create a sample recipe under Lunch for Cucumber Sandwich. Ingredients should be within Longevity and Mediterranean diet. Add CRUD features for the recipe.

---

Some items in the pyramid are recipes themselves, for example Hummus. If I build a recipe under Recipes, I would like to be able to drag that recipe over to a pyramid category, and that recipe becomes linked to an item badge. Please implement this functionality, and make two recipes: a Hummus recipe, and a Tzatziki recipe. Then to test, I will try to drag that recipe over to Condiments in the Pyramid, to see if it populates. Pyramid items that have associated recipes should have a little notepad in the badge to the right of the text, and when clicked, that opens the recipe.

---

I like how the Recipes column collapses into a vertical bar. Make the Pyramid and Kitchen columns do the same. The Kitchen column is the far right column of panels. Make a title row with the title Kitchen, imitating the same style as the pyramid title row.

The Pyramid column should be expanded by default, but the Recipe and Kitchen columns should be collapsed by default.

---

Make the Kitchen collapsed bar the same color as the Pantry bar. Make the collapsed Pyramid bar the same color as the Foundation bar.

Implement: When the items within a recipe are all present in at least one Kitchen panel (do not count the Shopping panel), then put a green checkmark to the immedite right of the recipe name text. This shows the user that they have all the ingredients to make that recipe immediately, with ingredients they have in the kitchen, and they don't need to shop.

---

change the shopping cart to its own column similar to kitchen and pyramid and recipes. 

---

When Recipes, Kitchen, and Shopping Cart columns are expanded, auto-collapse the Pyramid.

When an item is dragged over a collapsed kitchen pane or shopping cart, add the item to that pane, even though it's collapsed. 

--

Add "Search recipes" and "Search Kitchen" to corresponding columns, with same functionality as the "Search foods", for their corresponding columns.

---
I need to be able to drag item badges into the shopping list, from either the pyramid or the kitchen.

Change the text "Shopping Cart" to "Shopping List"

---

Make the shopping list title bar the same color as the "Occasionally" bar.

---

Add your recommendation to the app:
"Cook now" / "Almost there" recipe filters. You already compute the green ✓ (all ingredients in the kitchen). Turn that into a filter/sort: Can make now, and Missing only 1–2 (show the gaps, with a one-click "add just those to the Shopping List"). This is the single highest-value feature relative to effort — it makes the whole app answer a question ("what's for dinner?") instead of just storing data.

---
Make a recipe parser that can do 2 things:
1. If I paste in a recipe as text, it will parse it out and put it in our recipe format, and add the ingredients. Ingredients that are in the recipe, but missing from the pyramid, should have an exclamatino point that on hover shows "Not in food list". The user can drag that item into the food pyramid. Put a "Paste" button to the right of the "Add" buttons in the recipe categories.
2. If I link to a recipe web page, the parser crawls the web page, extracts the recipe, and adds it to our recipes. 

let's do #1 first, then pause and discuss #2, because #2 is a big deal.

---

- Under a specific recipe, for needed ingredients, there shouldn't be a text list for needed ingredients, only the recipe badges. There shouldn't be a "+ list" button; the shopping cart button that already exists is sufficient. The text "Need:" is not needed.

- Make the Legumes badges a more orangy color, rather than the red, so that the color doesn't overlap with needed ingredient badge color.

---
Add these considerations into your optimization recommendations and findings, and then prepare an optimization plan for my review. You may need to write in refactors as well as optimizations.
We will be making this a hosted app for other users.
I will continue to use it locally for my own purposes.
A hosted version will be made available to the online world.
Change from using JSON to postgres & sqlite for recipes and foods etc.
Provide a complete use sign-in and account experience.
Users' hosted saved foods and recipes etc. should persist on the server.
This will be a detailed and multi-faceted review and plan; take your time, be thorough. Start with the current optimization findings and recommendations.
Emit the optimization plan as a .org file.

---

Add ability to edit the name and decription of the existing and any new kitchen panes: via a pencil icon that should replace the "x" (delete the pane). When the pencil icon is clicked, the "x" for deletion will reappear to the right of the pencil, and the user can also click and edit the pane name and description. 

---

Create a Staples Tracker. This is a permanent (not editable or deletable) collapsable pane in the Kitchen column, under the search field. When open, the top of the pane reads "Add staple foods here. Click the 🛒 button to add missing staples (not in your Kitchen, colored red) to your shopping list." Users can drag foods into this pane, which will put them in the tracker. When a food in the tracker is not in another Kitchen panel, then that food badge turns red in the staples tracker pane, and clicking the cart in the tracker pane will add those missing items to the shopping list.

---

- In the Staples tracker, the shopping cart in the button is nearly invisible against the background. Make it more visible. The staples tracked pane should default to collapsed when the app page is loaded. 

- Implement: When clicking the edit button in a kitchen column, the edit button should disappear and be replaced by an "x" button that allows deletion of the pane, with a confirmation of deletion when clicked. Also, ensure the "x" button doesn't get cutoff on the right side, which is currently happening to the edit button when it's clicked (the editable region expands slightly, causing it to cutoff); the edit button will be replaced by the "x" button when editing is active, I want to ensure the "x" button does not get clipped on the right edge.

- In the kitchen column, when editing a pane is active, clicking off the pane active for editing will close editing without saving any changes.

- In the kitchen column, when editing a pane is active, add a color wheel icon to the left of the "x" button; when the color wheel icon is cliked, the user can select colors for the title row of the pane, within the color pallette of the app (limit color choices to colors currently being used in row headers for the various columns and panes).

---
NOT YET SENT

LLMs can be good at creating recipes for specific diets and including/excluding specific foods. I'd like to add AI capabilities to the app. I would like your opinion on how this should be done, and if it's even feasible. DOn't make any changes yet, just give me your opinions and initial approach ideas for making this a feature that users might be able to use for themselves, whether entering their own llm API, or accessing free LLM API. This will be a free to use hosted web app, so I don't want to spend any more money other than hosting; don't want to use our own LLM (except of course for my own local use for the app, where I will want to use Claude).
- Interface opened in Recipes column, within recipe category, button to the left of "Paste" titled "AI"; so the row for adding a new recipe should read New Recipe Name or Paste or AI
- Find/create recipes based on the meal category selected, and other useful options, food inclusions, food exclusions, allergies (stored for future sessions)
- Automatically add recipe to Recipes
- Automatically add required ingredients to shopping list if not in Kitchen
- Can choose to make recipe based on ingredients in Kitchen
- Other important options I'm missing here
- But, simple to use, no overwhelm
- Shows recipe before committing
- Generates optimized prompts for the LLM, to find/create excellent recipes
- Provides instrucitons to users on how to enter their LLM info, and requests confirmation/release to query their designated LLM... if this is feasible and useful.

I have never integrated LLM into an app before, so your experienced opinion is appreciated.

---

big style change. I'd like the item badges in each Longevity column main category (e.g., Foundation, Daily, Weekly, Occasionally) to have the same color, even if the items are in different sub-categories. The item badge colors should work with the color pallette of the main category color.

---
NOT YET SENT

Make the following categories default under the Shopping List column, in the order they appear:
Produce, Dry Goods, Canned, Dairy, Frozen, Bulk, Bakery, Meat & Seafood, Baking, Condiments & Sauces, Coffee & Tea, Cereals, Snacks, Health & Wellness

---

Make sure everything we've done since the refactor is in compliance with the refactor ideals.

REmove Snacks, Cereals, Dry Goods, and change Canned to Canned & Dry Goods. Change Baking to Baking & Spices. And make the style of the categories the same style as the REcipe categories. 

---
NOTE YET SENT
We need a way to bookmark recipe, so you know what you just added to shopping cart

---

For phone users, dragging badges isn't feasible. In the header title row of each of the 4 columns, right justified in the row, make a toggle called "Select:" which defaults to "Select: off" and toggles to "Select: on". When "Select: on" is toggled, item badges have a left-justified circle that toggles from empty (default) to selected (filled); the items can still be drag-and-dropped with click-and-hold, but when clicked or tapped they select on and off. When more than 1 item is selected, drag-and-dropping a selected item moves all selected items too. Add a test for this to the interactive release checklist.

---

When the Select toggle is toggled on, and 1 or more items are selected, a fat green down-arrow appears on each of the pane title bars in the Kitchen and Longevity Foods columns, and on each of the categories in the Shopping List column. When hovering over the down arrow, hove text: "Move selected here". When the green arrow button is clicked, the selected items are moved to that area. The selected items remain selected. When more than 1 item is selected, add a "Deselect all" button to the right of the Select toggle button; when clicked, the Deselect all button deselects any selected items, and disappears.

---

The green shopping cart button in the recipe header should be grayed out when the ingredients are already in the shopping cart or kitchen, and green when there's an item in the recipe that's not in either the shopping cart of kitchen.

---

We need a way to bookmark recipe, so you know what you just added to shopping cart. In the recipe badge, between the grabby icon and the shopping cart, make a bookmark toggle. When a recipe is bookmarked within a category, the category title row should how the number of bookmarked recipes within that category. 

---

When the Select button is toggled off, do not show the text "Tap item badges to select, then drag one — or press the ⬇ on a destination — to move them all.". Instead, when the Select button is toggled off, show: Drag-and-drop items. When the Select button is toggled On, show: "Drag-and-drop items; or, select items, then drag or press the ⬇ on destination to move selected." Ensure that this text remains in view, and bumps to next row, when the browser window is narrowed. 

Also, make the bookmark highlighted icon (when bookmark is toggled on) a light blue color, rather than the red color it is now.

Also, when in select mode, and user has selected 2 or more items, when holding and dragging one of the selected items, add a small box attached to the item badge that shows the total number of items being dragged, for example "x4"

---

Under the Longevity Foods column, in the title row for each main category (Daily etc.), next to the text "X Foods", add text to show how many of the foods in that main category are actually in stock, for example: "131 Foods / 26 Stocked". THis doesn't need to be done for each subategory.

---

When the Select toggle is On, and 1 or more items are selected, in the button show the number of selected items in parentheses. For example: "Select: on (5)".

Remove the text below the Select button, both when toggled on and off.

---

In the Recipes, when a user grabs a recive card (clicks and holds) and begins dragging the recipe card, currently this causes the category to collapse. Instead, the category should remain open. Furthermore, the user should be free to drag the recipe card into the recipe order under the category that they want. In other words, they can drag and drop the recipe card to a new position in the order.

---

Add recipe tags (manual text entry, no pre-existing bundled tags), & allow user to show only recipes with selected tag (hide all others); category cards' display of total number of recipes within the category change to reflect the number of recipes under the selected tag. Only 1 tag can be selected at at time. Put tag selection drop-down to the right of the Search Recipes field, but don't widen the recipes column, just make sure both the search recipes field and the less-wide tags drop-down fit.

---

Add in the ability to export a recipe to txt file

---

I need to be able to easily add, edit, and delete default bundled foods and recipes, in a more visual way (I don't want to edit code directly for this task). Please setup a method for me to do so. You can download and install any software that might be useful. Then prepare instructions for using your solution.

---

Ensure no JSON is beign used in the app anywhere, and remove any vestiges of it in the architecture.

---

I have a challenge for you. Take on the role of a professional dietician and chef, who develops recipe plans for people on longevity-focused diets, such as the mediterranean diet, or blue zone diet, anti inflammatory diet, dementia prevention diet, etc. I would like to populate our bundled default recipes with several recipes per each category, healthy and delicious recipes that utilize our bndled foods. THis would require you to look at popular or high-ranked recipes on the internet, and translate them into recipes for the app. You can also develop your own recipes if you feel confident in doing so. The recipes within categories should have lots of variety, utilizing a good spread of longevity foods. The recipes should be tagged based on the primary diet plan they fall under, for example, Mediterranean. Some recipes should be more simple, some more complex. If an ingredient isn't in our bundled food items, then add that food item to the appropriate category in the Longeivty Foods columns.

---

I would like the drag-and-drop for the recipe cards to have the same feel as drag-and-drop of the individual food items: when clicked and held, the recipe card floats with the pointer. For now, the recipe card can only be placed in another recipe category, but later we will be creating a weekly meal planner where the recipe card can also be drag and dropped. But for now, just get the feel of drag and drop recipe cards to match the drag and drop of food items.

---

please reset my own personal kitchen to the default seed so i can start fresh.

---

Create a collapsible Meal Planner column between the Recipe and Kitchen columns. Choose a nice color that vibes with the style. The Meal Planner should have 1 pane for each day of the week, starting with Sunday. Within each pane, there should be 4 categories: Breakfast, Lunch, Dinner, Snacks. Under these categories, users can drag recipes. Recipes cards will copy into these categories. There can be multiple copies of a single recipe among the Meal Planner categories. 

---
Implement these fixes and features:

- Add Lunch, Dinner, and Snacks categories to each day in the Meal Planner.

- Currently, when the meal planner panes are minimized/uncollapsed, the title bar doesn't have enough height and the name of the day (e.g. Sunday) gets cut off. Make sure the collapsed title bar of those panes remains the same height when collapsed.

- In the recipe badges in the meal planner panes, rather than a little badge, make a card for the recipe that extends the width of the pane, with the full name of the recipe. No hover text. Keep the X at the far left of the card that removes the recipe from that pane. Add a thick blue (same blue as the Recipe column title bar) arrow to the left of the recipe name, when clicked the arrow opens the recipe in the Recipes column, and scrolls so that the opened recipe is within the visible browser window.

- In the Meal Planner column, change the names of the panes from days of the week to "Day 1", "Day 2", etc., up to "Day 10". Underneath the last pane, add two buttons: "Add Day" and "Remove Day". These buttons do what they say; they add a new day, incremented by +1, or remove the last day in the list.

- In the Reipe column, when a recipe card is expanded, add a new row under the title bar and icons row, which has the full name of the recipe, in smaller font (same style as recipe categories text), so that the full recipe name can be seen (currently, the recipe name is cut off by the icons if it is too long, but that's ok). THis way, the user can see the recipe's full name when expanded. Recipe names should not be allowed to be more characters than can appear on this second line of the recipe card.

- To the default bundle, add some recipes that utilize Instant Pot and Slow Cooker. Add the tags Instant Pot or Slow Cooker as appropriate. Update my personal local kitchen to the default, so I can see what new users see.

- In the REcipes column, remove Breakfast, Lunch, and Dinner categories, and move the recipes in those categories to an appropriate other column, such as Main Courses and Side Dishes. But, tag those recipes with new tags Breakfast, Lunch, and Dinner, depending on the category they were in before you moved them. Scan the other recipes, and add Breakfast, Lunch, or Dinner tags to recipes where appropriate; not all recipes will need those tags, only recipes that are obviously meant for those particular meals.

- Create an About page. The page should describe the purpose of the website and its features. Fill it in with your own generated content, and I'll edit the content (let me know where the file is for editing the About page).

---

I don't love that the about page was built with CSS and javascript. Please check the template requirements and tell me if this deviates.

---
In the Meal Planner column, in the meal cards, change the arrow (that opens the recipe) to a notepad

---

In the recipe badges under Meal Planner, move the "x" for removing the recipe, to the right edge of the recipe badge, rather than the left edge.

---

Where is the About page code file so I can edit it?

---

When the browser window width is reduced, at some point (i think when we're at phone screen width) the columns convert to stacked rather than side-by-side. Currently, when the columns are stacked, the column title bar text remains sideways (vertical), but I would like to convert to horizontal when the columns are stacked. The title bar text for the columns should be vertical only when the columns are side-by-side.

---

We need to conduct tests to make sure the recipe parser is flexible and accurate across various possible recipe formats. Please design a thorough test plan, involving you finding various recipes online, then adding them to the parser as a user would do, and testing that the parser is accurately mirroring the recipe. I also want to make sure the parser doesn't duplicate food items that are already in the Longevity Foods lists; for example, if the recipe calls for a food item that's pluralized, but the Longevity List has that food as singular, it should be smart enough to keep the singular version and not add the plural version. Emit your plan as a .org file for my review, before you begin. ANy other tests that you can think we need for an excellent recipe parser, go ahead and bake them into the test plan.

---

- Add a "Donate" page link to the right of the "About" page link. Then add a Donate page, but it should be "Work in progress" for the content, for now.

- For the Cultured Dairy category, remove the text next to it that says "Moderate"

- Just like under the Shopping List column title bar, under the Meal Planner column title bar add two buttons "Export to .txt" and "Clear all". The "clear all" button (in the Meal Planner column) should clear all recipes from each day in the meal plan. The "Export to .txt" button (in the Meal Planner column) should emit and download a .txt file with each day and the recipe names for each category for that day

---

Now, for the exported daily meal planner text file, after the days and meals are listed, list also the recipes that are included as meals. Format the text file nicely.

---

We're going to add a cool feature to the Staples Tracker. In the Staples Tracker pane, under the title bar, add add a button: "Auto". WHen clicked, this opens a drop-down menu of the major longevity diets. When the user makes a selection, the Staples Tracker pane auto-populates with essential staples from the selected diet.
- Claude should choose the longevity-focused diets for the selection menu.
- Claude should determine the essential staples for each diet.
- If a staple already exists in the Staples Tracked pane, then that staple is not duplicated in the Staples Tracker pane.
- Claude should emit a .org file showing me its process for considering and choosing the diets and staples that claude chose for this feature.

---

Look through the longevity foods, and if there are longevity foods that also often come in cans or in some other form at the grocery store (for example, chopped tomated come in cans, and Rye can come as flour), then add the other versions of those items, if those other versions are often used in longevity food recipes. Don't add any Frozen versions. For example, Rye flour would be called "Rye flour"


---
Here are new foods to add to the various diet staples auto-fill (if not already part of the food items athat are suto-added). If the food doesn't exist in the Longevity Foods list, add it where appropriate.
To the Mediterranean staples auto-fill, add: Red wine vinegar, Balsamic vinegar, Apple cider vinegar, Tahini, Pine nuts, and also add very common herbs & spices staples that are used often in mediterranean recipes. Compare the Mediterranean suto-fill staples with our recipes, and add foods that are used very commonly as ingredients.
To the Blue Zone diet auto-fill staples foods, add more Blue Zone foods that are very commin in Blue Zone recipes, and add foods that are used very commonly used in Blue Zone recipes as ingredients. Don't neglect herbs and spices. Look through our recipes and ensure the staples auto-fill foods reflect the most common ingredients.
To the Anti Inflammatory  diet auto-fill staples foods, add more foods that are very common in Anti Inflammatory recipes, and add foods that are used very commonly used in Anti Inflammatory recipes as ingredients. Don't neglect herbs and spices. Look through our recipes and ensure the staples auto-fill foods reflect the most common ingredients.
To the MIND diet auto-fill staples foods, add more foods that are very common in MIND diet recipes, and add foods that are used very commonly used in MIND recipe ingredients. Don't neglect herbs and spices. Look through our recipes and ensure the staples auto-fill foods reflect the most common ingredients.
To the DASH diet auto-fill staples foods, add more foods that are very commin in DASH recipes, and add foods that are used very commonly use in DASH diet ingredients. Don't neglect herbs and spices. Look through our recipes and ensure the staples auto-fill foods reflect the most common ingredients.


---

The rust template at https://github.com/LoganBarnett/rust-template has been updated. Please ensure that our local rust template at ~dev/rust-template is a match to the updated rust template at https://github.com/LoganBarnett/rust-template. Then, run a full compliance check with our app here at ~/dev/food4u; everything you need to get started should be in ~/dev/rust-template/README.org (but compare that README.org version with our version here at ~/dev/food4u, and note any differences and why we made them). Prepare a comprehensive compliance plan for anything that's not in compliance with the updated template, and any refactoring that needs to be done to bring our project into compliance with the template. If there are parts of the template that are not useful for our project and that you think should not be followed, add those in a special section to the compliance plan; but, you should err on the side of template compliance, rather than look for things to take exception to; we should be as in compliance as possible to satisfy my supervisor and the requirements of our future host, who made the tamplate we are using. Don't begin making changes to our project yet, just emit the comprehensive plan for my review.

---

Please emit a table showing the auto-fill diet staples assigned to each diet selection for the Staples Tracker.

---

We need a way to allow the user to add a count for an item, so that the item bacge shows the number of those items in the badge, in parentheses to the right of the item. For example, "Jicama: 3". Im thinking add a "Count:" toggle to the right of the "Select:" toggle button. The Count can be either "Count: on" or "Count: off", with "Count: off" being the default. When toggled on, an up and down arrow appears to the left of the food name in each food badge; BUT it only works on foods in the Kitchen, Recipes, or Shopping List columns; it doesn't work in the Longevity Foods column. Then the up arrow is clicked, the item number is increased by 1 and when the down arrow is clicked, it's decreased by 1 with a minimum of 1. 

---

In the Lonegivty Foods column, in the Occasionally pane, change the category name "Limit" to "Snacks". In the Foundation pane, change "Oils & Healthy Fats" to "Plant-based Oils & Fats"

---

What i'm not liking about this solution with moving the "x" farther to the right when there's a count, is that the width of the food item badge with a count >1 is expanded and when not hovering over the badge, there is empty blank space on the right side of the badge. Here is my solution:
- Undo the work that's been done to move the "x" to the right of the count in the badge.
- Add a button toggle to the right of the "Count" toggle, that says "Pare:" and defaults to off. When "Pare" is toggled on, then the various "x" buttons that allow a food item badge or category to be deleted, appear. When "Pare" is toggled off, the "x" buttons do not appear, not even on hover.

This will allow the user to keep the badges looking clean, and it will also prevent any accidental deletions by mis-clicking.

---

Commit my default-data work

---

In the Shopping List column, in the Shopping List drag-and-drop area, just under the category heading "Shopping List", add a field where the user can type a food. The field should allow the user to quickly add food badges to the shopping list, without having to go to the Longevity Pyramid or anywhere else to populate the Shopping List, if they choose. The field also allows the user to add custom items to teh shopping list, that aren't in the Longevity pyramid.

---

The search field for the shopping list should have auto-complete functionality for existing food items.


---
Add: when hovering over select circle, the cursor should change to an arrow to show that the circle is togglable

