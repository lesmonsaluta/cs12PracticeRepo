module Practice.P217Factorial exposing (..)

import Html exposing (pre, text)
import Html.Attributes exposing (style)

--func
factorial : Int -> Int
factorial num =
    let
        numList = List.range 1 num
        answer = List.product numList
    in
    answer
    
    
output : String
output =
    --function, inputs
    factorial 6
    
    --format to string
    |> Debug.toString  -- Comment `Debug.toString` out if returned value is already a string


main =
    pre [ style "padding" "10px" ] [ text output ]