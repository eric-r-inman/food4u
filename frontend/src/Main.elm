module Main exposing (main)

{-| food4u — longevity staples, kitchen storage, and recipes.

The page is four side-by-side columns, each independently scrolling and
each collapsible to a slim vertical bar: Longevity Foods (the staples
pyramid), Recipes, Kitchen (the storage panes — Pantry, Refrigerator,
Freezer, Counter, Spice Cupboard, Apothecary), and Shopping List. The
pyramid is expanded by default; the others start collapsed. The Shopping
Cart is still a storage pane in the data — it just renders as its own
column rather than inside the Kitchen.

Dragging a food from the pyramid copies it into a storage pane or a
recipe; dragging among storage panes moves it; recipes always receive a
copy. Foods cannot be dropped back onto the pyramid, but a whole recipe
can be dragged (by its grip) onto a pyramid category to link it to a
food badge — those badges show a notepad that opens the recipe. The
whole model is loaded from and saved to the Rust server, which persists
it to a JSON file.

-}

import Browser
import Browser.Dom as Dom
import CartView exposing (viewCartColumn)
import Data exposing (Data, Food, Group, Item, Loc(..), Recipe, Tier, dataDecoder, encodeData, foodInGroup, itemInStorage, listHasName, mapGroup, mapRecipe, mapStorage, pushFood, pushItemTo, pyramidHasName, removeFood, shoppingCartName)
import Derived exposing (inStockNames, recipeMissing)
import Dict exposing (Dict)
import File.Download as Download
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onBlur, onClick, onInput)
import Html.Keyed as Keyed
import Html.Lazy as Lazy
import Http
import Json.Decode as Decode
import KitchenView exposing (viewKitchenColumn)
import Model exposing (Drag, Model, derive, emptyDerived, isOpen)
import Msg exposing (Msg(..))
import RecipeParser exposing (parsePastedRecipe)
import Set exposing (Set)
import Shopping exposing (cartCardId, shoppingListText)
import Style exposing (cardStyle, categoryChipBg, chipBase, foodChipStyle, searchHighlightStyle, styles)
import Task
import Types exposing (AddTarget(..), RecipeFilter(..))
import Ui exposing (addInputId, collapsedColumnBar, columnTitleBar, dropZone, notepadButton, pasteInputId, recipeCartButton, recipeDeleteButton, recipeDropZone, removeButton, viewAdder, viewSearchField)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { data = Nothing
      , error = Nothing
      , adding = Nothing
      , addValue = ""
      , drag = Nothing
      , recipeDrag = Nothing
      , seq = 0
      , toggled = Set.empty
      , pyramidOpen = True
      , recipesOpen = False
      , kitchenOpen = False
      , cartOpen = False
      , search = ""
      , recipeSearch = ""
      , kitchenSearch = ""
      , recipeFilter = AllRecipes
      , pasting = Nothing
      , pasteValue = ""
      , derived = emptyDerived
      }
    , fetchModel
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotModel (Ok data) ->
            ( { model | data = Just data, derived = derive data, error = Nothing }, Cmd.none )

        GotModel (Err _) ->
            ( { model | error = Just "Failed to load food data." }, Cmd.none )

        Saved (Ok ()) ->
            ( model, Cmd.none )

        Saved (Err _) ->
            ( { model | error = Just "Failed to save changes." }, Cmd.none )

        StartAdd target ->
            ( { model | adding = Just target, addValue = "" }
            , Task.attempt (\_ -> NoOp) (Dom.focus addInputId)
            )

        AddInput value ->
            ( { model | addValue = value }, Cmd.none )

        AddKeyDown key ->
            case key of
                "Enter" ->
                    case model.adding of
                        Just target ->
                            commitAdd target model

                        Nothing ->
                            ( model, Cmd.none )

                "Escape" ->
                    ( { model | adding = Nothing, addValue = "" }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        CommitAdd target ->
            commitAdd target model

        CancelAdd ->
            ( { model | adding = Nothing, addValue = "" }, Cmd.none )

        RemoveFoodMsg loc foodId ->
            withData model (\data -> persistData model (removeFood loc foodId data))

        RemoveRecipe rid ->
            withData model
                (\data ->
                    persistData model
                        (unlinkRecipe rid
                            { data | recipes = List.filter (\r -> r.id /= rid) data.recipes }
                        )
                )

        AddRecipeToCart rid ->
            addRecipeToCart rid model

        OpenRecipe rid ->
            case Maybe.andThen (\data -> List.head (List.filter (\r -> r.id == rid) data.recipes)) model.data of
                Just recipe ->
                    ( { model
                        | recipesOpen = True
                        , toggled =
                            model.toggled
                                |> Set.insert ("recipe:" ++ recipe.category)
                                |> Set.insert ("reciperow:" ++ rid)
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        EditRecipeName rid value ->
            -- Live-edit locally; persisted on blur via PersistNow.
            withData model
                (\data ->
                    ( { model | data = Just (mapRecipe rid (\r -> { r | name = value }) data) }
                    , Cmd.none
                    )
                )

        EditRecipeInstructions rid value ->
            withData model
                (\data ->
                    ( { model | data = Just (mapRecipe rid (\r -> { r | instructions = value }) data) }
                    , Cmd.none
                    )
                )

        PersistNow ->
            ( model
            , case model.data of
                Just data ->
                    saveModel data

                Nothing ->
                    Cmd.none
            )

        TogglePyramid ->
            ( { model | pyramidOpen = not model.pyramidOpen }, Cmd.none )

        ToggleRecipes ->
            ( { model | recipesOpen = not model.recipesOpen }, Cmd.none )

        ToggleKitchen ->
            ( { model | kitchenOpen = not model.kitchenOpen }, Cmd.none )

        ToggleCart ->
            ( { model | cartOpen = not model.cartOpen }, Cmd.none )

        SearchInput value ->
            ( { model | search = value }, Cmd.none )

        RecipeSearchInput value ->
            ( { model | recipeSearch = value }, Cmd.none )

        KitchenSearchInput value ->
            ( { model | kitchenSearch = value }, Cmd.none )

        SetRecipeFilter filter ->
            ( { model | recipeFilter = filter }, Cmd.none )

        StartPaste category ->
            ( { model | pasting = Just category, pasteValue = "" }
            , Task.attempt (\_ -> NoOp) (Dom.focus pasteInputId)
            )

        PasteInput value ->
            ( { model | pasteValue = value }, Cmd.none )

        CancelPaste ->
            ( { model | pasting = Nothing, pasteValue = "" }, Cmd.none )

        CommitPaste category ->
            commitPaste category model

        ExportShoppingList ->
            ( model
            , case model.data of
                Just data ->
                    Download.string "shopping-list.txt" "text/plain" (shoppingListText data)

                Nothing ->
                    Cmd.none
            )

        ClearCart ->
            withData model
                (\data ->
                    case cartCardId data of
                        Just cid ->
                            persistData model
                                (mapStorage (StoragePane cid) (always []) data)

                        Nothing ->
                            ( model, Cmd.none )
                )

        ToggleCategory gid ->
            ( { model
                | toggled =
                    if Set.member gid model.toggled then
                        Set.remove gid model.toggled

                    else
                        Set.insert gid model.toggled
              }
            , Cmd.none
            )

        DragStart loc foodId ->
            ( { model | drag = Just (Drag loc foodId) }, Cmd.none )

        DragEnd ->
            ( { model | drag = Nothing }, Cmd.none )

        DropOn target ->
            case ( model.drag, model.data ) of
                ( Just drag, Just data ) ->
                    if drag.from == target then
                        ( { model | drag = Nothing }, Cmd.none )

                    else
                        let
                            ( newData, newSeq ) =
                                performDrop drag target model.seq data
                        in
                        ( { model | data = Just newData, derived = derive newData, seq = newSeq, drag = Nothing }
                        , saveModel newData
                        )

                _ ->
                    ( { model | drag = Nothing }, Cmd.none )

        RecipeDragStart rid ->
            ( { model | recipeDrag = Just rid }, Cmd.none )

        RecipeDragEnd ->
            ( { model | recipeDrag = Nothing }, Cmd.none )

        DropRecipeOnGroup gid ->
            case ( model.recipeDrag, model.data ) of
                ( Just rid, Just data ) ->
                    -- A recipe (dragged by its grip) was dropped: link it.
                    let
                        ( newData, newSeq ) =
                            linkRecipeToGroup rid gid model.seq data
                    in
                    ( { model
                        | data = Just newData
                        , derived = derive newData
                        , seq = newSeq
                        , recipeDrag = Nothing

                        -- Expand the target category so the new linked badge is visible.
                        , toggled = Set.insert gid model.toggled
                      }
                    , saveModel newData
                    )

                ( Nothing, Just data ) ->
                    -- A food/ingredient was dropped onto the pyramid: add it to
                    -- this category as a new food (unless already in the pyramid).
                    case Maybe.andThen (\drag -> draggedNameNa drag data) model.drag of
                        Just ( name, na ) ->
                            if pyramidHasName name data then
                                ( { model | drag = Nothing }, Cmd.none )

                            else
                                let
                                    newData =
                                        pushFood gid (Food (nextId model.seq) name "F" False na "") data
                                in
                                ( { model | data = Just newData, derived = derive newData, seq = model.seq + 1, drag = Nothing, toggled = Set.insert gid model.toggled }
                                , saveModel newData
                                )

                        Nothing ->
                            ( { model | drag = Nothing }, Cmd.none )

                _ ->
                    ( { model | recipeDrag = Nothing }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


withData : Model -> (Data -> ( Model, Cmd Msg )) -> ( Model, Cmd Msg )
withData model fn =
    case model.data of
        Just data ->
            fn data

        Nothing ->
            ( model, Cmd.none )


persistData : Model -> Data -> ( Model, Cmd Msg )
persistData model newData =
    ( { model | data = Just newData, derived = derive newData }, saveModel newData )


commitAdd : AddTarget -> Model -> ( Model, Cmd Msg )
commitAdd target model =
    let
        value =
            String.trim model.addValue
    in
    if value == "" then
        ( { model | adding = Nothing, addValue = "" }, Cmd.none )

    else
        case model.data of
            Just data ->
                let
                    newId =
                        nextId model.seq

                    newData =
                        case target of
                            AddFood (PyramidGroup gid) ->
                                pushFood gid (Food newId value "F" False False "") data

                            AddFood loc ->
                                pushItemTo loc (Item newId value False) data

                            AddRecipe category ->
                                { data | recipes = data.recipes ++ [ Recipe newId value category [] "" ] }
                in
                ( { model | data = Just newData, derived = derive newData, seq = model.seq + 1, adding = Nothing, addValue = "" }
                , saveModel newData
                )

            Nothing ->
                ( { model | adding = Nothing, addValue = "" }, Cmd.none )


nextId : Int -> String
nextId seq =
    "u" ++ String.fromInt seq


{-| Add a recipe parsed from pasted text to the given category.
-}
commitPaste : String -> Model -> ( Model, Cmd Msg )
commitPaste category model =
    if String.trim model.pasteValue == "" then
        ( { model | pasting = Nothing, pasteValue = "" }, Cmd.none )

    else
        case model.data of
            Just data ->
                let
                    parsed =
                        parsePastedRecipe model.pasteValue

                    ( ingredients, seqAfter ) =
                        List.foldl
                            (\nm ( acc, s ) -> ( acc ++ [ Item (nextId s) nm False ], s + 1 ))
                            ( [], model.seq )
                            parsed.ingredients

                    recipe =
                        Recipe (nextId seqAfter) parsed.name category ingredients parsed.instructions

                    newData =
                        { data | recipes = data.recipes ++ [ recipe ] }
                in
                ( { model
                    | data = Just newData
                    , derived = derive newData
                    , seq = seqAfter + 1
                    , pasting = Nothing
                    , pasteValue = ""

                    -- Expand the category so the parsed recipe is visible.
                    , toggled = Set.insert ("recipe:" ++ category) model.toggled
                  }
                , saveModel newData
                )

            Nothing ->
                ( { model | pasting = Nothing, pasteValue = "" }, Cmd.none )


{-| Link a recipe to a pyramid category by name: if a food of that name
already exists in the group, tag it with the recipe id; otherwise create
a new linked badge. Returns the new data and advanced id sequence.
-}
linkRecipeToGroup : String -> String -> Int -> Data -> ( Data, Int )
linkRecipeToGroup rid gid seq data =
    case List.head (List.filter (\r -> r.id == rid) data.recipes) of
        Just recipe ->
            let
                nameLower =
                    String.toLower recipe.name

                exists =
                    data.tiers
                        |> List.concatMap .groups
                        |> List.filter (\g -> g.id == gid)
                        |> List.concatMap .foods
                        |> List.any (\f -> String.toLower f.name == nameLower)
            in
            if exists then
                ( mapGroup gid
                    (\g ->
                        { g
                            | foods =
                                List.map
                                    (\f ->
                                        if String.toLower f.name == nameLower then
                                            { f | recipeId = rid }

                                        else
                                            f
                                    )
                                    g.foods
                        }
                    )
                    data
                , seq
                )

            else
                ( pushFood gid (Food (nextId seq) recipe.name "" False False rid) data, seq + 1 )

        Nothing ->
            ( data, seq )


{-| Clear any food links that point at the given recipe id.
-}
unlinkRecipe : String -> Data -> Data
unlinkRecipe rid data =
    { data
        | tiers =
            List.map
                (\t ->
                    { t
                        | groups =
                            List.map
                                (\g ->
                                    { g
                                        | foods =
                                            List.map
                                                (\f ->
                                                    if f.recipeId == rid then
                                                        { f | recipeId = "" }

                                                    else
                                                        f
                                                )
                                                g.foods
                                    }
                                )
                                t.groups
                    }
                )
                data.tiers
    }


{-| Add every ingredient of a recipe that is not already stocked in some
storage pane (including the cart itself) into the Shopping List pane.
-}
addRecipeToCart : String -> Model -> ( Model, Cmd Msg )
addRecipeToCart rid model =
    case model.data of
        Just data ->
            let
                stocked =
                    inStockNames data

                toAdd =
                    data.recipes
                        |> List.filter (\r -> r.id == rid)
                        |> List.concatMap .ingredients
                        |> List.filter (\i -> not (Set.member (String.toLower i.name) stocked))

                cartId =
                    data.staples
                        |> List.filter (\c -> c.name == shoppingCartName)
                        |> List.head
                        |> Maybe.map .id
            in
            case cartId of
                Just cid ->
                    let
                        ( newData, newSeq ) =
                            List.foldl
                                (\ing ( d, s ) ->
                                    ( pushItemTo (StoragePane cid) (Item (nextId s) ing.name ing.na) d
                                    , s + 1
                                    )
                                )
                                ( data, model.seq )
                                toAdd
                    in
                    ( { model | data = Just newData, derived = derive newData, seq = newSeq }, saveModel newData )

                Nothing ->
                    ( model, Cmd.none )

        Nothing ->
            ( model, Cmd.none )


{-| Whether a recipe passes the current Recipes-column filter.
-}
matchesRecipeFilter : RecipeFilter -> Set String -> Recipe -> Bool
matchesRecipeFilter filter stockedNoCart recipe =
    case filter of
        AllRecipes ->
            True

        CanMakeNow ->
            not (List.isEmpty recipe.ingredients)
                && List.isEmpty (recipeMissing stockedNoCart recipe)

        AlmostThere ->
            let
                n =
                    List.length (recipeMissing stockedNoCart recipe)
            in
            n >= 1 && n <= 2


{-| The name and sodium flag of the dragged food, wherever it came from.
-}
draggedNameNa : Drag -> Data -> Maybe ( String, Bool )
draggedNameNa drag data =
    case drag.from of
        PyramidGroup gid ->
            foodInGroup gid drag.foodId data |> Maybe.map (\f -> ( f.name, f.na ))

        _ ->
            itemInStorage drag.from drag.foodId data |> Maybe.map (\i -> ( i.name, i.na ))


{-| Apply a drop onto a target list. The pyramid is never a target.
Dropping onto a recipe always copies (a recipe ingredient is a
reference, never a move); dropping from the pyramid onto a storage list
copies; dropping between storage lists moves. Every target is
de-duplicated by name. Returns the new data and the advanced id
sequence.
-}
performDrop : Drag -> Loc -> Int -> Data -> ( Data, Int )
performDrop drag target seq data =
    let
        targetIsList =
            case target of
                StoragePane cid ->
                    Just cid == cartCardId data

                _ ->
                    False

        isCopy =
            case ( target, drag.from ) of
                ( RecipeIngredients _, _ ) ->
                    -- Into a recipe: always a reference copy.
                    True

                ( _, RecipeIngredients _ ) ->
                    -- Out of a recipe: copy, leaving the recipe intact.
                    True

                ( _, PyramidGroup _ ) ->
                    True

                _ ->
                    -- Dropping into the Shopping List always copies, so it
                    -- never depletes the pyramid or kitchen it came from.
                    targetIsList
    in
    case ( target, draggedNameNa drag data ) of
        ( PyramidGroup _, _ ) ->
            ( data, seq )

        ( _, Nothing ) ->
            ( data, seq )

        ( _, Just ( name, na ) ) ->
            if isCopy then
                if listHasName target name data then
                    ( data, seq )

                else
                    ( pushItemTo target (Item (nextId seq) name na) data, seq + 1 )

            else if listHasName target name data then
                ( removeFood drag.from drag.foodId data, seq )

            else
                case itemInStorage drag.from drag.foodId data of
                    Just item ->
                        ( data |> removeFood drag.from drag.foodId |> pushItemTo target item, seq )

                    Nothing ->
                        ( data, seq )



-- HTTP


fetchModel : Cmd Msg
fetchModel =
    Http.get { url = "/api/model", expect = Http.expectJson GotModel dataDecoder }


saveModel : Data -> Cmd Msg
saveModel data =
    Http.request
        { method = "PUT"
        , headers = []
        , url = "/api/model"
        , body = Http.jsonBody (encodeData data)
        , expect = Http.expectWhatever Saved
        , timeout = Nothing
        , tracker = Nothing
        }



-- DECODERS / ENCODERS
-- VIEW


view : Model -> Html Msg
view model =
    div [ class "app-root" ]
        [ viewToolbar
        , viewError model.error
        , case model.data of
            Just data ->
                div [ class "page" ]
                    [ div [ class "layout" ]
                        [ viewPyramidColumn model data
                        , viewRecipes model data
                        , viewKitchenColumn model data
                        , viewCartColumn model data
                        ]
                    ]

            Nothing ->
                case model.error of
                    Just _ ->
                        text ""

                    Nothing ->
                        div (styles [ ( "max-width", "1280px" ), ( "margin", "40px auto" ), ( "padding", "0 24px" ), ( "color", "oklch(0.5 0.012 70)" ) ])
                            [ text "Loading…" ]
        ]


viewError : Maybe String -> Html Msg
viewError maybeError =
    case maybeError of
        Just message ->
            div
                (styles
                    [ ( "max-width", "1280px" )
                    , ( "margin", "12px auto 0" )
                    , ( "padding", "10px 24px" )
                    , ( "background", "oklch(0.96 0.03 25)" )
                    , ( "border", "1px solid oklch(0.85 0.06 25)" )
                    , ( "border-radius", "8px" )
                    , ( "color", "oklch(0.5 0.16 25)" )
                    , ( "font-size", "13px" )
                    ]
                )
                [ text message ]

        Nothing ->
            text ""


viewToolbar : Html Msg
viewToolbar =
    div
        (class "noprint"
            :: styles
                [ ( "position", "sticky" )
                , ( "top", "0" )
                , ( "z-index", "60" )
                , ( "background", "oklch(0.985 0.006 86 / 0.92)" )
                , ( "backdrop-filter", "blur(8px)" )
                , ( "border-bottom", "1px solid oklch(0.9 0.012 86)" )
                ]
        )
        [ div
            (styles
                [ ( "display", "flex" )
                , ( "align-items", "center" )
                , ( "gap", "14px" )
                , ( "width", "100%" )
                , ( "padding", "11px 20px" )
                ]
            )
            [ span
                (styles
                    [ ( "font-family", "'IBM Plex Mono',monospace" )
                    , ( "font-size", "15px" )
                    , ( "font-weight", "600" )
                    , ( "letter-spacing", "0.5px" )
                    , ( "color", "oklch(0.4 0.07 128)" )
                    ]
                )
                [ text "food4u" ]
            , span
                (styles [ ( "font-size", "12.5px" ), ( "color", "oklch(0.5 0.012 70)" ) ])
                [ text "Drag a food to a storage pane · changes save automatically" ]
            ]
        ]



-- LEFT PANE: PYRAMID


viewPyramidColumn : Model -> Data -> Html Msg
viewPyramidColumn model data =
    if not model.pyramidOpen then
        collapsedColumnBar "Longevity Foods" "oklch(0.5 0.07 128)" TogglePyramid []

    else
        -- Lazy on the narrow set of inputs the pyramid actually reads, so a
        -- keystroke or drag in another column does not rebuild and re-diff
        -- the ~500-food tree.  Nothing here consults the drag state, so a
        -- drag never re-renders the pyramid at all.
        Lazy.lazy6 viewPyramidBody
            model.search
            model.toggled
            model.adding
            model.addValue
            model.derived.inStock
            data.tiers


viewPyramidBody : String -> Set String -> Maybe AddTarget -> String -> Set String -> List Tier -> Html Msg
viewPyramidBody rawSearch toggled adding addValue inStock tiers =
    let
        search =
            String.toLower (String.trim rawSearch)

        anyMatch =
            search /= "" && List.any (\f -> String.contains search (String.toLower f.name)) (List.concatMap (\t -> List.concatMap .foods t.groups) tiers)
    in
    div (class "pyramid-col-open" :: cardStyle ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ])
        [ columnTitleBar (Just "oklch(0.5 0.07 128)") "Longevity Foods" TogglePyramid
        , div [ class "pyramid-body" ]
            [ viewSearchField "Search foods…" rawSearch (search /= "" && not anyMatch) SearchInput
            , div (styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "10px" ) ])
                (List.map (viewTier toggled adding addValue inStock search) tiers)
            ]
        ]


viewTier : Set String -> Maybe AddTarget -> String -> Set String -> String -> Tier -> Html Msg
viewTier toggled adding addValue inStock search tier =
    let
        foodCount =
            tier.groups |> List.concatMap .foods |> List.length
    in
    div
        (styles
            [ ( "background", tier.tint )
            , ( "border", "1px solid " ++ tier.line )
            , ( "border-radius", "11px" )
            , ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "overflow", "hidden" )
            ]
        )
        [ div
            (styles
                [ ( "background", tier.rail )
                , ( "color", "#fff" )
                , ( "padding", "11px 16px" )
                , ( "display", "flex" )
                , ( "align-items", "baseline" )
                , ( "gap", "10px" )
                ]
            )
            [ span (styles [ ( "font-family", "'IBM Plex Mono',monospace" ), ( "font-size", "11px" ), ( "font-weight", "500" ), ( "opacity", "0.7" ), ( "letter-spacing", "1px" ) ]) [ text tier.no ]
            , span (styles [ ( "font-size", "18px" ), ( "font-weight", "700" ), ( "letter-spacing", "-0.3px" ) ]) [ text tier.name ]
            , span (styles [ ( "font-family", "'IBM Plex Mono',monospace" ), ( "font-size", "10.5px" ), ( "font-weight", "500" ), ( "opacity", "0.9" ), ( "letter-spacing", "0.5px" ) ]) [ text tier.freq ]
            , span (styles [ ( "font-family", "'IBM Plex Mono',monospace" ), ( "font-size", "10px" ), ( "opacity", "0.6" ), ( "letter-spacing", "0.5px" ), ( "margin-left", "auto" ) ]) [ text (String.fromInt foodCount ++ " FOODS") ]
            ]
        , div
            (styles
                [ ( "padding", "14px 16px" )
                , ( "display", "flex" )
                , ( "flex-direction", "column" )
                , ( "gap", "12px" )
                ]
            )
            (List.map (viewCategory toggled adding addValue inStock search tier) tier.groups)
        ]


