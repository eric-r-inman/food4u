module RecipeExport exposing (recipeFileName, recipeText)

{-| Rendering a single recipe as plain text for download, and a filename
derived from its name. The inverse of `RecipeParser`.
-}

import Char
import Data exposing (Recipe)


{-| A recipe as plain text: its name, then its tags, ingredients, and
instructions as labelled blocks, each omitted when empty.
-}
recipeText : Recipe -> String
recipeText recipe =
    let
        block title body =
            if String.trim body == "" then
                []

            else
                [ title ++ "\n" ++ body ]
    in
    ([ recipe.name ]
        ++ block "Tags" (String.join ", " recipe.tags)
        ++ block "Ingredients" (String.join "\n" (List.map (\i -> "- " ++ i.name) recipe.ingredients))
        ++ block "Instructions" recipe.instructions
    )
        |> String.join "\n\n"
        |> (\body -> body ++ "\n")


{-| A safe `.txt` filename from a recipe's name: lowercased with each run of
non-alphanumeric characters collapsed to a single hyphen, falling back to
"recipe" when the name has no usable characters.
-}
recipeFileName : Recipe -> String
recipeFileName recipe =
    let
        slug =
            recipe.name
                |> String.toLower
                |> String.map
                    (\c ->
                        if Char.isAlphaNum c then
                            c

                        else
                            ' '
                    )
                |> String.words
                |> String.join "-"
    in
    (if String.isEmpty slug then
        "recipe"

     else
        slug
    )
        ++ ".txt"
