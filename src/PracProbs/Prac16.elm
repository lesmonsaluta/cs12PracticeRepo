module PracProbs.Prac16 exposing (..)

import Html
import Set
import Array
import Set exposing (..)
import Json.Decode exposing (int)
import Bitwise exposing (shiftRightZfBy)

-- Add your functions here (first line for type signature, succeeding lines for function declaration and body)
--commonLetters: String -> String -> Set.Set Char
commonLetters: String -> String -> Set Char
commonLetters str1 str2 =
    let
        isChar : Char -> Bool
        isChar character =
            Char.isAlpha character
        
        strToSameChars : String -> List Char
        strToSameChars str = 
            str
                |> String.toLower
                |> String.toList
                |> List.filter isChar
        str1List = 
            strToSameChars str1

        str2List = 
            strToSameChars str2
    in
    Set.intersect (Set.fromList str1List) (Set.fromList str2List)



main =
    let
        -- Change the text inside the parentheses with a call to your function
        _ = Debug.log "" (commonLetters "" "")
        _ = Debug.log "" (commonLetters "123!@#" "123!@#")
        _ = Debug.log "" (commonLetters "a" "a")
        _ = Debug.log "" (commonLetters "a" "A")
        _ = Debug.log "" (commonLetters "abc" "cba")
        _ = Debug.log "" (commonLetters "ABCD" "BBCCDDEE")
    in
    -- Ignore the line below
    Html.text ""