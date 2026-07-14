module Data exposing
    ( Card
    , Data
    , Food
    , Group
    , Item
    , Loc(..)
    , PlannerEntry
    , Recipe
    , Tier
    , cartZone
    , dataDecoder
    , encodeData
    , foodInGroup
    , isShoppingCard
    , itemInStorage
    , listHasName
    , mapCard
    , mapGroup
    , mapRecipe
    , mapStorage
    , moveRecipeBefore
    , moveRecipeToCategoryEnd
    , parseSelKey
    , pushFood
    , pushGroup
    , pushItemTo
    , pyramidHasName
    , removeFood
    , removeGroup
    , selKey
    , shoppingCartName
    , staplesTrackerId
    , staplesTrackerName
    )

{-| The food model's schema and its JSON serialization. The model is a
single document owned by the frontend; the server persists it verbatim,
so the decoders and encoders here are the only definition of its wire
shape. Older saved documents are tolerated: fields added over time
decode to sensible defaults rather than failing the whole load.
-}

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


{-| The reserved name of the Shopping List storage card. It is a to-buy
list rather than a real kitchen pane, so several queries treat it
specially.
-}
shoppingCartName : String
shoppingCartName =
    "Shopping List"


{-| The reserved name of the Staples Tracker pane: a permanent kitchen
pane holding the foods the user always wants on hand. Like the Shopping
List it is a storage card treated specially, so several queries single it
out by name.
-}
staplesTrackerName : String
staplesTrackerName =
    "Staples Tracker"


{-| The fixed id of the Staples Tracker card, so the frontend can create
it once when absent and always address the same pane.
-}
staplesTrackerId : String
staplesTrackerId =
    "staples-tracker"


{-| The `zone` a storage card carries when it belongs to the Shopping List
column's own categories rather than the Kitchen. Kitchen panes default to
`"kitchen"`.
-}
cartZone : String
cartZone =
    "shopping"


{-| Whether a storage card belongs to the Shopping List column: the
reserved Shopping List card (identified by its name, so documents predating
the zone still resolve it) or one of its user-added categories.
-}
isShoppingCard : Card -> Bool
isShoppingCard card =
    card.name == shoppingCartName || card.zone == cartZone


type alias Data =
    { tiers : List Tier
    , staples : List Card
    , recipes : List Recipe

    -- The Meal Planner's slots. Absent in older saved data.
    , planner : List PlannerEntry
    }


{-| One recipe planned into a Meal Planner slot: a copy-by-reference of the
recipe (the recipe itself stays in the Recipes column) placed under one
meal of one day. `day` counts from Sunday as zero. The entry has its own
id so the same recipe can be planned many times.
-}
type alias PlannerEntry =
    { id : String
    , day : Int
    , meal : String
    , recipeId : String
    }


type alias Recipe =
    { id : String
    , name : String
    , category : String
    , ingredients : List Item
    , instructions : String

    -- A user marker to remember a recipe, e.g. one whose ingredients were
    -- just sent to the Shopping List. Absent in older saved data.
    , bookmarked : Bool

    -- Free-form user labels for filtering the recipe list, entered by hand.
    -- Absent in older saved data.
    , tags : List String
    }


type alias Tier =
    { id : String
    , no : String
    , name : String
    , freq : String
    , width : String
    , rail : String
    , tint : String
    , line : String
    , groups : List Group
    }


type alias Group =
    { id : String
    , label : String
    , foods : List Food
    }


type alias Food =
    { id : String
    , name : String
    , prep : String
    , hero : Bool
    , na : Bool

    -- Id of a recipe this food is linked to ("" when none). Set by
    -- dragging a recipe onto the food's pyramid category.
    , recipeId : String
    }


type alias Card =
    { id : String
    , name : String
    , meta : String
    , rail : String
    , line : String
    , note : String

    -- Which column the card belongs to: "kitchen" for a Kitchen pane,
    -- "shopping" for one of the Shopping List's categories. Absent in
    -- documents predating the field; defaults to "kitchen".
    , zone : String
    , items : List Item
    }


type alias Item =
    { id : String
    , name : String
    , na : Bool
    }


{-| A location identifies the list a food lives in — a pyramid group
(left, not a drop target), a storage pane's in-stock list, or a recipe's
ingredient list. The strings are the owning record's id.
-}
type Loc
    = PyramidGroup String
    | StoragePane String
    | RecipeIngredients String


