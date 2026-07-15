module PlannerView exposing (viewPlannerColumn)

{-| The Meal Planner column: a run of day panes ("Day 1".."Day N", grown
and shrunk one day at a time), each with a Breakfast/Lunch/Dinner/Snacks
slot that recipes are dragged into. A drop copies the recipe by reference —
the recipe stays in the Recipes column — so the same recipe can be planned
any number of times. Entries jump to their recipe via a magnifying glass
and carry their own remove control.
-}

import Data exposing (Data, PlannerEntry, Recipe)
import Html exposing (Attribute, Html, button, div, span, text)
import Html.Attributes exposing (class, classList, disabled, type_)
import Html.Events exposing (on, onClick, preventDefaultOn)
import Json.Decode as Decode
import Model exposing (Model, isOpen)
import Msg exposing (Msg(..))
import Set exposing (Set)
import Ui exposing (collapsedColumnBar, columnDragAttrs, columnTitleBar)


{-| The column's rail colour, resolved from the stylesheet's palette so the
plum lives in one place.
-}
plannerColor : String
plannerColor =
    "var(--planner-rail)"


meals : List String
meals =
    [ "Breakfast", "Lunch", "Dinner", "Snacks" ]


{-| How many days the planner can grow to, and shrink to.
-}
maxDays : Int
maxDays =
    10


minDays : Int
minDays =
    1


viewPlannerColumn : Model -> Data -> Html Msg
viewPlannerColumn model data =
    if not model.plannerOpen then
        collapsedBar

    else
        div [ class "planner-col-open" ]
            [ columnTitleBar (Just plannerColor) "Meal Planner" TogglePlanner (columnDragAttrs "planner")
            , div [ class "planner-body" ]
                (List.map
                    (viewDay data.planner data.recipes model.toggled model.recipeDrag model.plannerDropTarget)
                    (List.range 0 (data.plannerDays - 1))
                    ++ [ viewDayControls data.plannerDays ]
                )
            ]


{-| The "Add Day" / "Remove Day" pair under the last day pane, growing the
plan one day at a time up to the ceiling, or dropping the last day.
-}
viewDayControls : Int -> Html Msg
viewDayControls plannerDays =
    div [ class "planner-day-controls" ]
        [ button
            [ type_ "button"
            , class "planner-day-btn"
            , disabled (plannerDays >= maxDays)
            , onClick AddPlannerDay
            ]
            [ text "+ Add Day" ]
        , button
            [ type_ "button"
            , class "planner-day-btn"
            , disabled (plannerDays <= minDays)
            , onClick RemovePlannerDay
            ]
            [ text "− Remove Day" ]
        ]


collapsedBar : Html Msg
collapsedBar =
    collapsedColumnBar "Meal Planner" plannerColor TogglePlanner (columnDragAttrs "planner")


{-| One day pane, "Day 1".."Day N": a plum rail header carrying the day's
name, its planned-entry count, and a collapse toggle, over the meal slots.
-}
viewDay : List PlannerEntry -> List Recipe -> Set String -> Maybe String -> Maybe ( Int, String ) -> Int -> Html Msg
viewDay planner recipes toggled recipeDrag dropTarget day =
    let
        dayName =
            "Day " ++ String.fromInt (day + 1)

        collapseKey =
            "planner:day-" ++ String.fromInt day

        collapsed =
            not (isOpen True collapseKey toggled)

        planned =
            List.length (List.filter (\e -> e.day == day) planner)
    in
    div [ class "planner-day" ]
        (div [ class "planner-day-header", onClick (ToggleCategory collapseKey) ]
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


{-| One planned recipe: a full-width card — the remove control at the far
left, then the magnifying glass that jumps to the recipe in the Recipes
column, then the recipe's full name. An entry whose recipe no longer
exists renders nothing.
-}
viewEntry : List Recipe -> PlannerEntry -> Maybe (Html Msg)
viewEntry recipes entry =
    recipes
        |> List.filter (\r -> r.id == entry.recipeId)
        |> List.head
        |> Maybe.map
            (\recipe ->
                div [ class "planner-entry" ]
                    [ button
                        [ type_ "button"
                        , class "planner-entry-x"
                        , onClick (RemovePlannerEntry entry.id)
                        ]
                        [ text "✕" ]
                    , button
                        [ type_ "button"
                        , class "planner-entry-open"
                        , onClick (OpenRecipe recipe.id)
                        ]
                        [ text "🔍" ]
                    , span [ class "planner-entry-name" ] [ text recipe.name ]
                    ]
            )
