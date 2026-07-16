module Ids exposing
    ( nextId
    , nextSeq
    )

{-| Minting model ids and resuming the id sequence. Every id the app mints
has the form `u<n>`; ids from the seed carry other prefixes. Resuming one
past the highest minted id keeps a freshly minted id from colliding with a
persisted one — a collision the relational store rejects.
-}

import Data exposing (Data)


{-| The id for sequence position `seq`.
-}
nextId : Int -> String
nextId seq =
    "u" ++ String.fromInt seq


{-| The id sequence to resume from for a freshly loaded model: one past the
highest `u<n>` id already in use. Every id the app mints has the form
`u<n>`, so starting here guarantees new ids do not collide with persisted
ones — a collision the relational store rejects.
-}
nextSeq : Data -> Int
nextSeq data =
    modelIds data
        |> List.filterMap mintedIdNumber
        |> List.maximum
        |> Maybe.map (\n -> n + 1)
        |> Maybe.withDefault 0


{-| Every id in the model: the pyramid, the storage panes and their items,
the recipes and their ingredients, and the meal-plan entries. A collection
missed here is invisible to `nextSeq`, so the counter can resume atop its
ids and mint a duplicate — keep this exhaustive.
-}
modelIds : Data -> List String
modelIds data =
    let
        groups =
            List.concatMap .groups data.tiers
    in
    List.concat
        [ List.map .id data.tiers
        , List.map .id groups
        , groups |> List.concatMap .foods |> List.map .id
        , List.map .id data.staples
        , data.staples |> List.concatMap .items |> List.map .id
        , List.map .id data.recipes
        , data.recipes |> List.concatMap .ingredients |> List.map .id
        , List.map .id data.planner
        ]


{-| The numeric part of an id the app minted (`u<n>`); Nothing for ids from
other sources, such as the seed's `d<n>`.
-}
mintedIdNumber : String -> Maybe Int
mintedIdNumber id =
    if String.startsWith "u" id then
        String.toInt (String.dropLeft 1 id)

    else
        Nothing
