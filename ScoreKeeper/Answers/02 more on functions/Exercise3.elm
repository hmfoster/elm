module Main exposing (..)

import Html
import String
import List


wordCount =
    String.words >> List.length


main =
    "Hello, my name is Luna"
        |> wordCount
        |> toString
        |> Html.text
