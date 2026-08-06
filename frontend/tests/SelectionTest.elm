module SelectionTest exposing (suite)

{-| Shift-clicking an item badge in select mode toggles its whole
category: everything at the badge's location becomes selected, or — when
every item there already is — everything becomes unselected, without
disturbing selections made elsewhere.
-}

import Data exposing (Data, Loc(..), selKey, toggleLocSelection)
import Expect
import Set
import Test exposing (Test, describe, test)


food : String -> Data.Food
food id =
    { id = id
    , name = id
    , prep = "F"
    , hero = False
    , na = False
    , recipeId = ""
    , department = ""
    }


item : String -> Data.Item
item id =
    { id = id, name = id, na = False, count = 1 }


{-| A kitchen with a two-food pyramid group, a two-item storage pane, an
empty pane, and a one-ingredient recipe — one location of each kind.
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
                  , foods = [ food "f1", food "f2" ]
                  }
                ]
          }
        ]
    , staples =
        [ { id = "pane"
          , name = "Pantry"
          , meta = ""
          , rail = ""
          , line = ""
          , note = ""
          , zone = "kitchen"
          , items = [ item "i1", item "i2" ]
          }
        , { id = "empty"
          , name = "Bare shelf"
          , meta = ""
          , rail = ""
          , line = ""
          , note = ""
          , zone = "kitchen"
          , items = []
          }
        ]
    , recipes =
        [ { id = "r1"
          , name = "Soup"
          , category = ""
          , ingredients = [ item "i3" ]
          , instructions = ""
          , bookmarked = False
          , tags = []
          }
        ]
    , planner = []
    , plannerDays = 7
    , columnOrder = []
    , sortTargets = []
    }


suite : Test
suite =
    describe "toggleLocSelection"
        [ test "selects every item in an unselected category" <|
            \_ ->
                toggleLocSelection (PyramidGroup "g1") base Set.empty
                    |> Expect.equal
                        (Set.fromList
                            [ selKey (PyramidGroup "g1") "f1"
                            , selKey (PyramidGroup "g1") "f2"
                            ]
                        )
        , test "completes a partially selected category" <|
            \_ ->
                Set.singleton (selKey (StoragePane "pane") "i1")
                    |> toggleLocSelection (StoragePane "pane") base
                    |> Expect.equal
                        (Set.fromList
                            [ selKey (StoragePane "pane") "i1"
                            , selKey (StoragePane "pane") "i2"
                            ]
                        )
        , test "unselects a fully selected category" <|
            \_ ->
                Set.fromList
                    [ selKey (StoragePane "pane") "i1"
                    , selKey (StoragePane "pane") "i2"
                    ]
                    |> toggleLocSelection (StoragePane "pane") base
                    |> Expect.equal Set.empty
        , test "leaves selections at other locations alone" <|
            \_ ->
                Set.singleton (selKey (RecipeIngredients "r1") "i3")
                    |> toggleLocSelection (PyramidGroup "g1") base
                    |> Set.member (selKey (RecipeIngredients "r1") "i3")
                    |> Expect.equal True
        , test "an empty location changes nothing" <|
            \_ ->
                Set.singleton (selKey (StoragePane "pane") "i1")
                    |> toggleLocSelection (StoragePane "empty") base
                    |> Expect.equal (Set.singleton (selKey (StoragePane "pane") "i1"))
        , test "a recipe's ingredients toggle as a category" <|
            \_ ->
                toggleLocSelection (RecipeIngredients "r1") base Set.empty
                    |> Expect.equal (Set.singleton (selKey (RecipeIngredients "r1") "i3"))
        ]
