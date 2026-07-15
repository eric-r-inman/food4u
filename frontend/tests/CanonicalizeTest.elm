module CanonicalizeTest exposing (suite)

{-| Parsed ingredient names must resolve against the food catalog: exact
matches adopt the catalog's casing, and whole-name singular/plural pairs
fold together — but similar names must never merge. A chip that resolves
keeps its tier tint, stock tracking, and shopping-list identity; a false
merge would corrupt them.
-}

import Expect
import RecipeParser exposing (parsePastedRecipe)
import Test exposing (Test, describe, test)


{-| A slice of the real catalog: every name below exists in the shipped
seed, chosen to cover the plural shapes and the dangerous near-misses.
-}
catalog : List String
catalog =
    [ "Tomatoes"
    , "Carrots"
    , "Dates"
    , "Date syrup"
    , "Avocado"
    , "Sweet potato"
    , "Lemons"
    , "Chickpeas"
    , "Cherries"
    , "Berries"
    , "Extra-virgin olive oil"
    , "Olives"
    , "Coconut"
    , "Coconut milk"
    , "Green onions"
    , "Onions"
    , "Lentils"
    , "Red lentils"
    , "Saffron"
    , "Hummus"
    , "Jalapeños"
    ]


{-| Parse a single pasted ingredient bullet and return its chip name.
-}
chipFor : String -> String
chipFor line =
    parsePastedRecipe catalog ("Test\n\nIngredients:\n- " ++ line)
        |> .ingredients
        |> List.head
        |> Maybe.withDefault "(no chip)"


suite : Test
suite =
    describe "catalog canonicalization"
        [ describe "exact matches adopt catalog casing"
            [ test "lowercase" <|
                \_ -> chipFor "2 tomatoes" |> Expect.equal "Tomatoes"
            , test "uppercase" <|
                \_ -> chipFor "EXTRA-VIRGIN OLIVE OIL" |> Expect.equal "Extra-virgin olive oil"
            , test "already canonical" <|
                \_ -> chipFor "1 cup cherries" |> Expect.equal "Cherries"
            ]
        , describe "singular in the paste, plural in the catalog"
            [ test "tomato folds to Tomatoes" <|
                \_ -> chipFor "1 large tomato" |> Expect.equal "Tomatoes"
            , test "carrot folds to Carrots" <|
                \_ -> chipFor "1 carrot" |> Expect.equal "Carrots"
            , test "date folds to Dates" <|
                \_ -> chipFor "1 date" |> Expect.equal "Dates"
            , test "chickpea folds to Chickpeas" <|
                \_ -> chipFor "1 cup chickpea" |> Expect.equal "Chickpeas"
            , test "berry folds to Berries" <|
                \_ -> chipFor "1 cup berry" |> Expect.equal "Berries"
            , test "jalapeño folds to Jalapeños" <|
                \_ -> chipFor "1 jalapeño" |> Expect.equal "Jalapeños"
            ]
        , describe "plural in the paste, singular in the catalog"
            [ test "avocados folds to Avocado" <|
                \_ -> chipFor "2 avocados" |> Expect.equal "Avocado"
            , test "sweet potatoes folds to Sweet potato" <|
                \_ -> chipFor "2 sweet potatoes" |> Expect.equal "Sweet potato"
            , test "lemons is already plural in the catalog" <|
                \_ -> chipFor "2 lemons" |> Expect.equal "Lemons"
            ]
        , describe "similar names must never merge"
            [ test "coconut milk stays distinct from Coconut" <|
                \_ -> chipFor "1 can coconut milk" |> Expect.equal "Coconut milk"
            , test "olive oil is not Olives" <|
                \_ -> chipFor "2 tbsp olive oil" |> Expect.equal "Olive oil"
            , test "date syrup stays distinct from Dates" <|
                \_ -> chipFor "1 tbsp date syrup" |> Expect.equal "Date syrup"
            , test "green onions stay distinct from Onions" <|
                \_ -> chipFor "2 green onions" |> Expect.equal "Green onions"
            , test "red lentils stay distinct from Lentils" <|
                \_ -> chipFor "1 cup red lentils" |> Expect.equal "Red lentils"
            ]
        , describe "unknown foods pass through untouched"
            [ test "unknown name keeps its parsed form" <|
                \_ -> chipFor "1 cup farro" |> Expect.equal "Farro"
            , test "the last-word fold must not force a partial match" <|
                \_ -> chipFor "6 saffron threads" |> Expect.equal "Saffron threads"
            , test "hummus is not mangled by the s-fold" <|
                \_ -> chipFor "3 tbsp hummus" |> Expect.equal "Hummus"
            ]
        , describe "dedup runs after canonicalization"
            [ test "tomato and Tomatoes collapse to one chip" <|
                \_ ->
                    parsePastedRecipe catalog "Test\n\nIngredients:\n- 1 tomato\n- 2 cups tomatoes"
                        |> .ingredients
                        |> Expect.equal [ "Tomatoes" ]
            ]
        ]
