module RecipeParser exposing (ParsedRecipe, parsePastedRecipe)

{-| A heuristic parser for a pasted recipe. The first non-empty line is
the name; ingredient lines (under an "Ingredients" header, or bullet
lines) are reduced to bare food names for the chips; the rest of the
paste is kept verbatim as the instructions (preserving amounts and
steps).
-}

import Set exposing (Set)


type alias ParsedRecipe =
    { name : String
    , ingredients : List String
    , instructions : String
    }


parsePastedRecipe : String -> ParsedRecipe
parsePastedRecipe raw =
    let
        lines =
            String.lines raw |> List.map String.trim

        name =
            lines |> List.filter (\l -> l /= "") |> List.head |> Maybe.withDefault "Untitled recipe"

        ( _, ingredientsRev ) =
            List.foldl parseLineStep ( SeekingSection, [] ) lines

        ingredients =
            ingredientsRev
                |> List.reverse
                |> List.filter (\n -> n /= "")
                |> dedupeKeepingOrder
    in
    { name = name
    , ingredients = ingredients
    , instructions = String.trim (String.join "\n" (dropNameLine lines))
    }


type ParseSection
    = SeekingSection
    | IngredientsSection
    | InstructionsSection


parseLineStep : String -> ( ParseSection, List String ) -> ( ParseSection, List String )
parseLineStep line ( section, ings ) =
    if line == "" then
        ( section, ings )

    else if isHeader "ingredient" line then
        ( IngredientsSection, ings )

    else if isInstructionsHeader line then
        ( InstructionsSection, ings )

    else
        case section of
            IngredientsSection ->
                ( section, cleanIngredient line :: ings )

            InstructionsSection ->
                ( section, ings )

            SeekingSection ->
                if isBulletLine line then
                    ( section, cleanIngredient line :: ings )

                else
                    ( section, ings )


isHeader : String -> String -> Bool
isHeader keyword line =
    String.contains keyword (String.toLower line) && String.length line < 40


isInstructionsHeader : String -> Bool
isInstructionsHeader line =
    let
        lo =
            String.toLower line
    in
    String.length line
        < 40
        && (String.contains "instruction" lo
                || String.contains "direction" lo
                || String.contains "method" lo
                || String.contains "steps" lo
                || String.contains "preparation" lo
           )


isBulletLine : String -> Bool
isBulletLine line =
    List.member (String.left 1 line) [ "-", "*", "•", "·", "–", "—" ]


dropNameLine : List String -> List String
dropNameLine lines =
    case lines of
        l :: rest ->
            if String.trim l == "" then
                dropNameLine rest

            else
                rest

        [] ->
            []


dedupeKeepingOrder : List String -> List String
dedupeKeepingOrder items =
    List.foldl
        (\x ( seen, acc ) ->
            let
                key =
                    String.toLower x
            in
            if Set.member key seen then
                ( seen, acc )

            else
                ( Set.insert key seen, x :: acc )
        )
        ( Set.empty, [] )
        items
        |> Tuple.second
        |> List.reverse


{-| Reduce an ingredient line ("2 cups chopped spinach, rinsed") to a bare
food name ("Spinach") for matching against the pyramid.
-}
cleanIngredient : String -> String
cleanIngredient line =
    line
        |> beforeFirst "("
        |> beforeFirst ","
        |> stripLeadingChars "-*•·–—.#)( 0123456789/½¼¾⅓⅔"
        |> String.words
        |> dropWhileList (\w -> isQuantityWord w || isPrepWord w)
        |> String.join " "
        |> String.trim
        |> capitalizeFirst


beforeFirst : String -> String -> String
beforeFirst sep s =
    case String.indexes sep s of
        i :: _ ->
            String.left i s

        [] ->
            s


stripLeadingChars : String -> String -> String
stripLeadingChars chars s =
    case String.uncons s of
        Just ( c, rest ) ->
            if String.contains (String.fromChar c) chars then
                stripLeadingChars chars rest

            else
                s

        Nothing ->
            s


capitalizeFirst : String -> String
capitalizeFirst s =
    String.toUpper (String.left 1 s) ++ String.dropLeft 1 s


dropWhileList : (a -> Bool) -> List a -> List a
dropWhileList pred list =
    case list of
        x :: xs ->
            if pred x then
                dropWhileList pred xs

            else
                list

        [] ->
            []


stripTrailingPunct : String -> String
stripTrailingPunct w =
    if List.any (\p -> String.endsWith p w) [ ".", ",", ")", ":", ";" ] then
        stripTrailingPunct (String.dropRight 1 w)

    else
        w


isQuantityWord : String -> Bool
isQuantityWord w =
    let
        core =
            stripTrailingPunct w
    in
    (core /= "" && (String.toList core |> List.all (\ch -> String.contains (String.fromChar ch) "0123456789/.-x×")))
        || Set.member (String.toLower core) measureWords


measureWords : Set String
measureWords =
    Set.fromList
        [ "cup", "cups", "tbsp", "tbs", "tablespoon", "tablespoons", "tsp", "teaspoon", "teaspoons", "oz", "ounce", "ounces", "lb", "lbs", "pound", "pounds", "g", "gram", "grams", "kg", "ml", "l", "liter", "liters", "litre", "litres", "clove", "cloves", "can", "cans", "jar", "jars", "slice", "slices", "pinch", "pinches", "dash", "handful", "bunch", "bunches", "sprig", "sprigs", "stick", "sticks", "head", "heads", "package", "packages", "pkg", "qt", "quart", "quarts", "pint", "pints", "stalk", "stalks", "fillet", "fillets", "piece", "pieces", "of" ]


isPrepWord : String -> Bool
isPrepWord w =
    Set.member (String.toLower (stripTrailingPunct w)) prepWords


prepWords : Set String
prepWords =
    Set.fromList
        [ "fresh", "dried", "ground", "chopped", "diced", "minced", "sliced", "grated", "crushed", "whole", "raw", "cooked", "ripe", "finely", "coarsely", "thinly", "peeled", "seeded", "halved", "quartered", "cubed", "shredded", "packed", "frozen", "canned", "organic", "large", "small", "medium", "ripe", "boneless", "skinless", "extra" ]
