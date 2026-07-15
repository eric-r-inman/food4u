module PyramidView exposing (viewPyramidColumn)

{-| The Longevity Foods column: the staples pyramid of tiers, each with
its category groups and draggable food chips. The whole column is lazy on
the narrow set of inputs it reads, and a live search force-expands the
categories that contain a match.
-}

import Data exposing (Data, Food, Group, Loc(..), Tier)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Keyed as Keyed
import Html.Lazy as Lazy
import Model exposing (Model, Selection, isOpen)
import Msg exposing (Msg(..))
import Set exposing (Set)
import Style exposing (cardStyle, foodChipStyle, searchHighlightStyle, styles, tierChipBg)
import Types exposing (AddTarget(..))
import Ui exposing (categoryDeleteControl, collapsedColumnBar, columnDragAttrs, columnTitleBar, moveHereButton, notepadButton, recipeDropZone, removeButton, selectAttrs, selectLead, viewAdder, viewSearchField)


viewPyramidColumn : Model -> Data -> Html Msg
viewPyramidColumn model data =
    if not model.pyramidOpen then
        collapsedColumnBar "Longevity Foods" "col-closed-pyramid" TogglePyramid (columnDragAttrs "pyramid")

    else
        -- Lazy on the narrow set of inputs the pyramid actually reads, so a
        -- keystroke or drag in another column does not rebuild and re-diff
        -- the ~500-food tree.  Nothing here consults the drag state, so a
        -- drag never re-renders the pyramid at all.
        Lazy.lazy8 viewPyramidBody
            model.search
            model.toggled
            model.adding
            model.addValue
            model.confirmingDelete
            model.selection
            model.derived.inStock
            data.tiers


viewPyramidBody : String -> Set String -> Maybe AddTarget -> String -> Maybe String -> Selection -> Set String -> List Tier -> Html Msg
viewPyramidBody rawSearch toggled adding addValue confirmingDelete selection inStock tiers =
    let
        search =
            String.toLower (String.trim rawSearch)

        selectMode =
            selection.active

        anyMatch =
            search /= "" && List.any (\f -> String.contains search (String.toLower f.name)) (List.concatMap (\t -> List.concatMap .foods t.groups) tiers)
    in
    div (class "pyramid-col-open" :: cardStyle ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ])
        [ columnTitleBar (Just "oklch(0.5 0.07 128)") "Longevity Foods" TogglePyramid (columnDragAttrs "pyramid")
        , div [ class "pyramid-body" ]
            [ viewSearchField "Search foods…" rawSearch (search /= "" && not anyMatch) SearchInput []
            , div (styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "10px" ) ])
                (List.map (viewTier toggled adding addValue confirmingDelete selectMode selection.items inStock search) tiers)
            ]
        ]


viewTier : Set String -> Maybe AddTarget -> String -> Maybe String -> Bool -> Set String -> Set String -> String -> Tier -> Html Msg
viewTier toggled adding addValue confirmingDelete selectMode selected inStock search tier =
    let
        foods =
            List.concatMap .foods tier.groups

        foodCount =
            List.length foods

        stockedCount =
            foods
                |> List.filter (\f -> Set.member (String.toLower f.name) inStock)
                |> List.length
    in
    div
        (styles
            [ ( "background", tier.tint )
            , ( "border", "1px solid " ++ tier.line )
            , ( "border-radius", "11px" )
            , ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "overflow", "hidden" )
            ]
        )
        [ div
            (styles
                [ ( "background", tier.rail )
                , ( "color", "#fff" )
                , ( "padding", "11px 16px" )
                , ( "display", "flex" )
                , ( "align-items", "baseline" )
                , ( "gap", "10px" )
                ]
            )
            [ span (styles [ ( "font-family", "'IBM Plex Mono',monospace" ), ( "font-size", "11px" ), ( "font-weight", "500" ), ( "opacity", "0.7" ), ( "letter-spacing", "1px" ) ]) [ text tier.no ]
            , span (styles [ ( "font-size", "18px" ), ( "font-weight", "700" ), ( "letter-spacing", "-0.3px" ) ]) [ text tier.name ]
            , span (styles [ ( "font-family", "'IBM Plex Mono',monospace" ), ( "font-size", "10.5px" ), ( "font-weight", "500" ), ( "opacity", "0.9" ), ( "letter-spacing", "0.5px" ) ]) [ text tier.freq ]
            , span (styles [ ( "font-family", "'IBM Plex Mono',monospace" ), ( "font-size", "10px" ), ( "opacity", "0.6" ), ( "letter-spacing", "0.5px" ), ( "margin-left", "auto" ) ]) [ text (String.fromInt foodCount ++ " FOODS / " ++ String.fromInt stockedCount ++ " STOCKED") ]
            ]
        , div
            (styles
                [ ( "padding", "14px 16px" )
                , ( "display", "flex" )
                , ( "flex-direction", "column" )
                , ( "gap", "12px" )
                ]
            )
            (List.map (viewCategory toggled adding addValue confirmingDelete selectMode selected inStock search tier) tier.groups
                ++ [ viewAdder adding addValue (AddCategory tier.id) "New category…" "+ Add category" ]
            )
        ]


