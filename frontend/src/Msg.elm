module Msg exposing (Msg(..))

{-| Every message the application can produce. Kept in its own module so
the per-column view modules can depend on it without a cycle back through
Main.
-}

import Data exposing (Data, Loc)
import Http
import Types exposing (AddTarget, RecipeFilter)


type Msg
    = GotModel (Result Http.Error Data)
    | Saved (Result Http.Error ())
    | StartAdd AddTarget
    | AddInput String
    | AddKeyDown String
    | CommitAdd AddTarget
    | CancelAdd
    | RemoveFoodMsg Loc String
    | RemoveRecipe String
    | AddRecipeToCart String
    | EditRecipeName String String
    | EditRecipeInstructions String String
    | PersistNow
    | OpenRecipe String
    | ToggleCategory String
    | TogglePyramid
    | ToggleRecipes
    | ToggleKitchen
    | ToggleCart
    | SearchInput String
    | RecipeSearchInput String
    | KitchenSearchInput String
    | SetRecipeFilter RecipeFilter
    | StartPaste String
    | PasteInput String
    | CommitPaste String
    | CancelPaste
    | ExportShoppingList
    | ClearCart
    | DragStart Loc String
    | DragEnd
    | DropOn Loc
    | RecipeDragStart String
    | RecipeDragEnd
    | DropRecipeOnGroup String
    | NoOp
