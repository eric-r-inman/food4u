module Main exposing (main)

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

import Browser
import Browser.Dom as Dom
import CartView exposing (viewCartColumn)
import Data exposing (Card, Data, Food, Item, Loc(..), Recipe, dataDecoder, encodeData, foodInGroup, itemInStorage, listHasName, mapCard, mapGroup, mapRecipe, mapStorage, pushFood, pushItemTo, pyramidHasName, removeFood, shoppingCartName)
import Derived exposing (inStockNames)
import Dict exposing (Dict)
import File.Download as Download
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onBlur, onClick, onInput)
import Http
import Json.Decode as Decode
import KitchenView exposing (viewKitchenColumn)
import Model exposing (Drag, Model, derive, emptyDerived, isOpen)
import Msg exposing (Msg(..))
import PyramidView exposing (viewPyramidColumn)
import RecipeParser exposing (parsePastedRecipe)
import RecipesView exposing (viewRecipes)
import Set exposing (Set)
import Shopping exposing (cartCardId, shoppingListText)
import Style exposing (styles)
import Task
import Types exposing (AddTarget(..), Me, RecipeFilter(..))
import Ui exposing (addInputId, pasteInputId)


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
      , me = Nothing
      , editingPane = Nothing
      , derived = emptyDerived
      }
    , Cmd.batch [ fetchModel, fetchMe ]
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
            withData model
                (\data ->
                    persistData model
                        (unlinkRecipe rid
                            { data | recipes = List.filter (\r -> r.id /= rid) data.recipes }
                        )
                )

        RemovePane pid ->
            withData model
                (\data ->
                    persistData model
                        { data | staples = List.filter (\c -> c.id /= pid) data.staples }
                )

        ToggleEditPane pid ->
            ( { model
                | editingPane =
                    if model.editingPane == Just pid then
                        Nothing

                    else
                        Just pid
              }
            , Cmd.none
            )

        EditPaneName pid value ->
            -- Live-edit locally; persisted on blur via PersistNow.
            withData model
                (\data ->
                    ( { model | data = Just (mapCard pid (\c -> { c | name = value }) data) }
                    , Cmd.none
                    )
                )

        EditPaneMeta pid value ->
            withData model
                (\data ->
                    ( { model | data = Just (mapCard pid (\c -> { c | meta = value }) data) }
                    , Cmd.none
                    )
                )

        CommitPaneEdit ->
            -- Leave edit mode and persist; the edits are already live in
            -- the model, so this just saves them (as a blur would).
            ( { model | editingPane = Nothing }
            , case model.data of
                Just data ->
                    saveModel data

                Nothing ->
                    Cmd.none
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

                            AddPane ->
                                { data | staples = data.staples ++ [ newPane newId value ] }
                in
                ( { model | data = Just newData, derived = derive newData, seq = model.seq + 1, adding = Nothing, addValue = "" }
                , saveModel newData
                )

            Nothing ->
                ( { model | adding = Nothing, addValue = "" }, Cmd.none )


nextId : Int -> String
nextId seq =
    "u" ++ String.fromInt seq


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
        [ viewToolbar model.me
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


viewToolbar : Maybe Me -> Html Msg
viewToolbar me =
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
                [ text "Longevity Pantry" ]
            , div [ class "toolbar-auth" ] (viewAuth me)
            ]
        ]


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