viewCategory : Set String -> Maybe AddTarget -> String -> Set String -> String -> Tier -> Group -> Html Msg
viewCategory toggled adding addValue inStock search tier group =
    let
        loc =
            PyramidGroup group.id

        categoryHasMatch =
            search /= "" && List.any (\f -> String.contains search (String.toLower f.name)) group.foods

        -- Categories default collapsed; a live search force-expands any
        -- category containing a match.
        isCollapsed =
            not (categoryHasMatch || isOpen False group.id toggled)

        bg =
            categoryChipBg group.label
    in
    div (styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "8px" ) ] ++ recipeDropZone group.id)
        (div
            (onClick (ToggleCategory group.id)
                :: styles
                    [ ( "display", "flex" )
                    , ( "align-items", "baseline" )
                    , ( "gap", "7px" )
                    , ( "font-family", "'IBM Plex Mono',monospace" )
                    , ( "font-size", "11px" )
                    , ( "font-weight", "600" )
                    , ( "letter-spacing", "0.6px" )
                    , ( "text-transform", "uppercase" )
                    , ( "color", tier.rail )
                    , ( "border-bottom", "1px solid " ++ tier.line )
                    , ( "padding-bottom", "5px" )
                    , ( "cursor", "pointer" )
                    , ( "user-select", "none" )
                    ]
            )
            [ span (styles [ ( "font-size", "9px" ), ( "opacity", "0.7" ) ])
                [ text
                    (if isCollapsed then
                        "▶"

                     else
                        "▼"
                    )
                ]
            , span [] [ text group.label ]
            , span (styles [ ( "margin-left", "auto" ), ( "opacity", "0.55" ), ( "font-weight", "500" ) ]) [ text (String.fromInt (List.length group.foods)) ]
            ]
            :: (if isCollapsed then
                    []

                else
                    [ Keyed.node "div"
                        (styles [ ( "display", "flex" ), ( "flex-wrap", "wrap" ), ( "gap", "6px" ) ])
                        (group.foods
                            |> List.sortBy (\f -> String.toLower f.name)
                            |> List.map (\f -> ( f.id, viewFood bg inStock search loc f ))
                        )
                    , viewAdder adding addValue (AddFood loc) "Add food…"
                    ]
               )
        )


