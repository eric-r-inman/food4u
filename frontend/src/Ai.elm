module Ai exposing
    ( GeneratedIngredient
    , GeneratedRecipe
    , Prefs
    , Provider(..)
    , Settings
    , Status(..)
    , allProviders
    , decodeStore
    , defaultModel
    , defaultPrefs
    , defaultSettings
    , encodeStore
    , generate
    , providerKeyUrl
    , providerLabel
    )

{-| The AI recipe assistant's domain: the user's provider settings and
recipe preferences, the prompt that turns them into a request, the
per-provider HTTP call, and the structured recipe decoded back.

The call is made from the browser straight to the chosen provider with the
user's own API key — it never touches the Longevity Pantry server, so the
key stays on the user's machine and the hosted app pays nothing. This
module is pure of application state (no Model/Msg), so it can be shared by
the model, the messages, and the views without a cycle.

-}

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


{-| The LLM providers the assistant can call directly from the browser.
All allow browser-origin requests (Gemini and OpenAI natively; Anthropic
via its explicit opt-in header). Gemini has a free tier for hosted users;
OpenAI (ChatGPT) and Anthropic (Claude) use the user's own paid key.
-}
type Provider
    = Gemini
    | OpenAi
    | Anthropic


allProviders : List Provider
allProviders =
    [ Gemini, OpenAi, Anthropic ]


providerLabel : Provider -> String
providerLabel provider =
    case provider of
        Gemini ->
            "Google Gemini (free tier)"

        OpenAi ->
            "OpenAI (ChatGPT)"

        Anthropic ->
            "Anthropic Claude"


{-| Where a user gets an API key for each provider.
-}
providerKeyUrl : Provider -> String
providerKeyUrl provider =
    case provider of
        Gemini ->
            "https://aistudio.google.com/apikey"

        OpenAi ->
            "https://platform.openai.com/api-keys"

        Anthropic ->
            "https://console.anthropic.com/settings/keys"


{-| A sensible default model per provider. Editable, since model names
change over time and the user may prefer a different one.
-}
defaultModel : Provider -> String
defaultModel provider =
    case provider of
        Gemini ->
            "gemini-2.0-flash"

        OpenAi ->
            "gpt-4o-mini"

        Anthropic ->
            "claude-haiku-4-5-20251001"


{-| The user's provider configuration, persisted in the browser. The key
lives only here, never on the server.
-}
type alias Settings =
    { provider : Provider
    , apiKey : String
    , model : String
    }


defaultSettings : Settings
defaultSettings =
    { provider = Gemini
    , apiKey = ""
    , model = defaultModel Gemini
    }


{-| Recipe preferences remembered across sessions: comma-separated foods to
favour or avoid, and allergies to strictly exclude.
-}
type alias Prefs =
    { include : String
    , exclude : String
    , allergies : String
    }


defaultPrefs : Prefs
defaultPrefs =
    { include = "", exclude = "", allergies = "" }


{-| A recipe as the model returns it, before it is turned into an app
recipe. Ingredients carry a short canonical `name` (for matching the
kitchen and shopping list) and a human `amount`.
-}
type alias GeneratedRecipe =
    { name : String
    , ingredients : List GeneratedIngredient
    , instructions : String
    }


type alias GeneratedIngredient =
    { name : String
    , amount : String
    }


{-| Where a category's generation currently stands.
-}
type Status
    = Idle
    | Loading
    | Failed String
    | Ready GeneratedRecipe



-- PERSISTENCE


{-| Encode the settings and preferences for localStorage. The API key is
included: it is the user's own key, kept on their machine.
-}
encodeStore : Settings -> Prefs -> Encode.Value
encodeStore settings prefs =
    Encode.object
        [ ( "provider", Encode.string (providerTag settings.provider) )
        , ( "apiKey", Encode.string settings.apiKey )
        , ( "model", Encode.string settings.model )
        , ( "include", Encode.string prefs.include )
        , ( "exclude", Encode.string prefs.exclude )
        , ( "allergies", Encode.string prefs.allergies )
        ]


