module PracProbs.Prac3 exposing (..)

import Html
import Array exposing (get)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)


getSign : Int -> String   -- Similar to:
getSign n =               -- char *getSign(int n) {
    if n > 0 then         --     return (n > 0 ? "POSITIVE"
        "POSITIVE"        --             : n < 0 ? "NEGATIVE"
    else if n < 0 then    --             : "ZERO");
        "NEGATIVE"        -- }
    else
        "ZERO"

main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (getSign 12)
    in
    -- Ignore the line below
    Html.text ""