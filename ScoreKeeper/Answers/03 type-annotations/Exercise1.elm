module Main exposing (..)

import List
import Html


type alias Item =
    { name : String, qty : Int, freeQty : Int }


cart : List Item
cart =
    [ { name = "Lemon", qty = 1, freeQty = 0 }
    , { name = "Apple", qty = 5, freeQty = 0 }
    , { name = "Pear", qty = 10, freeQty = 0 }
    ]


numFree : Int -> Int -> Item -> Item
numFree minNum free item =
    if item.qty >= minNum && item.freeQty == 0 then
        { item | freeQty = free }
    else
        item


discountedCart : List Item
discountedCart =
    List.map ((numFree 10 3) >> (numFree 5 1)) cart


main : Html.Html msg
main =
    Html.text (toString discountedCart)