{-| A stable key identifying one draggable item at one location, for the
selection set. A food can appear in several locations under different ids,
so the key pairs the location with the item id. The `|` separator is safe:
ids are alphanumeric with hyphens, never that character.
-}
selKey : Loc -> String -> String
selKey loc itemId =
    (case loc of
        PyramidGroup gid ->
            "P|" ++ gid

        StoragePane cid ->
            "S|" ++ cid

        RecipeIngredients rid ->
            "R|" ++ rid
    )
        ++ "|"
        ++ itemId


{-| Recover the location and item id a selection key was built from.
-}
parseSelKey : String -> Maybe ( Loc, String )
parseSelKey key =
    case String.split "|" key of
        [ "P", locId, itemId ] ->
            Just ( PyramidGroup locId, itemId )

        [ "S", locId, itemId ] ->
            Just ( StoragePane locId, itemId )

        [ "R", locId, itemId ] ->
            Just ( RecipeIngredients locId, itemId )

        _ ->
            Nothing


dataDecoder : Decoder Data
dataDecoder =
    Decode.map4 Data
        (Decode.field "tiers" (Decode.list tierDecoder))
        (Decode.field "staples" (Decode.list cardDecoder))
        -- "recipes" is absent in older saved data; default to empty.
        (Decode.oneOf
            [ Decode.field "recipes" (Decode.list recipeDecoder)
            , Decode.succeed []
            ]
        )
        -- "planner" is absent in older saved data; default to empty.
        (Decode.oneOf
            [ Decode.field "planner" (Decode.list plannerEntryDecoder)
            , Decode.succeed []
            ]
        )


plannerEntryDecoder : Decoder PlannerEntry
plannerEntryDecoder =
    Decode.map4 PlannerEntry
        (Decode.field "id" Decode.string)
        (Decode.field "day" Decode.int)
        (Decode.field "meal" Decode.string)
        (Decode.field "recipeId" Decode.string)


recipeDecoder : Decoder Recipe
recipeDecoder =
    Decode.map7 Recipe
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "category" Decode.string)
        (Decode.field "ingredients" (Decode.list itemDecoder))
        -- "instructions" is absent in older saved data; default to empty.
        (Decode.oneOf
            [ Decode.field "instructions" Decode.string
            , Decode.succeed ""
            ]
        )
        -- "bookmarked" is absent in older saved data; default to false.
        (Decode.oneOf
            [ Decode.field "bookmarked" Decode.bool
            , Decode.succeed False
            ]
        )
        -- "tags" is absent in older saved data; default to none.
        (Decode.oneOf
            [ Decode.field "tags" (Decode.list Decode.string)
            , Decode.succeed []
            ]
        )


tierDecoder : Decoder Tier
tierDecoder =
    Decode.map2 (<|)
        (Decode.map8 Tier
            (Decode.field "id" Decode.string)
            (Decode.field "no" Decode.string)
            (Decode.field "name" Decode.string)
            (Decode.field "freq" Decode.string)
            (Decode.field "width" Decode.string)
            (Decode.field "rail" Decode.string)
            (Decode.field "tint" Decode.string)
            (Decode.field "line" Decode.string)
        )
        (Decode.field "groups" (Decode.list groupDecoder))


groupDecoder : Decoder Group
groupDecoder =
    Decode.map3 Group
        (Decode.field "id" Decode.string)
        (Decode.field "label" Decode.string)
        (Decode.field "foods" (Decode.list foodDecoder))


foodDecoder : Decoder Food
foodDecoder =
    Decode.map6 Food
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "prep" Decode.string)
        (Decode.field "hero" Decode.bool)
        (Decode.field "na" Decode.bool)
        -- "recipeId" is absent in older saved data; default to none.
        (Decode.oneOf
            [ Decode.field "recipeId" Decode.string
            , Decode.succeed ""
            ]
        )


cardDecoder : Decoder Card
cardDecoder =
    Decode.map8 Card
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "meta" Decode.string)
        (Decode.field "rail" Decode.string)
        (Decode.field "line" Decode.string)
        (Decode.field "note" Decode.string)
        -- "zone" is absent in older saved data; default to a kitchen pane.
        (Decode.oneOf
            [ Decode.field "zone" Decode.string
            , Decode.succeed "kitchen"
            ]
        )
        (Decode.field "items" (Decode.list itemDecoder))


