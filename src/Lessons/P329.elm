module Lessons.P329 exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

type FilesystemObject
    = File String
    | Directory String (List FilesystemObject)
   
countFiles : FilesystemObject -> Int
countFiles object =
    case object of
        File _ -> 1
        Directory dirname children -> 
            children
            |> List.map countFiles
            |> List.sum
            


main =
    let
        _ = Debug.log "" (countFiles (Directory "1st" [Directory "Sem1" [File "file1", File "file2"], Directory "Sem2" [File "file3", File "file4", File "file5"]]))

    in
    Html.text ""
