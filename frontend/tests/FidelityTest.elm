module FidelityTest exposing (suite)

{-| Real-world recipes, pasted as a user would paste them, must parse
into a faithful mirror: the right name, one chip per real ingredient
(none for headers or notes), and the steps preserved verbatim in the
instructions. The first four fixtures were captured from live recipe
sites; the rest reproduce common formats by hand.
-}

import Expect
import RecipeExport
import RecipeParser exposing (parsePastedRecipe)
import Test exposing (Test, describe, test)


{-| A slice of the shipped catalog covering these fixtures' foods.
-}
catalog : List String
catalog =
    [ "Extra-virgin olive oil"
    , "Yellow Onion"
    , "Onions"
    , "Shallots"
    , "Carrots"
    , "Celery"
    , "Garlic"
    , "Cumin"
    , "Cinnamon"
    , "Green lentils"
    , "Lentils"
    , "Vegetable broth"
    , "Lemon juice"
    , "Lemons"
    , "Kale"
    , "Black pepper"
    , "Black beans"
    , "Chipotle in adobo"
    , "Avocado"
    , "Avocado oil"
    , "Banana"
    , "Eggs"
    , "Walnuts"
    , "Tomatoes"
    , "Tomato paste"
    , "Maple syrup"
    , "Smoked paprika"
    , "Chickpeas"
    , "Tahini"
    , "Spinach"
    , "Cilantro"
    , "Olives"
    ]


parse : String -> RecipeParser.ParsedRecipe
parse =
    parsePastedRecipe catalog


{-| Parse a single pasted ingredient bullet and return its chip name.
-}
chip : String -> String
chip line =
    parse ("Test\n\nIngredients:\n- " ++ line)
        |> .ingredients
        |> List.head
        |> Maybe.withDefault "(no chip)"


{-| Budget Bytes, "Mediterranean Lentil Soup" — a food-blog recipe card
with checkbox bullets and per-ingredient prices in parentheses.
-}
budgetBytes : String
budgetBytes =
    """Mediterranean Lentil Soup

Ingredients
▢ 2 Tbsp olive oil ($0.32)
▢ 1 large yellow onion, diced small ($0.78)
▢ 2 medium carrots, diced small ($0.24)
▢ 3 stalks celery, diced small ($0.36)
▢ 5 cloves garlic, crushed ($0.30)
▢ 2 tsp ground cumin ($0.20)
▢ 1 tsp cinnamon ($0.16)
▢ 1 cup uncooked brown or green lentils ($0.68)
▢ 8 cups vegetable broth ($1.44)
▢ 4 oz. lemon juice ($0.48)
▢ 3 cups kale, chopped and lightly packed ($2.48)
▢ 1 tsp salt ($0.05)
▢ 2 tsp freshly cracked black pepper ($0.10)

Instructions
1. Rinse the lentils in a strainer under cold water until the water runs clear.
2. Heat the oil in a large soup pot set over medium-high heat. Add in the onions, carrots, and celery and cook until they become tender, about 6-7 minutes, stirring frequently. Season with salt and pepper.
3. Stir in the garlic, cumin, and cinnamon. Heat until fragrant, about 60 seconds. Add the lentils to the pan and heat for 1-2 minutes to slightly toast.
4. Pour in the vegetable broth and lemon juice, then bring the pot to a boil. Reduce heat to low and simmer until the lentils are tender, about 30-45 minutes.
5. Stir in the greens, season with additional salt, pepper, and lemon juice to taste before serving."""