itemDecoder : Decoder Item
itemDecoder =
    Decode.map3 Item
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "na" Decode.bool)


encodeData : Data -> Encode.Value
encodeData data =
    Encode.object
        [ ( "tiers", Encode.list encodeTier data.tiers )
        , ( "staples", Encode.list encodeCard data.staples )
        , ( "recipes", Encode.list encodeRecipe data.recipes )
        , ( "planner", Encode.list encodePlannerEntry data.planner )
        ]


encodePlannerEntry : PlannerEntry -> Encode.Value
encodePlannerEntry entry =
    Encode.object
        [ ( "id", Encode.string entry.id )
        , ( "day", Encode.int entry.day )
        , ( "meal", Encode.string entry.meal )
        , ( "recipeId", Encode.string entry.recipeId )
        ]


encodeRecipe : Recipe -> Encode.Value
encodeRecipe recipe =
    Encode.object
        [ ( "id", Encode.string recipe.id )
        , ( "name", Encode.string recipe.name )
        , ( "category", Encode.string recipe.category )
        , ( "ingredients", Encode.list encodeItem recipe.ingredients )
        , ( "instructions", Encode.string recipe.instructions )
        , ( "bookmarked", Encode.bool recipe.bookmarked )
        , ( "tags", Encode.list Encode.string recipe.tags )
        ]


encodeTier : Tier -> Encode.Value
encodeTier tier =
    Encode.object
        [ ( "id", Encode.string tier.id )
        , ( "no", Encode.string tier.no )
        , ( "name", Encode.string tier.name )
        , ( "freq", Encode.string tier.freq )
        , ( "width", Encode.string tier.width )
        , ( "rail", Encode.string tier.rail )
        , ( "tint", Encode.string tier.tint )
        , ( "line", Encode.string tier.line )
        , ( "groups", Encode.list encodeGroup tier.groups )
        ]


encodeGroup : Group -> Encode.Value
encodeGroup group =
    Encode.object
        [ ( "id", Encode.string group.id )
        , ( "label", Encode.string group.label )
        , ( "foods", Encode.list encodeFood group.foods )
        ]


encodeFood : Food -> Encode.Value
encodeFood food =
    Encode.object
        [ ( "id", Encode.string food.id )
        , ( "name", Encode.string food.name )
        , ( "prep", Encode.string food.prep )
        , ( "hero", Encode.bool food.hero )
        , ( "na", Encode.bool food.na )
        , ( "recipeId", Encode.string food.recipeId )
        ]


encodeCard : Card -> Encode.Value
encodeCard card =
    Encode.object
        [ ( "id", Encode.string card.id )
        , ( "name", Encode.string card.name )
        , ( "meta", Encode.string card.meta )
        , ( "rail", Encode.string card.rail )
        , ( "line", Encode.string card.line )
        , ( "note", Encode.string card.note )
        , ( "zone", Encode.string card.zone )
        , ( "items", Encode.list encodeItem card.items )
        ]


encodeItem : Item -> Encode.Value
encodeItem item =
    Encode.object
        [ ( "id", Encode.string item.id )
        , ( "name", Encode.string item.name )
        , ( "na", Encode.bool item.na )
        ]



-- DATA OPERATIONS


mapGroup : String -> (Group -> Group) -> Data -> Data
mapGroup gid fn data =
    { data
        | tiers =
            List.map
                (\t ->
                    { t
                        | groups =
                            List.map
                                (\g ->
                                    if g.id == gid then
                                        fn g

                                    else
                                        g
                                )
                                t.groups
                    }
                )
                data.tiers
    }


mapCard : String -> (Card -> Card) -> Data -> Data
mapCard cid fn data =
    { data
        | staples =
            List.map
                (\c ->
                    if c.id == cid then
                        fn c

                    else
                        c
                )
                data.staples
    }


pushFood : String -> Food -> Data -> Data
pushFood gid food =
    mapGroup gid (\g -> { g | foods = g.foods ++ [ food ] })


{-| Append a new category (group) to the end of a pyramid tier's groups.
-}
pushGroup : String -> Group -> Data -> Data
pushGroup tierId group data =
    { data
        | tiers =
            List.map
                (\t ->
                    if t.id == tierId then
                        { t | groups = t.groups ++ [ group ] }

                    else
                        t
                )
                data.tiers
    }


