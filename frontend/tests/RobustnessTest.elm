module RobustnessTest exposing (suite)

{-| Hostile and degenerate pastes: the parser must fail quietly — no
invented ingredients from prose, no crashes on emptiness or bulk, no
corruption from encodings and odd bullets.
-}

import Expect
import RecipeParser exposing (parsePastedRecipe)
import Test exposing (Test, describe, test)


catalog : List String
catalog =
    [ "Tomatoes", "Kale", "Jalapeños", "Açaí" ]


parse : String -> RecipeParser.ParsedRecipe
parse =
    parsePastedRecipe catalog


suite : Test
suite =
    describe "robustness"
        [ describe "degenerate input"
            [ test "empty paste" <|
                \_ ->
                    parse ""
                        |> Expect.equal { name = "Untitled recipe", ingredients = [], instructions = "" }
            , test "whitespace-only paste" <|
                \_ ->
                    parse "   \n\t\n  "
                        |> Expect.equal { name = "Untitled recipe", ingredients = [], instructions = "" }
            ]
        , describe "prose is not a recipe"
            [ test "an article paragraph yields no chips" <|
                \_ ->
                    (parse "A Brief History of Soup\n\nSoup is ancient. Mix the ingredients well, our ancestors knew, and dinner follows. There are many directions a broth can take.\n\nScholars disagree about the rest.").ingredients
                        |> Expect.equal []
            , test "a keyword buried in prose does not flip sections" <|
                \_ ->
                    (parse "Notes\n\nSimple, wholesome ingredients.\nThis line must not become a chip.").ingredients
                        |> Expect.equal []
            ]
        , describe "bulk"
            [ test "a very long paste parses and keeps only the bulleted foods" <|
                \_ ->
                    let
                        blather =
                            List.repeat 400 "The story continues at considerable length." |> String.join "\n"
                    in
                    (parse ("War and Peas\n\n" ++ blather ++ "\n- 2 cups kale\n" ++ blather)).ingredients
                        |> Expect.equal [ "Kale" ]
            ]
        , describe "encodings and bullets"
            [ test "windows line endings do not corrupt chips" <|
                \_ ->
                    (parse "Soup\u{000D}\n\u{000D}\nIngredients:\u{000D}\n- 2 tomatoes\u{000D}\n- 1 bunch kale\u{000D}\n\u{000D}\nMethod:\u{000D}\nSimmer.").ingredients
                        |> Expect.equal [ "Tomatoes", "Kale" ]
            , test "accented foods survive and match the catalog" <|
                \_ ->
                    (parse "Salsa\n\nIngredients:\n- 2 jalapeños, sliced\n- 1 cup açaí").ingredients
                        |> Expect.equal [ "Jalapeños", "Açaí" ]
            , test "en-dash, em-dash, and middot bullets are recognized" <|
                \_ ->
                    (parse "Soup\n\n– 1 tomato\n— 2 cups kale\n· 1 jalapeño").ingredients
                        |> Expect.equal [ "Tomatoes", "Kale", "Jalapeños" ]
            ]
        , describe "documented behaviour for odd structures"
            [ test "two recipes in one paste pool their ingredients under the first name" <|
                \_ ->
                    let
                        parsed =
                            parse "Salad\n\nIngredients:\n- 1 tomato\n\nInstructions:\nToss.\n\nSmoothie\n\nIngredients:\n- 2 cups kale\n\nInstructions:\nBlend."
                    in
                    ( parsed.name, parsed.ingredients )
                        |> Expect.equal ( "Salad", [ "Tomatoes", "Kale" ] )
            ]
        ]
