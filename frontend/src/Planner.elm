module Planner exposing
    ( meals
    , plannerText
    )

{-| The Meal Planner's shared pieces: the ordered meal slots every day
carries, and rendering the whole plan — the week's schedule followed by
the full text of every recipe it draws on — as plain text for export.
-}

import Data exposing (Data)
import RecipeExport exposing (recipeText)
import Set


{-| The meal slots every day pane carries, in display order. The view and
the text export share this so a slot cannot appear in one but not the
other.
-}
meals : List String
meals =
    [ "Breakfast", "Lunch", "Dinner", "Snacks" ]


{-| The plan rendered as plain text for export: a "Meal Plan" schedule —
one block per planned day, each meal a line of its recipes — followed by a
"Recipes" appendix with the full text of every recipe the plan uses, each
listed once in the order it first appears, so the file is enough to cook
the week from on its own.
-}
plannerText : Data -> String
plannerText data =
    let
        recipeById recipeId =
            data.recipes
                |> List.filter (\r -> r.id == recipeId)
                |> List.head

        -- The plan's meal slots in reading order: day by day, then meal by
        -- meal, so the recipe appendix follows the same order as the plan.
        orderedRecipeIds =
            List.range 0 (data.plannerDays - 1)
                |> List.concatMap
                    (\day ->
                        meals
                            |> List.concatMap
                                (\meal ->
                                    data.planner
                                        |> List.filter (\e -> e.day == day && e.meal == meal)
                                        |> List.map .recipeId
                                )
                    )

        mealLine day meal =
            case
                data.planner
                    |> List.filter (\e -> e.day == day && e.meal == meal)
                    |> List.filterMap (\e -> Maybe.map .name (recipeById e.recipeId))
            of
                [] ->
                    Nothing

                names ->
                    Just ("  " ++ String.padRight 12 ' ' (meal ++ ":") ++ String.join ", " names)

        renderDay day =
            case List.filterMap (mealLine day) meals of
                [] ->
                    Nothing

                lines ->
                    Just (("Day " ++ String.fromInt (day + 1)) ++ "\n" ++ String.join "\n" lines)

        planBody =
            case List.filterMap renderDay (List.range 0 (data.plannerDays - 1)) of
                [] ->
                    "Nothing planned yet."

                days ->
                    String.join "\n\n" days

        recipesBody =
            orderedRecipeIds
                |> dedupe
                |> List.filterMap recipeById
                |> List.map (\recipe -> String.trimRight (recipeText recipe))
                |> String.join ("\n\n" ++ String.repeat 40 "-" ++ "\n\n")

        section title body =
            title ++ "\n" ++ String.repeat (String.length title) "=" ++ "\n\n" ++ body
    in
    (section "MEAL PLAN" planBody
        :: (if String.isEmpty recipesBody then
                []

            else
                [ section "RECIPES" recipesBody ]
           )
    )
        |> String.join "\n\n\n"
        |> (\text -> text ++ "\n")


{-| The list with later duplicates dropped, keeping each value's first
occurrence in order.
-}
dedupe : List String -> List String
dedupe items =
    List.foldl
        (\x ( seen, acc ) ->
            if Set.member x seen then
                ( seen, acc )

            else
                ( Set.insert x seen, x :: acc )
        )
        ( Set.empty, [] )
        items
        |> Tuple.second
        |> List.reverse
