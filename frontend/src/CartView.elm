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
import Html.Events exposing (on, onClick, onInput)
import Html.Lazy as Lazy
import Json.Decode as Decode
import Model exposing (Indices, Model, Selection, isOpen)
import Msg exposing (Msg(..))
import Set exposing (Set)
import Style exposing (cardStyle, styles)
import Types exposing (AddTarget(..))
import Ui exposing (categoryDeleteControl, collapsedColumnBar, columnDragAttrs, columnTitleBar, dropZone, moveHereButton, viewAdder, viewItem)


viewCartColumn : Model -> Data -> Html Msg
viewCartColumn model data =
    if not model.cartOpen then
        -- Even collapsed, the cart bar accepts foods dropped onto the
        -- uncategorised bucket.
        collapsedColumnBar "Shopping List"
            "col-closed-cart"
            ToggleCart
            (columnDragAttrs "cart"
                ++ (data.staples
                        |> List.filter (\c -> c.name == shoppingCartName)
                        |> List.head
                        |> Maybe.map (\cart -> dropZone (StoragePane cart.id))
                        |> Maybe.withDefault []
                   )
            )

    else
        -- The cart reads only the derived tints and the storage list, plus
        -- the collapse, add/confirm, and quick-add UI state, so it re-renders
        -- only when those change — not on a keystroke in another column.
        Lazy.lazy8 viewCartBody model.derived data.staples model.toggled model.adding model.addValue model.confirmingDelete model.selection model.cartQuickAdd


viewCartBody : Indices -> List Card -> Set String -> Maybe AddTarget -> String -> Maybe String -> Selection -> String -> Html Msg
viewCartBody derived staples toggled adding addValue confirmingDelete selection quickAdd =
    let
        selectMode =
            selection.active

        countMode =
            selection.countMode

        pareMode =
            selection.pareMode

        shoppingCards =
            List.filter isShoppingCard staples

        -- The reserved bucket sorts first, its user categories after, in the
        -- order they were added.
        ordered =
            List.filter (\c -> c.name == shoppingCartName) shoppingCards
                ++ List.filter (\c -> c.name /= shoppingCartName) shoppingCards
    in
    div (class "cart-col-open" :: cardStyle ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ])
        [ columnTitleBar (Just "oklch(0.52 0.1 42)") "Shopping List" ToggleCart (columnDragAttrs "cart")
        , div [ class "cart-toolbar" ]
            [ button
                [ type_ "button", class "cart-btn cart-btn-export", onClick ExportShoppingList ]
                [ text "⬇  Export to .txt" ]
            , button
                [ type_ "button", class "cart-btn cart-btn-clear", onClick ClearCart ]
                [ text "🗑  Clear all" ]
            ]
        , div [ class "cart-body" ]
            (List.map (viewCartCard derived.nameTierRail toggled selectMode countMode pareMode selection.items confirmingDelete quickAdd) ordered
                ++ [ viewAdder adding addValue AddCartCategory "New category…" "+ Add category" ]
            )
        ]


{-| One Shopping List card, styled like a Recipes-column category: a
collapsible underlined title row (with a delete control for user
categories, but not the reserved bucket) over its item chips. The reserved
bucket defaults open, since recipe and staple additions land there; the
user categories default collapsed, showing just their counts until opened.
The reserved bucket also carries the quick-add field under its heading,
so foods can be typed straight onto the list.
-}
viewCartCard : Dict String String -> Set String -> Bool -> Bool -> Bool -> Set String -> Maybe String -> String -> Card -> Html Msg
viewCartCard nameToTierRail toggled selectMode countMode pareMode selected confirmingDelete quickAdd card =
    let
        loc =
            StoragePane card.id

        reserved =
            card.name == shoppingCartName

        collapsed =
            not (isOpen reserved ("cart:" ++ card.id) toggled)

        -- The reserved bucket is permanent; only user categories can be
        -- deleted, and only while pare mode is on.
        controls =
            if reserved || not pareMode then
                []

            else
                [ categoryDeleteControl (confirmingDelete == Just card.id) (RequestDelete card.id) (RemovePane card.id) CancelDelete ]

        -- While items are selected, a green arrow moves the whole selection
        -- into this list.
        moveControl =
            if selectMode && not (Set.isEmpty selected) then
                [ moveHereButton (MoveSelectedTo loc) ]

            else
                []

        -- The standing quick-add field, on the reserved bucket only: type a
        -- food and press Enter to drop its badge on the list without
        -- visiting the pyramid.  Escape clears the field.
        quickAddField =
            if reserved && not collapsed then
                [ div [ class "cart-quick-add-row" ]
                    [ input
                        [ class "cart-quick-add-input"
                        , type_ "text"
                        , placeholder "Type a food, press Enter…"
                        , value quickAdd
                        , onInput CartQuickAddInput
                        , on "keydown" quickAddKey
                        ]
                        []
                    ]
                ]

            else
                []

        body =
            if collapsed then
                []

            else if List.isEmpty card.items then
                [ div [ class "cart-cat-body" ] [ span [ class "cart-empty-hint" ] [ text "Drag foods here." ] ] ]

            else
                [ div [ class "cart-cat-body" ]
                    (card.items
                        |> List.sortBy (\i -> String.toLower i.name)
                        |> List.map (viewItem selectMode countMode pareMode selected False "" nameToTierRail loc)
                    )
                ]
    in
    div (class "cart-cat" :: dropZone loc)
        (div [ class "cart-cat-head", onClick (ToggleCategory ("cart:" ++ card.id)) ]
            (span [ class "cart-cat-caret" ]
                [ text
                    (if collapsed then
                        "▶"

                     else
                        "▼"
                    )
                ]
                :: span [] [ text card.name ]
                :: span [ class "cart-cat-count" ] [ text (String.fromInt (List.length card.items)) ]
                :: (moveControl ++ controls)
            )
            :: (quickAddField ++ body)
        )


{-| The quick-add field's keyboard contract: Enter commits the typed
name, Escape clears the field, and every other key is left to the input.
-}
quickAddKey : Decode.Decoder Msg
quickAddKey =
    Decode.field "key" Decode.string
        |> Decode.andThen
            (\key ->
                case key of
                    "Enter" ->
                        Decode.succeed CartQuickAddSubmit

                    "Escape" ->
                        Decode.succeed (CartQuickAddInput "")

                    _ ->
                        Decode.fail "not a quick-add key"
            )