viewCategory : Set String -> Maybe AddTarget -> String -> Maybe String -> Bool -> Set String -> Set String -> String -> Tier -> Group -> Html Msg
viewCategory toggled adding addValue confirmingDelete selectMode selected inStock search tier group =
    let
        loc =
            PyramidGroup group.id

        categoryHasMatch =
            search /= "" && List.any (\f -> String.contains search (String.toLower f.name)) group.foods

        -- Categories default collapsed; a live search force-expands any
        -- category containing a match.
        isCollapsed =
            not (categoryHasMatch || isOpen False group.id toggled)

        -- Every food in a tier shares the tier's badge tint, regardless of
        -- its sub-category.
        bg =
            tierChipBg tier.rail

        -- While items are selected, a green arrow adds the whole selection
        -- to this category as pyramid foods.
        moveControl =
            if selectMode && not (Set.isEmpty selected) then
                [ moveHereButton (MoveSelectedTo loc) ]

            else
                []
    in
    div (styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "8px" ) ] ++ recipeDropZone group.id)
        (div
            (onClick (ToggleCategory group.id)
                :: styles
                    [ ( "display", "flex" )
                    , ( "align-items", "baseline" )
                    , ( "gap", "7px" )
                    , ( "font-family", "'IBM Plex Mono',monospace" )
                    , ( "font-size", "11px" )
                    , ( "font-weight", "600" )
                    , ( "letter-spacing", "0.6px" )
                    , ( "text-transform", "uppercase" )
                    , ( "color", tier.rail )
                    , ( "border-bottom", "1px solid " ++ tier.line )
                    , ( "padding-bottom", "5px" )
                    , ( "cursor", "pointer" )
                    , ( "user-select", "none" )
                    ]
            )
            ([ span (styles [ ( "font-size", "9px" ), ( "opacity", "0.7" ) ])
                [ text
                    (if isCollapsed then
                        "▶"

                     else
                        "▼"
                    )
                ]
             , span [] [ text group.label ]
             , span (styles [ ( "margin-left", "auto" ), ( "opacity", "0.55" ), ( "font-weight", "500" ) ]) [ text (String.fromInt (List.length group.foods)) ]
             ]
                ++ moveControl
                ++ [ categoryDeleteControl (confirmingDelete == Just group.id) (RequestDelete group.id) (RemoveCategory group.id) CancelDelete ]
            )
            :: (if isCollapsed then
                    []

                else
                    [ Keyed.node "div"
                        (styles [ ( "display", "flex" ), ( "flex-wrap", "wrap" ), ( "gap", "6px" ) ])
                        (group.foods
                            |> List.sortBy (\f -> String.toLower f.name)
                            |> List.map (\f -> ( f.id, viewFood selectMode selected bg inStock search loc f ))
                        )
                    , viewAdder adding addValue (AddFood loc) "Add food…" "+ Add"
                    ]
               )
        )


viewFood : Bool -> Set String -> String -> Set String -> String -> Loc -> Food -> Html Msg
viewFood selectMode selected bg inStock search loc food =
    let
        matches =
            search /= "" && String.contains search (String.toLower food.name)

        chip =
            if matches then
                searchHighlightStyle

            else
                foodChipStyle bg (Set.member (String.toLower food.name) inStock)
    in
    span (class "chip" :: chip ++ Ui.draggable loc food.id ++ selectAttrs selectMode loc food.id)
        (selectLead selectMode selected loc food.id
            ++ [ span [] [ text food.name ] ]
            ++ (if food.recipeId /= "" then
                    [ notepadButton (OpenRecipe food.recipeId) ]

                else
                    []
               )
            ++ [ removeButton (RemoveFoodMsg loc food.id) ]
        )
