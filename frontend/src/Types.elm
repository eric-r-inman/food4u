module Types exposing (AddTarget(..), Me, RecipeFilter(..))

{-| Small UI/interaction types shared across the model, the messages, and
the views: what an inline add-input is creating, the Recipes-column stock
filter, and the signed-in identity.
-}

import Data exposing (Loc)


{-| The current identity, from the server's `/me`. `authEnabled` is false
for a local unauthenticated run; when true, `name` is the signed-in user
or "anonymous".
-}
type alias Me =
    { name : String
    , authEnabled : Bool
    }


{-| What an inline add-input is currently creating: a food in a list, a
new recipe in a category, a new Kitchen storage pane, or a new food
category in a pyramid tier (identified by its tier id).
-}
type AddTarget
    = AddFood Loc
    | AddRecipe String
    | AddPane
    | AddCategory String


{-| Filter for the Recipes column by how stocked each recipe is.
-}
type RecipeFilter
    = AllRecipes
    | CanMakeNow
    | AlmostThere
