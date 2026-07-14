module Msg exposing (Msg(..))

{-| Every message the application can produce. Kept in its own module so
the per-column view modules can depend on it without a cycle back through
Main.
-}

import Ai
import Data exposing (Data, Loc)
import Http
import Types exposing (AddTarget, Me, RecipeFilter)


type Msg
    = GotModel (Result Http.Error Data)
    | GotMe (Result Http.Error Me)
    | Saved (Result Http.Error ())
    | StartAdd AddTarget
    | AddInput String
    | AddKeyDown String
    | CommitAdd AddTarget
    | CancelAdd
    | RemoveFoodMsg Loc String
    | RemoveRecipe String
    | ToggleBookmark String
    | RemovePane String
    | RemoveCategory String
    | RequestDelete String
    | CancelDelete
    | StartEditPane String
    | EditPaneName String
    | EditPaneMeta String
    | TogglePaneColorPicker
    | SetPaneColor String
    | RequestDeletePane
    | CancelDeletePane
    | CommitPaneEdit
    | CancelPaneEdit
    | AddRecipeToCart String
    | AddStaplesToCart
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
    | SetRecipeTagFilter String
    | RemoveRecipeTag String String
    | StartPaste String
    | PasteInput String
    | CommitPaste String
    | CancelPaste
    | ExportShoppingList
    | ExportRecipe String
    | ClearCart
    | ToggleSelectMode
    | ToggleItemSelected String
    | MoveSelectedTo Loc
    | DeselectAll
    | DragStart Loc String
    | DragEnd
    | DropOn Loc
    | RecipeDragStart String
    | RecipeDragEnd
    | DropRecipeOnGroup String
    | RecipeDragEnterCategory String
    | DropRecipeOnCategory String
    | RecipeDragEnterRecipe String
    | DropRecipeOnRecipe String
    | OpenAi String
    | CloseAi
    | AiToggleConfigure
    | AiSetProvider Ai.Provider
    | AiSetKey String
    | AiSetModel String
    | AiSetInclude String
    | AiSetExclude String
    | AiSetAllergies String
    | AiSetRequest String
    | AiToggleKitchen
    | AiToggleMoreOptions
    | AiToggleAddMissing
    | AiGenerate
    | GotAiRecipe (Result String Ai.GeneratedRecipe)
    | AiAccept
    | AiBackToForm
    | NoOp