viewFood : String -> Set String -> String -> Loc -> Food -> Html Msg
viewFood bg inStock search loc food =
    let
        matches =
            search /= "" && String.contains search (String.toLower food.name)

        chip =
            if matches then
                searchHighlightStyle

            else
                foodChipStyle bg (Set.member (String.toLower food.name) inStock)
    in
    span (class "chip" :: chip ++ Ui.draggable loc food.id)
        ([ span [] [ text food.name ] ]
            ++ (if food.recipeId /= "" then
                    [ notepadButton (OpenRecipe food.recipeId) ]

                else
                    []
               )
            ++ [ removeButton (RemoveFoodMsg loc food.id) ]
        )



-- LEFT PANE: RECIPES


recipeCategories : List String
recipeCategories =
    [ "Breakfast"
    , "Lunch"
    , "Dinner"
    , "Appetizers"
    , "Side Dishes"
    , "Soups & Stews"
    , "Salads"
    , "Main Courses"
    , "Snacks"
    , "Desserts"
    , "Beverages"
    , "Sauces & Condiments"
    ]


{-| The "All / Can make now / Almost there" segmented filter for recipes.
-}
viewRecipeFilterBar : RecipeFilter -> Html Msg
viewRecipeFilterBar active =
    let
        button_ label filter =
            button
                (type_ "button"
                    :: onClick (SetRecipeFilter filter)
                    :: styles
                        [ ( "flex", "1" )
                        , ( "padding", "6px 8px" )
                        , ( "border-radius", "7px" )
                        , ( "border", "1px solid oklch(0.86 0.012 86)" )
                        , ( "cursor", "pointer" )
                        , ( "font-family", "'IBM Plex Mono',monospace" )
                        , ( "font-size", "11px" )
                        , ( "font-weight", "600" )
                        , ( "letter-spacing", "0.2px" )
                        , ( "white-space", "nowrap" )
                        , ( "background"
                          , if active == filter then
                                "oklch(0.5 0.07 145)"

                            else
                                "#fff"
                          )
                        , ( "color"
                          , if active == filter then
                                "#fff"

                            else
                                "oklch(0.45 0.02 60)"
                          )
                        ]
                )
                [ text label ]
    in
    div (styles [ ( "display", "flex" ), ( "gap", "6px" ), ( "margin", "0 0 16px" ) ])
        [ button_ "All" AllRecipes
        , button_ "Can make" CanMakeNow
        , button_ "Almost there" AlmostThere
        ]


