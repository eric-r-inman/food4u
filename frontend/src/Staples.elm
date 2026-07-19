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
            [ "Extra-virgin olive oil", "Chickpeas", "Lentils", "Farro", "Whole-wheat pasta", "Tomato paste", "Garlic", "Onions", "Capers", "Lemons", "Olives", "Almonds", "Walnuts", "Greek yogurt", "Feta", "Canned sardines" ]
      }
    , { name = "Blue Zone"
      , staples =
            [ "Black beans", "Chickpeas", "Fava beans", "Brown rice", "Oats", "Whole-grain corn tortillas", "Sweet potato", "Cabbage", "Edamame", "Garlic", "Onions", "Tofu", "Miso", "Walnuts", "Extra-virgin olive oil", "Green tea" ]
      }
    , { name = "MIND"
      , staples =
            [ "Blueberries", "Strawberries", "Chickpeas", "Peanut butter", "Whole-wheat pasta", "Oats", "Quinoa", "Whole-grain bread", "Brown rice", "Black beans", "Lentils", "Walnuts", "Almonds", "Extra-virgin olive oil", "Canned salmon", "Chicken" ]
      }
    , { name = "DASH"
      , staples =
            [ "Oats", "Brown rice", "Whole-grain bread", "Black beans", "Kidney beans", "Lentils", "Banana", "Oranges", "Apples", "Onions", "Broccoli", "Carrots", "Sweet potato", "Greek yogurt", "Almonds", "Chicken" ]
      }
    , { name = "Anti-Inflammatory"
      , staples =
            [ "Turmeric", "Ginger", "Cinnamon", "Garlic", "Black pepper", "Extra-virgin olive oil", "Salmon", "Canned sardines", "Blueberries", "Tart cherries", "Onions", "Broccoli", "Walnuts", "Flaxseed", "Chia seeds", "Green tea" ]
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