{-| Read persisted settings and preferences from the init flags, falling
back to defaults for anything missing or unparseable (such as the first
run, when there is nothing stored).
-}
decodeStore : Decode.Value -> ( Settings, Prefs )
decodeStore flags =
    ( { provider = decodeField "provider" providerFromTag Gemini flags
      , apiKey = decodeField "apiKey" Just "" flags
      , model = decodeField "model" Just "" flags
      }
        |> withModelDefault
    , { include = decodeField "include" Just "" flags
      , exclude = decodeField "exclude" Just "" flags
      , allergies = decodeField "allergies" Just "" flags
      }
    )


{-| A stored model of "" means none was saved; use the provider default.
-}
withModelDefault : Settings -> Settings
withModelDefault settings =
    if settings.model == "" then
        { settings | model = defaultModel settings.provider }

    else
        settings


decodeField : String -> (String -> Maybe a) -> a -> Decode.Value -> a
decodeField key parse fallback flags =
    flags
        |> Decode.decodeValue (Decode.field key Decode.string)
        |> Result.toMaybe
        |> Maybe.andThen parse
        |> Maybe.withDefault fallback


providerTag : Provider -> String
providerTag provider =
    case provider of
        Gemini ->
            "gemini"

        OpenAi ->
            "openai"

        Anthropic ->
            "anthropic"


providerFromTag : String -> Maybe Provider
providerFromTag tag =
    case tag of
        "gemini" ->
            Just Gemini

        "openai" ->
            Just OpenAi

        "anthropic" ->
            Just Anthropic

        _ ->
            Nothing



-- THE PROMPT


{-| Inputs the prompt is built from: the meal category, the user's optional
free-text ask, the remembered preferences, and — when the user opts in —
the foods already on hand.
-}
type alias PromptInputs =
    { category : String
    , request : String
    , prefs : Prefs
    , kitchen : List String
    }


buildPrompt : PromptInputs -> String
buildPrompt inputs =
    [ "You are a recipe assistant for a longevity-focused, whole-foods kitchen app."
    , "Create ONE recipe for the meal category: " ++ inputs.category ++ "."
    , nonEmptyLine "The user asks specifically for: " inputs.request
    , nonEmptyLine "Favour these foods when it fits: " inputs.prefs.include
    , nonEmptyLine "Do not use these foods: " inputs.prefs.exclude
    , allergyLine inputs.prefs.allergies
    , kitchenLine inputs.kitchen
    , "Favour whole, minimally-processed, plant-forward longevity foods (vegetables, legumes, whole grains, nuts, seeds, olive oil, fish); avoid refined sugar, refined grains, and ultra-processed ingredients."
    , "Keep ingredient names short, canonical, and singular (e.g. \"kale\", \"chickpeas\", \"olive oil\") so they match a grocery list; put quantities in the amount field."
    , "Respond with ONLY a JSON object — no prose, no markdown fences — of exactly this shape:"
    , "{\"name\": string, \"ingredients\": [{\"name\": string, \"amount\": string}], \"instructions\": string}"
    , "The instructions must be numbered steps separated by newlines."
    ]
        |> List.filter (\line -> line /= "")
        |> String.join "\n\n"


nonEmptyLine : String -> String -> String
nonEmptyLine prefix value =
    if String.trim value == "" then
        ""

    else
        prefix ++ String.trim value ++ "."


allergyLine : String -> String
allergyLine allergies =
    if String.trim allergies == "" then
        ""

    else
        "STRICT ALLERGY CONSTRAINT: the recipe must not contain, and must avoid cross-contact with, any of: "
            ++ String.trim allergies
            ++ ". This is a safety requirement — never include these or close relatives of them."


