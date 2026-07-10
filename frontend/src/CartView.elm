module CartView exposing (viewCartColumn)

{-| The Shopping List column: a to-buy list the user organises into their
own categories. The reserved "Shopping List" card is the uncategorised
bucket recipe and staple additions land in; the user adds named categories
below it and drags items into them. Each card is a storage pane in the
data (so drag/drop, the recipe cart button, and export keep working); the
`zone` field is what files them here rather than in the Kitchen.
-}

import Data exposing (Card, Data, Loc(..), isShoppingCard, shoppingCartName)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Lazy as Lazy
import Model exposing (Indices, Model)
import Msg exposing (Msg(..))
import Style exposing (cardStyle, styles)
import Types exposing (AddTarget(..))
import Ui exposing (categoryDeleteControl, collapsedColumnBar, columnTitleBar, dropZone, viewAdder, viewItem)


viewCartColumn : Model -> Data -> Html Msg
viewCartColumn model data =
    if not model.cartOpen then
        -- Even collapsed, the cart bar accepts foods dropped onto the
        -- uncategorised bucket.
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
        -- The cart reads only the derived tints and the storage list, plus
        -- the add/confirm UI state, so it re-renders only when those change
        -- — not on a keystroke in another column.
        Lazy.lazy5 viewCartBody model.derived data.staples model.adding model.addValue model.confirmingDelete


viewCartBody : Indices -> List Card -> Maybe AddTarget -> String -> Maybe String -> Html Msg
viewCartBody derived staples adding addValue confirmingDelete =
    let
        shoppingCards =
            List.filter isShoppingCard staples

        -- The reserved bucket sorts first, its user categories after, in the
        -- order they were added.
        ordered =
            List.filter (\c -> c.name == shoppingCartName) shoppingCards
                ++ List.filter (\c -> c.name /= shoppingCartName) shoppingCards
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
        , div [ class "cart-body" ]
            (List.map (viewCartCard derived.nameTierRail confirmingDelete) ordered
                ++ [ viewAdder adding addValue AddCartCategory "New category…" "+ Add category" ]
            )
        ]


{-| One Shopping List card: its coloured title row (with a delete control
for user categories, but not the reserved bucket) and a drop area holding
its item chips.
-}
viewCartCard : Dict String String -> Maybe String -> Card -> Html Msg
viewCartCard nameToTierRail confirmingDelete card =
    let
        loc =
            StoragePane card.id

        railBg =
            if card.rail == "" then
                "oklch(0.52 0.1 42)"

            else
                card.rail

        -- The reserved bucket is permanent; only user categories can be
        -- deleted.
        controls =
            if card.name == shoppingCartName then
                []

            else
                [ categoryDeleteControl (confirmingDelete == Just card.id) (RequestDelete card.id) (RemovePane card.id) CancelDelete ]

        body =
            if List.isEmpty card.items then
                [ span [ class "cart-empty-hint" ] [ text "Drag foods here." ] ]

            else
                card.items
                    |> List.sortBy (\i -> String.toLower i.name)
                    |> List.map (viewItem False "" nameToTierRail loc)
    in
    div (class "cart-cat" :: dropZone loc)
        [ div (class "cart-cat-head" :: [ style "background" railBg ])
            (span [ class "cart-cat-title" ] [ text card.name ]
                :: span [ class "cart-cat-count" ] [ text (String.fromInt (List.length card.items)) ]
                :: controls
            )
        , div [ class "cart-cat-body" ] body
        ]
