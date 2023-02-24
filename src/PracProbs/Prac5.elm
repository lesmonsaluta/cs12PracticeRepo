module PracProbs.Prac5 exposing (..)
    
import Html
import Array exposing (get)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)

addCommas: List String -> String
addCommas strs =
    String.join "," strs
main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (addCommas ["Hello", " world!"])
    in
    -- Ignore the line below
    Html.text ""
    