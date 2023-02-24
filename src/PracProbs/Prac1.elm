module PracProbs.Prac1 exposing (..)

import Html
import Array exposing (get)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)


alwaysReturns12 : Int -> Int
alwaysReturns12 n = 12

main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (alwaysReturns12 12)
    in
    -- Ignore the line below
    Html.text ""