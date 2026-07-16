module IdsTest exposing (suite)

{-| The id sequence must resume past every id in the model, meal-plan
entries included — they are minted like any other id. Missing a collection
lets the counter resume atop its ids and mint a duplicate, which the
relational store rejects on save (the bug this guards against).
-}

import Data exposing (Data)
import Expect
import Ids exposing (nextSeq)
import Test exposing (Test, describe, test)


emptyData : Data
emptyData =
    { tiers = [], staples = [], recipes = [], planner = [], plannerDays = 7, columnOrder = [] }


suite : Test
suite =
    describe "id sequence"
        [ test "an empty model starts at zero" <|
            \_ ->
                nextSeq emptyData |> Expect.equal 0
        , test "resumes past a meal-plan entry's id" <|
            \_ ->
                -- The only minted id in the model is a planner entry's, so
                -- the next id must land above it rather than collide.
                nextSeq { emptyData | planner = [ { id = "u500", day = 0, meal = "Breakfast", recipeId = "r1" } ] }
                    |> Expect.equal 501
        , test "planner ids are weighed against the rest, highest winning" <|
            \_ ->
                nextSeq
                    { emptyData
                        | recipes =
                            [ { id = "u10"
                              , name = "Soup"
                              , category = "Soups"
                              , ingredients = []
                              , instructions = ""
                              , bookmarked = False
                              , tags = []
                              }
                            ]
                        , planner = [ { id = "u20", day = 0, meal = "Lunch", recipeId = "u10" } ]
                    }
                    |> Expect.equal 21
        ]