{-| Remove a pyramid category (group) by id, wherever it lives, dropping its
foods with it.
-}
removeGroup : String -> Data -> Data
removeGroup gid data =
    { data
        | tiers =
            List.map
                (\t -> { t | groups = List.filter (\g -> g.id /= gid) t.groups })
                data.tiers
    }


mapRecipe : String -> (Recipe -> Recipe) -> Data -> Data
mapRecipe rid fn data =
    { data
        | recipes =
            List.map
                (\r ->
                    if r.id == rid then
                        fn r

                    else
                        r
                )
                data.recipes
    }


recipeById : String -> Data -> Maybe Recipe
recipeById rid data =
    data.recipes |> List.filter (\r -> r.id == rid) |> List.head


{-| Move the dragged recipe so it renders immediately before the target
recipe, adopting the target's category. A category shows its recipes in
`recipes` order, so re-sequencing the list is what repositions the card.
-}
moveRecipeBefore : String -> String -> Data -> Data
moveRecipeBefore draggedId targetId data =
    if draggedId == targetId then
        data

    else
        case ( recipeById draggedId data, recipeById targetId data ) of
            ( Just dragged, Just target ) ->
                { data
                    | recipes =
                        data.recipes
                            |> List.filter (\r -> r.id /= draggedId)
                            |> List.concatMap
                                (\r ->
                                    if r.id == targetId then
                                        [ { dragged | category = target.category }, r ]

                                    else
                                        [ r ]
                                )
                }

            _ ->
                data


{-| Move the dragged recipe to the end of a category's order, adopting
that category. Appending to `recipes` places it after every recipe
already in the category, so it renders last there.
-}
moveRecipeToCategoryEnd : String -> String -> Data -> Data
moveRecipeToCategoryEnd draggedId category data =
    case recipeById draggedId data of
        Just dragged ->
            { data
                | recipes =
                    List.filter (\r -> r.id /= draggedId) data.recipes
                        ++ [ { dragged | category = category } ]
            }

        Nothing ->
            data


{-| Apply a transform to the item list of a drop-target location (a
pane's in-stock list, its "Buy" list, or a recipe's ingredients).
Pyramid locations have no item list, so they are left untouched.
-}
mapStorage : Loc -> (List Item -> List Item) -> Data -> Data
mapStorage loc fn data =
    case loc of
        StoragePane cid ->
            mapCard cid (\c -> { c | items = fn c.items }) data

        RecipeIngredients rid ->
            mapRecipe rid (\r -> { r | ingredients = fn r.ingredients }) data

        PyramidGroup _ ->
            data


storageItemsAt : Loc -> Data -> List Item
storageItemsAt loc data =
    let
        atCard cid selector =
            data.staples |> List.filter (\c -> c.id == cid) |> List.concatMap selector
    in
    case loc of
        StoragePane cid ->
            atCard cid .items

        RecipeIngredients rid ->
            data.recipes |> List.filter (\r -> r.id == rid) |> List.concatMap .ingredients

        PyramidGroup _ ->
            []


pushItemTo : Loc -> Item -> Data -> Data
pushItemTo loc item =
    mapStorage loc (\items -> items ++ [ item ])


itemInStorage : Loc -> String -> Data -> Maybe Item
itemInStorage loc foodId data =
    storageItemsAt loc data |> List.filter (\i -> i.id == foodId) |> List.head


listHasName : Loc -> String -> Data -> Bool
listHasName loc name data =
    storageItemsAt loc data |> List.any (\i -> String.toLower i.name == String.toLower name)


removeFood : Loc -> String -> Data -> Data
removeFood loc foodId data =
    case loc of
        PyramidGroup gid ->
            mapGroup gid (\g -> { g | foods = List.filter (\f -> f.id /= foodId) g.foods }) data

        _ ->
            mapStorage loc (List.filter (\i -> i.id /= foodId)) data


foodInGroup : String -> String -> Data -> Maybe Food
foodInGroup gid foodId data =
    data.tiers
        |> List.concatMap .groups
        |> List.filter (\g -> g.id == gid)
        |> List.concatMap .foods
        |> List.filter (\f -> f.id == foodId)
        |> List.head


{-| Whether a food of this name already exists anywhere in the pyramid.
-}
pyramidHasName : String -> Data -> Bool
pyramidHasName name data =
    data.tiers
        |> List.concatMap .groups
        |> List.concatMap .foods
        |> List.any (\f -> String.toLower f.name == String.toLower name)
