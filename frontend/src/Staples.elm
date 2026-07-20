module Staples exposing
    ( Diet
    , diets
    , missingStaples
    )

{-| The Staples Tracker's auto-populate data: the longevity diets on
offer and each one's essential staples. The diets are exactly the five
the recipe collection is tagged with, so auto-stocking a diet and
filtering recipes speak the same vocabulary. Every staple name matches
its Longevity Foods catalog spelling exactly — a tracker chip only picks
up its tier tint, stock tracking, and shopping-list identity through
that name. The reasoning behind both lists lives in
`docs/staples-auto-populate.org`.
-}


type alias Diet =
    { name : String
    , staples : List String
    }


diets : List Diet
diets =
    [ { name = "Mediterranean"
      , staples =
            [ "Extra-virgin olive oil", "Chickpeas", "Lentils", "Farro", "Whole-wheat pasta", "Tomato paste", "Tomatoes, canned, diced", "Garlic", "Onions", "Capers", "Lemons", "Lemon juice", "Olives", "Almonds", "Walnuts", "Pine nuts", "Pistachios", "Tahini", "Greek yogurt", "Feta", "Sardines, canned", "Red wine vinegar", "Balsamic vinegar", "Apple cider vinegar", "Honey", "Oregano", "Basil", "Mint", "Parsley", "Cumin", "Smoked paprika" ]
      }
    , { name = "Blue Zone"
      , staples =
            [ "Black beans", "Chickpeas", "Fava beans", "Brown rice", "Oats", "Whole-grain corn tortillas", "Sweet potato", "Cabbage", "Carrots", "Edamame", "Garlic", "Onions", "Ginger", "Tofu", "Miso", "Tamari / soy sauce", "Toasted sesame oil", "Sesame seeds", "Rice vinegar", "Kimchi", "Nori", "Wakame", "Tomatoes, canned, diced", "Honey", "Bay leaves", "Walnuts", "Extra-virgin olive oil", "Green tea" ]
      }
    , { name = "MIND"
      , staples =
            [ "Blueberries", "Strawberries", "Chickpeas", "Peanut butter", "Whole-wheat pasta", "Oats", "Quinoa", "Farro", "Whole-grain bread", "Brown rice", "Black beans", "Lentils", "Walnuts", "Almonds", "Extra-virgin olive oil", "Salmon, canned", "Chicken", "Cinnamon", "Thyme", "Dates", "Honey", "Maple syrup", "Soy milk", "Vegetable broth", "Shiitake, dried" ]
      }
    , { name = "DASH"
      , staples =
            [ "Oats", "Brown rice", "Quinoa", "Whole-grain bread", "Black beans", "Kidney beans", "Lentils", "Banana", "Oranges", "Apples", "Limes", "Garlic", "Onions", "Broccoli", "Carrots", "Sweet potato", "Tomatoes, canned, diced", "Greek yogurt", "Almonds", "Pistachios", "Chicken", "Honey", "Cinnamon", "Cumin" ]
      }
    , { name = "Anti-Inflammatory"
      , staples =
            [ "Turmeric", "Ginger", "Cinnamon", "Cumin", "Garam masala", "Smoked paprika", "Garlic", "Black pepper", "Extra-virgin olive oil", "Coconut milk", "Lemon juice", "Salmon", "Sardines, canned", "Blueberries", "Tart cherries", "Onions", "Carrots", "Broccoli", "Brown rice", "Red lentils", "Tomatoes, canned, diced", "Walnuts", "Flaxseed", "Chia seeds", "Green tea" ]
      }
    ]


{-| The staples a diet would add to a tracker already holding the given
names: the diet's list minus anything present case-insensitively, in the
diet's order. Unknown diet names add nothing. Re-running a diet is a
no-op, and stacking overlapping diets yields their union.
-}
missingStaples : List String -> String -> List String
missingStaples existingNames dietName =
    let
        existing =
            List.map String.toLower existingNames
    in
    diets
        |> List.filter (\d -> d.name == dietName)
        |> List.concatMap .staples
        |> List.filter (\name -> not (List.member (String.toLower name) existing))
