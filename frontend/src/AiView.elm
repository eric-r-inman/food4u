module AiView exposing (viewPanel)

{-| The AI recipe assistant panel, shown in a recipe category when its "AI"
button is pressed. It walks the user through one-time setup (choosing a
provider and pasting their own API key, with a plain-language note that the
key stays in their browser), a small mostly-optional request form, and a
preview of the generated recipe before anything is committed.
-}

import Ai
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model)
import Msg exposing (Msg(..))


viewPanel : Model -> String -> Html Msg
viewPanel model category =
    div [ class "ai-panel" ]
        (div [ class "ai-panel-head" ]
            [ span [ class "ai-title" ] [ text ("✨ AI recipe · " ++ category) ]
            , button
                [ type_ "button", class "ai-close", onClick CloseAi ]
                [ text "✕" ]
            ]
            :: (if model.ai.configuring then
                    viewSettings model.ai

                else
                    viewBody model.ai
               )
        )



-- SETTINGS / CONSENT


viewSettings : Model.AiState -> List (Html Msg)
viewSettings ai =
    [ p [ class "ai-note" ]
        [ text "Longevity Pantry calls the AI provider you choose directly from your browser, using your own API key. Your key and request are sent to that provider — never to Longevity Pantry's servers — and the key is remembered only in this browser." ]
    , div [ class "ai-field" ]
        [ label [ class "ai-label" ] [ text "Provider" ]
        , div [ class "ai-providers" ]
            (List.map (viewProviderChoice ai.settings.provider) Ai.allProviders)
        ]
    , div [ class "ai-field" ]
        [ label [ class "ai-label" ] [ text "API key" ]
        , input
            [ type_ "password"
            , class "ai-input"
            , value ai.settings.apiKey
            , placeholder "Paste your API key"
            , onInput AiSetKey
            ]
            []
        , a
            [ class "ai-link"
            , href (Ai.providerKeyUrl ai.settings.provider)
            , target "_blank"
            , rel "noopener"
            ]
            [ text ("Get a key for " ++ Ai.providerLabel ai.settings.provider ++ " ↗") ]
        ]
    , div [ class "ai-field" ]
        [ label [ class "ai-label" ] [ text "Model" ]
        , input
            [ class "ai-input"
            , value ai.settings.model
            , placeholder (Ai.defaultModel ai.settings.provider)
            , onInput AiSetModel
            ]
            []
        ]
    , div [ class "ai-actions" ]
        [ button
            [ type_ "button"
            , class "ai-btn ai-btn-primary"
            , disabled (String.trim ai.settings.apiKey == "")
            , onClick AiToggleConfigure
            ]
            [ text "Done" ]
        ]
    ]


viewProviderChoice : Ai.Provider -> Ai.Provider -> Html Msg
viewProviderChoice current provider =
    button
        [ type_ "button"
        , classList [ ( "ai-provider", True ), ( "ai-provider-selected", current == provider ) ]
        , onClick (AiSetProvider provider)
        ]
        [ text (Ai.providerLabel provider) ]



-- FORM / RESULT


viewBody : Model.AiState -> List (Html Msg)
viewBody ai =
    case ai.status of
        Ai.Loading ->
            [ div [ class "ai-loading" ] [ text "Generating a recipe…" ] ]

        Ai.Failed message ->
            [ p [ class "ai-error" ] [ text message ]
            , div [ class "ai-actions" ]
                [ button [ type_ "button", class "ai-btn ai-btn-primary", onClick AiGenerate ] [ text "Try again" ]
                , button [ type_ "button", class "ai-btn ai-btn-secondary", onClick AiBackToForm ] [ text "Back" ]
                ]
            ]

        Ai.Ready recipe ->
            viewPreview ai recipe

        Ai.Idle ->
            viewForm ai


viewForm : Model.AiState -> List (Html Msg)
viewForm ai =
    [ div [ class "ai-field" ]
        [ input
            [ class "ai-input"
            , value ai.request
            , placeholder "Anything specific? (optional)"
            , onInput AiSetRequest
            ]
            []
        ]
    , label [ class "ai-check" ]
        [ input [ type_ "checkbox", checked ai.useKitchen, onClick AiToggleKitchen ] []
        , text "Use what's in my Kitchen"
        ]
    , label [ class "ai-check" ]
        [ input [ type_ "checkbox", checked ai.addMissing, onClick AiToggleAddMissing ] []
        , text "Add missing ingredients to my Shopping List"
        ]
    , button
        [ type_ "button", class "ai-more-toggle", onClick AiToggleMoreOptions ]
        [ text
            (if ai.moreOptions then
                "▾ Fewer options"

             else
                "▸ More options"
            )
        ]
    , if ai.moreOptions then
        div [ class "ai-more" ]
            [ viewPrefField "Foods to include" "e.g. lentils, spinach" ai.prefs.include AiSetInclude
            , viewPrefField "Foods to avoid" "e.g. pork, cilantro" ai.prefs.exclude AiSetExclude
            , viewPrefField "Allergies (always excluded)" "e.g. peanuts, shellfish" ai.prefs.allergies AiSetAllergies
            ]

      else
        text ""
    , div [ class "ai-actions" ]
        [ button [ type_ "button", class "ai-btn ai-btn-primary", onClick AiGenerate ] [ text "Generate recipe" ]
        , button [ type_ "button", class "ai-btn ai-btn-secondary", onClick AiToggleConfigure ] [ text "Settings" ]
        ]
    ]


viewPrefField : String -> String -> String -> (String -> Msg) -> Html Msg
viewPrefField labelText placeholderText currentValue toMsg =
    div [ class "ai-field" ]
        [ label [ class "ai-label" ] [ text labelText ]
        , input [ class "ai-input", value currentValue, placeholder placeholderText, onInput toMsg ] []
        ]



-- PREVIEW


viewPreview : Model.AiState -> Ai.GeneratedRecipe -> List (Html Msg)
viewPreview ai recipe =
    [ div [ class "ai-preview" ]
        [ div [ class "ai-preview-name" ] [ text recipe.name ]
        , div [ class "ai-ingredients" ]
            (List.map viewIngredient recipe.ingredients)
        , div [ class "ai-instructions" ] [ text recipe.instructions ]
        ]
    , p [ class "ai-disclaimer" ]
        [ text "AI can make mistakes — check every ingredient against your allergies and preferences before adding." ]
    , div [ class "ai-actions" ]
        [ button [ type_ "button", class "ai-btn ai-btn-primary", onClick AiAccept ]
            [ text
                (if ai.addMissing then
                    "Add recipe & list ingredients"

                 else
                    "Add recipe"
                )
            ]
        , button [ type_ "button", class "ai-btn ai-btn-secondary", onClick AiGenerate ] [ text "Regenerate" ]
        , button [ type_ "button", class "ai-btn ai-btn-secondary", onClick AiBackToForm ] [ text "Discard" ]
        ]
    ]


viewIngredient : Ai.GeneratedIngredient -> Html Msg
viewIngredient ingredient =
    span [ class "ai-chip" ]
        [ text
            (if String.trim ingredient.amount == "" then
                ingredient.name

             else
                ingredient.amount ++ " " ++ ingredient.name
            )
        ]
