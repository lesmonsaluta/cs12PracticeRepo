module PracProbs.Prac4 exposing (..)


import Html
import Array exposing (get)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)


isFactor : Int -> Int -> Bool
isFactor k n =
    remainderBy k n == 0

isOdd : Int -> Bool
isOdd n =
    not (isFactor 2 n)

isOddFactor : Int -> Int -> Bool
isOddFactor k n =
    (isOdd k) && (isFactor k n)

main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (isFactor 5 20)
    in
    -- Ignore the line below
    Html.text ""