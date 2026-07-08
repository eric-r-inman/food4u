module KitchenView exposing (viewKitchenColumn)

{-| The Kitchen column: the storage panes (Pantry, Refrigerator, and so
on) and their in-stock item chips. Each pane is a drop target and
collapses to its header; a live search force-expands panes that contain a
match.
-}

import Data exposing (Card, Data, Loc(..), shoppingCartName, staplesTrackerName)
import Derived exposing (itemRank)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Keyed as Keyed
import Html.Lazy as Lazy
import Model exposing (Indices, Model, PaneEdit, isOpen)
import Msg exposing (Msg(..))
import Set exposing (Set)
import Style exposing (cardStyle, panePalette, styles)
import Types exposing (AddTarget(..))
import Ui exposing (collapsedColumnBar, columnTitleBar, dropZone, editingPaneDomId, paneColorButton, paneColorSwatch, paneDeleteButton, paneDeleteConfirm, paneEditButton, paneMetaInput, paneNameInput, stapleCartButton, viewAdder, viewItem, viewSearchField)


viewKitchenColumn : Model -> Data -> Html Msg
viewKitchenColumn model data =
    if not model.kitchenOpen then
        collapsedColumnBar "Kitchen" "oklch(0.55 0.08 74)" ToggleKitchen []

    else
        Lazy.lazy7 viewKitchenBody
            model.adding
            model.addValue
            model.editingPane
            model.kitchenSearch
            model.toggled
            model.derived
            data.staples


viewKitchenBody : Maybe AddTarget -> String -> Maybe PaneEdit -> String -> Set String -> Indices -> List Card -> Html Msg
viewKitchenBody adding addValue editingPane rawSearch toggled derived staples =
    let
        kitchenSearch =
            String.toLower (String.trim rawSearch)

        -- The Shopping List is its own column and the Staples Tracker is
        -- rendered separately below the search field, so neither is one of
        -- the ordinary, editable kitchen panes.
        kitchenPanes =
            List.filter (\c -> c.name /= shoppingCartName && c.name /= staplesTrackerName) staples

        anyMatch =
            kitchenSearch /= "" && List.any (\c -> List.any (\i -> String.contains kitchenSearch (String.toLower i.name)) c.items) kitchenPanes

        trackerView =
            case List.head (List.filter (\c -> c.name == staplesTrackerName) staples) of
                Just card ->
                    viewStaplesTracker toggled kitchenSearch derived card

                Nothing ->
                    text ""
    in
    div (class "kitchen-col-open" :: cardStyle ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ])
        [ columnTitleBar (Just "oklch(0.55 0.08 74)") "Kitchen" ToggleKitchen
        , div [ class "kitchen-body" ]
            (viewSearchField "Search Kitchen…" rawSearch (kitchenSearch /= "" && not anyMatch) KitchenSearchInput
                :: trackerView
                :: List.map (\c -> viewPane toggled kitchenSearch derived.nameCategory derived.categoryRanks (paneEditFor editingPane c) c) kitchenPanes
                ++ [ viewAdder adding addValue AddPane "New pane name…" "+ Add pane" ]
            )
        ]


{-| The Staples Tracker pane: a permanent, non-editable pane holding the
foods the user wants to keep on hand. A staple not on hand in any kitchen
pane shows red, and the cart button sends every such missing staple to the
Shopping List.
-}
viewStaplesTracker : Set String -> String -> Indices -> Card -> Html Msg
viewStaplesTracker toggled search derived card =
    let
        loc =
            StoragePane card.id

        -- Defaults collapsed like the other panes; the caret expands it.
        collapsed =
            not (isOpen False ("pane:" ++ card.id) toggled)

        missing item =
            not (Set.member (String.toLower item.name) derived.stockedNoCart)

        sorted =
            List.sortBy (\item -> ( itemRank derived.nameCategory derived.categoryRanks item, String.toLower item.name )) card.items
    in
    div (class "staples-tracker" :: dropZone loc)
        (div [ class "staples-tracker-head", onClick (ToggleCategory ("pane:" ++ card.id)) ]
            [ div [ class "staples-tracker-title" ]
                [ span [ class "staples-tracker-caret" ]
                    [ text
                        (if collapsed then
                            "▶"

                         else
                            "▼"
                        )
                    ]
                , span [] [ text card.name ]
                ]
            , stapleCartButton AddStaplesToCart
            ]
            :: (if collapsed then
                    []

                else
                    [ div [ class "staples-tracker-body" ]
                        [ p [ class "staples-note" ] [ text "Add staple foods here. Click the 🛒 button to add missing staples (not in your Kitchen, colored red) to your shopping list." ]
                        , Keyed.node "div"
                            [ class "staples-items" ]
                            (List.map (\item -> ( item.id, viewItem (missing item) search derived.nameCategory loc item )) sorted)
                        ]
                    ]
               )
        )


