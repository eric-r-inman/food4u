module Derived exposing
    ( categoryRanks
    , inStockNames
    , itemRank
    , nameCategory
    , recipeMissing
    , stockedExcludingCart
    )

{-| Indices and lookups derived from the food model. These are pure
functions of the data, recomputed once per data change and cached on the
model (see Main's `Derived` record) so the views consult a precomputed
result rather than rescanning every food and storage item on each render.
-}

import Data exposing (Data, Item, Recipe, shoppingCartName)
import Dict exposing (Dict)
import Set exposing (Set)


{-| Map each pyramid food name (lowercased) to the category it belongs
to, so storage-pane items can be tinted to match the pyramid.
-}
nameCategory : Data -> Dict String String
nameCategory data =
    data.tiers
        |> List.concatMap .groups
        |> List.concatMap (\g -> List.map (\f -> ( String.toLower f.name, g.label )) g.foods)
        |> Dict.fromList


{-| Map each pyramid category label to its position in the pyramid, so
storage-pane items can be ordered the same way the categories appear on
the left.
-}
categoryRanks : Data -> Dict String Int
categoryRanks data =
    data.tiers
        |> List.concatMap .groups
        |> List.indexedMap (\i g -> ( g.label, i ))
        |> Dict.fromList


{-| The pyramid-category rank of a storage item, by name. Items with no
matching pyramid food sort to the end.
-}
itemRank : Dict String String -> Dict String Int -> Item -> Int
itemRank nameToCat ranks item =
    Dict.get (String.toLower item.name) nameToCat
        |> Maybe.andThen (\label -> Dict.get label ranks)
        |> Maybe.withDefault 100000


{-| Lowercased names of every food currently stocked in a storage pane.
-}
inStockNames : Data -> Set String
inStockNames data =
    data.staples
        |> List.concatMap .items
        |> List.map (\i -> String.toLower i.name)
        |> Set.fromList


{-| Lowercased names stocked in a real kitchen pane — excluding the
Shopping List, which is a to-buy list rather than something on hand.
-}
stockedExcludingCart : Data -> Set String
stockedExcludingCart data =
    data.staples
        |> List.filter (\c -> c.name /= shoppingCartName)
        |> List.concatMap .items
        |> List.map (\i -> String.toLower i.name)
        |> Set.fromList


{-| A recipe's ingredients that are not on hand in a kitchen pane — what
you'd still need to make it now.
-}
recipeMissing : Set String -> Recipe -> List Item
recipeMissing stockedNoCart recipe =
    List.filter (\i -> not (Set.member (String.toLower i.name) stockedNoCart)) recipe.ingredients
