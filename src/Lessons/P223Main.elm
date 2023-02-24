module Practice.P223Main exposing (..)

import Html
import Set
import Array
import Json.Decode exposing (int)
import Bitwise exposing (shiftRightZfBy)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)

min3 : Int -> Int -> Int -> Int
min3 a b c = 
    let
        min_so_far =
            if a > b then b
            else a 
    in
    if min_so_far < c then min_so_far
    else c

main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (min3 14 5 10)
    in
    -- Ignore the line below
    Html.text ""