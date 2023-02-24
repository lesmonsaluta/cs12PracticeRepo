module PracProbs.Prac11 exposing (..)

    
import Html
import Array exposing (get)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)

onlyGreaterThan3 : List Int -> List Int
onlyGreaterThan3 listOfNumbers =
    let
        greaterThan3 : Int -> Bool
        greaterThan3 number =
            number > 3
    in
    List.filter greaterThan3 listOfNumbers

main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (onlyGreaterThan3 [4,4,4,4,4])
    in
    -- Ignore the line below
    Html.text ""
    