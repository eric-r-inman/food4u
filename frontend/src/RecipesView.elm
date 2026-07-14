module RecipesView exposing (viewRecipes)

{-| The Recipes column: recipes grouped by meal category, each an
editable card with draggable ingredient chips and a stocked-now check. A
category can be filtered to "can make now" / "almost there", and a new
recipe added by name or parsed from pasted text.
-}

import AiView
import Data exposing (Data, Item, Loc(..), Recipe)
import Derived exposing (recipeMissing)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (custom, on, onBlur, onClick, onInput, preventDefaultOn, stopPropagationOn)
import Json.Decode as Decode
import Model exposing (Model, isOpen)
import Msg exposing (Msg(..))
import Set exposing (Set)
import Style exposing (cardStyle, chipBase, foodChipStyle, styles, tierChipBg)
import Types exposing (AddTarget(..), RecipeFilter(..))
import Ui exposing (bookmarkButton, dropZone, pasteInputId, recipeCartButton, recipeDeleteButton, recipeExportButton, removeButton, selectAttrs, selectLead, viewAdder, viewSearchField)


recipeCategories : List String
recipeCategories =
    [ "Breakfast"
    , "Lunch"
    , "Dinner"
    , "Appetizers"
    , "Side Dishes"
    , "Soups & Stews"
    , "Salads"
    , "Main Courses"
    , "Snacks"
    , "Desserts"
    , "Beverages"
    , "Sauces & Condiments"
    ]


{-| Whether a recipe passes the current Recipes-column filter.
-}
matchesRecipeFilter : RecipeFilter -> Set String -> Recipe -> Bool
matchesRecipeFilter filter stockedNoCart recipe =
    case filter of
        AllRecipes ->
            True

        CanMakeNow ->
            not (List.isEmpty recipe.ingredients)
                && List.isEmpty (recipeMissing stockedNoCart recipe)

        AlmostThere ->
            let
                n =
                    List.length (recipeMissing stockedNoCart recipe)
            in
            n >= 1 && n <= 2


{-| Whether a recipe carries the tag the list is filtered to. No tag
filter (Nothing) matches every recipe.
-}
matchesTag : Maybe String -> Recipe -> Bool
matchesTag tagFilter recipe =
    case tagFilter of
        Nothing ->
            True

        Just tag ->
            List.member tag recipe.tags


{-| The tag filter dropdown shown to the right of the search field: one
option per distinct tag across all recipes, plus "All tags" to clear it.
Selecting a tag hides every recipe without it; only one tag filters at a
time. Kept narrow so it fits beside the search field without widening the
column.
-}
viewTagFilter : Maybe String -> Data -> Html Msg
viewTagFilter selectedTag data =
    select
        [ class "recipe-tag-select noprint"
        , title "Show only recipes with the selected tag"
        , value (Maybe.withDefault "" selectedTag)
        , onInput SetRecipeTagFilter
        ]
        (option [ value "" ] [ text "All tags" ]
            :: List.map
                (\tag -> option [ value tag ] [ text tag ])
                (data.recipes |> List.concatMap .tags |> Set.fromList |> Set.toList)
        )


{-| A single tag chip in a recipe's tag editor: the tag text and an ✕ that
removes the tag from that recipe.
-}
viewTagChip : String -> String -> Html Msg
viewTagChip rid tag =
    span [ class "recipe-tag" ]
        [ text tag
        , button
            [ type_ "button", class "recipe-tag-x", title "Remove tag", onClick (RemoveRecipeTag rid tag) ]
            [ text "✕" ]
        ]