{-| The add-recipe footer for a category: the inline "+ Add" / "Paste"
buttons, or — while pasting — a textarea that parses a pasted recipe.
-}
viewRecipeFooter : Model -> String -> Html Msg
viewRecipeFooter model category =
    if model.pasting == Just category then
        div (styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "7px" ) ])
            [ textarea
                (value model.pasteValue
                    :: id pasteInputId
                    :: onInput PasteInput
                    :: placeholder "Paste a recipe (name, ingredients, steps)…"
                    :: rows 8
                    :: styles
                        [ ( "width", "100%" )
                        , ( "padding", "8px 10px" )
                        , ( "border", "1px solid oklch(0.74 0.04 128)" )
                        , ( "border-radius", "7px" )
                        , ( "font-family", "'Archivo',system-ui,sans-serif" )
                        , ( "font-size", "12.5px" )
                        , ( "line-height", "1.5" )
                        , ( "color", "oklch(0.32 0.012 70)" )
                        , ( "outline", "none" )
                        , ( "resize", "vertical" )
                        ]
                )
                []
            , div (styles [ ( "display", "flex" ), ( "gap", "6px" ) ])
                [ button
                    (type_ "button"
                        :: onClick (CommitPaste category)
                        :: styles
                            [ ( "padding", "5px 12px" )
                            , ( "border-radius", "6px" )
                            , ( "border", "1px solid oklch(0.45 0.09 145)" )
                            , ( "background", "oklch(0.52 0.1 145)" )
                            , ( "color", "#fff" )
                            , ( "font-size", "12.5px" )
                            , ( "font-weight", "600" )
                            , ( "cursor", "pointer" )
                            ]
                    )
                    [ text "Add recipe" ]
                , button
                    (type_ "button"
                        :: onClick CancelPaste
                        :: styles
                            [ ( "padding", "5px 12px" )
                            , ( "border-radius", "6px" )
                            , ( "border", "1px solid oklch(0.86 0.012 86)" )
                            , ( "background", "#fff" )
                            , ( "color", "oklch(0.45 0.02 60)" )
                            , ( "font-size", "12.5px" )
                            , ( "font-weight", "600" )
                            , ( "cursor", "pointer" )
                            ]
                    )
                    [ text "Cancel" ]
                ]
            ]

    else
        div (styles [ ( "display", "flex" ), ( "align-items", "center" ), ( "gap", "8px" ) ])
            (viewAdder model.adding model.addValue (AddRecipe category) "New recipe name"
                :: (if model.adding == Just (AddRecipe category) then
                        -- Once the name input is showing, offer "or Paste"
                        -- to its right.
                        [ span (styles [ ( "font-size", "12.5px" ), ( "color", "oklch(0.55 0.012 70)" ) ]) [ text "or" ]
                        , button
                            (class "noprint"
                                :: type_ "button"
                                :: onClick (StartPaste category)
                                :: styles
                                    [ ( "padding", "4px 9px" )
                                    , ( "border", "1px dashed oklch(0.74 0.05 250)" )
                                    , ( "border-radius", "6px" )
                                    , ( "background", "transparent" )
                                    , ( "color", "oklch(0.45 0.08 250)" )
                                    , ( "font-size", "12.5px" )
                                    , ( "font-weight", "600" )
                                    , ( "cursor", "pointer" )
                                    ]
                            )
                            [ text "Paste" ]
                        ]

                    else
                        []
                   )
            )


