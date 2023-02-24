module LabOutputs.Lab01 exposing (..)

import Html
import Set
import Array
import Json.Decode exposing (int)    


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
        edge : Int -> String
        edge rowNum =
            if rowNum == 1 then
                "o"
            else if rowNum == (2 * rows - 1) then
                "o"
            else
                "-"
        
        
        range = List.range 1 rows
    
    in
    range
    |> Debug.toString
    

main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (hourglass 3)
    in
    -- Ignore the line below
    Html.text ""