{-| The "All / Can make now / Almost there" segmented filter for recipes.
-}
viewRecipeFilterBar : RecipeFilter -> Html Msg
viewRecipeFilterBar active =
    let
        button_ label filter =
            button
                (type_ "button"
                    :: onClick (SetRecipeFilter filter)
                    :: styles
                        [ ( "flex", "1" )
                        , ( "padding", "6px 8px" )
                        , ( "border-radius", "7px" )
                        , ( "border", "1px solid oklch(0.86 0.012 86)" )
                        , ( "cursor", "pointer" )
                        , ( "font-family", "'IBM Plex Mono',monospace" )
                        , ( "font-size", "11px" )
                        , ( "font-weight", "600" )
                        , ( "letter-spacing", "0.2px" )
                        , ( "white-space", "nowrap" )
                        , ( "background"
                          , if active == filter then
                                "oklch(0.5 0.07 145)"

                            else
                                "#fff"
                          )
                        , ( "color"
                          , if active == filter then
                                "#fff"

                            else
                                "oklch(0.45 0.02 60)"
                          )
                        ]
                )
                [ text label ]
    in
    div (styles [ ( "display", "flex" ), ( "gap", "6px" ), ( "margin", "0 0 16px" ) ])
        [ button_ "All" AllRecipes
        , button_ "Can make" CanMakeNow
        , button_ "Almost there" AlmostThere
        ]


{-| Keep the new-recipe name input focused when the sibling Paste or AI
button is pressed. The input commits (and clears itself) on blur; without
this, pressing those buttons would blur the input, remove them in the
re-render, and the click would never land — so nothing would happen.
Preventing the mousedown default stops the blur.
-}
keepAddInput : Attribute Msg
keepAddInput =
    preventDefaultOn "mousedown" (Decode.succeed ( NoOp, True ))


{-| The add-recipe footer for a category: the inline "+ Add" / "Paste"
buttons, or — while pasting — a textarea that parses a pasted recipe.
-}
viewRecipeFooter : Model -> String -> Html Msg
viewRecipeFooter model category =
    if model.ai.open == Just category then
        AiView.viewPanel model category

    else if model.pasting == Just category then
        div (styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "7px" ) ])
            [ textarea
                (value model.pasteValue
                    :: id pasteInputId
                    :: onInput PasteInput
                    :: placeholder "Paste a recipe (name, ingredients, steps)…"
                    :: rows 8
                    :: styles
                        [ ( "width", "100%" )
                        , ( "padding", "8px 10px" )
                        , ( "border", "1px solid oklch(0.74 0.04 128)" )
                        , ( "border-radius", "7px" )
                        , ( "font-family", "'Archivo',system-ui,sans-serif" )
                        , ( "font-size", "12.5px" )
                        , ( "line-height", "1.5" )
                        , ( "color", "oklch(0.32 0.012 70)" )
                        , ( "outline", "none" )
                        , ( "resize", "vertical" )
                        ]
                )
                []
            , div (styles [ ( "display", "flex" ), ( "gap", "6px" ) ])
                [ button
                    (type_ "button"
                        :: onClick (CommitPaste category)
                        :: styles
                            [ ( "padding", "5px 12px" )
                            , ( "border-radius", "6px" )
                            , ( "border", "1px solid oklch(0.45 0.09 145)" )
                            , ( "background", "oklch(0.52 0.1 145)" )
                            , ( "color", "#fff" )
                            , ( "font-size", "12.5px" )
                            , ( "font-weight", "600" )
                            , ( "cursor", "pointer" )
                            ]
                    )
                    [ text "Add recipe" ]
                , button
                    (type_ "button"
                        :: onClick CancelPaste
                        :: styles
                            [ ( "padding", "5px 12px" )
                            , ( "border-radius", "6px" )
                            , ( "border", "1px solid oklch(0.86 0.012 86)" )
                            , ( "background", "#fff" )
                            , ( "color", "oklch(0.45 0.02 60)" )
                            , ( "font-size", "12.5px" )
                            , ( "font-weight", "600" )
                            , ( "cursor", "pointer" )
                            ]
                    )
                    [ text "Cancel" ]
                ]
            ]

    else
        div (styles [ ( "display", "flex" ), ( "align-items", "center" ), ( "flex-wrap", "wrap" ), ( "gap", "8px" ) ])
            (viewAdder model.adding model.addValue (AddRecipe category) "New recipe name" "+ Add"
                :: (if model.adding == Just (AddRecipe category) then
                        -- Once the name input is showing, offer "or Paste"
                        -- and "or AI" to its right.
                        [ span [ class "recipe-or" ] [ text "or" ]
                        , button
                            (class "noprint"
                                :: type_ "button"
                                :: onClick (StartPaste category)
                                :: keepAddInput
                                :: styles
                                    [ ( "padding", "4px 9px" )
                                    , ( "border", "1px dashed oklch(0.74 0.05 250)" )
                                    , ( "border-radius", "6px" )
                                    , ( "background", "transparent" )
                                    , ( "color", "oklch(0.45 0.08 250)" )
                                    , ( "font-size", "12.5px" )
                                    , ( "font-weight", "600" )
                                    , ( "cursor", "pointer" )
                                    ]
                            )
                            [ text "Paste" ]
                        , span [ class "recipe-or" ] [ text "or" ]
                        , button
                            [ class "recipe-ai-btn noprint", type_ "button", onClick (OpenAi category), keepAddInput ]
                            [ text "AI" ]
                        ]

                    else
                        []
                   )
            )


