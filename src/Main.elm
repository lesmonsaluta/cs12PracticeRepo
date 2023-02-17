module Main exposing (..)
import Html exposing (text)

add : Int -> Int -> Int
add numOne numTwo = 
    numOne + numTwo
    
plusOne : Int -> Int 
plusOne base =
    base + 1
    
bothFuncs input = 
    input 
    |> plusOne
    |> add 6
    
main =
    bothFuncs 69
    |> Debug.toString 
    |> text
