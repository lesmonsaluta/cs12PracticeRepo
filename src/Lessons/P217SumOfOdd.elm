module Practice.P217SumOfOdd exposing (..)

import Html exposing (pre, text)
import Html.Attributes exposing (style)

--func
isOdd : Int -> Bool
isOdd number =
    (modBy 2 number) /= 0

sumOfOdd : Int -> Int
sumOfOdd num =
    let
        x =
            List.range 1 num
            |> List.filter isOdd 
            |> List.sum 
    in
    x

output : String
output =
    --function, inputs
    sumOfOdd 11
    
    --format to string
    |> Debug.toString  -- Comment `Debug.toString` out if returned value is already a string


main =
    pre [ style "padding" "10px" ] [ text output ]