kitchenLine : List String -> String
kitchenLine kitchen =
    if List.isEmpty kitchen then
        ""

    else
        "Build the recipe mainly from foods the user already has on hand: "
            ++ String.join ", " kitchen
            ++ ". A few extra common staples are fine."



-- THE REQUEST


{-| Issue the generation request to the configured provider, tagging the
decoded recipe (or transport error) with `toMsg`. The request goes from
the browser directly to the provider using the user's key.
-}
generate :
    Settings
    -> { category : String, request : String, prefs : Prefs, kitchen : List String }
    -> (Result String GeneratedRecipe -> msg)
    -> Cmd msg
generate settings inputs toMsg =
    let
        prompt =
            buildPrompt
                { category = inputs.category
                , request = inputs.request
                , prefs = inputs.prefs
                , kitchen = inputs.kitchen
                }
    in
    Http.request
        { method = "POST"
        , headers = providerHeaders settings
        , url = providerUrl settings
        , body = Http.jsonBody (providerBody settings prompt)
        , expect = Http.expectStringResponse toMsg (responseToResult settings.provider)
        , timeout = Just 60000
        , tracker = Nothing
        }


providerUrl : Settings -> String
providerUrl settings =
    case settings.provider of
        Gemini ->
            "https://generativelanguage.googleapis.com/v1beta/models/"
                ++ settings.model
                ++ ":generateContent?key="
                ++ settings.apiKey

        OpenAi ->
            "https://api.openai.com/v1/chat/completions"

        Anthropic ->
            "https://api.anthropic.com/v1/messages"


providerHeaders : Settings -> List Http.Header
providerHeaders settings =
    case settings.provider of
        Gemini ->
            []

        OpenAi ->
            [ Http.header "Authorization" ("Bearer " ++ settings.apiKey) ]

        Anthropic ->
            [ Http.header "x-api-key" settings.apiKey
            , Http.header "anthropic-version" "2023-06-01"

            -- Opts this browser request past Anthropic's CORS block; the
            -- key is exposed in the page, which is acceptable only because
            -- it is the user's own key on their own machine.
            , Http.header "anthropic-dangerous-direct-browser-access" "true"
            ]


providerBody : Settings -> String -> Encode.Value
providerBody settings prompt =
    case settings.provider of
        Gemini ->
            Encode.object
                [ ( "contents"
                  , Encode.list identity
                        [ Encode.object
                            [ ( "parts"
                              , Encode.list identity
                                    [ Encode.object [ ( "text", Encode.string prompt ) ] ]
                              )
                            ]
                        ]
                  )
                , ( "generationConfig"
                  , Encode.object
                        [ ( "responseMimeType", Encode.string "application/json" )
                        , ( "temperature", Encode.float 0.7 )
                        ]
                  )
                ]

        OpenAi ->
            Encode.object
                [ ( "model", Encode.string settings.model )
                , ( "temperature", Encode.float 0.7 )
                , ( "response_format", Encode.object [ ( "type", Encode.string "json_object" ) ] )
                , ( "messages"
                  , Encode.list identity
                        [ Encode.object
                            [ ( "role", Encode.string "user" )
                            , ( "content", Encode.string prompt )
                            ]
                        ]
                  )
                ]

        Anthropic ->
            Encode.object
                [ ( "model", Encode.string settings.model )
                , ( "max_tokens", Encode.int 2000 )
                , ( "temperature", Encode.float 0.7 )
                , ( "messages"
                  , Encode.list identity
                        [ Encode.object
                            [ ( "role", Encode.string "user" )
                            , ( "content", Encode.string prompt )
                            ]
                        ]
                  )
                ]


{-| Decode a provider's response: pull the model's text out of the
provider-specific envelope, then parse that text as the recipe JSON.
-}
providerDecoder : Provider -> Decoder GeneratedRecipe
providerDecoder provider =
    envelopeTextDecoder provider
        |> Decode.andThen
            (\text ->
                case Decode.decodeString recipeDecoder (stripCodeFence text) of
                    Ok recipe ->
                        Decode.succeed recipe

                    Err _ ->
                        Decode.fail "The model did not return a recipe in the expected format."
            )


