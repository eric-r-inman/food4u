module Types exposing (AddTarget(..), RecipeFilter(..))

{-| Small UI/interaction types shared across the model, the messages, and
the views: what an inline add-input is creating, and the Recipes-column
stock filter.
-}

import Data exposing (Loc)


{-| What an inline add-input is currently creating: a food in a list, or
a new recipe in a category.
-}
type AddTarget
    = AddFood Loc
    | AddRecipe String


{-| Filter for the Recipes column by how stocked each recipe is.
-}
type RecipeFilter
    = AllRecipes
    | CanMakeNow
    | AlmostThere
