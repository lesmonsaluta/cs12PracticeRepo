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
mapWithIndex func origElems =
    let
        helper : List a -> Int -> List b
        helper elems acc =
            case elems of
                [] -> 
                    []
                head :: tail ->
                    func acc head :: helper tail (acc+1)
                
    in
    helper origElems 0
    
removeVowels : String -> String
removeVowels sentence =
    case (String.uncons sentence) of
        Just (stringHead, stringTail) ->
            let
                vowels = ['a', 'e', 'i', 'o', 'u']
                member : Char -> List Char -> Bool
                member elem lst =
                    case lst of
                        [] ->
                            False
                        head :: tail ->
                            (head == elem) || member elem tail
            in
            if member stringHead vowels then
                removeVowels stringTail
            else 
                String.fromChar stringHead ++ removeVowels stringTail
                
            
        Nothing -> 
            ""




main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (insertSquares [10,20,30])
        _ = Debug.log "insertSquares" (insertSquares [10,20,30])
        _ = Debug.log "mapWithIndex" (mapWithIndex Tuple.pair ['a','b','c']) --== [(0,'a'),(1,'b'),(2,'b')]
        _ = Debug.log "mapWithIndex" (mapWithIndex (\idx x -> idx * x) [10,20,30]) --== [(0,'a'),(1,'b'),(2,'b')]
        _ = Debug.log "removeVowels" (removeVowels "tit")
    in
    -- Ignore the line below
    Html.text ""