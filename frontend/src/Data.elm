module Data exposing
    ( Card
    , Data
    , Food
    , Group
    , Item
    , Loc(..)
    , Recipe
    , Tier
    , dataDecoder
    , encodeData
    , foodInGroup
    , itemInStorage
    , listHasName
    , mapCard
    , mapGroup
    , mapRecipe
    , mapStorage
    , pushFood
    , pushItemTo
    , pyramidHasName
    , removeFood
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


type alias Data =
    { tiers : List Tier
    , staples : List Card
    , recipes : List Recipe
    }


type alias Recipe =
    { id : String
    , name : String
    , category : String
    , ingredients : List Item
    , instructions : String
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


dataDecoder : Decoder Data
dataDecoder =
    Decode.map3 Data
        (Decode.field "tiers" (Decode.list tierDecoder))
        (Decode.field "staples" (Decode.list cardDecoder))
        -- "recipes" is absent in older saved data; default to empty.
        (Decode.oneOf
            [ Decode.field "recipes" (Decode.list recipeDecoder)
            , Decode.succeed []
            ]
        )


recipeDecoder : Decoder Recipe
recipeDecoder =
    Decode.map5 Recipe
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
    Decode.map7 Card
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "meta" Decode.string)
        (Decode.field "rail" Decode.string)
        (Decode.field "line" Decode.string)
        (Decode.field "note" Decode.string)
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
        ]


encodeRecipe : Recipe -> Encode.Value
encodeRecipe recipe =
    Encode.object
        [ ( "id", Encode.string recipe.id )
        , ( "name", Encode.string recipe.name )
        , ( "category", Encode.string recipe.category )
        , ( "ingredients", Encode.list encodeItem recipe.ingredients )
        , ( "instructions", Encode.string recipe.instructions )
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
