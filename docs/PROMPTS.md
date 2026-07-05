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