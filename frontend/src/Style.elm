module Style exposing
    ( cardStyle
    , categoryChipBg
    , chipBase
    , foodChipStyle
    , panePalette
    , searchHighlightStyle
    , stapleMissingStyle
    , styles
    , tierChipBg
    )

{-| Presentational helpers shared across the columns: the inline-style
list helper the rest of the app is built on, the card and chip base
styles, the per-category chip tint, and the search-match highlight.
-}

import Html exposing (Attribute)
import Html.Attributes exposing (style)


styles : List ( String, String ) -> List (Attribute msg)
styles =
    List.map (\( k, v ) -> style k v)


{-| The header colours already used across the app's columns and panes —
the only choices offered when recolouring a pane's title row, so a
recoloured pane stays within the established palette.
-}
panePalette : List String
panePalette =
    [ "oklch(0.55 0.08 74)" -- Kitchen / Pantry
    , "oklch(0.5 0.085 64)" -- Counter
    , "oklch(0.5 0.11 45)" -- Spice Cupboard
    , "oklch(0.52 0.1 42)" -- Shopping List column
    , "oklch(0.5 0.09 150)" -- Shopping List pane
    , "oklch(0.49 0.06 232)" -- Refrigerator
    , "oklch(0.52 0.06 212)" -- Freezer
    , "oklch(0.43 0.06 250)" -- Recipes
    , "oklch(0.5 0.09 265)" -- Staples Tracker
    , "oklch(0.5 0.08 300)" -- Apothecary
    ]


cardStyle : List (Attribute msg)
cardStyle =
    styles
        [ ( "background", "oklch(0.99 0.006 86)" )
        , ( "border", "1px solid oklch(0.9 0.012 86)" )
        , ( "border-radius", "14px" )
        , ( "box-shadow", "0 18px 50px -28px rgba(60,45,20,0.35)" )
        ]


chipBase : List (Attribute msg)
chipBase =
    styles
        [ ( "display", "inline-flex" )
        , ( "align-items", "center" )
        , ( "gap", "5px" )
        , ( "padding", "4px 9px" )
        , ( "border-radius", "6px" )
        , ( "font-size", "13.5px" )
        , ( "line-height", "1.1" )
        , ( "cursor", "grab" )
        ]


{-| Style a pyramid food chip. The background is a very light,
category-specific tint; a food already stocked in a storage pane gets a
dark border so it stands out as in-stock.
-}
foodChipStyle : String -> Bool -> List (Attribute msg)
foodChipStyle bg inStock =
    chipBase
        ++ styles
            [ ( "background", bg )
            , ( "border"
              , if inStock then
                    "2px solid oklch(0.32 0.01 70)"

                else
                    "1px solid oklch(0.88 0.012 86)"
              )
            , ( "font-weight", "500" )
            , ( "color", "oklch(0.32 0.012 70)" )
            ]


{-| A light badge tint in the hue of the given rail colour (an
`oklch(l c h)` string), so a set of chips can share one colour derived from
a header. Falls back to white if the colour does not parse.
-}
tierChipBg : String -> String
tierChipBg rail =
    oklchHue rail
        |> Maybe.map (\hue -> "oklch(0.93 0.055 " ++ hue ++ ")")
        |> Maybe.withDefault "oklch(1 0 0)"


{-| The hue component of an `oklch(l c h)` colour string.
-}
oklchHue : String -> Maybe String
oklchHue color =
    color
        |> String.replace "oklch(" ""
        |> String.replace ")" ""
        |> String.words
        |> List.drop 2
        |> List.head


{-| Very light background tint for each pyramid category, so foods read
at a glance by the group they belong to. Unmapped categories fall back
to white.
-}
categoryChipBg : String -> String
categoryChipBg label =
    case label of
        "Oils & healthy fats" ->
            "oklch(0.96 0.06 98)"

        "Leafy greens" ->
            "oklch(0.92 0.075 150)"

        "Vegetables" ->
            "oklch(0.95 0.05 135)"

        "Whole grains" ->
            "oklch(0.93 0.035 82)"

        "Fruit" ->
            "oklch(0.94 0.05 315)"

        "Herbs & spices" ->
            "oklch(0.95 0.045 175)"

        "Tea & botanicals" ->
            "oklch(0.95 0.006 250)"

        "Legumes & pulses" ->
            "oklch(0.93 0.07 52)"

        "Nuts & seeds" ->
            "oklch(0.9 0.045 62)"

        "Soy & fermented" ->
            "oklch(0.96 0.08 105)"

        "Cultured dairy · moderate" ->
            "oklch(0.99 0.002 86)"

        "Supplements" ->
            "oklch(0.95 0.035 300)"

        "Oily & white fish" ->
            "oklch(0.94 0.05 245)"

        "Eggs & poultry" ->
            "oklch(0.95 0.05 210)"

        "Sweeteners & extras" ->
            "oklch(0.95 0.08 58)"

        "Limit" ->
            "oklch(0.95 0.08 58)"

        _ ->
            "oklch(1 0 0)"


searchHighlightStyle : List (Attribute msg)
searchHighlightStyle =
    chipBase
        ++ styles
            [ ( "background", "oklch(0.92 0.14 95)" )
            , ( "border", "2px solid oklch(0.7 0.16 90)" )
            , ( "font-weight", "600" )
            , ( "color", "oklch(0.3 0.05 80)" )
            ]


{-| A staple that is not on hand in any kitchen pane, shown red in the
Staples Tracker so a glance says what still needs buying.
-}
stapleMissingStyle : List (Attribute msg)
stapleMissingStyle =
    chipBase
        ++ styles
            [ ( "background", "oklch(0.94 0.05 25)" )
            , ( "border", "2px solid oklch(0.62 0.18 25)" )
            , ( "font-weight", "600" )
            , ( "color", "oklch(0.48 0.17 25)" )
            ]