{-| Love & Lemons, "Black Bean Soup" — unicode fractions, "2 (15-ounce)
cans", a quantity-less ingredient, and an "Optional toppings:" label.
-}
loveAndLemons : String
loveAndLemons =
    """Black Bean Soup

Ingredients
- 2 tablespoons extra-virgin olive oil
- 1 medium yellow onion, diced
- 2 celery ribs, diced
- 1 medium carrot, diced
- 1 teaspoon sea salt
- Freshly ground black pepper
- 3 garlic cloves, minced
- 1 teaspoon ground cumin
- ½ teaspoon chili powder
- 2 (15-ounce) cans black beans, including the liquid in the cans
- 2 chipotle peppers from a can of chipotles in adobo sauce, chopped
- 1½ cups vegetable broth
- 1 tablespoon fresh lime juice, plus wedges for serving
- Optional toppings: avocado, cilantro, pickled onions, pepitas

Instructions
1. Heat the olive oil in a large pot or Dutch oven over medium heat. Add the onion, celery, carrot, salt, and several grinds of pepper. Cook, stirring occasionally, for 10 to 15 minutes, or until soft.
2. Let cool slightly, then transfer half of the soup to a blender. Puree until smooth, then add it back to the pot with the remaining soup and stir. Stir in the lime juice.
3. Season to taste and serve with lime wedges and desired toppings."""


{-| King Arthur, "Whole Grain Banana Bread" — weights beside volumes,
"Batter"/"Topping" subsection labels, brand-name ingredients, and a
duplicated spice that must collapse to one chip.
-}
kingArthur : String
kingArthur =
    """Whole Grain Banana Bread

Ingredients

Batter
2 cups (454g) mashed banana (about 5 medium)
1/2 cup (99g) vegetable oil
1 cup (213g) light brown sugar or dark brown sugar, packed
2 large eggs
1 teaspoon King Arthur Pure Vanilla Extract
1 cup (120g) King Arthur Unbleached All-Purpose Flour
1 teaspoon baking soda
1 teaspoon ground cinnamon
1/2 cup (57g) chopped walnuts, toasted if desired; optional

Topping
1 tablespoon (13g) granulated sugar
1/2 teaspoon ground cinnamon

Instructions
1. Preheat oven to 350°F with rack in center position. Lightly grease 9" x 5" loaf pan.
2. In large bowl, stir together mashed banana, oil, sugar, eggs, and vanilla.
3. Mix flours, baking soda, salt, cinnamon, and walnuts into banana mixture.
4. Bake 60-75 minutes until set and paring knife inserted in center comes out clean."""


{-| Minimalist Baker, "1-Pot Chickpea Shakshuka" — ALL-CAPS subsection
headers, ranges ("1-3 Tbsp"), fused number-units ("1 28-ounce can"),
"or"-alternatives, and unnumbered dash steps.
-}
minimalistBaker : String
minimalistBaker =
    """1-Pot Chickpea Shakshuka

Ingredients

SHAKSHUKA
- 1 Tbsp olive or avocado oil
- 1/2 cup diced white onion or shallot
- 3 cloves garlic, minced (3 cloves yield ~1 1/2 Tbsp)
- 1 28-ounce can crushed tomatoes
- 1-3 Tbsp tomato paste
- 2-3 tsp coconut sugar or maple syrup (or omit if avoiding sugar)
- Sea salt to taste
- 2 tsp smoked paprika
- 1 tsp ground cumin
- 1 ½ 15-ounce cans cooked chickpeas (rinsed and drained)

FOR SERVING (optional)
- Lemon wedges
- Fresh chopped parsley or cilantro

Instructions
- Heat a large rimmed metal or cast iron skillet over medium heat. Once hot, add olive oil, onion, bell pepper and garlic. Sauté for 4-5 minutes, stirring frequently, until soft and fragrant.
- Add crushed tomatoes, tomato paste, coconut sugar, sea salt, paprika, and cumin. Stir to combine.
- Add chickpeas and olives. Stir to combine. Then reduce heat to medium-low and simmer for 15-20 minutes.
- Serve as is or with bread, pasta, or rice."""


