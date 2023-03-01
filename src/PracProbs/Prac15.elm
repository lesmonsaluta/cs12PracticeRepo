module PracProbs.Prac15 exposing (..)

import Html
import Set
import Array
import Json.Decode exposing (int)
import Bitwise exposing (shiftRightZfBy)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)
sumDigits: String -> Int
sumDigits str = 
    let
        charToInt : Char -> Int
        charToInt letter =
            letter 
            |> String.fromChar
            |> String.toInt
            |> Maybe.withDefault 0
    in
    String.toList str
    |> List.map charToInt
    |> List.sum
    


main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (sumDigits "hello123")
    in
    -- Ignore the line below
    Html.text ""