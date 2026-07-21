module Ui exposing
    ( addInputId
    , bookmarkButton
    , categoryDeleteControl
    , collapsedColumnBar
    , columnDragAttrs
    , columnTitleBar
    , countArrows
    , countSuffix
    , countToggle
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
    , recipeExportButton
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
columnTitleBar : Maybe String -> String -> Msg -> List (Attribute Msg) -> Html Msg
columnTitleBar maybeBg titleText toggleMsg extraAttrs =
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
            :: extraAttrs
            ++ styles
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


{-| The app-wide count-mode toggle, beside the Select toggle. When on,
item badges outside the pyramid grow up/down arrows to edit their count.
-}
countToggle : Bool -> Msg -> Html Msg
countToggle on msg =
    button
        [ type_ "button"
        , classList [ ( "select-toggle", True ), ( "select-toggle-on", on ) ]
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
        [ text
            ("Count: "
                ++ (if on then
                        "on"

                    else
                        "off"
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
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
        [ text "⬇" ]


{-| The slim vertical bar a column collapses to. The rail class names the
per-column background (a `col-closed-*` rule in the stylesheet); all other
presentation lives on the shared classes, so the narrow-screen stacked mode
can lay the bar flat and turn its title horizontal.
-}
collapsedColumnBar : String -> String -> Msg -> List (Attribute Msg) -> Html Msg
collapsedColumnBar titleText railClass toggleMsg extraAttrs =
    div
        (class "col-closed"
            :: class railClass
            :: onClick toggleMsg
            :: extraAttrs
        )
        [ span [ class "col-closed-caret" ] [ text "▶" ]
        , span [ class "col-closed-title" ] [ text titleText ]
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
        , onClick msg
        ]
        [ span [ classList [ ( "recipe-bookmark-glyph", True ), ( "recipe-bookmark-glyph-on", on ) ] ] [ text "🔖" ] ]


{-| Downloads the recipe as a plain-text `.txt` file.
-}
recipeExportButton : Msg -> Html Msg
recipeExportButton msg =
    button
        [ type_ "button"
        , class "recipe-export-btn"
        , onClick msg
        ]
        [ text "⬇" ]


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
            , stopPropagationOn "click" (Decode.succeed ( requestMsg, True ))
            ]
            [ text "✕" ]


removeButton : Msg -> Html Msg
removeButton msg =
    button
        [ class "chip-x"
        , type_ "button"
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
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


{-| The drag-handle attributes a column's title bar or collapsed bar
carries, so the whole column can be dragged to a new position in the row.
-}
columnDragAttrs : String -> List (Attribute Msg)
columnDragAttrs columnId =
    [ attribute "draggable" "true"
    , on "dragstart" (Decode.succeed (ColumnDragStart columnId))
    , on "dragend" (Decode.succeed ColumnDragEnd)
    ]


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
viewItem : Bool -> Bool -> Set String -> Bool -> String -> Dict String String -> Loc -> Item -> Html Msg
viewItem selectMode countMode selected missing search nameToTierRail loc item =
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
            ++ countArrows countMode loc item
            ++ (span [] [ text item.name ] :: countSuffix countMode item)
            ++ [ removeButton (RemoveFoodMsg loc item.id) ]
        )


{-| The up/down count controls at the left of an item badge, shown only
while count mode is on. The down arrow floors the count at one, and reads
as disabled once there. Their clicks stay off the badge's own drag and
tap-to-select handlers.
-}
countArrows : Bool -> Loc -> Item -> List (Html Msg)
countArrows countMode loc item =
    if countMode then
        [ span [ class "chip-count-ctl" ]
            [ button
                [ type_ "button"
                , class "chip-count-btn"
                , stopPropagationOn "click" (Decode.succeed ( ChangeItemCount loc item.id 1, True ))
                ]
                [ text "▲" ]
            , button
                [ type_ "button"
                , classList [ ( "chip-count-btn", True ), ( "chip-count-btn-min", item.count <= 1 ) ]
                , stopPropagationOn "click" (Decode.succeed ( ChangeItemCount loc item.id (negate 1), True ))
                ]
                [ text "▼" ]
            ]
        ]

    else
        []


{-| The count shown to the right of an item's name — "(3)" — whenever the
count is more than one, and always while count mode is on so the number
being edited is visible even at one.
-}
countSuffix : Bool -> Item -> List (Html Msg)
countSuffix countMode item =
    if item.count > 1 || countMode then
        [ span [ class "chip-count-n" ] [ text ("(" ++ String.fromInt item.count ++ ")") ] ]

    else
        []


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
        , stopPropagationOn "click" (Decode.succeed ( msg, True ))
        ]
        [ text "🛒" ]