{-| The buffered edit for this pane, if it is the one being edited.
-}
paneEditFor : Maybe PaneEdit -> Card -> Maybe PaneEdit
paneEditFor editingPane card =
    editingPane
        |> Maybe.andThen
            (\e ->
                if e.id == card.id then
                    Just e

                else
                    Nothing
            )


viewPane : Set String -> String -> Dict String String -> Dict String Int -> Maybe PaneEdit -> Card -> Html Msg
viewPane toggled search nameToCat ranks edit card =
    let
        editing =
            edit /= Nothing

        stockLoc =
            StoragePane card.id

        sortItems list =
            List.sortBy (\item -> ( itemRank nameToCat ranks item, String.toLower item.name )) list

        paneHasMatch =
            search /= "" && List.any (\i -> String.contains search (String.toLower i.name)) card.items

        -- Panes default collapsed, except the Shopping List; a live
        -- Kitchen search force-expands any pane that contains a match.
        paneCollapsed =
            not (paneHasMatch || isOpen (card.name == shoppingCartName) ("pane:" ++ card.id) toggled)

        -- The buffered colour while editing previews live; otherwise the
        -- pane's own colour.
        rail =
            edit |> Maybe.map .rail |> Maybe.withDefault card.rail

        -- View mode shows the count and the edit control; editing shows the
        -- recolour and delete controls, and the delete confirmation replaces
        -- them once delete is clicked.
        controls =
            case edit of
                Just e ->
                    if e.confirmingDelete then
                        [ paneDeleteConfirm (RemovePane card.id) CancelDeletePane ]

                    else
                        [ paneColorButton TogglePaneColorPicker
                        , paneDeleteButton RequestDeletePane
                        ]

                Nothing ->
                    [ div [ class "pane-item-count" ] [ text (String.fromInt (List.length card.items) ++ " ITEMS") ]
                    , paneEditButton (StartEditPane card.id)
                    ]

        title =
            case edit of
                Just e ->
                    [ paneNameInput e.name ]

                Nothing ->
                    [ span [ class "pane-caret" ]
                        [ text
                            (if paneCollapsed then
                                "▶"

                             else
                                "▼"
                            )
                        ]
                    , div [ class "pane-name" ] [ text card.name ]
                    ]

        metaRow =
            case edit of
                Just e ->
                    paneMetaInput e.meta

                Nothing ->
                    div [ class "pane-meta" ] [ text card.meta ]

        swatches =
            case edit of
                Just e ->
                    if e.colorOpen && not e.confirmingDelete then
                        [ div [ class "pane-swatches" ]
                            (List.map (\c -> paneColorSwatch (c == e.rail) c) panePalette)
                        ]

                    else
                        []

                Nothing ->
                    []

        header =
            div
                (class "pane-head"
                    :: classList [ ( "pane-head-editing", editing ) ]
                    :: style "background" rail
                    :: (if editing then
                            []

                        else
                            [ onClick (ToggleCategory ("pane:" ++ card.id)) ]
                       )
                )
                (div [ class "pane-head-row" ]
                    [ div [ class "pane-head-title" ] title
                    , div [ class "pane-header-meta" ] controls
                    ]
                    :: metaRow
                    :: swatches
                )

        body =
            if paneCollapsed then
                []

            else
                [ Keyed.node "div"
                    (styles [ ( "padding", "14px 15px" ), ( "display", "flex" ), ( "flex-wrap", "wrap" ), ( "gap", "7px" ), ( "align-content", "flex-start" ), ( "min-height", "44px" ), ( "flex", "1" ) ])
                    (List.map (\item -> ( item.id, viewItem False search nameToCat stockLoc item )) (sortItems card.items))
                ]
    in
    div
        -- The whole pane is a drop target, so items can be dropped even
        -- when it is collapsed (only its header is showing).  While it is
        -- being edited it carries the id the click-outside test looks for.
        (cardStyle
            ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ]
            ++ dropZone stockLoc
            ++ (if editing then
                    [ id editingPaneDomId ]

                else
                    []
               )
        )
        (header :: body)