viewRecipes : Model -> Data -> Html Msg
viewRecipes model data =
    let
        recipeSearch =
            String.toLower (String.trim model.recipeSearch)

        anyRecipeMatch =
            recipeSearch /= "" && List.any (\r -> String.contains recipeSearch (String.toLower r.name)) data.recipes
    in
    if model.recipesOpen then
        div
            (class "recipes-pane-open"
                :: cardStyle
                ++ styles [ ( "overflow", "hidden" ), ( "display", "flex" ), ( "flex-direction", "column" ) ]
            )
            [ div
                (onClick ToggleRecipes
                    :: styles
                        [ ( "background", "oklch(0.43 0.06 250)" )
                        , ( "color", "#fff" )
                        , ( "padding", "12px 16px" )
                        , ( "display", "flex" )
                        , ( "align-items", "center" )
                        , ( "gap", "9px" )
                        , ( "cursor", "pointer" )
                        , ( "user-select", "none" )
                        , ( "flex", "0 0 auto" )
                        ]
                )
                [ span (styles [ ( "font-size", "10px" ), ( "opacity", "0.85" ) ]) [ text "▼" ]
                , span (styles [ ( "font-size", "18px" ), ( "font-weight", "700" ), ( "letter-spacing", "-0.3px" ) ]) [ text "Recipes" ]
                , span (styles [ ( "font-family", "'IBM Plex Mono',monospace" ), ( "font-size", "11px" ), ( "opacity", "0.82" ), ( "margin-left", "auto" ) ]) [ text (String.fromInt (List.length data.recipes) ++ " RECIPES") ]
                ]
            , div [ class "recipes-body" ]
                (viewSearchField "Search recipes…" model.recipeSearch (recipeSearch /= "" && not anyRecipeMatch) RecipeSearchInput
                    :: viewRecipeFilterBar model.recipeFilter
                    :: List.map (viewRecipeCategory model model.derived.nameCategory model.derived.inStock model.derived.stockedNoCart recipeSearch data) recipeCategories
                )
            ]

    else
        div
            (class "recipes-pane-closed"
                :: onClick ToggleRecipes
                :: cardStyle
                ++ styles
                    [ ( "background", "oklch(0.43 0.06 250)" )
                    , ( "color", "#fff" )
                    , ( "cursor", "pointer" )
                    , ( "user-select", "none" )
                    , ( "display", "flex" )
                    , ( "flex-direction", "column" )
                    , ( "align-items", "center" )
                    , ( "gap", "12px" )
                    , ( "padding", "16px 0" )
                    ]
            )
            [ span (styles [ ( "font-size", "11px" ), ( "opacity", "0.85" ) ]) [ text "◀" ]
            , span
                (styles
                    [ ( "writing-mode", "vertical-rl" )
                    , ( "font-size", "16px" )
                    , ( "font-weight", "700" )
                    , ( "letter-spacing", "0.5px" )
                    ]
                )
                [ text "Recipes" ]
            ]