viewRecipes : Model -> Data -> Html Msg
viewRecipes model data =
    let
        recipeSearch =
            String.toLower (String.trim model.recipeSearch)

        anyRecipeMatch =
            recipeSearch /= "" && List.any (\r -> String.contains recipeSearch (String.toLower r.name)) data.recipes
    in
    if model.recipesOpen then
        div
            (class "recipes-pane-open"
                :: cardStyle
                ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ]
            )
            [ div
                (onClick ToggleRecipes
                    :: styles
                        [ ( "background", "oklch(0.43 0.06 250)" )
                        , ( "color", "#fff" )
                        , ( "padding", "12px 16px" )
                        , ( "display", "flex" )
                        , ( "align-items", "center" )
                        , ( "gap", "9px" )
                        , ( "cursor", "pointer" )
                        , ( "user-select", "none" )
                        , ( "flex", "0 0 auto" )
                        ]
                )
                [ span (styles [ ( "font-size", "10px" ), ( "opacity", "0.85" ) ]) [ text "▼" ]
                , span (styles [ ( "font-size", "18px" ), ( "font-weight", "700" ), ( "letter-spacing", "-0.3px" ) ]) [ text "Recipes" ]
                , span (styles [ ( "font-family", "'IBM Plex Mono',monospace" ), ( "font-size", "11px" ), ( "opacity", "0.82" ), ( "margin-left", "auto" ) ]) [ text (String.fromInt (List.length data.recipes) ++ " RECIPES") ]
                ]
            , div [ class "recipes-body" ]
                (viewSearchField "Search recipes…" model.recipeSearch (recipeSearch /= "" && not anyRecipeMatch) RecipeSearchInput [ viewTagFilter model.recipeTagFilter data ]
                    :: viewRecipeFilterBar model.recipeFilter
                    :: List.map (viewRecipeCategory model model.derived.nameTierRail model.derived.inStock model.derived.stockedNoCart recipeSearch data) recipeCategories
                )
            ]

    else
        div
            (class "recipes-pane-closed"
                :: onClick ToggleRecipes
                :: cardStyle
                ++ styles
                    [ ( "background", "oklch(0.43 0.06 250)" )
                    , ( "color", "#fff" )
                    , ( "cursor", "pointer" )
                    , ( "user-select", "none" )
                    , ( "display", "flex" )
                    , ( "flex-direction", "column" )
                    , ( "align-items", "center" )
                    , ( "gap", "12px" )
                    , ( "padding", "16px 0" )
                    ]
            )
            [ span (styles [ ( "font-size", "11px" ), ( "opacity", "0.85" ) ]) [ text "◀" ]
            , span
                (styles
                    [ ( "writing-mode", "vertical-rl" )
                    , ( "font-size", "16px" )
                    , ( "font-weight", "700" )
                    , ( "letter-spacing", "0.5px" )
                    ]
                )
                [ text "Recipes" ]
            ]


