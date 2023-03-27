module PracProbs.Lab03171 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)

-- define fold
getAdjacentPairs : List a -> List (a, a)
getAdjacentPairs lst  =
    let
        -- define reducer (Element -> Acc (ans, index) -> Updated Acc (ans, index))
        reducer : a -> (List (a, a), Maybe a) -> (List (a, a), Maybe a)
        reducer elem acc =
            let
                (answer, prev) = acc
            in
            case prev of
                Just x ->
                    (answer ++ [(x, elem)], Just elem)
                Nothing ->
                    ([], Just elem)
        
        -- extract answer
        -- reducer, initial answer, list to fold on
        (final, _) = List.foldl reducer ([], Nothing) lst
        
    in
    final
    
    
    
    

main =
    pre [ style "padding" "10px" ] [text <| Debug.toString <| (getAdjacentPairs ["t","i","t","e"])]
        
        
        