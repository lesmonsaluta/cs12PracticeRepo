module LabOutputs.Lab01 exposing (..)

import Html
import Set
import Array
import Json.Decode exposing (int)  

import Html exposing (pre, text)
import Html.Attributes exposing (style)


-- tally : String -> Dict String Int
-- tally str =





relativelyPrime : Int -> Int -> Bool
relativelyPrime lower higher =
    let
        --funcs here
        listOfFactors : Int -> List Int
        listOfFactors number =
            let
                isFactor : Int  -> Bool
                isFactor inlist =
                    modBy inlist number == 0
                out =
                    List.range 2 number
                    |> List.filter isFactor
                    
            in
            out
            
        --main code here
        combinedList = 
            Set.intersect (Set.fromList (listOfFactors lower)) (Set.fromList (listOfFactors higher))        
    in
    -- higherListPrime
    Set.isEmpty combinedList    
    
-- nestedLoopIndexes : (Int, Int) -> (Int, Int) -> List (Int, Int)
-- nestedLoopIndexes (outerStart, outerEnd) (innerStart, innerEnd) =
--     let
--         makePair : Int -> Int -> (Int, Int)
--         makePair left right =
--             (left, right)
--         firstRange = List.range outerStart outerEnd
--         secondRange = List.range innerStart innerEnd
--     in
--     firstRange
--     |> List.map



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
    pre [ style "padding" "10px" ] [text (hourglass 4)]