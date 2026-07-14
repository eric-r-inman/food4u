module Ui exposing
    ( addInputId
    , bookmarkButton
    , categoryDeleteControl
    , collapsedColumnBar
    , columnTitleBar
    , draggable
    , dropZone
    , editingPaneDomId
    , moveHereButton
    , notepadButton
    , paneColorButton
    , paneColorSwatch
    , paneDeleteButton
    , paneDeleteConfirm
    , paneEditButton
    , paneMetaInput
    , paneNameInput
    , pasteInputId
    , recipeCartButton
    , recipeDeleteButton
    , recipeDropZone
    , removeButton
    , selectAttrs
    , selectLead
    , selectToggle
    , stapleCartButton
    , viewAdder
    , viewItem
    , viewSearchField
    )

{-| Interactive presentational widgets shared across the columns: the
column title/collapsed bars, the search field, the inline add-input, the
per-chip buttons, and the drag/drop attribute helpers. These produce
`Html Msg` / `Attribute Msg`, so they live in their own module the
per-column views can import without cycling through Main.
-}

import Data exposing (Item, Loc, selKey)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onBlur, onClick, onInput, preventDefaultOn, stopPropagationOn)
import Json.Decode as Decode
import Msg exposing (Msg(..))
import Set exposing (Set)
import Style exposing (foodChipStyle, searchHighlightStyle, stapleMissingStyle, styles, tierChipBg)
import Types exposing (AddTarget)


{-| The single inline add-input is given this id so it can be focused
the moment the "+ Add" button is clicked.
-}
addInputId : String
addInputId =
    "food4u-add-input"


{-| Id of the paste textarea, focused when "Paste" is clicked.
-}
pasteInputId : String
pasteInputId =
    "food4u-paste-input"


{-| The dom id the pane being edited carries, so a mousedown-outside test
can tell whether a click landed within it (and thus should not close the
editor).
-}
editingPaneDomId : String
editingPaneDomId =
    "pane-editing"


{-| A big title row that toggles a whole column open/closed, in the
"Longevity Foods" style. With `Just color` it is a filled rail bar with
white text; with `Nothing` it is dark text on the card background.
-}
columnTitleBar : Maybe String -> String -> Msg -> Html Msg
columnTitleBar maybeBg titleText toggleMsg =
    let
        ( bg, fg, bottomBorder ) =
            case maybeBg of
                Just color ->
                    ( color, "#fff", "none" )

                Nothing ->
                    ( "transparent", "oklch(0.28 0.015 70)", "1px solid oklch(0.9 0.012 86)" )
    in
    div
        (onClick toggleMsg
            :: styles
                [ ( "display", "flex" )
                , ( "align-items", "center" )
                , ( "gap", "11px" )
                , ( "padding", "20px 24px 16px" )
                , ( "background", bg )
                , ( "color", fg )
                , ( "border-bottom", bottomBorder )
                , ( "cursor", "pointer" )
                , ( "user-select", "none" )
                , ( "flex", "0 0 auto" )
                ]
        )
        [ span (styles [ ( "font-size", "13px" ), ( "opacity", "0.55" ) ]) [ text "▼" ]
        , span (styles [ ( "font-size", "28px" ), ( "font-weight", "800" ), ( "letter-spacing", "-0.8px" ) ]) [ text titleText ]
        ]


