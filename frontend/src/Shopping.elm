module Shopping exposing
    ( cartCardId
    , groupByDepartment
    , shoppingListText
    )

{-| The Shopping List's grocery-department logic: which department each
food belongs to, how to group a to-buy list into aisle-ordered sections,
and how to render it as plain text for export.
-}

import Data exposing (Data, Item, shoppingCartName)
import Derived exposing (nameCategory)
import Dict exposing (Dict)


{-| The card id of the Shopping List pane, if present.
-}
cartCardId : Data -> Maybe String
cartCardId data =
    data.staples
        |> List.filter (\c -> c.name == shoppingCartName)
        |> List.head
        |> Maybe.map .id


{-| Grocery-store departments, in a sensible aisle order.
-}
departmentOrder : List String
departmentOrder =
    [ "Produce"
    , "Meat & Seafood"
    , "Dairy & Eggs"
    , "Refrigerated"
    , "Bakery & Grains"
    , "Pantry & Canned"
    , "Condiments & Sauces"
    , "Spices & Seasonings"
    , "Nuts, Seeds & Snacks"
    , "Beverages"
    , "Supplements"
    , "Other"
    ]


{-| Map a pyramid category to the grocery department it is usually found in.
-}
categoryDepartment : String -> String
categoryDepartment label =
    case label of
        "Leafy greens" ->
            "Produce"

        "Vegetables" ->
            "Produce"

        "Fruit" ->
            "Produce"

        "Oily & white fish" ->
            "Meat & Seafood"

        "Eggs & poultry" ->
            "Meat & Seafood"

        "Cultured dairy · moderate" ->
            "Dairy & Eggs"

        "Soy & fermented" ->
            "Refrigerated"

        "Whole grains" ->
            "Bakery & Grains"

        "Oils & healthy fats" ->
            "Pantry & Canned"

        "Legumes & pulses" ->
            "Pantry & Canned"

        "Sweeteners & extras" ->
            "Pantry & Canned"

        "Condiments" ->
            "Condiments & Sauces"

        "Herbs & spices" ->
            "Spices & Seasonings"

        "Nuts & seeds" ->
            "Nuts, Seeds & Snacks"

        "Tea & botanicals" ->
            "Beverages"

        "Supplements" ->
            "Supplements"

        _ ->
            "Other"


{-| The grocery department a shopping item belongs to, via its pyramid
category (foods not in the pyramid fall under "Other").
-}
itemDepartment : Dict String String -> String -> String
itemDepartment nameToCat name =
    Dict.get (String.toLower name) nameToCat
        |> Maybe.map categoryDepartment
        |> Maybe.withDefault "Other"


{-| Group items into (department, items) sections in aisle order, sorted
by name within each, omitting empty departments.
-}
groupByDepartment : Dict String String -> List Item -> List ( String, List Item )
groupByDepartment nameToCat items =
    departmentOrder
        |> List.map
            (\dept ->
                ( dept
                , items
                    |> List.filter (\i -> itemDepartment nameToCat i.name == dept)
                    |> List.sortBy (\i -> String.toLower i.name)
                )
            )
        |> List.filter (\( _, its ) -> not (List.isEmpty its))


{-| The Shopping List rendered as plain text, grouped by grocery
department in aisle order.
-}
shoppingListText : Data -> String
shoppingListText data =
    let
        nameToCat =
            nameCategory data

        sections =
            data.staples
                |> List.filter (\c -> c.name == shoppingCartName)
                |> List.concatMap .items
                |> groupByDepartment nameToCat

        renderSection ( dept, its ) =
            dept ++ "\n" ++ String.join "\n" (List.map (\i -> "- " ++ i.name) its)
    in
    "Shopping List\n\n"
        ++ String.join "\n\n" (List.map renderSection sections)
        ++ "\n"
