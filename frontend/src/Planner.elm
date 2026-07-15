module Planner exposing
    ( meals
    , plannerText
    )

{-| The Meal Planner's shared pieces: the ordered meal slots every day
carries, and rendering the whole plan — day by day, meal by meal — as
plain text for export.
-}

import Data exposing (Data)


{-| The meal slots every day pane carries, in display order. The view and
the text export share this so a slot cannot appear in one but not the
other.
-}
meals : List String
meals =
    [ "Breakfast", "Lunch", "Dinner", "Snacks" ]


{-| The plan rendered as plain text: one section per day that has any
planned recipes, each meal a line of its recipes beneath the day. Empty
days and empty meals are omitted, mirroring the Shopping List export.
-}
plannerText : Data -> String
plannerText data =
    let
        recipeName recipeId =
            data.recipes
                |> List.filter (\r -> r.id == recipeId)
                |> List.head
                |> Maybe.map .name

        mealLine day meal =
            case
                data.planner
                    |> List.filter (\e -> e.day == day && e.meal == meal)
                    |> List.filterMap (\e -> recipeName e.recipeId)
            of
                [] ->
                    Nothing

                names ->
                    Just (meal ++ ": " ++ String.join ", " names)

        renderDay day =
            case List.filterMap (mealLine day) meals of
                [] ->
                    Nothing

                lines ->
                    Just
                        (("Day " ++ String.fromInt (day + 1))
                            ++ "\n"
                            ++ String.join "\n" (List.map (\line -> "  " ++ line) lines)
                        )
    in
    List.range 0 (data.plannerDays - 1)
        |> List.filterMap renderDay
        |> String.join "\n\n"
        |> (\body -> "Meal Plan\n\n" ++ body ++ "\n")
