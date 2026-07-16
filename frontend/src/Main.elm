port module Main exposing (main)

{-| Longevity Pantry — longevity staples, kitchen storage, and recipes.

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

import Ai
import Browser
import Browser.Dom as Dom
import Browser.Events
import CartView exposing (viewCartColumn)
import Data exposing (Card, Data, Food, Group, Item, Loc(..), PlannerEntry, Recipe, cartZone, dataDecoder, encodeData, foodInGroup, isShoppingCard, itemInStorage, listHasName, mapCard, mapGroup, mapRecipe, mapStorage, moveRecipeBefore, moveRecipeToCategoryEnd, parseSelKey, pushFood, pushGroup, pushItemTo, pyramidHasName, removeFood, removeGroup, selKey, shoppingCartName, staplesTrackerId, staplesTrackerName)
import Derived exposing (inStockNames)
import Dict exposing (Dict)
import File.Download as Download
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onBlur, onClick, onInput, preventDefaultOn)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import KitchenView exposing (viewKitchenColumn)
import Model exposing (Drag, Model, derive, emptyDerived, initialAi, isOpen, noSelection)
import Msg exposing (Msg(..))
import Planner exposing (plannerText)
import PlannerView exposing (viewPlannerColumn)
import Process
import PyramidView exposing (viewPyramidColumn)
import RecipeExport exposing (recipeFileName, recipeText)
import RecipeParser exposing (parsePastedRecipe)
import RecipesView exposing (recipeCardDomId, recipeCategories, recipeNameLimit, recipesBodyId, viewRecipes)
import Set exposing (Set)
import Shopping exposing (cartCardId, shoppingListText)
import Style exposing (styles)
import Task
import Types exposing (AddTarget(..), Me, RecipeFilter(..))
import Ui exposing (addInputId, editingPaneDomId, pasteInputId, selectToggle)


{-| Persist the AI settings and preferences to the browser's localStorage.
The value is the object `Ai.encodeStore` produces; the API key it carries
is the user's own and stays on their machine.
-}
port persistAi : Encode.Value -> Cmd msg


