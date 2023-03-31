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
            if idx < range then
                (answer ++ [x,y], idx+1)
            else
                (answer, idx)

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
            if idx < range then
                case prev of
                        Just x ->
                            (answer ++ [(x, elem)], idx+1, Nothing)
                        Nothing ->
                            (answer, idx, Just elem)
                
            else
                (answer, idx, Nothing)
                    

        -- extract answer
        -- reducer, initial answer, list to fold on
        (final, _, _) = List.foldl reducer ([], 0, Nothing) lst
        
    in
    final

nestedLoop : (a -> b -> c) -> List a -> List b -> List c
nestedLoop func outerList innerList =
    let 
        outerReducer : a -> List c -> List c
        outerReducer outerElem outerAcc =
            let
                innerReducer : b -> List c -> List c
                innerReducer innerElem innerAcc =
                    [func outerElem innerElem] ++ innerAcc
            in
            List.foldr innerReducer [] innerList ++ outerAcc -- concatenate innerAcc with outerAcc
    in
    List.foldr outerReducer [] outerList


    
    
    
    
main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "dropNothings" (dropNothings [])
        _ = Debug.log "dropNothings" (dropNothings [Nothing])
        _ = Debug.log "dropNothings" (dropNothings [Just 1])
        _ = Debug.log "dropNothings" (dropNothings [Nothing, Just 5, Nothing, Just 4, Nothing])
        _ = Debug.log "isArithmeticSequence" (isArithmeticSequence 3 [])
        _ = Debug.log "isArithmeticSequence" (isArithmeticSequence 1 [1,2,3,4,5])
        _ = Debug.log "isArithmeticSequence" (isArithmeticSequence 2 [1,2,3,4,5])
        _ = Debug.log "isArithmeticSequence" (isArithmeticSequence -1 [2,1,0,-1,-2])
        _ = Debug.log "isArithmeticSequence" (isArithmeticSequence 1 [2,1,0,-1,-2])
        _ = Debug.log "unpairAtMost" (unpairAtMost 0 [])
        _ = Debug.log "unpairAtMost" (unpairAtMost 5 [])
        _ = Debug.log "unpairAtMost" (unpairAtMost -1 [])
        _ = Debug.log "unpairAtMost" (unpairAtMost 2 [(10,20),(30,40)])
        _ = Debug.log "unpairAtMost" (unpairAtMost 2 [(10,20),(30,40),(50,60)])
        _ = Debug.log "unpairAtMost" (unpairAtMost 4 [(10,20),(30,40),(50,60)])
        _ = Debug.log "unpairAtMost" (unpairAtMost -1 [(10,20),(30,40),(50,60)])
        _ = Debug.log "pairAtMost" (pairAtMost 2 [])
        _ = Debug.log "pairAtMost" (pairAtMost 0 [10,20,30,40])
        _ = Debug.log "pairAtMost" (pairAtMost -1 [10,20,30,40])
        _ = Debug.log "pairAtMost" (pairAtMost 2 [10,20,30,40])
        _ = Debug.log "pairAtMost" (pairAtMost 1 [10,20,30,40])
        _ = Debug.log "pairAtMost" (pairAtMost 2 [10,20,30])
        _ = Debug.log "nestedLoop" (nestedLoop Tuple.pair [] [])
        _ = Debug.log "nestedLoop" (nestedLoop Tuple.pair [1,2,3] [])
        _ = Debug.log "nestedLoop" (nestedLoop Tuple.pair [] [1,2,3])
        _ = Debug.log "nestedLoop" (nestedLoop Tuple.pair [1] [1])
        _ = Debug.log "nestedLoop" (nestedLoop Tuple.pair [1,2] [10])
        _ = Debug.log "nestedLoop" (nestedLoop Tuple.pair [10] [1,2])
        _ = Debug.log "nestedLoop" (nestedLoop Tuple.pair [1,2] [10,20])
        _ = Debug.log "nestedLoop" (nestedLoop Tuple.pair [1,2] ["a","b"])
        _ = Debug.log "nestedLoop" (nestedLoop Tuple.pair [1,2] [10,20,30])
        _ = Debug.log "nestedLoop" (nestedLoop (\x y -> x + y) [1,2] [10,20,30])
        _ = Debug.log "nestedLoop   " (nestedLoop (\x y -> x ++ y) ["a","b"] ["1","2","3"])
    in
    -- Ignore the line below
    Html.text ""

        
        
        
