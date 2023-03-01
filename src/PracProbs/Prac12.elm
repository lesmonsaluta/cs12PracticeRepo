module PracProbs.Prac12 exposing (..)


import Html
import Set
import Array
import Json.Decode exposing (int)
import Bitwise exposing (shiftRightZfBy)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)
sumOfOdds: List Int -> Int
sumOfOdds list =
    let
        isOdd : Int -> Bool
        isOdd int =
            modBy 2 int /= 0
    in
    List.filter isOdd list
    |> List.sum


main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (sumOfOdds [4,4,4,4,4])
    in
    -- Ignore the line below
    Html.text ""