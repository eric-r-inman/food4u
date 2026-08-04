module CountTest exposing (suite)

{-| The item count a parsed chip carries. A leading number counts items
when it counts something purchasable — the food itself or a discrete
unit like cans or cloves — and counts nothing when it measures volume
or weight, where the chip stays a single item however much the recipe
uses.
-}

import Expect
import RecipeParser exposing (parsePastedRecipe)
import Test exposing (Test, describe, test)


catalog : List String
catalog =
    [ "Bell peppers, red"
    , "Black beans, canned"
    , "Garlic clove"
    , "Lemons"
    , "Spinach"
    , "Onion, yellow"
    , "Oats"
    , "Whole-grain bread"
    , "Extra-virgin olive oil"
    , "Carrot"
    ]


{-| Parse one pasted ingredient bullet and return its chip's count.
-}
countFor : String -> Int
countFor line =
    parsePastedRecipe catalog ("Test\n\nIngredients:\n- " ++ line)
        |> .ingredients
        |> List.head
        |> Maybe.map .count
        |> Maybe.withDefault 0


suite : Test
suite =
    describe "chip item counts"
        [ describe "a number on the food counts items"
            [ test "3 red bell peppers" <|
                \_ -> countFor "3 red bell peppers" |> Expect.equal 3
            , test "2 lemons" <|
                \_ -> countFor "2 lemons" |> Expect.equal 2
            , test "spelled-out count" <|
                \_ -> countFor "two lemons" |> Expect.equal 2
            , test "count survives prep words" <|
                \_ -> countFor "3 large ripe lemons" |> Expect.equal 3
            , test "a range buys its larger end" <|
                \_ -> countFor "1-2 lemons" |> Expect.equal 2
            , test "a trailing half rounds up" <|
                \_ -> countFor "1½ lemons" |> Expect.equal 2
            ]
        , describe "a number on a purchasable unit counts items"
            [ test "2 cans black beans" <|
                \_ -> countFor "2 (15-ounce) cans black beans, rinsed" |> Expect.equal 2
            , test "4 cloves garlic" <|
                \_ -> countFor "4 cloves garlic, minced" |> Expect.equal 4
            , test "2 slices whole-grain bread" <|
                \_ -> countFor "2 slices whole-grain bread" |> Expect.equal 2
            ]
        , describe "a number on a measure counts nothing"
            [ test "2 cups spinach" <|
                \_ -> countFor "2 cups chopped spinach" |> Expect.equal 1
            , test "400g oats" <|
                \_ -> countFor "400g oats" |> Expect.equal 1
            , test "3 tbsp olive oil" <|
                \_ -> countFor "3 tbsp extra-virgin olive oil" |> Expect.equal 1
            ]
        , describe "no number is one item"
            [ test "bare food" <|
                \_ -> countFor "spinach, rinsed" |> Expect.equal 1
            , test "a fraction is one item" <|
                \_ -> countFor "½ yellow onion" |> Expect.equal 1
            , test "juice of 1 lemon is one lemon" <|
                \_ -> countFor "juice of 1 lemon" |> Expect.equal 1
            ]
        ]