viewRecipeCategory : Model -> Dict String String -> Set String -> Set String -> String -> Data -> String -> Html Msg
viewRecipeCategory model nameToTierRail inStock stockedNoCart recipeSearch data category =
    let
        key =
            "recipe:" ++ category

        filtering =
            model.recipeFilter /= AllRecipes || model.recipeTagFilter /= Nothing

        recipesInCat =
            data.recipes
                |> List.filter (\r -> r.category == category)
                |> List.filter (matchesRecipeFilter model.recipeFilter stockedNoCart)
                |> List.filter (matchesTag model.recipeTagFilter)

        bookmarkedCount =
            List.length (List.filter .bookmarked recipesInCat)

        categoryHasMatch =
            recipeSearch /= "" && List.any (\r -> String.contains recipeSearch (String.toLower r.name)) recipesInCat

        -- Recipe categories default collapsed; a live search or an active
        -- filter force-expands the categories that still have recipes.
        isCollapsed =
            not (categoryHasMatch || filtering || isOpen False key model.toggled)

        -- The category the dragged recipe is currently over, so it reads as
        -- the move target.
        isDropTarget =
            model.recipeDrag /= Nothing && model.recipeDropCategory == Just category

        -- Categories become recipe drop targets only while a recipe is
        -- being dragged; a drop moves the recipe into this category.
        dropAttrs =
            if model.recipeDrag == Nothing then
                []

            else
                [ preventDefaultOn "dragover" (Decode.succeed ( NoOp, True ))
                , on "dragenter" (Decode.succeed (RecipeDragEnterCategory category))
                , preventDefaultOn "drop" (Decode.succeed ( DropRecipeOnCategory category, True ))
                ]
    in
    if filtering && List.isEmpty recipesInCat then
        text ""

    else
        div
            (classList [ ( "recipe-drop-target", isDropTarget ) ]
                :: dropAttrs
                ++ styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "8px" ), ( "margin-bottom", "16px" ) ]
            )
            (div
                (onClick (ToggleCategory key)
                    :: styles
                        [ ( "display", "flex" )
                        , ( "align-items", "baseline" )
                        , ( "gap", "7px" )
                        , ( "font-family", "'IBM Plex Mono',monospace" )
                        , ( "font-size", "11px" )
                        , ( "font-weight", "600" )
                        , ( "letter-spacing", "0.6px" )
                        , ( "text-transform", "uppercase" )
                        , ( "color", "oklch(0.43 0.06 250)" )
                        , ( "border-bottom", "1px solid oklch(0.88 0.02 250)" )
                        , ( "padding-bottom", "5px" )
                        , ( "cursor", "pointer" )
                        , ( "user-select", "none" )
                        ]
                )
                [ span (styles [ ( "font-size", "9px" ), ( "opacity", "0.7" ) ])
                    [ text
                        (if isCollapsed then
                            "▶"

                         else
                            "▼"
                        )
                    ]
                , span [] [ text category ]
                , if bookmarkedCount > 0 then
                    span [ class "recipe-cat-bookmarks", title "Bookmarked recipes" ] [ text ("🔖 " ++ String.fromInt bookmarkedCount) ]

                  else
                    text ""
                , span (styles [ ( "margin-left", "auto" ), ( "opacity", "0.55" ), ( "font-weight", "500" ) ]) [ text (String.fromInt (List.length recipesInCat)) ]
                ]
                :: (if isCollapsed then
                        []

                    else
                        (if filtering then
                            []

                         else
                            [ viewRecipeFooter model category ]
                        )
                            ++ List.map (viewRecipe model.toggled model.selection.active model.selection.items nameToTierRail inStock stockedNoCart recipeSearch model.recipeDrag model.recipeDropBefore model.adding model.addValue) recipesInCat
                   )
            )


