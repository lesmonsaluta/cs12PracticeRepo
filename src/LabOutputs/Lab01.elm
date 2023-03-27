odule LabOutputs.Lab01 exposing (tally, relativelyPrime, nestedLoopIndexes, hourglass)

import Html
import Set exposing (..)
import Array
import Dict exposing (..)

import Html exposing (pre, text)
import Html.Attributes exposing (style)

tally : String -> Dict String Int
tally word = 
    let
        --main letters
        letters = String.split "" word
        
        --getting letters that appeared at least once
        filteredLetters = 
            letters
            |>Set.fromList
            |>Set.toList

        countOfALetter : String -> Int
        countOfALetter letter =
            let
                isSelectedLetter : String -> Bool
                isSelectedLetter character =
                    if letter == character then 
                        True 
                    else 
                        False
            
            in
            List.filter isSelectedLetter letters
            |>List.length
        pairs : String -> (String, Int)
        pairs character =
            (character, countOfALetter character)
    in
        List.map pairs filteredLetters
        |> Dict.fromList
    
relativelyPrime : Int -> Int -> Bool
relativelyPrime lower upper =
    let
        listOfFactors : Int -> List Int
        listOfFactors number =
            let
                isFactor : Int  -> Bool
                isFactor inlist =
                    modBy inlist number == 0
                factoredList =
                    List.range 2 number
                    |> List.filter isFactor
                    
            in
            factoredList
        intersectedList = Set.intersect (Set.fromList (listOfFactors lower)) (Set.fromList (listOfFactors upper))        
    in
    Set.isEmpty intersectedList
    
nestedLoopIndexes : (Int, Int) -> (Int, Int) -> List (Int, Int)
nestedLoopIndexes (outerStart, outerEnd) (innerStart, innerEnd) =
    List.range outerStart outerEnd
    |> List.map (\i -> List.range innerStart innerEnd |> List.map (\j -> (i, j)))
    |> List.concat



hourglass : Int -> String
hourglass rows =
    let
        nums = List.range 1 (2 * rows + 1)
        intToCharRows : Int -> String
        intToCharRows row =
            if row == 1 || row == (2 * rows + 1) then
                "o" ++ String.repeat (2 * rows - 1) "-" ++ "o"
            else if row == rows+1 then
                String.repeat rows " " ++ "x"
            else
                if row < rows+1 then
                String.repeat (row-1) " " ++ "\\" ++ String.repeat (2 * rows - 2 * row + 1) " " ++ "/"
                else
                String.repeat (2 * rows - row + 1) " " ++ "/" ++ String.repeat ((row - rows) * 2 - 3) "." ++ "\\"
        
        textRows = List.map intToCharRows nums
        answer = String.join "\n" textRows
        
    in
    answer
    
main =
    -- pre [ style "padding" "10px" ] [text (Debug.toString(tally "a !!1"))]
    -- pre [ style "padding" "10px" ] [text (hourglass 4)]
    
    let
        -- Change the text inside the parentheses with a call to your function
        -- _ = Debug.log "" (nestedLoopIndexes (1,5) (10,11))
        _ = Debug.log "" (relativelyPrime 11 13)
    in
    -- -- Ignore the line below
    -- Html.text ""