{-| A big-recipe-site format: yield noise before the ingredients, a
"Directions" header, and "Step N" labels inside the steps.
-}
directionsStyle : String
directionsStyle =
    """Easy Vegetable Soup

Servings: 6
Prep Time: 10 mins

Ingredients

2 tablespoons olive oil
1 onion, chopped
2 (14.5 ounce) cans diced tomatoes
4 cups low-sodium vegetable broth
2 cups chopped spinach
Salt and pepper to taste

Directions

Step 1
Heat oil in a large pot over medium heat. Add onion and cook until translucent.
Step 2
Add tomatoes and broth; bring to a boil. Stir in spinach and simmer 10 minutes."""


{-| A minimal hand-typed recipe: no headers at all, dashed ingredient
bullets straight under the title, free-text steps.
-}
handTyped : String
handTyped =
    """Grandma's Greens

- olive oil
- 2 bunches kale
- garlic
- lemon

Cook the garlic gently in the oil, add the kale in handfuls, and finish with the lemon's juice."""


{-| An emailed/markdown recipe: a forwarded-subject title, asterisk
bullets, a "Method:" header, and "1)" step numbering.
-}
emailStyle : String
emailStyle =
    """FWD: best hummus ever

Ingredients:
* 1 can chickpeas
* 1/4 cup tahini
* juice of 1 lemon
* 2 garlic cloves

Method:
1) Blend everything until smooth.
2) Season and serve."""