viewRecipe : Set String -> Bool -> Set String -> Dict String String -> Set String -> Set String -> String -> Maybe String -> Maybe String -> Maybe AddTarget -> String -> Recipe -> Html Msg
viewRecipe toggled selectMode selected nameToTierRail inStock stockedNoCart recipeSearch recipeDrag dropBefore adding addValue recipe =
    let
        loc =
            RecipeIngredients recipe.id

        -- While any recipe is being dragged, every card is a reorder drop
        -- target; a drop lands the dragged card just before this one. The
        -- handlers stop propagation so the drop does not also bubble to the
        -- category (which would re-home to the category's end instead).
        reorderAttrs =
            if recipeDrag == Nothing then
                []

            else
                [ preventDefaultOn "dragover" (Decode.succeed ( NoOp, True ))
                , stopPropagationOn "dragenter" (Decode.succeed ( RecipeDragEnterRecipe recipe.id, True ))
                , custom "drop" (Decode.succeed { message = DropRecipeOnRecipe recipe.id, stopPropagation = True, preventDefault = True })
                ]

        -- The insertion line shows above the hovered target, but never above
        -- the dragged card itself (dropping onto itself is a no-op).
        showDropLine =
            dropBefore == Just recipe.id && recipeDrag /= Just recipe.id

        matchesSearch =
            recipeSearch /= "" && String.contains recipeSearch (String.toLower recipe.name)

        collapsed =
            not (isOpen False ("reciperow:" ++ recipe.id) toggled)

        -- Ingredients not on hand in a real kitchen pane (not the Shopping
        -- List): what you'd still need to make this recipe now.
        missing =
            recipeMissing stockedNoCart recipe

        -- True when every ingredient is on hand: can be made without shopping.
        allStocked =
            not (List.isEmpty recipe.ingredients) && List.isEmpty missing

        -- The cart button has work — and so shows green — when some
        -- ingredient is neither in the Kitchen nor already on the Shopping
        -- List (the two the `inStock` set covers).
        cartActive =
            List.any (\i -> not (Set.member (String.toLower i.name) inStock)) recipe.ingredients
    in
    div
        (classList [ ( "recipe-card", True ), ( "recipe-reorder-before", showDropLine ) ]
            :: reorderAttrs
            ++ styles
                [ ( "background"
                  , if matchesSearch then
                        "oklch(0.97 0.06 95)"

                    else
                        "#fff"
                  )
                , ( "border"
                  , if matchesSearch then
                        "1.5px solid oklch(0.7 0.16 90)"

                    else
                        "1px solid oklch(0.9 0.012 86)"
                  )
                , ( "border-radius", "9px" )
                , ( "padding", "10px 12px" )
                ]
        )
        (div (styles [ ( "display", "flex" ), ( "align-items", "center" ), ( "gap", "6px" ) ])
            [ button
                (type_ "button"
                    :: onClick (ToggleCategory ("reciperow:" ++ recipe.id))
                    :: styles [ ( "border", "none" ), ( "background", "transparent" ), ( "cursor", "pointer" ), ( "font-size", "10px" ), ( "opacity", "0.6" ), ( "padding", "2px 4px" ) ]
                )
                [ text
                    (if collapsed then
                        "▶"

                     else
                        "▼"
                    )
                ]
            , input
                (value recipe.name
                    :: onInput (EditRecipeName recipe.id)
                    :: onBlur PersistNow
                    :: placeholder "Recipe name"
                    :: type_ "text"
                    :: size (Basics.max 6 (String.length recipe.name + 1))
                    :: styles
                        [ ( "flex", "0 1 auto" )
                        , ( "min-width", "0" )
                        , ( "border", "none" )
                        , ( "background", "transparent" )
                        , ( "outline", "none" )
                        , ( "font-size", "14.5px" )
                        , ( "font-weight", "600" )
                        , ( "color", "oklch(0.3 0.015 70)" )
                        , ( "padding", "2px 0" )
                        ]
                )
                []
            , if allStocked then
                span
                    (title "You have all the ingredients on hand"
                        :: styles [ ( "color", "oklch(0.55 0.16 150)" ), ( "font-size", "14px" ), ( "font-weight", "700" ), ( "flex", "0 0 auto" ) ]
                    )
                    [ text "✓" ]

              else
                text ""
            , div (styles [ ( "flex", "1" ) ]) []
            , span
                (class "recipe-grip"
                    :: attribute "draggable" "true"
                    :: on "dragstart" (Decode.succeed (RecipeDragStart recipe.id))
                    :: on "dragend" (Decode.succeed RecipeDragEnd)
                    :: title "Drag onto another card to reorder, onto a category to re-home, or onto a pyramid category to link"
                    :: styles [ ( "cursor", "grab" ), ( "font-size", "13px" ), ( "color", "oklch(0.6 0.012 70)" ), ( "padding", "0 2px" ), ( "user-select", "none" ) ]
                )
                [ text "⠿" ]
            , bookmarkButton recipe.bookmarked (ToggleBookmark recipe.id)
            , recipeCartButton cartActive (AddRecipeToCart recipe.id)
            , recipeExportButton (ExportRecipe recipe.id)
            , recipeDeleteButton (RemoveRecipe recipe.id)
            ]
            :: (if collapsed then
                    []

                else
                    [ div
                        (styles [ ( "margin-top", "8px" ), ( "display", "flex" ), ( "flex-wrap", "wrap" ), ( "gap", "6px" ), ( "min-height", "30px" ), ( "align-content", "flex-start" ) ]
                            ++ dropZone loc
                        )
                        (if List.isEmpty recipe.ingredients then
                            [ span (styles [ ( "font-size", "12px" ), ( "color", "oklch(0.6 0.012 70)" ), ( "font-style", "italic" ) ]) [ text "Drag ingredients here." ] ]

                         else
                            List.map (viewRecipeItem selectMode selected nameToTierRail inStock loc) recipe.ingredients
                        )
                    , div [ class "recipe-section-label" ] [ text "Tags" ]
                    , div [ class "recipe-tags" ]
                        (List.map (viewTagChip recipe.id) recipe.tags
                            ++ [ viewAdder adding addValue (AddRecipeTag recipe.id) "New tag…" "+ Tag" ]
                        )
                    , div [ class "recipe-section-label" ] [ text "Instructions" ]
                    , textarea
                        (value recipe.instructions
                            :: onInput (EditRecipeInstructions recipe.id)
                            :: onBlur PersistNow
                            :: placeholder "Ingredients & amounts, then steps…"
                            :: rows 9
                            :: styles
                                [ ( "width", "100%" )
                                , ( "margin-top", "4px" )
                                , ( "padding", "8px 10px" )
                                , ( "border", "1px solid oklch(0.9 0.012 86)" )
                                , ( "border-radius", "7px" )
                                , ( "font-family", "'Archivo',system-ui,sans-serif" )
                                , ( "font-size", "12.5px" )
                                , ( "line-height", "1.5" )
                                , ( "color", "oklch(0.32 0.012 70)" )
                                , ( "outline", "none" )
                                , ( "resize", "vertical" )
                                , ( "white-space", "pre-wrap" )
                                ]
                        )
                        []
                    ]
               )
        )


{-| A recipe ingredient chip. Tinted by pyramid category like other
chips, but outlined in red when the ingredient is not stocked in any
storage pane (a cue to add it to a shopping list).
-}
viewRecipeItem : Bool -> Set String -> Dict String String -> Set String -> Loc -> Item -> Html Msg
viewRecipeItem selectMode selected nameToTierRail inStock loc item =
    let
        inPyramid =
            Dict.member (String.toLower item.name) nameToTierRail

        bg =
            Dict.get (String.toLower item.name) nameToTierRail
                |> Maybe.map tierChipBg
                |> Maybe.withDefault "oklch(1 0 0)"

        stocked =
            Set.member (String.toLower item.name) inStock

        chip =
            if stocked then
                foodChipStyle bg False

            else
                chipBase
                    ++ styles
                        [ ( "background", "oklch(0.96 0.05 25)" )
                        , ( "border", "1.5px solid oklch(0.6 0.18 25)" )
                        , ( "font-weight", "500" )
                        , ( "color", "oklch(0.45 0.16 25)" )
                        ]
    in
    span (class "chip" :: chip ++ Ui.draggable loc item.id ++ selectAttrs selectMode loc item.id)
        (selectLead selectMode selected loc item.id
            ++ [ span [] [ text item.name ] ]
            ++ (if inPyramid then
                    []

                else
                    [ span
                        (title "Not in food list — drag onto a pyramid category to add it"
                            :: styles
                                [ ( "font-family", "'IBM Plex Mono',monospace" )
                                , ( "font-size", "11px" )
                                , ( "font-weight", "800" )
                                , ( "color", "oklch(0.6 0.2 50)" )
                                , ( "cursor", "help" )
                                ]
                        )
                        [ text "!" ]
                    ]
               )
            ++ [ removeButton (RemoveFoodMsg loc item.id) ]
        )
