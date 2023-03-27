module LabOutputs.Lab04 exposing (..)


import Html exposing (..)
import Html.Attributes exposing (style)


dropNothings : List (Maybe a) -> List a
dropNothings lst =
    let
        -- define reducer (Element -> Bool, Prev -> Updated Acc (ans, index))
        reducer : Maybe a -> List a -> List a
        reducer elem acc =
            case elem of 
                Just x->
                    acc ++ [x]
                        
                Nothing ->
                    acc
                    

        -- extract answer
        -- reducer, initial answer, list to fold on
        final = List.foldl reducer [] lst
        
    in
    final
    


-- define fold
isArithmeticSequence : Int -> List Int -> Bool
isArithmeticSequence d lst  =
    let
        -- define reducer (Element -> Bool, Prev -> Updated Acc (ans, index))
        reducer : Int -> (Bool, Maybe Int) -> (Bool, Maybe Int)
        reducer elem acc =
            let
                (answer, prev) = acc
            in
            case prev of 
                Just x->
                    if elem - x == d then
                        (answer, Just elem)
                    else
                        (False, Just elem)
                        
                Nothing ->
                    (answer, Just elem)

        -- extract answer
        -- reducer, initial answer, list to fold on
        (final, _) = List.foldl reducer (True, Nothing) lst
        
    in
    final
    
    
unpairAtMost : Int -> List (a,a) -> List a
unpairAtMost range lst =
    let
        -- define reducer (Element -> Bool, Prev -> Updated Acc (ans, index))
        reducer : (a,a) -> (List a, Int) -> (List a, Int)
        reducer (x,y) acc =
            let
                (answer, idx) = acc
            in
            if idx == range then
                (answer, idx)
            else
                (answer ++ [x,y], idx+1)

        -- extract answer
        -- reducer, initial answer, list to fold on
        (final, _) = List.foldl reducer ([], 0) lst
        
    in
    final
    
    pairAtMost : Int -> List a -> List (a,a)
pairAtMost range lst =
    let
        -- define reducer (Element -> Acc -> Updated Acc (ans, index))
        reducer : a -> (List (a,a), Int, Maybe a) -> (List (a,a), Int, Maybe a)
        reducer elem acc =
            let
                (answer, idx, prev) = acc
            in
            if idx == range then
                (answer, idx, Nothing)
            else
                case prev of
                    Just x ->
                        (answer ++ [(x, elem)], idx+1, Nothing)
                    Nothing ->
                        (answer, idx, Just elem)
                    

        -- extract answer
        -- reducer, initial answer, list to fold on
        (final, _, _) = List.foldl reducer ([], 0, Nothing) lst
        
    in
    final


    

main =
    -- pre [ style "padding" "10px" ] [text <| Debug.toString <| (dropNothings [Just 1])]
    -- pre [ style "padding" "10px" ] [text <| Debug.toString <| (isArithmeticSequence 1 [2,1,0,-1,-2])]
    xpre [ style "padding" "10px" ] [text <| Debug.toString <| (unpairAtMost 1 [(10,20),(30,40),(50,60)])]
    -- pre [ style "padding" "10px" ] [text <| Debug.toString <| (pairAtMost 2 [10,20,30,40,50,60])]

        
        
        
