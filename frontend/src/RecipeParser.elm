module RecipeParser exposing (ParsedIngredient, ParsedRecipe, canonicalize, parsePastedRecipe)

{-| A heuristic parser for a pasted recipe. The first non-empty line is
the name; ingredient lines (under an "Ingredients" header, or bullet
lines) are reduced to bare food names for the chips; the rest of the
paste is kept verbatim as the instructions (preserving amounts and
steps).

Chip names resolve against the food catalog so a pasted ingredient joins
the food the kitchen already tracks instead of duplicating it under
another spelling: an exact case-insensitive match adopts the catalog's
casing, and whole-name singular/plural pairs fold together ("tomato"
becomes "Tomatoes"). Matching never reaches into substrings, so "Coconut
milk" cannot collapse into "Coconut".

Each chip also carries the item count the line implies — "3 red bell
peppers" is three peppers on the shopping list, and "2 cans black beans"
is two cans, but "2 cups spinach" is an amount of one bag of spinach,
not two of anything, so measures of volume or weight never count.

-}

import Char
import Dict exposing (Dict)
import Set exposing (Set)


type alias ParsedRecipe =
    { name : String
    , ingredients : List ParsedIngredient
    , instructions : String
    }


{-| One parsed chip: the catalog-resolved food name and the discrete
item count its ingredient line implies (1 whenever the line's leading
number measures volume or weight rather than countable items).
-}
type alias ParsedIngredient =
    { name : String
    , count : Int
    }


parsePastedRecipe : List String -> String -> ParsedRecipe
parsePastedRecipe catalog raw =
    let
        lines =
            String.lines raw |> List.map String.trim

        name =
            lines |> List.filter (\l -> l /= "") |> List.head |> Maybe.withDefault "Untitled recipe"

        ( _, ingredientLinesRev ) =
            List.foldl parseLineStep ( SeekingSection, [] ) lines

        resolve =
            canonicalName (catalogIndex catalog)

        ingredients =
            ingredientLinesRev
                |> List.reverse
                |> List.map (\l -> { name = resolve (cleanIngredient l), count = itemCount l })
                |> List.filter (\ing -> ing.name /= "")
                |> dedupeKeepingOrder
    in
    { name = name
    , ingredients = ingredients
    , instructions = String.trim (String.join "\n" (dropNameLine lines))
    }


{-| Resolve one typed name against the catalog, with the same rules the
paste parser applies to every ingredient. For a single name the index is
built and used once, which is cheap at the scale of a keystroke-driven
add.
-}
canonicalize : List String -> String -> String
canonicalize catalog =
    canonicalName (catalogIndex catalog)


{-| The catalog's names, indexed for resolution: once by their exact
lowercase form, once by their plural-folded form.
-}
type alias CatalogIndex =
    { exact : Dict String String
    , folded : Dict String String
    }


catalogIndex : List String -> CatalogIndex
catalogIndex catalog =
    { exact =
        Dict.fromList (List.map (\n -> ( String.toLower n, n )) catalog)
    , folded =
        Dict.fromList (List.map (\n -> ( foldKey n, n )) catalog)
    }


{-| Resolve a parsed chip name to its catalog food, if it has one: an
exact case-insensitive match wins, then a whole-name singular/plural
fold. Anything else passes through untouched.
-}
canonicalName : CatalogIndex -> String -> String
canonicalName index name =
    case Dict.get (String.toLower name) index.exact of
        Just canon ->
            canon

        Nothing ->
            Dict.get (foldKey name) index.folded
                |> Maybe.withDefault name


{-| A name's plural-insensitive key: lowercase, with only the last word
singularized, so multi-word names never merge with their head word
("date syrup" cannot fold into "dates").
-}
foldKey : String -> String
foldKey name =
    case List.reverse (String.words (String.toLower name)) of
        last :: front ->
            String.join " " (List.reverse (singularize last :: front))

        [] ->
            ""


{-| A naive English singular fold, applied identically to both sides of
the match so imperfect stems still meet ("hummus" and "Hummus" fold the
same way).
-}
singularize : String -> String
singularize word =
    if String.endsWith "ies" word && String.length word > 4 then
        String.dropRight 3 word ++ "y"

    else if List.any (\suffix -> String.endsWith suffix word) [ "oes", "ses", "xes", "zes", "ches", "shes" ] then
        String.dropRight 2 word

    else if String.endsWith "s" word && not (String.endsWith "ss" word) && String.length word > 3 then
        String.dropRight 1 word

    else
        word


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
                ( section, line :: ings )

            InstructionsSection ->
                ( section, ings )

            SeekingSection ->
                if isBulletLine line then
                    ( section, line :: ings )

                else
                    ( section, ings )