viewRecipeCategory : Model -> Dict String String -> Set String -> Set String -> String -> Data -> String -> Html Msg
viewRecipeCategory model nameToCat inStock stockedNoCart recipeSearch data category =
    let
        key =
            "recipe:" ++ category

        filtering =
            model.recipeFilter /= AllRecipes

        recipesInCat =
            data.recipes
                |> List.filter (\r -> r.category == category)
                |> List.filter (matchesRecipeFilter model.recipeFilter stockedNoCart)

        categoryHasMatch =
            recipeSearch /= "" && List.any (\r -> String.contains recipeSearch (String.toLower r.name)) recipesInCat

        -- Recipe categories default collapsed; a live search or an active
        -- filter force-expands the categories that still have recipes.
        isCollapsed =
            not (categoryHasMatch || filtering || isOpen False key model.toggled)
    in
    if filtering && List.isEmpty recipesInCat then
        text ""

    else
        div (styles [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "gap", "8px" ), ( "margin-bottom", "16px" ) ])
            (div
                (onClick (ToggleCategory key)
                    :: styles
                        [ ( "display", "flex" )
                        , ( "align-items", "baseline" )
                        , ( "gap", "7px" )
                        , ( "font-family", "'IBM Plex Mono',monospace" )
                        , ( "font-size", "11px" )
                        , ( "font-weight", "600" )
                        , ( "letter-spacing", "0.6px" )
                        , ( "text-transform", "uppercase" )
                        , ( "color", "oklch(0.43 0.06 250)" )
                        , ( "border-bottom", "1px solid oklch(0.88 0.02 250)" )
                        , ( "padding-bottom", "5px" )
                        , ( "cursor", "pointer" )
                        , ( "user-select", "none" )
                        ]
                )
                [ span (styles [ ( "font-size", "9px" ), ( "opacity", "0.7" ) ])
                    [ text
                        (if isCollapsed then
                            "▶"

                         else
                            "▼"
                        )
                    ]
                , span [] [ text category ]
                , span (styles [ ( "margin-left", "auto" ), ( "opacity", "0.55" ), ( "font-weight", "500" ) ]) [ text (String.fromInt (List.length recipesInCat)) ]
                ]
                :: (if isCollapsed then
                        []

                    else
                        (if filtering then
                            []

                         else
                            [ viewRecipeFooter model category ]
                        )
                            ++ List.map (viewRecipe model.toggled nameToCat inStock stockedNoCart recipeSearch) recipesInCat
                   )
            )


