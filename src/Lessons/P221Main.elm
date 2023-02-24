module Practice.P221Main exposing (..)

import Html exposing (pre, text)
import Html.Attributes exposing (style)

--function
add : Int -> Int -> Int
add a b =
    a + b
    

triangle n =
    let
        nums = List.range 1 n
        numToAsterisks : Int -> String
        numToAsterisks rowNum  = 
            if n == 1 then
                "o"
            else
                if rowNum == 1 then
                    "o" ++ String.repeat(n-rowNum-1) "*" ++ "o"
                else if rowNum == n then
                    "o  "
                else
                    String.repeat (n-rowNum+1) "*"
        asterisks = List.map numToAsterisks nums
        answer = String.join "\n" asterisks

    in
    answer

--main
main =
    pre [ style "padding" "10px" ] [text (triangle 50)]