module PracProbs.Lab0324 exposing (..)
import Html exposing (..)
import List exposing (tail)

member : a -> List a -> Bool
member elem lst =
    -- cases
    
    case lst of 
        -- empty case, default value
        [] ->
            False
            
        --- head tail, call the func again
        head :: tail ->
            if head == elem then
                True
            else
                member elem tail

-- isAll : a -> List a -> Bool
-- isAll elem lst =
--     case lst of
--         [] ->
--             True
--         head :: tail ->
--             (head == elem) && isAll elem tail

isAll : a -> List a -> Bool
isAll elem lst =
    case lst of
        [] ->
            False
        head :: tail ->
            if head /= elem then
                False
            else 
                case tail of
                [] -> True
                _ -> isAll elem tail

    
main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (isAll 10 [10, 10])
        _ = Debug.log "" (isAll 10 [10, 10, 20])
        _ = Debug.log "" (isAll 10 [])
    in
    -- Ignore the line below
    Html.text ""