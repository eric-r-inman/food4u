module PlannerView exposing (viewPlannerColumn)

{-| The Meal Planner column: a week of day panes, Sunday first, each with a
Breakfast/Lunch/Dinner/Snacks slot that recipes are dragged into. A drop
copies the recipe by reference — the recipe stays in the Recipes column —
so the same recipe can be planned any number of times. Entries open their
recipe on click and carry their own remove control.
-}

import Data exposing (Data, PlannerEntry, Recipe)
import Html exposing (Attribute, Html, button, div, span, text)
import Html.Attributes exposing (class, classList, title, type_)
import Html.Events exposing (on, onClick, preventDefaultOn)
import Json.Decode as Decode
import Model exposing (Model, isOpen)
import Msg exposing (Msg(..))
import Set exposing (Set)
import Ui exposing (collapsedColumnBar, columnTitleBar)


{-| The column's rail colour, resolved from the stylesheet's palette so the
plum lives in one place.
-}
plannerColor : String
plannerColor =
    "var(--planner-rail)"


days : List String
days =
    [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]


meals : List String
meals =
    [ "Breakfast", "Lunch", "Dinner", "Snacks" ]


viewPlannerColumn : Model -> Data -> Html Msg
viewPlannerColumn model data =
    if not model.plannerOpen then
        collapsedBar

    else
        div [ class "planner-col-open" ]
            [ columnTitleBar (Just plannerColor) "Meal Planner" TogglePlanner
            , div [ class "planner-body" ]
                (List.indexedMap
                    (viewDay data.planner data.recipes model.toggled model.recipeDrag model.plannerDropTarget)
                    days
                )
            ]


collapsedBar : Html Msg
collapsedBar =
    collapsedColumnBar "Meal Planner" plannerColor TogglePlanner []


{-| One day of the week: a plum rail header carrying the day's name, its
planned-entry count, and a collapse toggle, over the four meal slots.
-}
viewDay : List PlannerEntry -> List Recipe -> Set String -> Maybe String -> Maybe ( Int, String ) -> Int -> String -> Html Msg
viewDay planner recipes toggled recipeDrag dropTarget day dayName =
    let
        collapsed =
            not (isOpen True ("planner:" ++ dayName) toggled)

        planned =
            List.length (List.filter (\e -> e.day == day) planner)
    in
    div [ class "planner-day" ]
        (div [ class "planner-day-header", onClick (ToggleCategory ("planner:" ++ dayName)) ]
            [ span [ class "planner-day-arrow" ]
                [ text
                    (if collapsed then
                        "▶"

                     else
                        "▼"
                    )
                ]
            , span [ class "planner-day-name" ] [ text dayName ]
            , span [ class "planner-day-count" ]
                [ text
                    (if planned == 0 then
                        ""

                     else
                        String.fromInt planned ++ " PLANNED"
                    )
                ]
            ]
            :: (if collapsed then
                    []

                else
                    [ div [ class "planner-day-body" ]
                        (List.map (viewMeal planner recipes recipeDrag dropTarget day) meals)
                    ]
               )
        )


{-| One meal slot of a day: its label over the entries planned into it.
While a recipe is being dragged the slot is a drop target, highlighted
when the pointer is over it.
-}
viewMeal : List PlannerEntry -> List Recipe -> Maybe String -> Maybe ( Int, String ) -> Int -> String -> Html Msg
viewMeal planner recipes recipeDrag dropTarget day meal =
    let
        entries =
            List.filter (\e -> e.day == day && e.meal == meal) planner

        isTarget =
            recipeDrag /= Nothing && dropTarget == Just ( day, meal )
    in
    div [ class "planner-meal" ]
        [ div [ class "planner-meal-label" ] [ text meal ]
        , div
            (classList [ ( "planner-slot", True ), ( "recipe-drop-target", isTarget ) ]
                :: plannerDropAttrs recipeDrag day meal
            )
            (if List.isEmpty entries then
                [ span [ class "planner-slot-hint" ] [ text "Drag a recipe here." ] ]

             else
                List.filterMap (viewEntry recipes) entries
            )
        ]


{-| The drop handlers a meal slot carries while a recipe is being dragged,
and nothing otherwise.
-}
plannerDropAttrs : Maybe String -> Int -> String -> List (Attribute Msg)
plannerDropAttrs recipeDrag day meal =
    if recipeDrag == Nothing then
        []

    else
        [ preventDefaultOn "dragover" (Decode.succeed ( NoOp, True ))
        , on "dragenter" (Decode.succeed (RecipeDragEnterPlanner day meal))
        , preventDefaultOn "drop" (Decode.succeed ( DropRecipeOnPlanner day meal, True ))
        ]


{-| One planned recipe: a chip that opens the recipe on click, with its own
remove control. An entry whose recipe no longer exists renders nothing.
-}
viewEntry : List Recipe -> PlannerEntry -> Maybe (Html Msg)
viewEntry recipes entry =
    recipes
        |> List.filter (\r -> r.id == entry.recipeId)
        |> List.head
        |> Maybe.map
            (\recipe ->
                span [ class "planner-entry" ]
                    [ span
                        [ class "planner-entry-name"
                        , title "Open recipe"
                        , onClick (OpenRecipe recipe.id)
                        ]
                        [ text recipe.name ]
                    , button
                        [ type_ "button"
                        , class "planner-entry-x"
                        , title "Remove from plan"
                        , onClick (RemovePlannerEntry entry.id)
                        ]
                        [ text "✕" ]
                    ]
            )
