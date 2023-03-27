module PracProbs.Test0317 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)

-- define fold
member : Int -> List Int -> Bool
member num lst =
    let
        -- define reducer
        reducer : Int -> (Bool, Int) -> (Bool, Int)
        reducer x acc =
            let
                (answer, idx) = acc
            in
            if x == num then
                (True, idx+1)
            else
                (answer, idx+1)
            
        (final, _) = List.foldl reducer (False, 1) lst
        
    in
    final
    -- reducer, initial answer, list to fold on
    
    
    

main =
    pre [ style "padding" "10px" ] [text <| Debug.toString <| (member 10 [10, 20, 30])]
        
        
        