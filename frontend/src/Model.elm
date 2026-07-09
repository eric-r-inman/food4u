module Model exposing (AiState, Drag, Indices, Model, PaneEdit, derive, emptyDerived, initialAi, isOpen)

{-| The application model, the in-progress drag, and the indices cached on
the model. The indices are recomputed once whenever the data changes (see
`derive`) so the views consult a precomputed lookup rather than rescanning
every food and storage item on each render.
-}

import Ai
import Data exposing (Data, Loc)
import Derived
import Dict exposing (Dict)
import Set exposing (Set)
import Types exposing (AddTarget, Me, RecipeFilter)


type alias Drag =
    { from : Loc
    , foodId : String
    }


{-| The AI recipe assistant's state. `settings` and `prefs` persist across
sessions; the rest is the transient state of the panel: which category it
is open for, whether the settings view is showing, the current form fields,
and where generation stands.
-}
type alias AiState =
    { settings : Ai.Settings
    , prefs : Ai.Prefs
    , open : Maybe String
    , configuring : Bool
    , request : String
    , useKitchen : Bool
    , moreOptions : Bool
    , addMissing : Bool
    , status : Ai.Status
    }


{-| The initial assistant state, seeded with the settings and preferences
restored from the browser.
-}
initialAi : Ai.Settings -> Ai.Prefs -> AiState
initialAi settings prefs =
    { settings = settings
    , prefs = prefs
    , open = Nothing
    , configuring = False
    , request = ""
    , useKitchen = False
    , moreOptions = False
    , addMissing = True
    , status = Ai.Idle
    }


{-| A buffered edit of one storage pane. `id` identifies the pane; `name`,
`meta`, and `rail` (the header colour) are the working values shown until
the edit is committed or cancelled. `colorOpen` tracks the colour picker,
and `confirmingDelete` the pending delete confirmation.
-}
type alias PaneEdit =
    { id : String
    , name : String
    , meta : String
    , rail : String
    , colorOpen : Bool
    , confirmingDelete : Bool
    }


type alias Model =
    { data : Maybe Data
    , error : Maybe String
    , adding : Maybe AddTarget
    , addValue : String
    , drag : Maybe Drag
    , recipeDrag : Maybe String

    -- While a recipe is being dragged, the recipe category the pointer is
    -- currently over, so it can be highlighted as the move target.
    , recipeDropCategory : Maybe String
    , seq : Int

    -- Keys whose collapse is *toggled away from their default*. Food and
    -- recipe categories and individual recipes default collapsed; storage
    -- panes default expanded. So membership flips whichever default
    -- applies at each site (see `isOpen`).
    , toggled : Set String
    , pyramidOpen : Bool
    , recipesOpen : Bool
    , kitchenOpen : Bool
    , cartOpen : Bool
    , search : String
    , recipeSearch : String
    , kitchenSearch : String
    , recipeFilter : RecipeFilter
    , pasting : Maybe String
    , pasteValue : String

    -- The in-progress edit of a storage pane's name and description, if
    -- any.  The edit is buffered here rather than applied to `data` as it
    -- is typed, so cancelling it (Escape) simply drops the buffer with
    -- nothing to undo; committing (Enter) writes it back and saves.
    , editingPane : Maybe PaneEdit

    -- The signed-in identity from `/me`, once fetched.  Drives the
    -- sign-in / sign-out control in the toolbar.
    , me : Maybe Me

    -- The AI recipe assistant: the user's provider settings and remembered
    -- preferences, plus the transient state of an open generation panel.
    , ai : AiState

    -- Indices derived from `data`, recomputed only when the data changes
    -- (see `derive`), so the views consult them instead of rescanning
    -- every food and storage item on each render.
    , derived : Indices
    }


{-| Precomputed lookups over `Data`. Rebuilding these on every render was
the dominant per-keystroke cost, so they are recomputed once at each data
change and cached on the model instead.
-}
type alias Indices =
    { nameCategory : Dict String String
    , categoryRanks : Dict String Int
    , inStock : Set String
    , stockedNoCart : Set String
    }


emptyDerived : Indices
emptyDerived =
    { nameCategory = Dict.empty
    , categoryRanks = Dict.empty
    , inStock = Set.empty
    , stockedNoCart = Set.empty
    }


derive : Data -> Indices
derive data =
    { nameCategory = Derived.nameCategory data
    , categoryRanks = Derived.categoryRanks data
    , inStock = Derived.inStockNames data
    , stockedNoCart = Derived.stockedExcludingCart data
    }


{-| Whether a collapse target is currently open, given its default-open
state and whether the user has toggled it.
-}
isOpen : Bool -> String -> Set String -> Bool
isOpen defaultOpen key toggled =
    if Set.member key toggled then
        not defaultOpen

    else
        defaultOpen