main : Program Decode.Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Decode.Value -> ( Model, Cmd Msg )
init flags =
    let
        ( settings, prefs ) =
            Ai.decodeStore flags
    in
    ( { data = Nothing
      , error = Nothing
      , adding = Nothing
      , addValue = ""
      , drag = Nothing
      , recipeDrag = Nothing
      , recipeDropCategory = Nothing
      , recipeDropBefore = Nothing
      , plannerDropTarget = Nothing
      , columnDrag = Nothing
      , columnDropTarget = Nothing
      , seq = 0
      , toggled = Set.empty
      , pyramidOpen = True
      , recipesOpen = False
      , kitchenOpen = False
      , cartOpen = False
      , plannerOpen = False
      , search = ""
      , recipeSearch = ""
      , kitchenSearch = ""
      , recipeFilter = AllRecipes
      , recipeTagFilter = Nothing
      , pasting = Nothing
      , pasteValue = ""
      , me = Nothing
      , editingPane = Nothing
      , confirmingDelete = Nothing
      , selection = noSelection
      , ai = initialAi settings prefs
      , derived = emptyDerived
      }
    , Cmd.batch [ fetchModel, fetchMe ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    -- While a pane is being edited: a mousedown outside it closes the editor
    -- without saving, and Enter/Escape commit/cancel from anywhere (so a
    -- colour-only change need not return focus to a text field first).
    case model.editingPane of
        Just _ ->
            Sub.batch
                [ Browser.Events.onMouseDown (clickOutside editingPaneDomId CancelPaneEdit)
                , Browser.Events.onKeyDown paneEditKey
                ]

        Nothing ->
            Sub.none


{-| Enter commits the pane edit, Escape cancels it; any other key produces
no message.
-}
paneEditKey : Decode.Decoder Msg
paneEditKey =
    Decode.field "key" Decode.string
        |> Decode.andThen
            (\key ->
                case key of
                    "Enter" ->
                        Decode.succeed CommitPaneEdit

                    "Escape" ->
                        Decode.succeed CancelPaneEdit

                    _ ->
                        Decode.fail "ignored"
            )


{-| Fire `msg` when a click's target is not the element with `domId` nor a
descendant of it — i.e. a click outside that element.
-}
clickOutside : String -> Msg -> Decode.Decoder Msg
clickOutside domId msg =
    Decode.field "target" (isInside domId)
        |> Decode.andThen
            (\inside ->
                if inside then
                    Decode.fail "click was inside"

                else
                    Decode.succeed msg
            )


{-| Whether the decoded node, or any of its ancestors, has the given id.
Walks up `parentNode` until a match is found or the root is reached.
-}
isInside : String -> Decode.Decoder Bool
isInside domId =
    Decode.oneOf
        [ Decode.field "id" Decode.string
            |> Decode.andThen
                (\id ->
                    if id == domId then
                        Decode.succeed True

                    else
                        Decode.field "parentNode" (Decode.lazy (\_ -> isInside domId))
                )
        , Decode.field "parentNode" (Decode.lazy (\_ -> isInside domId))
        , Decode.succeed False
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotModel (Ok data) ->
            let
                withTracker =
                    ensureStaplesTracker (ensureRecipeCategories data)

                -- Start the id sequence past every id already in the model, so
                -- freshly minted ids never collide with persisted ones (which
                -- a reset-to-zero sequence would, and the store rejects). The
                -- default Shopping List categories are minted from here.
                ( withCategories, seqAfter ) =
                    ensureCartCategories (nextSeq withTracker) withTracker
            in
            ( { model | data = Just withCategories, derived = derive withCategories, seq = seqAfter, error = Nothing }, Cmd.none )

        GotModel (Err _) ->
            ( { model | error = Just "Failed to load food data." }, Cmd.none )

        GotMe (Ok me) ->
            ( { model | me = Just me }, Cmd.none )

        GotMe (Err _) ->
            ( model, Cmd.none )

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
            -- Deleting a recipe also unlinks its pyramid badges and clears
            -- its Meal Planner entries, so nothing dangles.
            withData model
                (\data ->
                    persistData model
                        (unlinkRecipe rid
                            { data
                                | recipes = List.filter (\r -> r.id /= rid) data.recipes
                                , planner = List.filter (\e -> e.recipeId /= rid) data.planner
                            }
                        )
                )

        ToggleBookmark rid ->
            withData model
                (\data -> persistData model (mapRecipe rid (\r -> { r | bookmarked = not r.bookmarked }) data))

        RemovePane pid ->
            withData model
                (\data ->
                    persistData { model | editingPane = Nothing, confirmingDelete = Nothing }
                        { data | staples = List.filter (\c -> c.id /= pid) data.staples }
                )

        RemoveCategory gid ->
            withData model
                (\data -> persistData { model | confirmingDelete = Nothing } (removeGroup gid data))

        RequestDelete id ->
            ( { model | confirmingDelete = Just id }, Cmd.none )

        CancelDelete ->
            ( { model | confirmingDelete = Nothing }, Cmd.none )

        StartEditPane pid ->
            -- Seed the edit buffer from the pane's current name, description,
            -- and colour; nothing is written back until it is committed.
            withData model
                (\data ->
                    ( { model
                        | editingPane =
                            data.staples
                                |> List.filter (\c -> c.id == pid)
                                |> List.head
                                |> Maybe.map
                                    (\c ->
                                        { id = pid
                                        , name = c.name
                                        , meta = c.meta
                                        , rail = c.rail
                                        , colorOpen = False
                                        , confirmingDelete = False
                                        }
                                    )
                      }
                    , Cmd.none
                    )
                )

        EditPaneName value ->
            ( { model | editingPane = Maybe.map (\e -> { e | name = value }) model.editingPane }
            , Cmd.none
            )

        EditPaneMeta value ->
            ( { model | editingPane = Maybe.map (\e -> { e | meta = value }) model.editingPane }
            , Cmd.none
            )

        TogglePaneColorPicker ->
            ( { model | editingPane = Maybe.map (\e -> { e | colorOpen = not e.colorOpen }) model.editingPane }
            , Cmd.none
            )

        SetPaneColor color ->
            ( { model | editingPane = Maybe.map (\e -> { e | rail = color }) model.editingPane }
            , Cmd.none
            )

        RequestDeletePane ->
            ( { model | editingPane = Maybe.map (\e -> { e | confirmingDelete = True }) model.editingPane }
            , Cmd.none
            )

        CancelDeletePane ->
            ( { model | editingPane = Maybe.map (\e -> { e | confirmingDelete = False }) model.editingPane }
            , Cmd.none
            )

        CommitPaneEdit ->
            -- Write the buffered edit back to the pane and save.
            case ( model.editingPane, model.data ) of
                ( Just edit, Just data ) ->
                    persistData { model | editingPane = Nothing }
                        (mapCard edit.id (\c -> { c | name = edit.name, meta = edit.meta, rail = edit.rail }) data)

                _ ->
                    ( { model | editingPane = Nothing }, Cmd.none )

        CancelPaneEdit ->
            -- Drop the buffer; `data` was never touched, so nothing to undo.
            ( { model | editingPane = Nothing }, Cmd.none )

        AddRecipeToCart rid ->
            addRecipeToCart rid model

        AddStaplesToCart ->
            addStaplesToCart model

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
                    , scrollRecipeIntoView rid
                    )

                Nothing ->
                    ( model, Cmd.none )

        EditRecipeName rid value ->
            -- Live-edit locally; persisted on blur via PersistNow.
            withData model
                (\data ->
                    ( { model | data = Just (mapRecipe rid (\r -> { r | name = String.left recipeNameLimit value }) data) }
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
            ( model, model.data |> Maybe.map saveModel |> Maybe.withDefault Cmd.none )

        TogglePyramid ->
            ( { model | pyramidOpen = not model.pyramidOpen }, Cmd.none )

        ToggleRecipes ->
            ( { model | recipesOpen = not model.recipesOpen }, Cmd.none )

        ToggleKitchen ->
            ( { model | kitchenOpen = not model.kitchenOpen }, Cmd.none )

        ToggleCart ->
            ( { model | cartOpen = not model.cartOpen }, Cmd.none )

        TogglePlanner ->
            ( { model | plannerOpen = not model.plannerOpen }, Cmd.none )

        SearchInput value ->
            ( { model | search = value }, Cmd.none )

        RecipeSearchInput value ->
            ( { model | recipeSearch = value }, Cmd.none )

        KitchenSearchInput value ->
            ( { model | kitchenSearch = value }, Cmd.none )

        SetRecipeFilter filter ->
            ( { model | recipeFilter = filter }, Cmd.none )

        SetRecipeTagFilter tag ->
            -- The dropdown's "All tags" option carries an empty value.
            ( { model
                | recipeTagFilter =
                    if tag == "" then
                        Nothing

                    else
                        Just tag
              }
            , Cmd.none
            )

        RemoveRecipeTag rid tag ->
            withData model
                (\data -> persistData model (mapRecipe rid (\r -> { r | tags = List.filter (\t -> t /= tag) r.tags }) data))

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
            , model.data
                |> Maybe.map (\data -> Download.string "shopping-list.txt" "text/plain" (shoppingListText data))
                |> Maybe.withDefault Cmd.none
            )

        ExportRecipe rid ->
            ( model
            , model.data
                |> Maybe.andThen (\data -> List.head (List.filter (\r -> r.id == rid) data.recipes))
                |> Maybe.map (\recipe -> Download.string (recipeFileName recipe) "text/plain" (recipeText recipe))
                |> Maybe.withDefault Cmd.none
            )

        ClearCart ->
            -- Empty every Shopping List card — the reserved cart and each
            -- category — but keep the categories themselves.
            withData model
                (\data ->
                    persistData model
                        { data
                            | staples =
                                List.map
                                    (\c ->
                                        if isShoppingCard c then
                                            { c | items = [] }

                                        else
                                            c
                                    )
                                    data.staples
                        }
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

        ToggleSelectMode ->
            -- Flipping select mode starts a fresh selection, so no stale
            -- picks linger from a previous round.
            ( { model | selection = { active = not model.selection.active, items = Set.empty } }
            , Cmd.none
            )

        ToggleItemSelected key ->
            ( { model
                | selection =
                    { active = model.selection.active
                    , items = toggleMember key model.selection.items
                    }
              }
            , Cmd.none
            )

        MoveSelectedTo target ->
            -- Move every selected item into the clicked area, keeping them
            -- selected (at their new home if they moved) so a further
            -- destination can be chosen.
            withData model
                (\data ->
                    let
                        ( newData, newSeq, newKeys ) =
                            moveSelectedHere target (Set.toList model.selection.items) model.seq data
                    in
                    ( { model
                        | data = Just newData
                        , derived = derive newData
                        , seq = newSeq
                        , selection = { active = model.selection.active, items = Set.fromList newKeys }
                      }
                    , saveModel newData
                    )
                )

        DeselectAll ->
            ( { model | selection = { active = model.selection.active, items = Set.empty } }, Cmd.none )

        DragStart loc foodId ->
            ( { model | drag = Just (Drag loc foodId) }, Cmd.none )

        DragEnd ->
            ( { model | drag = Nothing }, Cmd.none )

        DropOn target ->
            case ( model.drag, model.data ) of
                ( Just drag, Just data ) ->
                    -- Dragging a badge that is one of several selected moves
                    -- the whole selection; otherwise it is an ordinary
                    -- single drop.
                    if Set.size model.selection.items > 1 && Set.member (selKey drag.from drag.foodId) model.selection.items then
                        let
                            ( newData, newSeq ) =
                                performMultiDrop (Set.toList model.selection.items) target model.seq data
                        in
                        ( { model
                            | data = Just newData
                            , derived = derive newData
                            , seq = newSeq
                            , drag = Nothing
                            , selection = { active = model.selection.active, items = Set.empty }
                          }
                        , saveModel newData
                        )

                    else if drag.from == target then
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
            -- The category stays open during the drag; the card can be dropped
            -- onto another card to reorder it, or onto a category to re-home it.
            ( { model | recipeDrag = Just rid, recipeDropCategory = Nothing, recipeDropBefore = Nothing }
            , Cmd.none
            )

        RecipeDragEnd ->
            ( clearRecipeDrag model, Cmd.none )

        RecipeDragEnterCategory category ->
            ( { model | recipeDropCategory = Just category, recipeDropBefore = Nothing, plannerDropTarget = Nothing }, Cmd.none )

        DropRecipeOnCategory category ->
            case ( model.recipeDrag, model.data ) of
                ( Just rid, Just data ) ->
                    persistData (clearRecipeDrag model) (moveRecipeToCategoryEnd rid category data)

                _ ->
                    ( clearRecipeDrag model, Cmd.none )

        RecipeDragEnterRecipe targetRid ->
            ( { model | recipeDropBefore = Just targetRid, recipeDropCategory = Nothing, plannerDropTarget = Nothing }, Cmd.none )

        DropRecipeOnRecipe targetRid ->
            case ( model.recipeDrag, model.data ) of
                ( Just rid, Just data ) ->
                    persistData (clearRecipeDrag model) (moveRecipeBefore rid targetRid data)

                _ ->
                    ( clearRecipeDrag model, Cmd.none )

        RecipeDragEnterPlanner day meal ->
            ( { model | plannerDropTarget = Just ( day, meal ), recipeDropCategory = Nothing, recipeDropBefore = Nothing }, Cmd.none )

        DropRecipeOnPlanner day meal ->
            -- The drop copies the recipe into the slot by reference: the
            -- recipe stays in the Recipes column, and the same recipe may be
            -- planned any number of times.
            case ( model.recipeDrag, model.data ) of
                ( Just rid, Just data ) ->
                    persistData (clearRecipeDrag { model | seq = model.seq + 1 })
                        { data | planner = data.planner ++ [ PlannerEntry (nextId model.seq) day meal rid ] }

                _ ->
                    ( clearRecipeDrag model, Cmd.none )

        RemovePlannerEntry entryId ->
            withData model
                (\data -> persistData model { data | planner = List.filter (\e -> e.id /= entryId) data.planner })

        AddPlannerDay ->
            withData model
                (\data -> persistData model { data | plannerDays = Basics.min 10 (data.plannerDays + 1) })

        RemovePlannerDay ->
            -- Dropping the last day also drops whatever was planned on it.
            withData model
                (\data ->
                    let
                        remaining =
                            Basics.max 1 (data.plannerDays - 1)
                    in
                    persistData model
                        { data
                            | plannerDays = remaining
                            , planner = List.filter (\e -> e.day < remaining) data.planner
                        }
                )

        ExportPlanner ->
            ( model
            , model.data
                |> Maybe.map (\data -> Download.string "meal-plan.txt" "text/plain" (plannerText data))
                |> Maybe.withDefault Cmd.none
            )

        ClearPlanner ->
            -- Empty every day's slots but keep the number of days in the plan.
            withData model (\data -> persistData model { data | planner = [] })

        ColumnDragStart columnId ->
            ( { model | columnDrag = Just columnId, columnDropTarget = Nothing }, Cmd.none )

        ColumnDragEnd ->
            ( { model | columnDrag = Nothing, columnDropTarget = Nothing }, Cmd.none )

        ColumnDragEnterColumn columnId ->
            ( { model | columnDropTarget = Just columnId }, Cmd.none )

        DropOnColumnSlot columnId ->
            case ( model.columnDrag, model.data ) of
                ( Just dragged, Just data ) ->
                    persistData { model | columnDrag = Nothing, columnDropTarget = Nothing }
                        { data | columnOrder = reorderColumns dragged columnId (normalizeColumnOrder data.columnOrder) }

                _ ->
                    ( { model | columnDrag = Nothing, columnDropTarget = Nothing }, Cmd.none )

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
                        , recipeDropCategory = Nothing
                        , recipeDropBefore = Nothing

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

        OpenAi category ->
            let
                ai =
                    model.ai
            in
            ( { model
                | ai =
                    { ai
                        | open = Just category
                        , configuring = ai.settings.apiKey == ""
                        , status = Ai.Idle
                        , request = ""
                    }
              }
            , Cmd.none
            )

        CloseAi ->
            ( mapAi (\ai -> { ai | open = Nothing }) model, Cmd.none )

        AiToggleConfigure ->
            ( mapAi (\ai -> { ai | configuring = not ai.configuring }) model, Cmd.none )

        AiSetProvider provider ->
            persistedAi (\s -> { s | provider = provider, model = Ai.defaultModel provider }) identity model

        AiSetKey key ->
            persistedAi (\s -> { s | apiKey = key }) identity model

        AiSetModel modelName ->
            persistedAi (\s -> { s | model = modelName }) identity model

        AiSetInclude value ->
            persistedAi identity (\p -> { p | include = value }) model

        AiSetExclude value ->
            persistedAi identity (\p -> { p | exclude = value }) model

        AiSetAllergies value ->
            persistedAi identity (\p -> { p | allergies = value }) model

        AiSetRequest value ->
            ( mapAi (\ai -> { ai | request = value }) model, Cmd.none )

        AiToggleKitchen ->
            ( mapAi (\ai -> { ai | useKitchen = not ai.useKitchen }) model, Cmd.none )

        AiToggleMoreOptions ->
            ( mapAi (\ai -> { ai | moreOptions = not ai.moreOptions }) model, Cmd.none )

        AiToggleAddMissing ->
            ( mapAi (\ai -> { ai | addMissing = not ai.addMissing }) model, Cmd.none )

        AiGenerate ->
            case ( model.ai.open, model.data ) of
                ( Just category, Just _ ) ->
                    ( mapAi (\ai -> { ai | status = Ai.Loading }) model
                    , Ai.generate model.ai.settings
                        { category = category
                        , request = model.ai.request
                        , prefs = model.ai.prefs
                        , kitchen =
                            if model.ai.useKitchen then
                                Set.toList model.derived.stockedNoCart

                            else
                                []
                        }
                        GotAiRecipe
                    )

                _ ->
                    ( model, Cmd.none )

        GotAiRecipe (Ok recipe) ->
            ( mapAi (\ai -> { ai | status = Ai.Ready recipe }) model, Cmd.none )

        GotAiRecipe (Err message) ->
            ( mapAi (\ai -> { ai | status = Ai.Failed message }) model, Cmd.none )

        AiAccept ->
            acceptAiRecipe model

        AiBackToForm ->
            ( mapAi (\ai -> { ai | status = Ai.Idle }) model, Cmd.none )

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
                                { data | recipes = data.recipes ++ [ Recipe newId (String.left recipeNameLimit value) category [] "" False [] ] }

                            AddPane ->
                                { data | staples = data.staples ++ [ newPane newId value ] }

                            AddCategory tierId ->
                                pushGroup tierId (Group newId value []) data

                            AddCartCategory ->
                                { data | staples = data.staples ++ [ newCartCategory newId value ] }

                            AddRecipeTag rid ->
                                -- A tag needs no minted id; append it unless the
                                -- recipe already carries it.
                                mapRecipe rid
                                    (\r ->
                                        if List.member value r.tags then
                                            r

                                        else
                                            { r | tags = r.tags ++ [ value ] }
                                    )
                                    data
                in
                ( { model | data = Just newData, derived = derive newData, seq = model.seq + 1, adding = Nothing, addValue = "" }
                , saveModel newData
                )

            Nothing ->
                ( { model | adding = Nothing, addValue = "" }, Cmd.none )


nextId : Int -> String
nextId seq =
    "u" ++ String.fromInt seq


{-| The id sequence to resume from for a freshly loaded model: one past the
highest `u<n>` id already in use. Every id the app mints has the form
`u<n>`, so starting here guarantees new ids do not collide with persisted
ones — a collision the relational store rejects.
-}
nextSeq : Data -> Int
nextSeq data =
    modelIds data
        |> List.filterMap mintedIdNumber
        |> List.maximum
        |> Maybe.map (\n -> n + 1)
        |> Maybe.withDefault 0


{-| Every id in the model, across the pyramid, the storage panes, and the
recipes.
-}
modelIds : Data -> List String
modelIds data =
    let
        groups =
            List.concatMap .groups data.tiers
    in
    List.concat
        [ List.map .id data.tiers
        , List.map .id groups
        , groups |> List.concatMap .foods |> List.map .id
        , List.map .id data.staples
        , data.staples |> List.concatMap .items |> List.map .id
        , List.map .id data.recipes
        , data.recipes |> List.concatMap .ingredients |> List.map .id
        ]


{-| The numeric part of an id the app minted (`u<n>`); Nothing for ids from
other sources, such as the seed's `d<n>`.
-}
mintedIdNumber : String -> Maybe Int
mintedIdNumber id =
    if String.startsWith "u" id then
        String.toInt (String.dropLeft 1 id)

    else
        Nothing


{-| A fresh, empty Kitchen storage pane in a neutral warm rail, ready for
the user to drag foods into.
-}
newPane : String -> String -> Card
newPane id name =
    { id = id
    , name = name
    , meta = ""
    , rail = "oklch(0.55 0.08 74)"
    , line = "oklch(0.86 0.04 74)"
    , note = ""
    , zone = "kitchen"
    , items = []
    }


{-| A fresh, empty Shopping List category — a storage card in the shopping
zone, so it renders in the Shopping List column and collects dragged foods.
-}
newCartCategory : String -> String -> Card
newCartCategory id name =
    { id = id
    , name = name
    , meta = ""
    , rail = "oklch(0.5 0.09 150)"
    , line = "oklch(0.86 0.04 150)"
    , note = ""
    , zone = cartZone
    , items = []
    }


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
                    catalogNames =
                        data.tiers
                            |> List.concatMap .groups
                            |> List.concatMap .foods
                            |> List.map .name

                    parsed =
                        parsePastedRecipe catalogNames model.pasteValue

                    ( ingredients, seqAfter ) =
                        List.foldl
                            (\nm ( acc, s ) -> ( acc ++ [ Item (nextId s) nm False ], s + 1 ))
                            ( [], model.seq )
                            parsed.ingredients

                    recipe =
                        Recipe (nextId seqAfter) (String.left recipeNameLimit parsed.name) category ingredients parsed.instructions False []

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


{-| Send every staple that is not already on hand or on the list — the red
ones in the tracker — to the Shopping List.
-}
addStaplesToCart : Model -> ( Model, Cmd Msg )
addStaplesToCart model =
    case model.data of
        Just data ->
            let
                stocked =
                    inStockNames data

                toAdd =
                    data.staples
                        |> List.filter (\c -> c.name == staplesTrackerName)
                        |> List.concatMap .items
                        |> List.filter (\i -> not (Set.member (String.toLower i.name) stocked))
            in
            case cartCardId data of
                Just cid ->
                    let
                        ( newData, newSeq ) =
                            List.foldl
                                (\item ( d, s ) ->
                                    ( pushItemTo (StoragePane cid) (Item (nextId s) item.name item.na) d
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


{-| The Shopping List categories a model starts with, in aisle-ish order,
so a new or never-organised list already has somewhere to sort foods into.
-}
defaultCartCategories : List String
defaultCartCategories =
    [ "Produce"
    , "Canned & Dry Goods"
    , "Dairy"
    , "Frozen"
    , "Bulk"
    , "Bakery"
    , "Meat & Seafood"
    , "Baking & Spices"
    , "Condiments & Sauces"
    , "Coffee & Tea"
    , "Health & Wellness"
    ]


{-| Seed the default Shopping List categories when a loaded model has none
of its own yet — so the feature arrives populated for existing users and
fresh accounts alike, while a list that already has categories (even after
some were deleted) is left untouched. Returns the model and the id sequence
advanced past the minted categories.
-}
ensureCartCategories : Int -> Data -> ( Data, Int )
ensureCartCategories seq data =
    if List.any (\c -> c.zone == cartZone) data.staples then
        ( data, seq )

    else
        let
            ( cards, seqAfter ) =
                List.foldl
                    (\name ( acc, s ) -> ( acc ++ [ newCartCategory (nextId s) name ], s + 1 ))
                    ( [], seq )
                    defaultCartCategories
        in
        ( { data | staples = data.staples ++ cards }, seqAfter )


{-| Re-home every recipe filed under a category that no longer exists.
-}
ensureRecipeCategories : Data -> Data
ensureRecipeCategories data =
    { data | recipes = List.map rehomeRecipe data.recipes }


{-| Re-home a recipe whose category no longer exists, so it never drops out
of view — the meal categories became tags, and an older kitchen may still
file recipes under them. The vanished category rides along as a tag when it
was one of the meals.
-}
rehomeRecipe : Recipe -> Recipe
rehomeRecipe recipe =
    if List.member recipe.category recipeCategories then
        recipe

    else
        { recipe
            | category = "Main Courses"
            , tags =
                if List.member recipe.category [ "Breakfast", "Lunch", "Dinner" ] && not (List.member recipe.category recipe.tags) then
                    recipe.tags ++ [ recipe.category ]

                else
                    recipe.tags
        }


{-| Guarantee the permanent Staples Tracker pane exists, creating it empty
when a loaded model has none yet. It is a storage card treated specially by
name, so once present it drags, persists, and renders like any pane.
-}
ensureStaplesTracker : Data -> Data
ensureStaplesTracker data =
    if List.any (\c -> c.name == staplesTrackerName) data.staples then
        data

    else
        { data
            | staples =
                -- The tracker renders from its own CSS class, not these
                -- cosmetic Card fields, so meta/rail/line/note stay empty. It
                -- is a Kitchen-column pane, so its zone is the default.
                data.staples
                    ++ [ Card staplesTrackerId staplesTrackerName "" "" "" "" "kitchen" [] ]
        }


{-| The app's columns in their canonical left-to-right order, by id.
-}
columnIds : List String
columnIds =
    [ "pyramid", "recipes", "planner", "kitchen", "cart" ]


{-| A saved column order made safe to render: unknown ids dropped,
duplicates collapsed, and any column the saved order lacks appended in
canonical position — so every column always renders exactly once.
-}
normalizeColumnOrder : List String -> List String
normalizeColumnOrder saved =
    let
        known =
            List.foldl
                (\c acc ->
                    if List.member c columnIds && not (List.member c acc) then
                        acc ++ [ c ]

                    else
                        acc
                )
                []
                saved
    in
    known ++ List.filter (\c -> not (List.member c known)) columnIds


{-| Move the dragged column to the dropped-on column's position: dropping
on a column to the right lands just right of it, dropping on one to the
left lands just left of it, so every arrangement is reachable.
-}
reorderColumns : String -> String -> List String -> List String
reorderColumns dragged target order =
    if dragged == target then
        order

    else
        let
            without =
                List.filter ((/=) dragged) order

            insertAt =
                indexOfColumn target without
                    + (if indexOfColumn dragged order < indexOfColumn target order then
                        1

                       else
                        0
                      )
        in
        List.take insertAt without ++ dragged :: List.drop insertAt without


indexOfColumn : String -> List String -> Int
indexOfColumn columnId order =
    order
        |> List.indexedMap Tuple.pair
        |> List.filter (\( _, c ) -> c == columnId)
        |> List.head
        |> Maybe.map Tuple.first
        |> Maybe.withDefault 0


{-| One column in the layout, wrapped in an invisible slot that accepts a
dragged column, plus the insertion line marking where the drag would land.
The wrapper renders no box of its own, so the column keeps its flex sizing.
-}
viewColumnSlot : Model -> Data -> String -> List (Html Msg)
viewColumnSlot model data columnId =
    let
        slot =
            div (class "column-slot" :: columnSlotDropAttrs model.columnDrag columnId)
                [ viewColumn model data columnId ]

        line =
            div [ class "column-insert-line" ] []
    in
    case insertionSide model columnId of
        Just After ->
            [ slot, line ]

        Just Before ->
            [ line, slot ]

        Nothing ->
            [ slot ]


type InsertionSide
    = Before
    | After


{-| Which edge of this column the dragged column would land on, if the
pointer is over it — matching what `reorderColumns` will do on drop.
-}
insertionSide : Model -> String -> Maybe InsertionSide
insertionSide model columnId =
    case ( model.columnDrag, model.data ) of
        ( Just dragged, Just data ) ->
            if model.columnDropTarget == Just columnId && dragged /= columnId then
                let
                    order =
                        normalizeColumnOrder data.columnOrder
                in
                if indexOfColumn dragged order < indexOfColumn columnId order then
                    Just After

                else
                    Just Before

            else
                Nothing

        _ ->
            Nothing


{-| The drop handlers a column slot carries while a column is being
dragged, and nothing otherwise — so recipe and food drags pass through.
-}
columnSlotDropAttrs : Maybe String -> String -> List (Attribute Msg)
columnSlotDropAttrs columnDrag columnId =
    if columnDrag == Nothing then
        []

    else
        [ preventDefaultOn "dragover" (Decode.succeed ( NoOp, True ))
        , on "dragenter" (Decode.succeed (ColumnDragEnterColumn columnId))
        , preventDefaultOn "drop" (Decode.succeed ( DropOnColumnSlot columnId, True ))
        ]


viewColumn : Model -> Data -> String -> Html Msg
viewColumn model data columnId =
    case columnId of
        "pyramid" ->
            viewPyramidColumn model data

        "recipes" ->
            viewRecipes model data

        "planner" ->
            viewPlannerColumn model data

        "kitchen" ->
            viewKitchenColumn model data

        "cart" ->
            viewCartColumn model data

        _ ->
            text ""


{-| Scroll the Recipes column so the given recipe's card sits near the top
of its visible area. The short sleep lets the column and the card render
first — opening a recipe may have only just mounted them.
-}
scrollRecipeIntoView : String -> Cmd Msg
scrollRecipeIntoView rid =
    Process.sleep 80
        |> Task.andThen (\_ -> Dom.getElement (recipeCardDomId rid))
        |> Task.andThen
            (\card ->
                Dom.getElement recipesBodyId
                    |> Task.andThen
                        (\body ->
                            Dom.getViewportOf recipesBodyId
                                |> Task.andThen
                                    (\viewport ->
                                        Dom.setViewportOf recipesBodyId
                                            0
                                            (viewport.viewport.y + card.element.y - body.element.y - 16)
                                    )
                        )
            )
        |> Task.attempt (\_ -> NoOp)


{-| Clear every trace of an in-flight recipe drag: the dragged card and
every drop-target highlight (the category, the ins-before card, and the
Meal Planner slot).
-}
clearRecipeDrag : Model -> Model
clearRecipeDrag model =
    { model | recipeDrag = Nothing, recipeDropCategory = Nothing, recipeDropBefore = Nothing, plannerDropTarget = Nothing }


{-| Whether the storage card with this id is a Shopping List card (the
reserved cart or one of its categories).
-}
isShoppingCardId : String -> Data -> Bool
isShoppingCardId cid data =
    data.staples
        |> List.filter (\c -> c.id == cid)
        |> List.head
        |> Maybe.map isShoppingCard
        |> Maybe.withDefault False


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
        sourceIsShopping =
            case drag.from of
                StoragePane fid ->
                    isShoppingCardId fid data

                _ ->
                    False

        -- A Shopping List card and the Staples Tracker collect references:
        -- dropping in from the pyramid or a kitchen pane copies, so it never
        -- depletes the source.  Moving between two Shopping List cards,
        -- though, is a move — that is how a category gets filled — so a
        -- shopping-to-shopping drop does not collect.
        targetCollects =
            case target of
                StoragePane cid ->
                    (isShoppingCardId cid data && not sourceIsShopping)
                        || cid
                        == staplesTrackerId

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
                    targetCollects
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


{-| Apply one selected item at a target, whatever the target is: added as a
pyramid food (a pyramid group is otherwise never a drop target), or dropped
into a storage or recipe list with the usual copy-or-move rules. A drop onto
the item's own location is a no-op.
-}
dropOneHere : Loc -> String -> Loc -> Int -> Data -> ( Data, Int )
dropOneHere from foodId target seq data =
    case target of
        PyramidGroup gid ->
            draggedNameNa (Drag from foodId) data
                |> Maybe.map
                    (\( name, na ) ->
                        if pyramidHasName name data then
                            ( data, seq )

                        else
                            ( pushFood gid (Food (nextId seq) name "F" False na "") data, seq + 1 )
                    )
                |> Maybe.withDefault ( data, seq )

        _ ->
            if from == target then
                ( data, seq )

            else
                performDrop (Drag from foodId) target seq data


{-| Drop every selected item onto one target, each with its own copy/move
semantics, threading the id sequence through the sequence of drops.
-}
performMultiDrop : List String -> Loc -> Int -> Data -> ( Data, Int )
performMultiDrop keys target seq data =
    List.foldl
        (\key ( d, s ) ->
            case parseSelKey key of
                Just ( from, foodId ) ->
                    dropOneHere from foodId target s d

                Nothing ->
                    ( d, s )
        )
        ( data, seq )
        keys


{-| Move every selected item to a target and report their new selection
keys, so a "move selected here" leaves the same items selected — at their
new location for an item that moved, at the source for a copy.
-}
moveSelectedHere : Loc -> List String -> Int -> Data -> ( Data, Int, List String )
moveSelectedHere target keys seq data =
    List.foldl
        (\key ( d, s, acc ) ->
            case parseSelKey key of
                Just ( from, foodId ) ->
                    let
                        ( d2, s2 ) =
                            dropOneHere from foodId target s d

                        newKey =
                            if itemStillAt from foodId d2 then
                                selKey from foodId

                            else
                                selKey target foodId
                    in
                    ( d2, s2, newKey :: acc )

                Nothing ->
                    ( d, s, key :: acc )
        )
        ( data, seq, [] )
        keys


{-| Whether the item is still at the given location after a drop — true for
a copy (the source is kept), false for a move (the source is emptied).
-}
itemStillAt : Loc -> String -> Data -> Bool
itemStillAt loc foodId data =
    case loc of
        PyramidGroup gid ->
            foodInGroup gid foodId data /= Nothing

        _ ->
            itemInStorage loc foodId data /= Nothing


toggleMember : comparable -> Set comparable -> Set comparable
toggleMember member set =
    if Set.member member set then
        Set.remove member set

    else
        Set.insert member set



-- AI ASSISTANT


{-| Apply a change to the AI substate.
-}
mapAi : (Model.AiState -> Model.AiState) -> Model -> Model
mapAi fn model =
    { model | ai = fn model.ai }


{-| Change the persisted AI settings and/or preferences, and write the new
values back to the browser.
-}
persistedAi : (Ai.Settings -> Ai.Settings) -> (Ai.Prefs -> Ai.Prefs) -> Model -> ( Model, Cmd Msg )
persistedAi onSettings onPrefs model =
    let
        ai =
            model.ai

        settings =
            onSettings ai.settings

        prefs =
            onPrefs ai.prefs
    in
    ( { model | ai = { ai | settings = settings, prefs = prefs } }
    , persistAi (Ai.encodeStore settings prefs)
    )


{-| Turn the previewed recipe into a real recipe in its category, adding
its not-on-hand ingredients to the Shopping List when the option is set,
then save and close the panel.
-}
acceptAiRecipe : Model -> ( Model, Cmd Msg )
acceptAiRecipe model =
    case ( model.ai.status, model.ai.open, model.data ) of
        ( Ai.Ready generated, Just category, Just data ) ->
            let
                ai =
                    model.ai

                ( ingredients, seqAfter ) =
                    List.foldl
                        (\ing ( acc, s ) -> ( acc ++ [ Item (nextId s) ing.name False ], s + 1 ))
                        ( [], model.seq )
                        generated.ingredients

                recipe =
                    Recipe (nextId seqAfter) (String.left recipeNameLimit generated.name) category ingredients (aiInstructions generated) False []

                withRecipe =
                    { data | recipes = data.recipes ++ [ recipe ] }

                ( finalData, finalSeq ) =
                    if ai.addMissing then
                        addMissingToCart recipe (seqAfter + 1) withRecipe

                    else
                        ( withRecipe, seqAfter + 1 )
            in
            ( { model
                | data = Just finalData
                , derived = derive finalData
                , seq = finalSeq
                , ai = { ai | open = Nothing, status = Ai.Idle }
              }
            , saveModel finalData
            )

        _ ->
            ( model, Cmd.none )


{-| Add a recipe's ingredients that are not already on hand or on the list
to the Shopping List, minting ids from `seq`.
-}
addMissingToCart : Recipe -> Int -> Data -> ( Data, Int )
addMissingToCart recipe seq data =
    let
        stocked =
            inStockNames data

        toAdd =
            recipe.ingredients
                |> List.filter (\i -> not (Set.member (String.toLower i.name) stocked))
    in
    case cartCardId data of
        Just cid ->
            List.foldl
                (\ing ( d, s ) -> ( pushItemTo (StoragePane cid) (Item (nextId s) ing.name ing.na) d, s + 1 ))
                ( data, seq )
                toAdd

        Nothing ->
            ( data, seq )


{-| The generated recipe's instructions, prefixed with its ingredient list
and amounts (the app stores amounts in the instructions text, since the
ingredient chips carry only names).
-}
aiInstructions : Ai.GeneratedRecipe -> String
aiInstructions generated =
    let
        line ingredient =
            if String.trim ingredient.amount == "" then
                "- " ++ ingredient.name

            else
                "- " ++ ingredient.amount ++ " " ++ ingredient.name
    in
    "Ingredients:\n"
        ++ String.join "\n" (List.map line generated.ingredients)
        ++ "\n\n"
        ++ generated.instructions



-- HTTP


fetchModel : Cmd Msg
fetchModel =
    Http.get { url = "/api/model", expect = Http.expectJson GotModel dataDecoder }


fetchMe : Cmd Msg
fetchMe =
    Http.get { url = "/me", expect = Http.expectJson GotMe meDecoder }


meDecoder : Decode.Decoder Me
meDecoder =
    Decode.map2 Me
        (Decode.field "name" Decode.string)
        (Decode.field "auth_enabled" Decode.bool)


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
        [ -- The toolbar and the Select row form one sticky header block, so
          -- both stay pinned on screen wherever the page itself scrolls.
          div [ class "app-header noprint" ]
            [ viewToolbar model.me
            , viewSelectBar model.selection.active (Set.size model.selection.items)
            ]
        , viewError model.error
        , case model.data of
            Just data ->
                div [ class "page" ]
                    [ div [ class "layout" ]
                        (List.concatMap (viewColumnSlot model data) (normalizeColumnOrder data.columnOrder))
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


viewToolbar : Maybe Me -> Html Msg
viewToolbar me =
    div [ class "noprint toolbar" ]
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
                [ text "Longevity Pantry" ]
            , a [ class "about-link noprint", href "/about.html" ] [ text "About" ]
            , a [ class "about-link noprint", href "/donate.html" ] [ text "Donate" ]
            , div [ class "toolbar-auth" ] (viewAuth me)
            ]
        ]


{-| The app-wide select-mode row under the title bar: one toggle that, when
on, marks every column's item badges with a tap-to-select circle so several
can be moved at once — by dragging one, or with the ⬇ on a destination. A
"Deselect all" appears once more than one item is picked.
-}
viewSelectBar : Bool -> Int -> Html Msg
viewSelectBar active selectedCount =
    div [ class "noprint", class "select-bar" ]
        (selectToggle active selectedCount ToggleSelectMode
            :: (if selectedCount > 1 then
                    [ button [ type_ "button", class "deselect-all-btn", onClick DeselectAll ] [ text "Deselect all" ] ]

                else
                    []
               )
        )


{-| The sign-in / sign-out control. Empty in a local unauthenticated run;
a "Sign in" link when OIDC is on but nobody is signed in; the name and a
"Sign out" link once signed in.
-}
viewAuth : Maybe Me -> List (Html Msg)
viewAuth maybeMe =
    case maybeMe of
        Just me ->
            if not me.authEnabled then
                []

            else if me.name == "anonymous" then
                [ authLink "/auth/login" "Sign in" ]

            else
                [ span [ class "auth-name" ] [ text me.name ]
                , authLink "/auth/logout" "Sign out"
                ]

        Nothing ->
            []


authLink : String -> String -> Html Msg
authLink url label =
    a [ href url, class "auth-link" ] [ text label ]
