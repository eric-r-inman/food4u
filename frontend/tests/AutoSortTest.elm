module AutoSortTest exposing (suite)

{-| Auto-sorting the Shopping List into grocery departments: the catalog
default files an item out of the reserved bucket, a user's re-target
override wins over the default, and re-targeting a pane points every item
now inside it back at that pane.
-}

import Data exposing (Card, Data, Food, autoSortCart, retargetPane)
import Expect
import Test exposing (Test, describe, test)


food : String -> String -> Food
food name department =
    { id = "f-" ++ name
    , name = name
    , prep = "F"
    , hero = False
    , na = False
    , recipeId = ""
    , department = department
    }


item : String -> String -> Data.Item
item id name =
    { id = id, name = name, na = False, count = 1 }


card : String -> String -> String -> List Data.Item -> Card
card id name zone items =
    { id = id
    , name = name
    , meta = ""
    , rail = ""
    , line = ""
    , note = ""
    , zone = zone
    , items = items
    }


{-| A kitchen whose catalog knows Kale (Produce) and Oats (Canned & Dry
Goods), with the reserved bucket holding kale, oats, and an off-catalog
custom item, plus two department panes and an unrelated kitchen pane.
-}
base : Data
base =
    { tiers =
        [ { id = "t1"
          , no = "1"
          , name = "Foundation"
          , freq = ""
          , width = ""
          , rail = ""
          , tint = ""
          , line = ""
          , groups =
                [ { id = "g1"
                  , label = "Greens"
                  , foods = [ food "Kale" "Produce", food "Oats" "Canned & Dry Goods" ]
                  }
                ]
          }
        ]
    , staples =
        [ card "cart" "Shopping List" "shopping" [ item "i1" "Kale", item "i2" "Oats", item "i3" "Birthday candles" ]
        , card "produce" "Produce" "shopping" []
        , card "dry" "Canned & Dry Goods" "shopping" [ item "i4" "Quinoa" ]
        , card "pantry" "Pantry" "kitchen" [ item "i5" "Kale" ]
        ]
    , recipes = []
    , planner = []
    , plannerDays = 7
    , columnOrder = []
    , sortTargets = []
    }


itemNames : String -> Data -> List String
itemNames cardId data =
    data.staples
        |> List.filter (\c -> c.id == cardId)
        |> List.concatMap .items
        |> List.map .name


suite : Test
suite =
    describe "shopping list auto-sort"
        [ describe "autoSortCart"
            [ test "files items into their department panes" <|
                \_ ->
                    autoSortCart base
                        |> Expect.all
                            [ itemNames "produce" >> Expect.equal [ "Kale" ]
                            , itemNames "dry" >> Expect.equal [ "Quinoa", "Oats" ]
                            ]
            , test "an item with no target stays on the bucket" <|
                \_ ->
                    autoSortCart base
                        |> itemNames "cart"
                        |> Expect.equal [ "Birthday candles" ]
            , test "a user override beats the catalog default" <|
                \_ ->
                    { base | sortTargets = [ { name = "kale", department = "Canned & Dry Goods" } ] }
                        |> autoSortCart
                        |> itemNames "dry"
                        |> Expect.equal [ "Quinoa", "Kale", "Oats" ]
            , test "an override gives a custom item a home" <|
                \_ ->
                    { base | sortTargets = [ { name = "Birthday candles", department = "Produce" } ] }
                        |> autoSortCart
                        |> itemNames "produce"
                        |> Expect.equal [ "Kale", "Birthday candles" ]
            , test "a target naming no pane leaves the item put" <|
                \_ ->
                    { base | sortTargets = [ { name = "Birthday candles", department = "Party Supplies" } ] }
                        |> autoSortCart
                        |> itemNames "cart"
                        |> Expect.equal [ "Birthday candles" ]
            , test "kitchen panes are untouched" <|
                \_ ->
                    autoSortCart base
                        |> itemNames "pantry"
                        |> Expect.equal [ "Kale" ]
            ]
        , describe "retargetPane"
            [ test "points every item in the pane at the pane" <|
                \_ ->
                    retargetPane "dry" base
                        |> .sortTargets
                        |> Expect.equal [ { name = "Quinoa", department = "Canned & Dry Goods" } ]
            , test "replaces an earlier target for the same name" <|
                \_ ->
                    { base | sortTargets = [ { name = "quinoa", department = "Produce" } ] }
                        |> retargetPane "dry"
                        |> .sortTargets
                        |> Expect.equal [ { name = "Quinoa", department = "Canned & Dry Goods" } ]
            , test "round trip: retarget then auto-sort files the item back" <|
                \_ ->
                    { base
                        | staples =
                            base.staples
                                |> List.map
                                    (\c ->
                                        if c.id == "cart" then
                                            { c | items = c.items ++ [ item "i9" "Quinoa" ] }

                                        else
                                            c
                                    )
                    }
                        |> retargetPane "dry"
                        |> autoSortCart
                        |> itemNames "dry"
                        |> Expect.equal [ "Quinoa", "Oats", "Quinoa" ]
            ]
        ]
