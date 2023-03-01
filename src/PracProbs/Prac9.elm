module PracProbs.Prac9 exposing (..)

import Html
import Set
import Array
import Json.Decode exposing (int)
import Bitwise exposing (shiftRightZfBy)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)
summation: Int -> Int
summation int =
    List.range 1 int
    |> List.sum


main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (summation 12)
    in
    -- Ignore the line below
    Html.text ""