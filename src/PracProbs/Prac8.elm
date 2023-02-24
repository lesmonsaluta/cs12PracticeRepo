module PracProbs.Prac8 exposing (..)

import Html
import Set
import Array
import Json.Decode exposing (int)
import Bitwise exposing (shiftRightZfBy)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)
sevenUp: String -> Bool
sevenUp str =
    let
        charToInt : Char -> Int
        charToInt letter =
            String.fromChar letter
            |> String.toInt
            |> Maybe.withDefault 0
        equalToSeven : Int -> Bool
        equalToSeven sum =
            sum == 7
    in
    String.right 3 str
    |> String.toList
    |> List.map charToInt
    |> List.sum
    |> equalToSeven

    



main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (sevenUp "12345password12700")
    in
    -- Ignore the line below
    Html.text ""