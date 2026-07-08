module KitchenView exposing (viewKitchenColumn)

{-| The Kitchen column: the storage panes (Pantry, Refrigerator, and so
on) and their in-stock item chips. Each pane is a drop target and
collapses to its header; a live search force-expands panes that contain a
match.
-}

import Data exposing (Card, Data, Loc(..), shoppingCartName)
import Derived exposing (itemRank)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Keyed as Keyed
import Html.Lazy as Lazy
import Model exposing (Model, PaneEdit, isOpen)
import Msg exposing (Msg(..))
import Set exposing (Set)
import Style exposing (cardStyle, styles)
import Types exposing (AddTarget(..))
import Ui exposing (collapsedColumnBar, columnTitleBar, dropZone, paneDeleteButton, paneEditButton, paneMetaInput, paneNameInput, viewAdder, viewItem, viewSearchField)


viewKitchenColumn : Model -> Data -> Html Msg
viewKitchenColumn model data =
    if not model.kitchenOpen then
        collapsedColumnBar "Kitchen" "oklch(0.55 0.08 74)" ToggleKitchen []

    else
        Lazy.lazy8 viewKitchenBody
            model.adding
            model.addValue
            model.editingPane
            model.kitchenSearch
            model.toggled
            model.derived.nameCategory
            model.derived.categoryRanks
            data.staples


viewKitchenBody : Maybe AddTarget -> String -> Maybe PaneEdit -> String -> Set String -> Dict String String -> Dict String Int -> List Card -> Html Msg
viewKitchenBody adding addValue editingPane rawSearch toggled nameToCat ranks staples =
    let
        kitchenSearch =
            String.toLower (String.trim rawSearch)

        kitchenPanes =
            List.filter (\c -> c.name /= shoppingCartName) staples

        anyMatch =
            kitchenSearch /= "" && List.any (\c -> List.any (\i -> String.contains kitchenSearch (String.toLower i.name)) c.items) kitchenPanes
    in
    div (class "kitchen-col-open" :: cardStyle ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ])
        [ columnTitleBar (Just "oklch(0.55 0.08 74)") "Kitchen" ToggleKitchen
        , div [ class "kitchen-body" ]
            (viewSearchField "Search Kitchen…" rawSearch (kitchenSearch /= "" && not anyMatch) KitchenSearchInput
                :: List.map (\c -> viewPane toggled kitchenSearch nameToCat ranks (paneEditFor editingPane c) c) kitchenPanes
                ++ [ viewAdder adding addValue AddPane "New pane name…" "+ Add pane" ]
            )
        ]


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
    in
    div
        -- The whole pane is a drop target, so items can be dropped even
        -- when it is collapsed (only its header is showing).
        (cardStyle ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ] ++ dropZone stockLoc)
        (div
            (onClick (ToggleCategory ("pane:" ++ card.id))
                :: styles [ ( "background", card.rail ), ( "color", "#fff" ), ( "padding", "13px 16px" ), ( "cursor", "pointer" ), ( "user-select", "none" ) ]
            )
            [ div (styles [ ( "display", "flex" ), ( "justify-content", "space-between" ), ( "align-items", "baseline" ), ( "gap", "10px" ) ])
                [ div (styles [ ( "display", "flex" ), ( "align-items", "baseline" ), ( "gap", "8px" ) ])
                    [ span (styles [ ( "font-size", "10px" ), ( "opacity", "0.8" ) ])
                        [ text
                            (if paneCollapsed then
                                "▶"

                             else
                                "▼"
                            )
                        ]
                    , case edit of
                        Just e ->
                            paneNameInput e.name

                        Nothing ->
                            div [ class "pane-name" ] [ text card.name ]
                    ]
                , div [ class "pane-header-meta" ]
                    (if editing then
                        [ paneEditButton CommitPaneEdit
                        , paneDeleteButton (RemovePane card.id)
                        ]

                     else
                        [ div [ class "pane-item-count" ] [ text (String.fromInt (List.length card.items) ++ " ITEMS") ]
                        , paneEditButton (StartEditPane card.id)
                        ]
                    )
                ]
            , case edit of
                Just e ->
                    paneMetaInput e.meta

                Nothing ->
                    div [ class "pane-meta" ] [ text card.meta ]
            ]
            :: (if paneCollapsed then
                    []

                else
                    [ Keyed.node "div"
                        (styles [ ( "padding", "14px 15px" ), ( "display", "flex" ), ( "flex-wrap", "wrap" ), ( "gap", "7px" ), ( "align-content", "flex-start" ), ( "min-height", "44px" ), ( "flex", "1" ) ])
                        (List.map (\item -> ( item.id, viewItem search nameToCat stockLoc item )) (sortItems card.items))
                    ]
               )
        )