viewRecipe : Set String -> Dict String String -> Set String -> Set String -> String -> Recipe -> Html Msg
viewRecipe toggled nameToCat inStock stockedNoCart recipeSearch recipe =
    let
        loc =
            RecipeIngredients recipe.id

        matchesSearch =
            recipeSearch /= "" && String.contains recipeSearch (String.toLower recipe.name)

        collapsed =
            not (isOpen False ("reciperow:" ++ recipe.id) toggled)

        -- Ingredients not on hand in a real kitchen pane (not the Shopping
        -- List): what you'd still need to make this recipe now.
        missing =
            recipeMissing stockedNoCart recipe

        -- True when every ingredient is on hand: can be made without shopping.
        allStocked =
            not (List.isEmpty recipe.ingredients) && List.isEmpty missing
    in
    div
        (styles
            [ ( "background"
              , if matchesSearch then
                    "oklch(0.97 0.06 95)"

                else
                    "#fff"
              )
            , ( "border"
              , if matchesSearch then
                    "1.5px solid oklch(0.7 0.16 90)"

                else
                    "1px solid oklch(0.9 0.012 86)"
              )
            , ( "border-radius", "9px" )
            , ( "padding", "10px 12px" )
            ]
        )
        (div (styles [ ( "display", "flex" ), ( "align-items", "center" ), ( "gap", "6px" ) ])
            [ button
                (type_ "button"
                    :: onClick (ToggleCategory ("reciperow:" ++ recipe.id))
                    :: styles [ ( "border", "none" ), ( "background", "transparent" ), ( "cursor", "pointer" ), ( "font-size", "10px" ), ( "opacity", "0.6" ), ( "padding", "2px 4px" ) ]
                )
                [ text
                    (if collapsed then
                        "▶"

                     else
                        "▼"
                    )
                ]
            , input
                (value recipe.name
                    :: onInput (EditRecipeName recipe.id)
                    :: onBlur PersistNow
                    :: placeholder "Recipe name"
                    :: type_ "text"
                    :: size (Basics.max 6 (String.length recipe.name + 1))
                    :: styles
                        [ ( "flex", "0 1 auto" )
                        , ( "min-width", "0" )
                        , ( "border", "none" )
                        , ( "background", "transparent" )
                        , ( "outline", "none" )
                        , ( "font-size", "14.5px" )
                        , ( "font-weight", "600" )
                        , ( "color", "oklch(0.3 0.015 70)" )
                        , ( "padding", "2px 0" )
                        ]
                )
                []
            , if allStocked then
                span
                    (title "You have all the ingredients on hand"
                        :: styles [ ( "color", "oklch(0.55 0.16 150)" ), ( "font-size", "14px" ), ( "font-weight", "700" ), ( "flex", "0 0 auto" ) ]
                    )
                    [ text "✓" ]

              else
                text ""
            , div (styles [ ( "flex", "1" ) ]) []
            , span
                (attribute "draggable" "true"
                    :: on "dragstart" (Decode.succeed (RecipeDragStart recipe.id))
                    :: on "dragend" (Decode.succeed RecipeDragEnd)
                    :: title "Drag onto a pyramid category to link this recipe"
                    :: styles [ ( "cursor", "grab" ), ( "font-size", "13px" ), ( "color", "oklch(0.6 0.012 70)" ), ( "padding", "0 2px" ), ( "user-select", "none" ) ]
                )
                [ text "⠿" ]
            , recipeCartButton (AddRecipeToCart recipe.id)
            , recipeDeleteButton (RemoveRecipe recipe.id)
            ]
            :: (if collapsed then
                    []

                else
                    [ div
                        (styles [ ( "margin-top", "8px" ), ( "display", "flex" ), ( "flex-wrap", "wrap" ), ( "gap", "6px" ), ( "min-height", "30px" ), ( "align-content", "flex-start" ) ]
                            ++ dropZone loc
                        )
                        (if List.isEmpty recipe.ingredients then
                            [ span (styles [ ( "font-size", "12px" ), ( "color", "oklch(0.6 0.012 70)" ), ( "font-style", "italic" ) ]) [ text "Drag ingredients here." ] ]

                         else
                            List.map (viewRecipeItem nameToCat inStock loc) recipe.ingredients
                        )
                    , div (styles [ ( "margin-top", "10px" ), ( "font-family", "'IBM Plex Mono',monospace" ), ( "font-size", "10px" ), ( "font-weight", "600" ), ( "letter-spacing", "0.6px" ), ( "text-transform", "uppercase" ), ( "color", "oklch(0.5 0.04 250)" ) ]) [ text "Instructions" ]
                    , textarea
                        (value recipe.instructions
                            :: onInput (EditRecipeInstructions recipe.id)
                            :: onBlur PersistNow
                            :: placeholder "Ingredients & amounts, then steps…"
                            :: rows 9
                            :: styles
                                [ ( "width", "100%" )
                                , ( "margin-top", "4px" )
                                , ( "padding", "8px 10px" )
                                , ( "border", "1px solid oklch(0.9 0.012 86)" )
                                , ( "border-radius", "7px" )
                                , ( "font-family", "'Archivo',system-ui,sans-serif" )
                                , ( "font-size", "12.5px" )
                                , ( "line-height", "1.5" )
                                , ( "color", "oklch(0.32 0.012 70)" )
                                , ( "outline", "none" )
                                , ( "resize", "vertical" )
                                , ( "white-space", "pre-wrap" )
                                ]
                        )
                        []
                    ]
               )
        )


