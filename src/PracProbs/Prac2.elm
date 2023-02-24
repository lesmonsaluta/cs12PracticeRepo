module PracProbs.Prac2 exposing (..)

import Html
import Array exposing (get)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)


echo : String -> String
echo str = str 

main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (echo "hello world")
    in
    -- Ignore the line below
    Html.text ""