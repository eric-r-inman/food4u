module PlannerExportTest exposing (suite)

{-| The Meal Planner text export must mirror the plan and then carry the
full text of every recipe it uses, each recipe listed once however many
times it is planned, so the downloaded file is enough to cook the week
from on its own.
-}

import Data exposing (Data)
import Expect
import Planner exposing (plannerText)
import Test exposing (Test, describe, test)


sampleData : Data
sampleData =
    { tiers = []
    , staples = []
    , recipes =
        [ { id = "r1"
          , name = "Oatmeal"
          , category = "Breakfast"
          , ingredients = [ { id = "i1", name = "Oats", na = False, count = 1 } ]
          , instructions = "Cook the oats."
          , bookmarked = False
          , tags = []
          }
        , { id = "r2"
          , name = "Big Salad"
          , category = "Salads"
          , ingredients = [ { id = "i2", name = "Greens", na = False, count = 1 } ]
          , instructions = "Toss."
          , bookmarked = False
          , tags = [ "Quick" ]
          }
        ]
    , planner =
        [ { id = "e1", day = 0, meal = "Breakfast", recipeId = "r1" }
        , { id = "e2", day = 0, meal = "Lunch", recipeId = "r2" }
        , { id = "e3", day = 1, meal = "Breakfast", recipeId = "r1" }
        ]
    , plannerDays = 2
    , columnOrder = []
    }


emptyData : Data
emptyData =
    { tiers = [], staples = [], recipes = [], planner = [], plannerDays = 3, columnOrder = [] }


occurrences : String -> String -> Int
occurrences needle haystack =
    List.length (String.indexes needle haystack)


suite : Test
suite =
    describe "meal plan export"
        [ test "the schedule lists the planned days and their meals" <|
            \_ ->
                plannerText sampleData
                    |> Expect.all
                        [ \s -> String.contains "MEAL PLAN" s |> Expect.equal True
                        , \s -> String.contains "Day 1" s |> Expect.equal True
                        , \s -> String.contains "Day 2" s |> Expect.equal True
                        , \s -> String.contains "Breakfast:" s |> Expect.equal True
                        , \s -> String.contains "Oatmeal" s |> Expect.equal True
                        , \s -> String.contains "Big Salad" s |> Expect.equal True
                        ]
        , test "the appendix carries each used recipe's full text" <|
            \_ ->
                plannerText sampleData
                    |> Expect.all
                        [ \s -> String.contains "RECIPES" s |> Expect.equal True
                        , \s -> String.contains "Ingredients\n- Oats" s |> Expect.equal True
                        , \s -> String.contains "Instructions\nCook the oats." s |> Expect.equal True
                        , \s -> String.contains "Ingredients\n- Greens" s |> Expect.equal True
                        ]
        , test "a recipe planned more than once appears once in the appendix" <|
            \_ ->
                -- Two distinct recipes are joined by exactly one divider rule.
                plannerText sampleData
                    |> occurrences (String.repeat 40 "-")
                    |> Expect.equal 1
        , test "an empty plan says so and prints no recipes section" <|
            \_ ->
                plannerText emptyData
                    |> Expect.all
                        [ \s -> String.contains "Nothing planned yet." s |> Expect.equal True
                        , \s -> String.contains "RECIPES" s |> Expect.equal False
                        ]
        ]
