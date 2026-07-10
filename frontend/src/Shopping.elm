module Shopping exposing
    ( cartCardId
    , shoppingListText
    )

{-| The Shopping List's helpers: locating the reserved cart card and
rendering the whole list — one section per user category — as plain text
for export.
-}

import Data exposing (Data, isShoppingCard, shoppingCartName)


{-| The card id of the reserved Shopping List card, if present. It is the
uncategorised bucket recipe and staple additions land in.
-}
cartCardId : Data -> Maybe String
cartCardId data =
    data.staples
        |> List.filter (\c -> c.name == shoppingCartName)
        |> List.head
        |> Maybe.map .id


{-| The Shopping List rendered as plain text: one section per category in
the order the categories appear, the reserved bucket labelled "Unsorted",
empty categories omitted.
-}
shoppingListText : Data -> String
shoppingListText data =
    let
        sectionLabel card =
            if card.name == shoppingCartName then
                "Unsorted"

            else
                card.name

        renderSection card =
            sectionLabel card
                ++ "\n"
                ++ String.join "\n" (List.map (\i -> "- " ++ i.name) card.items)
    in
    data.staples
        |> List.filter isShoppingCard
        |> List.filter (\c -> not (List.isEmpty c.items))
        |> List.map renderSection
        |> String.join "\n\n"
        |> (\body -> "Shopping List\n\n" ++ body ++ "\n")
