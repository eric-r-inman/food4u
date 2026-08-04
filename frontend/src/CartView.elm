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
import Html.Events exposing (on, onClick, onInput, stopPropagationOn)
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

        -- The names already on the reserved list, so the quick-add
        -- autocomplete never suggests a food the list already holds.
        onList =
            ordered
                |> List.filter (\c -> c.name == shoppingCartName)
                |> List.concatMap (\c -> List.map (\i -> String.toLower i.name) c.items)
                |> Set.fromList

        suggestions =
            quickAddSuggestions derived.catalogNames onList quickAdd
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
            (List.map (viewCartCard derived.nameTierRail toggled selectMode countMode pareMode selection.items confirmingDelete quickAdd suggestions) ordered
                ++ [ viewAdder adding addValue AddCartCategory "New category…" "+ Add category" ]
            )
        ]


{-| The autocomplete matches for the quick-add field: catalog foods
whose name contains the typed text, ones that begin with it first, and
never a food already on the list. Empty while nothing is typed, and
capped so the dropdown stays short.
-}
quickAddSuggestions : List String -> Set String -> String -> List String
quickAddSuggestions catalog onList quickAdd =
    let
        query =
            String.toLower (String.trim quickAdd)
    in
    if query == "" then
        []

    else
        let
            candidates =
                catalog
                    |> List.filter (\n -> not (Set.member (String.toLower n) onList))
                    |> List.filter (\n -> String.contains query (String.toLower n))

            ( prefix, rest ) =
                List.partition (\n -> String.startsWith query (String.toLower n)) candidates
        in
        List.take 8 (prefix ++ rest)


{-| One Shopping List card, styled like a Recipes-column category: a
collapsible underlined title row (with a delete control for user
categories, but not the reserved bucket) over its item chips. The reserved
bucket defaults open, since recipe and staple additions land there; the
user categories default collapsed, showing just their counts until opened.
The reserved bucket also carries the quick-add field under its heading,
so foods can be typed straight onto the list.
-}
viewCartCard : Dict String String -> Set String -> Bool -> Bool -> Bool -> Set String -> Maybe String -> String -> List String -> Card -> Html Msg
viewCartCard nameToTierRail toggled selectMode countMode pareMode selected confirmingDelete quickAdd suggestions card =
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

        -- The reserved bucket's header files its items into their target
        -- departments; a category's header points its current items back
        -- at itself, so custom items become sortable and a food's target
        -- can be changed by moving it.  Hidden while selecting or paring,
        -- whose header controls take the space.
        sortControls =
            if selectMode || pareMode || List.isEmpty card.items then
                []

            else if reserved then
                [ button
                    [ type_ "button"
                    , class "cart-sort-btn"
                    , title "File each item into the department it targets"
                    , stopPropagationOn "click" (Decode.succeed ( AutoSortCart, True ))
                    ]
                    [ text "⇅ Auto-sort" ]
                ]

            else
                [ button
                    [ type_ "button"
                    , class "cart-sort-btn"
                    , title "Make every item here sort back to this department"
                    , stopPropagationOn "click" (Decode.succeed ( RetargetPane card.id, True ))
                    ]
                    [ text "◎ Sort here" ]
                ]

        -- While items are selected, a green bulk-move button moves the
        -- whole selection into this list.
        moveControl =
            if selectMode && not (Set.isEmpty selected) then
                [ moveHereButton (Set.size selected) (MoveSelectedTo loc) ]

            else
                []

        -- The standing quick-add field, on the reserved bucket only: type a
        -- food and press Enter to drop its badge on the list without
        -- visiting the pyramid.  Escape clears the field.  As the user
        -- types, matching catalog foods appear below it; clicking one adds
        -- it straight away.
        quickAddField =
            if reserved && not collapsed then
                [ div [ class "cart-quick-add-row" ]
                    (input
                        [ class "cart-quick-add-input"
                        , type_ "text"
                        , placeholder "Type a food, press Enter…"
                        , value quickAdd
                        , onInput CartQuickAddInput
                        , on "keydown" quickAddKey
                        ]
                        []
                        :: quickAddSuggestionList suggestions
                    )
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
                :: (sortControls ++ moveControl ++ controls)
            )
            :: (quickAddField ++ body)
        )


{-| The autocomplete dropdown under the quick-add field: one button per
matching food, each adding that food to the list on click. Empty (so
nothing renders) until the user types something that matches.
-}
quickAddSuggestionList : List String -> List (Html Msg)
quickAddSuggestionList suggestions =
    if List.isEmpty suggestions then
        []

    else
        [ div [ class "cart-quick-add-suggestions" ]
            (List.map
                (\name ->
                    button
                        [ type_ "button"
                        , class "cart-quick-add-suggestion"
                        , onClick (CartQuickAddPick name)
                        ]
                        [ text name ]
                )
                suggestions
            )
        ]


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
