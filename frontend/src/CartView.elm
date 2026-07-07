module CartView exposing (viewCartColumn)

{-| The Shopping List column: a to-buy list grouped into grocery
departments, with export and clear-all controls. The cart is still a
storage pane in the data (so drag/drop and the recipe cart button keep
working); here it is rendered on its own rather than inside the Kitchen.
-}

import Data exposing (Card, Data, Item, Loc(..), shoppingCartName)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Lazy as Lazy
import Model exposing (Model)
import Msg exposing (Msg(..))
import Shopping exposing (groupByDepartment)
import Style exposing (cardStyle, styles)
import Ui exposing (collapsedColumnBar, columnTitleBar, dropZone, viewItem)


viewCartColumn : Model -> Data -> Html Msg
viewCartColumn model data =
    if not model.cartOpen then
        -- Even collapsed, the cart bar accepts dropped foods.
        collapsedColumnBar "Shopping List"
            "oklch(0.52 0.1 42)"
            ToggleCart
            (case List.head (List.filter (\c -> c.name == shoppingCartName) data.staples) of
                Just cart ->
                    dropZone (StoragePane cart.id)

                Nothing ->
                    []
            )

    else
        -- The cart reads only the department map and the storage list, and
        -- nothing about the drag state, so it re-renders only when the
        -- stored data changes — not on a keystroke in another column.
        Lazy.lazy2 viewCartBody model.derived.nameCategory data.staples


viewCartBody : Dict String String -> List Card -> Html Msg
viewCartBody nameToCat staples =
    let
        cartMaybe =
            List.head (List.filter (\c -> c.name == shoppingCartName) staples)
    in
    div (class "cart-col-open" :: cardStyle ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ])
        [ columnTitleBar (Just "oklch(0.52 0.1 42)") "Shopping List" ToggleCart
        , div [ class "cart-toolbar" ]
            [ button
                [ type_ "button", class "cart-btn cart-btn-export", onClick ExportShoppingList ]
                [ text "⬇  Export to .txt" ]
            , button
                [ type_ "button", class "cart-btn cart-btn-clear", onClick ClearCart ]
                [ text "🗑  Clear all" ]
            ]
        , case cartMaybe of
            Just cart ->
                let
                    loc =
                        StoragePane cart.id

                    sections =
                        groupByDepartment nameToCat cart.items
                in
                -- The whole body is the drop target, so foods can be
                -- dropped anywhere in the panel — not just on the chips.
                div
                    (class "cart-body"
                        :: styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "14px" ) ]
                        ++ dropZone loc
                    )
                    (if List.isEmpty cart.items then
                        [ span (styles [ ( "font-size", "12px" ), ( "color", "oklch(0.6 0.012 70)" ), ( "font-style", "italic" ) ]) [ text "Drag foods here, or use a recipe's 🛒 button." ] ]

                     else
                        List.map (viewCartSection nameToCat loc) sections
                    )

            Nothing ->
                div [ class "cart-body" ] []
        ]


{-| One grocery-department section of the Shopping List: a header plus the
items in that department.
-}
viewCartSection : Dict String String -> Loc -> ( String, List Item ) -> Html Msg
viewCartSection nameToCat loc ( dept, items ) =
    div (styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "7px" ) ])
        [ div
            (styles
                [ ( "font-family", "'IBM Plex Mono',monospace" )
                , ( "font-size", "10.5px" )
                , ( "font-weight", "600" )
                , ( "letter-spacing", "0.6px" )
                , ( "text-transform", "uppercase" )
                , ( "color", "oklch(0.45 0.07 150)" )
                , ( "border-bottom", "1px solid oklch(0.9 0.012 86)" )
                , ( "padding-bottom", "4px" )
                ]
            )
            [ text dept ]
        , div (styles [ ( "display", "flex" ), ( "flex-wrap", "wrap" ), ( "gap", "7px" ), ( "align-content", "flex-start" ) ])
            (List.map (viewItem "" nameToCat loc) items)
        ]
