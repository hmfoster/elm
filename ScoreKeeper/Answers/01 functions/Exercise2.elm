module Main exposing (..)

import Html
import String


uppercase maxLength name =
    if String.length name > maxLength then
        String.toUpper name
    else
        name


main =
    let
        name =
            "Hailey Foster"

        length =
            String.length name
    in
        (uppercase 10 name)
            ++ " - length is "
            ++ toString length
            |> Html.text
