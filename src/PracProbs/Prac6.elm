module PracProbs.Prac6 exposing (..)

import Html
import Set
import Array
import Json.Decode exposing (int)
import Bitwise exposing (shiftRightZfBy)

reverse : String -> String
reverse str =
    String.reverse str


main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (functioncall function)
    in
    -- Ignore the line below
    Html.text ""