module PracProbs.Prac7 exposing (..)

import Html
import Set
import Array
import Json.Decode exposing (int)
import Bitwise exposing (shiftRightZfBy)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)
repeat: Int -> String -> String
repeat int str =
    String.repeat int str


main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (functioncall function)
    in
    -- Ignore the line below
    Html.text ""