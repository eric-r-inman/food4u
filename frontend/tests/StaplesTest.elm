module StaplesTest exposing (suite)

{-| The Auto staples data must stay well-formed — the five diets the
recipe tags use, each with a real list and no internal duplicates — and
the merge must never duplicate a staple already in the tracker, however
it is cased. (That every staple matches a catalog food name exactly is
checked against the seed during development; the catalog lives server-side
and is out of an Elm test's reach.)
-}

import Expect
import Set
import Staples exposing (diets, missingStaples)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "auto staples"
        [ test "the menu offers exactly the diets the recipe tags use" <|
            \_ ->
                List.map .name diets
                    |> Expect.equal [ "Mediterranean", "Blue Zone", "MIND", "DASH", "Anti-Inflammatory" ]
        , test "every diet carries a full list with no internal duplicates" <|
            \_ ->
                diets
                    |> List.all
                        (\d ->
                            List.length d.staples
                                > 0
                                && List.length d.staples
                                == Set.size (Set.fromList (List.map String.toLower d.staples))
                        )
                    |> Expect.equal True
        , test "an empty tracker receives the diet's whole list" <|
            \_ ->
                missingStaples [] "MIND"
                    |> List.length
                    |> Expect.equal 16
        , test "a staple already present is skipped, case-insensitively" <|
            \_ ->
                missingStaples [ "extra-virgin olive oil", "WALNUTS" ] "Mediterranean"
                    |> Expect.all
                        [ \names -> List.member "Extra-virgin olive oil" names |> Expect.equal False
                        , \names -> List.member "Walnuts" names |> Expect.equal False
                        , \names -> List.length names |> Expect.equal 14
                        ]
        , test "re-running a diet adds nothing" <|
            \_ ->
                missingStaples (missingStaples [] "DASH") "DASH"
                    |> Expect.equal []
        , test "stacking overlapping diets yields their union" <|
            \_ ->
                let
                    afterMediterranean =
                        missingStaples [] "Mediterranean"
                in
                missingStaples afterMediterranean "Blue Zone"
                    |> Expect.all
                        [ \names -> List.member "Chickpeas" names |> Expect.equal False
                        , \names -> List.member "Miso" names |> Expect.equal True
                        ]
        , test "an unknown diet adds nothing" <|
            \_ ->
                missingStaples [] "Carnivore"
                    |> Expect.equal []
        ]
