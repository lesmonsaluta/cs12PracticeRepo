module LabOutputs.Lab05 exposing (..)
import Html exposing (..)

insertSquares : List Int -> List Int
insertSquares lst =
    case lst of
    [] ->
        []
    
    head :: tail ->
        head :: head * head :: insertSquares tail

mapWithIndex : (Int -> a -> b) -> List a -> List b
mapWithIndex func lst =
    case lst of
    [] ->
        []
    
    head :: tail ->
        (func head head) :: tail



main =
    let
        -- Change the text inside the parentheses with a call to your function
        -- _ = Debug.log "" (insertSquares [10,20,30])
        _ = Debug.log "" (insertSquares [10,20,30])


    in
    -- Ignore the line below
    Html.text ""