{-| The app-wide "Select: off / on" toggle shown in its own row under the
page title. Turning it on marks every column's item badges with a
tap-to-select circle, a drag alternative for touch.
-}
selectToggle : Bool -> Int -> Msg -> Html Msg
selectToggle on selectedCount msg =
    button
        [ type_ "button"
        , classList [ ( "select-toggle", True ), ( "select-toggle-on", on ) ]
        , title "Tap items to select several, then drag one to move them all"
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
        [ text
            ("Select: "
                ++ (if on then
                        "on"

                    else
                        "off"
                   )
                ++ (if on && selectedCount >= 1 then
                        " (" ++ String.fromInt selectedCount ++ ")"

                    else
                        ""
                   )
            )
        ]


{-| The tap-to-select circle shown at the left of an item badge while its
column is in select mode: an empty ring, filled when the item is selected.
-}
selectionCircle : Bool -> Html Msg
selectionCircle selected =
    span [ classList [ ( "sel-circle", True ), ( "sel-circle-on", selected ) ] ] []


{-| The fat green down-arrow shown on a pane or category header while items
are selected: pressing it moves the whole selection into that area. It sits
in a header that is itself a collapse or edit toggle, so its click must not
propagate.
-}
moveHereButton : Msg -> Html Msg
moveHereButton msg =
    button
        [ type_ "button"
        , class "move-here-btn"
        , title "Move selected here"
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
        [ text "⬇" ]


{-| The slim vertical bar a Pyramid/Kitchen column collapses to, in the
given rail color (matching the Foundation / Pantry bars).
-}
collapsedColumnBar : String -> String -> Msg -> List (Attribute Msg) -> Html Msg
collapsedColumnBar titleText bgColor toggleMsg extraAttrs =
    div
        (class "col-closed"
            :: onClick toggleMsg
            :: extraAttrs
            ++ styles
                [ ( "background", bgColor )
                , ( "color", "#fff" )
                , ( "border-radius", "14px" )
                , ( "box-shadow", "0 18px 50px -28px rgba(60,45,20,0.35)" )
                , ( "cursor", "pointer" )
                , ( "user-select", "none" )
                , ( "display", "flex" )
                , ( "flex-direction", "column" )
                , ( "align-items", "center" )
                , ( "gap", "12px" )
                , ( "padding", "18px 0" )
                ]
        )
        [ span (styles [ ( "font-size", "12px" ), ( "opacity", "0.75" ) ]) [ text "▶" ]
        , span
            (styles
                [ ( "writing-mode", "vertical-rl" )
                , ( "font-size", "16px" )
                , ( "font-weight", "800" )
                , ( "letter-spacing", "-0.3px" )
                ]
            )
            [ text titleText ]
        ]


{-| A search input with a clear button, reddened when the current term
matches nothing. Shared by the Pyramid, Recipes, and Kitchen columns. Any
`trailing` elements sit on the same row to the right of the field, which
shrinks to make room without the row growing wider (the Recipes column
uses this for its tag filter).
-}
viewSearchField : String -> String -> Bool -> (String -> Msg) -> List (Html Msg) -> Html Msg
viewSearchField placeholderText currentValue noMatch onInputMsg trailing =
    div [ class "search-field-row" ]
        (div [ class "search-field-wrap" ]
            [ input
                (value currentValue
                    :: onInput onInputMsg
                    :: placeholder placeholderText
                    :: type_ "text"
                    :: styles
                        [ ( "width", "100%" )
                        , ( "padding", "8px 34px 8px 12px" )
                        , ( "border-radius", "8px" )
                        , ( "font-size", "14px" )
                        , ( "outline", "none" )
                        , ( "color", "oklch(0.3 0.012 70)" )
                        , ( "border"
                          , if noMatch then
                                "1px solid oklch(0.6 0.2 25)"

                            else
                                "1px solid oklch(0.86 0.012 86)"
                          )
                        , ( "background"
                          , if noMatch then
                                "oklch(0.96 0.04 25)"

                            else
                                "#fff"
                          )
                        ]
                )
                []
            , if currentValue /= "" then
                button
                    (type_ "button"
                        :: onClick (onInputMsg "")
                        :: styles
                            [ ( "position", "absolute" )
                            , ( "right", "8px" )
                            , ( "top", "50%" )
                            , ( "transform", "translateY(-50%)" )
                            , ( "border", "none" )
                            , ( "background", "transparent" )
                            , ( "cursor", "pointer" )
                            , ( "font-size", "14px" )
                            , ( "font-weight", "700" )
                            , ( "color", "oklch(0.55 0.012 70)" )
                            , ( "padding", "2px 4px" )
                            , ( "line-height", "1" )
                            ]
                    )
                    [ text "✕" ]

              else
                text ""
            ]
            :: trailing
        )


{-| A small always-visible notepad button shown on a pyramid food that is
linked to a recipe; opens that recipe.
-}
notepadButton : Msg -> Html Msg
notepadButton msg =
    button
        (type_ "button"
            :: stopPropagationOn "click" (Decode.succeed ( msg, True ))
            :: title "Open linked recipe"
            :: styles
                [ ( "border", "none" )
                , ( "background", "transparent" )
                , ( "cursor", "pointer" )
                , ( "font-size", "11px" )
                , ( "padding", "0 1px" )
                , ( "line-height", "1" )
                ]
        )
        [ text "📝" ]


{-| Sends every not-yet-stocked ingredient of the recipe to the Shopping
List. It is green while `active` — when the recipe has an ingredient that is
neither in the Kitchen nor already on the Shopping List — and greyed out
when there is nothing left to add.
-}
recipeCartButton : Bool -> Msg -> Html Msg
recipeCartButton active msg =
    button
        [ type_ "button"
        , classList [ ( "recipe-cart-btn", True ), ( "recipe-cart-btn-active", active ) ]
        , title "Add missing ingredients to Shopping List"
        , onClick msg
        ]
        [ text "🛒" ]


{-| The recipe header's bookmark toggle: a user marker to remember a
recipe. A light-blue pill when bookmarked, greyed and desaturated when not.
The glyph is wrapped so its own filter can tint the red ribbon emoji blue —
an emoji ignores `color`, so a filter is the only way to recolour it.
-}
bookmarkButton : Bool -> Msg -> Html Msg
bookmarkButton on msg =
    button
        [ type_ "button"
        , classList [ ( "recipe-bookmark-btn", True ), ( "recipe-bookmark-btn-on", on ) ]
        , title
            (if on then
                "Remove bookmark"

             else
                "Bookmark this recipe"
            )
        , onClick msg
        ]
        [ span [ classList [ ( "recipe-bookmark-glyph", True ), ( "recipe-bookmark-glyph-on", on ) ] ] [ text "🔖" ] ]


{-| A small but always-visible delete control for a recipe (unlike the
hover-revealed chip remove button).
-}
recipeDeleteButton : Msg -> Html Msg
recipeDeleteButton msg =
    button
        (type_ "button"
            :: onClick msg
            :: styles
                [ ( "font-family", "'IBM Plex Mono',monospace" )
                , ( "font-size", "11px" )
                , ( "font-weight", "700" )
                , ( "padding", "2px 7px" )
                , ( "border-radius", "5px" )
                , ( "cursor", "pointer" )
                , ( "border", "1px solid oklch(0.85 0.06 25)" )
                , ( "background", "oklch(0.96 0.03 25)" )
                , ( "color", "oklch(0.5 0.16 25)" )
                , ( "line-height", "1.2" )
                ]
        )
        [ text "✕" ]


{-| Deletes a whole storage pane. It sits inside the pane header, which is
itself a collapse toggle, so the click must not propagate up to it.
-}
paneDeleteButton : Msg -> Html Msg
paneDeleteButton msg =
    button
        [ type_ "button"
        , class "pane-delete-btn"
        , title "Delete this pane"
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
        [ text "✕" ]


{-| Toggles a pane's edit mode. In view mode it is the only right-hand
control; in edit mode it is replaced by the recolour and delete controls.
-}
paneEditButton : Msg -> Html Msg
paneEditButton msg =
    button
        [ type_ "button"
        , class "pane-edit-btn"
        , title "Edit this pane"
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
        [ text "✎" ]


{-| The inline delete confirmation shown after the delete control is
clicked: a prompt with a confirming Delete and a Cancel.
-}
paneDeleteConfirm : Msg -> Msg -> Html Msg
paneDeleteConfirm confirmMsg cancelMsg =
    span [ class "pane-delete-confirm" ]
        [ span [ class "pane-delete-confirm-label" ] [ text "Delete pane?" ]
        , button
            [ type_ "button"
            , class "pane-confirm-delete"
            , stopPropagationOn "click" (Decode.succeed ( confirmMsg, True ))
            ]
            [ text "Delete" ]
        , button
            [ type_ "button"
            , class "pane-confirm-cancel"
            , stopPropagationOn "click" (Decode.succeed ( cancelMsg, True ))
            ]
            [ text "Cancel" ]
        ]


{-| Toggles the colour picker for the pane being edited. Sits in the
collapse-toggle header, so its click must not propagate.
-}
paneColorButton : Msg -> Html Msg
paneColorButton msg =
    button
        [ type_ "button"
        , class "pane-edit-btn"
        , title "Recolour this pane"
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
        [ text "🎨" ]


{-| A single colour choice in the pane colour picker: a swatch filled with
the colour (necessarily an inline value), ringed when it is the current
choice. Its click must not propagate to the header toggle.
-}
paneColorSwatch : Bool -> String -> Html Msg
paneColorSwatch selected color =
    button
        [ type_ "button"
        , classList [ ( "pane-swatch", True ), ( "pane-swatch-selected", selected ) ]
        , title "Use this colour"
        , style "background" color
        , stopPropagationOn "click" (Decode.succeed ( SetPaneColor color, True ))
        ]
        []


{-| The pane name as an editable field, shown in place of the title while
the pane is in edit mode. Edits are buffered and written back only on
commit (Enter, handled globally while editing).
-}
paneNameInput : String -> Html Msg
paneNameInput currentName =
    input
        [ class "pane-name-input"
        , value currentName
        , placeholder "Pane name"
        , type_ "text"
        , onInput EditPaneName
        ]
        []


{-| The pane description (its `meta` line) as an editable field, shown in
place of the subtitle while the pane is in edit mode.
-}
paneMetaInput : String -> Html Msg
paneMetaInput currentMeta =
    input
        [ class "pane-meta-input"
        , value currentMeta
        , placeholder "Description"
        , type_ "text"
        , onInput EditPaneMeta
        ]
        []


{-| A category header's delete control, shared by the Longevity and
Shopping List columns: a small always-visible ✕ that, once clicked, is
replaced by a Delete/Cancel confirmation. It sits inside a header that is
itself a collapse toggle, so every click stops propagation.
-}
categoryDeleteControl : Bool -> Msg -> Msg -> Msg -> Html Msg
categoryDeleteControl confirming requestMsg confirmMsg cancelMsg =
    if confirming then
        span [ class "cat-delete-confirm" ]
            [ span [ class "cat-delete-confirm-label" ] [ text "Delete?" ]
            , button
                [ type_ "button"
                , class "cat-confirm-delete"
                , stopPropagationOn "click" (Decode.succeed ( confirmMsg, True ))
                ]
                [ text "Delete" ]
            , button
                [ type_ "button"
                , class "cat-confirm-cancel"
                , stopPropagationOn "click" (Decode.succeed ( cancelMsg, True ))
                ]
                [ text "Cancel" ]
            ]

    else
        button
            [ type_ "button"
            , class "cat-delete-btn"
            , title "Delete this category"
            , stopPropagationOn "click" (Decode.succeed ( requestMsg, True ))
            ]
            [ text "✕" ]


removeButton : Msg -> Html Msg
removeButton msg =
    button
        (class "chip-x"
            :: type_ "button"
            :: stopPropagationOn "click" (Decode.succeed ( msg, True ))
            :: styles
                [ ( "font-family", "'IBM Plex Mono',monospace" )
                , ( "font-size", "10px" )
                , ( "font-weight", "700" )
                , ( "padding", "0 3px" )
                , ( "border-radius", "3px" )
                , ( "cursor", "pointer" )
                , ( "border", "none" )
                , ( "background", "transparent" )
                , ( "color", "oklch(0.55 0.12 25)" )
                , ( "line-height", "1.3" )
                , ( "margin-left", "1px" )
                ]
        )
        [ text "✕" ]


viewAdder : Maybe AddTarget -> String -> AddTarget -> String -> String -> Html Msg
viewAdder adding addValue target placeholderText buttonLabel =
    if adding == Just target then
        input
            (value addValue
                :: id addInputId
                :: onInput AddInput
                :: onBlur (CommitAdd target)
                :: on "keydown" (Decode.map AddKeyDown (Decode.field "key" Decode.string))
                :: placeholder placeholderText
                :: autofocus True
                :: type_ "text"
                :: styles
                    [ ( "padding", "3px 8px" )
                    , ( "border", "1px solid oklch(0.68 0.06 128)" )
                    , ( "border-radius", "6px" )
                    , ( "font-size", "13px" )
                    , ( "width", "140px" )
                    , ( "outline", "none" )
                    , ( "color", "oklch(0.3 0.012 70)" )
                    ]
            )
            []

    else
        button
            (class "noprint"
                :: type_ "button"
                :: onClick (StartAdd target)
                :: styles
                    [ ( "align-self", "flex-start" )
                    , ( "padding", "4px 9px" )
                    , ( "border", "1px dashed oklch(0.74 0.04 128)" )
                    , ( "border-radius", "6px" )
                    , ( "background", "transparent" )
                    , ( "color", "oklch(0.48 0.06 128)" )
                    , ( "font-size", "12.5px" )
                    , ( "font-weight", "600" )
                    , ( "cursor", "pointer" )
                    ]
            )
            [ text buttonLabel ]


draggable : Loc -> String -> List (Attribute Msg)
draggable loc foodId =
    attribute "draggable" "true"
        :: on "dragstart" (Decode.succeed (DragStart loc foodId))
        :: [ on "dragend" (Decode.succeed DragEnd) ]


dropZone : Loc -> List (Attribute Msg)
dropZone loc =
    [ preventDefaultOn "dragover" (Decode.succeed ( NoOp, True ))
    , preventDefaultOn "drop" (Decode.succeed ( DropOn loc, True ))
    ]


{-| A pyramid category accepts dropped recipes (to link them) but not
foods. The drop handler is a no-op unless a recipe is being dragged.
-}
recipeDropZone : String -> List (Attribute Msg)
recipeDropZone gid =
    [ preventDefaultOn "dragover" (Decode.succeed ( NoOp, True ))
    , preventDefaultOn "drop" (Decode.succeed ( DropRecipeOnGroup gid, True ))
    ]


{-| A single storage-pane item chip, tinted by the tier its pyramid food
belongs to and highlighted when it matches the current search. Shared by
the Kitchen panes and the Shopping List sections. A `missing` staple
(tracked but not on hand) overrides the tint with the red missing style.
The dictionary maps a food name to its tier's rail colour.
-}
viewItem : Bool -> Set String -> Bool -> String -> Dict String String -> Loc -> Item -> Html Msg
viewItem selectMode selected missing search nameToTierRail loc item =
    let
        bg =
            Dict.get (String.toLower item.name) nameToTierRail
                |> Maybe.map tierChipBg
                |> Maybe.withDefault "oklch(1 0 0)"

        chip =
            if missing then
                stapleMissingStyle

            else if search /= "" && String.contains search (String.toLower item.name) then
                searchHighlightStyle

            else
                foodChipStyle bg False
    in
    span (class "chip" :: chip ++ draggable loc item.id ++ selectAttrs selectMode loc item.id)
        (selectLead selectMode selected loc item.id
            ++ [ span [] [ text item.name ]
               , removeButton (RemoveFoodMsg loc item.id)
               ]
        )


{-| The click-to-select attribute an item badge carries while its column is
in select mode, and nothing otherwise. Dragging still works — a drag
suppresses the click — so the same badge both selects on tap and moves on
drag.
-}
selectAttrs : Bool -> Loc -> String -> List (Attribute Msg)
selectAttrs selectMode loc itemId =
    if selectMode then
        [ onClick (ToggleItemSelected (selKey loc itemId)) ]

    else
        []


{-| The leading selection circle for an item badge, present only in select
mode.
-}
selectLead : Bool -> Set String -> Loc -> String -> List (Html Msg)
selectLead selectMode selected loc itemId =
    if selectMode then
        [ selectionCircle (Set.member (selKey loc itemId) selected) ]

    else
        []


{-| The Staples Tracker's cart button: sends every missing (red) staple
to the Shopping List. It lives in the tracker's collapse-toggle header, so
its click must not propagate up and toggle the pane. It turns green while
`active` — when there is at least one staple it would add.
-}
stapleCartButton : Bool -> Msg -> Html Msg
stapleCartButton active msg =
    button
        [ type_ "button"
        , classList [ ( "staple-cart-btn", True ), ( "staple-cart-btn-active", active ) ]
        , title "Add missing staples to the Shopping List"
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
        [ text "🛒" ]