envelopeTextDecoder : Provider -> Decoder String
envelopeTextDecoder provider =
    case provider of
        Gemini ->
            Decode.field "candidates"
                (Decode.index 0
                    (Decode.field "content"
                        (Decode.field "parts"
                            (Decode.index 0 (Decode.field "text" Decode.string))
                        )
                    )
                )

        OpenAi ->
            Decode.field "choices"
                (Decode.index 0
                    (Decode.field "message" (Decode.field "content" Decode.string))
                )

        Anthropic ->
            Decode.field "content"
                (Decode.index 0 (Decode.field "text" Decode.string))


recipeDecoder : Decoder GeneratedRecipe
recipeDecoder =
    Decode.map3 GeneratedRecipe
        (Decode.field "name" Decode.string)
        (Decode.field "ingredients" (Decode.list ingredientDecoder))
        (Decode.field "instructions" Decode.string)


ingredientDecoder : Decoder GeneratedIngredient
ingredientDecoder =
    Decode.map2 GeneratedIngredient
        (Decode.field "name" Decode.string)
        (Decode.oneOf
            [ Decode.field "amount" Decode.string
            , Decode.succeed ""
            ]
        )


{-| Strip a leading/trailing markdown code fence a model may add despite
being asked not to, so the inner JSON parses.
-}
stripCodeFence : String -> String
stripCodeFence raw =
    let
        trimmed =
            String.trim raw
    in
    if String.startsWith "```" trimmed then
        trimmed
            |> String.lines
            |> List.filter (\line -> not (String.startsWith "```" line))
            |> String.join "\n"

    else
        trimmed


{-| Turn a raw response into either the recipe or a message to show. Unlike
`Http.expectJson`, this keeps the error body so the provider's own
explanation (a quota notice, a bad-model message) can be surfaced.
-}
responseToResult : Provider -> Http.Response String -> Result String GeneratedRecipe
responseToResult provider response =
    case response of
        Http.BadUrl_ _ ->
            Err "The request address was invalid — check the model name."

        Http.Timeout_ ->
            Err "The request timed out. Try again."

        Http.NetworkError_ ->
            Err "Could not reach the provider. Check your connection, and that this provider allows browser requests."

        Http.BadStatus_ metadata body ->
            Err (statusMessage metadata.statusCode body)

        Http.GoodStatus_ _ body ->
            Decode.decodeString (providerDecoder provider) body
                |> Result.mapError
                    (\_ -> "The model replied, but not with a recipe in the expected format. Try again.")


{-| A message for a rejected request, distinguishing the common cases and
folding in the provider's own error text when it sends one.
-}
statusMessage : Int -> String -> String
statusMessage status body =
    let
        detail =
            providerErrorText body
                |> Maybe.map (\message -> " — " ++ message)
                |> Maybe.withDefault ""
    in
    if status == 429 then
        "Rate limit or quota reached (429)"
            ++ detail
            ++ ".  You may be sending requests too quickly, or the account's quota (including a free tier) is used up — wait a minute, or check the provider's plan, billing, and limits."

    else if status == 401 || status == 403 then
        "The provider rejected your API key (status "
            ++ String.fromInt status
            ++ ")"
            ++ detail
            ++ ".  Check the key."

    else if status == 404 then
        "Not found (404)" ++ detail ++ " — check the model name."

    else
        "The provider rejected the request (status "
            ++ String.fromInt status
            ++ ")"
            ++ detail
            ++ "."


{-| The provider's error message, if the error body carries the usual
`{ "error": { "message": … } }` shape.
-}
providerErrorText : String -> Maybe String
providerErrorText body =
    body
        |> Decode.decodeString (Decode.field "error" (Decode.field "message" Decode.string))
        |> Result.toMaybe