{-| A recipe ingredient chip. Tinted by pyramid category like other
chips, but outlined in red when the ingredient is not stocked in any
storage pane (a cue to add it to a shopping list).
-}
viewRecipeItem : Dict String String -> Set String -> Loc -> Item -> Html Msg
viewRecipeItem nameToCat inStock loc item =
    let
        inPyramid =
            Dict.member (String.toLower item.name) nameToCat

        bg =
            Dict.get (String.toLower item.name) nameToCat
                |> Maybe.map categoryChipBg
                |> Maybe.withDefault "oklch(1 0 0)"

        stocked =
            Set.member (String.toLower item.name) inStock

        chip =
            if stocked then
                foodChipStyle bg False

            else
                chipBase
                    ++ styles
                        [ ( "background", "oklch(0.96 0.05 25)" )
                        , ( "border", "1.5px solid oklch(0.6 0.18 25)" )
                        , ( "font-weight", "500" )
                        , ( "color", "oklch(0.45 0.16 25)" )
                        ]
    in
    span (class "chip" :: chip ++ Ui.draggable loc item.id)
        ([ span [] [ text item.name ] ]
            ++ (if inPyramid then
                    []

                else
                    [ span
                        (title "Not in food list — drag onto a pyramid category to add it"
                            :: styles
                                [ ( "font-family", "'IBM Plex Mono',monospace" )
                                , ( "font-size", "11px" )
                                , ( "font-weight", "800" )
                                , ( "color", "oklch(0.6 0.2 50)" )
                                , ( "cursor", "help" )
                                ]
                        )
                        [ text "!" ]
                    ]
               )
            ++ [ removeButton (RemoveFoodMsg loc item.id) ]
        )