suite : Test
suite =
    describe "real-world parsing fidelity"
        [ describe "Budget Bytes (blog card: checkbox bullets, prices)"
            [ test "name" <|
                \_ -> (parse budgetBytes).name |> Expect.equal "Mediterranean Lentil Soup"
            , test "ingredients" <|
                \_ ->
                    (parse budgetBytes).ingredients
                        |> Expect.equal
                            [ "Olive oil", "Yellow Onion", "Carrots", "Celery", "Garlic", "Cumin", "Cinnamon", "Green lentils", "Vegetable broth", "Lemon juice", "Kale", "Salt", "Black pepper" ]
            , test "steps survive verbatim" <|
                \_ ->
                    (parse budgetBytes).instructions
                        |> String.contains "simmer until the lentils are tender, about 30-45 minutes"
                        |> Expect.equal True
            ]
        , describe "Love & Lemons (fractions, (15-ounce) cans, toppings label)"
            [ test "name" <|
                \_ -> (parse loveAndLemons).name |> Expect.equal "Black Bean Soup"
            , test "ingredients" <|
                \_ ->
                    (parse loveAndLemons).ingredients
                        |> Expect.equal
                            [ "Extra-virgin olive oil", "Yellow Onion", "Celery", "Carrots", "Sea salt", "Black pepper", "Garlic", "Cumin", "Chili powder", "Black beans", "Chipotle peppers", "Vegetable broth", "Lime juice", "Avocado" ]
            , test "the parenthetical can size does not eat the food" <|
                \_ ->
                    (parse loveAndLemons).ingredients
                        |> List.member "Black beans"
                        |> Expect.equal True
            ]
        , describe "King Arthur (weights+volumes, subsections, duplicates)"
            [ test "name" <|
                \_ -> (parse kingArthur).name |> Expect.equal "Whole Grain Banana Bread"
            , test "ingredients" <|
                \_ ->
                    (parse kingArthur).ingredients
                        |> Expect.equal
                            [ "Banana", "Vegetable oil", "Dark brown sugar", "Eggs", "King Arthur Pure Vanilla Extract", "King Arthur Unbleached All-Purpose Flour", "Baking soda", "Cinnamon", "Walnuts", "Granulated sugar" ]
            , test "subsection labels yield no chips" <|
                \_ ->
                    (parse kingArthur).ingredients
                        |> List.filter (\c -> c == "Batter" || c == "Topping")
                        |> Expect.equal []
            ]
        , describe "Minimalist Baker (ALL-CAPS sections, ranges, fused units)"
            [ test "name" <|
                \_ -> (parse minimalistBaker).name |> Expect.equal "1-Pot Chickpea Shakshuka"
            , test "ingredients" <|
                \_ ->
                    (parse minimalistBaker).ingredients
                        |> Expect.equal
                            [ "Avocado oil", "Shallots", "Garlic", "Tomatoes", "Tomato paste", "Maple syrup", "Sea salt", "Smoked paprika", "Cumin", "Chickpeas", "Lemon wedges", "Cilantro" ]
            , test "dash steps after the header are not chips" <|
                \_ ->
                    (parse minimalistBaker).ingredients
                        |> List.filter (String.contains "skillet")
                        |> Expect.equal []
            ]
        , describe "Directions style (yield noise, Step N labels)"
            [ test "name skips nothing — the title is the first line" <|
                \_ -> (parse directionsStyle).name |> Expect.equal "Easy Vegetable Soup"
            , test "yield lines produce no chips" <|
                \_ ->
                    (parse directionsStyle).ingredients
                        |> Expect.equal
                            [ "Olive oil", "Onions", "Tomatoes", "Vegetable broth", "Spinach", "Salt and pepper" ]
            , test "Step labels stay in the instructions" <|
                \_ ->
                    (parse directionsStyle).instructions
                        |> String.contains "Step 2"
                        |> Expect.equal True
            ]
        , describe "hand-typed minimal (no headers, bullets only)"
            [ test "name" <|
                \_ -> (parse handTyped).name |> Expect.equal "Grandma's Greens"
            , test "bulleted foods become canonical chips" <|
                \_ ->
                    (parse handTyped).ingredients
                        |> Expect.equal [ "Olive oil", "Kale", "Garlic", "Lemons" ]
            ]
        , describe "email/markdown (asterisks, Method:, juice-of)"
            [ test "the forwarded subject becomes the name, warts and all" <|
                \_ -> (parse emailStyle).name |> Expect.equal "FWD: best hummus ever"
            , test "ingredients, including juice of 1 lemon" <|
                \_ ->
                    (parse emailStyle).ingredients
                        |> Expect.equal [ "Chickpeas", "Tahini", "Lemons", "Garlic" ]
            ]
        , describe "leading articles and spelled-out counts"
            [ test "a pinch of salt is salt" <|
                \_ -> chip "A pinch of salt" |> Expect.equal "Salt"
            , test "a handful of a food is the food" <|
                \_ -> chip "A handful of spinach" |> Expect.equal "Spinach"
            , test "the juice of a numbered lemon is the lemon" <|
                \_ -> chip "The juice of 1 lemon" |> Expect.equal "Lemons"
            , test "the zest of a spelled-out count is the food" <|
                \_ -> chip "The zest of one lemon" |> Expect.equal "Lemons"
            , test "a spelled-out count leads like a digit" <|
                \_ -> chip "two lemons" |> Expect.equal "Lemons"
            , test "an article between a count and its food is dropped" <|
                \_ -> chip "half a lemon" |> Expect.equal "Lemons"
            ]
        , describe "export round-trip"
            [ test "an exported recipe re-parses to the same chips" <|
                \_ ->
                    let
                        recipe =
                            { id = "r1"
                            , name = "Hummus"
                            , category = "Sauces & Condiments"
                            , ingredients =
                                [ { id = "i1", name = "Chickpeas", na = False, count = 1 }
                                , { id = "i2", name = "Tahini", na = False, count = 1 }
                                , { id = "i3", name = "Extra-virgin olive oil", na = False, count = 1 }
                                , { id = "i4", name = "Lemon juice", na = False, count = 1 }
                                , { id = "i5", name = "Garlic", na = False, count = 1 }
                                ]
                            , instructions = "Blend everything until smooth."
                            , bookmarked = False
                            , tags = [ "Mediterranean", "Quick" ]
                            }

                        reparsed =
                            parse (RecipeExport.recipeText recipe)
                    in
                    ( reparsed.name, reparsed.ingredients )
                        |> Expect.equal
                            ( "Hummus"
                            , [ "Chickpeas", "Tahini", "Extra-virgin olive oil", "Lemon juice", "Garlic" ]
                            )
            ]
        ]
