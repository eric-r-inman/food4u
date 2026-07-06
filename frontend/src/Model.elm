module Model exposing (Drag, Indices, Model, derive, emptyDerived, isOpen)

{-| The application model, the in-progress drag, and the indices cached on
the model. The indices are recomputed once whenever the data changes (see
`derive`) so the views consult a precomputed lookup rather than rescanning
every food and storage item on each render.
-}

import Data exposing (Data, Loc)
import Derived
import Dict exposing (Dict)
import Set exposing (Set)
import Types exposing (AddTarget, RecipeFilter)


type alias Drag =
    { from : Loc
    , foodId : String
    }


type alias Model =
    { data : Maybe Data
    , error : Maybe String
    , adding : Maybe AddTarget
    , addValue : String
    , drag : Maybe Drag
    , recipeDrag : Maybe String
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