{-| A section header mentions the keyword and looks like a header: short,
and either colon-terminated or a few words with no sentence-ending period
— so prose like "Mix the ingredients well." cannot flip the section.
-}
isHeader : String -> String -> Bool
isHeader keyword line =
    String.contains keyword (String.toLower line)
        && (String.length line < 40)
        && (String.endsWith ":" line
                || (List.length (String.words line) <= 3 && not (String.endsWith "." line))
           )


isInstructionsHeader : String -> Bool
isInstructionsHeader line =
    List.any (\keyword -> isHeader keyword line)
        [ "instruction", "direction", "method", "steps", "preparation" ]


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


dedupeKeepingOrder : List ParsedIngredient -> List ParsedIngredient
dedupeKeepingOrder items =
    List.foldl
        (\x ( seen, acc ) ->
            let
                key =
                    String.toLower x.name
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


{-| The discrete item count an ingredient line implies. A leading number
counts items only when what follows is countable: the food itself ("3
red bell peppers") or a purchasable unit ("2 cans black beans", "4
cloves garlic"). A number that measures volume or weight ("2 cups
spinach", "400g lentils") counts nothing — the chip is one item however
much of it the recipe uses — and a line with no leading number is one
item.
-}
itemCount : String -> Int
itemCount line =
    let
        tokens =
            line
                |> stripParentheticals
                |> afterLabel
                |> stripLeadingChars bulletChars
                |> stripLeadingArticle
                |> stripFoodOfPrefix
                |> String.words
    in
    case tokens of
        first :: rest ->
            case leadingNumber (stripTrailingPunct first) of
                Just n ->
                    if numberCountsItems rest then
                        n

                    else
                        1

                Nothing ->
                    1

        [] ->
            1


{-| Whether the tokens after a leading number name something countable:
prep words and articles are skipped, a volume or weight measure means
the number was an amount, and anything else — a purchasable unit or the
food itself — means the number was a count.
-}
numberCountsItems : List String -> Bool
numberCountsItems tokens =
    case tokens of
        t :: rest ->
            let
                word =
                    String.toLower (stripTrailingPunct t)
            in
            if isPrepWord t || isArticleWord t || word == "of" then
                numberCountsItems rest

            else if Set.member word volumeMeasureWords then
                False

            else
                word /= ""

        [] ->
            False


{-| Read a count from an ingredient line's leading token: "3" and
"three" count, a range ("1-2") counts its larger end, a whole number
with a trailing fraction ("1½") rounds up, and a bare fraction ("½",
"1/2") is one item. Anything else is not a number.
-}
leadingNumber : String -> Maybe Int
leadingNumber token =
    let
        isDash c =
            c == '-' || c == '–'

        isFraction c =
            String.contains (String.fromChar c) fractionChars
    in
    if token == "" then
        Nothing

    else if String.any isDash token then
        case List.reverse (String.split "-" (String.replace "–" "-" token)) of
            last :: _ ->
                leadingNumber last

            [] ->
                Nothing

    else if String.contains "/" token then
        -- A slashed fraction is a part of one item; buy the whole one.
        Just 1

    else if String.all Char.isDigit token then
        String.toInt token

    else if String.all isFraction token then
        Just 1

    else
        case String.toInt (String.filter Char.isDigit token) of
            Just n ->
                if String.all (\c -> Char.isDigit c || isFraction c) token then
                    -- "1½" rounds up: the half means opening a second one.
                    Just (n + 1)

                else
                    Dict.get (String.toLower token) numberWordValues

            Nothing ->
                Dict.get (String.toLower token) numberWordValues


{-| Reduce an ingredient line ("2 cups chopped spinach, rinsed") to a bare
food name ("Spinach") for matching against the pyramid. Parentheticals,
notes after a comma, "or"-alternatives, and serving phrases fall away;
subsection labels inside an ingredient list ("For the sauce:") yield no
chip at all.
-}
cleanIngredient : String -> String
cleanIngredient line =
    let
        core =
            line
                |> stripParentheticals
                |> afterLabel
    in
    if core == "" || isSubsectionWord core then
        ""

    else
        core
            |> beforeFirst ","
            |> beforeFirst ";"
            |> afterLast " or "
            |> beforeFirst " from "
            |> stripLeadingChars leadingChars
            |> stripLeadingArticle
            |> stripFoodOfPrefix
            |> stripLeadingChars leadingChars
            |> String.words
            |> dropWhileList (\w -> isQuantityWord w || isPrepWord w || isArticleWord w)
            |> dropTrailingMeasure
            |> String.join " "
            |> String.trim
            |> stripServingPhrase
            |> capitalizeFirst


{-| The vulgar-fraction glyphs treated as quantities, kept in one place so
the leading-strip and the quantity-token checks cannot drift apart.
-}
fractionChars : String
fractionChars =
    "½¼¾⅓⅔⅛⅜⅝⅞⅙⅚"


{-| The characters that compose a bare quantity token: digits, the
separators and multipliers that join them, and the vulgar fractions.
-}
quantityChars : String
quantityChars =
    "0123456789/.-x×" ++ fractionChars


{-| The leading noise stripped from the front of an ingredient line:
bullets, list punctuation, and a leading quantity.
-}
leadingChars : String
leadingChars =
    bulletChars ++ "0123456789/" ++ fractionChars


{-| Bullet and list punctuation alone — the leading strip that keeps a
quantity in place, for the count extraction that needs to read it.
-}
bulletChars : String
bulletChars =
    "-*•·–—.#)(▢□☐ "


{-| Remove every "(...)" span, so "2 (15-ounce) cans black beans" keeps
its food instead of losing everything after the parenthesis.
-}
stripParentheticals : String -> String
stripParentheticals s =
    case ( String.indexes "(" s, String.indexes ")" s ) of
        ( open :: _, _ ) ->
            case List.filter (\close -> close > open) (String.indexes ")" s) of
                close :: _ ->
                    stripParentheticals
                        (String.trim (String.left open s)
                            ++ " "
                            ++ String.trim (String.dropLeft (close + 1) s)
                        )

                [] ->
                    String.left open s

        _ ->
            s


{-| Resolve a leading "Label:" — "Optional toppings: avocado, …" keeps the
content after the colon, while a bare "For the sauce:" leaves nothing and
so produces no chip.
-}
afterLabel : String -> String
afterLabel s =
    case String.indexes ":" s of
        i :: _ ->
            String.trim (String.dropLeft (i + 1) s)

        [] ->
            String.trim s


{-| A lone subsection word sitting in an ingredient list ("Batter",
"Topping") is a header, not a food.
-}
isSubsectionWord : String -> Bool
isSubsectionWord s =
    Set.member (String.toLower s) subsectionWords
        || (s
                == String.toUpper s
                && (s /= String.toLower s)
                && not (String.any Char.isDigit s)
                && (List.length (String.words s) <= 2)
           )


subsectionWords : Set String
subsectionWords =
    Set.fromList
        [ "batter", "topping", "toppings", "sauce", "dressing", "filling", "garnish", "garnishes", "marinade", "glaze", "frosting", "streusel", "base", "crust" ]


{-| Trim a trailing serving phrase ("sea salt to taste") once the
quantities are gone.
-}
stripServingPhrase : String -> String
stripServingPhrase s =
    List.foldl
        (\phrase acc ->
            if String.endsWith phrase (String.toLower acc) then
                String.trim (String.dropRight (String.length phrase) acc)

            else
                acc
        )
        s
        [ " to taste", " for serving", " for garnish", " as needed", " to serve", " plus more" ]


{-| Drop a trailing measure word left after the food ("garlic cloves",
"celery ribs"), so the chip is the food itself.
-}
dropTrailingMeasure : List String -> List String
dropTrailingMeasure words =
    case List.reverse words of
        last :: ((_ :: _) as front) ->
            if Set.member (String.toLower (stripTrailingPunct last)) measureWords then
                List.reverse front

            else
                words

        _ ->
            words


{-| Keep the text after the last " or ": alternatives put the fuller
option last, and adjective alternatives share their head noun ("brown or
green lentils" keeps "green lentils").
-}
afterLast : String -> String -> String
afterLast sep s =
    case List.reverse (String.indexes sep s) of
        i :: _ ->
            String.dropLeft (i + String.length sep) s

        [] ->
            s


{-| Strip a leading article so it is gone before the "juice of" prefixes
and the quantity words are examined ("the juice of 1 lemon" is a lemon,
"a pinch of salt" is salt).
-}
stripLeadingArticle : String -> String
stripLeadingArticle s =
    List.foldl
        (\article acc ->
            if String.startsWith article (String.toLower acc) then
                String.trim (String.dropLeft (String.length article) acc)

            else
                acc
        )
        s
        [ "a ", "an ", "the " ]


{-| An article standing between a count and its food ("half a lemon") is
noise, not part of the food name.
-}
isArticleWord : String -> Bool
isArticleWord w =
    Set.member (String.toLower (stripTrailingPunct w)) articleWords


articleWords : Set String
articleWords =
    Set.fromList [ "a", "an", "the" ]


{-| Strip a "juice of" / "zest of" lead ("juice of 1 lemon" is a lemon).
-}
stripFoodOfPrefix : String -> String
stripFoodOfPrefix s =
    List.foldl
        (\prefix acc ->
            if String.startsWith prefix (String.toLower acc) then
                String.trim (String.dropLeft (String.length prefix) acc)

            else
                acc
        )
        s
        [ "juice of ", "zest of " ]


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

        unitPart =
            core
                |> String.toLower
                |> String.toList
                |> dropWhileList (\ch -> String.contains (String.fromChar ch) quantityChars)
                |> String.fromList

        digitPart =
            String.left (String.length core - String.length unitPart) core
    in
    (core /= "" && (String.toList core |> List.all (\ch -> String.contains (String.fromChar ch) quantityChars)))
        || Set.member (String.toLower core) measureWords
        || Set.member (String.toLower core) numberWords
        -- A number fused to its unit ("28-ounce", "400g") is a quantity too.
        || (digitPart /= "" && Set.member unitPart measureWords)


measureWords : Set String
measureWords =
    Set.fromList
        [ "cup", "cups", "tbsp", "tbs", "tablespoon", "tablespoons", "tsp", "teaspoon", "teaspoons", "oz", "ounce", "ounces", "lb", "lbs", "pound", "pounds", "g", "gram", "grams", "kg", "ml", "l", "liter", "liters", "litre", "litres", "clove", "cloves", "can", "cans", "jar", "jars", "slice", "slices", "pinch", "pinches", "dash", "handful", "bunch", "bunches", "sprig", "sprigs", "stick", "sticks", "head", "heads", "package", "packages", "pkg", "qt", "quart", "quarts", "pint", "pints", "stalk", "stalks", "fillet", "fillets", "piece", "pieces", "of", "rib", "ribs", "container", "containers", "bag", "bags", "box", "boxes", "envelope", "gallon", "gallons", "sheet", "sheets", "sprigs", "ear", "ears", "knob", "each" ]


{-| Spelled-out cardinal counts that lead an ingredient the way a digit
would ("two lemons", "half a cup").
-}
numberWords : Set String
numberWords =
    Set.fromList (Dict.keys numberWordValues)


{-| The value each spelled-out count carries when it counts items.
"Half" is one — half a lemon is still a lemon bought whole.
-}
numberWordValues : Dict String Int
numberWordValues =
    Dict.fromList
        [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ), ( "four", 4 ), ( "five", 5 ), ( "six", 6 ), ( "seven", 7 ), ( "eight", 8 ), ( "nine", 9 ), ( "ten", 10 ), ( "eleven", 11 ), ( "twelve", 12 ), ( "half", 1 ), ( "dozen", 12 ) ]


{-| The measures of volume, weight, or vague amount, under which a
leading number measures the food rather than counting items. The
remaining measure words — cans, cloves, bunches, heads, and the other
purchasable units — leave the number counting real things.
-}
volumeMeasureWords : Set String
volumeMeasureWords =
    Set.fromList
        [ "cup", "cups", "tbsp", "tbs", "tablespoon", "tablespoons", "tsp", "teaspoon", "teaspoons", "oz", "ounce", "ounces", "lb", "lbs", "pound", "pounds", "g", "gram", "grams", "kg", "ml", "l", "liter", "liters", "litre", "litres", "pinch", "pinches", "dash", "handful", "qt", "quart", "quarts", "pint", "pints", "gallon", "gallons", "knob", "each" ]


isPrepWord : String -> Bool
isPrepWord w =
    Set.member (String.toLower (stripTrailingPunct w)) prepWords


prepWords : Set String
prepWords =
    Set.fromList
        [ "fresh", "dried", "ground", "chopped", "diced", "minced", "sliced", "grated", "crushed", "whole", "raw", "cooked", "ripe", "finely", "coarsely", "thinly", "peeled", "seeded", "halved", "quartered", "cubed", "shredded", "packed", "frozen", "canned", "organic", "large", "small", "medium", "boneless", "skinless", "extra", "freshly", "mashed", "uncooked", "toasted", "roasted", "melted", "softened", "unsalted", "unsweetened", "low-sodium", "plain", "warm", "cold", "hot", "cracked", "lightly", "roughly", "loosely", "firmly", "baby", "prepared", "trimmed", "rinsed", "drained", "divided" ]
